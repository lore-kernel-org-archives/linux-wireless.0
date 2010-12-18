Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36082 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab0LRQkR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Dec 2010 11:40:17 -0500
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
From: Johannes Berg <johannes@sipsolutions.net>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-mmc@vger.kernel.org,
	Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
	Ido Yariv <ido@wizery.com>, linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTin23vbbA7+UDzh=v060HbkLMrJjB38cs+AWScPJ@mail.gmail.com>
References: <AANLkTikJr+0kVPE4aSwPjZWRfA3gRSNgGwzQdSwRpo_5@mail.gmail.com>
	 <Pine.LNX.4.44L0.1012110937100.10743-100000@netrider.rowland.org>
	 <AANLkTi=32bqipN5U00La-B7JSgTC1bHgMev=xUSF6kRN@mail.gmail.com>
	 <201012181607.26628.rjw@sisk.pl>
	 <AANLkTin23vbbA7+UDzh=v060HbkLMrJjB38cs+AWScPJ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 18 Dec 2010 17:40:07 +0100
Message-ID: <1292690407.3653.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-12-18 at 18:00 +0200, Ohad Ben-Cohen wrote:

> > That's where the problem is.  If there's a difference, from the driver's
> > point of view, between suspend and some other operation, there should be a
> > way to tell the driver what case it actually is dealing with.
> 
> Yes, the problem will be solved if the driver would bypass the runtime
> PM framework on system suspend. mac80211 obviously has this
> information, and technically it's very easy to let the driver know
> about it.
> 
> But the difference between suspend and normal operation is really
> artificial: in both cases mac80211 just asks the driver to power its
> device down, and the end result is exactly the same (a GPIO line of
> the device is de-asserted in our case). The difference between these
> two scenarios
> exist only because runtime PM is effectively disabled during system
> suspend, and therefore the driver has to look for an alternative way
> to power down the device.

Sounds to me like the difference isn't really in the driver, but the
core PM subsystem. Why does it care when powering off a device whether
it's during suspend, or during runtime?

johannes

