Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11786 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754598AbbAVUen (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:34:43 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 33/38] iwlwifi: mvm: really disable TDLS queues
Date: Thu, 22 Jan 2015 22:33:24 +0200
Message-Id: <1421958809-3371-33-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_214447_946942_40137F1C)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox>
References: <1421958313.6424.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

for_each_set_bit expect the size in number of bits and not
in bytes.

Fixes: a0f6bf2a5b01 ("iwlwifi: mvm: use private TFD queues for TDLS stations")
Reviewed-by: Arik Nemtsov <arik@wizery.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/sta.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 8e413d3..14a8484 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -250,7 +250,7 @@ static void iwl_mvm_tdls_sta_deinit(struct iwl_mvm *mvm,
 
 	/* disable the TDLS STA-specific queues */
 	sta_msk = mvmsta->tfd_queue_msk;
-	for_each_set_bit(i, &sta_msk, sizeof(sta_msk))
+	for_each_set_bit(i, &sta_msk, sizeof(sta_msk) * BITS_PER_BYTE)
 		iwl_mvm_disable_txq(mvm, i, 0);
 }
 
@@ -464,7 +464,7 @@ void iwl_mvm_sta_drained_wk(struct work_struct *wk)
 		if (mvm->tfd_drained[sta_id]) {
 			unsigned long i, msk = mvm->tfd_drained[sta_id];
 
-			for_each_set_bit(i, &msk, sizeof(msk))
+			for_each_set_bit(i, &msk, sizeof(msk) * BITS_PER_BYTE)
 				iwl_mvm_disable_txq(mvm, i, 0);
 
 			mvm->tfd_drained[sta_id] = 0;
-- 
1.9.1

