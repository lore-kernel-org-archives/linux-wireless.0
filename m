Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45066 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932537AbaJ2LvH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 07:51:07 -0400
Received: by mail-wi0-f174.google.com with SMTP id d1so1431981wiv.13
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 04:51:06 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/25] iwlwifi: mvm: spin off a function to start scan offload
Date: Wed, 29 Oct 2014 13:50:27 +0200
Message-Id: <1414583446-11032-6-git-send-email-egrumbach@gmail.com> (sfid-20141029_125113_631177_0CFDF146)
In-Reply-To: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
References: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

The net-detect feature will require a scan offload to be started in
the same way it is done now for scheduled scan.  Spin a new function
off of the sched_scan_start op code for reuse.  Additionally,
restructure the function a bit for more readability.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 20 ++------------------
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  4 ++++
 drivers/net/wireless/iwlwifi/mvm/scan.c     | 25 +++++++++++++++++++++++++
 3 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 585fe5b..b17877c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2170,25 +2170,9 @@ static int iwl_mvm_mac_sched_scan_start(struct ieee80211_hw *hw,
 
 	mvm->scan_status = IWL_MVM_SCAN_SCHED;
 
-	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN)) {
-		ret = iwl_mvm_config_sched_scan(mvm, vif, req, ies);
-		if (ret)
-			goto err;
-	}
-
-	ret = iwl_mvm_config_sched_scan_profiles(mvm, req);
+	ret = iwl_mvm_scan_offload_start(mvm, vif, req, ies);
 	if (ret)
-		goto err;
-
-	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN)
-		ret = iwl_mvm_unified_sched_scan_lmac(mvm, vif, req, ies);
-	else
-		ret = iwl_mvm_sched_scan_start(mvm, req);
-
-	if (!ret)
-		goto out;
-err:
-	mvm->scan_status = IWL_MVM_SCAN_NONE;
+		mvm->scan_status = IWL_MVM_SCAN_NONE;
 out:
 	mutex_unlock(&mvm->mutex);
 	return ret;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index b153ced..14ec678 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -949,6 +949,10 @@ int iwl_mvm_config_sched_scan_profiles(struct iwl_mvm *mvm,
 				       struct cfg80211_sched_scan_request *req);
 int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 			     struct cfg80211_sched_scan_request *req);
+int iwl_mvm_scan_offload_start(struct iwl_mvm *mvm,
+			       struct ieee80211_vif *vif,
+			       struct cfg80211_sched_scan_request *req,
+			       struct ieee80211_scan_ies *ies);
 int iwl_mvm_scan_offload_stop(struct iwl_mvm *mvm, bool notify);
 int iwl_mvm_rx_scan_offload_results(struct iwl_mvm *mvm,
 				    struct iwl_rx_cmd_buffer *rxb,
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index b280d5d..64c02a2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -1007,6 +1007,31 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 				    sizeof(scan_req), &scan_req);
 }
 
+int iwl_mvm_scan_offload_start(struct iwl_mvm *mvm,
+			       struct ieee80211_vif *vif,
+			       struct cfg80211_sched_scan_request *req,
+			       struct ieee80211_scan_ies *ies)
+{
+	int ret;
+
+	if ((mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN)) {
+		ret = iwl_mvm_config_sched_scan_profiles(mvm, req);
+		if (ret)
+			return ret;
+		ret = iwl_mvm_unified_sched_scan_lmac(mvm, vif, req, ies);
+	} else {
+		ret = iwl_mvm_config_sched_scan(mvm, vif, req, ies);
+		if (ret)
+			return ret;
+		ret = iwl_mvm_config_sched_scan_profiles(mvm, req);
+		if (ret)
+			return ret;
+		ret = iwl_mvm_sched_scan_start(mvm, req);
+	}
+
+	return ret;
+}
+
 static int iwl_mvm_send_scan_offload_abort(struct iwl_mvm *mvm)
 {
 	int ret;
-- 
1.9.1

