Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA586C282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:27:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA54D21019
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548170859;
	bh=Hk/tWkLMgt3bDf3fRUwUcXH+J/WLqvT4P8WbgWTB3Ck=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=Ks+6JGsA94AbNKLSMtwa/mDmvrNEB5Af3GcORiuR3N8+BTgYMDjarx1ipkJxvoXPP
	 hOkvZIHUochTQF8flZSUePRm4EDu6MaVrS3Na2LrdCHWrdSlslSVY/xFVDtu/RBE6t
	 G0BztCmpWC5WwCldRniU5lzCgPukY8Fnff03I5xo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729679AbfAVPWr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:22:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:35006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729653AbfAVPWm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 10:22:42 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA2E920879;
        Tue, 22 Jan 2019 15:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548170562;
        bh=Hk/tWkLMgt3bDf3fRUwUcXH+J/WLqvT4P8WbgWTB3Ck=;
        h=From:To:Cc:Subject:Date:From;
        b=qI8bpEuXv8TvfZGgYHPXafjroLnylu7ehV0lS7ZigR7eBzRxev/om45xnHJ2qQNxN
         zQn+HThXBPCrg/OX+GvpTNAQ7xD9wWK7YAe8TfXVjk9Z56WKw3phXIdJ41aFFEmHZ5
         OsJjFgzGWKz4Ei9eAdE5oF9+n1GDm/y+X3czCYeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: [PATCH] iwlwifi: iwl-drv: no need to check return value of debugfs_create functions
Date:   Tue, 22 Jan 2019 16:21:22 +0100
Message-Id: <20190122152151.16139-23-gregkh@linuxfoundation.org>
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
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 22 --------------------
 1 file changed, 22 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index bf1be985f36b..de03d1d9312f 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1207,11 +1207,6 @@ _iwl_op_mode_start(struct iwl_drv *drv, struct iwlwifi_opmode_table *op)
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	drv->dbgfs_op_mode = debugfs_create_dir(op->name,
 						drv->dbgfs_drv);
-	if (!drv->dbgfs_op_mode) {
-		IWL_ERR(drv,
-			"failed to create opmode debugfs directory\n");
-		return op_mode;
-	}
 	dbgfs_dir = drv->dbgfs_op_mode;
 #endif
 
@@ -1574,20 +1569,8 @@ struct iwl_drv *iwl_drv_start(struct iwl_trans *trans)
 	drv->dbgfs_drv = debugfs_create_dir(dev_name(trans->dev),
 					    iwl_dbgfs_root);
 
-	if (!drv->dbgfs_drv) {
-		IWL_ERR(drv, "failed to create debugfs directory\n");
-		ret = -ENOMEM;
-		goto err_free_tlv;
-	}
-
 	/* Create transport layer debugfs dir */
 	drv->trans->dbgfs_dir = debugfs_create_dir("trans", drv->dbgfs_drv);
-
-	if (!drv->trans->dbgfs_dir) {
-		IWL_ERR(drv, "failed to create transport debugfs directory\n");
-		ret = -ENOMEM;
-		goto err_free_dbgfs;
-	}
 #endif
 
 	ret = iwl_request_firmware(drv, true);
@@ -1600,9 +1583,7 @@ struct iwl_drv *iwl_drv_start(struct iwl_trans *trans)
 
 err_fw:
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-err_free_dbgfs:
 	debugfs_remove_recursive(drv->dbgfs_drv);
-err_free_tlv:
 	iwl_fw_dbg_free(drv->trans);
 #endif
 	kfree(drv);
@@ -1713,9 +1694,6 @@ static int __init iwl_drv_init(void)
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	/* Create the root of iwlwifi debugfs subsystem. */
 	iwl_dbgfs_root = debugfs_create_dir(DRV_NAME, NULL);
-
-	if (!iwl_dbgfs_root)
-		return -EFAULT;
 #endif
 
 	return iwl_pci_register_driver();
-- 
2.20.1

