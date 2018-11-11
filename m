Return-Path: <SRS0=Soq1=NW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6EBDC0044C
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 20:07:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98510214DB
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 20:07:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 98510214DB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731543AbeKLF5M (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 00:57:12 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:35938 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731240AbeKLF5L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 00:57:11 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gLw1F-0000JG-EY; Sun, 11 Nov 2018 22:07:41 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, Lior Cohen <lior2.cohen@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sun, 11 Nov 2018 22:07:21 +0200
Message-Id: <20181111200732.8159-6-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181111200732.8159-1-luca@coelho.fi>
References: <20181111200732.8159-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 05/16] iwlwifi: add fw dump upon RT ucode start failure
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lior Cohen <lior2.cohen@intel.com>

FW dump was missing in case the RT FW ucode
section failed to load. This failure happens when
the RT section of the FW file is corrupted.

Signed-off-by: Lior Cohen <lior2.cohen@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 8 ++++++++
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h | 1 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 2 ++
 3 files changed, 11 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 6243b503d0b0..efd4ac5bba73 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -998,6 +998,14 @@ const struct iwl_fw_dump_desc iwl_dump_desc_assert = {
 };
 IWL_EXPORT_SYMBOL(iwl_dump_desc_assert);
 
+void iwl_fw_assert_error_dump(struct iwl_fw_runtime *fwrt)
+{
+	IWL_INFO(fwrt, "error dump due to fw assert\n");
+	fwrt->dump.desc = &iwl_dump_desc_assert;
+	iwl_fw_error_dump(fwrt);
+}
+IWL_EXPORT_SYMBOL(iwl_fw_assert_error_dump);
+
 void iwl_fw_alive_error_dump(struct iwl_fw_runtime *fwrt)
 {
 	struct iwl_fw_dump_desc *iwl_dump_desc_no_alive =
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index 4a5fa05c7ac2..544b42f9fb19 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -378,6 +378,7 @@ static inline void iwl_fw_resume_timestamp(struct iwl_fw_runtime *fwrt) {}
 
 #endif /* CONFIG_IWLWIFI_DEBUGFS */
 
+void iwl_fw_assert_error_dump(struct iwl_fw_runtime *fwrt);
 void iwl_fw_alive_error_dump(struct iwl_fw_runtime *fwrt);
 void iwl_fw_dbg_collect_sync(struct iwl_fw_runtime *fwrt);
 #endif  /* __iwl_fw_dbg_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index dade206d5511..2cd07247e0a7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -407,6 +407,7 @@ static int iwl_run_unified_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 	ret = iwl_mvm_load_ucode_wait_alive(mvm, IWL_UCODE_REGULAR);
 	if (ret) {
 		IWL_ERR(mvm, "Failed to start RT ucode: %d\n", ret);
+		iwl_fw_assert_error_dump(&mvm->fwrt);
 		goto error;
 	}
 
@@ -1024,6 +1025,7 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	ret = iwl_mvm_load_rt_fw(mvm);
 	if (ret) {
 		IWL_ERR(mvm, "Failed to start RT ucode: %d\n", ret);
+		iwl_fw_assert_error_dump(&mvm->fwrt);
 		goto error;
 	}
 
-- 
2.19.1

