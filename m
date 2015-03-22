Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:16906 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbbCVRVq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2015 13:21:46 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 6/6] iwlwifi: mvm: remove WARN_ON for invalid BA notification
Date: Sun, 22 Mar 2015 19:21:32 +0200
Message-Id: <1427044892-13907-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150322_182150_405719_4CEE9463)
In-Reply-To: <1427044767.8611.4.camel@egrumbacBox>
References: <1427044767.8611.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The firmware frequently manages to trigger this, and there's
no known driver workaround, so stop warning.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/tx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 07304e1..96a0540 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -949,8 +949,10 @@ int iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 	mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	tid_data = &mvmsta->tid_data[tid];
 
-	if (WARN_ONCE(tid_data->txq_id != scd_flow, "Q %d, tid %d, flow %d",
-		      tid_data->txq_id, tid, scd_flow)) {
+	if (tid_data->txq_id != scd_flow) {
+		IWL_ERR(mvm,
+			"invalid BA notification: Q %d, tid %d, flow %d\n",
+			tid_data->txq_id, tid, scd_flow);
 		rcu_read_unlock();
 		return 0;
 	}
-- 
1.9.1

