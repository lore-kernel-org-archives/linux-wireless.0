Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:49443 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbaEGTyH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 15:54:07 -0400
Received: by mail-wg0-f49.google.com with SMTP id m15so1540542wgh.32
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 12:54:06 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 21/23] iwlwifi: mvm: implement mac80211's flush callback
Date: Wed,  7 May 2014 22:52:58 +0300
Message-Id: <1399492380-12050-21-git-send-email-egrumbach@gmail.com> (sfid-20140507_215435_204387_D89B8712)
In-Reply-To: <536A8EE3.2050906@gmail.com>
References: <536A8EE3.2050906@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This allows mac80211 to flush the Tx queues before it sends
critical management frames.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 3462624..6713b87 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2400,6 +2400,34 @@ out_unlock:
 	mutex_unlock(&mvm->mutex);
 }
 
+static void iwl_mvm_mac_flush(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif, u32 queues, bool drop)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	struct iwl_mvm_vif *mvmvif;
+	struct iwl_mvm_sta *mvmsta;
+
+	if (!vif || vif->type != NL80211_IFTYPE_STATION)
+		return;
+
+	mutex_lock(&mvm->mutex);
+	mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	mvmsta = iwl_mvm_sta_from_staid_protected(mvm, mvmvif->ap_sta_id);
+
+	if (WARN_ON_ONCE(!mvmsta))
+		goto done;
+
+	if (drop) {
+		if (iwl_mvm_flush_tx_path(mvm, mvmsta->tfd_queue_msk, true))
+			IWL_ERR(mvm, "flush request fail\n");
+	} else {
+		iwl_trans_wait_tx_queue_empty(mvm->trans,
+					      mvmsta->tfd_queue_msk);
+	}
+done:
+	mutex_unlock(&mvm->mutex);
+}
+
 const struct ieee80211_ops iwl_mvm_hw_ops = {
 	.tx = iwl_mvm_mac_tx,
 	.ampdu_action = iwl_mvm_mac_ampdu_action,
@@ -2423,6 +2451,7 @@ const struct ieee80211_ops iwl_mvm_hw_ops = {
 	.sta_rc_update = iwl_mvm_sta_rc_update,
 	.conf_tx = iwl_mvm_mac_conf_tx,
 	.mgd_prepare_tx = iwl_mvm_mac_mgd_prepare_tx,
+	.flush = iwl_mvm_mac_flush,
 	.sched_scan_start = iwl_mvm_mac_sched_scan_start,
 	.sched_scan_stop = iwl_mvm_mac_sched_scan_stop,
 	.set_key = iwl_mvm_mac_set_key,
-- 
1.8.3.2

