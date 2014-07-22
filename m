Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:42024 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756430AbaGVT1g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 15:27:36 -0400
Received: by mail-wi0-f180.google.com with SMTP id n3so1023429wiv.7
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2014 12:27:35 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliadx.peller@intel.com>,
	Eliad Peller <eliad@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/20] iwlwifi: mvm: wait for handlers when stopping scans
Date: Tue, 22 Jul 2014 22:26:43 +0300
Message-Id: <1406057211-31752-12-git-send-email-egrumbach@gmail.com> (sfid-20140722_212741_369477_087C7538)
In-Reply-To: <53CEB854.9000008@gmail.com>
References: <53CEB854.9000008@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliadx.peller@intel.com>

The recent unified scan api change introduced issues
when stopping ongoing scans, since both regular and
sched scan now use same stopped notification.

When issuing a new scan right after a running one,
we get the "old" notification and handle it wrongly
as notification for the current scan.

Fix it by introducing a new function that make sure
we consume the pending notifications before issuing
a new scan.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Reviewed-by: ArikX Nemtsov <arik@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 86 +++++++++++++++++------------
 1 file changed, 51 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 5219b3a..46ff7cd 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1718,6 +1718,47 @@ static void iwl_mvm_bss_info_changed(struct ieee80211_hw *hw,
 	iwl_mvm_unref(mvm, IWL_MVM_REF_BSS_CHANGED);
 }
 
+static int iwl_mvm_cancel_scan_wait_notif(struct iwl_mvm *mvm,
+					  enum iwl_scan_status scan_type)
+{
+	int ret;
+	bool wait_for_handlers = false;
+
+	mutex_lock(&mvm->mutex);
+
+	if (mvm->scan_status != scan_type) {
+		ret = 0;
+		/* make sure there are no pending notifications */
+		wait_for_handlers = true;
+		goto out;
+	}
+
+	switch (scan_type) {
+	case IWL_MVM_SCAN_SCHED:
+		ret = iwl_mvm_scan_offload_stop(mvm, true);
+		break;
+	case IWL_MVM_SCAN_OS:
+		ret = iwl_mvm_cancel_scan(mvm);
+		break;
+	case IWL_MVM_SCAN_NONE:
+	default:
+		WARN_ON_ONCE(1);
+		ret = -EINVAL;
+		break;
+	}
+	if (ret)
+		goto out;
+
+	wait_for_handlers = true;
+out:
+	mutex_unlock(&mvm->mutex);
+
+	/* make sure we consume the completion notification */
+	if (wait_for_handlers)
+		iwl_mvm_wait_for_async_handlers(mvm);
+
+	return ret;
+}
 static int iwl_mvm_mac_hw_scan(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif,
 			       struct ieee80211_scan_request *hw_req)
@@ -1730,19 +1771,13 @@ static int iwl_mvm_mac_hw_scan(struct ieee80211_hw *hw,
 	    req->n_channels > mvm->fw->ucode_capa.n_scan_channels)
 		return -EINVAL;
 
+	ret = iwl_mvm_cancel_scan_wait_notif(mvm, IWL_MVM_SCAN_SCHED);
+	if (ret)
+		return ret;
+
 	mutex_lock(&mvm->mutex);
 
-	switch (mvm->scan_status) {
-	case IWL_MVM_SCAN_SCHED:
-		ret = iwl_mvm_scan_offload_stop(mvm, true);
-		if (ret) {
-			ret = -EBUSY;
-			goto out;
-		}
-		break;
-	case IWL_MVM_SCAN_NONE:
-		break;
-	default:
+	if (mvm->scan_status != IWL_MVM_SCAN_NONE) {
 		ret = -EBUSY;
 		goto out;
 	}
@@ -1758,8 +1793,6 @@ static int iwl_mvm_mac_hw_scan(struct ieee80211_hw *hw,
 		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
 out:
 	mutex_unlock(&mvm->mutex);
-	/* make sure to flush the Rx handler before the next scan arrives */
-	iwl_mvm_wait_for_async_handlers(mvm);
 	return ret;
 }
 
@@ -2135,6 +2168,10 @@ static int iwl_mvm_mac_sched_scan_start(struct ieee80211_hw *hw,
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	int ret;
 
+	ret = iwl_mvm_cancel_scan_wait_notif(mvm, IWL_MVM_SCAN_OS);
+	if (ret)
+		return ret;
+
 	mutex_lock(&mvm->mutex);
 
 	if (!iwl_mvm_is_idle(mvm)) {
@@ -2142,26 +2179,7 @@ static int iwl_mvm_mac_sched_scan_start(struct ieee80211_hw *hw,
 		goto out;
 	}
 
-	switch (mvm->scan_status) {
-	case IWL_MVM_SCAN_OS:
-		IWL_DEBUG_SCAN(mvm, "Stopping previous scan for sched_scan\n");
-		ret = iwl_mvm_cancel_scan(mvm);
-		if (ret) {
-			ret = -EBUSY;
-			goto out;
-		}
-
-		/*
-		 * iwl_mvm_rx_scan_complete() will be called soon but will
-		 * not reset the scan status as it won't be IWL_MVM_SCAN_OS
-		 * any more since we queue the next scan immediately (below).
-		 * We make sure it is called before the next scan starts by
-		 * flushing the async-handlers work.
-		 */
-		break;
-	case IWL_MVM_SCAN_NONE:
-		break;
-	default:
+	if (mvm->scan_status != IWL_MVM_SCAN_NONE) {
 		ret = -EBUSY;
 		goto out;
 	}
@@ -2189,8 +2207,6 @@ err:
 	mvm->scan_status = IWL_MVM_SCAN_NONE;
 out:
 	mutex_unlock(&mvm->mutex);
-	/* make sure to flush the Rx handler before the next scan arrives */
-	iwl_mvm_wait_for_async_handlers(mvm);
 	return ret;
 }
 
-- 
1.8.3.2

