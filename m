Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:45975 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758973Ab3HNPtg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Aug 2013 11:49:36 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] ath9k: Identify first subframe in an A-MPDU
Date: Wed, 14 Aug 2013 21:15:55 +0530
Message-Id: <1376495157-18983-2-git-send-email-sujith@msujith.org> (sfid-20130814_174945_983721_510359A2)
In-Reply-To: <1376495157-18983-1-git-send-email-sujith@msujith.org>
References: <1376495157-18983-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c | 1 +
 drivers/net/wireless/ath/ath9k/mac.c        | 4 ++--
 drivers/net/wireless/ath/ath9k/mac.h        | 2 ++
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 5163abd..f6c5c1b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -491,6 +491,7 @@ int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah, struct ath_rx_status *rxs,
 	rxs->rs_rate = MS(rxsp->status1, AR_RxRate);
 	rxs->rs_more = (rxsp->status2 & AR_RxMore) ? 1 : 0;
 
+	rxs->rs_firstaggr = (rxsp->status11 & AR_RxFirstAggr) ? 1 : 0;
 	rxs->rs_isaggr = (rxsp->status11 & AR_RxAggr) ? 1 : 0;
 	rxs->rs_moreaggr = (rxsp->status11 & AR_RxMoreAggr) ? 1 : 0;
 	rxs->rs_antenna = (MS(rxsp->status4, AR_RxAntenna) & 0x7);
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 2ef05eb..a3eff09 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -583,9 +583,9 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 	rs->rs_rate = MS(ads.ds_rxstatus0, AR_RxRate);
 	rs->rs_more = (ads.ds_rxstatus1 & AR_RxMore) ? 1 : 0;
 
+	rs->rs_firstaggr = (ads.ds_rxstatus8 & AR_RxFirstAggr) ? 1 : 0;
 	rs->rs_isaggr = (ads.ds_rxstatus8 & AR_RxAggr) ? 1 : 0;
-	rs->rs_moreaggr =
-		(ads.ds_rxstatus8 & AR_RxMoreAggr) ? 1 : 0;
+	rs->rs_moreaggr = (ads.ds_rxstatus8 & AR_RxMoreAggr) ? 1 : 0;
 	rs->rs_antenna = MS(ads.ds_rxstatus3, AR_RxAntenna);
 
 	/* directly mapped flags for ieee80211_rx_status */
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index b02dfce..bfccace 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -140,6 +140,7 @@ struct ath_rx_status {
 	int8_t rs_rssi_ext1;
 	int8_t rs_rssi_ext2;
 	u8 rs_isaggr;
+	u8 rs_firstaggr;
 	u8 rs_moreaggr;
 	u8 rs_num_delims;
 	u8 rs_flags;
@@ -569,6 +570,7 @@ struct ar5416_desc {
 #define AR_RxAggr           0x00020000
 #define AR_PostDelimCRCErr  0x00040000
 #define AR_RxStatusRsvd71   0x3ff80000
+#define AR_RxFirstAggr      0x20000000
 #define AR_DecryptBusyErr   0x40000000
 #define AR_KeyMiss          0x80000000
 
-- 
1.8.3.4

