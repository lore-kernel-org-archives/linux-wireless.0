Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36234 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751699AbdAWWSE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jan 2017 17:18:04 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, luciano.coelho@intel.com
Date: Tue, 24 Jan 2017 00:03:46 +0200
Message-Id: <20170123220350.25305-22-luca@coelho.fi> (sfid-20170123_231806_885688_458EF83B)
In-Reply-To: <20170123220350.25305-1-luca@coelho.fi>
References: <20170123220350.25305-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH 21/25] iwlwifi: mvm: remove unused sta_id variable in iwl_mvm_change_queue_owner()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Remove the sta_id variable, to avoid this compile warning when
compiling with W=1:

/home/luca/iwlwifi/stack-dev/drivers/net/wireless/intel/iwlwifi/mvm/sta.c: In function ‘iwl_mvm_change_queue_owner’:
/home/luca/iwlwifi/stack-dev/drivers/net/wireless/intel/iwlwifi/mvm/sta.c:871:5: warning: variable ‘sta_id’ set but not used [-Wunused-but-set-variable]
  s8 sta_id;
     ^

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 636c8b03e318..cf8222a8b588 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -868,7 +868,6 @@ static void iwl_mvm_change_queue_owner(struct iwl_mvm *mvm, int queue)
 		.scd_queue = queue,
 		.action = SCD_CFG_UPDATE_QUEUE_TID,
 	};
-	s8 sta_id;
 	int tid;
 	unsigned long tid_bitmap;
 	int ret;
@@ -876,7 +875,6 @@ static void iwl_mvm_change_queue_owner(struct iwl_mvm *mvm, int queue)
 	lockdep_assert_held(&mvm->mutex);
 
 	spin_lock_bh(&mvm->queue_info_lock);
-	sta_id = mvm->queue_info[queue].ra_sta_id;
 	tid_bitmap = mvm->queue_info[queue].tid_bitmap;
 	spin_unlock_bh(&mvm->queue_info_lock);
 
-- 
2.11.0
