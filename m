Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:53061 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbbCJIbw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 04:31:52 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org
Subject: [PATCH 1/7] ath9k: Add initial structures for AIC
Date: Tue, 10 Mar 2015 14:05:28 +0530
Message-Id: <1425976534-1194-2-git-send-email-sujith@msujith.org> (sfid-20150310_093205_560819_EBC6BAD8)
In-Reply-To: <1425976534-1194-1-git-send-email-sujith@msujith.org>
References: <1425976534-1194-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

These are necessary for implementing AIC,
supported by chips like WB222.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_aic.h | 49 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/btcoex.h     | 11 +++++++
 2 files changed, 60 insertions(+)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_aic.h

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_aic.h b/drivers/net/wireless/ath/ath9k/ar9003_aic.h
new file mode 100644
index 0000000..d1adb49
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/ar9003_aic.h
@@ -0,0 +1,49 @@
+/*
+ * Copyright (c) 2015 Qualcomm Atheros Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef AR9003_AIC_H
+#define AR9003_AIC_H
+
+#define ATH_AIC_MAX_COM_ATT_DB_TABLE    6
+#define ATH_AIC_MAX_AIC_LIN_TABLE       69
+#define ATH_AIC_MIN_ROT_DIR_ATT_DB      0
+#define ATH_AIC_MIN_ROT_QUAD_ATT_DB     0
+#define ATH_AIC_MAX_ROT_DIR_ATT_DB      37
+#define ATH_AIC_MAX_ROT_QUAD_ATT_DB     37
+#define ATH_AIC_SRAM_AUTO_INCREMENT     0x80000000
+#define ATH_AIC_SRAM_GAIN_TABLE_OFFSET  0x280
+#define ATH_AIC_SRAM_CAL_OFFSET         0x140
+#define ATH_AIC_SRAM_OFFSET             0x00
+#define ATH_AIC_MEAS_MAG_THRESH         20
+#define ATH_AIC_BT_JUPITER_CTRL         0x66820
+#define ATH_AIC_BT_AIC_ENABLE           0x02
+
+struct ath_aic_sram_info {
+	bool valid;
+	u8 rot_quad_att_db;
+	bool vga_quad_sign;
+	u8 rot_dir_att_db;
+	bool vga_dir_sign;
+	u8 com_att_6db;
+};
+
+struct ath_aic_out_info {
+	int16_t dir_path_gain_lin;
+	int16_t quad_path_gain_lin;
+	struct ath_aic_sram_info sram;
+};
+
+#endif /* AR9003_AIC_H */
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
index 5fe62ff..b3ed738 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.h
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -44,6 +44,9 @@
 
 #define AR9300_NUM_BT_WEIGHTS   4
 #define AR9300_NUM_WLAN_WEIGHTS 4
+
+#define ATH_AIC_MAX_BT_CHANNEL  79
+
 /* Defines the BT AR_BT_COEX_WGHT used */
 enum ath_stomp_type {
 	ATH_BTCOEX_STOMP_ALL,
@@ -93,6 +96,14 @@ struct ath9k_hw_mci {
 	u32 last_recovery;
 };
 
+struct ath9k_hw_aic {
+	bool aic_enabled;
+	u8 aic_cal_state;
+	u8 aic_caled_chan;
+	u32 aic_sram[ATH_AIC_MAX_BT_CHANNEL];
+	u32 aic_cal_start_time;
+};
+
 struct ath_btcoex_hw {
 	enum ath_btcoex_scheme scheme;
 	struct ath9k_hw_mci mci;
-- 
2.3.1

