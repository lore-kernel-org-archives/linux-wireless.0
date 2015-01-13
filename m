Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:53777 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbbAMMTv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 07:19:51 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 2/3] iwlwifi: mvm: drop non VO frames when flushing
Date: Tue, 13 Jan 2015 14:19:46 +0200
Message-Id: <1421151587-10437-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150113_131956_854938_12B78D8F)
In-Reply-To: <1421151474.2601.10.camel@egrumbacBox>
References: <1421151474.2601.10.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This change has already been implemented in iwldvm:

commit a260e7b3f0307878b99d57ed1406cf2d497923b8
Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date:   Sun Oct 5 09:11:14 2014 +0300

    iwlwifi: dvm: drop non VO frames when flushing

Since I added the flush() callback implementation in mvm,
we got reports that the queues are stuck while roaming
or suspending.
This commit above helped much for iwldvm, implement the
same behavior for iwlmvm.

CC: <stable@vger.kernel.org> [3.16+]
Fixes: c5b0e7c0565a ("iwlwifi: mvm: implement mac80211's flush callback")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index e880f9d..2091558 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -3343,18 +3343,16 @@ static void iwl_mvm_mac_flush(struct ieee80211_hw *hw,
 		msk |= mvmsta->tfd_queue_msk;
 	}
 
-	if (drop) {
-		if (iwl_mvm_flush_tx_path(mvm, msk, true))
-			IWL_ERR(mvm, "flush request fail\n");
-		mutex_unlock(&mvm->mutex);
-	} else {
-		mutex_unlock(&mvm->mutex);
+	msk &= ~BIT(vif->hw_queue[IEEE80211_AC_VO]);
 
-		/* this can take a while, and we may need/want other operations
-		 * to succeed while doing this, so do it without the mutex held
-		 */
-		iwl_trans_wait_tx_queue_empty(mvm->trans, msk);
-	}
+	if (iwl_mvm_flush_tx_path(mvm, msk, true))
+		IWL_ERR(mvm, "flush request fail\n");
+	mutex_unlock(&mvm->mutex);
+
+	/* this can take a while, and we may need/want other operations
+	 * to succeed while doing this, so do it without the mutex held
+	 */
+	iwl_trans_wait_tx_queue_empty(mvm->trans, msk);
 }
 
 const struct ieee80211_ops iwl_mvm_hw_ops = {
-- 
1.9.1

