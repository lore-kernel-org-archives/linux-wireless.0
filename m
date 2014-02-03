Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:47659 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbaBCU7Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:59:25 -0500
Received: by mail-ea0-f178.google.com with SMTP id a15so3936091eae.23
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:59:24 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 41/62] iwlwifi: mvm: add D0i3 ref/unref for scan
Date: Mon,  3 Feb 2014 22:57:47 +0200
Message-Id: <1391461088-8082-41-git-send-email-egrumbach@gmail.com> (sfid-20140203_220007_166232_923E66C7)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Take a reference when starting to scan and release it on completion.
Note that if the scan is cancelled/aborted, a completion will still be
sent up.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |   12 +++++++++---
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |    1 +
 drivers/net/wireless/iwlwifi/mvm/scan.c     |    3 +++
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index e121685..64d9efd 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1442,11 +1442,17 @@ static int iwl_mvm_mac_hw_scan(struct ieee80211_hw *hw,
 
 	mutex_lock(&mvm->mutex);
 
-	if (mvm->scan_status == IWL_MVM_SCAN_NONE)
-		ret = iwl_mvm_scan_request(mvm, vif, req);
-	else
+	if (mvm->scan_status != IWL_MVM_SCAN_NONE) {
 		ret = -EBUSY;
+		goto out;
+	}
 
+	iwl_mvm_ref(mvm, IWL_MVM_REF_SCAN);
+
+	ret = iwl_mvm_scan_request(mvm, vif, req);
+	if (ret)
+		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
+out:
 	mutex_unlock(&mvm->mutex);
 
 	return ret;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 9ffafe8..3a3e9f1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -241,6 +241,7 @@ enum iwl_mvm_smps_type_request {
 
 enum iwl_mvm_ref_type {
 	IWL_MVM_REF_UCODE_DOWN,
+	IWL_MVM_REF_SCAN,
 
 	IWL_MVM_REF_COUNT,
 };
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 6c5c173..8477902 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -407,6 +407,8 @@ int iwl_mvm_rx_scan_complete(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 	mvm->scan_status = IWL_MVM_SCAN_NONE;
 	ieee80211_scan_completed(mvm->hw, notif->status != SCAN_COMP_STATUS_OK);
 
+	iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
+
 	return 0;
 }
 
@@ -475,6 +477,7 @@ void iwl_mvm_cancel_scan(struct iwl_mvm *mvm)
 
 	if (iwl_mvm_is_radio_killed(mvm)) {
 		ieee80211_scan_completed(mvm->hw, true);
+		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
 		mvm->scan_status = IWL_MVM_SCAN_NONE;
 		return;
 	}
-- 
1.7.9.5

