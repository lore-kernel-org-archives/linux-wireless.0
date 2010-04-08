Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:1916 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932086Ab0DHVuq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 17:50:46 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville <linville"@tuxdriver.com
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 4/9] rt2x00: Remove rt2800 version constants.
Date: Thu,  8 Apr 2010 23:50:32 +0200
Message-Id: <1270763437-29526-5-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1270763437-29526-1-git-send-email-gwingerde@gmail.com>
References: <1270763437-29526-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rt2800 version constants are inconsistent, and the version number don't
mean a lot of things anyway. Use the literal values in the code instead of
some sort of fabricated version name macro.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h    |    9 ---------
 drivers/net/wireless/rt2x00/rt2800lib.c |   31 +++++++++++--------------------
 2 files changed, 11 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 455dc3f..de39d5c 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -59,15 +59,6 @@
 #define RF3320				0x000b
 
 /*
- * Chipset version.
- */
-#define RT2860C_VERSION			0x0100
-#define RT2860D_VERSION			0x0101
-#define RT2880E_VERSION			0x0200
-#define RT2883_VERSION			0x0300
-#define RT3070_VERSION			0x0200
-
-/*
  * Signal information.
  * Default offset is required for RSSI <-> dBm conversion.
  */
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 4bc7e09..d15b230 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -896,8 +896,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field8(&bbp, BBP3_HT40_PLUS, conf_is_ht40_plus(conf));
 	rt2800_bbp_write(rt2x00dev, 3, bbp);
 
-	if (rt2x00_rt(rt2x00dev, RT2860) &&
-	    (rt2x00_rev(rt2x00dev) == RT2860C_VERSION)) {
+	if (rt2x00_rt(rt2x00dev, RT2860) && rt2x00_rev(rt2x00dev) == 0x0100) {
 		if (conf_is_ht40(conf)) {
 			rt2800_bbp_write(rt2x00dev, 69, 0x1a);
 			rt2800_bbp_write(rt2x00dev, 70, 0x0a);
@@ -1061,7 +1060,7 @@ static u8 rt2800_get_default_vgc(struct rt2x00_dev *rt2x00dev)
 	if (rt2x00dev->curr_band == IEEE80211_BAND_2GHZ) {
 		if (rt2x00_is_usb(rt2x00dev) &&
 		    rt2x00_rt(rt2x00dev, RT3070) &&
-		    (rt2x00_rev(rt2x00dev) == RT3070_VERSION))
+		    rt2x00_rev(rt2x00dev) == 0x0200)
 			return 0x1c + (2 * rt2x00dev->lna_gain);
 		else
 			return 0x2e + rt2x00dev->lna_gain;
@@ -1092,8 +1091,7 @@ EXPORT_SYMBOL_GPL(rt2800_reset_tuner);
 void rt2800_link_tuner(struct rt2x00_dev *rt2x00dev, struct link_qual *qual,
 		       const u32 count)
 {
-	if (rt2x00_rt(rt2x00dev, RT2860) &&
-	    (rt2x00_rev(rt2x00dev) == RT2860C_VERSION))
+	if (rt2x00_rt(rt2x00dev, RT2860) && rt2x00_rev(rt2x00dev) == 0x0100)
 		return;
 
 	/*
@@ -1179,8 +1177,7 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 
 	if (rt2x00_is_usb(rt2x00dev) &&
-	    rt2x00_rt(rt2x00dev, RT3070) &&
-	    (rt2x00_rev(rt2x00dev) == RT3070_VERSION)) {
+	    rt2x00_rt(rt2x00dev, RT3070) && rt2x00_rev(rt2x00dev) == 0x0200) {
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000400);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00000000);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
@@ -1207,11 +1204,9 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_register_read(rt2x00dev, MAX_LEN_CFG, &reg);
 	rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_MPDU, AGGREGATION_SIZE);
-	if ((rt2x00_rt(rt2x00dev, RT2872) &&
-	     (rt2x00_rev(rt2x00dev) >= RT2880E_VERSION)) ||
+	if ((rt2x00_rt(rt2x00dev, RT2872) && rt2x00_rev(rt2x00dev) >= 0x0200) ||
 	    rt2x00_rt(rt2x00dev, RT2883) ||
-	    (rt2x00_rt(rt2x00dev, RT3070) &&
-	     (rt2x00_rev(rt2x00dev) < RT3070_VERSION)))
+	    (rt2x00_rt(rt2x00dev, RT3070) && rt2x00_rev(rt2x00dev) < 0x0200))
 		rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_PSDU, 2);
 	else
 		rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_PSDU, 1);
@@ -1490,19 +1485,16 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 103, 0x00);
 	rt2800_bbp_write(rt2x00dev, 105, 0x05);
 
-	if (rt2x00_rt(rt2x00dev, RT2860) &&
-	    (rt2x00_rev(rt2x00dev) == RT2860C_VERSION)) {
+	if (rt2x00_rt(rt2x00dev, RT2860) && rt2x00_rev(rt2x00dev) == 0x0100) {
 		rt2800_bbp_write(rt2x00dev, 69, 0x16);
 		rt2800_bbp_write(rt2x00dev, 73, 0x12);
 	}
 
-	if (rt2x00_rt(rt2x00dev, RT2860) &&
-	    (rt2x00_rev(rt2x00dev) > RT2860D_VERSION))
+	if (rt2x00_rt(rt2x00dev, RT2860) && rt2x00_rev(rt2x00dev) > 0x0101)
 		rt2800_bbp_write(rt2x00dev, 84, 0x19);
 
 	if (rt2x00_is_usb(rt2x00dev) &&
-	    rt2x00_rt(rt2x00dev, RT3070) &&
-	    (rt2x00_rev(rt2x00dev) == RT3070_VERSION)) {
+	    rt2x00_rt(rt2x00dev, RT3070) && rt2x00_rev(rt2x00dev) == 0x0200) {
 		rt2800_bbp_write(rt2x00dev, 70, 0x0a);
 		rt2800_bbp_write(rt2x00dev, 84, 0x99);
 		rt2800_bbp_write(rt2x00dev, 105, 0x05);
@@ -1588,8 +1580,7 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	u8 bbp;
 
 	if (rt2x00_is_usb(rt2x00dev) &&
-	    rt2x00_rt(rt2x00dev, RT3070) &&
-	    (rt2x00_rev(rt2x00dev) != RT3070_VERSION))
+	    rt2x00_rt(rt2x00dev, RT3070) && rt2x00_rev(rt2x00dev) != 0x0200)
 		return 0;
 
 	if (rt2x00_is_pci(rt2x00dev) || rt2x00_is_soc(rt2x00dev)) {
@@ -1764,7 +1755,7 @@ int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 		   rt2x00_rt(rt2x00dev, RT2870) ||
 		   rt2x00_rt(rt2x00dev, RT2872) ||
 		   (rt2x00_rt(rt2x00dev, RT2883) &&
-		    (rt2x00_rev(rt2x00dev) < RT2883_VERSION))) {
+		    rt2x00_rev(rt2x00dev) < 0x0300)) {
 		/*
 		 * There is a max of 2 RX streams for RT28x0 series
 		 */
-- 
1.7.0.4

