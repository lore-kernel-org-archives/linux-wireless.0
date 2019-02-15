Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E01DC4360F
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:49:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1824921929
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:49:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbfBOLtm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 06:49:42 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:60472 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2436494AbfBOLtl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 06:49:41 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gubzt-0008TN-Gm; Fri, 15 Feb 2019 13:49:37 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Date:   Fri, 15 Feb 2019 13:49:14 +0200
Message-Id: <20190215114924.2545-11-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190215114924.2545-1-luca@coelho.fi>
References: <20190215114924.2545-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 10/20] iwlwifi: iwl-drv: no need to check return value of debugfs_create functions
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
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 22 --------------------
 1 file changed, 22 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 4b75a93c7364..689a65b11cc3 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1253,11 +1253,6 @@ _iwl_op_mode_start(struct iwl_drv *drv, struct iwlwifi_opmode_table *op)
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
 
@@ -1620,20 +1615,8 @@ struct iwl_drv *iwl_drv_start(struct iwl_trans *trans)
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
@@ -1646,9 +1629,7 @@ struct iwl_drv *iwl_drv_start(struct iwl_trans *trans)
 
 err_fw:
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-err_free_dbgfs:
 	debugfs_remove_recursive(drv->dbgfs_drv);
-err_free_tlv:
 	iwl_fw_dbg_free(drv->trans);
 #endif
 	kfree(drv);
@@ -1759,9 +1740,6 @@ static int __init iwl_drv_init(void)
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

