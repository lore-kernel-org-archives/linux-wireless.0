Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51840 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752450AbdLWJWL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 23 Dec 2017 04:22:11 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 23 Dec 2017 11:22:00 +0200
Message-Id: <20171223092200.30270-6-luca@coelho.fi> (sfid-20171223_102227_051032_84375B15)
In-Reply-To: <20171223092200.30270-1-luca@coelho.fi>
References: <20171223092200.30270-1-luca@coelho.fi>
Subject: [PATCH 5/5] iwlwifi: mvm: check if mac80211_queue is valid in iwl_mvm_disable_txq
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Sometimes iwl_mvm_disable_txq() may be called with mac80211_queue ==
IEEE80211_INVAL_HW_QUEUE, and this would cause us to use BIT(0xFF)
which is way too large for the u16 we used to store it in
hw_queue_to_mac820211.  If this happens the following UBSAN warning
will be generated:

[  167.185167] UBSAN: Undefined behaviour in drivers/net/wireless/intel/iwlwifi/mvm/utils.c:838:5
[  167.185171] shift exponent 255 is too large for 64-bit type 'long unsigned int'

Fix that by checking that it is not IEEE80211_INVAL_HW_QUEUE and,
while at it, add a warning if the queue number is larger than
IEEE80211_MAX_QUEUES.

Fixes: 34e10860ae8d ("iwlwifi: mvm: remove references to queue_info in new TX path")
Reported-by: Paul Menzel <pmenzel+linux-wireless@molgen.mpg.de>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index d65e1db7c097..70f8b8eb6117 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -800,12 +800,19 @@ int iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 		.scd_queue = queue,
 		.action = SCD_CFG_DISABLE_QUEUE,
 	};
-	bool remove_mac_queue = true;
+	bool remove_mac_queue = mac80211_queue != IEEE80211_INVAL_HW_QUEUE;
 	int ret;
 
+	if (WARN_ON(remove_mac_queue && mac80211_queue >= IEEE80211_MAX_QUEUES))
+		return -EINVAL;
+
 	if (iwl_mvm_has_new_tx_api(mvm)) {
 		spin_lock_bh(&mvm->queue_info_lock);
-		mvm->hw_queue_to_mac80211[queue] &= ~BIT(mac80211_queue);
+
+		if (remove_mac_queue)
+			mvm->hw_queue_to_mac80211[queue] &=
+				~BIT(mac80211_queue);
+
 		spin_unlock_bh(&mvm->queue_info_lock);
 
 		iwl_trans_txq_free(mvm->trans, queue);
-- 
2.15.1
