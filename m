Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:12657 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758176AbZJBUtv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2009 16:49:51 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/13] iwlwifi/iwl3945 : unify apm stop operation
Date: Fri,  2 Oct 2009 13:44:04 -0700
Message-Id: <1254516247-4085-11-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1254516247-4085-1-git-send-email-reinette.chatre@intel.com>
References: <1254516247-4085-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Unify the usage of apm_stop_master and apm_stop
across all hardwares.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c |   43 +---------------------------
 drivers/net/wireless/iwlwifi/iwl-4965.c |   38 +------------------------
 drivers/net/wireless/iwlwifi/iwl-5000.c |   46 ++-----------------------------
 drivers/net/wireless/iwlwifi/iwl-6000.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c |   36 ++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h |    3 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    1 -
 8 files changed, 47 insertions(+), 124 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 86d93b5..679a67f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -112,7 +112,7 @@ static struct iwl_lib_ops iwl1000_lib = {
 	.apm_ops = {
 		.init =	iwl5000_apm_init,
 		.reset = iwl5000_apm_reset,
-		.stop = iwl5000_apm_stop,
+		.stop = iwl_apm_stop,
 		.config = iwl1000_nic_config,
 		.set_pwr_src = iwl_set_pwr_src,
 	},
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 8cc0dfc..bb045a0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1167,48 +1167,9 @@ void iwl3945_hw_txq_ctx_stop(struct iwl_priv *priv)
 	iwl3945_hw_txq_ctx_free(priv);
 }
 
-static int iwl3945_apm_stop_master(struct iwl_priv *priv)
-{
-	int ret = 0;
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	/* set stop master bit */
-	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_STOP_MASTER);
-
-	iwl_poll_direct_bit(priv, CSR_RESET,
-			    CSR_RESET_REG_FLAG_MASTER_DISABLED, 100);
-
-	if (ret < 0)
-		goto out;
-
-out:
-	spin_unlock_irqrestore(&priv->lock, flags);
-	IWL_DEBUG_INFO(priv, "stop master\n");
-
-	return ret;
-}
-
-static void iwl3945_apm_stop(struct iwl_priv *priv)
-{
-	unsigned long flags;
-
-	iwl3945_apm_stop_master(priv);
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
-
-	udelay(10);
-	/* clear "init complete"  move adapter D0A* --> D0U state */
-	iwl_clear_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
-	spin_unlock_irqrestore(&priv->lock, flags);
-}
-
 static int iwl3945_apm_reset(struct iwl_priv *priv)
 {
-	iwl3945_apm_stop_master(priv);
+	iwl_apm_stop_master(priv);
 
 
 	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
@@ -2841,7 +2802,7 @@ static struct iwl_lib_ops iwl3945_lib = {
 	.apm_ops = {
 		.init = iwl3945_apm_init,
 		.reset = iwl3945_apm_reset,
-		.stop = iwl3945_apm_stop,
+		.stop = iwl_apm_stop,
 		.config = iwl3945_nic_config,
 		.set_pwr_src = iwl3945_set_pwr_src,
 	},
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 8717946..dd10c42 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -396,45 +396,11 @@ static void iwl4965_nic_config(struct iwl_priv *priv)
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
-static int iwl4965_apm_stop_master(struct iwl_priv *priv)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	/* set stop master bit */
-	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_STOP_MASTER);
-
-	iwl_poll_direct_bit(priv, CSR_RESET,
-			CSR_RESET_REG_FLAG_MASTER_DISABLED, 100);
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-	IWL_DEBUG_INFO(priv, "stop master\n");
-
-	return 0;
-}
-
-static void iwl4965_apm_stop(struct iwl_priv *priv)
-{
-	unsigned long flags;
-
-	iwl4965_apm_stop_master(priv);
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
-
-	udelay(10);
-	/* clear "init complete"  move adapter D0A* --> D0U state */
-	iwl_clear_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
-	spin_unlock_irqrestore(&priv->lock, flags);
-}
-
 static int iwl4965_apm_reset(struct iwl_priv *priv)
 {
 	int ret = 0;
 
-	iwl4965_apm_stop_master(priv);
+	iwl_apm_stop_master(priv);
 
 
 	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
@@ -2306,7 +2272,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 	.apm_ops = {
 		.init = iwl4965_apm_init,
 		.reset = iwl4965_apm_reset,
-		.stop = iwl4965_apm_stop,
+		.stop = iwl_apm_stop,
 		.config = iwl4965_nic_config,
 		.set_pwr_src = iwl_set_pwr_src,
 	},
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 6248535..d8dadbf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -72,26 +72,6 @@ static const u16 iwl5000_default_queue_to_tx_fifo[] = {
 	IWL_TX_FIFO_HCCA_2
 };
 
-/* FIXME: same implementation as 4965 */
-static int iwl5000_apm_stop_master(struct iwl_priv *priv)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	/* set stop master bit */
-	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_STOP_MASTER);
-
-	iwl_poll_direct_bit(priv, CSR_RESET,
-				  CSR_RESET_REG_FLAG_MASTER_DISABLED, 100);
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-	IWL_DEBUG_INFO(priv, "stop master\n");
-
-	return 0;
-}
-
-
 int iwl5000_apm_init(struct iwl_priv *priv)
 {
 	int ret = 0;
@@ -137,31 +117,11 @@ int iwl5000_apm_init(struct iwl_priv *priv)
 	return ret;
 }
 
-/* FIXME: this is identical to 4965 */
-void iwl5000_apm_stop(struct iwl_priv *priv)
-{
-	unsigned long flags;
-
-	iwl5000_apm_stop_master(priv);
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
-
-	udelay(10);
-
-	/* clear "init complete"  move adapter D0A* --> D0U state */
-	iwl_clear_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-}
-
-
 int iwl5000_apm_reset(struct iwl_priv *priv)
 {
 	int ret = 0;
 
-	iwl5000_apm_stop_master(priv);
+	iwl_apm_stop_master(priv);
 
 	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
 
@@ -1561,7 +1521,7 @@ struct iwl_lib_ops iwl5000_lib = {
 	.apm_ops = {
 		.init =	iwl5000_apm_init,
 		.reset = iwl5000_apm_reset,
-		.stop = iwl5000_apm_stop,
+		.stop = iwl_apm_stop,
 		.config = iwl5000_nic_config,
 		.set_pwr_src = iwl_set_pwr_src,
 	},
@@ -1613,7 +1573,7 @@ static struct iwl_lib_ops iwl5150_lib = {
 	.apm_ops = {
 		.init =	iwl5000_apm_init,
 		.reset = iwl5000_apm_reset,
-		.stop = iwl5000_apm_stop,
+		.stop = iwl_apm_stop,
 		.config = iwl5000_nic_config,
 		.set_pwr_src = iwl_set_pwr_src,
 	},
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index a002214..d1f0b0b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -193,7 +193,7 @@ static struct iwl_lib_ops iwl6000_lib = {
 	.apm_ops = {
 		.init =	iwl5000_apm_init,
 		.reset = iwl5000_apm_reset,
-		.stop = iwl5000_apm_stop,
+		.stop = iwl_apm_stop,
 		.config = iwl6000_nic_config,
 		.set_pwr_src = iwl_set_pwr_src,
 	},
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 34547cf..7c0ef8e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1329,6 +1329,42 @@ void iwl_irq_handle_error(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_irq_handle_error);
 
+int iwl_apm_stop_master(struct iwl_priv *priv)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	/* set stop master bit */
+	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_STOP_MASTER);
+
+	iwl_poll_direct_bit(priv, CSR_RESET,
+			CSR_RESET_REG_FLAG_MASTER_DISABLED, 100);
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+	IWL_DEBUG_INFO(priv, "stop master\n");
+
+	return 0;
+}
+EXPORT_SYMBOL(iwl_apm_stop_master);
+
+void iwl_apm_stop(struct iwl_priv *priv)
+{
+	unsigned long flags;
+
+	iwl_apm_stop_master(priv);
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
+
+	udelay(10);
+	/* clear "init complete"  move adapter D0A* --> D0U state */
+	iwl_clear_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
+EXPORT_SYMBOL(iwl_apm_stop);
+
 void iwl_configure_filter(struct ieee80211_hw *hw,
 			  unsigned int changed_flags,
 			  unsigned int *total_flags,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index eb586a5..6688b69 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -658,6 +658,8 @@ extern void iwl_rx_reply_rx_phy(struct iwl_priv *priv,
 				    struct iwl_rx_mem_buffer *rxb);
 void iwl_rx_reply_compressed_ba(struct iwl_priv *priv,
 					   struct iwl_rx_mem_buffer *rxb);
+void iwl_apm_stop(struct iwl_priv *priv);
+int iwl_apm_stop_master(struct iwl_priv *priv);
 
 void iwl_setup_rxon_timing(struct iwl_priv *priv);
 static inline int iwl_send_rxon_assoc(struct iwl_priv *priv)
@@ -677,5 +679,4 @@ static inline const struct ieee80211_supported_band *iwl_get_hw_mode(
 {
 	return priv->hw->wiphy->bands[band];
 }
-
 #endif /* __iwl_core_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index eabc556..72946c1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -86,7 +86,6 @@ extern void iwl5000_rts_tx_cmd_flag(struct ieee80211_tx_info *info,
 extern int iwl5000_calc_rssi(struct iwl_priv *priv,
 			     struct iwl_rx_phy_res *rx_resp);
 extern int iwl5000_apm_init(struct iwl_priv *priv);
-extern void iwl5000_apm_stop(struct iwl_priv *priv);
 extern int iwl5000_apm_reset(struct iwl_priv *priv);
 extern void iwl5000_nic_config(struct iwl_priv *priv);
 extern u16 iwl5000_eeprom_calib_version(struct iwl_priv *priv);
-- 
1.5.6.3

