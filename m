Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:57795 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751479AbbBYOxX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 09:53:23 -0500
Date: Wed, 25 Feb 2015 16:53:19 +0200
From: Jouni Malinen <j@w1.fi>
To: Thomas =?utf-8?B?SMO8aG4=?= <thomas@net.t-labs.tu-berlin.de>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Andrew McGregor <andrewmcgr@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [ath9k-devel] AR9462 problems connecting again..
Message-ID: <20150225145319.GA7006@w1.fi> (sfid-20150225_155327_218225_23A767D6)
References: <CA+55aFyNqdNk5aq17YdqTCjiWpZ9=ifF3ii+Ko=EzUWZgnCGoQ@mail.gmail.com>
 <CAJ-Vmo=Tu9vBgm2xwqHWqXhx6df9h5cff5_ivERShJ9QPdwYww@mail.gmail.com>
 <20150223224305.GA30228@w1.fi>
 <21739.50662.902775.901924@gargle.gargle.HOWL>
 <CAA_e5Z4zuDMS+CJvFbw4F5M9OZxgS-NZzL2E3d3GSvpRr_TbQw@mail.gmail.com>
 <CAA_e5Z5PqfcYss9fADFewBTgnxrYMy5U6XbRz-J5doEyKgugTg@mail.gmail.com>
 <20150224102611.GA30806@w1.fi>
 <80AA1103-EBCD-4C18-A950-B03FF516E5AC@net.t-labs.tu-berlin.de>
 <20150224181454.GA30859@w1.fi>
 <655DCF68-95EE-47F6-82D3-45F6E0999161@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <655DCF68-95EE-47F6-82D3-45F6E0999161@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 24, 2015 at 11:38:02PM +0100, Thomas Hühn wrote:
> Minstrel_HT does only set mrr[0..2] and does not touch the fourth mrr[3], assumed chips with 4 mrr stages.
> In function minstrel_ht_update_rates() the rate table struct ieee80211_sta_rates is set for the first 3 out of 4 rates and the fouth rate (mrr[3]) is „-1“.

Agreed.

> In case of ath9k, the driver in xmit.c allocates in function ath_tx_fill_desc() a  struct ath_tx_info info by  memset(&info, 0, sizeof(info)) .. so all info->rates[xy].Rate == 0.
> Than function ath_buf_set_rate() sets all info->rates[xy].Rate to those values specified in the rate table (struct ieee8021_sta_rate) IF (!rates[i].count || (rates[i].idx < 0)) …
> … so info->rates[3].Rate is untouched and still  „0“.

Sure, it can be 0 and so is the number of tries at that rate..

> I just added a printk() to xmit.c in function ath_tx_fill_desc() just before ath9k_hw_set_txdesc() is called.
> From the log I get, e.g.:
> 
> [  169.543554] mrr setup: mrr[0]:133 mrr[1]:132 mrr[2]:134 mrr[3]:0 
> 
> I have not check yet if info->rates[3].Rate == 0 is the lowest possible rate… but I would guess so.

It is not and even if it were, it does not matter since this 4th item is
used for _0_ tries. I've verified the exact behavior with a sniffer for
a case where the target device does not ACK frames. ath9k ends up
sending at exactly the three different rates indicated in the first
three values and nothing else. With RC probing (which happens to occur
for the initial EAPOL frames, this results in only one attempt at
MCS(>0) and two + two attempts at MCS0. No non-MCS rates are tried. As
pointed out previously, this is likely fine for normal data frames, but
not for EAPOL.

-- 
Jouni Malinen                                            PGP id EFC895FA
