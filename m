Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:55919 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932231Ab0LRVaT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Dec 2010 16:30:19 -0500
Date: Sat, 18 Dec 2010 16:30:18 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Ohad Ben-Cohen <ohad@wizery.com>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, <linux-mmc@vger.kernel.org>,
	Ido Yariv <ido@wizery.com>, <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
In-Reply-To: <AANLkTin6zdUb2C-3GU-FySb3Pmk5iHaG5neLNSG38Tdx@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1012181629350.7965-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 18 Dec 2010, Ohad Ben-Cohen wrote:

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

Have you forgotten about the "echo on >.../power/control" scenario?

Alan Stern

