Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:44281 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605AbaDMTVF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:21:05 -0400
Received: by mail-we0-f178.google.com with SMTP id u56so7364327wes.9
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:21:04 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 37/47] iwlwifi: remove IWL_UCODE_TLV_FLAGS_STA_KEY_CMD flag
Date: Sun, 13 Apr 2014 22:19:52 +0300
Message-Id: <1397416802-32403-37-git-send-email-egrumbach@gmail.com> (sfid-20140413_213518_334587_24F35308)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

All the supported firmwares have this flag set.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h         |   2 -
 drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h |  46 +-------
 drivers/net/wireless/iwlwifi/mvm/sta.c        | 161 +++++---------------------
 3 files changed, 32 insertions(+), 177 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index ad65f68..77f02e1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -83,7 +83,6 @@
  *	from the probe request template.
  * @IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_SMALL: new NS offload (small version)
  * @IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_LARGE: new NS offload (large version)
- * @IWL_UCODE_TLV_FLAGS_STA_KEY_CMD: new ADD_STA and ADD_STA_KEY command API
  * @IWL_UCODE_TLV_FLAGS_DEVICE_PS_CMD: support device wide power command
  *	containing CAM (Continuous Active Mode) indication.
  * @IWL_UCODE_TLV_FLAGS_P2P_PM: P2P client supports PM as a stand alone MAC
@@ -106,7 +105,6 @@ enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_NO_BASIC_SSID	= BIT(12),
 	IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_SMALL	= BIT(15),
 	IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_LARGE	= BIT(16),
-	IWL_UCODE_TLV_FLAGS_STA_KEY_CMD		= BIT(19),
 	IWL_UCODE_TLV_FLAGS_DEVICE_PS_CMD	= BIT(20),
 	IWL_UCODE_TLV_FLAGS_P2P_PM		= BIT(21),
 	IWL_UCODE_TLV_FLAGS_BSS_P2P_PS_DCM	= BIT(22),
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h
index d636478..39cebee 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h
@@ -255,22 +255,19 @@ struct iwl_mvm_keyinfo {
 } __packed;
 
 /**
- * struct iwl_mvm_add_sta_cmd_v5 - Add/modify a station in the fw's sta table.
+ * struct iwl_mvm_add_sta_cmd - Add/modify a station in the fw's sta table.
  * ( REPLY_ADD_STA = 0x18 )
  * @add_modify: 1: modify existing, 0: add new station
- * @unicast_tx_key_id: unicast tx key id. Relevant only when unicast key sent
- * @multicast_tx_key_id: multicast tx key id. Relevant only when multicast key
- *	sent
+ * @awake_acs:
+ * @tid_disable_tx: is tid BIT(tid) enabled for Tx. Clear BIT(x) to enable
+ *	AMPDU for tid x. Set %STA_MODIFY_TID_DISABLE_TX to change this field.
  * @mac_id_n_color: the Mac context this station belongs to
  * @addr[ETH_ALEN]: station's MAC address
  * @sta_id: index of station in uCode's station table
  * @modify_mask: STA_MODIFY_*, selects which parameters to modify vs. leave
  *	alone. 1 - modify, 0 - don't change.
- * @key: look at %iwl_mvm_keyinfo
  * @station_flags: look at %iwl_sta_flags
  * @station_flags_msk: what of %station_flags have changed
- * @tid_disable_tx: is tid BIT(tid) enabled for Tx. Clear BIT(x) to enable
- *	AMPDU for tid x. Set %STA_MODIFY_TID_DISABLE_TX to change this field.
  * @add_immediate_ba_tid: tid for which to add block-ack support (Rx)
  *	Set %STA_MODIFY_ADD_BA_TID to use this field, and also set
  *	add_immediate_ba_ssn.
@@ -294,40 +291,7 @@ struct iwl_mvm_keyinfo {
  * ADD_STA sets up the table entry for one station, either creating a new
  * entry, or modifying a pre-existing one.
  */
-struct iwl_mvm_add_sta_cmd_v5 {
-	u8 add_modify;
-	u8 unicast_tx_key_id;
-	u8 multicast_tx_key_id;
-	u8 reserved1;
-	__le32 mac_id_n_color;
-	u8 addr[ETH_ALEN];
-	__le16 reserved2;
-	u8 sta_id;
-	u8 modify_mask;
-	__le16 reserved3;
-	struct iwl_mvm_keyinfo key;
-	__le32 station_flags;
-	__le32 station_flags_msk;
-	__le16 tid_disable_tx;
-	__le16 reserved4;
-	u8 add_immediate_ba_tid;
-	u8 remove_immediate_ba_tid;
-	__le16 add_immediate_ba_ssn;
-	__le16 sleep_tx_count;
-	__le16 sleep_state_flags;
-	__le16 assoc_id;
-	__le16 beamform_flags;
-	__le32 tfd_queue_msk;
-} __packed; /* ADD_STA_CMD_API_S_VER_5 */
-
-/**
- * struct iwl_mvm_add_sta_cmd_v7 - Add / modify a station
- * VER_7 of this command is quite similar to VER_5 except
- * exclusion of all fields related to the security key installation.
- * It only differs from VER_6 by the "awake_acs" field that is
- * reserved and ignored in VER_6.
- */
-struct iwl_mvm_add_sta_cmd_v7 {
+struct iwl_mvm_add_sta_cmd {
 	u8 add_modify;
 	u8 awake_acs;
 	__le16 tid_disable_tx;
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 075500c..3e11b9d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -66,115 +66,6 @@
 #include "sta.h"
 #include "rs.h"
 
-static void iwl_mvm_add_sta_cmd_v7_to_v5(struct iwl_mvm_add_sta_cmd_v7 *cmd_v7,
-					 struct iwl_mvm_add_sta_cmd_v5 *cmd_v5)
-{
-	memset(cmd_v5, 0, sizeof(*cmd_v5));
-
-	cmd_v5->add_modify = cmd_v7->add_modify;
-	cmd_v5->tid_disable_tx = cmd_v7->tid_disable_tx;
-	cmd_v5->mac_id_n_color = cmd_v7->mac_id_n_color;
-	memcpy(cmd_v5->addr, cmd_v7->addr, ETH_ALEN);
-	cmd_v5->sta_id = cmd_v7->sta_id;
-	cmd_v5->modify_mask = cmd_v7->modify_mask;
-	cmd_v5->station_flags = cmd_v7->station_flags;
-	cmd_v5->station_flags_msk = cmd_v7->station_flags_msk;
-	cmd_v5->add_immediate_ba_tid = cmd_v7->add_immediate_ba_tid;
-	cmd_v5->remove_immediate_ba_tid = cmd_v7->remove_immediate_ba_tid;
-	cmd_v5->add_immediate_ba_ssn = cmd_v7->add_immediate_ba_ssn;
-	cmd_v5->sleep_tx_count = cmd_v7->sleep_tx_count;
-	cmd_v5->sleep_state_flags = cmd_v7->sleep_state_flags;
-	cmd_v5->assoc_id = cmd_v7->assoc_id;
-	cmd_v5->beamform_flags = cmd_v7->beamform_flags;
-	cmd_v5->tfd_queue_msk = cmd_v7->tfd_queue_msk;
-}
-
-static void
-iwl_mvm_add_sta_key_to_add_sta_cmd_v5(struct iwl_mvm_add_sta_key_cmd *key_cmd,
-				      struct iwl_mvm_add_sta_cmd_v5 *sta_cmd,
-				      u32 mac_id_n_color)
-{
-	memset(sta_cmd, 0, sizeof(*sta_cmd));
-
-	sta_cmd->sta_id = key_cmd->sta_id;
-	sta_cmd->add_modify = STA_MODE_MODIFY;
-	sta_cmd->modify_mask = STA_MODIFY_KEY;
-	sta_cmd->mac_id_n_color = cpu_to_le32(mac_id_n_color);
-
-	sta_cmd->key.key_offset = key_cmd->key_offset;
-	sta_cmd->key.key_flags = key_cmd->key_flags;
-	memcpy(sta_cmd->key.key, key_cmd->key, sizeof(sta_cmd->key.key));
-	sta_cmd->key.tkip_rx_tsc_byte2 = key_cmd->tkip_rx_tsc_byte2;
-	memcpy(sta_cmd->key.tkip_rx_ttak, key_cmd->tkip_rx_ttak,
-	       sizeof(sta_cmd->key.tkip_rx_ttak));
-}
-
-static int iwl_mvm_send_add_sta_cmd_status(struct iwl_mvm *mvm,
-					   struct iwl_mvm_add_sta_cmd_v7 *cmd,
-					   int *status)
-{
-	struct iwl_mvm_add_sta_cmd_v5 cmd_v5;
-
-	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_STA_KEY_CMD)
-		return iwl_mvm_send_cmd_pdu_status(mvm, ADD_STA, sizeof(*cmd),
-						   cmd, status);
-
-	iwl_mvm_add_sta_cmd_v7_to_v5(cmd, &cmd_v5);
-
-	return iwl_mvm_send_cmd_pdu_status(mvm, ADD_STA, sizeof(cmd_v5),
-					   &cmd_v5, status);
-}
-
-static int iwl_mvm_send_add_sta_cmd(struct iwl_mvm *mvm, u32 flags,
-				    struct iwl_mvm_add_sta_cmd_v7 *cmd)
-{
-	struct iwl_mvm_add_sta_cmd_v5 cmd_v5;
-
-	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_STA_KEY_CMD)
-		return iwl_mvm_send_cmd_pdu(mvm, ADD_STA, flags,
-					    sizeof(*cmd), cmd);
-
-	iwl_mvm_add_sta_cmd_v7_to_v5(cmd, &cmd_v5);
-
-	return iwl_mvm_send_cmd_pdu(mvm, ADD_STA, flags, sizeof(cmd_v5),
-				    &cmd_v5);
-}
-
-static int
-iwl_mvm_send_add_sta_key_cmd_status(struct iwl_mvm *mvm,
-				    struct iwl_mvm_add_sta_key_cmd *cmd,
-				    u32 mac_id_n_color,
-				    int *status)
-{
-	struct iwl_mvm_add_sta_cmd_v5 sta_cmd;
-
-	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_STA_KEY_CMD)
-		return iwl_mvm_send_cmd_pdu_status(mvm, ADD_STA_KEY,
-						   sizeof(*cmd), cmd, status);
-
-	iwl_mvm_add_sta_key_to_add_sta_cmd_v5(cmd, &sta_cmd, mac_id_n_color);
-
-	return iwl_mvm_send_cmd_pdu_status(mvm, ADD_STA, sizeof(sta_cmd),
-					   &sta_cmd, status);
-}
-
-static int iwl_mvm_send_add_sta_key_cmd(struct iwl_mvm *mvm,
-					u32 flags,
-					struct iwl_mvm_add_sta_key_cmd *cmd,
-					u32 mac_id_n_color)
-{
-	struct iwl_mvm_add_sta_cmd_v5 sta_cmd;
-
-	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_STA_KEY_CMD)
-		return iwl_mvm_send_cmd_pdu(mvm, ADD_STA_KEY, flags,
-					    sizeof(*cmd), cmd);
-
-	iwl_mvm_add_sta_key_to_add_sta_cmd_v5(cmd, &sta_cmd, mac_id_n_color);
-
-	return iwl_mvm_send_cmd_pdu(mvm, ADD_STA, flags, sizeof(sta_cmd),
-				    &sta_cmd);
-}
-
 static int iwl_mvm_find_free_sta_id(struct iwl_mvm *mvm,
 				    enum nl80211_iftype iftype)
 {
@@ -207,7 +98,7 @@ int iwl_mvm_sta_send_to_fw(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 			   bool update)
 {
 	struct iwl_mvm_sta *mvm_sta = (void *)sta->drv_priv;
-	struct iwl_mvm_add_sta_cmd_v7 add_sta_cmd;
+	struct iwl_mvm_add_sta_cmd add_sta_cmd;
 	int ret;
 	u32 status;
 	u32 agg_size = 0, mpdu_dens = 0;
@@ -295,7 +186,8 @@ int iwl_mvm_sta_send_to_fw(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		cpu_to_le32(mpdu_dens << STA_FLG_AGG_MPDU_DENS_SHIFT);
 
 	status = ADD_STA_SUCCESS;
-	ret = iwl_mvm_send_add_sta_cmd_status(mvm, &add_sta_cmd, &status);
+	ret = iwl_mvm_send_cmd_pdu_status(mvm, ADD_STA, sizeof(add_sta_cmd),
+					  &add_sta_cmd, &status);
 	if (ret)
 		return ret;
 
@@ -380,7 +272,7 @@ int iwl_mvm_update_sta(struct iwl_mvm *mvm,
 int iwl_mvm_drain_sta(struct iwl_mvm *mvm, struct iwl_mvm_sta *mvmsta,
 		      bool drain)
 {
-	struct iwl_mvm_add_sta_cmd_v7 cmd = {};
+	struct iwl_mvm_add_sta_cmd cmd = {};
 	int ret;
 	u32 status;
 
@@ -393,7 +285,8 @@ int iwl_mvm_drain_sta(struct iwl_mvm *mvm, struct iwl_mvm_sta *mvmsta,
 	cmd.station_flags_msk = cpu_to_le32(STA_FLG_DRAIN_FLOW);
 
 	status = ADD_STA_SUCCESS;
-	ret = iwl_mvm_send_add_sta_cmd_status(mvm, &cmd, &status);
+	ret = iwl_mvm_send_cmd_pdu_status(mvm, ADD_STA, sizeof(cmd),
+					  &cmd, &status);
 	if (ret)
 		return ret;
 
@@ -595,13 +488,13 @@ static int iwl_mvm_add_int_sta_common(struct iwl_mvm *mvm,
 				      const u8 *addr,
 				      u16 mac_id, u16 color)
 {
-	struct iwl_mvm_add_sta_cmd_v7 cmd;
+	struct iwl_mvm_add_sta_cmd cmd;
 	int ret;
 	u32 status;
 
 	lockdep_assert_held(&mvm->mutex);
 
-	memset(&cmd, 0, sizeof(struct iwl_mvm_add_sta_cmd_v7));
+	memset(&cmd, 0, sizeof(cmd));
 	cmd.sta_id = sta->sta_id;
 	cmd.mac_id_n_color = cpu_to_le32(FW_CMD_ID_AND_COLOR(mac_id,
 							     color));
@@ -611,7 +504,8 @@ static int iwl_mvm_add_int_sta_common(struct iwl_mvm *mvm,
 	if (addr)
 		memcpy(cmd.addr, addr, ETH_ALEN);
 
-	ret = iwl_mvm_send_add_sta_cmd_status(mvm, &cmd, &status);
+	ret = iwl_mvm_send_cmd_pdu_status(mvm, ADD_STA, sizeof(cmd),
+					  &cmd, &status);
 	if (ret)
 		return ret;
 
@@ -745,7 +639,7 @@ int iwl_mvm_sta_rx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		       int tid, u16 ssn, bool start)
 {
 	struct iwl_mvm_sta *mvm_sta = (void *)sta->drv_priv;
-	struct iwl_mvm_add_sta_cmd_v7 cmd = {};
+	struct iwl_mvm_add_sta_cmd cmd = {};
 	int ret;
 	u32 status;
 
@@ -769,7 +663,8 @@ int iwl_mvm_sta_rx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 				  STA_MODIFY_REMOVE_BA_TID;
 
 	status = ADD_STA_SUCCESS;
-	ret = iwl_mvm_send_add_sta_cmd_status(mvm, &cmd, &status);
+	ret = iwl_mvm_send_cmd_pdu_status(mvm, ADD_STA, sizeof(cmd),
+					  &cmd, &status);
 	if (ret)
 		return ret;
 
@@ -804,7 +699,7 @@ static int iwl_mvm_sta_tx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 			      int tid, u8 queue, bool start)
 {
 	struct iwl_mvm_sta *mvm_sta = (void *)sta->drv_priv;
-	struct iwl_mvm_add_sta_cmd_v7 cmd = {};
+	struct iwl_mvm_add_sta_cmd cmd = {};
 	int ret;
 	u32 status;
 
@@ -826,7 +721,8 @@ static int iwl_mvm_sta_tx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	cmd.tid_disable_tx = cpu_to_le16(mvm_sta->tid_disable_agg);
 
 	status = ADD_STA_SUCCESS;
-	ret = iwl_mvm_send_add_sta_cmd_status(mvm, &cmd, &status);
+	ret = iwl_mvm_send_cmd_pdu_status(mvm, ADD_STA, sizeof(cmd),
+					  &cmd, &status);
 	if (ret)
 		return ret;
 
@@ -1121,12 +1017,11 @@ static int iwl_mvm_send_sta_key(struct iwl_mvm *mvm,
 				u8 sta_id, u32 tkip_iv32, u16 *tkip_p1k,
 				u32 cmd_flags)
 {
-	__le16 key_flags;
 	struct iwl_mvm_add_sta_key_cmd cmd = {};
+	__le16 key_flags;
 	int ret, status;
 	u16 keyidx;
 	int i;
-	u32 mac_id_n_color = mvm_sta->mac_id_n_color;
 
 	keyidx = (keyconf->keyidx << STA_KEY_FLG_KEYID_POS) &
 		 STA_KEY_FLG_KEYID_MSK;
@@ -1159,12 +1054,11 @@ static int iwl_mvm_send_sta_key(struct iwl_mvm *mvm,
 
 	status = ADD_STA_SUCCESS;
 	if (cmd_flags == CMD_SYNC)
-		ret = iwl_mvm_send_add_sta_key_cmd_status(mvm, &cmd,
-							  mac_id_n_color,
-							  &status);
+		ret = iwl_mvm_send_cmd_pdu_status(mvm, ADD_STA_KEY, sizeof(cmd),
+						  &cmd, &status);
 	else
-		ret = iwl_mvm_send_add_sta_key_cmd(mvm, CMD_ASYNC, &cmd,
-						   mac_id_n_color);
+		ret =  iwl_mvm_send_cmd_pdu(mvm, ADD_STA_KEY, CMD_ASYNC,
+					    sizeof(cmd), &cmd);
 
 	switch (status) {
 	case ADD_STA_SUCCESS:
@@ -1391,9 +1285,8 @@ int iwl_mvm_remove_sta_key(struct iwl_mvm *mvm,
 	cmd.sta_id = sta_id;
 
 	status = ADD_STA_SUCCESS;
-	ret = iwl_mvm_send_add_sta_key_cmd_status(mvm, &cmd,
-						  mvm_sta->mac_id_n_color,
-						  &status);
+	ret = iwl_mvm_send_cmd_pdu_status(mvm, ADD_STA_KEY, sizeof(cmd),
+					  &cmd, &status);
 
 	switch (status) {
 	case ADD_STA_SUCCESS:
@@ -1440,7 +1333,7 @@ void iwl_mvm_sta_modify_ps_wake(struct iwl_mvm *mvm,
 				struct ieee80211_sta *sta)
 {
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
-	struct iwl_mvm_add_sta_cmd_v7 cmd = {
+	struct iwl_mvm_add_sta_cmd cmd = {
 		.add_modify = STA_MODE_MODIFY,
 		.sta_id = mvmsta->sta_id,
 		.station_flags_msk = cpu_to_le32(STA_FLG_PS),
@@ -1448,7 +1341,7 @@ void iwl_mvm_sta_modify_ps_wake(struct iwl_mvm *mvm,
 	};
 	int ret;
 
-	ret = iwl_mvm_send_add_sta_cmd(mvm, CMD_ASYNC, &cmd);
+	ret = iwl_mvm_send_cmd_pdu(mvm, ADD_STA, CMD_ASYNC, sizeof(cmd), &cmd);
 	if (ret)
 		IWL_ERR(mvm, "Failed to send ADD_STA command (%d)\n", ret);
 }
@@ -1460,7 +1353,7 @@ void iwl_mvm_sta_modify_sleep_tx_count(struct iwl_mvm *mvm,
 				       bool agg)
 {
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
-	struct iwl_mvm_add_sta_cmd_v7 cmd = {
+	struct iwl_mvm_add_sta_cmd cmd = {
 		.add_modify = STA_MODE_MODIFY,
 		.sta_id = mvmsta->sta_id,
 		.modify_mask = STA_MODIFY_SLEEPING_STA_TX_COUNT,
@@ -1530,7 +1423,7 @@ void iwl_mvm_sta_modify_sleep_tx_count(struct iwl_mvm *mvm,
 		cmd.sleep_state_flags |= cpu_to_le16(STA_SLEEP_STATE_UAPSD);
 	}
 
-	ret = iwl_mvm_send_add_sta_cmd(mvm, CMD_ASYNC, &cmd);
+	ret = iwl_mvm_send_cmd_pdu(mvm, ADD_STA, CMD_ASYNC, sizeof(cmd), &cmd);
 	if (ret)
 		IWL_ERR(mvm, "Failed to send ADD_STA command (%d)\n", ret);
 }
-- 
1.8.3.2

