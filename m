Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:48280 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750890AbXKSSpV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 13:45:21 -0500
Date: Mon, 19 Nov 2007 19:44:14 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <larry.finger@lwfinger.net>, mb@bu3sch.de
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: [PATCH v2] remove bcm43xx
Message-ID: <20071119194414.1f2f13e2@morte> (sfid-20071119_184525_807288_B3A78C05)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove bcm43xx.


Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>

---

John,
this is for 2.6.25. Please also run:
	git rm -r drivers/wireless/bcm43xx


---

Index: wireless-2.6/Documentation/networking/bcm43xx.txt
===================================================================
--- wireless-2.6.orig/Documentation/networking/bcm43xx.txt
+++ /dev/null
@@ -1,89 +0,0 @@
-
-			BCM43xx Linux Driver Project
-			============================
-
-Introduction
-------------
-
-Many of the wireless devices found in modern notebook computers are
-based on the wireless chips produced by Broadcom. These devices have
-been a problem for Linux users as there is no open-source driver
-available. In addition, Broadcom has not released specifications
-for the device, and driver availability has been limited to the
-binary-only form used in the GPL versions of AP hardware such as the
-Linksys WRT54G, and the Windows and OS X drivers.  Before this project
-began, the only way to use these devices were to use the Windows or
-OS X drivers with either the Linuxant or ndiswrapper modules. There
-is a strong penalty if this method is used as loading the binary-only
-module "taints" the kernel, and no kernel developer will help diagnose
-any kernel problems.
-
-Development
------------
-
-This driver has been developed using
-a clean-room technique that is described at
-http://bcm-specs.sipsolutions.net/ReverseEngineeringProcess. For legal
-reasons, none of the clean-room crew works on the on the Linux driver,
-and none of the Linux developers sees anything but the specifications,
-which are the ultimate product of the reverse-engineering group.
-
-Software
---------
-
-Since the release of the 2.6.17 kernel, the bcm43xx driver has been
-distributed with the kernel source, and is prebuilt in most, if not
-all, distributions.  There is, however, additional software that is
-required. The firmware used by the chip is the intellectual property
-of Broadcom and they have not given the bcm43xx team redistribution
-rights to this firmware.  Since we cannot legally redistribute
-the firmware we cannot include it with the driver. Furthermore, it
-cannot be placed in the downloadable archives of any distributing
-organization; therefore, the user is responsible for obtaining the
-firmware and placing it in the appropriate location so that the driver
-can find it when initializing.
-
-To help with this process, the bcm43xx developers provide a separate
-program named bcm43xx-fwcutter to "cut" the firmware out of a
-Windows or OS X driver and write the extracted files to the proper
-location. This program is usually provided with the distribution;
-however, it may be downloaded from
-
-http://developer.berlios.de/project/showfiles.php?group_id=4547
-
-The firmware is available in two versions. V3 firmware is used with
-the in-kernel bcm43xx driver that uses a software MAC layer called
-SoftMAC, and will have a microcode revision of 0x127 or smaller. The
-V4 firmware is used by an out-of-kernel driver employing a variation of
-the Devicescape MAC layer known as d80211. Once bcm43xx-d80211 reaches
-a satisfactory level of development, it will replace bcm43xx-softmac
-in the kernel as it is much more flexible and powerful.
-
-A source for the latest V3 firmware is
-
-http://downloads.openwrt.org/sources/wl_apsta-3.130.20.0.o
-
-Once this file is downloaded, the command
-'bcm43xx-fwcutter -w <dir> <filename>'
-will extract the microcode and write it to directory
-<dir>. The correct directory will depend on your distribution;
-however, most use '/lib/firmware'. Once this step is completed,
-the bcm3xx driver should load when the system is booted. To see
-any messages relating to the driver, issue the command 'dmesg |
-grep bcm43xx' from a terminal window. If there are any problems,
-please send that output to Bcm43xx-dev@lists.berlios.de.
-
-Although the driver has been in-kernel since 2.6.17, the earliest
-version is quite limited in its capability. Patches that include
-all features of later versions are available for the stable kernel
-versions from 2.6.18. These will be needed if you use a BCM4318,
-or a PCI Express version (BCM4311 and BCM4312). In addition, if you
-have an early BCM4306 and more than 1 GB RAM, your kernel will need
-to be patched.	These patches, which are being updated regularly,
-are available at ftp://lwfinger.dynalias.org/patches. Look for
-combined_2.6.YY.patch. Of course you will need kernel source downloaded
-from kernel.org, or the source from your distribution.
-
-If you build your own kernel, please enable CONFIG_BCM43XX_DEBUG
-and CONFIG_IEEE80211_SOFTMAC_DEBUG. The log information provided is
-essential for solving any problems.
Index: wireless-2.6/MAINTAINERS
===================================================================
--- wireless-2.6.orig/MAINTAINERS
+++ wireless-2.6/MAINTAINERS
@@ -821,15 +821,6 @@ L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/en/users/Drivers/b43
 S:	Maintained
 
-BCM43XX WIRELESS DRIVER (SOFTMAC BASED VERSION)
-P:	Larry Finger
-M:	Larry.Finger@lwfinger.net
-P:	Stefano Brivio
-M:	stefano.brivio@polimi.it
-L:	linux-wireless@vger.kernel.org
-W:	http://bcm43xx.berlios.de/
-S:	Maintained
-
 BEFS FILE SYSTEM
 P:	Sergey S. Kostyliov
 M:	rathamahata@php4.ru
Index: wireless-2.6/drivers/net/wireless/Kconfig
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/Kconfig
+++ wireless-2.6/drivers/net/wireless/Kconfig
@@ -629,7 +629,6 @@ config ATH5K
 
 source "drivers/net/wireless/iwlwifi/Kconfig"
 source "drivers/net/wireless/hostap/Kconfig"
-source "drivers/net/wireless/bcm43xx/Kconfig"
 source "drivers/net/wireless/b43/Kconfig"
 source "drivers/net/wireless/b43legacy/Kconfig"
 source "drivers/net/wireless/zd1211rw/Kconfig"
Index: wireless-2.6/drivers/net/wireless/Makefile
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/Makefile
+++ wireless-2.6/drivers/net/wireless/Makefile
@@ -37,7 +37,6 @@ obj-$(CONFIG_USB_ATMEL)	        += at76_
 obj-$(CONFIG_PRISM54)		+= prism54/
 
 obj-$(CONFIG_HOSTAP)		+= hostap/
-obj-$(CONFIG_BCM43XX)		+= bcm43xx/
 obj-$(CONFIG_B43)		+= b43/
 obj-$(CONFIG_B43LEGACY)		+= b43legacy/
 obj-$(CONFIG_ZD1211RW)		+= zd1211rw/
Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c
+++ wireless-2.6/drivers/net/wireless/b43/main.c
@@ -1558,7 +1558,7 @@ static void b43_release_firmware(struct 
 static void b43_print_fw_helptext(struct b43_wl *wl)
 {
 	b43err(wl, "You must go to "
-
"http://linuxwireless.org/en/users/Drivers/bcm43xx#devicefirmware "
+
"http://linuxwireless.org/en/users/Drivers/b43#devicefirmware " "and
download the correct firmware (version 4).\n"); }
 
Index: wireless-2.6/drivers/net/wireless/b43legacy/dma.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/dma.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/dma.c
@@ -996,7 +996,7 @@ int b43legacy_dma_init(struct b43legacy_
 
 	err = ssb_dma_set_mask(dev->dev, dmamask);
 	if (err) {
-#ifdef BCM43XX_PIO
+#ifdef CONFIG_B43LEGACY_PIO
 		b43legacywarn(dev->wl, "DMA for this device not supported.
" "Falling back to PIO\n");
 		dev->__using_pio = 1;
Index: wireless-2.6/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/main.c
@@ -1398,7 +1398,7 @@ static void b43legacy_release_firmware(s
 static void b43legacy_print_fw_helptext(struct b43legacy_wl *wl)
 {
 	b43legacyerr(wl, "You must go to
http://linuxwireless.org/en/users/"
-		     "Drivers/bcm43xx#devicefirmware "
+		     "Drivers/b43#devicefirmware "
 		     "and download the correct firmware (version 3).\n");
 }
 


-- 
Ciao
Stefano
