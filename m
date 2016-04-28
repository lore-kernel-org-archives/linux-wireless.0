Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vpn.innerrange.com.au ([203.122.143.146]:29053 "EHLO
	remote.innerrange.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751094AbcD1E5d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2016 00:57:33 -0400
From: Craig McQueen <craig.mcqueen@innerrange.com>
To: Craig McQueen <craig.mcqueen@innerrange.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 28 Apr 2016 14:57:24 +1000
Subject: RE: rt2800 soft lockup on disable
Message-ID: <5500469A22567C4BAF673A6E86AFA3A4022D20C815A5@IR-CENTRAL.corp.innerrange.com> (sfid-20160428_065739_048176_880A2DE3)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I previously wrote:
> 
> I have a D-Link DWA-140 USB Wi-Fi device which is rt2800 based (5392
> chipset). I've been testing it on a BeagleBone Black running an Ubuntu 16.04
> image (4.4.6 kernel).
> 
> (For the following, I am testing with a USB hub, because as I said in a previous
> e-mail, I get a kernel panic if I try to plug it in directly to the BeagleBone Black
> without the hub. However, I have also had this issue on a BeagleBone Black-
> based device running a 3.14.x Yocto-built kernel, where I was able to use it
> without a hub, and this issue also occurs when the device is plugged directly
> into the BeagleBone Black.)
> 
> If I plug in the rt2800 device, and wait for it to connect to an access point,
> then try to disable it by various methods, I get a kernel soft lockup.
> 
> Various methods to disable the device which cause the kernel soft lockup
> include (while current directory is e.g. /sys/bus/usb/devices/1-1.3):
> 
> echo 0 > authorized
> echo -1 > bConfigurationValue
> modprobe -r rt2800usb
> echo 1-1.3 > driver/unbind
> 
> On the 4.4.6 kernel, they sometimes succeed, but often cause a soft lockup.
> On the 3.14.x Yocto-built kernel, I found they always fail if the Wi-Fi device is
> in-use (operating in client or access point mode) but succeed if it is idle.
> 
> E.g. in a recent test doing "echo 0 > authorized", I got the following in the
> serial debug console:
> 
> [  172.167656] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 23s!
> [kworker/u2:0:6] [  200.167589] NMI watchdog: BUG: soft lockup - CPU#0
> stuck for 22s! [kworker/u2:0:6] [  228.167550] NMI watchdog: BUG: soft
> lockup - CPU#0 stuck for 22s! [kworker/u2:0:6]
> 
> In this case, I was able to do a couple of successful "echo 0 > authorized" and
> then re-enable with "echo 1 > authorized", before the lockup occurred on a
> third "echo 0 > authorized".  I'm attaching the corresponding dmesg dump.
> 

My subject previously said "kernel panic" but it's actually a soft lockup. Subject changed.

I've also been able to reproduce this on an i586 based eBox-3310A mini PC running Debian 8.4 with a 3.16.0 kernel. On that platform, it does not suffer from the other rt2800 issue I reported (kernel panicwhen connecting to access point without a USB hub), so I was able to test this both with and without a hub. I get a soft lockup in both cases. But in both cases, unplugging the device and/or the hub did not relieve the soft lockup condition.

In contrast, I have not been able to reproduce the rt2800 issue of one of my other recent reports (soft lockup on unplug from hub) on the i586 mini-PC platform.

-- 
Craig McQueen

