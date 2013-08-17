Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:53086 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754018Ab3HQR4T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Aug 2013 13:56:19 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 1/6] rt2x00: rt2800lib: move rt2800_drv_data declaration into rt2800lib.h
Date: Sat, 17 Aug 2013 19:56:02 +0200
Message-Id: <1376762167-24583-2-git-send-email-juhosg@openwrt.org> (sfid-20130817_195623_056971_EAC2E281)
In-Reply-To: <1376762167-24583-1-git-send-email-juhosg@openwrt.org>
References: <1376762167-24583-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rt2800_drv_data structure contains driver specific
information. Move the declaration into the rt2800lib.h
header which is a more logical place for it. Also fix
the comment style to avoid checkpatch warning.

The patch contains no functional changes, it is in
preparation for the next patch.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800.h    |   13 -------------
 drivers/net/wireless/rt2x00/rt2800lib.h |   11 +++++++++++
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index e25e5bf..426129a 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -2956,17 +2956,4 @@ enum rt2800_eeprom_word {
  */
 #define BCN_TBTT_OFFSET 64
 
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
-	unsigned int tbtt_tick;
-};
-
 #endif /* RT2800_H */
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index a94ba44..9b3e8ef 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -22,6 +22,17 @@
 #ifndef RT2800LIB_H
 #define RT2800LIB_H
 
+/* RT2800 driver data structure */
+struct rt2800_drv_data {
+	u8 calibration_bw20;
+	u8 calibration_bw40;
+	u8 bbp25;
+	u8 bbp26;
+	u8 txmixer_gain_24g;
+	u8 txmixer_gain_5g;
+	unsigned int tbtt_tick;
+};
+
 struct rt2800_ops {
 	void (*register_read)(struct rt2x00_dev *rt2x00dev,
 			      const unsigned int offset, u32 *value);
-- 
1.7.10
