Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DDBCC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 14:00:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB5A0218A5
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 14:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbfCVOAU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 10:00:20 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:46260 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727725AbfCVOAT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 10:00:19 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h7Khk-0000bK-DW; Fri, 22 Mar 2019 15:59:28 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Date:   Fri, 22 Mar 2019 15:58:58 +0200
Message-Id: <20190322135903.10631-20-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190322135903.10631-1-luca@coelho.fi>
References: <20190322135903.10631-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 19/24] iwlwifi: pcie: no need to check return value of debugfs_create functions
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: Intel Linux Wireless <linuxwifi@intel.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  6 +-----
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  7 ++-----
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 12 +++---------
 3 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 2b94e4cef56c..d7b866e0e7ae 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1046,9 +1046,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	/* register transport layer debugfs here */
-	ret = iwl_trans_pcie_dbgfs_register(iwl_trans);
-	if (ret)
-		goto out_free_drv;
+	iwl_trans_pcie_dbgfs_register(iwl_trans);
 
 	/* if RTPM is in use, enable it in our device */
 	if (iwl_trans->runtime_pm_mode != IWL_PLAT_PM_MODE_DISABLED) {
@@ -1077,8 +1075,6 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	return 0;
 
-out_free_drv:
-	iwl_drv_stop(iwl_trans->drv);
 out_free_trans:
 	iwl_trans_pcie_free(iwl_trans);
 	return ret;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 5b5a77a66921..860259e65553 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -1030,12 +1030,9 @@ void iwl_trans_pcie_dump_regs(struct iwl_trans *trans);
 void iwl_trans_sync_nmi(struct iwl_trans *trans);
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans);
+void iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans);
 #else
-static inline int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans)
-{
-	return 0;
-}
+static inline void iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans) { }
 #endif
 
 int iwl_pci_fw_exit_d0i3(struct iwl_trans *trans);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 2915840c8b95..cfaad360c823 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2442,9 +2442,8 @@ void iwl_pcie_dump_csr(struct iwl_trans *trans)
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 /* create and remove of files */
 #define DEBUGFS_ADD_FILE(name, parent, mode) do {			\
-	if (!debugfs_create_file(#name, mode, parent, trans,		\
-				 &iwl_dbgfs_##name##_ops))		\
-		goto err;						\
+	debugfs_create_file(#name, mode, parent, trans,			\
+			    &iwl_dbgfs_##name##_ops);			\
 } while (0)
 
 /* file operation */
@@ -2847,7 +2846,7 @@ static const struct file_operations iwl_dbgfs_monitor_data_ops = {
 };
 
 /* Create the debugfs files and directories */
-int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans)
+void iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans)
 {
 	struct dentry *dir = trans->dbgfs_dir;
 
@@ -2858,11 +2857,6 @@ int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans)
 	DEBUGFS_ADD_FILE(fh_reg, dir, 0400);
 	DEBUGFS_ADD_FILE(rfkill, dir, 0600);
 	DEBUGFS_ADD_FILE(monitor_data, dir, 0400);
-	return 0;
-
-err:
-	IWL_ERR(trans, "failed to create the trans debugfs entry\n");
-	return -ENOMEM;
 }
 
 static void iwl_trans_pcie_debugfs_cleanup(struct iwl_trans *trans)
-- 
2.20.1

