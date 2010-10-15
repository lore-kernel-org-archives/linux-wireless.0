Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:34022 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685Ab0JOXBx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 19:01:53 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH] ath9k_hw: optimize all descriptor access functions
Date: Sat, 16 Oct 2010 01:01:48 +0200
Message-Id: <1287183708-10675-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Because all of the descriptor data structures are marked as __packed, GCC
assumes the worst case wrt. alignment and generates unaligned load/store
instructions on MIPS for access to all fields.
Since descriptors always have to be 4-byte-aligned, we can just mark the
data structures with __aligned(4), which allows GCC to generate much more
efficient code.
Verified through disassembly and OProfile comparisons.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.h |    6 +++---
 drivers/net/wireless/ath/ath9k/mac.h        |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.h b/drivers/net/wireless/ath/ath9k/ar9003_mac.h
index 9f2cea7..45cc7e8 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.h
@@ -65,7 +65,7 @@ struct ar9003_rxs {
 	u32 status9;
 	u32 status10;
 	u32 status11;
-} __packed;
+} __packed __aligned(4);
 
 /* Transmit Control Descriptor */
 struct ar9003_txc {
@@ -93,7 +93,7 @@ struct ar9003_txc {
 	u32 ctl21;  /* DMA control 21 */
 	u32 ctl22;  /* DMA control 22 */
 	u32 pad[9]; /* pad to cache line (128 bytes/32 dwords) */
-} __packed;
+} __packed __aligned(4);
 
 struct ar9003_txs {
 	u32 ds_info;
@@ -105,7 +105,7 @@ struct ar9003_txs {
 	u32 status6;
 	u32 status7;
 	u32 status8;
-} __packed;
+} __packed __aligned(4);
 
 void ar9003_hw_attach_mac_ops(struct ath_hw *hw);
 void ath9k_hw_set_rx_bufsize(struct ath_hw *ah, u16 buf_size);
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index fdc2507..22907e2 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -237,7 +237,7 @@ struct ath_desc {
 	u32 ds_ctl1;
 	u32 ds_hw[20];
 	void *ds_vdata;
-} __packed;
+} __packed __aligned(4);
 
 #define ATH9K_TXDESC_CLRDMASK		0x0001
 #define ATH9K_TXDESC_NOACK		0x0002
@@ -307,7 +307,7 @@ struct ar5416_desc {
 			u32 status8;
 		} rx;
 	} u;
-} __packed;
+} __packed __aligned(4);
 
 #define AR5416DESC(_ds)         ((struct ar5416_desc *)(_ds))
 #define AR5416DESC_CONST(_ds)   ((const struct ar5416_desc *)(_ds))
-- 
1.7.2.2

