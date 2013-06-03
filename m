Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:49070 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab3FCDwS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Jun 2013 23:52:18 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/7] ath9k: Remove unused structure ath_dbg_bb_mac_samp
Date: Mon,  3 Jun 2013 09:19:25 +0530
Message-Id: <1370231369-16241-3-git-send-email-sujith@msujith.org> (sfid-20130603_055223_859155_2D15E920)
In-Reply-To: <1370231369-16241-1-git-send-email-sujith@msujith.org>
References: <1370231369-16241-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/debug.h | 39 ----------------------------------
 1 file changed, 39 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 223418d..fc67919 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -251,45 +251,6 @@ struct ath_stats {
 	u32 reset[__RESET_TYPE_MAX];
 };
 
-#define ATH_DBG_MAX_SAMPLES	10
-struct ath_dbg_bb_mac_samp {
-	u32 dma_dbg_reg_vals[ATH9K_NUM_DMA_DEBUG_REGS];
-	u32 pcu_obs, pcu_cr, noise;
-	struct {
-		u64 jiffies;
-		int8_t rssi_ctl0;
-		int8_t rssi_ctl1;
-		int8_t rssi_ctl2;
-		int8_t rssi_ext0;
-		int8_t rssi_ext1;
-		int8_t rssi_ext2;
-		int8_t rssi;
-		bool isok;
-		u8 rts_fail_cnt;
-		u8 data_fail_cnt;
-		u8 rateindex;
-		u8 qid;
-		u8 tid;
-		u32 ba_low;
-		u32 ba_high;
-	} ts[ATH_DBG_MAX_SAMPLES];
-	struct {
-		u64 jiffies;
-		int8_t rssi_ctl0;
-		int8_t rssi_ctl1;
-		int8_t rssi_ctl2;
-		int8_t rssi_ext0;
-		int8_t rssi_ext1;
-		int8_t rssi_ext2;
-		int8_t rssi;
-		bool is_mybeacon;
-		u8 antenna;
-		u8 rate;
-	} rs[ATH_DBG_MAX_SAMPLES];
-	struct ath_cycle_counters cc;
-	struct ath9k_nfcal_hist nfCalHist[NUM_NF_READINGS];
-};
-
 struct ath9k_debug {
 	struct dentry *debugfs_phy;
 	u32 regidx;
-- 
1.8.3

