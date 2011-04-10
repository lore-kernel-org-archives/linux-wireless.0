Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44271 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092Ab1DJQcY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2011 12:32:24 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org
Subject: [PATCH 2/7] ath5k: remove ts_rate from ath5k_tx_status
Date: Sun, 10 Apr 2011 18:32:14 +0200
Message-Id: <1302453139-11437-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1302453139-11437-1-git-send-email-nbd@openwrt.org>
References: <1302453139-11437-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is no longer necessary for preparing mac80211 tx status

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    1 -
 drivers/net/wireless/ath/ath5k/desc.c  |   13 -------------
 2 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 4bb381c..aa588a0 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -452,7 +452,6 @@ struct ath5k_tx_status {
 	u16	ts_seqnum;
 	u16	ts_tstamp;
 	u8	ts_status;
-	u8	ts_rate[4];
 	u8	ts_retry[4];
 	u8	ts_final_idx;
 	s8	ts_rssi;
diff --git a/drivers/net/wireless/ath/ath5k/desc.c b/drivers/net/wireless/ath/ath5k/desc.c
index 0a8a9ef..990a3b4 100644
--- a/drivers/net/wireless/ath/ath5k/desc.c
+++ b/drivers/net/wireless/ath/ath5k/desc.c
@@ -375,8 +375,6 @@ static int ath5k_hw_proc_2word_tx_status(struct ath5k_hw *ah,
 		AR5K_DESC_TX_STATUS1_ACK_SIG_STRENGTH);
 	ts->ts_antenna = 1;
 	ts->ts_status = 0;
-	ts->ts_rate[0] = AR5K_REG_MS(tx_ctl->tx_control_0,
-		AR5K_2W_TX_DESC_CTL0_XMIT_RATE);
 	ts->ts_retry[0] = ts->ts_longretry;
 	ts->ts_final_idx = 0;
 
@@ -439,32 +437,21 @@ static int ath5k_hw_proc_4word_tx_status(struct ath5k_hw *ah,
 	ts->ts_retry[ts->ts_final_idx] = ts->ts_longretry;
 	switch (ts->ts_final_idx) {
 	case 3:
-		ts->ts_rate[3] = AR5K_REG_MS(tx_ctl->tx_control_3,
-			AR5K_4W_TX_DESC_CTL3_XMIT_RATE3);
-
 		ts->ts_retry[2] = AR5K_REG_MS(tx_ctl->tx_control_2,
 			AR5K_4W_TX_DESC_CTL2_XMIT_TRIES2);
 		ts->ts_longretry += ts->ts_retry[2];
 		/* fall through */
 	case 2:
-		ts->ts_rate[2] = AR5K_REG_MS(tx_ctl->tx_control_3,
-			AR5K_4W_TX_DESC_CTL3_XMIT_RATE2);
-
 		ts->ts_retry[1] = AR5K_REG_MS(tx_ctl->tx_control_2,
 			AR5K_4W_TX_DESC_CTL2_XMIT_TRIES1);
 		ts->ts_longretry += ts->ts_retry[1];
 		/* fall through */
 	case 1:
-		ts->ts_rate[1] = AR5K_REG_MS(tx_ctl->tx_control_3,
-			AR5K_4W_TX_DESC_CTL3_XMIT_RATE1);
-
 		ts->ts_retry[0] = AR5K_REG_MS(tx_ctl->tx_control_2,
 			AR5K_4W_TX_DESC_CTL2_XMIT_TRIES1);
 		ts->ts_longretry += ts->ts_retry[0];
 		/* fall through */
 	case 0:
-		ts->ts_rate[0] = tx_ctl->tx_control_3 &
-			AR5K_4W_TX_DESC_CTL3_XMIT_RATE0;
 		break;
 	}
 
-- 
1.7.3.2

