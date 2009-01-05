Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:44439 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbZAEQWH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 11:22:07 -0500
Date: Mon, 5 Jan 2009 17:35:53 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Andi Kleen <andi@firstfloor.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: rate instability in wireless stack
Message-ID: <20090105163553.GU496@one.firstfloor.org> (sfid-20090105_172211_516282_20988E83)
References: <20090105025302.GF496@one.firstfloor.org> <49618497.50809@lwfinger.net> <20090105050248.GG496@one.firstfloor.org> <496193A6.3040608@lwfinger.net> <20090105054830.GJ496@one.firstfloor.org> <49620BE5.9030507@openwrt.org> <20090105142343.GS496@one.firstfloor.org> <49621C36.70602@openwrt.org> <20090105152410.GT496@one.firstfloor.org> <49622686.9050005@openwrt.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <49622686.9050005@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 05, 2009 at 04:25:58PM +0100, Felix Fietkau wrote:
> > Forcing the rates works somewhat, but the link quality is very poor
> > (10-15/100) and fluctuates.
> Another possibility is that the tx power is fine, but the
> sensitivity of the card is crap, so the packets actually make it,

Ok, but I see the same thing with two different cards, with different
chipsets (RaLink and RealTek). You think they both have that problem?

> Even if both cards work fine on Windows, I wouldn't assume that this
> is an issue with mac80211. The information that was used to write
> these two drivers was derived from very poor vendor codebases and
> limited information in datasheets, so it's much more likely that
> simply the Baseband/RF tuning is far from optimal on both cards.

Ok I won't try then. Setting up Windows would be quite a lot of
effort and I would prefer to avoid it.

> Maybe we can see more if you provide some minstrel stats after
> you've pushed more traffic through the link - 25-50 packets is not
> nearly enough for getting an accurate view of how good the link is.
> Try to push through a few megabytes of data...

Here are the statistics after a few MB.

rate     throughput  ewma prob   this prob  this succ/attempt   success    attempts
TtP  1         0.9       97.9      100.0          1(  1)      19284       21249
     2         0.0        0.0        0.0          0(  0)          0         101
     5.5       0.0        0.0        0.0          0(  0)          0         104
    11         0.0        0.0        0.0          0(  0)        253         397
     6         0.0        0.0        0.0          0(  0)          0         103
     9         0.0        0.0        0.0          0(  0)          0         106
    12         0.0        0.0        0.0          0(  0)          0         107
    18         0.0        0.0        0.0          0(  0)          0         104
    24         0.0        0.0        0.0          0(  0)          0         111
    36         0.0        0.0        0.0          0(  0)          0         120
    48         0.0        0.0        0.0          0(  0)          0         179
    54         0.0        0.0        0.0          0(  0)          0         253

Total packet count::    ideal 9023      lookaround 474

-Andi
-- 
ak@linux.intel.com
