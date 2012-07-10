Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39762 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab2GJTjo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 15:39:44 -0400
Message-ID: <1341949184.4475.34.camel@jlt3.sipsolutions.net> (sfid-20120710_213948_088556_7E70C628)
Subject: Re: Can one program see another's scan-results?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 10 Jul 2012 21:39:44 +0200
In-Reply-To: <4FFC82FB.2060301@candelatech.com>
References: <4FFC7C4F.9020804@candelatech.com>
	   (sfid-20120710_210252_194820_A6A69A50) <1341947332.4475.32.camel@jlt3.sipsolutions.net>
	  <4FFC805B.909@candelatech.com>
	 <1341948158.4475.33.camel@jlt3.sipsolutions.net>
	 <4FFC82FB.2060301@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-07-10 at 12:31 -0700, Ben Greear wrote:
> On 07/10/2012 12:22 PM, Johannes Berg wrote:
> > On Tue, 2012-07-10 at 12:19 -0700, Ben Greear wrote:
> >> On 07/10/2012 12:08 PM, Johannes Berg wrote:
> >>> On Tue, 2012-07-10 at 12:02 -0700, Ben Greear wrote:
> >>>> Is there a way to open a netlink socket and have it receive
> >>>> all scan results (even those requested by other applications)?
> >>>
> >>> What do you mean by scan results? The results themselves? No, they are a
> >>> dump and unicast to one application. The fact that a scan finished? Yes,
> >>> of course.
> >>
> >> I'd like the results themselves..for instance, just piggyback on whatever
> >> supplicant is already doing to get periodic updates, and of course I'd
> >> end up requesting some scans myself from time to time if a user wanted
> >> an immediate update.
> >>
> >> I was hoping it could be something like just listening for network-device
> >> and route updates like netlink already supports.
> >>
> >> Since scanning is relatively slow and expensive, it seems like a good
> >> idea to allow re-using the results...
> >
> > Well, umm.. you can just request the results? A la "iw wlan0 scan dump"?
> 
> So, you could listen for the 'scan-complete' netlink message, and then
> when you receive it, immediately go ask for a 'scan dump' for that interface,
> and immediately get the last scan results?

Yes.

> Aside from a small race (what if something else did something to invalidate
> those scan results), that sounds like it might be good enough to me.

There's not much that anything could do to do that.

johannes

