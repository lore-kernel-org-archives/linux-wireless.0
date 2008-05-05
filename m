Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:17420 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975AbYEECYM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 22:24:12 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 07/25] iwlwifi: generalize iwl4965_send_add_station function
Date: Mon,  5 May 2008 10:22:34 +0800
Message-Id: <1209954172-3092-8-git-send-email-yi.zhu@intel.com> (sfid-20080505_042354_432975_BF0A750C)
In-Reply-To: <1209954172-3092-7-git-send-email-yi.zhu@intel.com>
References: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-2-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-3-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-4-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-5-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-6-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-7-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch moves iwl4965_send_add_station to iwlcore
under new name iwl_send_add_sta.
Function uses build command handler in order to support
multiple HWs.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   28 +++++++++++--
 drivers/net/wireless/iwlwifi/iwl-commands.h |   46 +++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   10 ++--
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   54 ++++++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   51 +------------------------
 6 files changed, 127 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index f437326..47b6d64 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2931,7 +2931,7 @@ static void iwl4965_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id)
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
-	iwl4965_send_add_station(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
+	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
 }
 
 static void iwl4965_update_ps_mode(struct iwl_priv *priv, u16 ps_bit, u8 *addr)
@@ -3323,7 +3323,7 @@ static void iwl4965_sta_modify_enable_tid_tx(struct iwl_priv *priv,
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
-	iwl4965_send_add_station(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
+	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
 }
 
 /**
@@ -3875,7 +3875,7 @@ static int iwl4965_rx_agg_start(struct iwl_priv *priv,
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
-	return iwl4965_send_add_station(priv, &priv->stations[sta_id].sta,
+	return iwl_send_add_sta(priv, &priv->stations[sta_id].sta,
 					CMD_ASYNC);
 }
 
@@ -3896,7 +3896,7 @@ static int iwl4965_rx_agg_stop(struct iwl_priv *priv,
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
-	return iwl4965_send_add_station(priv, &priv->stations[sta_id].sta,
+	return iwl_send_add_sta(priv, &priv->stations[sta_id].sta,
 					CMD_ASYNC);
 }
 
@@ -4061,9 +4061,26 @@ int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
 	}
 	return 0;
 }
-
 #endif /* CONFIG_IWL4965_HT */
 
+
+static u16 iwl4965_build_addsta_hcmd(const struct iwl_addsta_cmd *cmd, u8 *data)
+{
+	struct iwl4965_addsta_cmd *addsta = (struct iwl4965_addsta_cmd *)data;
+	addsta->mode = cmd->mode;
+	memcpy(&addsta->sta, &cmd->sta, sizeof(struct sta_id_modify));
+	memcpy(&addsta->key, &cmd->key, sizeof(struct iwl4965_keyinfo));
+	addsta->station_flags = cmd->station_flags;
+	addsta->station_flags_msk = cmd->station_flags_msk;
+	addsta->tid_disable_tx = cmd->tid_disable_tx;
+	addsta->add_immediate_ba_tid = cmd->add_immediate_ba_tid;
+	addsta->remove_immediate_ba_tid = cmd->remove_immediate_ba_tid;
+	addsta->add_immediate_ba_ssn = cmd->add_immediate_ba_ssn;
+	addsta->reserved1 = __constant_cpu_to_le16(0);
+	addsta->reserved2 = __constant_cpu_to_le32(0);
+
+	return (u16)sizeof(struct iwl4965_addsta_cmd);
+}
 /* Set up 4965-specific Rx frame reply handlers */
 static void iwl4965_rx_handler_setup(struct iwl_priv *priv)
 {
@@ -4107,6 +4124,7 @@ static struct iwl_hcmd_ops iwl4965_hcmd = {
 
 static struct iwl_hcmd_utils_ops iwl4965_hcmd_utils = {
 	.enqueue_hcmd = iwl4965_enqueue_hcmd,
+	.build_addsta_hcmd = iwl4965_build_addsta_hcmd,
 #ifdef CONFIG_IWL4965_RUN_TIME_CALIB
 	.chain_noise_reset = iwl4965_chain_noise_reset,
 	.gain_computation = iwl4965_gain_computation,
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index e5449b8..d16a853 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -769,6 +769,20 @@ struct iwl4965_keyinfo {
 	u8 key[16];		/* 16-byte unicast decryption key */
 } __attribute__ ((packed));
 
+/* 5000 */
+struct iwl_keyinfo {
+	__le16 key_flags;
+	u8 tkip_rx_tsc_byte2;	/* TSC[2] for key mix ph1 detection */
+	u8 reserved1;
+	__le16 tkip_rx_ttak[5];	/* 10-byte unicast TKIP TTAK */
+	u8 key_offset;
+	u8 reserved2;
+	u8 key[16];		/* 16-byte unicast decryption key */
+	__le64 tx_secur_seq_cnt;
+	__le64 hw_tkip_mic_rx_key;
+	__le64 hw_tkip_mic_tx_key;
+} __attribute__ ((packed));
+
 /**
  * struct sta_id_modify
  * @addr[ETH_ALEN]: station's MAC address
@@ -844,6 +858,38 @@ struct iwl4965_addsta_cmd {
 	__le32 reserved2;
 } __attribute__ ((packed));
 
+/* 5000 */
+struct iwl_addsta_cmd {
+	u8 mode;		/* 1: modify existing, 0: add new station */
+	u8 reserved[3];
+	struct sta_id_modify sta;
+	struct iwl_keyinfo key;
+	__le32 station_flags;		/* STA_FLG_* */
+	__le32 station_flags_msk;	/* STA_FLG_* */
+
+	/* bit field to disable (1) or enable (0) Tx for Traffic ID (TID)
+	 * corresponding to bit (e.g. bit 5 controls TID 5).
+	 * Set modify_mask bit STA_MODIFY_TID_DISABLE_TX to use this field. */
+	__le16 tid_disable_tx;
+
+	__le16	reserved1;
+
+	/* TID for which to add block-ack support.
+	 * Set modify_mask bit STA_MODIFY_ADDBA_TID_MSK to use this field. */
+	u8 add_immediate_ba_tid;
+
+	/* TID for which to remove block-ack support.
+	 * Set modify_mask bit STA_MODIFY_DELBA_TID_MSK to use this field. */
+	u8 remove_immediate_ba_tid;
+
+	/* Starting Sequence Number for added block-ack support.
+	 * Set modify_mask bit STA_MODIFY_ADDBA_TID_MSK to use this field. */
+	__le16 add_immediate_ba_ssn;
+
+	__le32 reserved2;
+} __attribute__ ((packed));
+
+
 #define ADD_STA_SUCCESS_MSK		0x1
 #define ADD_STA_NO_ROOM_IN_TABLE	0x2
 #define ADD_STA_NO_BLOCK_ACK_RESOURCE	0x4
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 2356cad..df27ee6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -87,6 +87,7 @@ struct iwl_hcmd_ops {
 };
 struct iwl_hcmd_utils_ops {
 	int (*enqueue_hcmd)(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
+	u16 (*build_addsta_hcmd)(const struct iwl_addsta_cmd *cmd, u8 *data);
 #ifdef CONFIG_IWLWIFI_RUN_TIME_CALIB
 	void (*gain_computation)(struct iwl_priv *priv,
 			u32 *average_noise,
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 07eff75..4786194 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -319,7 +319,7 @@ struct iwl_cmd {
 	struct iwl_cmd_meta meta;	/* driver data */
 	struct iwl_cmd_header hdr;	/* uCode API */
 	union {
-		struct iwl4965_addsta_cmd addsta;
+		struct iwl_addsta_cmd addsta;
 		struct iwl4965_led_cmd led;
 		u32 flags;
 		u8 val8;
@@ -511,7 +511,7 @@ struct iwl4965_qos_info {
 #define STA_PS_STATUS_SLEEP            1
 
 struct iwl_station_entry {
-	struct iwl4965_addsta_cmd sta;
+	struct iwl_addsta_cmd sta;
 	struct iwl_tid_data tid[MAX_TID_COUNT];
 	u8 used;
 	u8 ps_status;
@@ -634,9 +634,9 @@ struct iwl_hw_params {
  * for use by iwl-*.c
  *
  *****************************************************************************/
-struct iwl4965_addsta_cmd;
-extern int iwl4965_send_add_station(struct iwl_priv *priv,
-				struct iwl4965_addsta_cmd *sta, u8 flags);
+struct iwl_addsta_cmd;
+extern int iwl_send_add_sta(struct iwl_priv *priv,
+			    struct iwl_addsta_cmd *sta, u8 flags);
 extern u8 iwl4965_add_station_flags(struct iwl_priv *priv, const u8 *addr,
 			  int is_ap, u8 flags, void *ht_data);
 extern int iwl4965_is_network_packet(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 0148d49..34f5424 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -70,6 +70,52 @@ u8 iwl_find_station(struct iwl_priv *priv, const u8 *addr)
 }
 EXPORT_SYMBOL(iwl_find_station);
 
+int iwl_send_add_sta(struct iwl_priv *priv,
+		     struct iwl_addsta_cmd *sta, u8 flags)
+{
+	struct iwl_rx_packet *res = NULL;
+	int ret = 0;
+	u8 data[sizeof(*sta)];
+	struct iwl_host_cmd cmd = {
+		.id = REPLY_ADD_STA,
+		.meta.flags = flags,
+		.data = data,
+	};
+
+	if (!(flags & CMD_ASYNC))
+		cmd.meta.flags |= CMD_WANT_SKB;
+
+	cmd.len = priv->cfg->ops->utils->build_addsta_hcmd(sta, data);
+	ret = iwl_send_cmd(priv, &cmd);
+
+	if (ret || (flags & CMD_ASYNC))
+		return ret;
+
+	res = (struct iwl_rx_packet *)cmd.meta.u.skb->data;
+	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
+		IWL_ERROR("Bad return from REPLY_ADD_STA (0x%08X)\n",
+			  res->hdr.flags);
+		ret = -EIO;
+	}
+
+	if (ret == 0) {
+		switch (res->u.add_sta.status) {
+		case ADD_STA_SUCCESS_MSK:
+			IWL_DEBUG_INFO("REPLY_ADD_STA PASSED\n");
+			break;
+		default:
+			ret = -EIO;
+			IWL_WARNING("REPLY_ADD_STA failed\n");
+			break;
+		}
+	}
+
+	priv->alloc_rxb_skb--;
+	dev_kfree_skb_any(cmd.meta.u.skb);
+
+	return ret;
+}
+EXPORT_SYMBOL(iwl_send_add_sta);
 
 int iwl_get_free_ucode_key_index(struct iwl_priv *priv)
 {
@@ -216,8 +262,7 @@ static int iwl_set_wep_dynamic_key_info(struct iwl_priv *priv,
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 
-	ret = iwl4965_send_add_station(priv,
-		&priv->stations[sta_id].sta, CMD_ASYNC);
+	ret = iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
 
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
@@ -265,8 +310,7 @@ static int iwl_set_ccmp_dynamic_key_info(struct iwl_priv *priv,
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
 	IWL_DEBUG_INFO("hwcrypto: modify ucode station key info\n");
-	return iwl4965_send_add_station(priv,
-				&priv->stations[sta_id].sta, CMD_ASYNC);
+	return iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
 }
 
 static int iwl_set_tkip_dynamic_key_info(struct iwl_priv *priv,
@@ -343,7 +387,7 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 
 	IWL_DEBUG_INFO("hwcrypto: clear ucode station key info\n");
-	ret =  iwl4965_send_add_station(priv, &priv->stations[sta_id].sta, 0);
+	ret =  iwl_send_add_sta(priv, &priv->stations[sta_id].sta, 0);
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 	return ret;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 661adf6..820b90a 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -476,7 +476,7 @@ u8 iwl4965_add_station_flags(struct iwl_priv *priv, const u8 *addr,
 	priv->num_stations++;
 
 	/* Set up the REPLY_ADD_STA command to send to device */
-	memset(&station->sta, 0, sizeof(struct iwl4965_addsta_cmd));
+	memset(&station->sta, 0, sizeof(struct iwl_addsta_cmd));
 	memcpy(station->sta.sta.addr, addr, ETH_ALEN);
 	station->sta.mode = 0;
 	station->sta.sta.sta_id = index;
@@ -493,7 +493,7 @@ u8 iwl4965_add_station_flags(struct iwl_priv *priv, const u8 *addr,
 	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
 
 	/* Add station to device's station table */
-	iwl4965_send_add_station(priv, &station->sta, flags);
+	iwl_send_add_sta(priv, &station->sta, flags);
 	return index;
 
 }
@@ -963,51 +963,6 @@ static int iwl4965_send_card_state(struct iwl_priv *priv, u32 flags, u8 meta_fla
 	return iwl_send_cmd(priv, &cmd);
 }
 
-int iwl4965_send_add_station(struct iwl_priv *priv,
-			 struct iwl4965_addsta_cmd *sta, u8 flags)
-{
-	struct iwl_rx_packet *res = NULL;
-	int rc = 0;
-	struct iwl_host_cmd cmd = {
-		.id = REPLY_ADD_STA,
-		.len = sizeof(struct iwl4965_addsta_cmd),
-		.meta.flags = flags,
-		.data = sta,
-	};
-
-	if (!(flags & CMD_ASYNC))
-		cmd.meta.flags |= CMD_WANT_SKB;
-
-	rc = iwl_send_cmd(priv, &cmd);
-
-	if (rc || (flags & CMD_ASYNC))
-		return rc;
-
-	res = (struct iwl_rx_packet *)cmd.meta.u.skb->data;
-	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
-		IWL_ERROR("Bad return from REPLY_ADD_STA (0x%08X)\n",
-			  res->hdr.flags);
-		rc = -EIO;
-	}
-
-	if (rc == 0) {
-		switch (res->u.add_sta.status) {
-		case ADD_STA_SUCCESS_MSK:
-			IWL_DEBUG_INFO("REPLY_ADD_STA PASSED\n");
-			break;
-		default:
-			rc = -EIO;
-			IWL_WARNING("REPLY_ADD_STA failed\n");
-			break;
-		}
-	}
-
-	priv->alloc_rxb_skb--;
-	dev_kfree_skb_any(cmd.meta.u.skb);
-
-	return rc;
-}
-
 static void iwl4965_clear_free_frames(struct iwl_priv *priv)
 {
 	struct list_head *element;
@@ -5928,7 +5883,7 @@ static void iwl4965_mac_update_tkip_key(struct ieee80211_hw *hw,
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 
-	iwl4965_send_add_station(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
+	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
 
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
-- 
1.5.3.6

