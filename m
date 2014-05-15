Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:52659 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbaEORFD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 13:05:03 -0400
Received: by mail-we0-f170.google.com with SMTP id u57so1397976wes.15
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 10:05:01 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/24] iwlwifi: mvm: notify sched scan complete from stop routine
Date: Thu, 15 May 2014 20:04:23 +0300
Message-Id: <1400173481-9047-6-git-send-email-egrumbach@gmail.com> (sfid-20140515_190620_427288_D46BA40B)
In-Reply-To: <5374F373.6040902@gmail.com>
References: <5374F373.6040902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Add an option to notify mac80211 about sched scan complete from
iwl_mvm_stop_sched_scan(), to enable this notification when the
stop was called from within the driver.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Reviewed-by: Alexander Bondar <alexander.bondar@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 4 ++--
 drivers/net/wireless/iwlwifi/mvm/mvm.h      | 2 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c     | 5 ++++-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 18d77e4..66fa21b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1542,7 +1542,7 @@ static int iwl_mvm_mac_hw_scan(struct ieee80211_hw *hw,
 
 	switch (mvm->scan_status) {
 	case IWL_MVM_SCAN_SCHED:
-		ret = iwl_mvm_sched_scan_stop(mvm);
+		ret = iwl_mvm_sched_scan_stop(mvm, true);
 		if (ret) {
 			ret = -EBUSY;
 			goto out;
@@ -1882,7 +1882,7 @@ static int iwl_mvm_mac_sched_scan_stop(struct ieee80211_hw *hw,
 	int ret;
 
 	mutex_lock(&mvm->mutex);
-	ret = iwl_mvm_sched_scan_stop(mvm);
+	ret = iwl_mvm_sched_scan_stop(mvm, false);
 	mutex_unlock(&mvm->mutex);
 	iwl_mvm_wait_for_async_handlers(mvm);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index a4909f3..78f3328 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -857,7 +857,7 @@ int iwl_mvm_config_sched_scan_profiles(struct iwl_mvm *mvm,
 				       struct cfg80211_sched_scan_request *req);
 int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 			     struct cfg80211_sched_scan_request *req);
-int iwl_mvm_sched_scan_stop(struct iwl_mvm *mvm);
+int iwl_mvm_sched_scan_stop(struct iwl_mvm *mvm, bool notify);
 int iwl_mvm_rx_sched_scan_results(struct iwl_mvm *mvm,
 				  struct iwl_rx_cmd_buffer *rxb,
 				  struct iwl_device_cmd *cmd);
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 3e25af4..a7f6ae3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -936,7 +936,7 @@ static int iwl_mvm_send_sched_scan_abort(struct iwl_mvm *mvm)
 	return ret;
 }
 
-int iwl_mvm_sched_scan_stop(struct iwl_mvm *mvm)
+int iwl_mvm_sched_scan_stop(struct iwl_mvm *mvm, bool notify)
 {
 	int ret;
 	struct iwl_notification_wait wait_scan_done;
@@ -974,5 +974,8 @@ int iwl_mvm_sched_scan_stop(struct iwl_mvm *mvm)
 	 */
 	mvm->scan_status = IWL_MVM_SCAN_NONE;
 
+	if (notify)
+		ieee80211_sched_scan_stopped(mvm->hw);
+
 	return 0;
 }
-- 
1.8.3.2

