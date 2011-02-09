Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44849 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab1BIVNe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 16:13:34 -0500
Received: by fxm20 with SMTP id 20so661986fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Feb 2011 13:13:33 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] ar9170usb: mark the old driver as obsolete
Date: Wed, 9 Feb 2011 22:13:11 +0100
Cc: linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201102092213.11681.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR9170USB will be replaced by carl9170 in the foreseeable
future [2.6.39].

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index b3f35e5..d47ef03 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -35,6 +35,17 @@ Who:	Luis R. Rodriguez <lrodriguez@atheros.com>
 
 ---------------------------
 
+What:	AR9170USB
+When:	2.6.39
+
+Why:	This driver is deprecated and the firmware is no longer
+	maintained. The replacement driver "carl9170" has been
+	around for a while, so the devices are still supported.
+		
+Who:	Christian Lamparter <chunkeey@googlemail.com>
+
+---------------------------
+
 What:	IRQF_SAMPLE_RANDOM
 Check:	IRQF_SAMPLE_RANDOM
 When:	July 2009
diff --git a/MAINTAINERS b/MAINTAINERS
index 97a7841..1961669 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1205,7 +1205,7 @@ ATHEROS AR9170 WIRELESS DRIVER
 M:	Christian Lamparter <chunkeey@web.de>
 L:	linux-wireless@vger.kernel.org
 W:	http://wireless.kernel.org/en/users/Drivers/ar9170
-S:	Maintained
+S:	Obsolete
 F:	drivers/net/wireless/ath/ar9170/
 
 CARL9170 LINUX COMMUNITY WIRELESS DRIVER
diff --git a/drivers/net/wireless/ath/ar9170/Kconfig b/drivers/net/wireless/ath/ar9170/Kconfig
index d7a4799..7cfaf5f 100644
--- a/drivers/net/wireless/ath/ar9170/Kconfig
+++ b/drivers/net/wireless/ath/ar9170/Kconfig
@@ -1,8 +1,10 @@
 config AR9170_USB
-	tristate "Atheros AR9170 802.11n USB support"
+	tristate "Atheros AR9170 802.11n USB support (OBSOLETE)"
 	depends on USB && MAC80211
 	select FW_LOADER
 	help
+	  This driver is going to get replaced by carl9170. 
+
 	  This is a driver for the Atheros "otus" 802.11n USB devices.
 
 	  These devices require additional firmware (2 files).
