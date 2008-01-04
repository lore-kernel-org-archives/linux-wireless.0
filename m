Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:43863 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbYADQIQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jan 2008 11:08:16 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Add NPHY kconfig option
Date: Fri, 4 Jan 2008 17:06:29 +0100
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
MIME-Version: 1.0
Message-Id: <200801041706.29704.mb@bu3sch.de> (sfid-20080104_160823_429226_10816D7F)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a new Kconfig option for enabling probing of N-PHYs.
This option will be removed again once the stuff works.
For now it is to help in development. This way real users won't
execute the broken N-PHY codepaths, but the developers can easily
enable N-PHY stuff.

To enable N-PHY probing simply remove the BROKEN dependency
and enable the option in the kernel config.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

2.6.25 stuff.

Index: wireless-2.6/drivers/net/wireless/b43/Kconfig
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/Kconfig	2008-01-04 15:01:42.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/Kconfig	2008-01-04 16:59:38.000000000 +0100
@@ -61,6 +61,16 @@ config B43_PCMCIA
 
 	  If unsure, say N.
 
+config B43_NPHY
+	bool "Pre IEEE 802.11n support (BROKEN)"
+	depends on B43 && EXPERIMENTAL && BROKEN
+	---help---
+	  Support for the IEEE 802.11n draft.
+
+	  THIS IS BROKEN AND DOES NOT WORK YET.
+
+	  SAY N.
+
 # This config option automatically enables b43 LEDS support,
 # if it's possible.
 config B43_LEDS
Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c	2008-01-04 15:01:42.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/main.c	2008-01-04 16:57:24.000000000 +0100
@@ -81,6 +81,7 @@ static const struct ssb_device_id b43_ss
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 7),
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 9),
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 10),
+	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 11),
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 13),
 	SSB_DEVTABLE_END
 };
@@ -3097,6 +3098,12 @@ static int b43_phy_versioning(struct b43
 		if (phy_rev > 9)
 			unsupported = 1;
 		break;
+#ifdef CONFIG_B43_NPHY
+	case B43_PHYTYPE_N:
+		if (phy_rev > 1)
+			unsupported = 1;
+		break;
+#endif
 	default:
 		unsupported = 1;
 	};
