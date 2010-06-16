Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:31840 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753962Ab0FPKMx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 06:12:53 -0400
Received: from vs3009.wh2.ocn.ne.jp (125.206.180.237)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0982283172
	for <linux-wireless@vger.kernel.org>; Wed, 16 Jun 2010 19:12:52 +0900 (JST)
Subject: [PATCH 16/17] ath5k: review RX descriptor functions
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 16 Jun 2010 19:12:34 +0900
Message-ID: <20100616101234.10067.48622.stgit@tt-desk>
In-Reply-To: <20100616100809.10067.34787.stgit@tt-desk>
References: <20100616100809.10067.34787.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reviewed RX descriptor functions against the HAL sources. Some minor changes:

  - check size before making changes to the descriptor

  - whitespace

  - add comments about 5210 timestamps. this needs to be adressed later!

  - FIFO overrun error only available on 5210

  - rs_phyerr should not be OR'ed

  - clear the whole ath5k_rx_status structure before using, instead of
    zeroing specific fields.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/desc.c |   34 +++++++++++++++++++--------------
 1 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/desc.c b/drivers/net/wireless/ath/ath5k/desc.c
index 019525d..c0037b6 100644
--- a/drivers/net/wireless/ath/ath5k/desc.c
+++ b/drivers/net/wireless/ath/ath5k/desc.c
@@ -499,10 +499,11 @@ int ath5k_hw_setup_rx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 	*/
 	memset(&desc->ud.ds_rx, 0, sizeof(struct ath5k_hw_all_rx_desc));
 
+	if (unlikely(size & ~AR5K_DESC_RX_CTL1_BUF_LEN))
+		return -EINVAL;
+
 	/* Setup descriptor */
 	rx_ctl->rx_control_1 = size & AR5K_DESC_RX_CTL1_BUF_LEN;
-	if (unlikely(rx_ctl->rx_control_1 != size))
-		return -EINVAL;
 
 	if (flags & AR5K_RXDESC_INTREQ)
 		rx_ctl->rx_control_1 |= AR5K_DESC_RX_CTL1_INTREQ;
@@ -522,9 +523,11 @@ static int ath5k_hw_proc_5210_rx_status(struct ath5k_hw *ah,
 
 	/* No frame received / not ready */
 	if (unlikely(!(rx_status->rx_status_1 &
-	AR5K_5210_RX_DESC_STATUS1_DONE)))
+			AR5K_5210_RX_DESC_STATUS1_DONE)))
 		return -EINPROGRESS;
 
+	memset(rs, 0, sizeof(struct ath5k_rx_status));
+
 	/*
 	 * Frame receive status
 	 */
@@ -536,7 +539,11 @@ static int ath5k_hw_proc_5210_rx_status(struct ath5k_hw *ah,
 		AR5K_5210_RX_DESC_STATUS0_RECEIVE_RATE);
 	rs->rs_more = !!(rx_status->rx_status_0 &
 		AR5K_5210_RX_DESC_STATUS0_MORE);
-	/* TODO: this timestamp is 13 bit, later on we assume 15 bit */
+	/* TODO: this timestamp is 13 bit, later on we assume 15 bit!
+	 * also the HAL code for 5210 says the timestamp is bits [10..22] of the
+	 * TSF, and extends the timestamp here to 15 bit.
+	 * we need to check on 5210...
+	 */
 	rs->rs_tstamp = AR5K_REG_MS(rx_status->rx_status_1,
 		AR5K_5210_RX_DESC_STATUS1_RECEIVE_TIMESTAMP);
 
@@ -548,9 +555,6 @@ static int ath5k_hw_proc_5210_rx_status(struct ath5k_hw *ah,
 				AR5K_5210_RX_DESC_STATUS0_RECEIVE_ANT_5210)
 				? 2 : 1;
 
-	rs->rs_status = 0;
-	rs->rs_phyerr = 0;
-
 	/*
 	 * Key table status
 	 */
@@ -564,19 +568,21 @@ static int ath5k_hw_proc_5210_rx_status(struct ath5k_hw *ah,
 	 * Receive/descriptor errors
 	 */
 	if (!(rx_status->rx_status_1 &
-	AR5K_5210_RX_DESC_STATUS1_FRAME_RECEIVE_OK)) {
+			AR5K_5210_RX_DESC_STATUS1_FRAME_RECEIVE_OK)) {
 		if (rx_status->rx_status_1 &
 				AR5K_5210_RX_DESC_STATUS1_CRC_ERROR)
 			rs->rs_status |= AR5K_RXERR_CRC;
 
-		if (rx_status->rx_status_1 &
-				AR5K_5210_RX_DESC_STATUS1_FIFO_OVERRUN_5210)
+		/* only on 5210 */
+		if ((ah->ah_version == AR5K_AR5210) &&
+		    (rx_status->rx_status_1 &
+				AR5K_5210_RX_DESC_STATUS1_FIFO_OVERRUN_5210))
 			rs->rs_status |= AR5K_RXERR_FIFO;
 
 		if (rx_status->rx_status_1 &
 				AR5K_5210_RX_DESC_STATUS1_PHY_ERROR) {
 			rs->rs_status |= AR5K_RXERR_PHY;
-			rs->rs_phyerr |= AR5K_REG_MS(rx_status->rx_status_1,
+			rs->rs_phyerr = AR5K_REG_MS(rx_status->rx_status_1,
 				AR5K_5210_RX_DESC_STATUS1_PHY_ERROR);
 		}
 
@@ -604,6 +610,8 @@ static int ath5k_hw_proc_5212_rx_status(struct ath5k_hw *ah,
 				AR5K_5212_RX_DESC_STATUS1_DONE)))
 		return -EINPROGRESS;
 
+	memset(rs, 0, sizeof(struct ath5k_rx_status));
+
 	/*
 	 * Frame receive status
 	 */
@@ -619,8 +627,6 @@ static int ath5k_hw_proc_5212_rx_status(struct ath5k_hw *ah,
 		AR5K_5212_RX_DESC_STATUS0_MORE);
 	rs->rs_tstamp = AR5K_REG_MS(rx_status->rx_status_1,
 		AR5K_5212_RX_DESC_STATUS1_RECEIVE_TIMESTAMP);
-	rs->rs_status = 0;
-	rs->rs_phyerr = 0;
 
 	/*
 	 * Key table status
@@ -643,7 +649,7 @@ static int ath5k_hw_proc_5212_rx_status(struct ath5k_hw *ah,
 		if (rx_status->rx_status_1 &
 				AR5K_5212_RX_DESC_STATUS1_PHY_ERROR) {
 			rs->rs_status |= AR5K_RXERR_PHY;
-			rs->rs_phyerr |= AR5K_REG_MS(rx_status->rx_status_1,
+			rs->rs_phyerr = AR5K_REG_MS(rx_status->rx_status_1,
 				AR5K_5212_RX_DESC_STATUS1_PHY_ERROR_CODE);
 			ath5k_ani_phy_error_report(ah, rs->rs_phyerr);
 		}

