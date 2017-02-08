Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39406 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751654AbdBHQXK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 11:23:10 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  8 Feb 2017 17:51:48 +0200
Message-Id: <20170208155149.1704-8-luca@coelho.fi> (sfid-20170208_172313_995409_1DF78C62)
In-Reply-To: <20170208155149.1704-1-luca@coelho.fi>
References: <20170208112322.29413-1-luca@coelho.fi>
 <20170208155149.1704-1-luca@coelho.fi>
Subject: [PATCH 16/17] iwlwifi: mvm: Fix removal of IGTK
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

When removing an IGTK, iwl_mvm_send_sta_igtk() was
called before station ID was retrieved, so the function
was invoked with an invalid station ID. Fix this by first
getting the station ID.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=192411
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 1bad933b3ad4..c35fabdf85da 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -3047,6 +3047,11 @@ int iwl_mvm_remove_sta_key(struct iwl_mvm *mvm,
 
 	/* Get the station from the mvm local station table */
 	mvm_sta = iwl_mvm_get_key_sta(mvm, vif, sta);
+	if (!mvm_sta) {
+		IWL_ERR(mvm, "Failed to find station\n");
+		return -EINVAL;
+	}
+	sta_id = mvm_sta->sta_id;
 
 	IWL_DEBUG_WEP(mvm, "mvm remove dynamic key: idx=%d sta=%d\n",
 		      keyconf->keyidx, sta_id);
@@ -3074,8 +3079,6 @@ int iwl_mvm_remove_sta_key(struct iwl_mvm *mvm,
 		return 0;
 	}
 
-	sta_id = mvm_sta->sta_id;
-
 	ret = __iwl_mvm_remove_sta_key(mvm, sta_id, keyconf, mcast);
 	if (ret)
 		return ret;
-- 
2.11.0
