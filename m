Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:53341 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992AbaICT5J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:57:09 -0400
Received: by mail-we0-f180.google.com with SMTP id w61so9156944wes.11
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:57:08 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 26/36] iwlwifi: trans: make aggregation explicit for TX queue handling
Date: Wed,  3 Sep 2014 22:56:14 +0300
Message-Id: <1409774184-24665-26-git-send-email-egrumbach@gmail.com> (sfid-20140903_220113_492760_88378CDC)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Currently a valid sta_id is assumed to mean that the queue is
meant to also be aggregated, but that assumption will not be
true in the future, so don't make it in the lower level but
only in the inline wrapper.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h | 3 +++
 drivers/net/wireless/iwlwifi/pcie/tx.c   | 3 +--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index dd3aefc..7e8dc3a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -405,6 +405,7 @@ struct iwl_trans_txq_scd_cfg {
 	u8 fifo;
 	s8 sta_id;
 	u8 tid;
+	bool aggregate;
 	int frame_limit;
 };
 
@@ -803,6 +804,7 @@ static inline void iwl_trans_txq_enable(struct iwl_trans *trans, int queue,
 		.sta_id = sta_id,
 		.tid = tid,
 		.frame_limit = frame_limit,
+		.aggregate = sta_id >= 0,
 	};
 
 	iwl_trans_txq_enable_cfg(trans, queue, ssn, &cfg);
@@ -816,6 +818,7 @@ static inline void iwl_trans_ac_txq_enable(struct iwl_trans *trans, int queue,
 		.sta_id = -1,
 		.tid = IWL_MAX_TID_COUNT,
 		.frame_limit = IWL_FRAME_LIMIT,
+		.aggregate = false,
 	};
 
 	iwl_trans_txq_enable_cfg(trans, queue, 0, &cfg);
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index eb39e58..a24c1df 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -1085,8 +1085,7 @@ void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, u16 ssn,
 		if (txq_id != trans_pcie->cmd_queue)
 			iwl_scd_txq_set_chain(trans, txq_id);
 
-		/* If this queue is mapped to a certain station: it is an AGG */
-		if (cfg->sta_id >= 0) {
+		if (cfg->aggregate) {
 			u16 ra_tid = BUILD_RAxTID(cfg->sta_id, cfg->tid);
 
 			/* Map receiver-address / traffic-ID to this queue */
-- 
1.9.1

