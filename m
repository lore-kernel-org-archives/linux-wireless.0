Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:45809 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758641Ab0FPKMc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 06:12:32 -0400
Received: from vs3011.wh2.ocn.ne.jp (125.206.180.239)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0980963150
	for <linux-wireless@vger.kernel.org>; Wed, 16 Jun 2010 19:12:30 +0900 (JST)
Subject: [PATCH 12/17] ath5k: remove pointless rx error overlay struct
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 16 Jun 2010 19:12:12 +0900
Message-ID: <20100616101212.10067.63798.stgit@tt-desk>
In-Reply-To: <20100616100809.10067.34787.stgit@tt-desk>
References: <20100616100809.10067.34787.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath5k_hw_rx_error was only used once, where we could easily just use
ath5k_hw_rx_status as well, so remove it.

Signed-off-by: Bruno Randolf <br1@einfach.org>
Acked-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/debug.c |    2 +-
 drivers/net/wireless/ath/ath5k/desc.c  |   12 ++++--------
 drivers/net/wireless/ath/ath5k/desc.h  |   24 ++++--------------------
 3 files changed, 9 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index 02db66e..8c63886 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -925,7 +925,7 @@ ath5k_debug_printrxbuf(struct ath5k_buf *bf, int done,
 		ds, (unsigned long long)bf->daddr,
 		ds->ds_link, ds->ds_data,
 		rd->rx_ctl.rx_control_0, rd->rx_ctl.rx_control_1,
-		rd->u.rx_stat.rx_status_0, rd->u.rx_stat.rx_status_1,
+		rd->rx_stat.rx_status_0, rd->rx_stat.rx_status_1,
 		!done ? ' ' : (rs->rs_status == 0) ? '*' : '!');
 }
 
diff --git a/drivers/net/wireless/ath/ath5k/desc.c b/drivers/net/wireless/ath/ath5k/desc.c
index 50fc931..eb1427c 100644
--- a/drivers/net/wireless/ath/ath5k/desc.c
+++ b/drivers/net/wireless/ath/ath5k/desc.c
@@ -510,7 +510,7 @@ static int ath5k_hw_proc_5210_rx_status(struct ath5k_hw *ah,
 {
 	struct ath5k_hw_rx_status *rx_status;
 
-	rx_status = &desc->ud.ds_rx.u.rx_stat;
+	rx_status = &desc->ud.ds_rx.rx_stat;
 
 	/* No frame received / not ready */
 	if (unlikely(!(rx_status->rx_status_1 &
@@ -581,12 +581,8 @@ static int ath5k_hw_proc_5212_rx_status(struct ath5k_hw *ah,
 					struct ath5k_rx_status *rs)
 {
 	struct ath5k_hw_rx_status *rx_status;
-	struct ath5k_hw_rx_error *rx_err;
 
-	rx_status = &desc->ud.ds_rx.u.rx_stat;
-
-	/* Overlay on error */
-	rx_err = &desc->ud.ds_rx.u.rx_err;
+	rx_status = &desc->ud.ds_rx.rx_stat;
 
 	/* No frame received / not ready */
 	if (unlikely(!(rx_status->rx_status_1 &
@@ -632,8 +628,8 @@ static int ath5k_hw_proc_5212_rx_status(struct ath5k_hw *ah,
 		if (rx_status->rx_status_1 &
 				AR5K_5212_RX_DESC_STATUS1_PHY_ERROR) {
 			rs->rs_status |= AR5K_RXERR_PHY;
-			rs->rs_phyerr |= AR5K_REG_MS(rx_err->rx_error_1,
-					   AR5K_RX_DESC_ERROR1_PHY_ERROR_CODE);
+			rs->rs_phyerr |= AR5K_REG_MS(rx_status->rx_status_1,
+				AR5K_5212_RX_DESC_STATUS1_PHY_ERROR_CODE);
 			ath5k_ani_phy_error_report(ah, rs->rs_phyerr);
 		}
 
diff --git a/drivers/net/wireless/ath/ath5k/desc.h b/drivers/net/wireless/ath/ath5k/desc.h
index 64538fb..45f2644 100644
--- a/drivers/net/wireless/ath/ath5k/desc.h
+++ b/drivers/net/wireless/ath/ath5k/desc.h
@@ -96,21 +96,8 @@ struct ath5k_hw_rx_status {
 #define AR5K_5212_RX_DESC_STATUS1_RECEIVE_TIMESTAMP	0x7fff0000
 #define AR5K_5212_RX_DESC_STATUS1_RECEIVE_TIMESTAMP_S	16
 #define AR5K_5212_RX_DESC_STATUS1_KEY_CACHE_MISS	0x80000000
-
-/*
- * common hardware RX error descriptor
- */
-struct ath5k_hw_rx_error {
-	u32	rx_error_0; /* RX status word 0 */
-	u32	rx_error_1; /* RX status word 1 */
-} __packed;
-
-/* RX error word 0 fields/flags */
-#define AR5K_RX_DESC_ERROR0			0x00000000
-
-/* RX error word 1 fields/flags */
-#define AR5K_RX_DESC_ERROR1_PHY_ERROR_CODE	0x0000ff00
-#define AR5K_RX_DESC_ERROR1_PHY_ERROR_CODE_S	8
+#define AR5K_5212_RX_DESC_STATUS1_PHY_ERROR_CODE	0x0000ff00
+#define AR5K_5212_RX_DESC_STATUS1_PHY_ERROR_CODE_S	8
 
 /**
  * enum ath5k_phy_error_code - PHY Error codes
@@ -316,11 +303,8 @@ struct ath5k_hw_5212_tx_desc {
  * common hardware RX descriptor
  */
 struct ath5k_hw_all_rx_desc {
-	struct ath5k_hw_rx_ctl			rx_ctl;
-	union {
-		struct ath5k_hw_rx_status	rx_stat;
-		struct ath5k_hw_rx_error	rx_err;
-	} u;
+	struct ath5k_hw_rx_ctl		rx_ctl;
+	struct ath5k_hw_rx_status	rx_stat;
 } __packed;
 
 /*

