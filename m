Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:37880 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757185Ab0LRW57 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Dec 2010 17:57:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
Date: Sat, 18 Dec 2010 23:57:25 +0100
Cc: "Ohad Ben-Cohen" <ohad@wizery.com>,
	"Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
	linux-mmc@vger.kernel.org, Ido Yariv <ido@wizery.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <Pine.LNX.4.44L0.1012181629350.7965-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1012181629350.7965-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012182357.25687.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday, December 18, 2010, Alan Stern wrote:
> On Sat, 18 Dec 2010, Ohad Ben-Cohen wrote:
> 
> > > Sounds to me like the difference isn't really in the driver, but the
> > > core PM subsystem. Why does it care when powering off a device whether
> > > it's during suspend, or during runtime?
> > 
> > Agree.
> > 
> > If we can add a dev_pm_info bit, that would allow using runtime PM API
> > during suspend/resume transitions, the driver will not have to care.
> > 
> > Rafael what do you think ? Is that totally unacceptable ?
> 
> Have you forgotten about the "echo on >.../power/control" scenario?

Well, that change would basically require the runtime PM framework to ignore
the usage count for this particular device, which would defeat the framework's
purpose to some extent, but it would cover the "echo on > ..." case.

However, I'm not going to agree to make that change.

Thanks,
Rafael
