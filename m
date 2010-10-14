Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:42929 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754850Ab0JNHlF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 03:41:05 -0400
Message-ID: <4CB6BE57.8010401@gmx.net>
Date: Thu, 14 Oct 2010 10:24:55 +0200
From: George <george.news@gmx.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Compat-wireless N900
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I'm trying to use compat-wireless to upgrade my n900 wireless driver. 
N900 is using WL1251 wireless driver and the omap1 kernel version used 
it 2.6.28.

The issue is that 2.6.28 does not have implemented many issues for 
nl80211 netlink family which I wanted to test on my n900.

I have recompiled the kernel to make cfg80211 and mac80211 modules, so I 
can use compat-wireless. After that I have compiled compat-wireless by 
selecting the driver family I need. All done under scratchbox.

# scripts/driver-select wl12xx
# make KLIB=/lib/modules/2.6.28-myversion \
    KMODPATH_ARG=/lib/modules/2.6.28-myversion
# make  KLIB=/lib/modules/2.6.28-myversion \
    KMODPATH_ARG=/lib/modules/2.6.28-myversion install

After that I have installed the new kernel and the drivers in the n900 
and the system starts. `uname -a` reports I'm using my custom kernel.

The problem is that the wireless modules are not working as expected and 
I cannot get access to my wifi networks. Actually bluetooth is not 
working as well, as far as I have tested.

dmesg reports --> http://pastebin.com/xskKcGnE

I have hightlighted the lines that seems to be reflecting what is not 
working. So it seems that on startup it is trying to upload the former 
wl12xx.ko module. Then I decided to manually upload the new modules to 
check them out.

$ sudo gainroot
# modprobe wl1251_spi
# ifconfig -a
---- no wlan0 iface ----
# iwconfig
---- no wireless devices ----

I have also tried with wl1251_sdio driver but I have the same problem. 
dmesg doesn't report any error while uploading these drivers, but I 
don't know why not a new wireless interface is not created.

BTW, the firmware is in /lib/modules/firmware so it is in a place that 
can be found. Do I have to change something?

What files do I need to reconfigure as to get the kernel to point to the 
correct driver upon booting?
How do I create a new wireless interface if the driver is uploaded 
properly but the interface is not created?
Any other issue that you find I'm not doing correctly?

Any help is welcome.

Regards,
George
