Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:27461 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758859AbYEWCLL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 22:11:11 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Gregory Greenman <gregory.greenman@intel.com>,
	Zhu Yi <yi.zhu@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] iwlwifi: get_hw_cmd_size
Date: Fri, 23 May 2008 10:08:45 +0800
Message-Id: <1211508569-3163-8-git-send-email-yi.zhu@intel.com> (sfid-20080523_041120_324345_7B474477)
In-Reply-To: <1211508569-3163-7-git-send-email-yi.zhu@intel.com>
References: <1211508569-3163-1-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-2-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-3-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-4-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-5-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-6-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-7-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

This patch introduces a new handler get_hw_cmd_size in hcmd_utils,
which should adjust the size of the command sent to the microcode
according to the current nic.
It also changes the RXON flow to make usage of this new handler.

The patch also adds iwl_rxon_cmd structure which is supperset for
5000 HW and 4965.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   15 +++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    7 +++++++
 drivers/net/wireless/iwlwifi/iwl-commands.h |   26 ++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    6 +++---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   25 ++++++++++++++-----------
 7 files changed, 65 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 2bb0075..83876a0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1857,8 +1857,8 @@ static int iwl4965_send_rxon_assoc(struct iwl_priv *priv)
 {
 	int ret = 0;
 	struct iwl4965_rxon_assoc_cmd rxon_assoc;
-	const struct iwl4965_rxon_cmd *rxon1 = &priv->staging_rxon;
-	const struct iwl4965_rxon_cmd *rxon2 = &priv->active_rxon;
+	const struct iwl_rxon_cmd *rxon1 = &priv->staging_rxon;
+	const struct iwl_rxon_cmd *rxon2 = &priv->active_rxon;
 
 	if ((rxon1->flags == rxon2->flags) &&
 	    (rxon1->filter_flags == rxon2->filter_flags) &&
@@ -3743,6 +3743,16 @@ int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
 #endif /* CONFIG_IWL4965_HT */
 
 
+static u16 iwl4965_get_hcmd_size(u8 cmd_id, u16 len)
+{
+	switch (cmd_id) {
+	case REPLY_RXON:
+		return (u16) sizeof(struct iwl4965_rxon_cmd);
+	default:
+		return len;
+	}
+}
+
 static u16 iwl4965_build_addsta_hcmd(const struct iwl_addsta_cmd *cmd, u8 *data)
 {
 	struct iwl4965_addsta_cmd *addsta = (struct iwl4965_addsta_cmd *)data;
@@ -3802,6 +3812,7 @@ static struct iwl_hcmd_ops iwl4965_hcmd = {
 };
 
 static struct iwl_hcmd_utils_ops iwl4965_hcmd_utils = {
+	.get_hcmd_size = iwl4965_get_hcmd_size,
 	.enqueue_hcmd = iwl4965_enqueue_hcmd,
 	.build_addsta_hcmd = iwl4965_build_addsta_hcmd,
 #ifdef CONFIG_IWL4965_RUN_TIME_CALIB
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index b5e28b8..72d655c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -459,10 +459,17 @@ static int iwl5000_disable_tx_fifo(struct iwl_priv *priv)
 	return 0;
 }
 
+/* Currently 5000 is the supperset of everything */
+static u16 iwl5000_get_hcmd_size(u8 cmd_id, u16 len)
+{
+	return len;
+}
+
 static struct iwl_hcmd_ops iwl5000_hcmd = {
 };
 
 static struct iwl_hcmd_utils_ops iwl5000_hcmd_utils = {
+	.get_hcmd_size = iwl5000_get_hcmd_size,
 	.build_addsta_hcmd = iwl5000_build_addsta_hcmd,
 #ifdef CONFIG_IWL5000_RUN_TIME_CALIB
 	.gain_computation = iwl5000_gain_computation,
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index d16a853..350af1b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -600,6 +600,32 @@ struct iwl4965_rxon_cmd {
 	u8 ofdm_ht_dual_stream_basic_rates;
 } __attribute__ ((packed));
 
+/* 5000 HW just extend this cmmand */
+struct iwl_rxon_cmd {
+	u8 node_addr[6];
+	__le16 reserved1;
+	u8 bssid_addr[6];
+	__le16 reserved2;
+	u8 wlap_bssid_addr[6];
+	__le16 reserved3;
+	u8 dev_type;
+	u8 air_propagation;
+	__le16 rx_chain;
+	u8 ofdm_basic_rates;
+	u8 cck_basic_rates;
+	__le16 assoc_id;
+	__le32 flags;
+	__le32 filter_flags;
+	__le16 channel;
+	u8 ofdm_ht_single_stream_basic_rates;
+	u8 ofdm_ht_dual_stream_basic_rates;
+	u8 ofdm_ht_triple_stream_basic_rates;
+	u8 reserved5;
+	__le16 acquisition_data;
+	__le16 reserved6;
+} __attribute__ ((packed));
+
+
 /*
  * REPLY_RXON_ASSOC = 0x11 (command, has simple generic response)
  */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index a2f4f28..b800031 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -588,7 +588,7 @@ EXPORT_SYMBOL(iwl_is_fat_tx_allowed);
 
 void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_info *ht_info)
 {
-	struct iwl4965_rxon_cmd *rxon = &priv->staging_rxon;
+	struct iwl_rxon_cmd *rxon = &priv->staging_rxon;
 	u32 val;
 
 	if (!ht_info->is_ht)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index e139c8f..dcf1e56 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -86,6 +86,7 @@ struct iwl_hcmd_ops {
 	int (*rxon_assoc)(struct iwl_priv *priv);
 };
 struct iwl_hcmd_utils_ops {
+	u16 (*get_hcmd_size)(u8 cmd_id, u16 len);
 	int (*enqueue_hcmd)(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
 	u16 (*build_addsta_hcmd)(const struct iwl_addsta_cmd *cmd, u8 *data);
 #ifdef CONFIG_IWLWIFI_RUN_TIME_CALIB
@@ -303,5 +304,4 @@ static inline int iwl_send_rxon_assoc(struct iwl_priv *priv)
 	return priv->cfg->ops->hcmd->rxon_assoc(priv);
 }
 
-
 #endif /* __iwl_core_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index ae18a80..9a842fd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1009,11 +1009,11 @@ struct iwl_priv {
 	 * changed via explicit cast within the
 	 * routines that actually update the physical
 	 * hardware */
-	const struct iwl4965_rxon_cmd active_rxon;
-	struct iwl4965_rxon_cmd staging_rxon;
+	const struct iwl_rxon_cmd active_rxon;
+	struct iwl_rxon_cmd staging_rxon;
 
 	int error_recovering;
-	struct iwl4965_rxon_cmd recovery_rxon;
+	struct iwl_rxon_cmd recovery_rxon;
 
 	/* 1st responses from initialize and runtime uCode images.
 	 * 4965's initialize alive response contains some calibration data. */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 6e70405..45b6b52 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -353,11 +353,14 @@ int iwl4965_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	u32 *control_flags;
 	struct iwl_cmd *out_cmd;
 	u32 idx;
-	u16 fix_size = (u16)(cmd->len + sizeof(out_cmd->hdr));
+	u16 fix_size;
 	dma_addr_t phys_addr;
 	int ret;
 	unsigned long flags;
 
+	cmd->len = priv->cfg->ops->utils->get_hcmd_size(cmd->id, cmd->len);
+	fix_size = (u16)(cmd->len + sizeof(out_cmd->hdr));
+
 	/* If any of the command structures end up being larger than
 	 * the TFD_MAX_PAYLOAD_SIZE, and it sent as a 'small' command then
 	 * we will need to increase the size of the TFD entries */
@@ -422,7 +425,7 @@ int iwl4965_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 
 static void iwl4965_set_rxon_hwcrypto(struct iwl_priv *priv, int hw_decrypt)
 {
-	struct iwl4965_rxon_cmd *rxon = &priv->staging_rxon;
+	struct iwl_rxon_cmd *rxon = &priv->staging_rxon;
 
 	if (hw_decrypt)
 		rxon->filter_flags &= ~RXON_FILTER_DIS_DECRYPT_MSK;
@@ -470,7 +473,7 @@ static int iwl4965_rxon_add_station(struct iwl_priv *priv,
  * be #ifdef'd out once the driver is stable and folks aren't actively
  * making changes
  */
-static int iwl4965_check_rxon_cmd(struct iwl4965_rxon_cmd *rxon)
+static int iwl4965_check_rxon_cmd(struct iwl_rxon_cmd *rxon)
 {
 	int error = 0;
 	int counter = 1;
@@ -595,7 +598,7 @@ static int iwl4965_full_rxon_required(struct iwl_priv *priv)
 static int iwl4965_commit_rxon(struct iwl_priv *priv)
 {
 	/* cast away the const for active_rxon in this function */
-	struct iwl4965_rxon_cmd *active_rxon = (void *)&priv->active_rxon;
+	struct iwl_rxon_cmd *active_rxon = (void *)&priv->active_rxon;
 	DECLARE_MAC_BUF(mac);
 	int rc = 0;
 
@@ -640,7 +643,7 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 
 		rc = iwl_send_cmd_pdu(priv, REPLY_RXON,
-				      sizeof(struct iwl4965_rxon_cmd),
+				      sizeof(struct iwl_rxon_cmd),
 				      &priv->active_rxon);
 
 		/* If the mask clearing failed then we set
@@ -665,7 +668,7 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 	iwl4965_set_rxon_hwcrypto(priv, !priv->hw_params.sw_crypto);
 	/* Apply the new configuration */
 	rc = iwl_send_cmd_pdu(priv, REPLY_RXON,
-			      sizeof(struct iwl4965_rxon_cmd), &priv->staging_rxon);
+			      sizeof(struct iwl_rxon_cmd), &priv->staging_rxon);
 	if (rc) {
 		IWL_ERROR("Error setting new configuration (%d).\n", rc);
 		return rc;
@@ -2699,7 +2702,7 @@ static void iwl4965_rx_reply_error(struct iwl_priv *priv,
 static void iwl4965_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
-	struct iwl4965_rxon_cmd *rxon = (void *)&priv->active_rxon;
+	struct iwl_rxon_cmd *rxon = (void *)&priv->active_rxon;
 	struct iwl4965_csa_notification *csa = &(pkt->u.csa_notif);
 	IWL_DEBUG_11H("CSA notif: channel %d, status %d\n",
 		      le16_to_cpu(csa->channel), le32_to_cpu(csa->status));
@@ -3317,7 +3320,7 @@ static int iwl4965_tx_queue_update_write_ptr(struct iwl_priv *priv,
 #ifdef CONFIG_IWLWIFI_DEBUG
 static void iwl4965_print_rx_config_cmd(struct iwl_priv *priv)
 {
-	struct iwl4965_rxon_cmd *rxon = &priv->staging_rxon;
+	struct iwl_rxon_cmd *rxon = &priv->staging_rxon;
 	DECLARE_MAC_BUF(mac);
 
 	IWL_DEBUG_RADIO("RX CONFIG:\n");
@@ -4213,8 +4216,8 @@ static void iwl4965_alive_start(struct iwl_priv *priv)
 	priv->active_rate_basic = priv->rates_mask & IWL_BASIC_RATES_MASK;
 
 	if (iwl_is_associated(priv)) {
-		struct iwl4965_rxon_cmd *active_rxon =
-				(struct iwl4965_rxon_cmd *)(&priv->active_rxon);
+		struct iwl_rxon_cmd *active_rxon =
+				(struct iwl_rxon_cmd *)&priv->active_rxon;
 
 		memcpy(&priv->staging_rxon, &priv->active_rxon,
 		       sizeof(priv->staging_rxon));
@@ -5021,7 +5024,7 @@ static int iwl4965_mac_start(struct ieee80211_hw *hw)
 	/* we should be verifying the device is ready to be opened */
 	mutex_lock(&priv->mutex);
 
-	memset(&priv->staging_rxon, 0, sizeof(struct iwl4965_rxon_cmd));
+	memset(&priv->staging_rxon, 0, sizeof(struct iwl_rxon_cmd));
 	/* fetch ucode file from disk, alloc and copy to bus-master buffers ...
 	 * ucode filename and max sizes are card-specific. */
 
-- 
1.5.3.6

