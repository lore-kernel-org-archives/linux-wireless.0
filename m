Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 076F7C282D7
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:55:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D866F20855
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730768AbfA3Lzx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 06:55:53 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:52758 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728480AbfA3Lzv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 06:55:51 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gooT7-0003x8-GX; Wed, 30 Jan 2019 13:55:49 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed, 30 Jan 2019 13:55:17 +0200
Message-Id: <20190130115528.19922-7-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190130115528.19922-1-luca@coelho.fi>
References: <20190130115528.19922-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 06/17] iwlwifi: mvm: simplify some return conditions
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Simplify some return conditions found by running a semantic patch
to detect unnecessary assignments to local variables.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c | 7 ++-----
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 5 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  | 9 +++------
 3 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/coex.c b/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
index 730e37744dc0..3d2abbc5c76c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
@@ -241,7 +241,6 @@ static int iwl_mvm_bt_coex_reduced_txp(struct iwl_mvm *mvm, u8 sta_id,
 	struct iwl_bt_coex_reduced_txp_update_cmd cmd = {};
 	struct iwl_mvm_sta *mvmsta;
 	u32 value;
-	int ret;
 
 	mvmsta = iwl_mvm_sta_from_staid_protected(mvm, sta_id);
 	if (!mvmsta)
@@ -262,10 +261,8 @@ static int iwl_mvm_bt_coex_reduced_txp(struct iwl_mvm *mvm, u8 sta_id,
 	cmd.reduced_txp = cpu_to_le32(value);
 	mvmsta->bt_reduced_txpower = enable;
 
-	ret = iwl_mvm_send_cmd_pdu(mvm, BT_COEX_UPDATE_REDUCED_TXP, CMD_ASYNC,
-				   sizeof(cmd), &cmd);
-
-	return ret;
+	return iwl_mvm_send_cmd_pdu(mvm, BT_COEX_UPDATE_REDUCED_TXP,
+				    CMD_ASYNC, sizeof(cmd), &cmd);
 }
 
 struct iwl_bt_iterator_data {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 86d598d5b68f..af8156ba8084 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1976,9 +1976,8 @@ static int iwl_mvm_scan_stop_wait(struct iwl_mvm *mvm, int type)
 		return ret;
 	}
 
-	ret = iwl_wait_notification(&mvm->notif_wait, &wait_scan_done, 1 * HZ);
-
-	return ret;
+	return iwl_wait_notification(&mvm->notif_wait, &wait_scan_done,
+				     1 * HZ);
 }
 
 int iwl_mvm_scan_size(struct iwl_mvm *mvm)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index c5a01470a3bc..a102a16a15f6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -314,7 +314,6 @@ static int iwl_mvm_invalidate_sta_queue(struct iwl_mvm *mvm, int queue,
 	struct iwl_mvm_sta *mvmsta;
 	u32 status;
 	u8 sta_id;
-	int ret;
 
 	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
 		return -EINVAL;
@@ -349,11 +348,9 @@ static int iwl_mvm_invalidate_sta_queue(struct iwl_mvm *mvm, int queue,
 
 	/* Notify FW of queue removal from the STA queues */
 	status = ADD_STA_SUCCESS;
-	ret = iwl_mvm_send_cmd_pdu_status(mvm, ADD_STA,
-					  iwl_mvm_add_sta_cmd_size(mvm),
-					  &cmd, &status);
-
-	return ret;
+	return iwl_mvm_send_cmd_pdu_status(mvm, ADD_STA,
+					   iwl_mvm_add_sta_cmd_size(mvm),
+					   &cmd, &status);
 }
 
 static int iwl_mvm_disable_txq(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
-- 
2.20.1

