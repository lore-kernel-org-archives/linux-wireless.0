Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56978 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbaF0HpO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2014 03:45:14 -0400
Message-ID: <1403855097.5610.1.camel@jlt4.sipsolutions.net> (sfid-20140627_094518_195755_45E2CCF6)
Subject: Re: Can we make ieee80211_iface_combination.limits non-const?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 27 Jun 2014 09:44:57 +0200
In-Reply-To: <53AC814C.9040201@candelatech.com>
References: <53AC6454.5090605@candelatech.com>
	  (sfid-20140626_202012_477893_089B637F) <1403813187.4463.1.camel@jlt4.sipsolutions.net>
	 <53AC814C.9040201@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-06-26 at 13:23 -0700, Ben Greear wrote:
> On 06/26/2014 01:06 PM, Johannes Berg wrote:
> > On Thu, 2014-06-26 at 11:20 -0700, Ben Greear wrote:
> >> Depending on firmware loaded (and/or module options), a different
> >> number of vdev interfaces may be supported.
> >>
> >> Can we remove the const from the "struct ieee80211_iface_limit *limits"
> >> member of ieee80211_iface_combination?
> > 
> > No, it would break drivers who actually have a static const for the
> > pointer target.
> 
> That could be easily fixed, eh?

Yeah but it'd be stupid :)

> > You don't have to assign something that's const, but you also can't be
> > changing it on the fly after wiphy registration anyway.
> 
> This would be done before registration.  I like static init
> for defaults, but wanted to poke a few variables at run-time
> based on firmware, etc.

I don't really get it anyway. If you're going to do anything dynamic,
you don't want to be changing a global static value anyway. You want to
be making a copy or so and building it in a dynamic data structure, and
then point to it.

johannes

