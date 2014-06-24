Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:65328 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192AbaFXTxA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 15:53:00 -0400
Received: by mail-wi0-f174.google.com with SMTP id bs8so6626529wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 12:52:59 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 22/27] iwlwifi: mvm: BT Coex - avoid the shared antenna for management frames
Date: Tue, 24 Jun 2014 22:52:16 +0300
Message-Id: <1403639541-4621-22-git-send-email-egrumbach@gmail.com> (sfid-20140624_220201_185964_7AF86ADB)
In-Reply-To: <53A9D6CF.9040100@gmail.com>
References: <53A9D6CF.9040100@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

If BT is active, we need to refrain from using the shared
antenna. This logic is done in the firmware when we use the
link quality tables. But for management frames, the rate is
written in the Tx command by the driver.
Hence the driver needs to make sure not use the shared
antenna when BT is active for any frames that don't use
the rate scale table such as management frames or multicast.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c | 5 +++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h  | 1 +
 drivers/net/wireless/iwlwifi/mvm/tx.c   | 8 +++++++-
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index cae44ed..7e0388a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -1246,6 +1246,11 @@ bool iwl_mvm_bt_coex_is_mimo_allowed(struct iwl_mvm *mvm,
 	return lut_type != BT_COEX_LOOSE_LUT;
 }
 
+bool iwl_mvm_bt_coex_is_shared_ant_avail(struct iwl_mvm *mvm)
+{
+	return le32_to_cpu(mvm->last_bt_notif.bt_activity_grading) == BT_OFF;
+}
+
 bool iwl_mvm_bt_coex_is_tpc_allowed(struct iwl_mvm *mvm,
 				    enum ieee80211_band band)
 {
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 472ef09..8419840 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -973,6 +973,7 @@ u16 iwl_mvm_coex_agg_time_limit(struct iwl_mvm *mvm,
 				struct ieee80211_sta *sta);
 bool iwl_mvm_bt_coex_is_mimo_allowed(struct iwl_mvm *mvm,
 				     struct ieee80211_sta *sta);
+bool iwl_mvm_bt_coex_is_shared_ant_avail(struct iwl_mvm *mvm);
 bool iwl_mvm_bt_coex_is_tpc_allowed(struct iwl_mvm *mvm,
 				    enum ieee80211_band band);
 u8 iwl_mvm_bt_coex_tx_prio(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 3846a6c..4f7cff5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -205,7 +205,13 @@ static void iwl_mvm_set_tx_cmd_rate(struct iwl_mvm *mvm,
 	mvm->mgmt_last_antenna_idx =
 		iwl_mvm_next_antenna(mvm, mvm->fw->valid_tx_ant,
 				     mvm->mgmt_last_antenna_idx);
-	rate_flags = BIT(mvm->mgmt_last_antenna_idx) << RATE_MCS_ANT_POS;
+
+	if (info->band == IEEE80211_BAND_2GHZ &&
+	    !iwl_mvm_bt_coex_is_shared_ant_avail(mvm))
+		rate_flags = BIT(ANT_A) << RATE_MCS_ANT_POS;
+	else
+		rate_flags =
+			BIT(mvm->mgmt_last_antenna_idx) << RATE_MCS_ANT_POS;
 
 	/* Set CCK flag as needed */
 	if ((rate_idx >= IWL_FIRST_CCK_RATE) && (rate_idx <= IWL_LAST_CCK_RATE))
-- 
1.8.3.2

