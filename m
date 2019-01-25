Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F24B1C282C0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 20:13:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAB5F218B0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 20:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729060AbfAYUNV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 15:13:21 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:50832 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726991AbfAYUNU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 15:13:20 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gn7qo-00010a-Jd; Fri, 25 Jan 2019 22:13:19 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 25 Jan 2019 22:12:57 +0200
Message-Id: <20190125201305.5616-10-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190125201305.5616-1-luca@coelho.fi>
References: <20190125201305.5616-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 09/17] iwlwifi: mvm: save and export regdb blob from the NVM
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Sometimes we want to debug issues related to the regulatory blob in
the NVM.  To make that easier, add a debugfs entry to export it
together with the other nvm blobs we export.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h     | 1 +
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c     | 5 +++++
 3 files changed, 9 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 514aaec6d59e..cbbd4b076e17 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -2028,6 +2028,9 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 	if (!debugfs_create_blob("nvm_phy_sku", 0400,
 				 mvm->debugfs_dir, &mvm->nvm_phy_sku_blob))
 		goto err;
+	if (!debugfs_create_blob("nvm_reg", S_IRUSR,
+				 mvm->debugfs_dir, &mvm->nvm_reg_blob))
+		goto err;
 
 	debugfs_create_file("mem", 0600, dbgfs_dir, mvm, &iwl_dbgfs_mem_ops);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 503e51d32e7f..c314f77f657f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -965,6 +965,7 @@ struct iwl_mvm {
 	struct debugfs_blob_wrapper nvm_calib_blob;
 	struct debugfs_blob_wrapper nvm_prod_blob;
 	struct debugfs_blob_wrapper nvm_phy_sku_blob;
+	struct debugfs_blob_wrapper nvm_reg_blob;
 
 	struct iwl_mvm_frame_stats drv_rx_stats;
 	spinlock_t drv_stats_lock;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
index f08934b03cf3..7bdbd010ae6b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
@@ -416,6 +416,11 @@ int iwl_nvm_init(struct iwl_mvm *mvm)
 			mvm->nvm_phy_sku_blob.data = temp;
 			mvm->nvm_phy_sku_blob.size  = ret;
 			break;
+		case NVM_SECTION_TYPE_REGULATORY_SDP:
+		case NVM_SECTION_TYPE_REGULATORY:
+			mvm->nvm_reg_blob.data = temp;
+			mvm->nvm_reg_blob.size  = ret;
+			break;
 		default:
 			if (section == mvm->cfg->nvm_hw_section_num) {
 				mvm->nvm_hw_blob.data = temp;
-- 
2.20.1

