Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6D7CC433E9
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Feb 2021 15:16:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEC7B64E7C
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Feb 2021 15:16:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbhBJPQK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Feb 2021 10:16:10 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:45244 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231309AbhBJPQG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Feb 2021 10:16:06 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1l9rD3-0049kS-Uu; Wed, 10 Feb 2021 17:15:18 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Wed, 10 Feb 2021 17:15:05 +0200
Message-Id: <iwlwifi.20210210171218.c03cc5db67c1.Ia928ca34d25a73d959a345ffbe4f1217c3f17394@changeid>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210210151514.416221-1-luca@coelho.fi>
References: <20210210151514.416221-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 03/12] iwlwifi: mvm: register to mac80211 last
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

All the actions that were taken after the registration can
be taken before the registration to mac80211.
This will help to defer part of the op_mode_mvm_start
function to a later stage in case the device is not
available.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 3f82b219b45b..573c4548e441 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -891,16 +891,9 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	/* Set EBS as successful as long as not stated otherwise by the FW. */
 	mvm->last_ebs_successful = true;
 
-	err = iwl_mvm_mac_setup_register(mvm);
-	if (err)
-		goto out_free;
-	mvm->hw_registered = true;
-
 	min_backoff = iwl_mvm_min_backoff(mvm);
 	iwl_mvm_thermal_initialize(mvm, min_backoff);
 
-	iwl_mvm_dbgfs_register(mvm, dbgfs_dir);
-
 	if (!iwl_mvm_has_new_rx_stats_api(mvm))
 		memset(&mvm->rx_stats_v3, 0,
 		       sizeof(struct mvm_statistics_rx_v3));
@@ -909,8 +902,17 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 
 	iwl_mvm_toggle_tx_ant(mvm, &mvm->mgmt_last_antenna_idx);
 
+	err = iwl_mvm_mac_setup_register(mvm);
+	if (err)
+		goto out_thermal_exit;
+	mvm->hw_registered = true;
+
+	iwl_mvm_dbgfs_register(mvm, dbgfs_dir);
+
 	return op_mode;
 
+ out_thermal_exit:
+	iwl_mvm_thermal_exit(mvm);
  out_free:
 	iwl_fw_flush_dumps(&mvm->fwrt);
 	iwl_fw_runtime_free(&mvm->fwrt);
-- 
2.30.0

