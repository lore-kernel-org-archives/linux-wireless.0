Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:40662 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932220Ab0LRV3O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Dec 2010 16:29:14 -0500
Date: Sat, 18 Dec 2010 16:29:13 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Johannes Berg <johannes@sipsolutions.net>
cc: Ohad Ben-Cohen <ohad@wizery.com>, <linux-wireless@vger.kernel.org>,
	Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
	<linux-mmc@vger.kernel.org>, Ido Yariv <ido@wizery.com>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
In-Reply-To: <1292690407.3653.2.camel@jlt3.sipsolutions.net>
Message-ID: <Pine.LNX.4.44L0.1012181622460.7965-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 18 Dec 2010, Johannes Berg wrote:

> Sounds to me like the difference isn't really in the driver, but the
> core PM subsystem. Why does it care when powering off a device whether
> it's during suspend, or during runtime?

The two operations are quite different.  One involves preparing the
device to have its power removed (when the system goes to sleep), and
the other involves actually reducing the device's power.  (In other
words, system suspend involves telling the driver "The computer is
going to sleep in a moment, so get ready", whereas runtime suspend
involves telling the driver "Your device isn't being used now so feel
free to reduce its power".)  There also are differences with regard to
how wakeup events are signalled.  Obviously there's a great deal of
similarity and overlap, but they are _not_ the same in general.

Now these differences don't matter so much to the PM core, but they
should matter to subsystems and drivers.  The PM core cares just enough 
to know that it has to invoke different callbacks for the different 
operations.

Alan Stern

