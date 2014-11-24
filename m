Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:42112 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105AbaKXOfN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:13 -0500
Received: by mail-wi0-f173.google.com with SMTP id r20so5860906wiv.6
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:35:11 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/75] iwlwifi: mvm: rs - don't use the shared antenna when BT load is high
Date: Mon, 24 Nov 2014 16:33:46 +0200
Message-Id: <1416839691-28533-10-git-send-email-egrumbach@gmail.com> (sfid-20141124_154441_142599_47274279)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When we need only one antenna, we should refrain from using
the antenna that is shared with BT if BT load is high.
Fix this.

Reviewed-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c        | 16 ++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c |  6 ++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h         |  2 ++
 drivers/net/wireless/iwlwifi/mvm/rs.c          | 16 ++++++++++++++++
 4 files changed, 40 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index 508c813..a3bfda4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -1137,6 +1137,22 @@ bool iwl_mvm_bt_coex_is_mimo_allowed(struct iwl_mvm *mvm,
 	return lut_type != BT_COEX_LOOSE_LUT;
 }
 
+bool iwl_mvm_bt_coex_is_ant_avail(struct iwl_mvm *mvm, u8 ant)
+{
+	/* there is no other antenna, shared antenna is always available */
+	if (mvm->cfg->bt_shared_single_ant)
+		return true;
+
+	if (ant & mvm->cfg->non_shared_ant)
+		return true;
+
+	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_BT_COEX_SPLIT))
+		return iwl_mvm_bt_coex_is_shared_ant_avail_old(mvm);
+
+	return le32_to_cpu(mvm->last_bt_notif.bt_activity_grading) <
+		BT_HIGH_TRAFFIC;
+}
+
 bool iwl_mvm_bt_coex_is_shared_ant_avail(struct iwl_mvm *mvm)
 {
 	/* there is no other antenna, shared antenna is always available */
diff --git a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
index b571e1b..cda5111 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
@@ -1156,6 +1156,12 @@ bool iwl_mvm_bt_coex_is_mimo_allowed_old(struct iwl_mvm *mvm,
 	return lut_type != BT_COEX_LOOSE_LUT;
 }
 
+bool iwl_mvm_bt_coex_is_ant_avail_old(struct iwl_mvm *mvm, u8 ant)
+{
+	u32 ag = le32_to_cpu(mvm->last_bt_notif_old.bt_activity_grading);
+	return ag < BT_HIGH_TRAFFIC;
+}
+
 bool iwl_mvm_bt_coex_is_shared_ant_avail_old(struct iwl_mvm *mvm)
 {
 	u32 ag = le32_to_cpu(mvm->last_bt_notif_old.bt_activity_grading);
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index c89ac95..105a76b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1086,12 +1086,14 @@ u16 iwl_mvm_coex_agg_time_limit(struct iwl_mvm *mvm,
 				struct ieee80211_sta *sta);
 bool iwl_mvm_bt_coex_is_mimo_allowed(struct iwl_mvm *mvm,
 				     struct ieee80211_sta *sta);
+bool iwl_mvm_bt_coex_is_ant_avail(struct iwl_mvm *mvm, u8 ant);
 bool iwl_mvm_bt_coex_is_shared_ant_avail(struct iwl_mvm *mvm);
 bool iwl_mvm_bt_coex_is_tpc_allowed(struct iwl_mvm *mvm,
 				    enum ieee80211_band band);
 u8 iwl_mvm_bt_coex_tx_prio(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
 			   struct ieee80211_tx_info *info, u8 ac);
 
+bool iwl_mvm_bt_coex_is_ant_avail_old(struct iwl_mvm *mvm, u8 ant);
 bool iwl_mvm_bt_coex_is_shared_ant_avail_old(struct iwl_mvm *mvm);
 void iwl_mvm_bt_coex_vif_change_old(struct iwl_mvm *mvm);
 int iwl_send_bt_init_conf_old(struct iwl_mvm *mvm);
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index bbd2f9b..c05f5a5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -158,6 +158,12 @@ struct rs_tx_column {
 	allow_column_func_t checks[MAX_COLUMN_CHECKS];
 };
 
+static bool rs_ant_allow(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
+			 struct iwl_scale_tbl_info *tbl)
+{
+	return iwl_mvm_bt_coex_is_ant_avail(mvm, tbl->rate.ant);
+}
+
 static bool rs_mimo_allow(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 			  struct iwl_scale_tbl_info *tbl)
 {
@@ -218,6 +224,9 @@ static const struct rs_tx_column rs_tx_columns[] = {
 			RS_COLUMN_INVALID,
 			RS_COLUMN_INVALID,
 		},
+		.checks = {
+			rs_ant_allow,
+		},
 	},
 	[RS_COLUMN_LEGACY_ANT_B] = {
 		.mode = RS_LEGACY,
@@ -231,6 +240,9 @@ static const struct rs_tx_column rs_tx_columns[] = {
 			RS_COLUMN_INVALID,
 			RS_COLUMN_INVALID,
 		},
+		.checks = {
+			rs_ant_allow,
+		},
 	},
 	[RS_COLUMN_SISO_ANT_A] = {
 		.mode = RS_SISO,
@@ -246,6 +258,7 @@ static const struct rs_tx_column rs_tx_columns[] = {
 		},
 		.checks = {
 			rs_siso_allow,
+			rs_ant_allow,
 		},
 	},
 	[RS_COLUMN_SISO_ANT_B] = {
@@ -262,6 +275,7 @@ static const struct rs_tx_column rs_tx_columns[] = {
 		},
 		.checks = {
 			rs_siso_allow,
+			rs_ant_allow,
 		},
 	},
 	[RS_COLUMN_SISO_ANT_A_SGI] = {
@@ -279,6 +293,7 @@ static const struct rs_tx_column rs_tx_columns[] = {
 		},
 		.checks = {
 			rs_siso_allow,
+			rs_ant_allow,
 			rs_sgi_allow,
 		},
 	},
@@ -297,6 +312,7 @@ static const struct rs_tx_column rs_tx_columns[] = {
 		},
 		.checks = {
 			rs_siso_allow,
+			rs_ant_allow,
 			rs_sgi_allow,
 		},
 	},
-- 
1.9.1

