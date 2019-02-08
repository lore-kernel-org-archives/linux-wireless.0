Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8B85C169C4
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 10:48:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9293021924
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 10:48:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbfBHKsV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 05:48:21 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:57132 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727722AbfBHKsV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 05:48:21 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gs3h1-0002jg-99; Fri, 08 Feb 2019 12:47:35 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  8 Feb 2019 12:47:12 +0200
Message-Id: <20190208104712.16210-21-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190208104712.16210-1-luca@coelho.fi>
References: <20190208104712.16210-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 20/20] iwlwifi: mvm: stop static queues correctly
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Avraham Stern <avraham.stern@intel.com>

AP interfaces still use some static TX queues (for probes,
broadcast and multicast frames). These queues were not stopped
correctly when the transport layer indicated the queue should be
stopped. As a result, when flushing the queues, new frames from
the overflow queue were tx'd, so the queues still had frames after
flushing. This ended up in an assert since trying to remove a station
with non-empty queues.

Fix it by stopping the static queues correctly when required.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 0bdf92c49710..33053d136a8c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1125,6 +1125,12 @@ static void iwl_mvm_async_cb(struct iwl_op_mode *op_mode,
 	iwl_trans_block_txq_ptrs(mvm->trans, false);
 }
 
+static int iwl_mvm_is_static_queue(struct iwl_mvm *mvm, int queue)
+{
+	return queue == mvm->aux_queue || queue == mvm->probe_queue ||
+		queue == mvm->p2p_dev_queue || queue == mvm->snif_queue;
+}
+
 static void iwl_mvm_queue_state_change(struct iwl_op_mode *op_mode,
 				       int hw_queue, bool start)
 {
@@ -1151,6 +1157,15 @@ static void iwl_mvm_queue_state_change(struct iwl_op_mode *op_mode,
 		goto out;
 	mvmsta = iwl_mvm_sta_from_mac80211(sta);
 
+	if (iwl_mvm_is_static_queue(mvm, hw_queue)) {
+		if (!start)
+			ieee80211_stop_queues(mvm->hw);
+		else if (mvmsta->sta_state != IEEE80211_STA_NOTEXIST)
+			ieee80211_wake_queues(mvm->hw);
+
+		goto out;
+	}
+
 	if (iwl_mvm_has_new_tx_api(mvm)) {
 		int tid = mvm->tvqm_info[hw_queue].txq_tid;
 
-- 
2.20.1

