Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39344 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754610AbeDMMnG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Apr 2018 08:43:06 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 13 Apr 2018 15:42:34 +0300
Message-Id: <20180413124256.21769-4-luca@coelho.fi> (sfid-20180413_144349_114775_C5D6E2DA)
In-Reply-To: <20180413124256.21769-1-luca@coelho.fi>
References: <20180413124256.21769-1-luca@coelho.fi>
Subject: [PATCH 03/25] iwlwifi: mvm: BT Coex - make the primary / secondary pick traffic aware
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The primary channel is the channel that will be untouched by BT. The
secondary channel might be touched by BT.  Hence, we want the primary
to be the most active channel.  To do so, use the TCM infrastructure.

Since the BT keeps sending notifications, we can rely on them to
trigger the check. Every 10 seconds, we will check what is the most
active context and chose the right primary.

We need to wait 10 seconds before we modify the settings because
frequent changes in these settings can confuse BT.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c | 37 +++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/coex.c b/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
index 890dbfff3a06..016e03a5034f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
@@ -279,6 +279,8 @@ struct iwl_bt_iterator_data {
 	struct ieee80211_chanctx_conf *primary;
 	struct ieee80211_chanctx_conf *secondary;
 	bool primary_ll;
+	u8 primary_load;
+	u8 secondary_load;
 };
 
 static inline
@@ -295,6 +297,30 @@ void iwl_mvm_bt_coex_enable_rssi_event(struct iwl_mvm *mvm,
 		enable ? -IWL_MVM_BT_COEX_DIS_RED_TXP_THRESH : 0;
 }
 
+#define MVM_COEX_TCM_PERIOD (HZ * 10)
+
+static void iwl_mvm_bt_coex_tcm_based_ci(struct iwl_mvm *mvm,
+					 struct iwl_bt_iterator_data *data)
+{
+	unsigned long now = jiffies;
+
+	if (!time_after(now, mvm->bt_coex_last_tcm_ts + MVM_COEX_TCM_PERIOD))
+		return;
+
+	mvm->bt_coex_last_tcm_ts = now;
+
+	/* We assume here that we don't have more than 2 vifs on 2.4GHz */
+
+	/* if the primary is low latency, it will stay primary */
+	if (data->primary_ll)
+		return;
+
+	if (data->primary_load >= data->secondary_load)
+		return;
+
+	swap(data->primary, data->secondary);
+}
+
 /* must be called under rcu_read_lock */
 static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 				      struct ieee80211_vif *vif)
@@ -385,6 +411,11 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 			/* there is low latency vif - we will be secondary */
 			data->secondary = chanctx_conf;
 		}
+
+		if (data->primary == chanctx_conf)
+			data->primary_load = mvm->tcm.result.load[mvmvif->id];
+		else if (data->secondary == chanctx_conf)
+			data->secondary_load = mvm->tcm.result.load[mvmvif->id];
 		return;
 	}
 
@@ -398,6 +429,10 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 		/* if secondary is not NULL, it might be a GO */
 		data->secondary = chanctx_conf;
 
+	if (data->primary == chanctx_conf)
+		data->primary_load = mvm->tcm.result.load[mvmvif->id];
+	else if (data->secondary == chanctx_conf)
+		data->secondary_load = mvm->tcm.result.load[mvmvif->id];
 	/*
 	 * don't reduce the Tx power if one of these is true:
 	 *  we are in LOOSE
@@ -449,6 +484,8 @@ static void iwl_mvm_bt_coex_notif_handle(struct iwl_mvm *mvm)
 					mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
 					iwl_mvm_bt_notif_iterator, &data);
 
+	iwl_mvm_bt_coex_tcm_based_ci(mvm, &data);
+
 	if (data.primary) {
 		struct ieee80211_chanctx_conf *chan = data.primary;
 		if (WARN_ON(!chan->def.chan)) {
-- 
2.16.3
