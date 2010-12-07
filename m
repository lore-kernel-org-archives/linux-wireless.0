Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40847 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab0LGU46 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 15:56:58 -0500
Received: by wwa36 with SMTP id 36so369994wwa.1
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 12:56:57 -0800 (PST)
From: =?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 4/4] b43: rename config option for N-PHY, drop BROKEN
Date: Tue,  7 Dec 2010 21:56:00 +0100
Message-Id: <1291755360-21570-5-git-send-email-zajec5@gmail.com>
In-Reply-To: <1291755360-21570-1-git-send-email-zajec5@gmail.com>
References: <1291755360-21570-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/Kconfig      |   13 +++++++------
 drivers/net/wireless/b43/Makefile     |    8 ++++----
 drivers/net/wireless/b43/main.c       |    4 ++--
 drivers/net/wireless/b43/phy_common.c |    2 +-
 4 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index 0a00d42..47033f6 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -86,15 +86,16 @@ config B43_PIO
 	select SSB_BLOCKIO
 	default y
 
-config B43_NPHY
-	bool "Pre IEEE 802.11n support (BROKEN)"
-	depends on B43 && EXPERIMENTAL && BROKEN
+config B43_PHY_N
+	bool "Support for 802.11n (N-PHY) devices (EXPERIMENTAL)"
+	depends on B43 && EXPERIMENTAL
 	---help---
-	  Support for the IEEE 802.11n draft.
+	  Support for the N-PHY.
 
-	  THIS IS BROKEN AND DOES NOT WORK YET.
+	  This enables support for devices with N-PHY revision up to 2.
 
-	  SAY N.
+	  Say N if you expect high stability and performance. Saying Y will not
+	  affect other devices support and may provide support for basic needs.
 
 config B43_PHY_LP
 	bool "Support for low-power (LP-PHY) devices (EXPERIMENTAL)"
diff --git a/drivers/net/wireless/b43/Makefile b/drivers/net/wireless/b43/Makefile
index 69d4af0..cef334a 100644
--- a/drivers/net/wireless/b43/Makefile
+++ b/drivers/net/wireless/b43/Makefile
@@ -1,12 +1,12 @@
 b43-y				+= main.o
 b43-y				+= tables.o
-b43-$(CONFIG_B43_NPHY)		+= tables_nphy.o
-b43-$(CONFIG_B43_NPHY)		+= radio_2055.o
-b43-$(CONFIG_B43_NPHY)		+= radio_2056.o
+b43-$(CONFIG_B43_PHY_N)		+= tables_nphy.o
+b43-$(CONFIG_B43_PHY_N)		+= radio_2055.o
+b43-$(CONFIG_B43_PHY_N)		+= radio_2056.o
 b43-y				+= phy_common.o
 b43-y				+= phy_g.o
 b43-y				+= phy_a.o
-b43-$(CONFIG_B43_NPHY)		+= phy_n.o
+b43-$(CONFIG_B43_PHY_N)		+= phy_n.o
 b43-$(CONFIG_B43_PHY_LP)	+= phy_lp.o
 b43-$(CONFIG_B43_PHY_LP)	+= tables_lpphy.o
 b43-y				+= sysfs.o
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 4d97aac..9ae3f61 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4052,7 +4052,7 @@ static int b43_phy_versioning(struct b43_wldev *dev)
 		if (phy_rev > 9)
 			unsupported = 1;
 		break;
-#ifdef CONFIG_B43_NPHY
+#ifdef CONFIG_B43_PHY_N
 	case B43_PHYTYPE_N:
 		if (phy_rev > 2)
 			unsupported = 1;
@@ -5097,7 +5097,7 @@ static void b43_print_driverinfo(void)
 #ifdef CONFIG_B43_PCMCIA
 	feat_pcmcia = "M";
 #endif
-#ifdef CONFIG_B43_NPHY
+#ifdef CONFIG_B43_PHY_N
 	feat_nphy = "N";
 #endif
 #ifdef CONFIG_B43_LEDS
diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index 412f1b6..b5c5ce9 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -50,7 +50,7 @@ int b43_phy_allocate(struct b43_wldev *dev)
 		phy->ops = &b43_phyops_g;
 		break;
 	case B43_PHYTYPE_N:
-#ifdef CONFIG_B43_NPHY
+#ifdef CONFIG_B43_PHY_N
 		phy->ops = &b43_phyops_n;
 #endif
 		break;
-- 
1.6.3.3

