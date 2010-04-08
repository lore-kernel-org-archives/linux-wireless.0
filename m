Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:1978 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932949Ab0DHVus (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 17:50:48 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville <linville"@tuxdriver.com
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 3/9] rt2x00: Align RT chipset definitions with vendor driver.
Date: Thu,  8 Apr 2010 23:50:31 +0200
Message-Id: <1270763437-29526-4-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1270763437-29526-1-git-send-email-gwingerde@gmail.com>
References: <1270763437-29526-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only include definitions for RT chipsets that are also used inside the
Ralink vendor drivers.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   13 -------------
 drivers/net/wireless/rt2x00/rt2x00.h    |    7 +++----
 2 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 394c8e4..4bc7e09 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1209,10 +1209,7 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_MPDU, AGGREGATION_SIZE);
 	if ((rt2x00_rt(rt2x00dev, RT2872) &&
 	     (rt2x00_rev(rt2x00dev) >= RT2880E_VERSION)) ||
-	    rt2x00_rt(rt2x00dev, RT2880) ||
 	    rt2x00_rt(rt2x00dev, RT2883) ||
-	    rt2x00_rt(rt2x00dev, RT2890) ||
-	    rt2x00_rt(rt2x00dev, RT3052) ||
 	    (rt2x00_rt(rt2x00dev, RT3070) &&
 	     (rt2x00_rev(rt2x00dev) < RT3070_VERSION)))
 		rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_PSDU, 2);
@@ -1511,12 +1508,6 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		rt2800_bbp_write(rt2x00dev, 105, 0x05);
 	}
 
-	if (rt2x00_rt(rt2x00dev, RT3052)) {
-		rt2800_bbp_write(rt2x00dev, 31, 0x08);
-		rt2800_bbp_write(rt2x00dev, 78, 0x0e);
-		rt2800_bbp_write(rt2x00dev, 80, 0x08);
-	}
-
 	for (i = 0; i < EEPROM_BBP_SIZE; i++) {
 		rt2x00_eeprom_read(rt2x00dev, EEPROM_BBP_START + i, &eeprom);
 
@@ -1772,7 +1763,6 @@ int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 	} else if (rt2x00_rt(rt2x00dev, RT2860) ||
 		   rt2x00_rt(rt2x00dev, RT2870) ||
 		   rt2x00_rt(rt2x00dev, RT2872) ||
-		   rt2x00_rt(rt2x00dev, RT2880) ||
 		   (rt2x00_rt(rt2x00dev, RT2883) &&
 		    (rt2x00_rev(rt2x00dev) < RT2883_VERSION))) {
 		/*
@@ -1879,10 +1869,7 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	if (!rt2x00_rt(rt2x00dev, RT2860) &&
 	    !rt2x00_rt(rt2x00dev, RT2870) &&
 	    !rt2x00_rt(rt2x00dev, RT2872) &&
-	    !rt2x00_rt(rt2x00dev, RT2880) &&
 	    !rt2x00_rt(rt2x00dev, RT2883) &&
-	    !rt2x00_rt(rt2x00dev, RT2890) &&
-	    !rt2x00_rt(rt2x00dev, RT3052) &&
 	    !rt2x00_rt(rt2x00dev, RT3070) &&
 	    !rt2x00_rt(rt2x00dev, RT3071) &&
 	    !rt2x00_rt(rt2x00dev, RT3090) &&
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index d9daa9c..16aa850 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -177,16 +177,15 @@ struct rt2x00_chip {
 #define RT2573		0x2573
 #define RT2860		0x2860	/* 2.4GHz PCI/CB */
 #define RT2870		0x2870
-#define RT2872		0x2872
-#define RT2880		0x2880	/* WSOC */
+#define RT2872		0x2872	/* WSOC */
 #define RT2883		0x2883	/* WSOC */
-#define RT2890		0x2890	/* 2.4GHz PCIe */
-#define RT3052		0x3052	/* WSOC */
 #define RT3070		0x3070
 #define RT3071		0x3071
 #define RT3090		0x3090	/* 2.4GHz PCIe */
 #define RT3390		0x3390
 #define RT3572		0x3572
+#define RT3593		0x3593	/* PCIe */
+#define RT3883		0x3883	/* WSOC */
 
 	u16 rf;
 	u16 rev;
-- 
1.7.0.4

