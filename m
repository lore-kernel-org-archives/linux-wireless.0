Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:2731 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751224Ab0DKMbZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Apr 2010 08:31:25 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 4/9] rt2x00: Refactor rt2800 version constants.
Date: Sun, 11 Apr 2010 14:31:10 +0200
Message-Id: <1270989075-2267-5-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1270989075-2267-1-git-send-email-gwingerde@gmail.com>
References: <1270989075-2267-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rt2800 version constants are inconsistent, and the version number don't
mean a lot of things anyway. Refactor the constants to have some more
meaningful names, and introduce and use some new helpers to check these
chipset revisions. At the same time rename to revision, as they are more
revision numbers rather than version numbers.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h    |   16 ++++++++++------
 drivers/net/wireless/rt2x00/rt2800lib.c |   30 ++++++++++--------------------
 drivers/net/wireless/rt2x00/rt2x00.h    |   22 ++++++++++++++++++++--
 3 files changed, 40 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 4d5871b..ec89372 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -59,13 +59,17 @@
 #define RF3320				0x000b
 
 /*
- * Chipset version.
- */
-#define RT2860C_VERSION			0x0100
-#define RT2860D_VERSION			0x0101
-#define RT2880E_VERSION			0x0200
-#define RT2883_VERSION			0x0300
-#define RT3070_VERSION			0x0200
+ * Chipset revisions.
+ */
+#define REV_RT2860C			0x0100
+#define REV_RT2860D			0x0101
+#define REV_RT2870D			0x0101
+#define REV_RT2872E			0x0200
+#define REV_RT3070E			0x0200
+#define REV_RT3070F			0x0201
+#define REV_RT3071E			0x0211
+#define REV_RT3090E			0x0211
+#define REV_RT3390E			0x0211
 
 /*
  * Signal information.
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 2ab8884..8a4ed76 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -896,8 +896,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field8(&bbp, BBP3_HT40_PLUS, conf_is_ht40_plus(conf));
 	rt2800_bbp_write(rt2x00dev, 3, bbp);
 
-	if (rt2x00_rt(rt2x00dev, RT2860) &&
-	    (rt2x00_rev(rt2x00dev) == RT2860C_VERSION)) {
+	if (rt2x00_rt_rev(rt2x00dev, RT2860, REV_RT2860C)) {
 		if (conf_is_ht40(conf)) {
 			rt2800_bbp_write(rt2x00dev, 69, 0x1a);
 			rt2800_bbp_write(rt2x00dev, 70, 0x0a);
@@ -1060,8 +1059,7 @@ static u8 rt2800_get_default_vgc(struct rt2x00_dev *rt2x00dev)
 {
 	if (rt2x00dev->curr_band == IEEE80211_BAND_2GHZ) {
 		if (rt2x00_is_usb(rt2x00dev) &&
-		    rt2x00_rt(rt2x00dev, RT3070) &&
-		    (rt2x00_rev(rt2x00dev) == RT3070_VERSION))
+		    rt2x00_rt_rev(rt2x00dev, RT3070, REV_RT3070E))
 			return 0x1c + (2 * rt2x00dev->lna_gain);
 		else
 			return 0x2e + rt2x00dev->lna_gain;
@@ -1092,8 +1090,7 @@ EXPORT_SYMBOL_GPL(rt2800_reset_tuner);
 void rt2800_link_tuner(struct rt2x00_dev *rt2x00dev, struct link_qual *qual,
 		       const u32 count)
 {
-	if (rt2x00_rt(rt2x00dev, RT2860) &&
-	    (rt2x00_rev(rt2x00dev) == RT2860C_VERSION))
+	if (rt2x00_rt_rev(rt2x00dev, RT2860, REV_RT2860C))
 		return;
 
 	/*
@@ -1179,8 +1176,7 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 
 	if (rt2x00_is_usb(rt2x00dev) &&
-	    rt2x00_rt(rt2x00dev, RT3070) &&
-	    (rt2x00_rev(rt2x00dev) == RT3070_VERSION)) {
+	    rt2x00_rt_rev(rt2x00dev, RT3070, REV_RT3070E)) {
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000400);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00000000);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
@@ -1207,11 +1203,9 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_register_read(rt2x00dev, MAX_LEN_CFG, &reg);
 	rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_MPDU, AGGREGATION_SIZE);
-	if ((rt2x00_rt(rt2x00dev, RT2872) &&
-	     (rt2x00_rev(rt2x00dev) >= RT2880E_VERSION)) ||
+	if (rt2x00_rt_rev_gte(rt2x00dev, RT2872, REV_RT2872E) ||
 	    rt2x00_rt(rt2x00dev, RT2883) ||
-	    (rt2x00_rt(rt2x00dev, RT3070) &&
-	     (rt2x00_rev(rt2x00dev) < RT3070_VERSION)))
+	    rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070E))
 		rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_PSDU, 2);
 	else
 		rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_PSDU, 1);
@@ -1490,14 +1484,12 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 103, 0x00);
 	rt2800_bbp_write(rt2x00dev, 105, 0x05);
 
-	if (rt2x00_rt(rt2x00dev, RT2860) &&
-	    (rt2x00_rev(rt2x00dev) == RT2860C_VERSION)) {
+	if (rt2x00_rt_rev(rt2x00dev, RT2860, REV_RT2860C)) {
 		rt2800_bbp_write(rt2x00dev, 69, 0x16);
 		rt2800_bbp_write(rt2x00dev, 73, 0x12);
 	}
 
-	if (rt2x00_rt(rt2x00dev, RT2860) &&
-	    (rt2x00_rev(rt2x00dev) > RT2860D_VERSION))
+	if (rt2x00_rt_rev_gte(rt2x00dev, RT2860, REV_RT2860D))
 		rt2800_bbp_write(rt2x00dev, 84, 0x19);
 
 	if (rt2x00_rt(rt2x00dev, RT2872)) {
@@ -1507,8 +1499,7 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	}
 
 	if (rt2x00_is_usb(rt2x00dev) &&
-	    rt2x00_rt(rt2x00dev, RT3070) &&
-	    (rt2x00_rev(rt2x00dev) == RT3070_VERSION)) {
+	    rt2x00_rt_rev(rt2x00dev, RT3070, REV_RT3070E)) {
 		rt2800_bbp_write(rt2x00dev, 70, 0x0a);
 		rt2800_bbp_write(rt2x00dev, 84, 0x99);
 		rt2800_bbp_write(rt2x00dev, 105, 0x05);
@@ -1594,8 +1585,7 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	u8 bbp;
 
 	if (rt2x00_is_usb(rt2x00dev) &&
-	    rt2x00_rt(rt2x00dev, RT3070) &&
-	    (rt2x00_rev(rt2x00dev) != RT3070_VERSION))
+	    !rt2x00_rt_rev(rt2x00dev, RT3070, REV_RT3070E))
 		return 0;
 
 	if (rt2x00_is_pci(rt2x00dev) || rt2x00_is_soc(rt2x00dev)) {
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 16aa850..4de505b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -929,12 +929,12 @@ static inline void rt2x00_set_chip(struct rt2x00_dev *rt2x00dev,
 	     rt2x00dev->chip.rt, rt2x00dev->chip.rf, rt2x00dev->chip.rev);
 }
 
-static inline char rt2x00_rt(struct rt2x00_dev *rt2x00dev, const u16 rt)
+static inline bool rt2x00_rt(struct rt2x00_dev *rt2x00dev, const u16 rt)
 {
 	return (rt2x00dev->chip.rt == rt);
 }
 
-static inline char rt2x00_rf(struct rt2x00_dev *rt2x00dev, const u16 rf)
+static inline bool rt2x00_rf(struct rt2x00_dev *rt2x00dev, const u16 rf)
 {
 	return (rt2x00dev->chip.rf == rf);
 }
@@ -944,6 +944,24 @@ static inline u16 rt2x00_rev(struct rt2x00_dev *rt2x00dev)
 	return rt2x00dev->chip.rev;
 }
 
+static inline bool rt2x00_rt_rev(struct rt2x00_dev *rt2x00dev,
+				 const u16 rt, const u16 rev)
+{
+	return (rt2x00_rt(rt2x00dev, rt) && rt2x00_rev(rt2x00dev) == rev);
+}
+
+static inline bool rt2x00_rt_rev_lt(struct rt2x00_dev *rt2x00dev,
+				    const u16 rt, const u16 rev)
+{
+	return (rt2x00_rt(rt2x00dev, rt) && rt2x00_rev(rt2x00dev) < rev);
+}
+
+static inline bool rt2x00_rt_rev_gte(struct rt2x00_dev *rt2x00dev,
+				     const u16 rt, const u16 rev)
+{
+	return (rt2x00_rt(rt2x00dev, rt) && rt2x00_rev(rt2x00dev) >= rev);
+}
+
 static inline void rt2x00_set_chip_intf(struct rt2x00_dev *rt2x00dev,
 					enum rt2x00_chip_intf intf)
 {
-- 
1.7.0.4

