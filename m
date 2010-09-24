Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56465 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab0IXVS5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 17:18:57 -0400
Subject: Re: [wireless] wireless:  Keep phy name consistent across module
 reloads.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <4C9D13AC.4080308@candelatech.com>
References: <1285113431-25526-1-git-send-email-greearb@candelatech.com>
	 <1285362170.11036.1.camel@jlt3.sipsolutions.net>
	 <4C9D13AC.4080308@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Sep 2010 23:18:54 +0200
Message-ID: <1285363135.11036.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-09-24 at 14:10 -0700, Ben Greear wrote:

> > We cannot do this because otherwise operations you attempt to do one one
> > PHY will race with re-creating of the same phy index. For the same
> > reason, interface indexes aren't reused for netdevs.
> >
> > If this bothers you so much, you can easily write a udev rule that
> > renames all your phys to "myphy" or whatever.
> 
> Sorry about that.
> 
> Would a similar patch be acceptable that just set the name to the first
> available phyX, but left the index to increment monotomically as it does
> now be OK?

Actually, right now it doesn't even allow you to use a "phy%d" name,
which is because I don't want (sysfs, debugfs) errors coming from doing
"iw phy0 set name phy1" and then plugging in a new device ... In doing
that, I manage to avoid having to allocate two different numbers...

I suppose it'd be possible to treat this more like interfaces. Want to
also make it per net namespace? ;-)

> I'd really like to not have to deal with udev if possible!

It's really not very hard, you just need a rule that reacts to adding a
new phy, and calls "iw phy#7 set name myphy" :-)

johannes

