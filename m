Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44273 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755104Ab1DJQcY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2011 12:32:24 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org
Subject: [PATCH 3/7] ath5k: optimize tx status processing
Date: Sun, 10 Apr 2011 18:32:15 +0200
Message-Id: <1302453139-11437-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1302453139-11437-2-git-send-email-nbd@openwrt.org>
References: <1302453139-11437-1-git-send-email-nbd@openwrt.org>
 <1302453139-11437-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use ACCESS_ONCE to reduce the number of variable reloads on uncached memory

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath5k/desc.c |   37 ++++++++++++++++++--------------
 1 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/desc.c b/drivers/net/wireless/ath/ath5k/desc.c
index 990a3b4..3758b96 100644
--- a/drivers/net/wireless/ath/ath5k/desc.c
+++ b/drivers/net/wireless/ath/ath5k/desc.c
@@ -401,32 +401,38 @@ static int ath5k_hw_proc_4word_tx_status(struct ath5k_hw *ah,
 {
 	struct ath5k_hw_4w_tx_ctl *tx_ctl;
 	struct ath5k_hw_tx_status *tx_status;
+	u32 txstat0, txstat1, txctl2;
 
 	tx_ctl = &desc->ud.ds_tx5212.tx_ctl;
 	tx_status = &desc->ud.ds_tx5212.tx_stat;
 
+	txstat1 = ACCESS_ONCE(tx_status->tx_status_1);
+
 	/* No frame has been send or error */
-	if (unlikely(!(tx_status->tx_status_1 & AR5K_DESC_TX_STATUS1_DONE)))
+	if (unlikely(!(txstat1 & AR5K_DESC_TX_STATUS1_DONE)))
 		return -EINPROGRESS;
 
+	txstat0 = ACCESS_ONCE(tx_status->tx_status_0);
+	txctl2 = ACCESS_ONCE(tx_ctl->tx_control_2);
+
 	/*
 	 * Get descriptor status
 	 */
-	ts->ts_tstamp = AR5K_REG_MS(tx_status->tx_status_0,
+	ts->ts_tstamp = AR5K_REG_MS(txstat0,
 		AR5K_DESC_TX_STATUS0_SEND_TIMESTAMP);
-	ts->ts_shortretry = AR5K_REG_MS(tx_status->tx_status_0,
+	ts->ts_shortretry = AR5K_REG_MS(txstat0,
 		AR5K_DESC_TX_STATUS0_SHORT_RETRY_COUNT);
-	ts->ts_longretry = AR5K_REG_MS(tx_status->tx_status_0,
+	ts->ts_longretry = AR5K_REG_MS(txstat0,
 		AR5K_DESC_TX_STATUS0_LONG_RETRY_COUNT);
-	ts->ts_seqnum = AR5K_REG_MS(tx_status->tx_status_1,
+	ts->ts_seqnum = AR5K_REG_MS(txstat1,
 		AR5K_DESC_TX_STATUS1_SEQ_NUM);
-	ts->ts_rssi = AR5K_REG_MS(tx_status->tx_status_1,
+	ts->ts_rssi = AR5K_REG_MS(txstat1,
 		AR5K_DESC_TX_STATUS1_ACK_SIG_STRENGTH);
-	ts->ts_antenna = (tx_status->tx_status_1 &
+	ts->ts_antenna = (txstat1 &
 		AR5K_DESC_TX_STATUS1_XMIT_ANTENNA_5212) ? 2 : 1;
 	ts->ts_status = 0;
 
-	ts->ts_final_idx = AR5K_REG_MS(tx_status->tx_status_1,
+	ts->ts_final_idx = AR5K_REG_MS(txstat1,
 			AR5K_DESC_TX_STATUS1_FINAL_TS_IX_5212);
 
 	/* The longretry counter has the number of un-acked retries
@@ -437,17 +443,17 @@ static int ath5k_hw_proc_4word_tx_status(struct ath5k_hw *ah,
 	ts->ts_retry[ts->ts_final_idx] = ts->ts_longretry;
 	switch (ts->ts_final_idx) {
 	case 3:
-		ts->ts_retry[2] = AR5K_REG_MS(tx_ctl->tx_control_2,
+		ts->ts_retry[2] = AR5K_REG_MS(txctl2,
 			AR5K_4W_TX_DESC_CTL2_XMIT_TRIES2);
 		ts->ts_longretry += ts->ts_retry[2];
 		/* fall through */
 	case 2:
-		ts->ts_retry[1] = AR5K_REG_MS(tx_ctl->tx_control_2,
+		ts->ts_retry[1] = AR5K_REG_MS(txctl2,
 			AR5K_4W_TX_DESC_CTL2_XMIT_TRIES1);
 		ts->ts_longretry += ts->ts_retry[1];
 		/* fall through */
 	case 1:
-		ts->ts_retry[0] = AR5K_REG_MS(tx_ctl->tx_control_2,
+		ts->ts_retry[0] = AR5K_REG_MS(txctl2,
 			AR5K_4W_TX_DESC_CTL2_XMIT_TRIES1);
 		ts->ts_longretry += ts->ts_retry[0];
 		/* fall through */
@@ -456,15 +462,14 @@ static int ath5k_hw_proc_4word_tx_status(struct ath5k_hw *ah,
 	}
 
 	/* TX error */
-	if (!(tx_status->tx_status_0 & AR5K_DESC_TX_STATUS0_FRAME_XMIT_OK)) {
-		if (tx_status->tx_status_0 &
-				AR5K_DESC_TX_STATUS0_EXCESSIVE_RETRIES)
+	if (!(txstat0 & AR5K_DESC_TX_STATUS0_FRAME_XMIT_OK)) {
+		if (txstat0 & AR5K_DESC_TX_STATUS0_EXCESSIVE_RETRIES)
 			ts->ts_status |= AR5K_TXERR_XRETRY;
 
-		if (tx_status->tx_status_0 & AR5K_DESC_TX_STATUS0_FIFO_UNDERRUN)
+		if (txstat0 & AR5K_DESC_TX_STATUS0_FIFO_UNDERRUN)
 			ts->ts_status |= AR5K_TXERR_FIFO;
 
-		if (tx_status->tx_status_0 & AR5K_DESC_TX_STATUS0_FILTERED)
+		if (txstat0 & AR5K_DESC_TX_STATUS0_FILTERED)
 			ts->ts_status |= AR5K_TXERR_FILT;
 	}
 
-- 
1.7.3.2

