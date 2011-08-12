Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55516 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab1HLMfh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 08:35:37 -0400
Subject: Re: [PATCH 4/4] mac80211: Add HT operation modes for IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Simon <alexander.simon@saxnet.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1312990268.3128.22.camel@alex-2> (sfid-20110810_173144_123158_1479ED2B)
References: <1888623.Vt5VZUN2cU@alex-1>  <3091493.N5vzNRrbMZ@alex-1>
	 (sfid-20110808_141034_452490_4BA26D5D)  <1312985033.4325.19.camel@jlt3.sipsolutions.net>
	 <1312990268.3128.22.camel@alex-2> (sfid-20110810_173144_123158_1479ED2B)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Aug 2011 14:35:36 +0200
Message-ID: <1313152536.4022.9.camel@jlt3.sipsolutions.net> (sfid-20110812_143539_782518_AE9D194A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-08-10 at 17:31 +0200, Alexander Simon wrote:

> In short: The HT parameter shall behave similar to the frequency:
> Non-fixed mode: Only used when starting an IBSS or starting HT in an
> non-IBSS.
> Fixed mode: Only join when HT modes match.

Ok, that makes sense. So you need the get_bss_ht() only for fixed mode I
guess.

> This should answer your last questions:
> When not fixed, the BSSID configuration always is preferred. Thus, we
> would join as HT40 even though not requested.
> So, when we requsted HT40-, but the IBSS is HT40+, we would work on -.

? I think I know what you mean but your example seems .. the wrong way
around?

> I wanted to have the opportunity to start HT on an existing IBSS.

Well that should always be OK?

> The problem is that legacy station may "kill" the HT configuration:
> If STA A starts in HT IBSS and lets say Windows STA B joins, B would
> advertise that IBSS as non-HT as it ignores our HT IE.
> Then, if STA A dies and STA C joins, it will be non-HT.

mac80211 is STA C? Would it be a problem to use HT if the IBSS was
previously non-HT? The old members will ignore it, but other new HT
members may work OK? IOW -- is it not possible to have a mixed HT/non-HT
IBSS?

> No, pretty sure not. We *are* already joined. That means the TSFs of all
> stations *within* our BSSID match. TSFs can only tell whitch BSSID is
> older...
> So there is no way to distinguish which station first joined.
> Or am i wrong? That would be good in that case :)

Oh, no, you're right of course.

johannes


