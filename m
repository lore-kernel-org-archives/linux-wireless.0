Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4933 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755403AbXKUP1O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 10:27:14 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: rjw@sisk.pl, larry.finger@lwfinger.net, stefano.brivio@polimi.it,
	mb@bu3sch.de, bcm43xx-dev@lists.berlios.de,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v2] bcm43xx: mark as obsolete and schedule for removal
Date: Wed, 21 Nov 2007 10:26:18 -0500
Message-Id: <1195658778-13118-1-git-send-email-linville@tuxdriver.com> (sfid-20071121_152719_154103_78A7A278)
In-Reply-To: <1195654571-10506-1-git-send-email-linville@tuxdriver.com>
References: <1195654571-10506-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
Amended based on suggestions from Stefano...

 Documentation/feature-removal-schedule.txt |    9 +++++++++
 MAINTAINERS                                |    2 +-
 drivers/net/wireless/bcm43xx/Kconfig       |    9 ++++++---
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 20c4c8b..c057e36 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -333,3 +333,12 @@ Why:	This driver has been marked obsolete for many years.
 Who:	Stephen Hemminger <shemminger@linux-foundation.org>
 
 ---------------------------
+
+What:	bcm43xx wireless network driver
+When:	2.6.26
+Files:	drivers/net/wireless/bcm43xx
+Why:	This driver's functionality has been replaced by the
+	mac80211-based b43 and b43legacy drivers.
+Who:	John W. Linville <linville@tuxdriver.com>
+
+---------------------------
diff --git a/MAINTAINERS b/MAINTAINERS
index 18b7c8e..2bfc23f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -828,7 +828,7 @@ P:	Stefano Brivio
 M:	stefano.brivio@polimi.it
 L:	linux-wireless@vger.kernel.org
 W:	http://bcm43xx.berlios.de/
-S:	Maintained
+S:	Obsolete
 
 BEFS FILE SYSTEM
 P:	Sergey S. Kostyliov
diff --git a/drivers/net/wireless/bcm43xx/Kconfig b/drivers/net/wireless/bcm43xx/Kconfig
index ce397e4..0159701 100644
--- a/drivers/net/wireless/bcm43xx/Kconfig
+++ b/drivers/net/wireless/bcm43xx/Kconfig
@@ -1,12 +1,15 @@
 config BCM43XX
-	tristate "Broadcom BCM43xx wireless support"
+	tristate "Broadcom BCM43xx wireless support (DEPRECATED)"
 	depends on PCI && IEEE80211 && IEEE80211_SOFTMAC && WLAN_80211 && EXPERIMENTAL
 	select WIRELESS_EXT
 	select FW_LOADER
 	select HW_RANDOM
 	---help---
-	  This is an experimental driver for the Broadcom 43xx wireless chip,
-	  found in the Apple Airport Extreme and various other devices.
+	  This is an experimental driver for the Broadcom 43xx wireless
+	  chip, found in the Apple Airport Extreme and various other
+	  devices.  This driver is deprecated and will be removed
+	  from the kernel in the near future.  It has been replaced
+	  by the b43 and b43legacy drivers.
 
 config BCM43XX_DEBUG
 	bool "Broadcom BCM43xx debugging (RECOMMENDED)"
-- 
1.5.3.3

