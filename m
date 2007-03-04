Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailgate.cesmail.net ([216.154.195.36]:39407 "HELO
	mailgate.cesmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751012AbXCDFKD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2007 00:10:03 -0500
Message-ID: <20070304001001.z1p520cck44ookcs@webmail.spamcop.net>
Date: Sun,  4 Mar 2007 00:10:01 -0500
From: Pavel Roskin <proski@gnu.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Larry Finger <larry.finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcm43xx: remove ethtool
References: <45ea1a34.Lf4EKmMy+KAmSkH0%Larry.Finger@lwfinger.net>
	<45EA3272.7090101@garzik.org> <45EA3D21.3080203@lwfinger.net>
	<45EA43EF.1080009@garzik.org>
In-Reply-To: <45EA43EF.1080009@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Jeff Garzik <jeff@garzik.org>:

> It's a highly standardized interface that provides information that's
> either impossible or highly difficult to obtain elsewhere.

For what it's worth, ifrename in the forthcoming Wireless Tools 29 will support
reading symlinks on sysfs, which would allow matching the device and  the
driver name.  Other userspace tools can do the same.

$ readlink /sys/class/net/eth0/device
../../../devices/pci0000:00/0000:00:0d.0/0000:01:02.0
$ readlink /sys/class/net/eth0/device/driver
../../../../bus/pci/drivers/orinoco_plx

That's 2.6.20, things may be slightly different on 2.6.21+

> If you are a userland process querying a network interface, that's the
> only way to know which driver is attached, or the only way to build an
> association between a PCI device and a network interface.
>
> So NAK this change.  All network drivers should implement GDRVINFO, even
> if they are not strictly ethernet drivers.

I would say it's not yet time to remove it.  But if a driver doesn't implement
it (that's the case for bcm43xx_d80211), I don't think we should bother
implementing it.

--
Regards,
Pavel Roskin
