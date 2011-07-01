Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:14050 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756625Ab1GAPxG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 11:53:06 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/11] iwlagn: remove the indirection for the rx write pointer
Date: Fri,  1 Jul 2011 08:20:05 -0700
Message-Id: <1309533605-25774-12-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110701_175321_876844_7F1A4C27)
In-Reply-To: <1309533605-25774-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1309533605-25774-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Not needed since the driver split.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-2000.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-5000.c |    2 --
 drivers/net/wireless/iwlwifi/iwl-6000.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    1 -
 drivers/net/wireless/iwlwifi/iwl-rx.c   |    7 +++----
 6 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 8c5a829..cf1449d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -138,7 +138,6 @@ static int iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 
 	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
-	priv->hw_params.rx_wrt_ptr_reg = FH_RSCSR_CHNL0_WPTR;
 
 	priv->hw_params.tx_chains_num = num_of_ant(priv->cfg->valid_tx_ant);
 	if (priv->cfg->rx_with_siso_diversity)
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 75d63e6..a401113 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -136,7 +136,6 @@ static int iwl2000_hw_set_hw_params(struct iwl_priv *priv)
 
 	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
-	priv->hw_params.rx_wrt_ptr_reg = FH_RSCSR_CHNL0_WPTR;
 
 	priv->hw_params.tx_chains_num = num_of_ant(priv->cfg->valid_tx_ant);
 	if (priv->cfg->rx_with_siso_diversity)
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 5ebf5d2..c55cec8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -169,7 +169,6 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 
 	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
-	priv->hw_params.rx_wrt_ptr_reg = FH_RSCSR_CHNL0_WPTR;
 
 	priv->hw_params.tx_chains_num = num_of_ant(priv->cfg->valid_tx_ant);
 	priv->hw_params.rx_chains_num = num_of_ant(priv->cfg->valid_rx_ant);
@@ -214,7 +213,6 @@ static int iwl5150_hw_set_hw_params(struct iwl_priv *priv)
 
 	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
-	priv->hw_params.rx_wrt_ptr_reg = FH_RSCSR_CHNL0_WPTR;
 
 	priv->hw_params.tx_chains_num = num_of_ant(priv->cfg->valid_tx_ant);
 	priv->hw_params.rx_chains_num = num_of_ant(priv->cfg->valid_rx_ant);
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 94ad57c..965d010 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -157,7 +157,6 @@ static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 
 	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
-	priv->hw_params.rx_wrt_ptr_reg = FH_RSCSR_CHNL0_WPTR;
 
 	priv->hw_params.tx_chains_num = num_of_ant(priv->cfg->valid_tx_ant);
 	if (priv->cfg->rx_with_siso_diversity)
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 4d17619..f4501f8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -665,7 +665,6 @@ struct iwl_hw_params {
 	u16 max_rxq_size;
 	u16 max_rxq_log;
 	u32 rx_page_order;
-	u32 rx_wrt_ptr_reg;
 	u8  max_stations;
 	u8  ht40_channel;
 	u8  max_beacon_itrvl;	/* in 1024 ms */
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 065d2c0..87148bb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -134,7 +134,6 @@ int iwl_rx_queue_space(const struct iwl_rx_queue *q)
 void iwl_rx_queue_update_write_ptr(struct iwl_priv *priv, struct iwl_rx_queue *q)
 {
 	unsigned long flags;
-	u32 rx_wrt_ptr_reg = priv->hw_params.rx_wrt_ptr_reg;
 	u32 reg;
 
 	spin_lock_irqsave(&q->lock, flags);
@@ -146,7 +145,7 @@ void iwl_rx_queue_update_write_ptr(struct iwl_priv *priv, struct iwl_rx_queue *q
 		/* shadow register enabled */
 		/* Device expects a multiple of 8 */
 		q->write_actual = (q->write & ~0x7);
-		iwl_write32(priv, rx_wrt_ptr_reg, q->write_actual);
+		iwl_write32(priv, FH_RSCSR_CHNL0_WPTR, q->write_actual);
 	} else {
 		/* If power-saving is in use, make sure device is awake */
 		if (test_bit(STATUS_POWER_PMI, &priv->status)) {
@@ -162,14 +161,14 @@ void iwl_rx_queue_update_write_ptr(struct iwl_priv *priv, struct iwl_rx_queue *q
 			}
 
 			q->write_actual = (q->write & ~0x7);
-			iwl_write_direct32(priv, rx_wrt_ptr_reg,
+			iwl_write_direct32(priv, FH_RSCSR_CHNL0_WPTR,
 					q->write_actual);
 
 		/* Else device is assumed to be awake */
 		} else {
 			/* Device expects a multiple of 8 */
 			q->write_actual = (q->write & ~0x7);
-			iwl_write_direct32(priv, rx_wrt_ptr_reg,
+			iwl_write_direct32(priv, FH_RSCSR_CHNL0_WPTR,
 				q->write_actual);
 		}
 	}
-- 
1.7.0.4

