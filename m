Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:45496 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbaDMTUp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:20:45 -0400
Received: by mail-wg0-f49.google.com with SMTP id a1so7487639wgh.32
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:20:44 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Monam Agarwal <monamagarwal123@gmail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 23/47] iwlwifi: mvm: Use RCU_INIT_POINTER(x, NULL)
Date: Sun, 13 Apr 2014 22:19:38 +0300
Message-Id: <1397416802-32403-23-git-send-email-egrumbach@gmail.com> (sfid-20140413_213518_032171_40044910)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Monam Agarwal <monamagarwal123@gmail.com>

rcu_assign_pointer() ensures that the initialization of a structure is
carried out before storing a pointer to that structure. However, in the
case that NULL is assigned there's no structure to initialize so using
RCU_INIT_POINTER instead is safe and more efficient.

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
[rewrite commit log]
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/sta.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index eb3e4bc..075500c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -498,7 +498,7 @@ void iwl_mvm_sta_drained_wk(struct work_struct *wk)
 				sta_id);
 			continue;
 		}
-		rcu_assign_pointer(mvm->fw_id_to_mac_id[sta_id], NULL);
+		RCU_INIT_POINTER(mvm->fw_id_to_mac_id[sta_id], NULL);
 		clear_bit(sta_id, mvm->sta_drained);
 	}
 
@@ -549,7 +549,7 @@ int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 	} else {
 		spin_unlock_bh(&mvm_sta->lock);
 		ret = iwl_mvm_rm_sta_common(mvm, mvm_sta->sta_id);
-		rcu_assign_pointer(mvm->fw_id_to_mac_id[mvm_sta->sta_id], NULL);
+		RCU_INIT_POINTER(mvm->fw_id_to_mac_id[mvm_sta->sta_id], NULL);
 	}
 
 	return ret;
@@ -563,7 +563,7 @@ int iwl_mvm_rm_sta_id(struct iwl_mvm *mvm,
 
 	lockdep_assert_held(&mvm->mutex);
 
-	rcu_assign_pointer(mvm->fw_id_to_mac_id[sta_id], NULL);
+	RCU_INIT_POINTER(mvm->fw_id_to_mac_id[sta_id], NULL);
 	return ret;
 }
 
@@ -585,7 +585,7 @@ int iwl_mvm_allocate_int_sta(struct iwl_mvm *mvm, struct iwl_mvm_int_sta *sta,
 
 void iwl_mvm_dealloc_int_sta(struct iwl_mvm *mvm, struct iwl_mvm_int_sta *sta)
 {
-	rcu_assign_pointer(mvm->fw_id_to_mac_id[sta->sta_id], NULL);
+	RCU_INIT_POINTER(mvm->fw_id_to_mac_id[sta->sta_id], NULL);
 	memset(sta, 0, sizeof(struct iwl_mvm_int_sta));
 	sta->sta_id = IWL_MVM_STATION_COUNT;
 }
-- 
1.8.3.2

