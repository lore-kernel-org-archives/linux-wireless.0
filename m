Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52710 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751077AbdBOJaK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 04:30:10 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>, Gabor Juhos <juhosg@openwrt.org>,
        Daniel Golle <daniel@makrotopia.org>
Subject: [PATCH v2 01/10] rt2x00: rt2800lib: move rt2800_drv_data declaration into rt2800lib.h
Date: Wed, 15 Feb 2017 10:25:04 +0100
Message-Id: <1487150713-3510-2-git-send-email-sgruszka@redhat.com> (sfid-20170215_103015_005478_ED5903E8)
In-Reply-To: <1487150713-3510-1-git-send-email-sgruszka@redhat.com>
References: <1487150713-3510-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gabor Juhos <juhosg@openwrt.org>

The rt2800_drv_data structure contains driver specific
information. Move the declaration into the rt2800lib.h
header which is a more logical place for it. Also fix
the comment style to avoid checkpatch warning.

The patch contains no functional changes, it is in
preparation for the next patch.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800.h    | 25 -------------------------
 drivers/net/wireless/ralink/rt2x00/rt2800lib.h | 23 +++++++++++++++++++++++
 2 files changed, 23 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800.h b/drivers/net/wireless/ralink/rt2x00/rt2800.h
index 256496b..0e7051d 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800.h
@@ -2987,29 +2987,4 @@ enum rt2800_eeprom_word {
  */
 #define BCN_TBTT_OFFSET 64
 
-/*
- * Hardware has 255 WCID table entries. First 32 entries are reserved for
- * shared keys. Since parts of the pairwise key table might be shared with
- * the beacon frame buffers 6 & 7 we could only use the first 222 entries.
- */
-#define WCID_START	33
-#define WCID_END	222
-#define STA_IDS_SIZE	(WCID_END - WCID_START + 2)
-
-/*
- * RT2800 driver data structure
- */
-struct rt2800_drv_data {
-	u8 calibration_bw20;
-	u8 calibration_bw40;
-	u8 bbp25;
-	u8 bbp26;
-	u8 txmixer_gain_24g;
-	u8 txmixer_gain_5g;
-	u8 max_psdu;
-	unsigned int tbtt_tick;
-	unsigned int ampdu_factor_cnt[4];
-	DECLARE_BITMAP(sta_ids, STA_IDS_SIZE);
-};
-
 #endif /* RT2800_H */
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.h b/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
index 0a8b4df..8e1ae13 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
@@ -20,6 +20,29 @@
 #ifndef RT2800LIB_H
 #define RT2800LIB_H
 
+/*
+ * Hardware has 255 WCID table entries. First 32 entries are reserved for
+ * shared keys. Since parts of the pairwise key table might be shared with
+ * the beacon frame buffers 6 & 7 we could only use the first 222 entries.
+ */
+#define WCID_START	33
+#define WCID_END	222
+#define STA_IDS_SIZE	(WCID_END - WCID_START + 2)
+
+/* RT2800 driver data structure */
+struct rt2800_drv_data {
+	u8 calibration_bw20;
+	u8 calibration_bw40;
+	u8 bbp25;
+	u8 bbp26;
+	u8 txmixer_gain_24g;
+	u8 txmixer_gain_5g;
+	u8 max_psdu;
+	unsigned int tbtt_tick;
+	unsigned int ampdu_factor_cnt[4];
+	DECLARE_BITMAP(sta_ids, STA_IDS_SIZE);
+};
+
 struct rt2800_ops {
 	void (*register_read)(struct rt2x00_dev *rt2x00dev,
 			      const unsigned int offset, u32 *value);
-- 
1.8.3.1
