Return-Path: <SRS0=Soq1=NW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD81C4161B
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 10:26:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8977208A3
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 10:26:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C8977208A3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727727AbeKKUOs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 11 Nov 2018 15:14:48 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:35826 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727344AbeKKUOs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Nov 2018 15:14:48 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gLmwu-00007G-Cs; Sun, 11 Nov 2018 12:26:36 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sun, 11 Nov 2018 12:26:26 +0200
Message-Id: <20181111102627.18461-5-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181111102627.18461-1-luca@coelho.fi>
References: <20181111102627.18461-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 4/5] iwlwifi: fix D3 debug data buffer memory leak
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

If the driver is unloaded when D3 debug data pulling is enabled
but not triggered, it doesn't release the data buffer.

Fix this by adding iwl_fw_runtime_free and calling it from the
relevant places.

Fixes: 2d8c261511ab ("iwlwifi: add d3 debug data support")
Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h | 6 +++++-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c    | 2 ++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
index 6b95d0e75889..2b8b50a77990 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
@@ -154,7 +154,11 @@ void iwl_fw_runtime_init(struct iwl_fw_runtime *fwrt, struct iwl_trans *trans,
 			const struct iwl_fw_runtime_ops *ops, void *ops_ctx,
 			struct dentry *dbgfs_dir);
 
-void iwl_fw_runtime_exit(struct iwl_fw_runtime *fwrt);
+static inline void iwl_fw_runtime_free(struct iwl_fw_runtime *fwrt)
+{
+	kfree(fwrt->dump.d3_debug_data);
+	fwrt->dump.d3_debug_data = NULL;
+}
 
 void iwl_fw_runtime_suspend(struct iwl_fw_runtime *fwrt);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 0e2092526fae..af3fba10abc1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -858,6 +858,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	iwl_mvm_thermal_exit(mvm);
  out_free:
 	iwl_fw_flush_dump(&mvm->fwrt);
+	iwl_fw_runtime_free(&mvm->fwrt);
 
 	if (iwlmvm_mod_params.init_dbg)
 		return op_mode;
@@ -910,6 +911,7 @@ static void iwl_op_mode_mvm_stop(struct iwl_op_mode *op_mode)
 
 	iwl_mvm_tof_clean(mvm);
 
+	iwl_fw_runtime_free(&mvm->fwrt);
 	mutex_destroy(&mvm->mutex);
 	mutex_destroy(&mvm->d0i3_suspend_mutex);
 
-- 
2.19.1

