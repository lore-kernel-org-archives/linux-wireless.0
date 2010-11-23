Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:47771 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756457Ab0KWTEa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 14:04:30 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3/5] iwlwifi: consider BT for power management
Date: Tue, 23 Nov 2010 10:58:54 -0800
Message-Id: <1290538736-10816-4-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1290538736-10816-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1290538736-10816-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check the BT PSPoll flag when fill PM command to uCode

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c    |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    4 ++++
 drivers/net/wireless/iwlwifi/iwl-core.h    |    2 ++
 drivers/net/wireless/iwlwifi/iwl-power.c   |   17 +++++++++++++++++
 4 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 0cc66fd..f650282 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -549,6 +549,7 @@ static struct iwl_bt_params iwl6000_bt_params = {
 	.agg_time_limit = BT_AGG_THRESHOLD_DEF,
 	.bt_init_traffic_load = IWL_BT_COEX_TRAFFIC_LOAD_NONE,
 	.bt_prio_boost = IWLAGN_BT_PRIO_BOOST_DEFAULT,
+	.bt_sco_disable = true,
 };
 
 struct iwl_cfg iwl6000g2a_2agn_cfg = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index c4491f7..f8fe5f4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1829,6 +1829,10 @@ void iwlagn_send_advance_bt_config(struct iwl_priv *priv)
 	} else {
 		bt_cmd.flags = IWLAGN_BT_FLAG_COEX_MODE_3W <<
 					IWLAGN_BT_FLAG_COEX_MODE_SHIFT;
+		if (priv->cfg->bt_params &&
+		    priv->cfg->bt_params->bt_sco_disable)
+			bt_cmd.flags |= IWLAGN_BT_FLAG_SYNC_2_BT_DISABLE;
+
 		if (priv->bt_ch_announce)
 			bt_cmd.flags |= IWLAGN_BT_FLAG_CHANNEL_INHIBITION;
 		IWL_DEBUG_INFO(priv, "BT coex flag: 0X%x\n", bt_cmd.flags);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 9035cd8..3f7bd40 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -334,6 +334,7 @@ struct iwl_base_params {
  * @agg_time_limit: maximum number of uSec in aggregation
  * @ampdu_factor: Maximum A-MPDU length factor
  * @ampdu_density: Minimum A-MPDU spacing
+ * @bt_sco_disable: uCode should not response to BT in SCO/ESCO mode
 */
 struct iwl_bt_params {
 	bool advanced_bt_coexist;
@@ -343,6 +344,7 @@ struct iwl_bt_params {
 	u16 agg_time_limit;
 	u8 ampdu_factor;
 	u8 ampdu_density;
+	bool bt_sco_disable;
 };
 /*
  * @use_rts_for_aggregation: use rts/cts protection for HT traffic
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index b7abd86..306c852 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -163,6 +163,15 @@ static void iwl_static_sleep_cmd(struct iwl_priv *priv,
 	else
 		cmd->flags &= ~IWL_POWER_SLEEP_OVER_DTIM_MSK;
 
+	if (priv->cfg->bt_params &&
+	    priv->cfg->bt_params->advanced_bt_coexist) {
+		if (!priv->cfg->bt_params->bt_sco_disable)
+			cmd->flags |= IWL_POWER_BT_SCO_ENA;
+		else
+			cmd->flags &= ~IWL_POWER_BT_SCO_ENA;
+	}
+
+
 	slp_itrvl = le32_to_cpu(cmd->sleep_interval[IWL_POWER_VEC_SIZE - 1]);
 	if (slp_itrvl > IWL_CONN_MAX_LISTEN_INTERVAL)
 		cmd->sleep_interval[IWL_POWER_VEC_SIZE - 1] =
@@ -236,6 +245,14 @@ static void iwl_power_fill_sleep_cmd(struct iwl_priv *priv,
 	if (priv->power_data.pci_pm)
 		cmd->flags |= IWL_POWER_PCI_PM_MSK;
 
+	if (priv->cfg->bt_params &&
+	    priv->cfg->bt_params->advanced_bt_coexist) {
+		if (!priv->cfg->bt_params->bt_sco_disable)
+			cmd->flags |= IWL_POWER_BT_SCO_ENA;
+		else
+			cmd->flags &= ~IWL_POWER_BT_SCO_ENA;
+	}
+
 	cmd->rx_data_timeout = cpu_to_le32(1000 * dynps_ms);
 	cmd->tx_data_timeout = cpu_to_le32(1000 * dynps_ms);
 
-- 
1.7.0.4

