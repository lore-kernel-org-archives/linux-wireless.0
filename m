Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:60798 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752646AbbBYUw4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 15:52:56 -0500
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Subject: Re: [ath9k-devel] AR9462 problems connecting again..
From: =?utf-8?Q?Thomas_H=C3=BChn?= <thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <20150225145319.GA7006@w1.fi>
Date: Wed, 25 Feb 2015 21:52:55 +0100
Cc: Andrew McGregor <andrewmcgr@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Kalle Valo <kvalo@codeaurora.org>
Message-Id: <38DE7E62-563E-4CC5-A147-40AB4B01220A@net.t-labs.tu-berlin.de> (sfid-20150225_215302_629861_4D7C57AD)
References: <CA+55aFyNqdNk5aq17YdqTCjiWpZ9=ifF3ii+Ko=EzUWZgnCGoQ@mail.gmail.com> <CAJ-Vmo=Tu9vBgm2xwqHWqXhx6df9h5cff5_ivERShJ9QPdwYww@mail.gmail.com> <20150223224305.GA30228@w1.fi> <21739.50662.902775.901924@gargle.gargle.HOWL> <CAA_e5Z4zuDMS+CJvFbw4F5M9OZxgS-NZzL2E3d3GSvpRr_TbQw@mail.gmail.com> <CAA_e5Z5PqfcYss9fADFewBTgnxrYMy5U6XbRz-J5doEyKgugTg@mail.gmail.com> <20150224102611.GA30806@w1.fi> <80AA1103-EBCD-4C18-A950-B03FF516E5AC@net.t-labs.tu-berlin.de> <20150224181454.GA30859@w1.fi> <655DCF68-95EE-47F6-82D3-45F6E0999161@net.t-labs.tu-berlin.de> <20150225145319.GA7006@w1.fi>
To: Jouni Malinen <j@w1.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jouni,

>> In case of ath9k, the driver in xmit.c allocates in function ath_tx_fill_desc() a  struct ath_tx_info info by  memset(&info, 0, sizeof(info)) .. so all info->rates[xy].Rate == 0.
>> Than function ath_buf_set_rate() sets all info->rates[xy].Rate to those values specified in the rate table (struct ieee8021_sta_rate) IF (!rates[i].count || (rates[i].idx < 0)) …
>> … so info->rates[3].Rate is untouched and still  „0“.
> 
> Sure, it can be 0 and so is the number of tries at that rate..

You are absolutely right … as the tries are 0 as well, the 4th mrr[3] is not used. I missed that obvious point.


>> I just added a printk() to xmit.c in function ath_tx_fill_desc() just before ath9k_hw_set_txdesc() is called.
>> From the log I get, e.g.:
>> 
>> [  169.543554] mrr setup: mrr[0]:133 mrr[1]:132 mrr[2]:134 mrr[3]:0 
>> 
>> I have not check yet if info->rates[3].Rate == 0 is the lowest possible rate… but I would guess so.
> 
> It is not and even if it were, it does not matter since this 4th item is
> used for _0_ tries. I've verified the exact behavior with a sniffer for
> a case where the target device does not ACK frames. ath9k ends up
> sending at exactly the three different rates indicated in the first
> three values and nothing else. With RC probing (which happens to occur
> for the initial EAPOL frames, this results in only one attempt at
> MCS(>0) and two + two attempts at MCS0. No non-MCS rates are tried. As
> pointed out previously, this is likely fine for normal data frames, but
> not for EAPOL.

I do agree in changing the way to assign a (mrr) rate set for  EAPOL frames in the most robust fashion.

Greetings Thomas


> 
> -- 
> Jouni Malinen                                            PGP id EFC895FA
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel

