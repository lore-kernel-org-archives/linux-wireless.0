Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22722 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017Ab0CYUpA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 16:45:00 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 16/22] iwlwifi: remove non-exist extern functions and structures
Date: Thu, 25 Mar 2010 13:44:44 -0700
Message-Id: <1269549890-19195-17-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
References: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

After re-structure the agn files layout and move all the
agn shared functions out from iwl-5000.c, all those functions and data
structures do not need to be declare "extern" from iwl-5000.c in
iwl-dev.h.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    6 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   39 ---------------------------
 3 files changed, 4 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 6c09b24..aaf7e51 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -65,7 +65,7 @@
 #define IWL5150_MODULE_FIRMWARE(api) _IWL5150_MODULE_FIRMWARE(api)
 
 /* NIC configuration for 5000 series */
-void iwl5000_nic_config(struct iwl_priv *priv)
+static void iwl5000_nic_config(struct iwl_priv *priv)
 {
 	unsigned long flags;
 	u16 radio_cfg;
@@ -164,7 +164,7 @@ static void iwl5000_set_ct_threshold(struct iwl_priv *priv)
 	priv->hw_params.ct_kill_threshold = CT_KILL_THRESHOLD_LEGACY;
 }
 
-int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
+static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 {
 	if (priv->cfg->mod_params->num_of_queues >= IWL_MIN_NUM_QUEUES &&
 	    priv->cfg->mod_params->num_of_queues <= IWLAGN_NUM_QUEUES)
@@ -266,7 +266,7 @@ static int iwl5000_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 	return iwl_send_cmd_sync(priv, &hcmd);
 }
 
-struct iwl_lib_ops iwl5000_lib = {
+static struct iwl_lib_ops iwl5000_lib = {
 	.set_hw_params = iwl5000_hw_set_hw_params,
 	.txq_update_byte_cnt_tbl = iwlagn_txq_update_byte_cnt_tbl,
 	.txq_inval_byte_cnt_tbl = iwlagn_txq_inval_byte_cnt_tbl,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index a0e3c11..6e331f5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -35,6 +35,7 @@
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-io.h"
+#include "iwl-agn.h"
 
 static int iwlagn_send_rxon_assoc(struct iwl_priv *priv)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index c2e97cd..07d865f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -68,45 +68,6 @@ extern struct iwl_cfg iwl1000_bg_cfg;
 
 struct iwl_tx_queue;
 
-/* shared structures from iwl-5000.c */
-extern struct iwl_mod_params iwl50_mod_params;
-extern struct iwl_ucode_ops iwl5000_ucode;
-extern struct iwl_lib_ops iwl5000_lib;
-extern struct iwl_hcmd_ops iwl5000_hcmd;
-extern struct iwl_hcmd_utils_ops iwl5000_hcmd_utils;
-
-/* shared functions from iwl-5000.c */
-extern u16 iwl5000_get_hcmd_size(u8 cmd_id, u16 len);
-extern u16 iwl5000_build_addsta_hcmd(const struct iwl_addsta_cmd *cmd,
-				     u8 *data);
-extern void iwl5000_rts_tx_cmd_flag(struct ieee80211_tx_info *info,
-				    __le32 *tx_flags);
-extern int iwl5000_calc_rssi(struct iwl_priv *priv,
-			     struct iwl_rx_phy_res *rx_resp);
-extern void iwl5000_nic_config(struct iwl_priv *priv);
-extern u16 iwl5000_eeprom_calib_version(struct iwl_priv *priv);
-extern const u8 *iwl5000_eeprom_query_addr(const struct iwl_priv *priv,
-				    size_t offset);
-extern void iwl5000_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
-					    struct iwl_tx_queue *txq,
-					    u16 byte_cnt);
-extern void iwl5000_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
-				    struct iwl_tx_queue *txq);
-extern int iwl5000_load_ucode(struct iwl_priv *priv);
-extern void iwl5000_init_alive_start(struct iwl_priv *priv);
-extern int iwl5000_alive_notify(struct iwl_priv *priv);
-extern int iwl5000_hw_set_hw_params(struct iwl_priv *priv);
-extern int iwl5000_txq_agg_enable(struct iwl_priv *priv, int txq_id,
-			   int tx_fifo, int sta_id, int tid, u16 ssn_idx);
-extern int iwl5000_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
-			    u16 ssn_idx, u8 tx_fifo);
-extern void iwl5000_txq_set_sched(struct iwl_priv *priv, u32 mask);
-extern void iwl5000_setup_deferred_work(struct iwl_priv *priv);
-extern void iwl5000_rx_handler_setup(struct iwl_priv *priv);
-extern int iwl5000_hw_valid_rtc_data_addr(u32 addr);
-extern int iwl5000_send_tx_power(struct iwl_priv *priv);
-extern void iwl5000_temperature(struct iwl_priv *priv);
-
 /* CT-KILL constants */
 #define CT_KILL_THRESHOLD_LEGACY   110 /* in Celsius */
 #define CT_KILL_THRESHOLD	   114 /* in Celsius */
-- 
1.6.3.3

