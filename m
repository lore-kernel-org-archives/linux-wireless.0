Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54781 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800Ab0DODax (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:53 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH v2 36/97] ath9k_hw: Define tx control struct for AR9003
Date: Wed, 14 Apr 2010 23:29:50 -0400
Message-Id: <1271302251-9075-37-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Store appropriate desc length which will be used by the
ath9k module while duplicating tx desc.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.h |   28 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.c         |    3 ++
 drivers/net/wireless/ath/ath9k/hw.h         |    1 +
 3 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.h b/drivers/net/wireless/ath/ath9k/ar9003_mac.h
index 479dcd1..7f87804 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.h
@@ -43,6 +43,34 @@ struct ar9003_rxs {
 	u32 status11;
 } __packed;
 
+/* Transmit Control Descriptor */
+struct ar9003_txc {
+	u32 info;   /* descriptor information */
+	u32 link;   /* link pointer */
+	u32 data0;  /* data pointer to 1st buffer */
+	u32 ctl3;   /* DMA control 3  */
+	u32 data1;  /* data pointer to 2nd buffer */
+	u32 ctl5;   /* DMA control 5  */
+	u32 data2;  /* data pointer to 3rd buffer */
+	u32 ctl7;   /* DMA control 7  */
+	u32 data3;  /* data pointer to 4th buffer */
+	u32 ctl9;   /* DMA control 9  */
+	u32 ctl10;  /* DMA control 10 */
+	u32 ctl11;  /* DMA control 11 */
+	u32 ctl12;  /* DMA control 12 */
+	u32 ctl13;  /* DMA control 13 */
+	u32 ctl14;  /* DMA control 14 */
+	u32 ctl15;  /* DMA control 15 */
+	u32 ctl16;  /* DMA control 16 */
+	u32 ctl17;  /* DMA control 17 */
+	u32 ctl18;  /* DMA control 18 */
+	u32 ctl19;  /* DMA control 19 */
+	u32 ctl20;  /* DMA control 20 */
+	u32 ctl21;  /* DMA control 21 */
+	u32 ctl22;  /* DMA control 22 */
+	u32 pad[9]; /* pad to cache line (128 bytes/32 dwords) */
+} __packed;
+
 void ar9003_hw_attach_mac_ops(struct ath_hw *hw);
 void ath9k_hw_set_rx_bufsize(struct ath_hw *ah, u16 buf_size);
 void ath9k_hw_addrxbuf_edma(struct ath_hw *ah, u32 rxdp,
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index a285e17..aa80d43 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2962,6 +2962,9 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		pCap->rx_hp_qdepth = ATH9K_HW_RX_HP_QDEPTH;
 		pCap->rx_lp_qdepth = ATH9K_HW_RX_LP_QDEPTH;
 		pCap->rx_status_len = sizeof(struct ar9003_rxs);
+		pCap->tx_desc_len = sizeof(struct ar9003_txc);
+	} else {
+		pCap->tx_desc_len = sizeof(struct ath_desc);
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 64266ff..0361f42 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -206,6 +206,7 @@ struct ath9k_hw_capabilities {
 	u8 rx_hp_qdepth;
 	u8 rx_lp_qdepth;
 	u8 rx_status_len;
+	u8 tx_desc_len;
 };
 
 struct ath9k_ops_config {
-- 
1.6.3.3

