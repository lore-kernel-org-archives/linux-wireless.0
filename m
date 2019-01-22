Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCC2AC282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A85A320879
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548170559;
	bh=yDF6uYI7JuPh/gtYRkd9uGrw8g/KMx5XSdM602NkI2o=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=gKZPYylod1BxT4CvXuR/rYUZeluQ4X52Ff1MMWjgPuvliSVaS3g5OKv1eI1oySR92
	 zEfE8is+xvLz1kyYhm4+HjtJm0eBkt8t+Y18HpxMx3YNU/ZdWE4+9s6Uu852wwvSyI
	 fXpP8+ShDqd5IYL9vXvBx5mDgW0ILO0jowtE+bdA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729015AbfAVPWi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:22:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:34824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729597AbfAVPWh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 10:22:37 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6705420879;
        Tue, 22 Jan 2019 15:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548170556;
        bh=yDF6uYI7JuPh/gtYRkd9uGrw8g/KMx5XSdM602NkI2o=;
        h=From:To:Cc:Subject:Date:From;
        b=i0xzBL2RXNLUh0cmsUfyOboVZrSHyOmDksJEeSj8hFNf9OkVt1H25KslA/M5DaW7G
         T1dAyVfqImvsSh++j2o21B092lHviJlYZXQDf4VCK25O5kdzckylxS8Ye3W/0ipcO7
         xErQl/u4cxquldyiT4kckCjsFjXzXSAO6JWPrL1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: [PATCH] iwlwifi: pcie: no need to check return value of debugfs_create functions
Date:   Tue, 22 Jan 2019 16:21:20 +0100
Message-Id: <20190122152151.16139-21-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

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
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  6 +-----
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  7 ++-----
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 12 +++---------
 3 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 353581ccc01e..61e9be5068f5 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -971,9 +971,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	/* register transport layer debugfs here */
-	ret = iwl_trans_pcie_dbgfs_register(iwl_trans);
-	if (ret)
-		goto out_free_drv;
+	iwl_trans_pcie_dbgfs_register(iwl_trans);
 
 	/* if RTPM is in use, enable it in our device */
 	if (iwl_trans->runtime_pm_mode != IWL_PLAT_PM_MODE_DISABLED) {
@@ -1002,8 +1000,6 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	return 0;
 
-out_free_drv:
-	iwl_drv_stop(iwl_trans->drv);
 out_free_trans:
 	iwl_trans_pcie_free(iwl_trans);
 	return ret;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index d6fc6ce73e0a..2d3a8578a50d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -1018,12 +1018,9 @@ void iwl_trans_pcie_rf_kill(struct iwl_trans *trans, bool state);
 void iwl_trans_pcie_dump_regs(struct iwl_trans *trans);
 
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
index f97aea5ffc44..89e58e43ed03 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2464,9 +2464,8 @@ void iwl_pcie_dump_csr(struct iwl_trans *trans)
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
@@ -2869,7 +2868,7 @@ static const struct file_operations iwl_dbgfs_monitor_data_ops = {
 };
 
 /* Create the debugfs files and directories */
-int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans)
+void iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans)
 {
 	struct dentry *dir = trans->dbgfs_dir;
 
@@ -2880,11 +2879,6 @@ int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans)
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

