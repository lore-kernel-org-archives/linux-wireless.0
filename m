Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:51638 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbZAEP0E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 10:26:04 -0500
Message-ID: <49622686.9050005@openwrt.org> (sfid-20090105_162607_283877_88BCA52F)
Date: Mon, 05 Jan 2009 16:25:58 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: rate instability in wireless stack
References: <20090104174123.GW496@one.firstfloor.org> <49615465.4090604@lwfinger.net> <20090105025302.GF496@one.firstfloor.org> <49618497.50809@lwfinger.net> <20090105050248.GG496@one.firstfloor.org> <496193A6.3040608@lwfinger.net> <20090105054830.GJ496@one.firstfloor.org> <49620BE5.9030507@openwrt.org> <20090105142343.GS496@one.firstfloor.org> <49621C36.70602@openwrt.org> <20090105152410.GT496@one.firstfloor.org>
In-Reply-To: <20090105152410.GT496@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andi Kleen wrote:
>> Probably the RT2561 and the RTL8180 simply have a lower Tx power and
>> thus can't get the signal through the walls as easily as the zd1211rw.
> 
> That surprises me because I use a real antenna on them which the zd1211rw
> is just itself. Also some laptops with Intel wireless have no trouble
> talking through the walls at full rate when I put them on the same position.
> 
> Hmm perhaps I should try to find a Windows box and see if it works
> there. That would rule out hardware issues.
> 
>> If you still think that it's a rate control problem, please try all
> 
> I don't know what it is, i just know that it doesn't work and
> from the evidence I gathered so far it looks like a Linux software
> problem.
> 
>> the rates individually and see if one of them works better.
> 
> Forcing the rates works somewhat, but the link quality is very poor
> (10-15/100) and fluctuates.
Another possibility is that the tx power is fine, but the
sensitivity of the card is crap, so the packets actually make it,
but the ACKs don't. This is something that's quite hard to detect in
a rate control module that relies on ACKs as the only available
source of feedback (not that using RSSI for that would be any
better, but still).

Even if both cards work fine on Windows, I wouldn't assume that this
is an issue with mac80211. The information that was used to write
these two drivers was derived from very poor vendor codebases and
limited information in datasheets, so it's much more likely that
simply the Baseband/RF tuning is far from optimal on both cards.

Maybe we can see more if you provide some minstrel stats after
you've pushed more traffic through the link - 25-50 packets is not
nearly enough for getting an accurate view of how good the link is.
Try to push through a few megabytes of data...

- Felix
