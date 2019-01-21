Return-Path: <SRS0=xI28=P5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0C7AC282E6
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 07:51:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98DD92084A
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 07:51:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728906AbfAUHvL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Jan 2019 02:51:11 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:49188 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726240AbfAUHvL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Jan 2019 02:51:11 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1glULy-0006cr-4X; Mon, 21 Jan 2019 09:50:42 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon, 21 Jan 2019 09:50:23 +0200
Message-Id: <20190121075026.25059-14-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190121075026.25059-1-luca@coelho.fi>
References: <20190121075026.25059-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 13/16] iwlwifi: mvm: avoid possible access out of array.
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

The value in txq_id can be out of array scope,
validate it before accessing the array.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Fixes: cf961e16620f ("iwlwifi: mvm: support dqa-mode agg on non-shared queue")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 09f294c466da..5f42897dcd55 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2702,7 +2702,7 @@ int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_mvm_tid_data *tid_data;
 	u16 normalized_ssn;
-	int txq_id;
+	u16 txq_id;
 	int ret;
 
 	if (WARN_ON_ONCE(tid >= IWL_MAX_TID_COUNT))
@@ -2744,17 +2744,24 @@ int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	 */
 	txq_id = mvmsta->tid_data[tid].txq_id;
 	if (txq_id == IWL_MVM_INVALID_QUEUE) {
-		txq_id = iwl_mvm_find_free_queue(mvm, mvmsta->sta_id,
-						 IWL_MVM_DQA_MIN_DATA_QUEUE,
-						 IWL_MVM_DQA_MAX_DATA_QUEUE);
-		if (txq_id < 0) {
-			ret = txq_id;
+		ret = iwl_mvm_find_free_queue(mvm, mvmsta->sta_id,
+					      IWL_MVM_DQA_MIN_DATA_QUEUE,
+					      IWL_MVM_DQA_MAX_DATA_QUEUE);
+		if (ret < 0) {
 			IWL_ERR(mvm, "Failed to allocate agg queue\n");
 			goto out;
 		}
 
+		txq_id = ret;
+
 		/* TXQ hasn't yet been enabled, so mark it only as reserved */
 		mvm->queue_info[txq_id].status = IWL_MVM_QUEUE_RESERVED;
+	} else if (WARN_ON(txq_id >= IWL_MAX_HW_QUEUES)) {
+		ret = -ENXIO;
+		IWL_ERR(mvm, "tid_id %d out of range (0, %d)!\n",
+			tid, IWL_MAX_HW_QUEUES - 1);
+		goto out;
+
 	} else if (unlikely(mvm->queue_info[txq_id].status ==
 			    IWL_MVM_QUEUE_SHARED)) {
 		ret = -ENXIO;
-- 
2.20.1

