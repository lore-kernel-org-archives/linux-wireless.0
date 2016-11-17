Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41996 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750785AbcKQIvH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 03:51:07 -0500
Message-ID: <1479372663.1463.9.camel@sipsolutions.net> (sfid-20161117_095110_737064_34CD76C5)
Subject: Re: [PATCH V3] qtnfmac: announcement of new FullMAC driver for
 Quantenna chipsets
From: Johannes Berg <johannes@sipsolutions.net>
To: IgorMitsyanko <igor.mitsyanko.os@quantenna.com>,
        linux-wireless@vger.kernel.org
Date: Thu, 17 Nov 2016 09:51:03 +0100
In-Reply-To: <c6655668-f433-c784-0098-a94a61874e43@quantenna.com> (sfid-20161116_175111_132947_47E19850)
References: <1478700000-11624-1-git-send-email-igor.mitsyanko.os@quantenna.com>
         <1478700000-11624-2-git-send-email-igor.mitsyanko.os@quantenna.com>
         <1479117120.9766.8.camel@sipsolutions.net>
         <62102ba6-cae0-f00d-f989-3f2e9ea43d9b@quantenna.com>
         <c6655668-f433-c784-0098-a94a61874e43@quantenna.com>
         (sfid-20161116_175111_132947_47E19850)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > > It's probably worth having a discussion about this behaviour
> > > difference - not necessarily in the context of this driver
> > > submission though.
> > 
> > Do you mean that default is to allow to dynamically allocate
> > resources (add_interface) for as much interfaces as memory allows,
> > but only use (allow to open) a limited number of them? 

Correct, this is how mac80211 works.

> > This seems like unnecessary complication, 

Well, I don't really know where this came from. I suspect some types of
mode switching cases could benefit from it, say (completely
constructed) your hardware supports either two AP or two clients, but
not AP+client - then to switch from 2xAP to 2xclient you'd have to
destroy one of the interfaces, since you can't mode-switch both at the
same time.

Also, interfaces that are down (should!) have no runtime impact on the
device whatsoever, so it's just a little bit more software complexity
to handle.

I think there may also be cases of cfg80211 doing partial interface
combination enforcement only on interfaces that are up.

> > I can see only one relevant comment in documentation to "struct
> > ieee80211_iface_combination" that does not clarify what should be
> > the behavior:

Agree, we never thought about it since for mac80211 it was always
obvious, and for other drivers the other way seemed obvious - I only
found out about it after the fact :)


I think the mode-switching I outlined above is a slight advantage to
the mac80211 scheme, so I wouldn't want to switch mac80211 to this
other scheme, risking that being seen as an API/ABI regression.

At the same time, having all drivers behave the same way seems somewhat
useful, but the consequence would be all drivers having to adopt the
mac80211 scheme. I can't say how difficult that would be - might be
more difficult than it seems since you couldn't statically allocate
your interface pointers etc. as you do now.

johannes
