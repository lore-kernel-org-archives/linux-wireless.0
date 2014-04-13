Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:56241 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755475AbaDMTUs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:20:48 -0400
Received: by mail-we0-f178.google.com with SMTP id u56so7244656wes.37
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:20:47 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 25/47] iwlwifi: mvm: replace BUG_ON by WARN_ON in scan.c
Date: Sun, 13 Apr 2014 22:19:40 +0300
Message-Id: <1397416802-32403-25-git-send-email-egrumbach@gmail.com> (sfid-20140413_213516_915726_7A12617D)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

While the scan_cmd should really be allocated in init (and
we do fail init in case the allocation failed), it doesn't
mean we should lock up the machine if something really bad
happened.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c   | 5 ++++-
 drivers/net/wireless/iwlwifi/pcie/trans.c | 3 +++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index c91dc84..9e760d0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -348,7 +348,10 @@ int iwl_mvm_scan_request(struct iwl_mvm *mvm,
 	struct iwl_mvm_scan_params params = {};
 
 	lockdep_assert_held(&mvm->mutex);
-	BUG_ON(mvm->scan_cmd == NULL);
+
+	/* we should have failed registration if scan_cmd was NULL */
+	if (WARN_ON(mvm->scan_cmd == NULL))
+		return -ENOMEM;
 
 	IWL_DEBUG_SCAN(mvm, "Handling mac80211 scan request\n");
 	mvm->scan_status = IWL_MVM_SCAN_OS;
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 4845d50..f98ef1e 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1278,6 +1278,8 @@ static int iwl_trans_pcie_wait_txq_empty(struct iwl_trans *trans, u32 txq_bm)
 			continue;
 		if (!(BIT(cnt) & txq_bm))
 			continue;
+
+		IWL_DEBUG_TX_QUEUES(trans, "Emptying queue %d...\n", cnt);
 		txq = &trans_pcie->txq[cnt];
 		q = &txq->q;
 		wr_ptr = ACCESS_ONCE(q->write_ptr);
@@ -1300,6 +1302,7 @@ static int iwl_trans_pcie_wait_txq_empty(struct iwl_trans *trans, u32 txq_bm)
 			ret = -ETIMEDOUT;
 			break;
 		}
+		IWL_DEBUG_TX_QUEUES(trans, "Queue %d is now empty.\n", cnt);
 	}
 
 	if (!ret)
-- 
1.8.3.2

