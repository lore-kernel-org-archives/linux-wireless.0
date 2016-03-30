Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:24696 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145AbcC3OGA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:06:00 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 18/43] iwlwifi: mvm: remove is_data_qos variable in TX
Date: Wed, 30 Mar 2016 17:04:50 +0300
Message-Id: <1459346715-7954-18-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160612_067712_2DB77DD6)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

"is_data_qos == true" is equivalent to "tid < IWL_MAX_TID_COUNT"
since tid is only assigned (and range-checked) in that case.

This removes a (harmless) smatch warning that occurs because it
can't seem to follow the above logic from the code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 138d64d..c7c3d7b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -654,7 +654,7 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 	u16 seq_number = 0;
 	u8 tid = IWL_MAX_TID_COUNT;
 	u8 txq_id = info->hw_queue;
-	bool is_data_qos = false, is_ampdu = false;
+	bool is_ampdu = false;
 	int hdrlen;
 
 	mvmsta = iwl_mvm_sta_from_mac80211(sta);
@@ -694,7 +694,6 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 		seq_number &= IEEE80211_SCTL_SEQ;
 		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
 		hdr->seq_ctrl |= cpu_to_le16(seq_number);
-		is_data_qos = true;
 		is_ampdu = info->flags & IEEE80211_TX_CTL_AMPDU;
 	}
 
@@ -722,7 +721,7 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 	if (iwl_trans_tx(mvm->trans, skb, dev_cmd, txq_id))
 		goto drop_unlock_sta;
 
-	if (is_data_qos && !ieee80211_has_morefrags(fc))
+	if (tid < IWL_MAX_TID_COUNT && !ieee80211_has_morefrags(fc))
 		mvmsta->tid_data[tid].seq_number = seq_number + 0x10;
 
 	spin_unlock(&mvmsta->lock);
-- 
2.5.0

