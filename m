Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:22582 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624AbXHSScR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 14:32:17 -0400
Received: by ug-out-1314.google.com with SMTP id j3so446922ugf
        for <linux-wireless@vger.kernel.org>; Sun, 19 Aug 2007 11:32:16 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 26/30] rt2x00: Clean up RATEMASK handling
Date: Sun, 19 Aug 2007 20:36:05 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200708192018.30624.IvDoorn@gmail.com>
In-Reply-To: <200708192018.30624.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708192036.05318.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 295b7e7bc2a2081714a071c3946f1c0262b6e503 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 18 Aug 2007 16:31:38 +0200
Subject: [PATCH 26/30] rt2x00: Clean up RATEMASK handling

Rate handling needs some cleaning up to
clear up the meaning of the variables.

- Rename DEV_RATE_* to DEV_RATEBIT_*
- Add DEV_RATEMASK_* to remove "magical values" passed to
  rt2x00lib_rate
- CCK_RATEMASK is alias for DEV_RATEMASK_11MB
- OFDM_RATEMASK is alias for DEV_RATE_MASK_54MB - CCK_RATEMASK

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt2500pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt2500usb.c |    2 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c |   44 ++++++++++++++----------
 drivers/net/wireless/rt2x00/rt2x00reg.h |   56 +++++++++++++++++++------------
 drivers/net/wireless/rt2x00/rt61pci.c   |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c   |    2 +-
 7 files changed, 64 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index b851571..524f529 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -366,7 +366,7 @@ static void rt2400pci_config_rate(struct rt2x00_dev *rt2x00dev, const int rate)
 	else
 		preamble = PREAMBLE;
 
-	reg = DEVICE_GET_RATE_FIELD(rate, RATEMASK) & DEV_BASIC_RATE;
+	reg = DEVICE_GET_RATE_FIELD(rate, RATEMASK) & DEV_BASIC_RATEMASK;
 	rt2x00pci_register_write(rt2x00dev, ARCSR1, reg);
 
 	rt2x00pci_register_read(rt2x00dev, TXCSR1, &reg);
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 1000525..cc90597 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -374,7 +374,7 @@ static void rt2500pci_config_rate(struct rt2x00_dev *rt2x00dev, const int rate)
 	else
 		preamble = PREAMBLE;
 
-	reg = DEVICE_GET_RATE_FIELD(rate, RATEMASK) & DEV_BASIC_RATE;
+	reg = DEVICE_GET_RATE_FIELD(rate, RATEMASK) & DEV_BASIC_RATEMASK;
 	rt2x00pci_register_write(rt2x00dev, ARCSR1, reg);
 
 	rt2x00pci_register_read(rt2x00dev, TXCSR1, &reg);
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 9ece4af..ba6c099 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -383,7 +383,7 @@ static void rt2500usb_config_rate(struct rt2x00_dev *rt2x00dev, const int rate)
 	else
 		preamble = PREAMBLE;
 
-	reg = DEVICE_GET_RATE_FIELD(rate, RATEMASK) & DEV_BASIC_RATE;
+	reg = DEVICE_GET_RATE_FIELD(rate, RATEMASK) & DEV_BASIC_RATEMASK;
 
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR11, reg);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index a0fcd05..8e7fc2a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -449,7 +449,7 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Check for OFDM
 	 */
-	if (DEVICE_GET_RATE_FIELD(tx_rate, RATEMASK) & DEV_OFDM_RATE)
+	if (DEVICE_GET_RATE_FIELD(tx_rate, RATEMASK) & DEV_OFDM_RATEMASK)
 		__set_bit(ENTRY_TXD_OFDM_RATE, &entry->flags);
 
 	/*
@@ -587,26 +587,32 @@ static int rt2x00lib_probe_hw_modes(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Initialize Rate list.
 	 */
-	rt2x00lib_rate(&rates[0], 10, 0x001, 0x00, IEEE80211_RATE_CCK);
-	rt2x00lib_rate(&rates[1], 20, 0x003, 0x01, IEEE80211_RATE_CCK_2);
-	rt2x00lib_rate(&rates[2], 55, 0x007, 0x02, IEEE80211_RATE_CCK_2);
-	rt2x00lib_rate(&rates[3], 110, 0x00f, 0x03, IEEE80211_RATE_CCK_2);
+	rt2x00lib_rate(&rates[0], 10, DEV_RATEMASK_1MB,
+		       0x00, IEEE80211_RATE_CCK);
+	rt2x00lib_rate(&rates[1], 20, DEV_RATEMASK_2MB,
+		       0x01, IEEE80211_RATE_CCK_2);
+	rt2x00lib_rate(&rates[2], 55, DEV_RATEMASK_5_5MB,
+		       0x02, IEEE80211_RATE_CCK_2);
+	rt2x00lib_rate(&rates[3], 110, DEV_RATEMASK_11MB,
+		       0x03, IEEE80211_RATE_CCK_2);
 
 	if (spec->num_rates > 4) {
-		rt2x00lib_rate(&rates[4], 60, 0x01f, 0x0b, IEEE80211_RATE_OFDM);
-		rt2x00lib_rate(&rates[5], 90, 0x03f, 0x0f, IEEE80211_RATE_OFDM);
-		rt2x00lib_rate(&rates[6], 120, 0x07f, 0x0a,
-			       IEEE80211_RATE_OFDM);
-		rt2x00lib_rate(&rates[7], 180, 0x0ff, 0x0e,
-			       IEEE80211_RATE_OFDM);
-		rt2x00lib_rate(&rates[8], 240, 0x1ff, 0x09,
-			       IEEE80211_RATE_OFDM);
-		rt2x00lib_rate(&rates[9], 360, 0x3ff, 0x0d,
-			       IEEE80211_RATE_OFDM);
-		rt2x00lib_rate(&rates[10], 480, 0x7ff, 0x08,
-			       IEEE80211_RATE_OFDM);
-		rt2x00lib_rate(&rates[11], 540, 0xfff, 0x0c,
-			       IEEE80211_RATE_OFDM);
+		rt2x00lib_rate(&rates[4], 60, DEV_RATEMASK_6MB,
+			       0x0b, IEEE80211_RATE_OFDM);
+		rt2x00lib_rate(&rates[5], 90, DEV_RATEMASK_9MB,
+			       0x0f, IEEE80211_RATE_OFDM);
+		rt2x00lib_rate(&rates[6], 120, DEV_RATEMASK_12MB,
+			       0x0a, IEEE80211_RATE_OFDM);
+		rt2x00lib_rate(&rates[7], 180, DEV_RATEMASK_18MB,
+			       0x0e, IEEE80211_RATE_OFDM);
+		rt2x00lib_rate(&rates[8], 240, DEV_RATEMASK_24MB,
+			       0x09, IEEE80211_RATE_OFDM);
+		rt2x00lib_rate(&rates[9], 360, DEV_RATEMASK_36MB,
+			       0x0d, IEEE80211_RATE_OFDM);
+		rt2x00lib_rate(&rates[10], 480, DEV_RATEMASK_48MB,
+			       0x08, IEEE80211_RATE_OFDM);
+		rt2x00lib_rate(&rates[11], 540, DEV_RATEMASK_54MB,
+			       0x0c, IEEE80211_RATE_OFDM);
 	}
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
index 10a4a42..690356f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00reg.h
+++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
@@ -228,34 +228,46 @@ static inline u8 rt2x00_get_field8(const u8 reg,
 #define DEV_PLCP	FIELD32(0xff000000)
 
 /*
- * Bitmask for MASK_RATE
+ * Bitfields
  */
-#define DEV_RATE_1MB	( 1 << 1 )
-#define DEV_RATE_2MB	( 1 << 2 )
-#define DEV_RATE_5_5MB	( 1 << 3 )
-#define DEV_RATE_11MB	( 1 << 4 )
-#define DEV_RATE_6MB	( 1 << 5 )
-#define DEV_RATE_9MB	( 1 << 6 )
-#define DEV_RATE_12MB	( 1 << 7 )
-#define DEV_RATE_18MB	( 1 << 8 )
-#define DEV_RATE_24MB	( 1 << 9 )
-#define DEV_RATE_36MB	( 1 << 10 )
-#define DEV_RATE_48MB	( 1 << 11 )
-#define DEV_RATE_54MB	( 1 << 12 )
+#define DEV_RATEBIT_1MB		( 1 << 1 )
+#define DEV_RATEBIT_2MB		( 1 << 2 )
+#define DEV_RATEBIT_5_5MB	( 1 << 3 )
+#define DEV_RATEBIT_11MB	( 1 << 4 )
+#define DEV_RATEBIT_6MB		( 1 << 5 )
+#define DEV_RATEBIT_9MB		( 1 << 6 )
+#define DEV_RATEBIT_12MB	( 1 << 7 )
+#define DEV_RATEBIT_18MB	( 1 << 8 )
+#define DEV_RATEBIT_24MB	( 1 << 9 )
+#define DEV_RATEBIT_36MB	( 1 << 10 )
+#define DEV_RATEBIT_48MB	( 1 << 11 )
+#define DEV_RATEBIT_54MB	( 1 << 12 )
 
 /*
- * Bitmask groups of bitrates
+ * Bitmasks for DEV_RATEMASK
  */
-#define DEV_BASIC_RATE \
-	( DEV_RATE_1MB | DEV_RATE_2MB | DEV_RATE_5_5MB | DEV_RATE_11MB | \
-	  DEV_RATE_6MB | DEV_RATE_12MB | DEV_RATE_24MB )
+#define DEV_RATEMASK_1MB	( (DEV_RATEBIT_1MB << 1) -1 )
+#define DEV_RATEMASK_2MB	( (DEV_RATEBIT_2MB << 1) -1 )
+#define DEV_RATEMASK_5_5MB	( (DEV_RATEBIT_5_5MB << 1) -1 )
+#define DEV_RATEMASK_11MB	( (DEV_RATEBIT_11MB << 1) -1 )
+#define DEV_RATEMASK_6MB	( (DEV_RATEBIT_6MB << 1) -1 )
+#define DEV_RATEMASK_9MB	( (DEV_RATEBIT_9MB << 1) -1 )
+#define DEV_RATEMASK_12MB	( (DEV_RATEBIT_12MB << 1) -1 )
+#define DEV_RATEMASK_18MB	( (DEV_RATEBIT_18MB << 1) -1 )
+#define DEV_RATEMASK_24MB	( (DEV_RATEBIT_24MB << 1) -1 )
+#define DEV_RATEMASK_36MB	( (DEV_RATEBIT_36MB << 1) -1 )
+#define DEV_RATEMASK_48MB	( (DEV_RATEBIT_48MB << 1) -1 )
+#define DEV_RATEMASK_54MB	( (DEV_RATEBIT_54MB << 1) -1 )
 
-#define DEV_CCK_RATE \
-	( DEV_RATE_1MB | DEV_RATE_2MB | DEV_RATE_5_5MB | DEV_RATE_11MB )
+/*
+ * Bitmask groups of bitrates
+ */
+#define DEV_BASIC_RATEMASK \
+	( DEV_RATEMASK_11MB | \
+	  DEV_RATEBIT_6MB | DEV_RATEBIT_12MB | DEV_RATEBIT_24MB )
 
-#define DEV_OFDM_RATE \
-	( DEV_RATE_6MB | DEV_RATE_9MB | DEV_RATE_12MB | DEV_RATE_18MB | \
-	  DEV_RATE_24MB | DEV_RATE_36MB | DEV_RATE_48MB | DEV_RATE_54MB )
+#define DEV_CCK_RATEMASK	( DEV_RATEMASK_11MB )
+#define DEV_OFDM_RATEMASK	( DEV_RATEMASK_54MB & ~DEV_CCK_RATEMASK )
 
 /*
  * Macro's to set and get specific fields from the device specific val and val2
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index efa6c25..0dacd59 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -404,7 +404,7 @@ static void rt61pci_config_rate(struct rt2x00_dev *rt2x00dev, const int rate)
 	 * We need to set TXRX_CSR5 to the basic rate mask so we need to mask
 	 * off the non-basic rates.
 	 */
-	reg = DEVICE_GET_RATE_FIELD(rate, RATEMASK) & DEV_BASIC_RATE;
+	reg = DEVICE_GET_RATE_FIELD(rate, RATEMASK) & DEV_BASIC_RATEMASK;
 
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR5, reg);
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 9e8c049..7eb1f02 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -380,7 +380,7 @@ static void rt73usb_config_rate(struct rt2x00_dev *rt2x00dev, const int rate)
 	else
 		preamble = PREAMBLE;
 
-	reg = DEVICE_GET_RATE_FIELD(rate, RATEMASK) & DEV_BASIC_RATE;
+	reg = DEVICE_GET_RATE_FIELD(rate, RATEMASK) & DEV_BASIC_RATEMASK;
 
 	rt73usb_register_write(rt2x00dev, TXRX_CSR5, reg);
 
-- 
1.5.3.rc5

