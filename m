Return-Path: <SRS0=x8ok=SU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53317C10F0E
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 12:15:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 224BE217D7
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 12:15:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388893AbfDRMPw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Apr 2019 08:15:52 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:53910 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727807AbfDRMPv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Apr 2019 08:15:51 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1hH5xF-0007X3-Lm; Thu, 18 Apr 2019 15:15:50 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Thu, 18 Apr 2019 15:15:41 +0300
Message-Id: <20190418121544.32040-2-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190418121544.32040-1-luca@coelho.fi>
References: <20190418121544.32040-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 1/4] iwlwifi: mvm: don't attempt debug collection in rfkill
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

If we fail to initialize because rfkill is enabled, then trying
to do debug collection currently just fails. Prevent that in the
high-level code, although we should probably also fix the lower
level code to do things more carefully.

It's not 100% clear that it fixes this commit, as the original
dump code at the time might've been more careful. In any case,
we don't really need to dump anything in this expected scenario.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Fixes: 7125648074e8 ("iwlwifi: add fw dump upon RT ucode start failure")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c  | 4 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 00a47f6f1d81..ab68b5d53ec9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1121,7 +1121,9 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	ret = iwl_mvm_load_rt_fw(mvm);
 	if (ret) {
 		IWL_ERR(mvm, "Failed to start RT ucode: %d\n", ret);
-		iwl_fw_dbg_error_collect(&mvm->fwrt, FW_DBG_TRIGGER_DRIVER);
+		if (ret != -ERFKILL)
+			iwl_fw_dbg_error_collect(&mvm->fwrt,
+						 FW_DBG_TRIGGER_DRIVER);
 		goto error;
 	}
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index ba27dce4c2bb..13681b03c10e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -834,7 +834,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	mutex_lock(&mvm->mutex);
 	iwl_mvm_ref(mvm, IWL_MVM_REF_INIT_UCODE);
 	err = iwl_run_init_mvm_ucode(mvm, true);
-	if (err)
+	if (err && err != -ERFKILL)
 		iwl_fw_dbg_error_collect(&mvm->fwrt, FW_DBG_TRIGGER_DRIVER);
 	if (!iwlmvm_mod_params.init_dbg || !err)
 		iwl_mvm_stop_device(mvm);
-- 
2.20.1

