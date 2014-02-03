Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:37864 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbaBCU7k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:59:40 -0500
Received: by mail-ee0-f49.google.com with SMTP id d17so3881261eek.8
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:59:38 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 51/62] iwlwifi: mvm: abort scheduled scan on scan request
Date: Mon,  3 Feb 2014 22:57:57 +0200
Message-Id: <1391461088-8082-51-git-send-email-egrumbach@gmail.com> (sfid-20140203_220009_932365_A64ED1C9)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some older versions of wpa_supplicant don't necessarily stop
scheduled scan before starting a regular scan, and there's
nothing in the API that requires it either. As a consequence
our driver's behaviour of not allowing scan while scheduled
scan was in progress broke userspace.

However, it is valid to unilaterally stop scheduled scan at
any point in time, so when a regular scan request comes just
abort the scheduled scan and run the regular scan.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |   25 ++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/mvm/ops.c      |    2 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c     |    7 ++++++-
 3 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 59b5b7a..9d9a2d0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1449,6 +1449,8 @@ static int iwl_mvm_mac_hw_scan(struct ieee80211_hw *hw,
 			       struct cfg80211_scan_request *req)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	struct iwl_notification_wait wait_scan_done;
+	static const u8 scan_done_notif[] = { SCAN_OFFLOAD_COMPLETE, };
 	int ret;
 
 	if (req->n_channels == 0 || req->n_channels > MAX_NUM_SCAN_CHANNELS)
@@ -1456,7 +1458,28 @@ static int iwl_mvm_mac_hw_scan(struct ieee80211_hw *hw,
 
 	mutex_lock(&mvm->mutex);
 
-	if (mvm->scan_status != IWL_MVM_SCAN_NONE) {
+	switch (mvm->scan_status) {
+	case IWL_MVM_SCAN_SCHED:
+		iwl_init_notification_wait(&mvm->notif_wait, &wait_scan_done,
+					   scan_done_notif,
+					   ARRAY_SIZE(scan_done_notif),
+					   NULL, NULL);
+		iwl_mvm_sched_scan_stop(mvm);
+		ret = iwl_wait_notification(&mvm->notif_wait,
+					    &wait_scan_done, HZ);
+		if (ret) {
+			ret = -EBUSY;
+			goto out;
+		}
+		/* iwl_mvm_rx_scan_offload_complete_notif() will be called
+		 * soon but will not reset the scan status as it won't be
+		 * IWL_MVM_SCAN_SCHED any more since we queue the next scan
+		 * immediately (below)
+		 */
+		break;
+	case IWL_MVM_SCAN_NONE:
+		break;
+	default:
 		ret = -EBUSY;
 		goto out;
 	}
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 4b7fa7a..e268c15 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -228,7 +228,7 @@ static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
 	RX_HANDLER(SCAN_REQUEST_CMD, iwl_mvm_rx_scan_response, false),
 	RX_HANDLER(SCAN_COMPLETE_NOTIFICATION, iwl_mvm_rx_scan_complete, false),
 	RX_HANDLER(SCAN_OFFLOAD_COMPLETE,
-		   iwl_mvm_rx_scan_offload_complete_notif, false),
+		   iwl_mvm_rx_scan_offload_complete_notif, true),
 	RX_HANDLER(MATCH_FOUND_NOTIFICATION, iwl_mvm_rx_sched_scan_results,
 		   false),
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 8477902..a827a13 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -511,11 +511,16 @@ int iwl_mvm_rx_scan_offload_complete_notif(struct iwl_mvm *mvm,
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_scan_offload_complete *scan_notif = (void *)pkt->data;
 
+	/* scan status must be locked for proper checking */
+	lockdep_assert_held(&mvm->mutex);
+
 	IWL_DEBUG_SCAN(mvm, "Scheduled scan completed, status %s\n",
 		       scan_notif->status == IWL_SCAN_OFFLOAD_COMPLETED ?
 		       "completed" : "aborted");
 
-	mvm->scan_status = IWL_MVM_SCAN_NONE;
+	/* might already be something else again, don't reset if so */
+	if (mvm->scan_status == IWL_MVM_SCAN_SCHED)
+		mvm->scan_status = IWL_MVM_SCAN_NONE;
 	ieee80211_sched_scan_stopped(mvm->hw);
 
 	return 0;
-- 
1.7.9.5

