Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42606 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726390AbeHUI2j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 04:28:39 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 21 Aug 2018 08:09:39 +0300
Message-Id: <20180821050952.31603-5-luca@coelho.fi> (sfid-20180821_071009_340119_10E1FC26)
In-Reply-To: <20180821050952.31603-1-luca@coelho.fi>
References: <20180821050952.31603-1-luca@coelho.fi>
Subject: [PATCH v2 04/17] iwlwifi: set the tid for non-QOS frames to zero
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

The tid for Non-QOS frames is set to IWL_MAX_TID_COUNT. This value
is also used for configuring the queue for non-QOS data. However, this
tid is used by the FW for management queues. As a result, the FW
does not encrypt non-QOS data frames.

Fix this by setting the tid for non-QOS data frames to zero, which
is a valid value for data frames in the FW.

This also fixes a bug in sending multicast frames, where the queues
are allocated with tid == 0, but are sent with tid == 8, which may
lead to unexpected behavior.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/api/tx.h    |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   | 24 ++++++++++++++-----
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h b/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
index 514b86123d3d..135135d80d4d 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
@@ -186,7 +186,7 @@ enum iwl_tx_cmd_sec_ctrl {
 /*
  * TID for non QoS frames - to be written in tid_tspec
  */
-#define IWL_TID_NON_QOS	IWL_MAX_TID_COUNT
+#define IWL_TID_NON_QOS	0
 
 /*
  * Limits on the retransmissions - to be written in {data,rts}_retry_limit
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index ff193dca2020..83f3e74337db 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -8,6 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018        Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -35,6 +36,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018        Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -245,14 +247,18 @@ void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
 		iwl_mvm_bar_check_trigger(mvm, bar->ra, tx_cmd->tid_tspec,
 					  ssn);
 	} else {
-		tx_cmd->tid_tspec = IWL_TID_NON_QOS;
+		if (ieee80211_is_data(fc))
+			tx_cmd->tid_tspec = IWL_TID_NON_QOS;
+		else
+			tx_cmd->tid_tspec = IWL_MAX_TID_COUNT;
+
 		if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ)
 			tx_flags |= TX_CMD_FLG_SEQ_CTL;
 		else
 			tx_flags &= ~TX_CMD_FLG_SEQ_CTL;
 	}
 
-	/* Default to 0 (BE) when tid_spec is set to IWL_TID_NON_QOS */
+	/* Default to 0 (BE) when tid_spec is set to IWL_MAX_TID_COUNT */
 	if (tx_cmd->tid_tspec < IWL_MAX_TID_COUNT)
 		ac = tid_to_mac80211_ac[tx_cmd->tid_tspec];
 	else
@@ -1049,6 +1055,8 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 			/* update the tx_cmd hdr as it was already copied */
 			tx_cmd->hdr->seq_ctrl = hdr->seq_ctrl;
 		}
+	} else if (ieee80211_is_data(fc) && !ieee80211_is_data_qos(fc)) {
+		tid = IWL_TID_NON_QOS;
 	}
 
 	txq_id = mvmsta->tid_data[tid].txq_id;
@@ -1525,7 +1533,7 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 		iwl_mvm_tx_airtime(mvm, mvmsta,
 				   le16_to_cpu(tx_resp->wireless_media_time));
 
-		if (tid != IWL_TID_NON_QOS && tid != IWL_MGMT_TID) {
+		if (sta->wme && tid != IWL_MGMT_TID) {
 			struct iwl_mvm_tid_data *tid_data =
 				&mvmsta->tid_data[tid];
 			bool send_eosp_ndp = false;
@@ -1645,20 +1653,24 @@ static void iwl_mvm_rx_tx_cmd_agg(struct iwl_mvm *mvm,
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 	struct iwl_mvm_sta *mvmsta;
 	int queue = SEQ_TO_QUEUE(sequence);
+	struct ieee80211_sta *sta;
 
 	if (WARN_ON_ONCE(queue < IWL_MVM_DQA_MIN_DATA_QUEUE &&
 			 (queue != IWL_MVM_DQA_BSS_CLIENT_QUEUE)))
 		return;
 
-	if (WARN_ON_ONCE(tid == IWL_TID_NON_QOS))
-		return;
-
 	iwl_mvm_rx_tx_cmd_agg_dbg(mvm, pkt);
 
 	rcu_read_lock();
 
 	mvmsta = iwl_mvm_sta_from_staid_rcu(mvm, sta_id);
 
+	sta = rcu_dereference(mvm->fw_id_to_mac_id[sta_id]);
+	if (WARN_ON_ONCE(!sta || !sta->wme)) {
+		rcu_read_unlock();
+		return;
+	}
+
 	if (!WARN_ON_ONCE(!mvmsta)) {
 		mvmsta->tid_data[tid].rate_n_flags =
 			le32_to_cpu(tx_resp->initial_rate);
-- 
2.18.0
