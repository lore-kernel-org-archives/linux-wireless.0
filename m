Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:50573 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756430AbaGVT1a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 15:27:30 -0400
Received: by mail-wi0-f174.google.com with SMTP id d1so6608461wiv.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2014 12:27:29 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/20] iwlwifi: mvm: BT Coex - fix the ACK / CTS kill mask
Date: Tue, 22 Jul 2014 22:26:41 +0300
Message-Id: <1406057211-31752-10-git-send-email-egrumbach@gmail.com> (sfid-20140722_212747_331002_F4396273)
In-Reply-To: <53CEB854.9000008@gmail.com>
References: <53CEB854.9000008@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

According to new requirements, the ACK / CTS kill mask is
not related to reduced TX power anymore. This allows to
remove the code that tracked reduced TX power enablement
across different interfaces.
The ACK / CTS kill mask is now fetch from a table. It
depends on the Activity grading (activity from BT) and on
the Look Up Table (LUT) type.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c        | 170 +++++++++++--------------
 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c | 102 +++------------
 drivers/net/wireless/iwlwifi/mvm/debugfs.c     |  21 ++-
 drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h |   2 +
 drivers/net/wireless/iwlwifi/mvm/mvm.h         |  13 +-
 5 files changed, 115 insertions(+), 193 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index e0a5cf2..a65b1bb 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -72,16 +72,56 @@
 
 #define BT_ANTENNA_COUPLING_THRESHOLD		(30)
 
-const u32 iwl_bt_ack_kill_msk[BT_KILL_MSK_MAX] = {
-	[BT_KILL_MSK_DEFAULT] = 0xffff0000,
-	[BT_KILL_MSK_SCO_HID_A2DP] = 0xffffffff,
-	[BT_KILL_MSK_REDUCED_TXPOW] = 0,
+const u32 iwl_bt_ctl_kill_msk[BT_KILL_MSK_MAX] = {
+	[BT_KILL_MSK_DEFAULT] = 0xfffffc00,
+	[BT_KILL_MSK_NEVER] = 0xffffffff,
+	[BT_KILL_MSK_ALWAYS] = 0,
 };
 
-const u32 iwl_bt_cts_kill_msk[BT_KILL_MSK_MAX] = {
-	[BT_KILL_MSK_DEFAULT] = 0xffff0000,
-	[BT_KILL_MSK_SCO_HID_A2DP] = 0xffffffff,
-	[BT_KILL_MSK_REDUCED_TXPOW] = 0,
+const u8 iwl_bt_cts_kill_msk[BT_MAX_AG][BT_COEX_MAX_LUT] = {
+	{
+		BT_KILL_MSK_ALWAYS,
+		BT_KILL_MSK_ALWAYS,
+		BT_KILL_MSK_ALWAYS,
+	},
+	{
+		BT_KILL_MSK_NEVER,
+		BT_KILL_MSK_NEVER,
+		BT_KILL_MSK_NEVER,
+	},
+	{
+		BT_KILL_MSK_NEVER,
+		BT_KILL_MSK_NEVER,
+		BT_KILL_MSK_NEVER,
+	},
+	{
+		BT_KILL_MSK_DEFAULT,
+		BT_KILL_MSK_NEVER,
+		BT_KILL_MSK_DEFAULT,
+	},
+};
+
+const u8 iwl_bt_ack_kill_msk[BT_MAX_AG][BT_COEX_MAX_LUT] = {
+	{
+		BT_KILL_MSK_ALWAYS,
+		BT_KILL_MSK_ALWAYS,
+		BT_KILL_MSK_ALWAYS,
+	},
+	{
+		BT_KILL_MSK_ALWAYS,
+		BT_KILL_MSK_ALWAYS,
+		BT_KILL_MSK_ALWAYS,
+	},
+	{
+		BT_KILL_MSK_ALWAYS,
+		BT_KILL_MSK_ALWAYS,
+		BT_KILL_MSK_ALWAYS,
+	},
+	{
+		BT_KILL_MSK_DEFAULT,
+		BT_KILL_MSK_ALWAYS,
+		BT_KILL_MSK_DEFAULT,
+	},
 };
 
 static const __le32 iwl_bt_prio_boost[BT_COEX_BOOST_SIZE] = {
@@ -611,54 +651,43 @@ send_cmd:
 	return ret;
 }
 
-static int iwl_mvm_bt_udpate_sw_boost(struct iwl_mvm *mvm,
-				      bool reduced_tx_power)
+static int iwl_mvm_bt_udpate_sw_boost(struct iwl_mvm *mvm)
 {
-	enum iwl_bt_kill_msk bt_kill_msk;
-	struct iwl_bt_coex_sw_boost_update_cmd cmd = {};
 	struct iwl_bt_coex_profile_notif *notif = &mvm->last_bt_notif;
+	u32 primary_lut = le32_to_cpu(notif->primary_ch_lut);
+	u32 secondary_lut = le32_to_cpu(notif->secondary_ch_lut);
+	u32 ag = le32_to_cpu(notif->bt_activity_grading);
+	struct iwl_bt_coex_sw_boost_update_cmd cmd = {};
+	u8 ack_kill_msk[NUM_PHY_CTX] = {};
+	u8 cts_kill_msk[NUM_PHY_CTX] = {};
+	int i;
 
 	lockdep_assert_held(&mvm->mutex);
 
-	if (reduced_tx_power) {
-		/* Reduced Tx power has precedence on the type of the profile */
-		bt_kill_msk = BT_KILL_MSK_REDUCED_TXPOW;
-	} else {
-		/* Low latency BT profile is active: give higher prio to BT */
-		if (BT_MBOX_MSG(notif, 3, SCO_STATE)  ||
-		    BT_MBOX_MSG(notif, 3, A2DP_STATE) ||
-		    BT_MBOX_MSG(notif, 3, SNIFF_STATE))
-			bt_kill_msk = BT_KILL_MSK_SCO_HID_A2DP;
-		else
-			bt_kill_msk = BT_KILL_MSK_DEFAULT;
-	}
+	ack_kill_msk[0] = iwl_bt_ack_kill_msk[ag][primary_lut];
+	cts_kill_msk[0] = iwl_bt_cts_kill_msk[ag][primary_lut];
 
-	IWL_DEBUG_COEX(mvm,
-		       "Update kill_msk: %d - SCO %sactive A2DP %sactive SNIFF %sactive\n",
-		       bt_kill_msk,
-		       BT_MBOX_MSG(notif, 3, SCO_STATE) ? "" : "in",
-		       BT_MBOX_MSG(notif, 3, A2DP_STATE) ? "" : "in",
-		       BT_MBOX_MSG(notif, 3, SNIFF_STATE) ? "" : "in");
+	ack_kill_msk[1] = iwl_bt_ack_kill_msk[ag][secondary_lut];
+	cts_kill_msk[1] = iwl_bt_cts_kill_msk[ag][secondary_lut];
 
 	/* Don't send HCMD if there is no update */
-	if (bt_kill_msk == mvm->bt_kill_msk)
+	if (!memcmp(ack_kill_msk, mvm->bt_ack_kill_msk, sizeof(ack_kill_msk)) ||
+	    !memcmp(cts_kill_msk, mvm->bt_cts_kill_msk, sizeof(cts_kill_msk)))
 		return 0;
 
-	mvm->bt_kill_msk = bt_kill_msk;
+	memcpy(mvm->bt_ack_kill_msk, ack_kill_msk,
+	       sizeof(mvm->bt_ack_kill_msk));
+	memcpy(mvm->bt_cts_kill_msk, cts_kill_msk,
+	       sizeof(mvm->bt_cts_kill_msk));
 
-	cmd.boost_values[0].kill_ack_msk =
-		cpu_to_le32(iwl_bt_ack_kill_msk[bt_kill_msk]);
-	cmd.boost_values[0].kill_cts_msk =
-		cpu_to_le32(iwl_bt_cts_kill_msk[bt_kill_msk]);
+	BUILD_BUG_ON(ARRAY_SIZE(ack_kill_msk) < ARRAY_SIZE(cmd.boost_values));
 
-	cmd.boost_values[1].kill_ack_msk = cmd.boost_values[0].kill_ack_msk;
-	cmd.boost_values[2].kill_cts_msk = cmd.boost_values[0].kill_cts_msk;
-	cmd.boost_values[1].kill_ack_msk = cmd.boost_values[0].kill_ack_msk;
-	cmd.boost_values[2].kill_cts_msk = cmd.boost_values[0].kill_cts_msk;
-
-	IWL_DEBUG_COEX(mvm, "ACK Kill msk = 0x%08x, CTS Kill msk = 0x%08x\n",
-		       iwl_bt_ack_kill_msk[bt_kill_msk],
-		       iwl_bt_cts_kill_msk[bt_kill_msk]);
+	for (i = 0; i < ARRAY_SIZE(cmd.boost_values); i++) {
+		cmd.boost_values[i].kill_ack_msk =
+			cpu_to_le32(iwl_bt_ctl_kill_msk[ack_kill_msk[i]]);
+		cmd.boost_values[i].kill_cts_msk =
+			cpu_to_le32(iwl_bt_ctl_kill_msk[cts_kill_msk[i]]);
+	}
 
 	return iwl_mvm_send_cmd_pdu(mvm, BT_COEX_UPDATE_SW_BOOST, 0,
 				    sizeof(cmd), &cmd);
@@ -700,8 +729,6 @@ static int iwl_mvm_bt_coex_reduced_txp(struct iwl_mvm *mvm, u8 sta_id,
 struct iwl_bt_iterator_data {
 	struct iwl_bt_coex_profile_notif *notif;
 	struct iwl_mvm *mvm;
-	u32 num_bss_ifaces;
-	bool reduced_tx_power;
 	struct ieee80211_chanctx_conf *primary;
 	struct ieee80211_chanctx_conf *secondary;
 	bool primary_ll;
@@ -737,8 +764,6 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
-		/* Count BSSes vifs */
-		data->num_bss_ifaces++;
 		/* default smps_mode for BSS / P2P client is AUTOMATIC */
 		smps_mode = IEEE80211_SMPS_AUTOMATIC;
 		break;
@@ -750,9 +775,6 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 					    smps_mode);
 			return;
 		}
-
-		/* the Ack / Cts kill mask must be default if AP / GO */
-		data->reduced_tx_power = false;
 		break;
 	default:
 		return;
@@ -766,7 +788,6 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 		/* ... relax constraints and disable rssi events */
 		iwl_mvm_update_smps(mvm, vif, IWL_MVM_SMPS_REQ_BT_COEX,
 				    smps_mode);
-		data->reduced_tx_power = false;
 		if (vif->type == NL80211_IFTYPE_STATION) {
 			iwl_mvm_bt_coex_reduced_txp(mvm, mvmvif->ap_sta_id,
 						    false);
@@ -846,7 +867,6 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 	if (iwl_get_coex_type(mvm, vif) == BT_COEX_LOOSE_LUT ||
 	    mvm->cfg->bt_shared_single_ant || !vif->bss_conf.assoc ||
 	    le32_to_cpu(mvm->last_bt_notif.bt_activity_grading) == BT_OFF) {
-		data->reduced_tx_power = false;
 		iwl_mvm_bt_coex_reduced_txp(mvm, mvmvif->ap_sta_id, false);
 		iwl_mvm_bt_coex_enable_rssi_event(mvm, vif, false, 0);
 		return;
@@ -861,23 +881,9 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 	if (ave_rssi > -IWL_MVM_BT_COEX_EN_RED_TXP_THRESH) {
 		if (iwl_mvm_bt_coex_reduced_txp(mvm, mvmvif->ap_sta_id, true))
 			IWL_ERR(mvm, "Couldn't send BT_CONFIG cmd\n");
-
-		/*
-		 * bt_kill_msk can be BT_KILL_MSK_REDUCED_TXPOW only if all the
-		 * BSS / P2P clients have rssi above threshold.
-		 * We set the bt_kill_msk to BT_KILL_MSK_REDUCED_TXPOW before
-		 * the iteration, if one interface's rssi isn't good enough,
-		 * bt_kill_msk will be set to default values.
-		 */
 	} else if (ave_rssi < -IWL_MVM_BT_COEX_DIS_RED_TXP_THRESH) {
 		if (iwl_mvm_bt_coex_reduced_txp(mvm, mvmvif->ap_sta_id, false))
 			IWL_ERR(mvm, "Couldn't send BT_CONFIG cmd\n");
-
-		/*
-		 * One interface hasn't rssi above threshold, bt_kill_msk must
-		 * be set to default values.
-		 */
-		data->reduced_tx_power = false;
 	}
 
 	/* Begin to monitor the RSSI: it may influence the reduced Tx power */
@@ -889,7 +895,6 @@ static void iwl_mvm_bt_coex_notif_handle(struct iwl_mvm *mvm)
 	struct iwl_bt_iterator_data data = {
 		.mvm = mvm,
 		.notif = &mvm->last_bt_notif,
-		.reduced_tx_power = true,
 	};
 	struct iwl_bt_coex_ci_cmd cmd = {};
 	u8 ci_bw_idx;
@@ -959,14 +964,7 @@ static void iwl_mvm_bt_coex_notif_handle(struct iwl_mvm *mvm)
 		memcpy(&mvm->last_bt_ci_cmd, &cmd, sizeof(cmd));
 	}
 
-	/*
-	 * If there are no BSS / P2P client interfaces, reduced Tx Power is
-	 * irrelevant since it is based on the RSSI coming from the beacon.
-	 * Use BT_KILL_MSK_DEFAULT in that case.
-	 */
-	data.reduced_tx_power = data.reduced_tx_power && data.num_bss_ifaces;
-
-	if (iwl_mvm_bt_udpate_sw_boost(mvm, data.reduced_tx_power))
+	if (iwl_mvm_bt_udpate_sw_boost(mvm))
 		IWL_ERR(mvm, "Failed to update the ctrl_kill_msk\n");
 }
 
@@ -1035,16 +1033,6 @@ static void iwl_mvm_bt_rssi_iterator(void *_data, u8 *mac,
 		return;
 
 	mvmsta = iwl_mvm_sta_from_mac80211(sta);
-
-	data->num_bss_ifaces++;
-
-	/*
-	 * This interface doesn't support reduced Tx power (because of low
-	 * RSSI probably), then set bt_kill_msk to default values.
-	 */
-	if (!mvmsta->bt_reduced_txpower)
-		data->reduced_tx_power = false;
-	/* else - possibly leave it to BT_KILL_MSK_REDUCED_TXPOW */
 }
 
 void iwl_mvm_bt_rssi_event(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
@@ -1053,7 +1041,6 @@ void iwl_mvm_bt_rssi_event(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	struct iwl_mvm_vif *mvmvif = (void *)vif->drv_priv;
 	struct iwl_bt_iterator_data data = {
 		.mvm = mvm,
-		.reduced_tx_power = true,
 	};
 	int ret;
 
@@ -1100,14 +1087,7 @@ void iwl_mvm_bt_rssi_event(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
 		iwl_mvm_bt_rssi_iterator, &data);
 
-	/*
-	 * If there are no BSS / P2P client interfaces, reduced Tx Power is
-	 * irrelevant since it is based on the RSSI coming from the beacon.
-	 * Use BT_KILL_MSK_DEFAULT in that case.
-	 */
-	data.reduced_tx_power = data.reduced_tx_power && data.num_bss_ifaces;
-
-	if (iwl_mvm_bt_udpate_sw_boost(mvm, data.reduced_tx_power))
+	if (iwl_mvm_bt_udpate_sw_boost(mvm))
 		IWL_ERR(mvm, "Failed to update the ctrl_kill_msk\n");
 }
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
index ce50363..9e3ba5a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
@@ -649,10 +649,6 @@ int iwl_send_bt_init_conf_old(struct iwl_mvm *mvm)
 	       sizeof(iwl_bt_prio_boost));
 	memcpy(&bt_cmd->bt4_multiprio_lut, iwl_bt_mprio_lut,
 	       sizeof(iwl_bt_mprio_lut));
-	bt_cmd->kill_ack_msk =
-		cpu_to_le32(iwl_bt_ack_kill_msk[BT_KILL_MSK_DEFAULT]);
-	bt_cmd->kill_cts_msk =
-		cpu_to_le32(iwl_bt_cts_kill_msk[BT_KILL_MSK_DEFAULT]);
 
 send_cmd:
 	memset(&mvm->last_bt_notif_old, 0, sizeof(mvm->last_bt_notif_old));
@@ -664,12 +660,13 @@ send_cmd:
 	return ret;
 }
 
-static int iwl_mvm_bt_udpate_ctrl_kill_msk(struct iwl_mvm *mvm,
-					   bool reduced_tx_power)
+static int iwl_mvm_bt_udpate_ctrl_kill_msk(struct iwl_mvm *mvm)
 {
-	enum iwl_bt_kill_msk bt_kill_msk;
-	struct iwl_bt_coex_cmd_old *bt_cmd;
 	struct iwl_bt_coex_profile_notif_old *notif = &mvm->last_bt_notif_old;
+	u32 primary_lut = le32_to_cpu(notif->primary_ch_lut);
+	u32 ag = le32_to_cpu(notif->bt_activity_grading);
+	struct iwl_bt_coex_cmd_old *bt_cmd;
+	u8 ack_kill_msk, cts_kill_msk;
 	struct iwl_host_cmd cmd = {
 		.id = BT_CONFIG,
 		.data[0] = &bt_cmd,
@@ -680,31 +677,15 @@ static int iwl_mvm_bt_udpate_ctrl_kill_msk(struct iwl_mvm *mvm,
 
 	lockdep_assert_held(&mvm->mutex);
 
-	if (reduced_tx_power) {
-		/* Reduced Tx power has precedence on the type of the profile */
-		bt_kill_msk = BT_KILL_MSK_REDUCED_TXPOW;
-	} else {
-		/* Low latency BT profile is active: give higher prio to BT */
-		if (BT_MBOX_MSG(notif, 3, SCO_STATE)  ||
-		    BT_MBOX_MSG(notif, 3, A2DP_STATE) ||
-		    BT_MBOX_MSG(notif, 3, SNIFF_STATE))
-			bt_kill_msk = BT_KILL_MSK_SCO_HID_A2DP;
-		else
-			bt_kill_msk = BT_KILL_MSK_DEFAULT;
-	}
+	ack_kill_msk = iwl_bt_ack_kill_msk[ag][primary_lut];
+	cts_kill_msk = iwl_bt_cts_kill_msk[ag][primary_lut];
 
-	IWL_DEBUG_COEX(mvm,
-		       "Update kill_msk: %d - SCO %sactive A2DP %sactive SNIFF %sactive\n",
-		       bt_kill_msk,
-		       BT_MBOX_MSG(notif, 3, SCO_STATE) ? "" : "in",
-		       BT_MBOX_MSG(notif, 3, A2DP_STATE) ? "" : "in",
-		       BT_MBOX_MSG(notif, 3, SNIFF_STATE) ? "" : "in");
-
-	/* Don't send HCMD if there is no update */
-	if (bt_kill_msk == mvm->bt_kill_msk)
+	if (mvm->bt_ack_kill_msk[0] == ack_kill_msk &&
+	    mvm->bt_cts_kill_msk[0] == cts_kill_msk)
 		return 0;
 
-	mvm->bt_kill_msk = bt_kill_msk;
+	mvm->bt_ack_kill_msk[0] = ack_kill_msk;
+	mvm->bt_cts_kill_msk[0] = cts_kill_msk;
 
 	bt_cmd = kzalloc(sizeof(*bt_cmd), GFP_KERNEL);
 	if (!bt_cmd)
@@ -712,16 +693,12 @@ static int iwl_mvm_bt_udpate_ctrl_kill_msk(struct iwl_mvm *mvm,
 	cmd.data[0] = bt_cmd;
 	bt_cmd->flags = cpu_to_le32(BT_COEX_NW_OLD);
 
-	bt_cmd->kill_ack_msk = cpu_to_le32(iwl_bt_ack_kill_msk[bt_kill_msk]);
-	bt_cmd->kill_cts_msk = cpu_to_le32(iwl_bt_cts_kill_msk[bt_kill_msk]);
+	bt_cmd->kill_ack_msk = cpu_to_le32(iwl_bt_ctl_kill_msk[ack_kill_msk]);
+	bt_cmd->kill_cts_msk = cpu_to_le32(iwl_bt_ctl_kill_msk[cts_kill_msk]);
 	bt_cmd->valid_bit_msk |= cpu_to_le32(BT_VALID_ENABLE |
 					     BT_VALID_KILL_ACK |
 					     BT_VALID_KILL_CTS);
 
-	IWL_DEBUG_COEX(mvm, "ACK Kill msk = 0x%08x, CTS Kill msk = 0x%08x\n",
-		       iwl_bt_ack_kill_msk[bt_kill_msk],
-		       iwl_bt_cts_kill_msk[bt_kill_msk]);
-
 	ret = iwl_mvm_send_cmd(mvm, &cmd);
 
 	kfree(bt_cmd);
@@ -777,8 +754,6 @@ static int iwl_mvm_bt_coex_reduced_txp(struct iwl_mvm *mvm, u8 sta_id,
 struct iwl_bt_iterator_data {
 	struct iwl_bt_coex_profile_notif_old *notif;
 	struct iwl_mvm *mvm;
-	u32 num_bss_ifaces;
-	bool reduced_tx_power;
 	struct ieee80211_chanctx_conf *primary;
 	struct ieee80211_chanctx_conf *secondary;
 	bool primary_ll;
@@ -814,8 +789,6 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
-		/* Count BSSes vifs */
-		data->num_bss_ifaces++;
 		/* default smps_mode for BSS / P2P client is AUTOMATIC */
 		smps_mode = IEEE80211_SMPS_AUTOMATIC;
 		break;
@@ -827,9 +800,6 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 					    smps_mode);
 			return;
 		}
-
-		/* the Ack / Cts kill mask must be default if AP / GO */
-		data->reduced_tx_power = false;
 		break;
 	default:
 		return;
@@ -843,7 +813,6 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 		/* ... relax constraints and disable rssi events */
 		iwl_mvm_update_smps(mvm, vif, IWL_MVM_SMPS_REQ_BT_COEX,
 				    smps_mode);
-		data->reduced_tx_power = false;
 		if (vif->type == NL80211_IFTYPE_STATION) {
 			iwl_mvm_bt_coex_reduced_txp(mvm, mvmvif->ap_sta_id,
 						    false);
@@ -920,7 +889,6 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 	if (iwl_get_coex_type(mvm, vif) == BT_COEX_LOOSE_LUT ||
 	    mvm->cfg->bt_shared_single_ant || !vif->bss_conf.assoc ||
 	    !data->notif->bt_status) {
-		data->reduced_tx_power = false;
 		iwl_mvm_bt_coex_reduced_txp(mvm, mvmvif->ap_sta_id, false);
 		iwl_mvm_bt_coex_enable_rssi_event(mvm, vif, false, 0);
 		return;
@@ -935,23 +903,9 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 	if (ave_rssi > -IWL_MVM_BT_COEX_EN_RED_TXP_THRESH) {
 		if (iwl_mvm_bt_coex_reduced_txp(mvm, mvmvif->ap_sta_id, true))
 			IWL_ERR(mvm, "Couldn't send BT_CONFIG cmd\n");
-
-		/*
-		 * bt_kill_msk can be BT_KILL_MSK_REDUCED_TXPOW only if all the
-		 * BSS / P2P clients have rssi above threshold.
-		 * We set the bt_kill_msk to BT_KILL_MSK_REDUCED_TXPOW before
-		 * the iteration, if one interface's rssi isn't good enough,
-		 * bt_kill_msk will be set to default values.
-		 */
 	} else if (ave_rssi < -IWL_MVM_BT_COEX_DIS_RED_TXP_THRESH) {
 		if (iwl_mvm_bt_coex_reduced_txp(mvm, mvmvif->ap_sta_id, false))
 			IWL_ERR(mvm, "Couldn't send BT_CONFIG cmd\n");
-
-		/*
-		 * One interface hasn't rssi above threshold, bt_kill_msk must
-		 * be set to default values.
-		 */
-		data->reduced_tx_power = false;
 	}
 
 	/* Begin to monitor the RSSI: it may influence the reduced Tx power */
@@ -963,7 +917,6 @@ static void iwl_mvm_bt_coex_notif_handle(struct iwl_mvm *mvm)
 	struct iwl_bt_iterator_data data = {
 		.mvm = mvm,
 		.notif = &mvm->last_bt_notif_old,
-		.reduced_tx_power = true,
 	};
 	struct iwl_bt_coex_ci_cmd_old cmd = {};
 	u8 ci_bw_idx;
@@ -1037,14 +990,7 @@ static void iwl_mvm_bt_coex_notif_handle(struct iwl_mvm *mvm)
 		memcpy(&mvm->last_bt_ci_cmd_old, &cmd, sizeof(cmd));
 	}
 
-	/*
-	 * If there are no BSS / P2P client interfaces, reduced Tx Power is
-	 * irrelevant since it is based on the RSSI coming from the beacon.
-	 * Use BT_KILL_MSK_DEFAULT in that case.
-	 */
-	data.reduced_tx_power = data.reduced_tx_power && data.num_bss_ifaces;
-
-	if (iwl_mvm_bt_udpate_ctrl_kill_msk(mvm, data.reduced_tx_power))
+	if (iwl_mvm_bt_udpate_ctrl_kill_msk(mvm))
 		IWL_ERR(mvm, "Failed to update the ctrl_kill_msk\n");
 }
 
@@ -1115,16 +1061,6 @@ static void iwl_mvm_bt_rssi_iterator(void *_data, u8 *mac,
 		return;
 
 	mvmsta = iwl_mvm_sta_from_mac80211(sta);
-
-	data->num_bss_ifaces++;
-
-	/*
-	 * This interface doesn't support reduced Tx power (because of low
-	 * RSSI probably), then set bt_kill_msk to default values.
-	 */
-	if (!mvmsta->bt_reduced_txpower)
-		data->reduced_tx_power = false;
-	/* else - possibly leave it to BT_KILL_MSK_REDUCED_TXPOW */
 }
 
 void iwl_mvm_bt_rssi_event_old(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
@@ -1133,7 +1069,6 @@ void iwl_mvm_bt_rssi_event_old(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	struct iwl_mvm_vif *mvmvif = (void *)vif->drv_priv;
 	struct iwl_bt_iterator_data data = {
 		.mvm = mvm,
-		.reduced_tx_power = true,
 	};
 	int ret;
 
@@ -1175,14 +1110,7 @@ void iwl_mvm_bt_rssi_event_old(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
 		iwl_mvm_bt_rssi_iterator, &data);
 
-	/*
-	 * If there are no BSS / P2P client interfaces, reduced Tx Power is
-	 * irrelevant since it is based on the RSSI coming from the beacon.
-	 * Use BT_KILL_MSK_DEFAULT in that case.
-	 */
-	data.reduced_tx_power = data.reduced_tx_power && data.num_bss_ifaces;
-
-	if (iwl_mvm_bt_udpate_ctrl_kill_msk(mvm, data.reduced_tx_power))
+	if (iwl_mvm_bt_udpate_ctrl_kill_msk(mvm))
 		IWL_ERR(mvm, "Failed to update the ctrl_kill_msk\n");
 }
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index ac9787c0..b268259 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -514,9 +514,9 @@ static ssize_t iwl_dbgfs_bt_cmd_read(struct file *file, char __user *user_buf,
 
 		pos += scnprintf(buf+pos, bufsz-pos, "BT Configuration CMD\n");
 		pos += scnprintf(buf+pos, bufsz-pos, "\tACK Kill Mask 0x%08x\n",
-				 iwl_bt_ack_kill_msk[mvm->bt_kill_msk]);
+				 iwl_bt_ctl_kill_msk[mvm->bt_ack_kill_msk[0]]);
 		pos += scnprintf(buf+pos, bufsz-pos, "\tCTS Kill Mask 0x%08x\n",
-				 iwl_bt_cts_kill_msk[mvm->bt_kill_msk]);
+				 iwl_bt_ctl_kill_msk[mvm->bt_cts_kill_msk[0]]);
 
 	} else {
 		struct iwl_bt_coex_ci_cmd *cmd = &mvm->last_bt_ci_cmd;
@@ -531,10 +531,19 @@ static ssize_t iwl_dbgfs_bt_cmd_read(struct file *file, char __user *user_buf,
 			       le64_to_cpu(cmd->bt_secondary_ci));
 
 		pos += scnprintf(buf+pos, bufsz-pos, "BT Configuration CMD\n");
-		pos += scnprintf(buf+pos, bufsz-pos, "\tACK Kill Mask 0x%08x\n",
-				 iwl_bt_ack_kill_msk[mvm->bt_kill_msk]);
-		pos += scnprintf(buf+pos, bufsz-pos, "\tCTS Kill Mask 0x%08x\n",
-				 iwl_bt_cts_kill_msk[mvm->bt_kill_msk]);
+		pos += scnprintf(buf+pos, bufsz-pos,
+				 "\tPrimary: ACK Kill Mask 0x%08x\n",
+				 iwl_bt_ctl_kill_msk[mvm->bt_ack_kill_msk[0]]);
+		pos += scnprintf(buf+pos, bufsz-pos,
+				 "\tPrimary: CTS Kill Mask 0x%08x\n",
+				 iwl_bt_ctl_kill_msk[mvm->bt_cts_kill_msk[0]]);
+		pos += scnprintf(buf+pos, bufsz-pos,
+				 "\tSecondary: ACK Kill Mask 0x%08x\n",
+				 iwl_bt_ctl_kill_msk[mvm->bt_ack_kill_msk[1]]);
+		pos += scnprintf(buf+pos, bufsz-pos,
+				 "\tSecondary: CTS Kill Mask 0x%08x\n",
+				 iwl_bt_ctl_kill_msk[mvm->bt_cts_kill_msk[1]]);
+
 	}
 
 	mutex_unlock(&mvm->mutex);
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h
index ab12aaa..6987571 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h
@@ -385,6 +385,8 @@ enum iwl_bt_activity_grading {
 	BT_ON_NO_CONNECTION	= 1,
 	BT_LOW_TRAFFIC		= 2,
 	BT_HIGH_TRAFFIC		= 3,
+
+	BT_MAX_AG,
 }; /* BT_COEX_BT_ACTIVITY_GRADING_API_E_VER_1 */
 
 enum iwl_bt_ci_compliance {
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 2cead5d..5b17fdf 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -660,7 +660,8 @@ struct iwl_mvm {
 	wait_queue_head_t d0i3_exit_waitq;
 
 	/* BT-Coex */
-	u8 bt_kill_msk;
+	u8 bt_ack_kill_msk[NUM_PHY_CTX];
+	u8 bt_cts_kill_msk[NUM_PHY_CTX];
 
 	struct iwl_bt_coex_profile_notif_old last_bt_notif_old;
 	struct iwl_bt_coex_ci_cmd_old last_bt_ci_cmd_old;
@@ -1047,12 +1048,14 @@ int iwl_mvm_rx_ant_coupling_notif_old(struct iwl_mvm *mvm,
 
 enum iwl_bt_kill_msk {
 	BT_KILL_MSK_DEFAULT,
-	BT_KILL_MSK_SCO_HID_A2DP,
-	BT_KILL_MSK_REDUCED_TXPOW,
+	BT_KILL_MSK_NEVER,
+	BT_KILL_MSK_ALWAYS,
 	BT_KILL_MSK_MAX,
 };
-extern const u32 iwl_bt_ack_kill_msk[BT_KILL_MSK_MAX];
-extern const u32 iwl_bt_cts_kill_msk[BT_KILL_MSK_MAX];
+
+extern const u8 iwl_bt_ack_kill_msk[BT_MAX_AG][BT_COEX_MAX_LUT];
+extern const u8 iwl_bt_cts_kill_msk[BT_MAX_AG][BT_COEX_MAX_LUT];
+extern const u32 iwl_bt_ctl_kill_msk[BT_KILL_MSK_MAX];
 
 /* beacon filtering */
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-- 
1.8.3.2

