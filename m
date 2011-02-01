Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:60174 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab1BAVJp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 16:09:45 -0500
Date: Tue, 1 Feb 2011 22:09:39 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Eric Fernandez <zeb@zebulon.org.uk>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Ralink RT2501/RT2573 USB Wireless Adapter crashes kernel 2.6.37
Message-ID: <20110201210939.GA21929@sig21.net>
References: <AANLkTik=oRjh9UHAsOOTpuOJR7OBw2HCsXd8vhHN_YJY@mail.gmail.com>
 <20110201114757.GA11930@sig21.net>
 <AANLkTi=VGu6Ysn5WkYjdmVx1+gvzywmqA1-jG5DEL3Eh@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTi=VGu6Ysn5WkYjdmVx1+gvzywmqA1-jG5DEL3Eh@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 01, 2011 at 08:31:33PM +0000, Eric Fernandez wrote:
> Feb  1 20:22:39 localhost kernel: PGD 154c063 PUD 1fffc067 PMD 80000000c94001e3
> Feb  1 20:22:39 localhost kernel: CPU 1
> Feb  1 20:22:39 localhost kernel: Modules linked in: rt73usb(+)
> rt2500usb rt2x00usb rt2x00lib mac80211 cfg80211 rfkill ipv6 it87
> adt7475 hwmon_vid ext3 jbd nls_cp437 vfat fat joydev usbhid hid
> nvidia(P) uvcvideo videodev v4l1_compat v4l2_compat_ioctl32
...
> Feb  1 20:22:39 localhost kernel: Pid: 7507, comm: modprobe Tainted: P

proprietary modules :-(

> Feb  1 20:22:39 localhost kernel: [<ffffffff812ae58a>] device_add+0x4fa/0x5c0
> Feb  1 20:22:39 localhost kernel: [<ffffffffa00846af>]
> rfkill_register+0x9f/0x270 [rfkill]
> Feb  1 20:22:39 localhost kernel: [<ffffffffa0cdf096>]
> wiphy_register+0x246/0x340 [cfg80211]
> Feb  1 20:22:39 localhost kernel: [<ffffffff81127e2b>] ? __kmalloc+0x19b/0x280
> Feb  1 20:22:39 localhost kernel: [<ffffffffa0d032e7>]
> ieee80211_register_hw+0x167/0x520 [mac80211]
> Feb  1 20:22:39 localhost kernel: [<ffffffffa0d43e40>]
> rt2x00lib_probe_dev+0x2e0/0x4c0 [rt2x00lib]
> Feb  1 20:22:39 localhost kernel: [<ffffffffa01502ad>]
> rt2x00usb_probe+0x14d/0x310 [rt2x00usb]

Can you double check rfkill module is from compat-wireless
and not from you kernel?
Or maybe compat-wireless is currently broken, try an older tarball.
It doesn't look at first glance like a rt2x00 specific issue.

BTW, output from dmesg also contains the actual crash
reason which is not in /var/log/messages due to your syslog config.


HTH,
Johannes
