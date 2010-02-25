Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54048 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933560Ab0BYUAL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 15:00:11 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 25 Feb 2010 12:00:11 -0800
Date: Thu, 25 Feb 2010 12:00:09 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Schilling, Paul" <Paul.Schilling@ecolab.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@Atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Ath9k Call trace from 2.6.33-RC8 - Rate marked as an HT rate
 but passed status->rate_idx is not an MCS index [0-76]: 127 (0x7f)
Message-ID: <20100225200009.GC5265@tux>
References: <599F2DD3D277A34381AA3DA3337F13A102F54E2F@USEAGAN1509P.GLOBAL.ECOLAB.CORP>
 <20100225180634.GB5265@tux>
 <599F2DD3D277A34381AA3DA3337F13A102F54F94@USEAGAN1509P.GLOBAL.ECOLAB.CORP>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <599F2DD3D277A34381AA3DA3337F13A102F54F94@USEAGAN1509P.GLOBAL.ECOLAB.CORP>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 25, 2010 at 11:54:52AM -0800, Schilling, Paul wrote:
> I am currently doing some stability testing right now, so updating the
> kernel to 2.6.33 will happen some time next week.  How recent of a
> kernel would you like me to test against.  Would you like me to test
> against linux-next or mainline.

wireless-testing is great for developers as that is what we work
with. We can only fix something in older stable kernels (2.6.33 is
now old just as 2.6.34 will be in 2 weeks from now) if we first
fix it on wireless-testing so if you use wireless-testing that can
get us to reproduce that as well. That is of course unless this
was a regression from 2.6.32 to 2.6.33 and we magicly fixed it
on 2.6.34.

> Also here is the kernel log for the module.  
> 
> [   12.715169] cfg80211: Calling CRDA to update world regulatory domain
> [   13.177053] cfg80211: World regulatory domain updated:
> [   13.177087]     (start_freq - end_freq @ bandwidth),
> (max_antenna_gain, max_eirp)
> [   13.177117]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi,
> 2000 mBm)
> [   13.177142]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi,
> 2000 mBm)
> [   13.177168]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi,
> 2000 mBm)
> [   13.177194]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi,
> 2000 mBm)
> [   13.177219]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi,
> 2000 mBm)
> [   20.381672] ath: EEPROM regdomain: 0x0
> [   20.381700] ath: EEPROM indicates default country code should be used
> [   20.381718] ath: doing EEPROM country->regdmn map search
> [   20.381744] ath: country maps to regdmn code: 0x3a
> [   20.381763] ath: Country alpha2 being used: US
> [   20.381779] ath: Regpair used: 0x3a
> [   20.507510] phy0: Selected rate control algorithm
> 'ath9k_rate_control'
> [   20.515860] cfg80211: Calling CRDA for country: US
> [   20.518464] Registered led device: ath9k-phy0::radio
> [   20.521167] Registered led device: ath9k-phy0::assoc
> [   20.524295] Registered led device: ath9k-phy0::tx
> [   20.524926] Registered led device: ath9k-phy0::rx
> [   20.524988] phy0: Atheros AR9280 Rev:2 mem=0xe0be0000, irq=6

OK this line was the one I wanted. Thanks.

> [   20.596504] cfg80211: Regulatory domain changed to country: US
> [   20.596539]     (start_freq - end_freq @ bandwidth),
> (max_antenna_gain, max_eirp)
> [   20.596569]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi,
> 2700 mBm)
> [   20.596594]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi,
> 1700 mBm)
> [   20.596620]     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi,
> 2000 mBm)
> [   20.596646]     (5490000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi,
> 2000 mBm)
> [   20.596672]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi,
> 3000 mBm)

> CONFIDENTIALITY NOTICE: 
> This e-mail communication and any attachments may contain proprietary and privileged information for the use of the designated recipients named above. 
> Any unauthorized review, use, disclosure or distribution is prohibited. 
> If you are not the intended recipient, please contact the sender by reply e-mail and destroy all copies of the original message.

This confidentiality notice is bogus as this is a public list.

  Luis
> 
