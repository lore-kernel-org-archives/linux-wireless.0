Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40892 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752843AbcEJUbM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:31:12 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:19 +0300
Message-Id: <1462910797-20303-23-git-send-email-luca@coelho.fi> (sfid-20160510_223115_492908_5B400BAD)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 23/41] iwlwifi: mvm: don't allow negative reference count
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Currently code allows mvm reference to become negative and
only warns in case mvm reference is released while reference
counting is 0.
However, we better prevent this from happening at all since
iwl_mvm_unref() may race against iwl_mvm_unref_all_except()
which is called on restart.
As a result we might get the same reference unreferenced twice
ending with a negative value:
An example for an easily reproduced log:
    [ 2689.909166] iwl_mvm_ref Take mvm reference - type 8
    [ 2690.732716] iwl_mvm_unref_all_except Cleanup: remove mvm ref type 8 (1)
    [ 2690.849708] iwl_mvm_unref Leave mvm reference - type 8
    [ 2690.849721] WARNING: ... iwl_mvm_unref+0xb0/0xc0 [iwlmvm]()

If there will be yet another another restart iwl_mvm_unref_all_except
will run from 0 up to ref count, and since it is unsigned, we will throw
the transport ref count completely out of balance:
    iwl_mvm_unref_all_except[I] -- Cleanup: remove mvm ref type 8 (255)
    iwl_trans_slv_unref[I] -- rpm counter: 0
    iwl_trans_slv_unref[I] -- rpm counter: -1
    iwl_trans_slv_unref[I] -- rpm counter: -2
 ...
    iwl_trans_slv_unref[I] -- rpm counter: -253
    iwl_trans_slv_unref[I] -- rpm counter: -254

As there is no valid scenario where we can get to a negative
reference count - prevent it from happening.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 5648e37..cd71017 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -229,7 +229,11 @@ void iwl_mvm_unref(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type)
 
 	IWL_DEBUG_RPM(mvm, "Leave mvm reference - type %d\n", ref_type);
 	spin_lock_bh(&mvm->refs_lock);
-	WARN_ON(!mvm->refs[ref_type]--);
+	if (WARN_ON(!mvm->refs[ref_type])) {
+		spin_unlock_bh(&mvm->refs_lock);
+		return;
+	}
+	mvm->refs[ref_type]--;
 	spin_unlock_bh(&mvm->refs_lock);
 	iwl_trans_unref(mvm->trans);
 }
-- 
2.8.1

