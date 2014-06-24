Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:59835 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272AbaFXTw6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 15:52:58 -0400
Received: by mail-we0-f170.google.com with SMTP id w61so892859wes.15
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 12:52:56 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 20/27] iwlwifi: mvm: BT Coex - don't limit rate control if TTC is on
Date: Tue, 24 Jun 2014 22:52:14 +0300
Message-Id: <1403639541-4621-20-git-send-email-egrumbach@gmail.com> (sfid-20140624_215952_477116_27979EEF)
In-Reply-To: <53A9D6CF.9040100@gmail.com>
References: <53A9D6CF.9040100@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When the firmware enables TxTxCorunning, we can lift the
constaints on the rate control.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c        | 6 ++++++
 drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h | 4 +++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index aab92a6..8d7146e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -1212,6 +1212,9 @@ u16 iwl_mvm_coex_agg_time_limit(struct iwl_mvm *mvm,
 	    BT_HIGH_TRAFFIC)
 		return LINK_QUAL_AGG_TIME_LIMIT_DEF;
 
+	if (mvm->last_bt_notif.ttc_enabled)
+		return LINK_QUAL_AGG_TIME_LIMIT_DEF;
+
 	lut_type = iwl_get_coex_type(mvm, mvmsta->vif);
 
 	if (lut_type == BT_COEX_LOOSE_LUT || lut_type == BT_COEX_INVALID_LUT)
@@ -1227,6 +1230,9 @@ bool iwl_mvm_bt_coex_is_mimo_allowed(struct iwl_mvm *mvm,
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	enum iwl_bt_coex_lut_type lut_type;
 
+	if (mvm->last_bt_notif.ttc_enabled)
+		return true;
+
 	if (le32_to_cpu(mvm->last_bt_notif.bt_activity_grading) <
 	    BT_HIGH_TRAFFIC)
 		return true;
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h
index 98175ca..39cb33a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h
@@ -305,6 +305,7 @@ enum iwl_bt_activity_grading {
  * @bt_traffic_load: load of BT traffic
  * @bt_agg_traffic_load: aggregated load of BT traffic
  * @bt_ci_compliance: 0 - no CI compliance, 1 - CI compliant
+ * @ttc_enabled: true if ttc has been enabled by the firmware
  * @primary_ch_lut: LUT used for primary channel
  * @secondary_ch_lut: LUT used for secondary channel
  * @bt_activity_grading: the activity of BT enum %iwl_bt_activity_grading
@@ -317,7 +318,8 @@ struct iwl_bt_coex_profile_notif {
 	u8 bt_traffic_load;
 	u8 bt_agg_traffic_load;
 	u8 bt_ci_compliance;
-	u8 reserved[3];
+	u8 ttc_enabled;
+	__le16 reserved;
 
 	__le32 primary_ch_lut;
 	__le32 secondary_ch_lut;
-- 
1.8.3.2

