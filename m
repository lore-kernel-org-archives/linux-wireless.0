Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:60637 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837Ab0L1TWf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 14:22:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Ohad Ben-Cohen" <ohad@wizery.com>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
Date: Tue, 28 Dec 2010 20:21:31 +0100
Cc: Alan Stern <stern@rowland.harvard.edu>,
	linux-pm@lists.linux-foundation.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	Ido Yariv <ido@wizery.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
References: <AANLkTimj0E3Rz_8WQrU4wGg3ONyXzkUT9+U3Xqz7Cq0X@mail.gmail.com> <201012261935.13238.rjw@sisk.pl> <AANLkTimHHN+GesyhR6Jjnm771XLhn=inn=vrSk=mT6Mh@mail.gmail.com>
In-Reply-To: <AANLkTimHHN+GesyhR6Jjnm771XLhn=inn=vrSk=mT6Mh@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012282021.31695.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, December 28, 2010, Ohad Ben-Cohen wrote:
> On Sun, Dec 26, 2010 at 8:35 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Sunday, December 26, 2010, Ohad Ben-Cohen wrote:
> >> On Sun, Dec 26, 2010 at 1:45 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > Why does the driver need the device to be reset even though it hasn't
> >> > been suspeneded yet?
> >>
> >> Because it is asked to stop the hardware by mac80211.
> >
> > So I guess the mac80211 layer should ask it to start it again.
> 
> It does...
> 
> And at this point the driver will try to boot a new firmware, but it
> will only succeed if the device was indeed powered off. If it wasn't
> (system suspend was cancelled before the host controller  suspended),
> the driver will fail to resume the device (because it can't reset it).

It looks like you could simply do a power down-power up cycle before trying to
load new firmware, just in case.  I guess that's suboptimal for some reason?

> We can change man80211 to let us know the system is suspending, and
> then we will power down the device directly. Or we can use something
> like your "runtime only" proposal, and then pm_runtime_put_sync() will
> just work for us regardless of the system state.

The pm_runtime_put_sync() is irrelevant at this point IMHO.  First, we should
figure out what needs to be done at the low level and _then_ think how to
code it.  From that we'll learn if you _really_ need anything new from the PM
core, but quite frankly I seriously doubt it right now.

> But that will not solve the /sys/devices/.../power/control problem.
> For that we will either have always to bypass runtime PM, or introduce
> something like "always auto"...

Please pretend that the runtime PM framework doesn't exist for a while.  How
would you design things in that case?

Rafael
