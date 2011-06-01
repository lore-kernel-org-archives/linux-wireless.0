Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3785 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161137Ab1FALqU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:20 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 11/83] staging: brcm80211: updated MAINTAINERS, README
 and TODO files
Date: Wed, 1 Jun 2011 13:44:56 +0200
Message-ID: <1306928768-7501-11-git-send-email-rvossen@broadcom.com> (sfid-20110601_134626_568187_4674315A)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

README now only contains a link to the brcm80211 driver page. Two maintainers
have been added, one deleted. TODO file has also been updated.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 MAINTAINERS                      |    3 +-
 drivers/staging/brcm80211/README |   65 +-------------------------------------
 drivers/staging/brcm80211/TODO   |   14 ++++++--
 3 files changed, 14 insertions(+), 68 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 29801f7..39c17dd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1533,9 +1533,10 @@ F:	drivers/net/tg3.*
 BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
 M:	Brett Rudley <brudley@broadcom.com>
 M:	Henry Ptasinski <henryp@broadcom.com>
-M:	Dowan Kim <dowan@broadcom.com>
 M:	Roland Vossen <rvossen@broadcom.com>
 M:	Arend van Spriel <arend@broadcom.com>
+M:	Franky (Zhenhui) Lin <frankyl@broadcom.com>
+M:	Kan Yan	<kanyan@broadcom.com>
 L:	linux-wireless@vger.kernel.org
 S:	Supported
 F:	drivers/staging/brcm80211/
diff --git a/drivers/staging/brcm80211/README b/drivers/staging/brcm80211/README
index 8ad5586..bb86b1b 100644
--- a/drivers/staging/brcm80211/README
+++ b/drivers/staging/brcm80211/README
@@ -1,64 +1 @@
-Broadcom brcmsmac (mac80211-based softmac PCIe) and brcmfmac (SDIO) drivers.
-
-Completely open source host drivers, no binary object files.
-
-Support for the following chips:
-===============================
-
-    brcmsmac (PCIe)
-    Name        Device ID
-    BCM4313     0x4727
-    BCM43224    0x4353
-    BCM43225    0x4357
-
-    brcmfmac (SDIO)
-    Name
-    BCM4329
-
-Both brcmsmac and brcmfmac drivers require firmware files that need to be
-separately downloaded.
-
-Firmware
-======================
-Firmware is available from the Linux firmware repository at:
-
-    git://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware.git
-    http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git
-    https://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git
-
-
-===============================================================
-Broadcom brcmsmac driver
-===============================================================
-- Support for both 32 and 64 bit Linux kernels
-
-
-Firmware installation
-======================
-Copy brcm/bcm43xx-0.fw and brcm/bcm43xx_hdr-0.fw to
-/lib/firmware/brcm (or wherever firmware is normally installed
-on your system).
-
-
-===============================================================
-Broadcom brcmfmac driver
-===============================================================
-- Support for 32 bit Linux kernel, 64 bit untested
-
-
-Firmware installation
-======================
-Copy brcm/bcm4329-fullmac-4.bin and brcm/bcm4329-fullmac-4.txt
-to /lib/firmware/brcm (or wherever firmware is normally installed on your
-system).
-
-
-Contact Info:
-=============
-Brett Rudley		brudley@broadcom.com
-Henry Ptasinski		henryp@broadcom.com
-Dowan Kim		dowan@broadcom.com
-Roland Vossen		rvossen@broadcom.com
-Arend van Spriel	arend@broadcom.com
-
-For more info, refer to: http://linuxwireless.org/en/users/Drivers/brcm80211
+refer to: http://linuxwireless.org/en/users/Drivers/brcm80211
diff --git a/drivers/staging/brcm80211/TODO b/drivers/staging/brcm80211/TODO
index e9c1393..2d9948d 100644
--- a/drivers/staging/brcm80211/TODO
+++ b/drivers/staging/brcm80211/TODO
@@ -2,14 +2,22 @@ To Do List for Broadcom Mac80211 driver before getting in mainline
 
 Bugs
 ====
-- Oops on AMPDU traffic, to be solved by new ucode (currently under test)
+- none known at this moment
 
 brcmfmac and brcmsmac
 =====================
-- ASSERTS not allowed in mainline, replace by warning + error handling
-- Replace printk and WL_ERROR() with proper routines
+
+- Remove unnecessary includes, move #includes from .h files into .c files.
+- Absorb and delete header files that are included in only one .c file
 
 brcmfmac
 =====================
+
+- ASSERTS not allowed in mainline, replace by warning + error handling
+- Replace printk and WL_ERROR() with proper routines
 - Replace driver's proprietary ssb interface with generic kernel ssb module
 - Build and test on 64 bit linux kernel
+
+brcm80211 info page
+=====================
+http://linuxwireless.org/en/users/Drivers/brcm80211
-- 
1.7.4.1


