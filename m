Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42591 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659AbYFLBt7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 21:49:59 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 23/29] iwlwifi: move iwl4965_rf_kill_ct_config to iwl-core.c
Date: Thu, 12 Jun 2008 09:47:13 +0800
Message-Id: <1213235239-2954-24-git-send-email-yi.zhu@intel.com> (sfid-20080612_041917_046860_19C6034A)
In-Reply-To: <1213235239-2954-23-git-send-email-yi.zhu@intel.com>
References: <1213235239-2954-1-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-2-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-3-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-4-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-5-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-6-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-7-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-8-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-9-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-10-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-11-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-12-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-13-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-14-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-15-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-16-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-17-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-18-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-19-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-20-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-21-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-22-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-23-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch moves iwl4965_rf_kill_ct_config to iwl-core.c.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   24 ------------------------
 drivers/net/wireless/iwlwifi/iwl-commands.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c     |   23 +++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 5 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 87648d0..aeb29b9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -556,30 +556,6 @@ out:
 
 #define REG_RECALIB_PERIOD (60)
 
-void iwl4965_rf_kill_ct_config(struct iwl_priv *priv)
-{
-	struct iwl4965_ct_kill_config cmd;
-	unsigned long flags;
-	int ret = 0;
-
-	spin_lock_irqsave(&priv->lock, flags);
-	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR,
-		    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	cmd.critical_temperature_R =
-		cpu_to_le32(priv->hw_params.ct_kill_threshold);
-
-	ret = iwl_send_cmd_pdu(priv, REPLY_CT_KILL_CONFIG_CMD,
-			       sizeof(cmd), &cmd);
-	if (ret)
-		IWL_ERROR("REPLY_CT_KILL_CONFIG_CMD failed\n");
-	else
-		IWL_DEBUG_INFO("REPLY_CT_KILL_CONFIG_CMD succeeded, "
-			"critical temperature is %d\n",
-			cmd.critical_temperature_R);
-}
-
 /* Reset differential Rx gains in NIC to prepare for chain noise calibration.
  * Called after every association, but this runs only once!
  *  ... once chain noise is calibrated the first time, it's good forever.  */
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 6613d32..920dfc1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2078,7 +2078,7 @@ struct iwl4965_card_state_notif {
 #define RF_CARD_DISABLED   0x04
 #define RXON_CARD_DISABLED 0x10
 
-struct iwl4965_ct_kill_config {
+struct iwl_ct_kill_config {
 	__le32   reserved;
 	__le32   critical_temperature_M;
 	__le32   critical_temperature_R;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 9794904..8096463 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1326,4 +1326,27 @@ void iwl_dump_nic_event_log(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_dump_nic_event_log);
 
+void iwl_rf_kill_ct_config(struct iwl_priv *priv)
+{
+	struct iwl_ct_kill_config cmd;
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR,
+		    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	cmd.critical_temperature_R =
+		cpu_to_le32(priv->hw_params.ct_kill_threshold);
 
+	ret = iwl_send_cmd_pdu(priv, REPLY_CT_KILL_CONFIG_CMD,
+			       sizeof(cmd), &cmd);
+	if (ret)
+		IWL_ERROR("REPLY_CT_KILL_CONFIG_CMD failed\n");
+	else
+		IWL_DEBUG_INFO("REPLY_CT_KILL_CONFIG_CMD succeeded, "
+			"critical temperature is %d\n",
+			cmd.critical_temperature_R);
+}
+EXPORT_SYMBOL(iwl_rf_kill_ct_config);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 8d9fde6..59dd342 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -371,6 +371,7 @@ int iwlcore_low_level_notify(struct iwl_priv *priv,
 			     enum iwlcore_card_notify notify);
 extern int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags);
 extern int iwl_verify_ucode(struct iwl_priv *priv);
+extern void iwl_rf_kill_ct_config(struct iwl_priv *priv);
 int iwl_send_lq_cmd(struct iwl_priv *priv,
 		    struct iwl_link_quality_cmd *lq, u8 flags);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 2073ba6..3717f99 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2295,7 +2295,7 @@ static void iwl_alive_start(struct iwl_priv *priv)
 	iwl4965_commit_rxon(priv);
 
 	/* At this point, the NIC is initialized and operational */
-	iwl4965_rf_kill_ct_config(priv);
+	iwl_rf_kill_ct_config(priv);
 
 	iwl_leds_register(priv);
 
-- 
1.5.3.6

