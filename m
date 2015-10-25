Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:56969 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbbJYMCF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 08:02:05 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/16] iwlwifi: mvm: disable TDLS ac queues correctly
Date: Sun, 25 Oct 2015 14:01:15 +0200
Message-Id: <1445774476-24792-15-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151025_131654_483580_B0B616AF)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8AF6CC@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8AF6CC@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

The iwl_mvm_disable_queue function requires the TID to be set to
IWL_MAX_TID_COUNT when disabling an AC queue. Call it correctly for TDLS
scenarios.

Fixes: 4ecafae9e568 ("iwlwifi: mvm: support using multiple ACs on single HW queue")
Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/sta.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 04d0cb3..300a249 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -255,7 +255,7 @@ static void iwl_mvm_tdls_sta_deinit(struct iwl_mvm *mvm,
 	/* disable the TDLS STA-specific queues */
 	sta_msk = mvmsta->tfd_queue_msk;
 	for_each_set_bit(i, &sta_msk, sizeof(sta_msk) * BITS_PER_BYTE)
-		iwl_mvm_disable_txq(mvm, i, i, 0, 0);
+		iwl_mvm_disable_txq(mvm, i, i, IWL_MAX_TID_COUNT, 0);
 }
 
 int iwl_mvm_add_sta(struct iwl_mvm *mvm,
@@ -474,7 +474,8 @@ void iwl_mvm_sta_drained_wk(struct work_struct *wk)
 			unsigned long i, msk = mvm->tfd_drained[sta_id];
 
 			for_each_set_bit(i, &msk, sizeof(msk) * BITS_PER_BYTE)
-				iwl_mvm_disable_txq(mvm, i, i, 0, 0);
+				iwl_mvm_disable_txq(mvm, i, i,
+						    IWL_MAX_TID_COUNT, 0);
 
 			mvm->tfd_drained[sta_id] = 0;
 			IWL_DEBUG_TDLS(mvm, "Drained sta %d, with queues %ld\n",
-- 
2.1.4

