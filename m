Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4291 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbXGTODl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jul 2007 10:03:41 -0400
Date: Fri, 20 Jul 2007 09:44:25 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Larry Finger <larry.finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>
Subject: Re: bcm4301: A mac80211 driver using V3 firmware
Message-ID: <20070720134425.GC7428@tuxdriver.com>
References: <46963C0F.3080104@lwfinger.net> <20070719215801.GB12449@tuxdriver.com> <20070720012714.0dc0298a@morte> <46A01209.4030200@lwfinger.net> <1184906596.9511.42.camel@dv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1184906596.9511.42.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 20, 2007 at 12:43:16AM -0400, Pavel Roskin wrote:
> On Thu, 2007-07-19 at 20:38 -0500, Larry Finger wrote:

> > 4. Once bcm43xx-mac80211 gets merged to mainline, then Michael's driver should become bcm43xx and my 
> > driver gets its PCI IDs stripped to the 802.11b-only devices and once again becomes bcm4301. This 
> > name change for Michael's driver would cause some disruption for current users as their firmware 
> > would have the wrong name/version. That might be too much of a problem.
> 
> Actually, the common practice is that the new driver that doesn't
> supplant the old driver immediately and for the whole range of hardware
> gets a new name.  Think CONFIG_IDE vs CONFIG_ATA and eepro100 vs e100.
 
Yes, this preserves stability for happy bcm43xx users.  Still taking
suggestions for the new name for bcm43xx-mac80211... :-)

> Also, we could introduce a kernel option to enable support for new
> devices in your driver.
 
Yes, this is probably worthwhile for those wishing to avoid PCI ID
conflicts between the drivers.  I have also been speculating that
perhaps we need an option for a secondary PCI ID table, so that a
driver could support a large range of PCI IDs but then gracefully
bow-out if another driver had a certain ID in its primary table.
Does that make any sense?  It would seem to be applicable to a number
of drivers in the kernel.

> I would also consider the option to use different names for v3 and v4
> firmware.  I have a file /etc/modprobe.d/bcm43xx that reads
> 
> options bcm43xx fwpostfix=.3
> options bcm43xx_mac80211 fwpostfix=.4
> 
> but we cannot expect every distro (let alone every user) to take care of
> the naming conflict.  Users don't expect the need to rename firmware,
> and we shouldn't create a problem for them.

Yes, we should probably start using a default value for fwpostfix.
As dwmw2 suggested, it would also be nice to fall back to an empty
fwpostfix if the firmware is not found w/ the default extension.

John
-- 
John W. Linville
linville@tuxdriver.com
