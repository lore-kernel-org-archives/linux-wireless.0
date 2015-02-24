Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:60048 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753006AbbBXWiE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 17:38:04 -0500
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Subject: Re: [ath9k-devel] AR9462 problems connecting again..
From: =?utf-8?Q?Thomas_H=C3=BChn?= <thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <20150224181454.GA30859@w1.fi>
Date: Tue, 24 Feb 2015 23:38:02 +0100
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Andrew McGregor <andrewmcgr@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Kalle Valo <kvalo@codeaurora.org>
Message-Id: <655DCF68-95EE-47F6-82D3-45F6E0999161@net.t-labs.tu-berlin.de> (sfid-20150224_233808_633936_0025BDD0)
References: <CA+55aFz0pAMbtczpe9fe5m9HjTysNVm3639VyNc3hrpkdenSGg@mail.gmail.com> <20150223213050.GA23232@w1.fi> <CA+55aFyNqdNk5aq17YdqTCjiWpZ9=ifF3ii+Ko=EzUWZgnCGoQ@mail.gmail.com> <CAJ-Vmo=Tu9vBgm2xwqHWqXhx6df9h5cff5_ivERShJ9QPdwYww@mail.gmail.com> <20150223224305.GA30228@w1.fi> <21739.50662.902775.901924@gargle.gargle.HOWL> <CAA_e5Z4zuDMS+CJvFbw4F5M9OZxgS-NZzL2E3d3GSvpRr_TbQw@mail.gmail.com> <CAA_e5Z5PqfcYss9fADFewBTgnxrYMy5U6XbRz-J5doEyKgugTg@mail.gmail.com> <20150224102611.GA30806@w1.fi> <80AA1103-EBCD-4C18-A950-B03FF516E5AC@net.t-labs.tu-berlin.de> <20150224181454.GA30859@w1.fi>
To: Jouni Malinen <j@w1.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jouni,

> Where is that mrr[3] part implemented? I did not find it when reviewing
> the design (hw->max_rates >= 3 is used, but not >= 4) and this does not
> match my experiments either when printing out all four values from
> ath9k. In every single case I observed, the last entry was unused (idx =
> -1) and only MCS values were used (i.e., not even a single case of basic
> rate visible; basic rates being 6, 12, 24 Mbps OFDM in this specific
> case with the AP that I used in the tests).

Minstrel_HT does only set mrr[0..2] and does not touch the fourth mrr[3], assumed chips with 4 mrr stages.
In function minstrel_ht_update_rates() the rate table struct ieee80211_sta_rates is set for the first 3 out of 4 rates and the fouth rate (mrr[3]) is „-1“.
In case of ath9k, the driver in xmit.c allocates in function ath_tx_fill_desc() a  struct ath_tx_info info by  memset(&info, 0, sizeof(info)) .. so all info->rates[xy].Rate == 0.
Than function ath_buf_set_rate() sets all info->rates[xy].Rate to those values specified in the rate table (struct ieee8021_sta_rate) IF (!rates[i].count || (rates[i].idx < 0)) …
… so info->rates[3].Rate is untouched and still  „0“.

I just added a printk() to xmit.c in function ath_tx_fill_desc() just before ath9k_hw_set_txdesc() is called.
>From the log I get, e.g.:

[  169.543554] mrr setup: mrr[0]:133 mrr[1]:132 mrr[2]:134 mrr[3]:0 

I have not check yet if info->rates[3].Rate == 0 is the lowest possible rate… but I would guess so.


Greetings Thomas

