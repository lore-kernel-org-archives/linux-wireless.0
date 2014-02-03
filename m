Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:53650 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbaBCU6p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:58:45 -0500
Received: by mail-ee0-f44.google.com with SMTP id c13so3936586eek.3
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:58:45 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 20/62] iwlwifi: mvm: BT Coex - set low latency vif as primary
Date: Mon,  3 Feb 2014 22:57:26 +0200
Message-Id: <1391461088-8082-20-git-send-email-egrumbach@gmail.com> (sfid-20140203_220010_079529_6D6A7CDC)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

If a vif is in low latency mode, it should be in primary
channel.
Also tell BT Coex about the change when a vif enters or
exits low latency mode.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c |   29 +++++++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/mvm/utils.c   |    3 +++
 2 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
index b1a572e..d38c4ae 100644
--- a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
@@ -542,6 +542,7 @@ struct iwl_bt_iterator_data {
 	bool reduced_tx_power;
 	struct ieee80211_chanctx_conf *primary;
 	struct ieee80211_chanctx_conf *secondary;
+	bool primary_ll;
 };
 
 static inline
@@ -590,7 +591,14 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 		return;
 	}
 
-	/* SoftAP / GO will always be primary */
+	/* low latency is always primary */
+	if (iwl_mvm_vif_low_latency(mvmvif)) {
+		data->primary_ll = true;
+
+		data->secondary = data->primary;
+		data->primary = chanctx_conf;
+	}
+
 	if (vif->type == NL80211_IFTYPE_AP) {
 		if (!mvmvif->ap_ibss_active)
 			return;
@@ -601,9 +609,17 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 		if (chanctx_conf == data->primary)
 			return;
 
-		/* downgrade the current primary no matter what its type is */
-		data->secondary = data->primary;
-		data->primary = chanctx_conf;
+		if (!data->primary_ll) {
+			/*
+			 * downgrade the current primary no matter what its
+			 * type is.
+			 */
+			data->secondary = data->primary;
+			data->primary = chanctx_conf;
+		} else {
+			/* there is low latency vif - we will be secondary */
+			data->secondary = chanctx_conf;
+		}
 		return;
 	}
 
@@ -613,7 +629,10 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 	if (!vif->bss_conf.assoc)
 		return;
 
-	/* STA / P2P Client, try to be primary if first vif */
+	/*
+	 * STA / P2P Client, try to be primary if first vif. If we are in low
+	 * latency mode, we are already in primary and just don't do much
+	 */
 	if (!data->primary || data->primary == chanctx_conf)
 		data->primary = chanctx_conf;
 	else if (!data->secondary)
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index 790da1b..c7ee2f3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -550,5 +550,8 @@ int iwl_mvm_update_low_latency(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	res = iwl_mvm_update_quotas(mvm, NULL);
 	if (res)
 		return res;
+
+	iwl_mvm_bt_coex_vif_change(mvm);
+
 	return iwl_mvm_power_update_mode(mvm, vif);
 }
-- 
1.7.9.5

