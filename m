Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11786 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559AbbAVUe1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:34:27 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 26/38] Revert "iwlwifi: mvm: drop non VO frames when flushing"
Date: Thu, 22 Jan 2015 22:33:17 +0200
Message-Id: <1421958809-3371-26-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_214447_104663_6FE296E4)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox>
References: <1421958313.6424.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is now implemented by mac80211 (commit below).
mac80211 will flush/drop the frames on the queues before
suspending / disconnecting.
It will then send the deauth and wait until the queues are
empty.

commit 3b24f4c65386dc0f2efb41027bc6e410ea2c0049
Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date:   Wed Jan 7 15:42:39 2015 +0200

    mac80211: let flush() drop packets when possible

This reverts commit 4e6c48e0984e28d064ee8fbc292aee7b7920c507.
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 2c79ad3..cef6f33 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -3565,16 +3565,18 @@ static void iwl_mvm_mac_flush(struct ieee80211_hw *hw,
 		msk |= mvmsta->tfd_queue_msk;
 	}
 
-	msk &= ~BIT(vif->hw_queue[IEEE80211_AC_VO]);
-
-	if (iwl_mvm_flush_tx_path(mvm, msk, true))
-		IWL_ERR(mvm, "flush request fail\n");
-	mutex_unlock(&mvm->mutex);
+	if (drop) {
+		if (iwl_mvm_flush_tx_path(mvm, msk, true))
+			IWL_ERR(mvm, "flush request fail\n");
+		mutex_unlock(&mvm->mutex);
+	} else {
+		mutex_unlock(&mvm->mutex);
 
-	/* this can take a while, and we may need/want other operations
-	 * to succeed while doing this, so do it without the mutex held
-	 */
-	iwl_trans_wait_tx_queue_empty(mvm->trans, msk);
+		/* this can take a while, and we may need/want other operations
+		 * to succeed while doing this, so do it without the mutex held
+		 */
+		iwl_trans_wait_tx_queue_empty(mvm->trans, msk);
+	}
 }
 
 const struct ieee80211_ops iwl_mvm_hw_ops = {
-- 
1.9.1

