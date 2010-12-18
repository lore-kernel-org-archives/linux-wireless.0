Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:37869 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483Ab0LRWxH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Dec 2010 17:53:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Ohad Ben-Cohen" <ohad@wizery.com>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
Date: Sat, 18 Dec 2010 23:52:10 +0100
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
	linux-mmc@vger.kernel.org, Ido Yariv <ido@wizery.com>,
	linux-wireless@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Johannes Berg <johannes@sipsolutions.net>
References: <AANLkTikJr+0kVPE4aSwPjZWRfA3gRSNgGwzQdSwRpo_5@mail.gmail.com> <1292690407.3653.2.camel@jlt3.sipsolutions.net> <AANLkTin6zdUb2C-3GU-FySb3Pmk5iHaG5neLNSG38Tdx@mail.gmail.com>
In-Reply-To: <AANLkTin6zdUb2C-3GU-FySb3Pmk5iHaG5neLNSG38Tdx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012182352.10765.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday, December 18, 2010, Ohad Ben-Cohen wrote:
> On Sat, Dec 18, 2010 at 6:40 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Sat, 2010-12-18 at 18:00 +0200, Ohad Ben-Cohen wrote:
> >
> >> > That's where the problem is.  If there's a difference, from the driver's
> >> > point of view, between suspend and some other operation, there should be a
> >> > way to tell the driver what case it actually is dealing with.
> >>
> >> Yes, the problem will be solved if the driver would bypass the runtime
> >> PM framework on system suspend. mac80211 obviously has this
> >> information, and technically it's very easy to let the driver know
> >> about it.
> >>
> >> But the difference between suspend and normal operation is really
> >> artificial: in both cases mac80211 just asks the driver to power its
> >> device down, and the end result is exactly the same (a GPIO line of
> >> the device is de-asserted in our case). The difference between these
> >> two scenarios
> >> exist only because runtime PM is effectively disabled during system
> >> suspend, and therefore the driver has to look for an alternative way
> >> to power down the device.
> >
> > Sounds to me like the difference isn't really in the driver, but the
> > core PM subsystem. Why does it care when powering off a device whether
> > it's during suspend, or during runtime?
> 
> Agree.
> 
> If we can add a dev_pm_info bit, that would allow using runtime PM API
> during suspend/resume transitions, the driver will not have to care.
> 
> Rafael what do you think ? Is that totally unacceptable ?

Already said.  It is not acceptable at all.

Thanks,
Rafael
