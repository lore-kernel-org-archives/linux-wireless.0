Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:34654 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041AbaCROqF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 10:46:05 -0400
Received: by mail-ee0-f41.google.com with SMTP id t10so5505187eei.0
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 07:46:03 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/35] iwlwifi: mvm: abort scan on sched_scan request
Date: Tue, 18 Mar 2014 16:45:16 +0200
Message-Id: <1395153939-23897-12-git-send-email-egrumbach@gmail.com> (sfid-20140318_154825_564527_6F397663)
In-Reply-To: <53285AF8.7050305@gmail.com>
References: <53285AF8.7050305@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

A scheduled scan is a more persistent setting and should take priority
over temporary regular scans. Abort the regular when a sched_scan
request arrives and then request the sched_scan.

The kernel API allows sending a sched_scan without canceling a regular
scan in progress, so this is our way to abstract the FW's limitations.

Make the scan-cancel Rx handler async and flush after invocation to
ensure new scans can't creep in before it.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 25 ++++++++++++++++++++++---
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  2 +-
 drivers/net/wireless/iwlwifi/mvm/ops.c      |  2 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c     | 18 +++++++++---------
 4 files changed, 33 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index fff66ab..a6df00d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1708,9 +1708,26 @@ static int iwl_mvm_mac_sched_scan_start(struct ieee80211_hw *hw,
 
 	mutex_lock(&mvm->mutex);
 
-	if (mvm->scan_status != IWL_MVM_SCAN_NONE) {
-		IWL_DEBUG_SCAN(mvm,
-			       "SCHED SCAN request during internal scan - abort\n");
+	switch (mvm->scan_status) {
+	case IWL_MVM_SCAN_OS:
+		IWL_DEBUG_SCAN(mvm, "Stopping previous scan for sched_scan\n");
+		ret = iwl_mvm_cancel_scan(mvm);
+		if (ret) {
+			ret = -EBUSY;
+			goto out;
+		}
+
+		/*
+		 * iwl_mvm_rx_scan_complete() will be called soon but will
+		 * not reset the scan status as it won't be IWL_MVM_SCAN_OS
+		 * any more since we queue the next scan immediately (below).
+		 * We make sure it is called before the next scan starts by
+		 * flushing the async-handlers work.
+		 */
+		break;
+	case IWL_MVM_SCAN_NONE:
+		break;
+	default:
 		ret = -EBUSY;
 		goto out;
 	}
@@ -1732,6 +1749,8 @@ err:
 	mvm->scan_status = IWL_MVM_SCAN_NONE;
 out:
 	mutex_unlock(&mvm->mutex);
+	/* make sure to flush the Rx handler before the next scan arrives */
+	iwl_mvm_wait_for_async_handlers(mvm);
 	return ret;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 4da53c3..e5c1db9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -804,7 +804,7 @@ int iwl_mvm_rx_scan_response(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 			     struct iwl_device_cmd *cmd);
 int iwl_mvm_rx_scan_complete(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 			     struct iwl_device_cmd *cmd);
-void iwl_mvm_cancel_scan(struct iwl_mvm *mvm);
+int iwl_mvm_cancel_scan(struct iwl_mvm *mvm);
 
 /* Scheduled scan */
 int iwl_mvm_rx_scan_offload_complete_notif(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 05f6355..39279e1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -226,7 +226,7 @@ static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
 	RX_HANDLER(EOSP_NOTIFICATION, iwl_mvm_rx_eosp_notif, false),
 
 	RX_HANDLER(SCAN_REQUEST_CMD, iwl_mvm_rx_scan_response, false),
-	RX_HANDLER(SCAN_COMPLETE_NOTIFICATION, iwl_mvm_rx_scan_complete, false),
+	RX_HANDLER(SCAN_COMPLETE_NOTIFICATION, iwl_mvm_rx_scan_complete, true),
 	RX_HANDLER(SCAN_OFFLOAD_COMPLETE,
 		   iwl_mvm_rx_scan_offload_complete_notif, true),
 	RX_HANDLER(MATCH_FOUND_NOTIFICATION, iwl_mvm_rx_sched_scan_results,
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index a2cd54b..945398b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -402,10 +402,13 @@ int iwl_mvm_rx_scan_complete(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_scan_complete_notif *notif = (void *)pkt->data;
 
+	lockdep_assert_held(&mvm->mutex);
+
 	IWL_DEBUG_SCAN(mvm, "Scan complete: status=0x%x scanned channels=%d\n",
 		       notif->status, notif->scanned_channels);
 
-	mvm->scan_status = IWL_MVM_SCAN_NONE;
+	if (mvm->scan_status == IWL_MVM_SCAN_OS)
+		mvm->scan_status = IWL_MVM_SCAN_NONE;
 	ieee80211_scan_completed(mvm->hw, notif->status != SCAN_COMP_STATUS_OK);
 
 	iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
@@ -466,7 +469,7 @@ static bool iwl_mvm_scan_abort_notif(struct iwl_notif_wait_data *notif_wait,
 	};
 }
 
-void iwl_mvm_cancel_scan(struct iwl_mvm *mvm)
+int iwl_mvm_cancel_scan(struct iwl_mvm *mvm)
 {
 	struct iwl_notification_wait wait_scan_abort;
 	static const u8 scan_abort_notif[] = { SCAN_ABORT_CMD,
@@ -474,13 +477,13 @@ void iwl_mvm_cancel_scan(struct iwl_mvm *mvm)
 	int ret;
 
 	if (mvm->scan_status == IWL_MVM_SCAN_NONE)
-		return;
+		return 0;
 
 	if (iwl_mvm_is_radio_killed(mvm)) {
 		ieee80211_scan_completed(mvm->hw, true);
 		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
 		mvm->scan_status = IWL_MVM_SCAN_NONE;
-		return;
+		return 0;
 	}
 
 	iwl_init_notification_wait(&mvm->notif_wait, &wait_scan_abort,
@@ -495,14 +498,11 @@ void iwl_mvm_cancel_scan(struct iwl_mvm *mvm)
 		goto out_remove_notif;
 	}
 
-	ret = iwl_wait_notification(&mvm->notif_wait, &wait_scan_abort, 1 * HZ);
-	if (ret)
-		IWL_ERR(mvm, "%s - failed on timeout\n", __func__);
-
-	return;
+	return iwl_wait_notification(&mvm->notif_wait, &wait_scan_abort, HZ);
 
 out_remove_notif:
 	iwl_remove_notification(&mvm->notif_wait, &wait_scan_abort);
+	return ret;
 }
 
 int iwl_mvm_rx_scan_offload_complete_notif(struct iwl_mvm *mvm,
-- 
1.8.3.2

