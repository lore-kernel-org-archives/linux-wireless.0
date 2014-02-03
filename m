Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:32902 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbaBCU7Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:59:25 -0500
Received: by mail-ee0-f48.google.com with SMTP id t10so3859022eei.7
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:59:24 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 42/62] iwlwifi: mvm: add D0i3 ref/unref for ROC commands
Date: Mon,  3 Feb 2014 22:57:48 +0200
Message-Id: <1391461088-8082-42-git-send-email-egrumbach@gmail.com> (sfid-20140203_223008_304856_8B7988CA)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Take a reference when ROC command is started, and
unref it on completion.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mvm.h        |    1 +
 drivers/net/wireless/iwlwifi/mvm/time-event.c |    2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 3a3e9f1..19a90d1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -242,6 +242,7 @@ enum iwl_mvm_smps_type_request {
 enum iwl_mvm_ref_type {
 	IWL_MVM_REF_UCODE_DOWN,
 	IWL_MVM_REF_SCAN,
+	IWL_MVM_REF_ROC,
 
 	IWL_MVM_REF_COUNT,
 };
diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index b4c2aba..e145dd4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -126,6 +126,7 @@ static void iwl_mvm_roc_finished(struct iwl_mvm *mvm)
 	 * in iwl_mvm_te_handle_notif).
 	 */
 	clear_bit(IWL_MVM_STATUS_ROC_RUNNING, &mvm->status);
+	iwl_mvm_unref(mvm, IWL_MVM_REF_ROC);
 
 	/*
 	 * Of course, our status bit is just as racy as mac80211, so in
@@ -210,6 +211,7 @@ static void iwl_mvm_te_handle_notif(struct iwl_mvm *mvm,
 
 		if (te_data->vif->type == NL80211_IFTYPE_P2P_DEVICE) {
 			set_bit(IWL_MVM_STATUS_ROC_RUNNING, &mvm->status);
+			iwl_mvm_ref(mvm, IWL_MVM_REF_ROC);
 			ieee80211_ready_on_channel(mvm->hw);
 		}
 	} else {
-- 
1.7.9.5

