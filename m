Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([140.186.70.10]:34339 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbXGTEnV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jul 2007 00:43:21 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1IBkLx-0001ND-RK
	for linux-wireless@vger.kernel.org; Fri, 20 Jul 2007 00:44:33 -0400
Subject: Re: bcm4301: A mac80211 driver using V3 firmware
From: Pavel Roskin <proski@gnu.org>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>
In-Reply-To: <46A01209.4030200@lwfinger.net>
References: <46963C0F.3080104@lwfinger.net>
	 <20070719215801.GB12449@tuxdriver.com> <20070720012714.0dc0298a@morte>
	 <46A01209.4030200@lwfinger.net>
Content-Type: text/plain
Date: Fri, 20 Jul 2007 00:43:16 -0400
Message-Id: <1184906596.9511.42.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, Larry!

First of all, many thanks for porting the v3 driver to mac80211!

On Thu, 2007-07-19 at 20:38 -0500, Larry Finger wrote:

> 1. For more general testing, I'll distribute my driver as a patch to
> be applied to wireless-dev as 
> it needs ssb, which is not yet in mainline. If we are still in testing when ssb is merged, I'll 
> change to making patches against mainline.

Sounds good.

> 2. Once the problems have been cleared and ssb is in -mm, it gets sent there as a port from softmac 
> to mac80211 for the current bcm43xx. An additional consideration is that a port from softmac to 
> mac80211 will be more easily merged than if it looks like a new driver.

I would prefer if the name stayed the same, but it shouldn't be a big
deal.

> 3. If the port of softmac to mac80211 is merged before Michael's driver, it will be known as bcm43xx 
> with bcm43xx-mac80211 remaining in wireless-dev.

Yes, that's what I mean, keep it "bcm43xx" unless renaming it is the
condition for acceptance.

> 4. Once bcm43xx-mac80211 gets merged to mainline, then Michael's driver should become bcm43xx and my 
> driver gets its PCI IDs stripped to the 802.11b-only devices and once again becomes bcm4301. This 
> name change for Michael's driver would cause some disruption for current users as their firmware 
> would have the wrong name/version. That might be too much of a problem.

Actually, the common practice is that the new driver that doesn't
supplant the old driver immediately and for the whole range of hardware
gets a new name.  Think CONFIG_IDE vs CONFIG_ATA and eepro100 vs e100.

Also, we could introduce a kernel option to enable support for new
devices in your driver.

> I think this is a path that always has a stable driver with at least moderate performance in 
> mainline throughout the entire transformation.

That's a very good goal.

I would also consider the option to use different names for v3 and v4
firmware.  I have a file /etc/modprobe.d/bcm43xx that reads

options bcm43xx fwpostfix=.3
options bcm43xx_mac80211 fwpostfix=.4

but we cannot expect every distro (let alone every user) to take care of
the naming conflict.  Users don't expect the need to rename firmware,
and we shouldn't create a problem for them.

-- 
Regards,
Pavel Roskin

