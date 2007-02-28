Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:48611 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932429AbXB1OHN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 09:07:13 -0500
Received: by nf-out-0910.google.com with SMTP id o25so562551nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 06:07:12 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 26/28] rt2x00: Fix rt2500usb linktuning
Date: Wed, 28 Feb 2007 15:07:06 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702281507.06834.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use EEPROM information to correctly work with the link tuning
for rt2500usb. This improves link stability/quality.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
index 20e321e..32dcc06 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -722,13 +722,18 @@ static void rt2500usb_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *addr)
  */
 static void rt2500usb_link_tuner(struct work_struct *work)
 {
-	struct link *link =
-		container_of(work, struct link, work.work);
 	struct rt2x00_dev *rt2x00dev =
-		container_of(link, struct rt2x00_dev, link);
-	u16 reg;
+		container_of(work, struct rt2x00_dev, link.work.work);
 	u32 rssi;
-	u8 reg_r17;
+	u16 cca_alarm;
+	u16 bbp_thresh;
+	u16 reg_r24;
+	u16 reg_r25;
+	u16 reg_r61;
+	u16 reg_r17;
+	u16 vgc_bound;
+	u8 bbp_r17;
+	u8 sens;
 	u8 up_bound;
 	u8 low_bound;
 
@@ -746,57 +751,67 @@ static void rt2500usb_link_tuner(struct work_struct *work)
 	if (!rssi)
 		goto exit;
 
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_BBPTUNE, &bbp_thresh);
+	bbp_thresh = eeprom_valid(bbp_thresh, 75, EEPROM_BBPTUNE_THRESHOLD);
+
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_BBPTUNE_R24, &reg_r24);
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_BBPTUNE_R25, &reg_r25);
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_BBPTUNE_R61, &reg_r61);
+
+	if (rssi > bbp_thresh) {
+		reg_r24 = eeprom_valid(reg_r24, 0x70, EEPROM_BBPTUNE_R24_HIGH);
+		reg_r25 = eeprom_valid(reg_r25, 0x40, EEPROM_BBPTUNE_R25_HIGH);
+		reg_r61 = eeprom_valid(reg_r61, 0x6d, EEPROM_BBPTUNE_R61_HIGH);
+	} else {
+		reg_r24 = eeprom_valid(reg_r24, 0x80, EEPROM_BBPTUNE_R24_LOW);
+		reg_r25 = eeprom_valid(reg_r25, 0x50, EEPROM_BBPTUNE_R25_LOW);
+		reg_r61 = eeprom_valid(reg_r61, 0x60, EEPROM_BBPTUNE_R61_LOW);
+	}
+
+	rt2x00_bbp_write(rt2x00dev, 24, reg_r24);
+	rt2x00_bbp_write(rt2x00dev, 25, reg_r25);
+	rt2x00_bbp_write(rt2x00dev, 61, reg_r61);
+
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_BBPTUNE_VGC, &vgc_bound);
+	vgc_bound = eeprom_valid(vgc_bound, 0x40, EEPROM_BBPTUNE_VGCUPPER);
+
 	low_bound = 0x32;
 	if (rssi >= 43)
-		up_bound = 0x40;
+		up_bound = vgc_bound;
 	else
-		up_bound = 0x40 - (43 - rssi);
+		up_bound = vgc_bound - (43 - rssi);
 	if (up_bound < low_bound)
 		up_bound = low_bound;
 
-	if (rssi > 75) {
-		rt2x00_bbp_write(rt2x00dev, 24, 0x70);
-		rt2x00_bbp_write(rt2x00dev, 25, 0x40);
-		rt2x00_bbp_write(rt2x00dev, 61, 0x6d);
-	} else {
-		rt2x00_bbp_write(rt2x00dev, 24, 0x80);
-		rt2x00_bbp_write(rt2x00dev, 25, 0x50);
-		rt2x00_bbp_write(rt2x00dev, 61, 0x60);
+	rt2x00_bbp_read(rt2x00dev, 17, &bbp_r17);
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_BBPTUNE_R17, &reg_r17);
+
+	sens = bbp_r17;
+
+	if (rssi > 80)
+		sens = 0x60;
+	else if (rssi >= 62)
+		sens = eeprom_valid(reg_r17, 0x48, EEPROM_BBPTUNE_R17_HIGH);
+	else if (rssi >= 46)
+		sens = eeprom_valid(reg_r17, 0x41, EEPROM_BBPTUNE_R17_LOW);
+	else if (bbp_r17 > up_bound)
+		sens = up_bound;
+	else {
+		rt2x00_register_read(rt2x00dev, STA_CSR3, &cca_alarm);
+		if (cca_alarm > 512 && bbp_r17 < up_bound)
+			sens = bbp_r17 + 1;
+		else if (cca_alarm < 100 && bbp_r17 > low_bound)
+			sens = bbp_r17 - 1;
 	}
 
-	rt2x00_bbp_read(rt2x00dev, 17, &reg_r17);
+	rt2x00_bbp_write(rt2x00dev, 17, sens);
 
-	if (rssi > 80) {
-		if (reg_r17 != 0x60)
-			rt2x00_bbp_write(rt2x00dev, 17, 0x60);
-		goto exit;
-	} else if (rssi >= 62) {
-		if (reg_r17 != 0x48)
-			rt2x00_bbp_write(rt2x00dev, 17, 0x48);
-		goto exit;
-	} else if (rssi >= 46) {
-		if (reg_r17 != 0x41)
-			rt2x00_bbp_write(rt2x00dev, 17, 0x41);
-		goto exit;
-	} else if (reg_r17 > up_bound) {
-		rt2x00_bbp_write(rt2x00dev, 17, up_bound);
-		goto exit;
-	}
-
-	rt2x00_register_read(rt2x00dev, STA_CSR3, &reg);
-
-	if (reg > 512 && reg_r17 < up_bound)
-		rt2x00_bbp_write(rt2x00dev, 17, ++reg_r17);
-	else if (reg < 100 && reg_r17 > low_bound)
-		rt2x00_bbp_write(rt2x00dev, 17, --reg_r17);
-
-exit:
 	/*
 	 * Update noise statistics.
 	 */
-	if (reg_r17)
-		rt2x00_update_link_noise(&rt2x00dev->link, reg_r17);
+	rt2x00_update_link_noise(&rt2x00dev->link, bbp_r17);
 
+exit:
 	queue_delayed_work(rt2x00dev->workqueue, &rt2x00dev->link.work,
 		LINK_TUNE_INTERVAL);
 }
@@ -1160,6 +1175,22 @@ continue_csr_init:
 	}
 	DEBUG("...End initialization from EEPROM.\n");
 
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_BBPTUNE_R24, &eeprom);
+	value = eeprom_valid(eeprom, 0x80, EEPROM_BBPTUNE_R24_LOW);
+	rt2x00_bbp_write(rt2x00dev, 24, value);
+
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_BBPTUNE_R25, &eeprom);
+	value = eeprom_valid(eeprom, 0x50, EEPROM_BBPTUNE_R25_LOW);
+	rt2x00_bbp_write(rt2x00dev, 25, value);
+
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_BBPTUNE_R61, &eeprom);
+	value = eeprom_valid(eeprom, 0x60, EEPROM_BBPTUNE_R61_LOW);
+	rt2x00_bbp_write(rt2x00dev, 61, value);
+
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_BBPTUNE_VGC, &eeprom);
+	value = eeprom_valid(eeprom, 0x40, EEPROM_BBPTUNE_VGCUPPER);
+	rt2x00_bbp_write(rt2x00dev, 17, value);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h
index ffedfee..4cb05e5 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h
@@ -561,6 +561,46 @@
 #define EEPROM_TXPOWER_2		FIELD16(0xff00)
 
 /*
+ * EEPROM Tuning threshold
+ */
+#define EEPROM_BBPTUNE			0x0030
+#define EEPROM_BBPTUNE_THRESHOLD	FIELD16(0x00ff)
+
+/*
+ * EEPROM BBP R24 Tuning.
+ */
+#define EEPROM_BBPTUNE_R24		0x0031
+#define EEPROM_BBPTUNE_R24_LOW		FIELD16(0x00ff)
+#define EEPROM_BBPTUNE_R24_HIGH		FIELD16(0xff00)
+
+/*
+ * EEPROM BBP R25 Tuning.
+ */
+#define EEPROM_BBPTUNE_R25		0x0032
+#define EEPROM_BBPTUNE_R25_LOW		FIELD16(0x00ff)
+#define EEPROM_BBPTUNE_R25_HIGH		FIELD16(0xff00)
+
+/*
+ * EEPROM BBP R24 Tuning.
+ */
+#define EEPROM_BBPTUNE_R61		0x0033
+#define EEPROM_BBPTUNE_R61_LOW		FIELD16(0x00ff)
+#define EEPROM_BBPTUNE_R61_HIGH		FIELD16(0xff00)
+
+/*
+ * EEPROM BBP VGC Tuning.
+ */
+#define EEPROM_BBPTUNE_VGC		0x0034
+#define EEPROM_BBPTUNE_VGCUPPER		FIELD16(0x00ff)
+
+/*
+ * EEPROM BBP R17 Tuning.
+ */
+#define EEPROM_BBPTUNE_R17		0x0035
+#define EEPROM_BBPTUNE_R17_LOW		FIELD16(0x00ff)
+#define EEPROM_BBPTUNE_R17_HIGH		FIELD16(0xff00)
+
+/*
  * RSSI <-> dBm offset calibration
  */
 #define EEPROM_CALIBRATE_OFFSET		0x0036
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
index 0d47a41..bd15702 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
@@ -1220,4 +1220,20 @@ static inline u16 get_duration_res(const unsigned int size, const u8 rate)
 	return ((size * 8 * 10) % rate);
 }
 
+/*
+ * Helper define for accessing eeprom data that should be
+ * validated before usage. When the eeprom is invalid the
+ * default value will be returned.
+ */
+#define eeprom_valid(__word, __def, __val)				\
+	({								\
+		u16 __retval;						\
+		if ((__word) == 0xffff || (__word) == 0x0000)		\
+			__retval = (__def);				\
+		else							\
+			__retval = rt2x00_get_field16(			\
+				(__word), (__val));			\
+		__retval;						\
+	})
+
 #endif /* RT2X00_H */
