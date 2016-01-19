Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43744 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbcASL5x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2016 06:57:53 -0500
Message-ID: <1453204670.3896.9.camel@sipsolutions.net> (sfid-20160119_125756_178142_486DBF73)
Subject: Re: Checking p2p capabilities
From: Johannes Berg <johannes@sipsolutions.net>
To: albertofanjul@gmail.com, linux-wireless@vger.kernel.org
Date: Tue, 19 Jan 2016 12:57:50 +0100
In-Reply-To: <20160119113457.GA32060@archlinux-alberto> (sfid-20160119_123521_709483_A29A5BDE)
References: <20160119113457.GA32060@archlinux-alberto>
	 (sfid-20160119_123521_709483_A29A5BDE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-01-19 at 12:34 +0100, albertofanjul@gmail.com wrote:

> Lot of people trying miraclecast ask me:why it's device do not
> support p2p?  (while it's documentation says it does, many times is
> just what they think, not reality).

Well, often the documentation is for the windows or vendor driver, not
for the upstream driver.

> I wonder if that is a matter of driver, modules or pure hardware. Is
> there any way to check it directly and not from a grep inside iw ?.
> 
> something like:
> 
> iw phy wlp3s0 get P2P-client
> iw phy wlp3s0 get P2P-GO

I'm not sure it makes sense to add commands to iw for that, but you can
use python or C code to talk to nl80211 directly.

> About kernel, modules and hardware, are they completely black box for
> others?, I mean, can I detect if my device hardware supports some
> interface but my driver or module can't?

No, you can't detect that.

> At this point my script informs pretty well, and there's a few people
> ask such things, but I would like to check it in a better way, even
> with an api inside my project
> 
> Something related with this lines I could check by myself (I use that
> clone for it's line anchors)
> 
> https://github.com/cozybit/iw/blob/master/util.c#L124
> https://github.com/cozybit/iw/blob/master/info.c#L276
> 
> NL80211_ATTR_SUPPORTED_IFTYPES
> NL80211_IFTYPE_MAX
> 

Right, you'd do something along these lines to directly speak to
nl80211 and query the supported interface types.

johannes
