Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42426 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751582AbdJ2M3L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Oct 2017 08:29:11 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 29 Oct 2017 14:28:11 +0200
Message-Id: <20171029122816.8802-13-luca@coelho.fi> (sfid-20171029_132917_696867_8AC8758C)
In-Reply-To: <20171029122816.8802-1-luca@coelho.fi>
References: <20171029122816.8802-1-luca@coelho.fi>
Subject: [PATCH 12/17] iwlwifi: mvm: hold mutex when flushing in iwl_mvm_flush_no_vif()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

The iwl_mvm_flush_tx_path() function sends a synchronous command to
the firmware.  When doing that, we must hold the mutex.  The
iwl_mvm_flush_no_vif() function was mistakenly not holding the mutex.
Fix it.

Fixes: 6110d9e5bdd1 ("iwlwifi: mvm: Flush non STA TX queues")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index ae2eb0c8cbeb..3e92a117c0b8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -4005,11 +4005,14 @@ static void iwl_mvm_flush_no_vif(struct iwl_mvm *mvm, u32 queues, bool drop)
 	int i;
 
 	if (!iwl_mvm_has_new_tx_api(mvm)) {
-		if (drop)
+		if (drop) {
+			mutex_lock(&mvm->mutex);
 			iwl_mvm_flush_tx_path(mvm,
 				iwl_mvm_flushable_queues(mvm) & queues, 0);
-		else
+			mutex_unlock(&mvm->mutex);
+		} else {
 			iwl_trans_wait_tx_queues_empty(mvm->trans, queues);
+		}
 		return;
 	}
 
-- 
2.14.2
