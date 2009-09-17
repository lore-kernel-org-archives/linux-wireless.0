Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9689 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755166AbZIQRn4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 13:43:56 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/13] iwlwifi: send cmd to uCode to configure valid tx antenna
Date: Thu, 17 Sep 2009 10:43:51 -0700
Message-Id: <1253209436-2309-9-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1253209436-2309-1-git-send-email-reinette.chatre@intel.com>
References: <1253209436-2309-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

In order for uCode to select the valid antennas for transmit, driver
need to configure the allowed tx antennas through host command.

The TX_ANT_CONFIGURATION_CMD should be used for 5000 series and up

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   19 +++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    4 ++++
 drivers/net/wireless/iwlwifi/iwl-commands.h |   12 +++++++++++-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 4 files changed, 35 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 00b07f0..2bb282e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1444,6 +1444,24 @@ int iwl5000_calc_rssi(struct iwl_priv *priv,
 	return max_rssi - agc - IWL49_RSSI_OFFSET;
 }
 
+static int iwl5000_send_tx_ant_config(struct iwl_priv *priv, u8 valid_tx_ant)
+{
+	struct iwl_tx_ant_config_cmd tx_ant_cmd = {
+	  .valid = cpu_to_le32(valid_tx_ant),
+	};
+
+	if (IWL_UCODE_API(priv->ucode_ver) > 1) {
+		IWL_DEBUG_HC(priv, "select valid tx ant: %u\n", valid_tx_ant);
+		return iwl_send_cmd_pdu(priv, TX_ANT_CONFIGURATION_CMD,
+					sizeof(struct iwl_tx_ant_config_cmd),
+					&tx_ant_cmd);
+	} else {
+		IWL_DEBUG_HC(priv, "TX_ANT_CONFIGURATION_CMD not supported\n");
+		return -EOPNOTSUPP;
+	}
+}
+
+
 #define IWL5000_UCODE_GET(item)						\
 static u32 iwl5000_ucode_get_##item(const struct iwl_ucode_header *ucode,\
 				    u32 api_ver)			\
@@ -1486,6 +1504,7 @@ struct iwl_hcmd_ops iwl5000_hcmd = {
 	.rxon_assoc = iwl5000_send_rxon_assoc,
 	.commit_rxon = iwl_commit_rxon,
 	.set_rxon_chain = iwl_set_rxon_chain,
+	.set_tx_ant = iwl5000_send_tx_ant_config,
 };
 
 struct iwl_hcmd_utils_ops iwl5000_hcmd_utils = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index f726b42..cc7a5a9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1577,6 +1577,10 @@ static void iwl_alive_start(struct iwl_priv *priv)
 	priv->active_rate = priv->rates_mask;
 	priv->active_rate_basic = priv->rates_mask & IWL_BASIC_RATES_MASK;
 
+	/* Configure Tx antenna selection based on H/W config */
+	if (priv->cfg->ops->hcmd->set_tx_ant)
+		priv->cfg->ops->hcmd->set_tx_ant(priv, priv->cfg->valid_tx_ant);
+
 	if (iwl_is_associated(priv)) {
 		struct iwl_rxon_cmd *active_rxon =
 				(struct iwl_rxon_cmd *)&priv->active_rxon;
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 2c5c88f..e5f40f3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -148,7 +148,7 @@ enum {
 	QUIET_NOTIFICATION = 0x96,		/* not used */
 	REPLY_TX_PWR_TABLE_CMD = 0x97,
 	REPLY_TX_POWER_DBM_CMD_V1 = 0x98,	/* old version of API */
-	TX_ANT_CONFIGURATION_CMD = 0x98,	/* not used */
+	TX_ANT_CONFIGURATION_CMD = 0x98,
 	MEASURE_ABORT_NOTIFICATION = 0x99,	/* not used */
 
 	/* Bluetooth device coexistence config command */
@@ -411,6 +411,16 @@ struct iwl5000_tx_power_dbm_cmd {
 	u8 reserved;
 } __attribute__ ((packed));
 
+/**
+ * Command TX_ANT_CONFIGURATION_CMD = 0x98
+ * This command is used to configure valid Tx antenna.
+ * By default uCode concludes the valid antenna according to the radio flavor.
+ * This command enables the driver to override/modify this conclusion.
+ */
+struct iwl_tx_ant_config_cmd {
+	__le32 valid;
+} __attribute__ ((packed));
+
 /******************************************************************************
  * (0a)
  * Alive and Error Commands & Responses:
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 4f7c133..3791c87 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -89,6 +89,7 @@ struct iwl_hcmd_ops {
 	int (*rxon_assoc)(struct iwl_priv *priv);
 	int (*commit_rxon)(struct iwl_priv *priv);
 	void (*set_rxon_chain)(struct iwl_priv *priv);
+	int (*set_tx_ant)(struct iwl_priv *priv, u8 valid_tx_ant);
 };
 
 struct iwl_hcmd_utils_ops {
-- 
1.5.6.3

