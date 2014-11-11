Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:58145 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaKKFif (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 00:38:35 -0500
Received: by mail-wg0-f42.google.com with SMTP id k14so10680806wgh.29
        for <linux-wireless@vger.kernel.org>; Mon, 10 Nov 2014 21:38:34 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/2] iwlwifi: mvm: abort scan upon RFKILL
Date: Tue, 11 Nov 2014 07:38:28 +0200
Message-Id: <1415684309-18816-1-git-send-email-egrumbach@gmail.com> (sfid-20141111_063838_691707_31BD36D8)
In-Reply-To: <CANUX_P2Q31DLtiZJ-GNcnME3LDXE2vWLN61QqNOxsjqxgfb4Gg@mail.gmail.com>
References: <CANUX_P2Q31DLtiZJ-GNcnME3LDXE2vWLN61QqNOxsjqxgfb4Gg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This code existed but not for all the different FW APIs
we support.
Fix this.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index b280d5d..7554f70 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -602,16 +602,6 @@ static int iwl_mvm_cancel_regular_scan(struct iwl_mvm *mvm)
 					       SCAN_COMPLETE_NOTIFICATION };
 	int ret;
 
-	if (mvm->scan_status == IWL_MVM_SCAN_NONE)
-		return 0;
-
-	if (iwl_mvm_is_radio_killed(mvm)) {
-		ieee80211_scan_completed(mvm->hw, true);
-		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
-		mvm->scan_status = IWL_MVM_SCAN_NONE;
-		return 0;
-	}
-
 	iwl_init_notification_wait(&mvm->notif_wait, &wait_scan_abort,
 				   scan_abort_notif,
 				   ARRAY_SIZE(scan_abort_notif),
@@ -1400,6 +1390,16 @@ int iwl_mvm_unified_sched_scan_lmac(struct iwl_mvm *mvm,
 
 int iwl_mvm_cancel_scan(struct iwl_mvm *mvm)
 {
+	if (mvm->scan_status == IWL_MVM_SCAN_NONE)
+		return 0;
+
+	if (iwl_mvm_is_radio_killed(mvm)) {
+		ieee80211_scan_completed(mvm->hw, true);
+		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
+		mvm->scan_status = IWL_MVM_SCAN_NONE;
+		return 0;
+	}
+
 	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN)
 		return iwl_mvm_scan_offload_stop(mvm, true);
 	return iwl_mvm_cancel_regular_scan(mvm);
-- 
1.9.1

