Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([140.186.70.10]:56855 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939695AbXGTQF3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jul 2007 12:05:29 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1IBv05-0002KR-L1
	for linux-wireless@vger.kernel.org; Fri, 20 Jul 2007 12:06:41 -0400
Subject: Re: bcm4301: A mac80211 driver using V3 firmware
From: Pavel Roskin <proski@gnu.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Larry Finger <larry.finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>
In-Reply-To: <20070720134425.GC7428@tuxdriver.com>
References: <46963C0F.3080104@lwfinger.net>
	 <20070719215801.GB12449@tuxdriver.com> <20070720012714.0dc0298a@morte>
	 <46A01209.4030200@lwfinger.net> <1184906596.9511.42.camel@dv>
	 <20070720134425.GC7428@tuxdriver.com>
Content-Type: text/plain
Date: Fri, 20 Jul 2007 12:05:21 -0400
Message-Id: <1184947521.1962.15.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-07-20 at 09:44 -0400, John W. Linville wrote:
> On Fri, Jul 20, 2007 at 12:43:16AM -0400, Pavel Roskin wrote:
> > Actually, the common practice is that the new driver that doesn't
> > supplant the old driver immediately and for the whole range of hardware
> > gets a new name.  Think CONFIG_IDE vs CONFIG_ATA and eepro100 vs e100.
>  
> Yes, this preserves stability for happy bcm43xx users.  Still taking
> suggestions for the new name for bcm43xx-mac80211... :-)

b43
bcm43
bcm4k3
bcmwifi
bcmwlan
bcm80211
brcm43xx
broadcom

I really like the minimalism of b43, which plays well with b44 and
p54 :)

> > Also, we could introduce a kernel option to enable support for new
> > devices in your driver.
>  
> Yes, this is probably worthwhile for those wishing to avoid PCI ID
> conflicts between the drivers.  I have also been speculating that
> perhaps we need an option for a secondary PCI ID table, so that a
> driver could support a large range of PCI IDs but then gracefully
> bow-out if another driver had a certain ID in its primary table.
> Does that make any sense?  It would seem to be applicable to a number
> of drivers in the kernel.

Yes, I used to hearing complains that orinoco steals IDs from hostap.
Then it became popular to blacklist orinoco modules.  Quite a disgrace
for the driver!  Having "weak" IDs for Prism based cards would have
avoided it.

But please realize that the problem goes far beyond PCI.  Perhaps you
have heard of CONFIG_USB_LIBUSUAL, which selects the best driver for USB
storage devices, either the slow but reliable ub, or the SCSI based
usb-storage, which it too fast for some cheap sticks.

It even has a parameter called "bias", which allows to control how
conservative the algorithm should be.  That would be hard to emulate
with "weak entries", but I hope that "bias" is an overkill.

> Yes, we should probably start using a default value for fwpostfix.
> As dwmw2 suggested, it would also be nice to fall back to an empty
> fwpostfix if the firmware is not found w/ the default extension.

Yes, that sounds good.

-- 
Regards,
Pavel Roskin

