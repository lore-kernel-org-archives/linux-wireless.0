Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:54315 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934109AbYCSXtn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 19:49:43 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/7] tkip: revert TKIP patches
Date: Wed, 19 Mar 2008 16:41:40 -0700
Message-Id: <1205970106-22196-2-git-send-email-reinette.chatre@intel.com> (sfid-20080319_235015_888767_B096BFC9)
In-Reply-To: <1205970106-22196-1-git-send-email-reinette.chatre@intel.com>
References: <1205970106-22196-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch revert tkip patches in mac80211 and iwlwifi

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-commands.h |   10 -
 drivers/net/wireless/iwlwifi/iwl-4965.c          |   66 -------
 drivers/net/wireless/iwlwifi/iwl4965-base.c      |  226 ++++++----------------
 include/net/mac80211.h                           |   15 --
 net/mac80211/ieee80211_i.h                       |    2 -
 net/mac80211/tkip.c                              |   17 +--
 net/mac80211/tx.c                                |   12 --
 net/mac80211/wpa.c                               |   27 +---
 8 files changed, 64 insertions(+), 311 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
index 5107100..1025ffe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
@@ -741,7 +741,6 @@ struct iwl4965_qosparam_cmd {
 /* wep key in STA: 5-bytes (0) or 13-bytes (1) */
 #define STA_KEY_FLG_KEY_SIZE_MSK     __constant_cpu_to_le16(0x1000)
 #define STA_KEY_MULTICAST_MSK        __constant_cpu_to_le16(0x4000)
-#define STA_KEY_MAX_NUM		8
 
 /* Flags indicate whether to modify vs. don't change various station params */
 #define	STA_MODIFY_KEY_MASK		0x01
@@ -890,10 +889,6 @@ struct iwl4965_rx_frame_hdr {
 #define RX_RES_STATUS_SEC_TYPE_WEP	(0x1 << 8)
 #define RX_RES_STATUS_SEC_TYPE_CCMP	(0x2 << 8)
 #define RX_RES_STATUS_SEC_TYPE_TKIP	(0x3 << 8)
-#define RX_RES_STATUS_SEC_TYPE_ERR	(0x7 << 8)
-
-#define RX_RES_STATUS_STATION_FOUND	(1<<6)
-#define RX_RES_STATUS_NO_STATION_INFO_MISMATCH	(1<<7)
 
 #define RX_RES_STATUS_DECRYPT_TYPE_MSK	(0x3 << 11)
 #define RX_RES_STATUS_NOT_DECRYPT	(0x0 << 11)
@@ -901,11 +896,6 @@ struct iwl4965_rx_frame_hdr {
 #define RX_RES_STATUS_BAD_ICV_MIC	(0x1 << 11)
 #define RX_RES_STATUS_BAD_KEY_TTAK	(0x2 << 11)
 
-#define RX_MPDU_RES_STATUS_ICV_OK	(0x20)
-#define RX_MPDU_RES_STATUS_MIC_OK	(0x40)
-#define RX_MPDU_RES_STATUS_TTAK_OK	(1 << 7)
-#define RX_MPDU_RES_STATUS_DEC_DONE_MSK	(0x800)
-
 struct iwl4965_rx_frame_end {
 	__le32 status;
 	__le64 timestamp;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 376968f..5fe42ae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3401,65 +3401,6 @@ static void iwl_update_rx_stats(struct iwl_priv *priv, u16 fc, u16 len)
 	priv->rx_stats[idx].bytes += len;
 }
 
-static u32 iwl4965_translate_rx_status(u32 decrypt_in)
-{
-	u32 decrypt_out = 0;
-
-	if ((decrypt_in & RX_RES_STATUS_STATION_FOUND) ==
-					RX_RES_STATUS_STATION_FOUND)
-		decrypt_out |= (RX_RES_STATUS_STATION_FOUND |
-				RX_RES_STATUS_NO_STATION_INFO_MISMATCH);
-
-	decrypt_out |= (decrypt_in & RX_RES_STATUS_SEC_TYPE_MSK);
-
-	/* packet was not encrypted */
-	if ((decrypt_in & RX_RES_STATUS_SEC_TYPE_MSK) ==
-					RX_RES_STATUS_SEC_TYPE_NONE)
-		return decrypt_out;
-
-	/* packet was encrypted with unknown alg */
-	if ((decrypt_in & RX_RES_STATUS_SEC_TYPE_MSK) ==
-					RX_RES_STATUS_SEC_TYPE_ERR)
-		return decrypt_out;
-
-	/* decryption was not done in HW */
-	if ((decrypt_in & RX_MPDU_RES_STATUS_DEC_DONE_MSK) !=
-					RX_MPDU_RES_STATUS_DEC_DONE_MSK)
-		return decrypt_out;
-
-	switch (decrypt_in & RX_RES_STATUS_SEC_TYPE_MSK) {
-
-	case RX_RES_STATUS_SEC_TYPE_CCMP:
-		/* alg is CCM: check MIC only */
-		if (!(decrypt_in & RX_MPDU_RES_STATUS_MIC_OK))
-			/* Bad MIC */
-			decrypt_out |= RX_RES_STATUS_BAD_ICV_MIC;
-		else
-			decrypt_out |= RX_RES_STATUS_DECRYPT_OK;
-
-		break;
-
-	case RX_RES_STATUS_SEC_TYPE_TKIP:
-		if (!(decrypt_in & RX_MPDU_RES_STATUS_TTAK_OK)) {
-			/* Bad TTAK */
-			decrypt_out |= RX_RES_STATUS_BAD_KEY_TTAK;
-			break;
-		}
-		/* fall through if TTAK OK */
-	default:
-		if (!(decrypt_in & RX_MPDU_RES_STATUS_ICV_OK))
-			decrypt_out |= RX_RES_STATUS_BAD_ICV_MIC;
-		else
-			decrypt_out |= RX_RES_STATUS_DECRYPT_OK;
-		break;
-	};
-
-	IWL_DEBUG_RX("decrypt_in:0x%x  decrypt_out = 0x%x\n",
-					decrypt_in, decrypt_out);
-
-	return decrypt_out;
-}
-
 static void iwl4965_handle_data_packet(struct iwl_priv *priv, int is_data,
 				       int include_phy,
 				       struct iwl4965_rx_mem_buffer *rxb,
@@ -3473,7 +3414,6 @@ static void iwl4965_handle_data_packet(struct iwl_priv *priv, int is_data,
 	__le32 *rx_end;
 	unsigned int skblen;
 	u32 ampdu_status;
-	u32 ampdu_status_legacy;
 
 	if (!include_phy && priv->last_phy_res[0])
 		rx_start = (struct iwl4965_rx_phy_res *)&priv->last_phy_res[1];
@@ -3510,12 +3450,6 @@ static void iwl4965_handle_data_packet(struct iwl_priv *priv, int is_data,
 	ampdu_status = le32_to_cpu(*rx_end);
 	skblen = ((u8 *) rx_end - (u8 *) & pkt->u.raw[0]) + sizeof(u32);
 
-	if (!include_phy) {
-		/* New status scheme, need to translate */
-		ampdu_status_legacy = ampdu_status;
-		ampdu_status = iwl4965_translate_rx_status(ampdu_status);
-	}
-
 	/* start from MAC */
 	skb_reserve(rxb->skb, (void *)hdr - (void *)pkt);
 	skb_put(rxb->skb, len);	/* end where data ends */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 7ba4f1a..43f251c 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -788,17 +788,6 @@ out:
 	return ret;
 }
 
-static void iwl4965_set_rxon_hwcrypto(struct iwl_priv *priv, int hw_decrypt)
-{
-	struct iwl4965_rxon_cmd *rxon = &priv->staging_rxon;
-
-	if (hw_decrypt)
-		rxon->filter_flags &= ~RXON_FILTER_DIS_DECRYPT_MSK;
-	else
-		rxon->filter_flags |= RXON_FILTER_DIS_DECRYPT_MSK;
-
-}
-
 int iwl4965_send_cmd(struct iwl_priv *priv, struct iwl4965_host_cmd *cmd)
 {
 	if (cmd->meta.flags & CMD_ASYNC)
@@ -1127,7 +1116,6 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 		       le16_to_cpu(priv->staging_rxon.channel),
 		       print_mac(mac, priv->staging_rxon.bssid_addr));
 
-	iwl4965_set_rxon_hwcrypto(priv, priv->cfg->mod_params->hw_crypto);
 	/* Apply the new configuration */
 	rc = iwl4965_send_cmd_pdu(priv, REPLY_RXON,
 			      sizeof(struct iwl4965_rxon_cmd), &priv->staging_rxon);
@@ -1340,36 +1328,33 @@ int iwl4965_send_add_station(struct iwl_priv *priv,
 	return rc;
 }
 
-static int iwl4965_set_ccmp_dynamic_key_info(struct iwl_priv *priv,
+static int iwl4965_update_sta_key_info(struct iwl_priv *priv,
 				   struct ieee80211_key_conf *keyconf,
 				   u8 sta_id)
 {
 	unsigned long flags;
 	__le16 key_flags = 0;
 
-	key_flags |= (STA_KEY_FLG_CCMP | STA_KEY_FLG_MAP_KEY_MSK);
-	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
-
-	if (sta_id == priv->hw_setting.bcast_sta_id)
-		key_flags |= STA_KEY_MULTICAST_MSK;
-
-	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
-	keyconf->hw_key_idx = sta_id;
-
-	key_flags &= ~STA_KEY_FLG_INVALID;
-
+	switch (keyconf->alg) {
+	case ALG_CCMP:
+		key_flags |= STA_KEY_FLG_CCMP;
+		key_flags |= cpu_to_le16(
+				keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
+		key_flags &= ~STA_KEY_FLG_INVALID;
+		break;
+	case ALG_TKIP:
+	case ALG_WEP:
+	default:
+		return -EINVAL;
+	}
 	spin_lock_irqsave(&priv->sta_lock, flags);
 	priv->stations[sta_id].keyinfo.alg = keyconf->alg;
 	priv->stations[sta_id].keyinfo.keylen = keyconf->keylen;
-
 	memcpy(priv->stations[sta_id].keyinfo.key, keyconf->key,
 	       keyconf->keylen);
 
 	memcpy(priv->stations[sta_id].sta.key.key, keyconf->key,
 	       keyconf->keylen);
-
-	priv->stations[sta_id].sta.key.key_offset
-			= (sta_id % STA_KEY_MAX_NUM);/*FIXME*/
 	priv->stations[sta_id].sta.key.key_flags = key_flags;
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
@@ -1377,66 +1362,8 @@ static int iwl4965_set_ccmp_dynamic_key_info(struct iwl_priv *priv,
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
 	IWL_DEBUG_INFO("hwcrypto: modify ucode station key info\n");
-	return iwl4965_send_add_station(priv,
-				&priv->stations[sta_id].sta, CMD_ASYNC);
-}
-
-static int iwl4965_set_tkip_dynamic_key_info(struct iwl_priv *priv,
-				   struct ieee80211_key_conf *keyconf,
-				   u8 sta_id)
-{
-	unsigned long flags;
-	__le16 key_flags = 0;
-	int i, ret = 0;
-
-	keyconf->flags |= IEEE80211_KEY_FLAG_TKIP_REQ_TX_P2_KEY;
-	keyconf->flags |= IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY;
-	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
-	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
-	keyconf->hw_key_idx = sta_id;
-
-	key_flags |= (STA_KEY_FLG_TKIP | STA_KEY_FLG_MAP_KEY_MSK);
-	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
-	key_flags &= ~STA_KEY_FLG_INVALID;
-
-	if (sta_id == priv->hw_setting.bcast_sta_id)
-		key_flags |= STA_KEY_MULTICAST_MSK;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-
-	priv->stations[sta_id].keyinfo.alg = keyconf->alg;
-	priv->stations[sta_id].keyinfo.keylen = 16;
-
-	/* This copy is acutally not needed: we get the key with each TX */
-	memcpy(priv->stations[sta_id].keyinfo.key, keyconf->key, 16);
-
-	memcpy(priv->stations[sta_id].sta.key.key, keyconf->key, 16);
-
-	priv->stations[sta_id].sta.key.key_offset = (sta_id%8);/*FIXME!!!*/
-	priv->stations[sta_id].sta.key.key_flags = key_flags;
-	if (keyconf->flags & IEEE80211_KEY_FLAG_TKIP_PHASE1_VALID) {
-		priv->stations[sta_id].sta.key.tkip_rx_tsc_byte2 =
-				(u8) keyconf->tkip_iv32;
-		for (i = 0; i < 5; i++)
-			priv->stations[sta_id].sta.key.tkip_rx_ttak[i] =
-				cpu_to_le16(keyconf->tkip_p1k[i]);
-	} else {
-		priv->stations[sta_id].sta.key.tkip_rx_tsc_byte2 = 0xff;
-	}
-
-	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
-	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
-
-	/* Don't send an incomplete key: a key w/o valid TTAK */
-	if (keyconf->flags & IEEE80211_KEY_FLAG_TKIP_PHASE1_VALID) {
-		IWL_DEBUG_INFO("hwcrypto: modify ucode station key info\n");
-		ret = iwl4965_send_add_station(priv,
-				&priv->stations[sta_id].sta, CMD_ASYNC);
-	}
-
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-
-	return ret;
+	iwl4965_send_add_station(priv, &priv->stations[sta_id].sta, 0);
+	return 0;
 }
 
 static int iwl4965_clear_sta_key_info(struct iwl_priv *priv, u8 sta_id)
@@ -1456,46 +1383,6 @@ static int iwl4965_clear_sta_key_info(struct iwl_priv *priv, u8 sta_id)
 	return 0;
 }
 
-static int iwl4965_set_dynamic_key(struct iwl_priv *priv,
-				struct ieee80211_key_conf *key, u8 sta_id)
-{
-	int ret;
-
-	switch (key->alg) {
-	case ALG_CCMP:
-		ret = iwl4965_set_ccmp_dynamic_key_info(priv, key, sta_id);
-		break;
-	case ALG_TKIP:
-		ret = iwl4965_set_tkip_dynamic_key_info(priv, key, sta_id);
-		break;
-	case ALG_WEP:
-		ret = -EOPNOTSUPP;
-		break;
-	default:
-		IWL_ERROR("Unknown alg: %s alg = %d\n", __func__, key->alg);
-		ret = -EINVAL;
-	}
-
-	return ret;
-}
-
-static int iwl4965_remove_static_key(struct iwl_priv *priv)
-{
-	int ret = -EOPNOTSUPP;
-
-	return ret;
-}
-
-static int iwl4965_set_static_key(struct iwl_priv *priv,
-				struct ieee80211_key_conf *key)
-{
-	if (key->alg == ALG_WEP)
-		return -EOPNOTSUPP;
-
-	IWL_ERROR("Static key invalid: alg %d\n", key->alg);
-	return -EINVAL;
-}
-
 static void iwl4965_clear_free_frames(struct iwl_priv *priv)
 {
 	struct list_head *element;
@@ -2227,6 +2114,17 @@ static int iwl4965_scan_initiate(struct iwl_priv *priv)
 	return 0;
 }
 
+static int iwl4965_set_rxon_hwcrypto(struct iwl_priv *priv, int hw_decrypt)
+{
+	struct iwl4965_rxon_cmd *rxon = &priv->staging_rxon;
+
+	if (hw_decrypt)
+		rxon->filter_flags &= ~RXON_FILTER_DIS_DECRYPT_MSK;
+	else
+		rxon->filter_flags |= RXON_FILTER_DIS_DECRYPT_MSK;
+
+	return 0;
+}
 
 static void iwl4965_set_flags_for_phymode(struct iwl_priv *priv,
 					  enum ieee80211_band band)
@@ -2384,9 +2282,15 @@ static void iwl4965_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
 		break;
 
 	case ALG_TKIP:
+#if 0
 		cmd->cmd.tx.sec_ctl = TX_CMD_SEC_TKIP;
-		memcpy(cmd->cmd.tx.key, ctl->tkip_key, keyinfo->keylen);
-		IWL_DEBUG_TX("tx_cmd with tkip hwcrypto\n");
+
+		if (last_frag)
+			memcpy(cmd->cmd.tx.tkip_mic.byte, skb_frag->tail - 8,
+			       8);
+		else
+			memset(cmd->cmd.tx.tkip_mic.byte, 0, 8);
+#endif
 		break;
 
 	case ALG_WEP:
@@ -2893,12 +2797,6 @@ void iwl4965_set_decrypted_flag(struct iwl_priv *priv, struct sk_buff *skb,
 	IWL_DEBUG_RX("decrypt_res:0x%x\n", decrypt_res);
 	switch (decrypt_res & RX_RES_STATUS_SEC_TYPE_MSK) {
 	case RX_RES_STATUS_SEC_TYPE_TKIP:
-		/* The uCode has got a bad phase 1 Key, pushes the packet.
-		 * Decryption will be done in SW. */
-		if ((decrypt_res & RX_RES_STATUS_DECRYPT_TYPE_MSK) ==
-		    RX_RES_STATUS_BAD_KEY_TTAK)
-			break;
-
 		if ((decrypt_res & RX_RES_STATUS_DECRYPT_TYPE_MSK) ==
 		    RX_RES_STATUS_BAD_ICV_MIC)
 			stats->flag |= RX_FLAG_MMIC_ERROR;
@@ -7215,9 +7113,8 @@ static int iwl4965_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 {
 	struct iwl_priv *priv = hw->priv;
 	DECLARE_MAC_BUF(mac);
-	int ret = 0;
-	u8 sta_id = IWL_INVALID_STATION;
-	u8 static_key;
+	int rc = 0;
+	u8 sta_id;
 
 	IWL_DEBUG_MAC80211("enter\n");
 
@@ -7230,45 +7127,44 @@ static int iwl4965_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		/* only support pairwise keys */
 		return -EOPNOTSUPP;
 
-	/* FIXME: need to differenciate between static and dynamic key
-	 * in the level of mac80211 */
-	static_key = !iwl4965_is_associated(priv);
-
-	if (!static_key) {
-		sta_id = iwl4965_hw_find_station(priv, addr);
-		if (sta_id == IWL_INVALID_STATION) {
-			IWL_DEBUG_MAC80211("leave - %s not in station map.\n",
-					   print_mac(mac, addr));
-			return -EINVAL;
-		}
+	sta_id = iwl4965_hw_find_station(priv, addr);
+	if (sta_id == IWL_INVALID_STATION) {
+		IWL_DEBUG_MAC80211("leave - %s not in station map.\n",
+				   print_mac(mac, addr));
+		return -EINVAL;
 	}
 
+	mutex_lock(&priv->mutex);
+
 	iwl4965_scan_cancel_timeout(priv, 100);
 
 	switch (cmd) {
-	case SET_KEY:
-		if (static_key)
-			ret = iwl4965_set_static_key(priv, key);
-		else
-			ret = iwl4965_set_dynamic_key(priv, key, sta_id);
-
-		IWL_DEBUG_MAC80211("enable hwcrypto key\n");
+	case  SET_KEY:
+		rc = iwl4965_update_sta_key_info(priv, key, sta_id);
+		if (!rc) {
+			iwl4965_set_rxon_hwcrypto(priv, 1);
+			iwl4965_commit_rxon(priv);
+			key->hw_key_idx = sta_id;
+			IWL_DEBUG_MAC80211("set_key success, using hwcrypto\n");
+			key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+		}
 		break;
 	case DISABLE_KEY:
-		if (static_key)
-			ret = iwl4965_remove_static_key(priv);
-		else
-			ret = iwl4965_clear_sta_key_info(priv, sta_id);
-
-		IWL_DEBUG_MAC80211("disable hwcrypto key\n");
+		rc = iwl4965_clear_sta_key_info(priv, sta_id);
+		if (!rc) {
+			iwl4965_set_rxon_hwcrypto(priv, 0);
+			iwl4965_commit_rxon(priv);
+			IWL_DEBUG_MAC80211("disable hwcrypto key\n");
+		}
 		break;
 	default:
-		ret = -EINVAL;
+		rc = -EINVAL;
 	}
 
 	IWL_DEBUG_MAC80211("leave\n");
+	mutex_unlock(&priv->mutex);
 
-	return ret;
+	return rc;
 }
 
 static int iwl4965_mac_conf_tx(struct ieee80211_hw *hw, int queue,
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 3b5d57c..5ab6a35 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -287,7 +287,6 @@ struct ieee80211_tx_control {
 	u8 iv_len;		/* length of the IV field in octets */
 	u8 queue;		/* hardware queue to use for this frame;
 				 * 0 = highest, hw->queues-1 = lowest */
-	u8 tkip_key[16];	/* generated phase2/phase1 key for hw TKIP */
 	int type;	/* internal */
 };
 
@@ -587,23 +586,11 @@ enum ieee80211_key_alg {
  * @IEEE80211_KEY_FLAG_GENERATE_MMIC: This flag should be set by
  *	the driver for a TKIP key if it requires Michael MIC
  *	generation in software.
- * @IEEE80211_KEY_FLAG_TKIP_REQ_TX_P2_KEY: This flag should be set by
- *	the driver for a TKIP key if it requires a phase2 TX key generation
- *	in SW. The key will be attached to each packet.
- * @IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY: This flag should be set by the driver
- *	for a TKIP key if it requires phase 1 key generation in software.
- *	The phase 1 key will be sent in the same context as Rx.
- * @IEEE80211_KEY_FLAG_TKIP_PHASE1_VALID: Set by mac80211, valid only when
- *	IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY was set. When set, the phase 1
- *	fields (tkip_p1k and tkip_iv32) in ieee80211_key_conf are valid.
  */
 enum ieee80211_key_flags {
 	IEEE80211_KEY_FLAG_WMM_STA	= 1<<0,
 	IEEE80211_KEY_FLAG_GENERATE_IV	= 1<<1,
 	IEEE80211_KEY_FLAG_GENERATE_MMIC= 1<<2,
-	IEEE80211_KEY_FLAG_TKIP_REQ_TX_P2_KEY = 1<<3,
-	IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY = 1<<4,
-	IEEE80211_KEY_FLAG_TKIP_PHASE1_VALID = 1<<5,
 };
 
 /**
@@ -627,8 +614,6 @@ struct ieee80211_key_conf {
 	u8 flags;
 	s8 keyidx;
 	u8 keylen;
-	u16 tkip_p1k[5];
-	u8 tkip_iv32;
 	u8 key[0];
 };
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d4c5f65..a6485f0 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -156,7 +156,6 @@ struct ieee80211_tx_data {
 	struct sta_info *sta;
 	u16 fc, ethertype;
 	struct ieee80211_key *key;
-	u8 tkip_key[16];
 	unsigned int flags;
 
 	struct ieee80211_tx_control *control;
@@ -171,7 +170,6 @@ struct ieee80211_tx_data {
 	 * in skb) */
 	int num_extra_frag;
 	struct sk_buff **extra_frag;
-	u8 *frag_tkip_key; /* size 16 * num_extra_frag */
 };
 
 
diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index 03b5ded..3abe194 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -286,8 +286,7 @@ int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
 		return TKIP_DECRYPT_REPLAY;
 	}
 
-	if (only_iv &&
-		!(key->conf.flags & IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY)) {
+	if (only_iv) {
 		res = TKIP_DECRYPT_OK;
 		key->u.tkip.rx_initialized[queue] = 1;
 		goto done;
@@ -299,14 +298,6 @@ int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
 		/* IV16 wrapped around - perform TKIP phase 1 */
 		tkip_mixing_phase1(ta, &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
 				   iv32, key->u.tkip.p1k_rx[queue]);
-		if (key->conf.flags & IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY) {
-			/* The driver needs a phase 1 key, provide it */
-			memcpy(&key->conf.tkip_p1k,
-				&key->u.tkip.p1k_rx[queue],
-				sizeof(key->conf.tkip_p1k));
-			key->conf.tkip_iv32 = iv32;
-			key->conf.flags |= IEEE80211_KEY_FLAG_TKIP_PHASE1_VALID;
-		}
 #ifdef CONFIG_TKIP_DEBUG
 		{
 			int i;
@@ -326,12 +317,6 @@ int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
 #endif /* CONFIG_TKIP_DEBUG */
 	}
 
-	if (only_iv) {
-		res = TKIP_DECRYPT_OK;
-		key->u.tkip.rx_initialized[queue] = 1;
-		goto done;
-	}
-
 	tkip_mixing_phase2(key->u.tkip.p1k_rx[queue],
 			   &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
 			   iv16, rc4key);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index ee09464..80f4343 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1078,11 +1078,6 @@ static int __ieee80211_tx(struct ieee80211_local *local, struct sk_buff *skb,
 	if (skb) {
 		ieee80211_dump_frame(wiphy_name(local->hw.wiphy),
 				     "TX to low-level driver", skb);
-
-		if (tx->key && (tx->key->conf.flags &
-				IEEE80211_KEY_FLAG_TKIP_REQ_TX_P2_KEY))
-			memcpy(control->tkip_key, tx->tkip_key, 16);
-
 		ret = local->ops->tx(local_to_hw(local), skb, control);
 		if (ret)
 			return IEEE80211_TX_AGAIN;
@@ -1097,11 +1092,6 @@ static int __ieee80211_tx(struct ieee80211_local *local, struct sk_buff *skb,
 		for (i = 0; i < tx->num_extra_frag; i++) {
 			if (!tx->extra_frag[i])
 				continue;
-
-			if (tx->frag_tkip_key)
-				memcpy(control->tkip_key,
-					&tx->frag_tkip_key[i * 16], 16);
-
 			if (__ieee80211_queue_stopped(local, control->queue))
 				return IEEE80211_TX_FRAG_AGAIN;
 			if (i == tx->num_extra_frag) {
@@ -1129,8 +1119,6 @@ static int __ieee80211_tx(struct ieee80211_local *local, struct sk_buff *skb,
 		}
 		kfree(tx->extra_frag);
 		tx->extra_frag = NULL;
-		kfree(tx->frag_tkip_key);
-		tx->frag_tkip_key = NULL;
 	}
 	return IEEE80211_TX_OK;
 }
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 60f2349..df0b734 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -229,7 +229,6 @@ static int tkip_encrypt_skb(struct ieee80211_tx_data *tx,
 				      (u8) key->u.tkip.iv16);
 
 		tx->control->key_idx = tx->key->conf.hw_key_idx;
-
 		return 0;
 	}
 
@@ -247,7 +246,6 @@ ieee80211_tx_result
 ieee80211_crypto_tkip_encrypt(struct ieee80211_tx_data *tx)
 {
 	struct sk_buff *skb = tx->skb;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	int wpa_test = 0, test = 0;
 
 	tx->control->icv_len = TKIP_ICV_LEN;
@@ -265,21 +263,12 @@ ieee80211_crypto_tkip_encrypt(struct ieee80211_tx_data *tx)
 	if (tkip_encrypt_skb(tx, skb, test) < 0)
 		return TX_DROP;
 
-	if (tx->key->conf.flags & IEEE80211_KEY_FLAG_TKIP_REQ_TX_P2_KEY)
-		ieee80211_tkip_gen_rc4key(tx->key, hdr->addr2, tx->tkip_key);
-
-
 	if (tx->extra_frag) {
 		int i;
-		if (tx->key->conf.flags & IEEE80211_KEY_FLAG_TKIP_REQ_TX_P2_KEY)
-			tx->frag_tkip_key =
-				kzalloc(tx->num_extra_frag * 16, GFP_ATOMIC);
 		for (i = 0; i < tx->num_extra_frag; i++) {
-			if (tkip_encrypt_skb(tx, tx->extra_frag[i], test) < 0)
+			if (tkip_encrypt_skb(tx, tx->extra_frag[i], test)
+			    < 0)
 				return TX_DROP;
-			if (tx->key->conf.flags & IEEE80211_KEY_FLAG_TKIP_REQ_TX_P2_KEY)
-				ieee80211_tkip_gen_rc4key(tx->key, hdr->addr2,
-							  &tx->frag_tkip_key[i * 16]);
 		}
 	}
 
@@ -336,18 +325,6 @@ ieee80211_crypto_tkip_decrypt(struct ieee80211_rx_data *rx)
 		return RX_DROP_UNUSABLE;
 	}
 
-	if (key->conf.flags & IEEE80211_KEY_FLAG_TKIP_PHASE1_VALID) {
-		u8 bcast[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
-		u8 *sta_addr = rx->sta->addr;
-
-		if (is_multicast_ether_addr(hdr->addr1))
-			sta_addr = bcast;
-
-		rx->local->ops->set_key(local_to_hw(rx->local),
-			SET_KEY, rx->dev->dev_addr, sta_addr, &key->conf);
-		key->conf.flags &= ~IEEE80211_KEY_FLAG_TKIP_PHASE1_VALID;
-	}
-
 	/* Trim ICV */
 	skb_trim(skb, skb->len - TKIP_ICV_LEN);
 
-- 
1.5.3.4

