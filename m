Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46733 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933207Ab0DHT1k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:40 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH 019/102] ath9k_hw: Fill few hw cap for edma
Date: Thu,  8 Apr 2010 15:26:15 -0400
Message-Id: <1270754858-26266-20-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

HP & LP queue depth and rx status length.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.h |   35 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.c         |   10 +++++++-
 drivers/net/wireless/ath/ath9k/hw.h         |    8 ++++++
 3 files changed, 52 insertions(+), 1 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_mac.h

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.h b/drivers/net/wireless/ath/ath9k/ar9003_mac.h
new file mode 100644
index 0000000..90c5ff0
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.h
@@ -0,0 +1,35 @@
+/*
+ * Copyright (c) 2010 Atheros Communications Inc.
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
+#ifndef AR9003_MAC_H
+#define AR9003_MAC_H
+
+struct ar9300_rxs {
+	u32 ds_info;
+	u32 status1;
+	u32 status2;
+	u32 status3;
+	u32 status4;
+	u32 status5;
+	u32 status6;
+	u32 status7;
+	u32 status8;
+	u32 status9;
+	u32 status10;
+	u32 status11;
+} __packed;
+
+#endif
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 9a63884..6605fdb 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2916,8 +2916,16 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		btcoex_hw->scheme = ATH_BTCOEX_CFG_NONE;
 	}
 
-	if (AR_SREV_9300_20_OR_LATER(ah))
+	if (AR_SREV_9300_20_OR_LATER(ah)) {
 		pCap->hw_caps |= ATH9K_HW_CAP_EDMA;
+		pCap->rx_hp_qdepth = ATH9K_HW_RX_HP_QDEPTH;
+		if (AR_SREV_9300_20_OR_LATER(ah))
+			pCap->rx_lp_qdepth = ATH9K_HW_RX_LP_QDEPTH;
+		else
+			pCap->rx_lp_qdepth = ATH9K_HW_RX_LP_QDEPTH_AR9300_10;
+
+		pCap->rx_status_len = sizeof(struct ar9300_rxs);
+	}
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index c4b2770..2d43050 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -28,6 +28,7 @@
 #include "reg.h"
 #include "phy.h"
 #include "btcoex.h"
+#include "ar9003_mac.h"
 
 #include "../regd.h"
 #include "../debug.h"
@@ -135,6 +136,10 @@
 
 #define TU_TO_USEC(_tu)             ((_tu) << 10)
 
+#define ATH9K_HW_RX_HP_QDEPTH	16
+#define ATH9K_HW_RX_LP_QDEPTH_AR9300_10	64
+#define ATH9K_HW_RX_LP_QDEPTH	128
+
 enum wireless_mode {
 	ATH9K_MODE_11A = 0,
 	ATH9K_MODE_11G,
@@ -192,6 +197,9 @@ struct ath9k_hw_capabilities {
 	u8 num_gpio_pins;
 	u8 num_antcfg_2ghz;
 	u8 num_antcfg_5ghz;
+	u8 rx_hp_qdepth;
+	u8 rx_lp_qdepth;
+	u8 rx_status_len;
 };
 
 struct ath9k_ops_config {
-- 
1.6.3.3

