Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41919 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932784AbaJ2Lvl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 07:51:41 -0400
Received: by mail-wi0-f172.google.com with SMTP id bs8so1433145wib.11
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 04:51:40 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 25/25] iwlwifi: mvm: unref SCAN ref on scan completion
Date: Wed, 29 Oct 2014 13:50:46 +0200
Message-Id: <1414583446-11032-25-git-send-email-egrumbach@gmail.com> (sfid-20141029_125153_593399_DA3302C7)
In-Reply-To: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
References: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

The scan reference wasn't released in case of offloaded scan,
causing the refcount to go wrong and prevent the device
from going into d0i3.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 042fcdc..5cd59a4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -673,6 +673,7 @@ int iwl_mvm_rx_scan_offload_complete_notif(struct iwl_mvm *mvm,
 		mvm->scan_status = IWL_MVM_SCAN_NONE;
 		ieee80211_scan_completed(mvm->hw,
 					 status == IWL_SCAN_OFFLOAD_ABORTED);
+		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
 	}
 
 	mvm->last_ebs_successful = !ebs_status;
@@ -1107,8 +1108,12 @@ int iwl_mvm_scan_offload_stop(struct iwl_mvm *mvm, bool notify)
 	/*
 	 * Clear the scan status so the next scan requests will succeed. This
 	 * also ensures the Rx handler doesn't do anything, as the scan was
-	 * stopped from above.
+	 * stopped from above. Since the rx handler won't do anything now,
+	 * we have to release the scan reference here.
 	 */
+	if (mvm->scan_status == IWL_MVM_SCAN_OS)
+		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
+
 	mvm->scan_status = IWL_MVM_SCAN_NONE;
 
 	if (notify) {
-- 
1.9.1

