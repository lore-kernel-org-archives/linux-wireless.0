Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:32774 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758615Ab0FPKM0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 06:12:26 -0400
Received: from vs3013.wh2.ocn.ne.jp (125.206.180.245)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0980503145
	for <linux-wireless@vger.kernel.org>; Wed, 16 Jun 2010 19:12:25 +0900 (JST)
Subject: [PATCH 11/17] ath5k: cosmetic changes in
	ath5k_hw_proc_5212_rx_status()
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 16 Jun 2010 19:12:07 +0900
Message-ID: <20100616101207.10067.97179.stgit@tt-desk>
In-Reply-To: <20100616100809.10067.34787.stgit@tt-desk>
References: <20100616100809.10067.34787.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just whitespace and indentation.

Signed-off-by: Bruno Randolf <br1@einfach.org>
Acked-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/desc.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/desc.c b/drivers/net/wireless/ath/ath5k/desc.c
index b5a5d45..50fc931 100644
--- a/drivers/net/wireless/ath/ath5k/desc.c
+++ b/drivers/net/wireless/ath/ath5k/desc.c
@@ -577,7 +577,8 @@ static int ath5k_hw_proc_5210_rx_status(struct ath5k_hw *ah,
  * Proccess the rx status descriptor on 5212
  */
 static int ath5k_hw_proc_5212_rx_status(struct ath5k_hw *ah,
-		struct ath5k_desc *desc, struct ath5k_rx_status *rs)
+					struct ath5k_desc *desc,
+					struct ath5k_rx_status *rs)
 {
 	struct ath5k_hw_rx_status *rx_status;
 	struct ath5k_hw_rx_error *rx_err;
@@ -589,7 +590,7 @@ static int ath5k_hw_proc_5212_rx_status(struct ath5k_hw *ah,
 
 	/* No frame received / not ready */
 	if (unlikely(!(rx_status->rx_status_1 &
-	AR5K_5212_RX_DESC_STATUS1_DONE)))
+				AR5K_5212_RX_DESC_STATUS1_DONE)))
 		return -EINPROGRESS;
 
 	/*
@@ -615,7 +616,7 @@ static int ath5k_hw_proc_5212_rx_status(struct ath5k_hw *ah,
 	 */
 	if (rx_status->rx_status_1 & AR5K_5212_RX_DESC_STATUS1_KEY_INDEX_VALID)
 		rs->rs_keyix = AR5K_REG_MS(rx_status->rx_status_1,
-				AR5K_5212_RX_DESC_STATUS1_KEY_INDEX);
+					   AR5K_5212_RX_DESC_STATUS1_KEY_INDEX);
 	else
 		rs->rs_keyix = AR5K_RXKEYIX_INVALID;
 
@@ -623,7 +624,7 @@ static int ath5k_hw_proc_5212_rx_status(struct ath5k_hw *ah,
 	 * Receive/descriptor errors
 	 */
 	if (!(rx_status->rx_status_1 &
-	AR5K_5212_RX_DESC_STATUS1_FRAME_RECEIVE_OK)) {
+	    AR5K_5212_RX_DESC_STATUS1_FRAME_RECEIVE_OK)) {
 		if (rx_status->rx_status_1 &
 				AR5K_5212_RX_DESC_STATUS1_CRC_ERROR)
 			rs->rs_status |= AR5K_RXERR_CRC;
@@ -644,7 +645,6 @@ static int ath5k_hw_proc_5212_rx_status(struct ath5k_hw *ah,
 				AR5K_5212_RX_DESC_STATUS1_MIC_ERROR)
 			rs->rs_status |= AR5K_RXERR_MIC;
 	}
-
 	return 0;
 }
 

