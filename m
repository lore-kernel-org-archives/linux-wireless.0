Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:45404 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbZK3Rb1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 12:31:27 -0500
Date: Mon, 30 Nov 2009 18:31:33 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 01/11] mwl8k: firmware command code cleanup
Message-ID: <20091130173133.GQ20214@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sort firmware commands by command code, get rid of the 802_11 substring
in all command names, and make sure that the command functions match the
firmware command names.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |  647 +++++++++++++++++++++---------------------
 1 files changed, 323 insertions(+), 324 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 16062e7..51a762c 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -222,7 +222,7 @@ struct mwl8k_vif {
 	u8	bssid[ETH_ALEN];
 	u8	mac_addr[ETH_ALEN];
 
-	 /* Index into station database.Returned by update_sta_db call */
+	/* Index into station database. Returned by UPDATE_STADB.  */
 	u8	peer_id;
 
 	/* Non AMPDU sequence number assigned by driver */
@@ -1898,9 +1898,9 @@ __mwl8k_cmd_mac_multicast_adr(struct ieee80211_hw *hw, int allmulti,
 }
 
 /*
- * CMD_802_11_GET_STAT.
+ * CMD_GET_STAT.
  */
-struct mwl8k_cmd_802_11_get_stat {
+struct mwl8k_cmd_get_stat {
 	struct mwl8k_cmd_pkt header;
 	__le32 stats[64];
 } __attribute__((packed));
@@ -1910,10 +1910,10 @@ struct mwl8k_cmd_802_11_get_stat {
 #define MWL8K_STAT_FCS_ERROR	24
 #define MWL8K_STAT_RTS_SUCCESS	11
 
-static int mwl8k_cmd_802_11_get_stat(struct ieee80211_hw *hw,
-				struct ieee80211_low_level_stats *stats)
+static int mwl8k_cmd_get_stat(struct ieee80211_hw *hw,
+			      struct ieee80211_low_level_stats *stats)
 {
-	struct mwl8k_cmd_802_11_get_stat *cmd;
+	struct mwl8k_cmd_get_stat *cmd;
 	int rc;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
@@ -1940,9 +1940,9 @@ static int mwl8k_cmd_802_11_get_stat(struct ieee80211_hw *hw,
 }
 
 /*
- * CMD_802_11_RADIO_CONTROL.
+ * CMD_RADIO_CONTROL.
  */
-struct mwl8k_cmd_802_11_radio_control {
+struct mwl8k_cmd_radio_control {
 	struct mwl8k_cmd_pkt header;
 	__le16 action;
 	__le16 control;
@@ -1950,10 +1950,10 @@ struct mwl8k_cmd_802_11_radio_control {
 } __attribute__((packed));
 
 static int
-mwl8k_cmd_802_11_radio_control(struct ieee80211_hw *hw, bool enable, bool force)
+mwl8k_cmd_radio_control(struct ieee80211_hw *hw, bool enable, bool force)
 {
 	struct mwl8k_priv *priv = hw->priv;
-	struct mwl8k_cmd_802_11_radio_control *cmd;
+	struct mwl8k_cmd_radio_control *cmd;
 	int rc;
 
 	if (enable == priv->radio_on && !force)
@@ -1978,14 +1978,14 @@ mwl8k_cmd_802_11_radio_control(struct ieee80211_hw *hw, bool enable, bool force)
 	return rc;
 }
 
-static int mwl8k_cmd_802_11_radio_disable(struct ieee80211_hw *hw)
+static int mwl8k_cmd_radio_disable(struct ieee80211_hw *hw)
 {
-	return mwl8k_cmd_802_11_radio_control(hw, 0, 0);
+	return mwl8k_cmd_radio_control(hw, 0, 0);
 }
 
-static int mwl8k_cmd_802_11_radio_enable(struct ieee80211_hw *hw)
+static int mwl8k_cmd_radio_enable(struct ieee80211_hw *hw)
 {
-	return mwl8k_cmd_802_11_radio_control(hw, 1, 0);
+	return mwl8k_cmd_radio_control(hw, 1, 0);
 }
 
 static int
@@ -1999,15 +1999,15 @@ mwl8k_set_radio_preamble(struct ieee80211_hw *hw, bool short_preamble)
 
 	priv->radio_short_preamble = short_preamble;
 
-	return mwl8k_cmd_802_11_radio_control(hw, 1, 1);
+	return mwl8k_cmd_radio_control(hw, 1, 1);
 }
 
 /*
- * CMD_802_11_RF_TX_POWER.
+ * CMD_RF_TX_POWER.
  */
 #define MWL8K_TX_POWER_LEVEL_TOTAL	8
 
-struct mwl8k_cmd_802_11_rf_tx_power {
+struct mwl8k_cmd_rf_tx_power {
 	struct mwl8k_cmd_pkt header;
 	__le16 action;
 	__le16 support_level;
@@ -2016,9 +2016,9 @@ struct mwl8k_cmd_802_11_rf_tx_power {
 	__le16 power_level_list[MWL8K_TX_POWER_LEVEL_TOTAL];
 } __attribute__((packed));
 
-static int mwl8k_cmd_802_11_rf_tx_power(struct ieee80211_hw *hw, int dBm)
+static int mwl8k_cmd_rf_tx_power(struct ieee80211_hw *hw, int dBm)
 {
-	struct mwl8k_cmd_802_11_rf_tx_power *cmd;
+	struct mwl8k_cmd_rf_tx_power *cmd;
 	int rc;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
@@ -2160,85 +2160,61 @@ static int mwl8k_cmd_set_rf_channel(struct ieee80211_hw *hw,
 }
 
 /*
- * CMD_SET_SLOT.
+ * CMD_SET_AID.
  */
-struct mwl8k_cmd_set_slot {
-	struct mwl8k_cmd_pkt header;
-	__le16 action;
-	__u8 short_slot;
-} __attribute__((packed));
-
-static int mwl8k_cmd_set_slot(struct ieee80211_hw *hw, bool short_slot_time)
-{
-	struct mwl8k_cmd_set_slot *cmd;
-	int rc;
-
-	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
-	if (cmd == NULL)
-		return -ENOMEM;
-
-	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_SLOT);
-	cmd->header.length = cpu_to_le16(sizeof(*cmd));
-	cmd->action = cpu_to_le16(MWL8K_CMD_SET);
-	cmd->short_slot = short_slot_time;
-
-	rc = mwl8k_post_cmd(hw, &cmd->header);
-	kfree(cmd);
+#define MWL8K_FRAME_PROT_DISABLED			0x00
+#define MWL8K_FRAME_PROT_11G				0x07
+#define MWL8K_FRAME_PROT_11N_HT_40MHZ_ONLY		0x02
+#define MWL8K_FRAME_PROT_11N_HT_ALL			0x06
 
-	return rc;
-}
+struct mwl8k_cmd_update_set_aid {
+	struct	mwl8k_cmd_pkt header;
+	__le16	aid;
 
-/*
- * CMD_MIMO_CONFIG.
- */
-struct mwl8k_cmd_mimo_config {
-	struct mwl8k_cmd_pkt header;
-	__le32 action;
-	__u8 rx_antenna_map;
-	__u8 tx_antenna_map;
+	 /* AP's MAC address (BSSID) */
+	__u8	bssid[ETH_ALEN];
+	__le16	protection_mode;
+	__u8	supp_rates[14];
 } __attribute__((packed));
 
-static int mwl8k_cmd_mimo_config(struct ieee80211_hw *hw, __u8 rx, __u8 tx)
+static int
+mwl8k_cmd_set_aid(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
-	struct mwl8k_cmd_mimo_config *cmd;
+	struct mwl8k_vif *mv_vif = MWL8K_VIF(vif);
+	struct ieee80211_bss_conf *info = &mv_vif->bss_info;
+	struct mwl8k_cmd_update_set_aid *cmd;
+	u16 prot_mode;
 	int rc;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (cmd == NULL)
 		return -ENOMEM;
 
-	cmd->header.code = cpu_to_le16(MWL8K_CMD_MIMO_CONFIG);
+	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_AID);
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
-	cmd->action = cpu_to_le32((u32)MWL8K_CMD_SET);
-	cmd->rx_antenna_map = rx;
-	cmd->tx_antenna_map = tx;
-
-	rc = mwl8k_post_cmd(hw, &cmd->header);
-	kfree(cmd);
-
-	return rc;
-}
-
-/*
- * CMD_ENABLE_SNIFFER.
- */
-struct mwl8k_cmd_enable_sniffer {
-	struct mwl8k_cmd_pkt header;
-	__le32 action;
-} __attribute__((packed));
+	cmd->aid = cpu_to_le16(info->aid);
 
-static int mwl8k_enable_sniffer(struct ieee80211_hw *hw, bool enable)
-{
-	struct mwl8k_cmd_enable_sniffer *cmd;
-	int rc;
+	memcpy(cmd->bssid, mv_vif->bssid, ETH_ALEN);
 
-	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
-	if (cmd == NULL)
-		return -ENOMEM;
+	if (info->use_cts_prot) {
+		prot_mode = MWL8K_FRAME_PROT_11G;
+	} else {
+		switch (info->ht_operation_mode &
+			IEEE80211_HT_OP_MODE_PROTECTION) {
+		case IEEE80211_HT_OP_MODE_PROTECTION_20MHZ:
+			prot_mode = MWL8K_FRAME_PROT_11N_HT_40MHZ_ONLY;
+			break;
+		case IEEE80211_HT_OP_MODE_PROTECTION_NONHT_MIXED:
+			prot_mode = MWL8K_FRAME_PROT_11N_HT_ALL;
+			break;
+		default:
+			prot_mode = MWL8K_FRAME_PROT_DISABLED;
+			break;
+		}
+	}
+	cmd->protection_mode = cpu_to_le16(prot_mode);
 
-	cmd->header.code = cpu_to_le16(MWL8K_CMD_ENABLE_SNIFFER);
-	cmd->header.length = cpu_to_le16(sizeof(*cmd));
-	cmd->action = cpu_to_le32(!!enable);
+	memcpy(cmd->supp_rates, mwl8k_rateids, sizeof(mwl8k_rateids));
 
 	rc = mwl8k_post_cmd(hw, &cmd->header);
 	kfree(cmd);
@@ -2247,37 +2223,30 @@ static int mwl8k_enable_sniffer(struct ieee80211_hw *hw, bool enable)
 }
 
 /*
- * CMD_SET_MAC_ADDR.
+ * CMD_SET_RATE.
  */
-struct mwl8k_cmd_set_mac_addr {
-	struct mwl8k_cmd_pkt header;
-	union {
-		struct {
-			__le16 mac_type;
-			__u8 mac_addr[ETH_ALEN];
-		} mbss;
-		__u8 mac_addr[ETH_ALEN];
-	};
+struct mwl8k_cmd_set_rate {
+	struct	mwl8k_cmd_pkt header;
+	__u8	legacy_rates[14];
+
+	/* Bitmap for supported MCS codes.  */
+	__u8	mcs_set[16];
+	__u8	reserved[16];
 } __attribute__((packed));
 
-static int mwl8k_set_mac_addr(struct ieee80211_hw *hw, u8 *mac)
+static int
+mwl8k_cmd_set_rate(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
-	struct mwl8k_priv *priv = hw->priv;
-	struct mwl8k_cmd_set_mac_addr *cmd;
+	struct mwl8k_cmd_set_rate *cmd;
 	int rc;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (cmd == NULL)
 		return -ENOMEM;
 
-	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_MAC_ADDR);
+	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_RATE);
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
-	if (priv->ap_fw) {
-		cmd->mbss.mac_type = 0;
-		memcpy(cmd->mbss.mac_addr, mac, ETH_ALEN);
-	} else {
-		memcpy(cmd->mac_addr, mac, ETH_ALEN);
-	}
+	memcpy(cmd->legacy_rates, mwl8k_rateids, sizeof(mwl8k_rateids));
 
 	rc = mwl8k_post_cmd(hw, &cmd->header);
 	kfree(cmd);
@@ -2285,29 +2254,40 @@ static int mwl8k_set_mac_addr(struct ieee80211_hw *hw, u8 *mac)
 	return rc;
 }
 
-
 /*
- * CMD_SET_RATEADAPT_MODE.
+ * CMD_FINALIZE_JOIN.
  */
-struct mwl8k_cmd_set_rate_adapt_mode {
+#define MWL8K_FJ_BEACON_MAXLEN	128
+
+struct mwl8k_cmd_finalize_join {
 	struct mwl8k_cmd_pkt header;
-	__le16 action;
-	__le16 mode;
+	__le32 sleep_interval;	/* Number of beacon periods to sleep */
+	__u8 beacon_data[MWL8K_FJ_BEACON_MAXLEN];
 } __attribute__((packed));
 
-static int mwl8k_cmd_setrateadaptmode(struct ieee80211_hw *hw, __u16 mode)
+static int mwl8k_cmd_finalize_join(struct ieee80211_hw *hw, void *frame,
+				   int framelen, int dtim)
 {
-	struct mwl8k_cmd_set_rate_adapt_mode *cmd;
+	struct mwl8k_cmd_finalize_join *cmd;
+	struct ieee80211_mgmt *payload = frame;
+	int payload_len;
 	int rc;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (cmd == NULL)
 		return -ENOMEM;
 
-	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_RATEADAPT_MODE);
+	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_FINALIZE_JOIN);
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
-	cmd->action = cpu_to_le16(MWL8K_CMD_SET);
-	cmd->mode = cpu_to_le16(mode);
+	cmd->sleep_interval = cpu_to_le32(dtim ? dtim : 1);
+
+	payload_len = framelen - ieee80211_hdrlen(payload->frame_control);
+	if (payload_len < 0)
+		payload_len = 0;
+	else if (payload_len > MWL8K_FJ_BEACON_MAXLEN)
+		payload_len = MWL8K_FJ_BEACON_MAXLEN;
+
+	memcpy(cmd->beacon_data, &payload->u.beacon, payload_len);
 
 	rc = mwl8k_post_cmd(hw, &cmd->header);
 	kfree(cmd);
@@ -2316,59 +2296,57 @@ static int mwl8k_cmd_setrateadaptmode(struct ieee80211_hw *hw, __u16 mode)
 }
 
 /*
- * CMD_SET_WMM_MODE.
+ * CMD_SET_RTS_THRESHOLD.
  */
-struct mwl8k_cmd_set_wmm {
+struct mwl8k_cmd_set_rts_threshold {
 	struct mwl8k_cmd_pkt header;
 	__le16 action;
+	__le16 threshold;
 } __attribute__((packed));
 
-static int mwl8k_set_wmm(struct ieee80211_hw *hw, bool enable)
+static int mwl8k_cmd_set_rts_threshold(struct ieee80211_hw *hw,
+				       u16 action, u16 threshold)
 {
-	struct mwl8k_priv *priv = hw->priv;
-	struct mwl8k_cmd_set_wmm *cmd;
+	struct mwl8k_cmd_set_rts_threshold *cmd;
 	int rc;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (cmd == NULL)
 		return -ENOMEM;
 
-	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_WMM_MODE);
+	cmd->header.code = cpu_to_le16(MWL8K_CMD_RTS_THRESHOLD);
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
-	cmd->action = cpu_to_le16(!!enable);
+	cmd->action = cpu_to_le16(action);
+	cmd->threshold = cpu_to_le16(threshold);
 
 	rc = mwl8k_post_cmd(hw, &cmd->header);
 	kfree(cmd);
 
-	if (!rc)
-		priv->wmm_enabled = enable;
-
 	return rc;
 }
 
 /*
- * CMD_SET_RTS_THRESHOLD.
+ * CMD_SET_SLOT.
  */
-struct mwl8k_cmd_rts_threshold {
+struct mwl8k_cmd_set_slot {
 	struct mwl8k_cmd_pkt header;
 	__le16 action;
-	__le16 threshold;
+	__u8 short_slot;
 } __attribute__((packed));
 
-static int mwl8k_rts_threshold(struct ieee80211_hw *hw,
-			       u16 action, u16 threshold)
+static int mwl8k_cmd_set_slot(struct ieee80211_hw *hw, bool short_slot_time)
 {
-	struct mwl8k_cmd_rts_threshold *cmd;
+	struct mwl8k_cmd_set_slot *cmd;
 	int rc;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (cmd == NULL)
 		return -ENOMEM;
 
-	cmd->header.code = cpu_to_le16(MWL8K_CMD_RTS_THRESHOLD);
+	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_SLOT);
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
-	cmd->action = cpu_to_le16(action);
-	cmd->threshold = cpu_to_le16(threshold);
+	cmd->action = cpu_to_le16(MWL8K_CMD_SET);
+	cmd->short_slot = short_slot_time;
 
 	rc = mwl8k_post_cmd(hw, &cmd->header);
 	kfree(cmd);
@@ -2427,9 +2405,9 @@ struct mwl8k_cmd_set_edca_params {
 				 MWL8K_SET_EDCA_AIFS)
 
 static int
-mwl8k_set_edca_params(struct ieee80211_hw *hw, __u8 qnum,
-		__u16 cw_min, __u16 cw_max,
-		__u8 aifs, __u16 txop)
+mwl8k_cmd_set_edca_params(struct ieee80211_hw *hw, __u8 qnum,
+			  __u16 cw_min, __u16 cw_max,
+			  __u8 aifs, __u16 txop)
 {
 	struct mwl8k_priv *priv = hw->priv;
 	struct mwl8k_cmd_set_edca_params *cmd;
@@ -2468,202 +2446,60 @@ mwl8k_set_edca_params(struct ieee80211_hw *hw, __u8 qnum,
 }
 
 /*
- * CMD_FINALIZE_JOIN.
+ * CMD_SET_WMM_MODE.
  */
-#define MWL8K_FJ_BEACON_MAXLEN	128
-
-struct mwl8k_cmd_finalize_join {
+struct mwl8k_cmd_set_wmm_mode {
 	struct mwl8k_cmd_pkt header;
-	__le32 sleep_interval;	/* Number of beacon periods to sleep */
-	__u8 beacon_data[MWL8K_FJ_BEACON_MAXLEN];
+	__le16 action;
 } __attribute__((packed));
 
-static int mwl8k_finalize_join(struct ieee80211_hw *hw, void *frame,
-			       int framelen, int dtim)
+static int mwl8k_cmd_set_wmm_mode(struct ieee80211_hw *hw, bool enable)
 {
-	struct mwl8k_cmd_finalize_join *cmd;
-	struct ieee80211_mgmt *payload = frame;
-	int payload_len;
+	struct mwl8k_priv *priv = hw->priv;
+	struct mwl8k_cmd_set_wmm_mode *cmd;
 	int rc;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (cmd == NULL)
 		return -ENOMEM;
 
-	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_FINALIZE_JOIN);
+	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_WMM_MODE);
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
-	cmd->sleep_interval = cpu_to_le32(dtim ? dtim : 1);
-
-	payload_len = framelen - ieee80211_hdrlen(payload->frame_control);
-	if (payload_len < 0)
-		payload_len = 0;
-	else if (payload_len > MWL8K_FJ_BEACON_MAXLEN)
-		payload_len = MWL8K_FJ_BEACON_MAXLEN;
-
-	memcpy(cmd->beacon_data, &payload->u.beacon, payload_len);
+	cmd->action = cpu_to_le16(!!enable);
 
 	rc = mwl8k_post_cmd(hw, &cmd->header);
 	kfree(cmd);
 
-	return rc;
-}
-
-/*
- * CMD_UPDATE_STADB.
- */
-struct mwl8k_cmd_update_sta_db {
-	struct mwl8k_cmd_pkt header;
-
-	/* See STADB_ACTION_TYPE */
-	__le32	action;
-
-	/* Peer MAC address */
-	__u8	peer_addr[ETH_ALEN];
-
-	__le32	reserved;
-
-	/* Peer info - valid during add/update.  */
-	struct peer_capability_info	peer_info;
-} __attribute__((packed));
-
-static int mwl8k_cmd_update_sta_db(struct ieee80211_hw *hw,
-		struct ieee80211_vif *vif, __u32 action)
-{
-	struct mwl8k_vif *mv_vif = MWL8K_VIF(vif);
-	struct ieee80211_bss_conf *info = &mv_vif->bss_info;
-	struct mwl8k_cmd_update_sta_db *cmd;
-	struct peer_capability_info *peer_info;
-	int rc;
-
-	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
-	if (cmd == NULL)
-		return -ENOMEM;
-
-	cmd->header.code = cpu_to_le16(MWL8K_CMD_UPDATE_STADB);
-	cmd->header.length = cpu_to_le16(sizeof(*cmd));
-
-	cmd->action = cpu_to_le32(action);
-	peer_info = &cmd->peer_info;
-	memcpy(cmd->peer_addr, mv_vif->bssid, ETH_ALEN);
-
-	switch (action) {
-	case MWL8K_STA_DB_ADD_ENTRY:
-	case MWL8K_STA_DB_MODIFY_ENTRY:
-		/* Build peer_info block */
-		peer_info->peer_type = MWL8K_PEER_TYPE_ACCESSPOINT;
-		peer_info->basic_caps = cpu_to_le16(info->assoc_capability);
-		memcpy(peer_info->legacy_rates, mwl8k_rateids,
-		       sizeof(mwl8k_rateids));
-		peer_info->interop = 1;
-		peer_info->amsdu_enabled = 0;
-
-		rc = mwl8k_post_cmd(hw, &cmd->header);
-		if (rc == 0)
-			mv_vif->peer_id = peer_info->station_id;
-
-		break;
-
-	case MWL8K_STA_DB_DEL_ENTRY:
-	case MWL8K_STA_DB_FLUSH:
-	default:
-		rc = mwl8k_post_cmd(hw, &cmd->header);
-		if (rc == 0)
-			mv_vif->peer_id = 0;
-		break;
-	}
-	kfree(cmd);
-
-	return rc;
-}
-
-/*
- * CMD_SET_AID.
- */
-#define MWL8K_FRAME_PROT_DISABLED			0x00
-#define MWL8K_FRAME_PROT_11G				0x07
-#define MWL8K_FRAME_PROT_11N_HT_40MHZ_ONLY		0x02
-#define MWL8K_FRAME_PROT_11N_HT_ALL			0x06
-
-struct mwl8k_cmd_update_set_aid {
-	struct	mwl8k_cmd_pkt header;
-	__le16	aid;
-
-	 /* AP's MAC address (BSSID) */
-	__u8	bssid[ETH_ALEN];
-	__le16	protection_mode;
-	__u8	supp_rates[14];
-} __attribute__((packed));
-
-static int mwl8k_cmd_set_aid(struct ieee80211_hw *hw,
-					struct ieee80211_vif *vif)
-{
-	struct mwl8k_vif *mv_vif = MWL8K_VIF(vif);
-	struct ieee80211_bss_conf *info = &mv_vif->bss_info;
-	struct mwl8k_cmd_update_set_aid *cmd;
-	u16 prot_mode;
-	int rc;
-
-	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
-	if (cmd == NULL)
-		return -ENOMEM;
-
-	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_AID);
-	cmd->header.length = cpu_to_le16(sizeof(*cmd));
-	cmd->aid = cpu_to_le16(info->aid);
-
-	memcpy(cmd->bssid, mv_vif->bssid, ETH_ALEN);
-
-	if (info->use_cts_prot) {
-		prot_mode = MWL8K_FRAME_PROT_11G;
-	} else {
-		switch (info->ht_operation_mode &
-			IEEE80211_HT_OP_MODE_PROTECTION) {
-		case IEEE80211_HT_OP_MODE_PROTECTION_20MHZ:
-			prot_mode = MWL8K_FRAME_PROT_11N_HT_40MHZ_ONLY;
-			break;
-		case IEEE80211_HT_OP_MODE_PROTECTION_NONHT_MIXED:
-			prot_mode = MWL8K_FRAME_PROT_11N_HT_ALL;
-			break;
-		default:
-			prot_mode = MWL8K_FRAME_PROT_DISABLED;
-			break;
-		}
-	}
-	cmd->protection_mode = cpu_to_le16(prot_mode);
-
-	memcpy(cmd->supp_rates, mwl8k_rateids, sizeof(mwl8k_rateids));
-
-	rc = mwl8k_post_cmd(hw, &cmd->header);
-	kfree(cmd);
+	if (!rc)
+		priv->wmm_enabled = enable;
 
 	return rc;
 }
 
 /*
- * CMD_SET_RATE.
+ * CMD_MIMO_CONFIG.
  */
-struct mwl8k_cmd_update_rateset {
-	struct	mwl8k_cmd_pkt header;
-	__u8	legacy_rates[14];
-
-	/* Bitmap for supported MCS codes.  */
-	__u8	mcs_set[16];
-	__u8	reserved[16];
+struct mwl8k_cmd_mimo_config {
+	struct mwl8k_cmd_pkt header;
+	__le32 action;
+	__u8 rx_antenna_map;
+	__u8 tx_antenna_map;
 } __attribute__((packed));
 
-static int mwl8k_update_rateset(struct ieee80211_hw *hw,
-		struct ieee80211_vif *vif)
+static int mwl8k_cmd_mimo_config(struct ieee80211_hw *hw, __u8 rx, __u8 tx)
 {
-	struct mwl8k_cmd_update_rateset *cmd;
+	struct mwl8k_cmd_mimo_config *cmd;
 	int rc;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (cmd == NULL)
 		return -ENOMEM;
 
-	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_RATE);
+	cmd->header.code = cpu_to_le16(MWL8K_CMD_MIMO_CONFIG);
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
-	memcpy(cmd->legacy_rates, mwl8k_rateids, sizeof(mwl8k_rateids));
+	cmd->action = cpu_to_le32((u32)MWL8K_CMD_SET);
+	cmd->rx_antenna_map = rx;
+	cmd->tx_antenna_map = tx;
 
 	rc = mwl8k_post_cmd(hw, &cmd->header);
 	kfree(cmd);
@@ -2756,6 +2592,169 @@ static int mwl8k_cmd_use_fixed_rate(struct ieee80211_hw *hw,
 	return rc;
 }
 
+/*
+ * CMD_ENABLE_SNIFFER.
+ */
+struct mwl8k_cmd_enable_sniffer {
+	struct mwl8k_cmd_pkt header;
+	__le32 action;
+} __attribute__((packed));
+
+static int mwl8k_cmd_enable_sniffer(struct ieee80211_hw *hw, bool enable)
+{
+	struct mwl8k_cmd_enable_sniffer *cmd;
+	int rc;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (cmd == NULL)
+		return -ENOMEM;
+
+	cmd->header.code = cpu_to_le16(MWL8K_CMD_ENABLE_SNIFFER);
+	cmd->header.length = cpu_to_le16(sizeof(*cmd));
+	cmd->action = cpu_to_le32(!!enable);
+
+	rc = mwl8k_post_cmd(hw, &cmd->header);
+	kfree(cmd);
+
+	return rc;
+}
+
+/*
+ * CMD_SET_MAC_ADDR.
+ */
+struct mwl8k_cmd_set_mac_addr {
+	struct mwl8k_cmd_pkt header;
+	union {
+		struct {
+			__le16 mac_type;
+			__u8 mac_addr[ETH_ALEN];
+		} mbss;
+		__u8 mac_addr[ETH_ALEN];
+	};
+} __attribute__((packed));
+
+static int mwl8k_cmd_set_mac_addr(struct ieee80211_hw *hw, u8 *mac)
+{
+	struct mwl8k_priv *priv = hw->priv;
+	struct mwl8k_cmd_set_mac_addr *cmd;
+	int rc;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (cmd == NULL)
+		return -ENOMEM;
+
+	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_MAC_ADDR);
+	cmd->header.length = cpu_to_le16(sizeof(*cmd));
+	if (priv->ap_fw) {
+		cmd->mbss.mac_type = 0;
+		memcpy(cmd->mbss.mac_addr, mac, ETH_ALEN);
+	} else {
+		memcpy(cmd->mac_addr, mac, ETH_ALEN);
+	}
+
+	rc = mwl8k_post_cmd(hw, &cmd->header);
+	kfree(cmd);
+
+	return rc;
+}
+
+/*
+ * CMD_SET_RATEADAPT_MODE.
+ */
+struct mwl8k_cmd_set_rate_adapt_mode {
+	struct mwl8k_cmd_pkt header;
+	__le16 action;
+	__le16 mode;
+} __attribute__((packed));
+
+static int mwl8k_cmd_set_rateadapt_mode(struct ieee80211_hw *hw, __u16 mode)
+{
+	struct mwl8k_cmd_set_rate_adapt_mode *cmd;
+	int rc;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (cmd == NULL)
+		return -ENOMEM;
+
+	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_RATEADAPT_MODE);
+	cmd->header.length = cpu_to_le16(sizeof(*cmd));
+	cmd->action = cpu_to_le16(MWL8K_CMD_SET);
+	cmd->mode = cpu_to_le16(mode);
+
+	rc = mwl8k_post_cmd(hw, &cmd->header);
+	kfree(cmd);
+
+	return rc;
+}
+
+/*
+ * CMD_UPDATE_STADB.
+ */
+struct mwl8k_cmd_update_stadb {
+	struct mwl8k_cmd_pkt header;
+
+	/* See STADB_ACTION_TYPE */
+	__le32	action;
+
+	/* Peer MAC address */
+	__u8	peer_addr[ETH_ALEN];
+
+	__le32	reserved;
+
+	/* Peer info - valid during add/update.  */
+	struct peer_capability_info	peer_info;
+} __attribute__((packed));
+
+static int mwl8k_cmd_update_stadb(struct ieee80211_hw *hw,
+		struct ieee80211_vif *vif, __u32 action)
+{
+	struct mwl8k_vif *mv_vif = MWL8K_VIF(vif);
+	struct ieee80211_bss_conf *info = &mv_vif->bss_info;
+	struct mwl8k_cmd_update_stadb *cmd;
+	struct peer_capability_info *peer_info;
+	int rc;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (cmd == NULL)
+		return -ENOMEM;
+
+	cmd->header.code = cpu_to_le16(MWL8K_CMD_UPDATE_STADB);
+	cmd->header.length = cpu_to_le16(sizeof(*cmd));
+
+	cmd->action = cpu_to_le32(action);
+	peer_info = &cmd->peer_info;
+	memcpy(cmd->peer_addr, mv_vif->bssid, ETH_ALEN);
+
+	switch (action) {
+	case MWL8K_STA_DB_ADD_ENTRY:
+	case MWL8K_STA_DB_MODIFY_ENTRY:
+		/* Build peer_info block */
+		peer_info->peer_type = MWL8K_PEER_TYPE_ACCESSPOINT;
+		peer_info->basic_caps = cpu_to_le16(info->assoc_capability);
+		memcpy(peer_info->legacy_rates, mwl8k_rateids,
+		       sizeof(mwl8k_rateids));
+		peer_info->interop = 1;
+		peer_info->amsdu_enabled = 0;
+
+		rc = mwl8k_post_cmd(hw, &cmd->header);
+		if (rc == 0)
+			mv_vif->peer_id = peer_info->station_id;
+
+		break;
+
+	case MWL8K_STA_DB_DEL_ENTRY:
+	case MWL8K_STA_DB_FLUSH:
+	default:
+		rc = mwl8k_post_cmd(hw, &cmd->header);
+		if (rc == 0)
+			mv_vif->peer_id = 0;
+		break;
+	}
+	kfree(cmd);
+
+	return rc;
+}
+
 
 /*
  * Interrupt handling.
@@ -2837,11 +2836,11 @@ static int mwl8k_start(struct ieee80211_hw *hw)
 
 	rc = mwl8k_fw_lock(hw);
 	if (!rc) {
-		rc = mwl8k_cmd_802_11_radio_enable(hw);
+		rc = mwl8k_cmd_radio_enable(hw);
 
 		if (!priv->ap_fw) {
 			if (!rc)
-				rc = mwl8k_enable_sniffer(hw, 0);
+				rc = mwl8k_cmd_enable_sniffer(hw, 0);
 
 			if (!rc)
 				rc = mwl8k_cmd_set_pre_scan(hw);
@@ -2852,10 +2851,10 @@ static int mwl8k_start(struct ieee80211_hw *hw)
 		}
 
 		if (!rc)
-			rc = mwl8k_cmd_setrateadaptmode(hw, 0);
+			rc = mwl8k_cmd_set_rateadapt_mode(hw, 0);
 
 		if (!rc)
-			rc = mwl8k_set_wmm(hw, 0);
+			rc = mwl8k_cmd_set_wmm_mode(hw, 0);
 
 		mwl8k_fw_unlock(hw);
 	}
@@ -2874,7 +2873,7 @@ static void mwl8k_stop(struct ieee80211_hw *hw)
 	struct mwl8k_priv *priv = hw->priv;
 	int i;
 
-	mwl8k_cmd_802_11_radio_disable(hw);
+	mwl8k_cmd_radio_disable(hw);
 
 	ieee80211_stop_queues(hw);
 
@@ -2930,7 +2929,7 @@ static int mwl8k_add_interface(struct ieee80211_hw *hw,
 	memset(mwl8k_vif, 0, sizeof(*mwl8k_vif));
 
 	/* Set and save the mac address */
-	mwl8k_set_mac_addr(hw, conf->mac_addr);
+	mwl8k_cmd_set_mac_addr(hw, conf->mac_addr);
 	memcpy(mwl8k_vif->mac_addr, conf->mac_addr, ETH_ALEN);
 
 	/* Back pointer to parent config block */
@@ -2953,7 +2952,7 @@ static void mwl8k_remove_interface(struct ieee80211_hw *hw,
 	if (priv->vif == NULL)
 		return;
 
-	mwl8k_set_mac_addr(hw, "\x00\x00\x00\x00\x00\x00");
+	mwl8k_cmd_set_mac_addr(hw, "\x00\x00\x00\x00\x00\x00");
 
 	priv->vif = NULL;
 }
@@ -2965,7 +2964,7 @@ static int mwl8k_config(struct ieee80211_hw *hw, u32 changed)
 	int rc;
 
 	if (conf->flags & IEEE80211_CONF_IDLE) {
-		mwl8k_cmd_802_11_radio_disable(hw);
+		mwl8k_cmd_radio_disable(hw);
 		priv->current_channel = NULL;
 		return 0;
 	}
@@ -2974,7 +2973,7 @@ static int mwl8k_config(struct ieee80211_hw *hw, u32 changed)
 	if (rc)
 		return rc;
 
-	rc = mwl8k_cmd_802_11_radio_enable(hw);
+	rc = mwl8k_cmd_radio_enable(hw);
 	if (rc)
 		goto out;
 
@@ -2986,7 +2985,7 @@ static int mwl8k_config(struct ieee80211_hw *hw, u32 changed)
 
 	if (conf->power_level > 18)
 		conf->power_level = 18;
-	rc = mwl8k_cmd_802_11_rf_tx_power(hw, conf->power_level);
+	rc = mwl8k_cmd_rf_tx_power(hw, conf->power_level);
 	if (rc)
 		goto out;
 
@@ -3029,7 +3028,7 @@ static void mwl8k_bss_info_changed(struct ieee80211_hw *hw,
 		memcpy(mwl8k_vif->bssid, info->bssid, ETH_ALEN);
 
 		/* Install rates */
-		rc = mwl8k_update_rateset(hw, vif);
+		rc = mwl8k_cmd_set_rate(hw, vif);
 		if (rc)
 			goto out;
 
@@ -3050,7 +3049,7 @@ static void mwl8k_bss_info_changed(struct ieee80211_hw *hw,
 			goto out;
 
 		/* Update peer rate info */
-		rc = mwl8k_cmd_update_sta_db(hw, vif,
+		rc = mwl8k_cmd_update_stadb(hw, vif,
 				MWL8K_STA_DB_MODIFY_ENTRY);
 		if (rc)
 			goto out;
@@ -3067,7 +3066,7 @@ static void mwl8k_bss_info_changed(struct ieee80211_hw *hw,
 		memcpy(priv->capture_bssid, mwl8k_vif->bssid, ETH_ALEN);
 		priv->capture_beacon = true;
 	} else {
-		rc = mwl8k_cmd_update_sta_db(hw, vif, MWL8K_STA_DB_DEL_ENTRY);
+		rc = mwl8k_cmd_update_stadb(hw, vif, MWL8K_STA_DB_DEL_ENTRY);
 		memset(&mwl8k_vif->bss_info, 0,
 			sizeof(struct ieee80211_bss_conf));
 		memset(mwl8k_vif->bssid, 0, ETH_ALEN);
@@ -3115,7 +3114,7 @@ mwl8k_configure_filter_sniffer(struct ieee80211_hw *hw,
 	}
 
 	if (!priv->sniffer_enabled) {
-		if (mwl8k_enable_sniffer(hw, 1))
+		if (mwl8k_cmd_enable_sniffer(hw, 1))
 			return 0;
 		priv->sniffer_enabled = true;
 	}
@@ -3162,7 +3161,7 @@ static void mwl8k_configure_filter(struct ieee80211_hw *hw,
 		return;
 
 	if (priv->sniffer_enabled) {
-		mwl8k_enable_sniffer(hw, 0);
+		mwl8k_cmd_enable_sniffer(hw, 0);
 		priv->sniffer_enabled = false;
 	}
 
@@ -3212,7 +3211,7 @@ static void mwl8k_configure_filter(struct ieee80211_hw *hw,
 
 static int mwl8k_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 {
-	return mwl8k_rts_threshold(hw, MWL8K_CMD_SET, value);
+	return mwl8k_cmd_set_rts_threshold(hw, MWL8K_CMD_SET, value);
 }
 
 static int mwl8k_conf_tx(struct ieee80211_hw *hw, u16 queue,
@@ -3224,14 +3223,14 @@ static int mwl8k_conf_tx(struct ieee80211_hw *hw, u16 queue,
 	rc = mwl8k_fw_lock(hw);
 	if (!rc) {
 		if (!priv->wmm_enabled)
-			rc = mwl8k_set_wmm(hw, 1);
+			rc = mwl8k_cmd_set_wmm_mode(hw, 1);
 
 		if (!rc)
-			rc = mwl8k_set_edca_params(hw, queue,
-						   params->cw_min,
-						   params->cw_max,
-						   params->aifs,
-						   params->txop);
+			rc = mwl8k_cmd_set_edca_params(hw, queue,
+						       params->cw_min,
+						       params->cw_max,
+						       params->aifs,
+						       params->txop);
 
 		mwl8k_fw_unlock(hw);
 	}
@@ -3260,7 +3259,7 @@ static int mwl8k_get_tx_stats(struct ieee80211_hw *hw,
 static int mwl8k_get_stats(struct ieee80211_hw *hw,
 			   struct ieee80211_low_level_stats *stats)
 {
-	return mwl8k_cmd_802_11_get_stat(hw, stats);
+	return mwl8k_cmd_get_stat(hw, stats);
 }
 
 static const struct ieee80211_ops mwl8k_ops = {
@@ -3303,7 +3302,7 @@ static void mwl8k_finalize_join_worker(struct work_struct *work)
 	struct sk_buff *skb = priv->beacon_skb;
 	u8 dtim = MWL8K_VIF(priv->vif)->bss_info.dtim_period;
 
-	mwl8k_finalize_join(priv->hw, skb->data, skb->len, dtim);
+	mwl8k_cmd_finalize_join(priv->hw, skb->data, skb->len, dtim);
 	dev_kfree_skb(skb);
 
 	priv->beacon_skb = NULL;
@@ -3532,14 +3531,14 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	}
 
 	/* Turn radio off */
-	rc = mwl8k_cmd_802_11_radio_disable(hw);
+	rc = mwl8k_cmd_radio_disable(hw);
 	if (rc) {
 		printk(KERN_ERR "%s: Cannot disable\n", wiphy_name(hw->wiphy));
 		goto err_stop_firmware;
 	}
 
 	/* Clear MAC address */
-	rc = mwl8k_set_mac_addr(hw, "\x00\x00\x00\x00\x00\x00");
+	rc = mwl8k_cmd_set_mac_addr(hw, "\x00\x00\x00\x00\x00\x00");
 	if (rc) {
 		printk(KERN_ERR "%s: Cannot clear MAC address\n",
 		       wiphy_name(hw->wiphy));
-- 
1.5.6.4
