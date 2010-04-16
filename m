Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14249 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932596Ab0DPVwp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 17:52:45 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 17/21] iwlwifi: make BT coex config a virtual method
Date: Fri, 16 Apr 2010 14:52:34 -0700
Message-Id: <1271454758-14351-18-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
References: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some future hardware will require a different command to
be sent for bluetooth coexist, so make this a virtual
method that can be changed on a per-device basis.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c     |    7 ++++---
 drivers/net/wireless/iwlwifi/iwl-core.h     |    3 ++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 7 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 51f1895..d10e59d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2687,6 +2687,7 @@ IWL3945_UCODE_GET(boot_size);
 static struct iwl_hcmd_ops iwl3945_hcmd = {
 	.rxon_assoc = iwl3945_send_rxon_assoc,
 	.commit_rxon = iwl3945_commit_rxon,
+	.send_bt_config = iwl_send_bt_config,
 };
 
 static struct iwl_ucode_ops iwl3945_ucode = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 8567297..2861819 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2144,6 +2144,7 @@ static struct iwl_hcmd_ops iwl4965_hcmd = {
 	.rxon_assoc = iwl4965_send_rxon_assoc,
 	.commit_rxon = iwl_commit_rxon,
 	.set_rxon_chain = iwl_set_rxon_chain,
+	.send_bt_config = iwl_send_bt_config,
 };
 
 static struct iwl_ucode_ops iwl4965_ucode = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index 231d0e6..44ef5d9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -262,6 +262,7 @@ struct iwl_hcmd_ops iwlagn_hcmd = {
 	.commit_rxon = iwl_commit_rxon,
 	.set_rxon_chain = iwl_set_rxon_chain,
 	.set_tx_ant = iwlagn_send_tx_ant_config,
+	.send_bt_config = iwl_send_bt_config,
 };
 
 struct iwl_hcmd_utils_ops iwlagn_hcmd_utils = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 1f3c5d5..c22d3d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2173,7 +2173,7 @@ static void iwl_alive_start(struct iwl_priv *priv)
 	}
 
 	/* Configure Bluetooth device coexistence support */
-	iwl_send_bt_config(priv);
+	priv->cfg->ops->hcmd->send_bt_config(priv);
 
 	iwl_reset_run_time_calib(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 9d300b2..aa86ef9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1479,7 +1479,7 @@ irqreturn_t iwl_isr_legacy(int irq, void *data)
 }
 EXPORT_SYMBOL(iwl_isr_legacy);
 
-int iwl_send_bt_config(struct iwl_priv *priv)
+void iwl_send_bt_config(struct iwl_priv *priv)
 {
 	struct iwl_bt_cmd bt_cmd = {
 		.lead_time = BT_LEAD_TIME_DEF,
@@ -1496,8 +1496,9 @@ int iwl_send_bt_config(struct iwl_priv *priv)
 	IWL_DEBUG_INFO(priv, "BT coex %s\n",
 		(bt_cmd.flags == BT_COEX_DISABLE) ? "disable" : "active");
 
-	return iwl_send_cmd_pdu(priv, REPLY_BT_CONFIG,
-				sizeof(struct iwl_bt_cmd), &bt_cmd);
+	if (iwl_send_cmd_pdu(priv, REPLY_BT_CONFIG,
+			     sizeof(struct iwl_bt_cmd), &bt_cmd))
+		IWL_ERR(priv, "failed to send BT Coex Config\n");
 }
 EXPORT_SYMBOL(iwl_send_bt_config);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 2a3b173..d9ec030 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -90,6 +90,7 @@ struct iwl_hcmd_ops {
 	int (*commit_rxon)(struct iwl_priv *priv);
 	void (*set_rxon_chain)(struct iwl_priv *priv);
 	int (*set_tx_ant)(struct iwl_priv *priv, u8 valid_tx_ant);
+	void (*send_bt_config)(struct iwl_priv *priv);
 };
 
 struct iwl_hcmd_utils_ops {
@@ -677,7 +678,7 @@ static inline int iwl_is_ready_rf(struct iwl_priv *priv)
 }
 
 extern void iwl_rf_kill_ct_config(struct iwl_priv *priv);
-extern int iwl_send_bt_config(struct iwl_priv *priv);
+extern void iwl_send_bt_config(struct iwl_priv *priv);
 extern int iwl_send_statistics_request(struct iwl_priv *priv,
 				       u8 flags, bool clear);
 extern int iwl_verify_ucode(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 8da3375..64b20e7 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2526,7 +2526,7 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 	}
 
 	/* Configure Bluetooth device coexistence support */
-	iwl_send_bt_config(priv);
+	priv->cfg->ops->hcmd->send_bt_config(priv);
 
 	/* Configure the adapter for unassociated operation */
 	iwlcore_commit_rxon(priv);
-- 
1.6.3.3

