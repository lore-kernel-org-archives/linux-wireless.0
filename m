Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-03.rdc-kc.rr.com ([24.94.166.129]:38590 "EHLO
	ms-smtp-03.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbXB0Vko (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Feb 2007 16:40:44 -0500
Date: Tue, 27 Feb 2007 15:39:27 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: [PATCH V2] bcm43xx: Update Documentation/bcm43xx.txt
Message-ID: <45e4a50f.sCG/5tmeAFHjK3H5%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The in-kernel documentation of the bcm43xx driver is out of date.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-2.6/Documentation/networking/bcm43xx.txt
===================================================================
--- wireless-2.6.orig/Documentation/networking/bcm43xx.txt
+++ wireless-2.6/Documentation/networking/bcm43xx.txt
@@ -2,35 +2,80 @@
 			BCM43xx Linux Driver Project
 			============================
 
-About this software
--------------------
-
-The goal of this project is to develop a linux driver for Broadcom
-BCM43xx chips, based on the specification at 
-http://bcm-specs.sipsolutions.net/
-
-The project page is http://bcm43xx.berlios.de/
-
-
-Requirements
+Introduction
 ------------
 
-1)	Linux Kernel 2.6.16 or later
-	http://www.kernel.org/
-
-	You may want to configure your kernel with:
-
-	CONFIG_DEBUG_FS (optional):
-		-> Kernel hacking
-		  -> Debug Filesystem
-
-2)	SoftMAC IEEE 802.11 Networking Stack extension and patched ieee80211
-	modules:
-	http://softmac.sipsolutions.net/
-
-3)	Firmware Files
-
-	Please try fwcutter. Fwcutter can extract the firmware from various 
-	binary driver files. It supports driver files from Windows, MacOS and 
-	Linux. You can get fwcutter from http://bcm43xx.berlios.de/.
-	Also, fwcutter comes with a README file for further instructions.
+Many of the wireless devices found in modern notebook computers are based
+on the wireless chips produced by Broadcom. These devices have been a problem
+for Linux users as there is no open-source driver available. In addition,
+Broadcom has not released specifications for the device, and driver availability
+has been limited to the binary-only form used in the GPL versions of AP
+hardware such as the Linksys WRT54G, and the Windows and OS X drivers.
+Before this project began, the only way to use these devices were to use the
+Windows or OS X drivers with either the Linuxant or ndiswrapper modules. There
+is a strong penalty if this method is used as loading the binary-only module
+"taints" the kernel, and no kernel developer will help diagnose any kernel
+problems.
+
+Development
+-----------
+
+This driver has been developed using a clean-room technique that is described
+at http://bcm-specs.sipsolutions.net/ReverseEngineeringProcess. For legal
+reasons, none of the clean-room crew works on the on the Linux driver, and
+none of the Linux developers sees anything but the specifications, which are
+the ultimate product of the reverse-engineering group.
+
+Software
+--------
+
+Since the release of the 2.6.17 kernel, the bcm43xx driver has been distributed
+with the kernel source, and is prebuilt in most, if not all, distributions.
+There is, however, additional software that is required. The firmware used by the
+chip is the intellectual property of Broadcom and they have not given the bcm43xx
+team redistribution rights to this firmware.  Since we cannot legally redistribute
+the firwmare we cannot include it with the driver. Furthermore, it cannot be placed
+in the downloadable archives of any distributing organization; therefore, the user is
+responsible for obtaining the firmware and placing it in the appropriate location
+so that the driver can find it when initializing.
+
+To help with this process, the bcm43xx developers provide a separate program
+named bcm43xx-fwcutter to "cut" the firmware out of a Windows or OS X driver
+and write the extracted files to the proper location. This program is usually
+provided with the distribution; however, it may be downloaded from
+
+http://developer.berlios.de/project/showfiles.php?group_id=4547
+
+The firmware is available in two versions. V3 firmware is used with the
+in-kernel bcm43xx driver that uses a software MAC layer called SoftMAC, and
+will have a microcode revision of 0x127 or smaller. The V4 firmware is used
+by an out-of-kernel driver employing a variation of the Devicescape MAC layer
+known as d80211. Once bcm43xx-d80211 reaches a satisfactory level of
+development, it will replace bcm43xx-softmac in the kernel as it is much more
+flexible and powerful.
+
+A source for the latest V3 firmware is
+
+http://downloads.openwrt.org/sources/wl_apsta-3.130.20.0.o
+
+Once this file is downloaded, the command 'bcm43xx-fwcutter -w <dir> <filename>'
+will extract the microcode and write it to directory <dir>. The correct
+directory will depend on your distribution; however, most use '/lib/firmware'.
+Once this step is completed, the bcm3xx driver should load when the system is
+booted. To see any messages relating to the driver, issue the command
+'dmesg | grep bcm43xx' from a terminal window. If there are any problems,
+please send that output to Bcm43xx-dev@lists.berlios.de.
+
+Although the driver has been in-kernel since 2.6.17, the earliest version is
+quite limited in its capability. Patches that include all features of later
+versions are available for the stable kernel versions from 2.6.18. These will
+be needed if you use a BCM4318, or a PCI Express version (BCM4311 and BCM4312).
+In addition, if you have an early BCM4306 and more than 1 GB RAM, your kernel
+will need to be patched. These patches, which are being updated regularly, are
+available at ftp://lwfinger.dynalias.org/patches. Look for
+'combined_2.6.YY.patch'. Of course you will need kernel source downloaded from
+kernel.org, or the source from your distribution.
+
+If you build your own kernel, please enable CONFIG_BCM43XX_DEBUG and
+CONFIG_IEEE80211_SOFTMAC_DEBUG. The log information provided is essential for
+solving any problems.
