Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24060 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbbCATb7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 14:31:59 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/31] iwlwifi: mvm: consider TDLS queues as used during drain
Date: Sun,  1 Mar 2015 21:31:18 +0200
Message-Id: <1425238304-498-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_203202_912836_58CDE4A3)
In-Reply-To: <1425238186.30202.5.camel@egrumbacBox>
References: <1425238186.30202.5.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

When a TDLS station is being drained its Tx queues are still in use. Don't
allocate them to a different station in the meantime.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 7bdc622..f2bfc15 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -244,6 +244,7 @@ static void iwl_mvm_mac_sta_hw_queues_iter(void *_data,
 unsigned long iwl_mvm_get_used_hw_queues(struct iwl_mvm *mvm,
 					 struct ieee80211_vif *exclude_vif)
 {
+	u8 sta_id;
 	struct iwl_mvm_hw_queues_iface_iterator_data data = {
 		.exclude_vif = exclude_vif,
 		.used_hw_queues =
@@ -264,6 +265,13 @@ unsigned long iwl_mvm_get_used_hw_queues(struct iwl_mvm *mvm,
 					  iwl_mvm_mac_sta_hw_queues_iter,
 					  &data);
 
+	/*
+	 * Some TDLS stations may be removed but are in the process of being
+	 * drained. Don't touch their queues.
+	 */
+	for_each_set_bit(sta_id, mvm->sta_drained, IWL_MVM_STATION_COUNT)
+		data.used_hw_queues |= mvm->tfd_drained[sta_id];
+
 	return data.used_hw_queues;
 }
 
-- 
1.9.1

