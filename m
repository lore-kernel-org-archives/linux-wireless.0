Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:47977 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760014AbYBLOKO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2008 09:10:14 -0500
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: ipw2100-admin@linux.intel.com
Subject: [PATCH] ipw2100/ipw2200: note firmware loading caveat in Kconfig help text
Message-Id: <20080212134942.9FD589D4135@zog.reactivated.net> (sfid-20080212_141033_444486_ED50E00D)
Date: Tue, 12 Feb 2008 13:49:42 +0000 (GMT)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Most wireless drivers load their firmware at interface open time, which
generally occurs after the filesystem is available. However, the ipw drivers
load their firmware at probe time because firmware is required to read the
device MAC address. When built-in, probe happens before the filesystem is
available, hence device init will only complete successfully if the user
has made special arrangements (including firmware plus a loader in the
initramfs).

Note all this in the kconfig help text for both drivers.

Signed-off-by: Daniel Drake <dsd@gentoo.org>
---
 drivers/net/wireless/Kconfig |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 714a6ca..ff1d5d8 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -146,12 +146,15 @@ config IPW2100
           configure your card:
 
           <http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html>.
+
+          It is recommended that you compile this driver as a module (M)
+          rather than built-in (Y). This driver requires firmware at device
+          initialization time, and when built-in this typically happens
+          before the filesystem is accessible (hence firmware will be
+          unavailable and initialization will fail). If you do choose to build
+          this driver into your kernel image, you can avoid this problem by
+          including the firmware and a firmware loader in an initramfs.
  
-          If you want to compile the driver as a module ( = code which can be
-          inserted in and removed from the running kernel whenever you want),
-          say M here and read <file:Documentation/kbuild/modules.txt>.
-          The module will be called ipw2100.ko.
-	
 config IPW2100_MONITOR
         bool "Enable promiscuous mode"
         depends on IPW2100
@@ -201,11 +204,14 @@ config IPW2200
           configure your card:
 
           <http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html>.
- 
-          If you want to compile the driver as a module ( = code which can be
-          inserted in and removed from the running kernel whenever you want),
-          say M here and read <file:Documentation/kbuild/modules.txt>.
-          The module will be called ipw2200.ko.
+
+          It is recommended that you compile this driver as a module (M)
+          rather than built-in (Y). This driver requires firmware at device
+          initialization time, and when built-in this typically happens
+          before the filesystem is accessible (hence firmware will be
+          unavailable and initialization will fail). If you do choose to build
+          this driver into your kernel image, you can avoid this problem by
+          including the firmware and a firmware loader in an initramfs.
 
 config IPW2200_MONITOR
         bool "Enable promiscuous mode"
-- 
1.5.4

