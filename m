Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:35470 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932656AbeGFL5k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jul 2018 07:57:40 -0400
Message-ID: <1530878256.3197.22.camel@sipsolutions.net> (sfid-20180706_135757_718819_5B1ECBC1)
Subject: Re: [PATCH] cfg80211: use IDA to allocate wiphy indeces
From: Johannes Berg <johannes@sipsolutions.net>
To: Brian Norris <briannorris@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Ben Greear <greearb@candelatech.com>
Date: Fri, 06 Jul 2018 13:57:36 +0200
In-Reply-To: <20180629184847.GA251207@ban.mtv.corp.google.com> (sfid-20180629_204855_940396_8E40A470)
References: <20180621012945.185705-1-briannorris@chromium.org>
         <1530258140.3481.4.camel@sipsolutions.net>
         <20180629184847.GA251207@ban.mtv.corp.google.com>
         (sfid-20180629_204855_940396_8E40A470)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brian,

> > Imagine you have some userspace process running that has remembered the
> > wiphy index to use it to talk to nl80211, and now underneath the device
> > goes away and reappears. This process should understand that situation,
> > and handle it accordingly, rather than being blind to the reset.
> 
> How is this different from the wlan (netdev) device naming? We allow
> 'wlan0' to leave and return under the same name. Isn't the right answer
> that user space should be listening for udev and/or netlink events?

Well, first of all - for netdev *naming* these things differ in that
even if you get "wlan0" back, it will in fact have a new interface index
which hasn't been used before. So tools that are not aware of changes
since they don't listen will (hopefully) look up the interface index by
name once, and then keep using that, and then get failures on the
renames.

This doesn't even have to be all that long-running btw, it could be you
enter "iw wlan0 scan" and somewhere between looking up the wlan0
interface index and actually trying to do an operation on it your hw
crashes and the interface goes way. Or similar.

Now, with phy0 there's an additional limitation in that we made it so
you could only use "phyX" for X == phy index. This wasn't there
originally, and technically isn't really needed, but there are
races/issues with this.

In commit 7623225f90526, which really is a revert of Ben's patch that
always used the lowest number for the phy *name*. It looks like after I
had to revert that patch, Ben decided to just name them "wiphyX" with a
low number X in userspace, which is obviously fine.

I think the way to satisfy all of the different concerns around this
would be to track - separately - which phyX *names* (are going to) exist
in the system. As commit 7623225f90526 pointed out:

    This reverts commit 5a254ffe3ffdfa84fe076009bd8e88da412180d2.
    
    The commit failed to take into account that allocated wireless devices
    (wiphys) are not added into the device list upon allocation, but only
    when they are registered. Therefore, it opened up a race between
    allocating and registering a name, so that if two processes allocate and
    register concurrently ("alloc, alloc, register, register" rather than
    "alloc, register, alloc, register") the code will attempt to use the
    same name twice.


The IDA code you wrote avoids this situation because you add the wiphy
index to the IDA data structure on *allocation*, vs. relying just on the
regular rdev list like in Ben's commit.

So, to address my concerns about not reusing the number, I think we
could just decouple the phyX from the wiphy index X (iw has some magic
"phy#x" to use the actual wiphy index if you need to).

Then we can use the IDA to track the allocated *names*, and keep the
actual underlying *index* the same as today - similar to what you
observe with netdevs, e.g. wlan0.

The only complexity is that you have to track this when wiphys are being
renamed, both on renaming away from "phyX" (to free the name index X),
but also on renaming *to* "phyX" to reserve the name index X and fail
the rename if it's already reserved even though the name doesn't show up
on the output of "iw list" yet because it's not registered yet.

johannes
