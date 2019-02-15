Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C6F1C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49FE321929
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393743AbfBOLtl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 06:49:41 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:60446 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2436545AbfBOLtj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 06:49:39 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gubzs-0008TN-Jm; Fri, 15 Feb 2019 13:49:37 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Date:   Fri, 15 Feb 2019 13:49:13 +0200
Message-Id: <20190215114924.2545-10-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190215114924.2545-1-luca@coelho.fi>
References: <20190215114924.2545-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 09/20] iwlwifi: fw: no need to check return value of debugfs_create functions
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
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c | 11 +++--------
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.h |  9 +++------
 2 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
index 3e120dd47305..c1aa4360736b 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
@@ -173,9 +173,8 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {		\
 	_FWRT_DEBUGFS_READ_WRITE_FILE_OPS(name, bufsz, struct iwl_fw_runtime)
 
 #define FWRT_DEBUGFS_ADD_FILE_ALIAS(alias, name, parent, mode) do {	\
-	if (!debugfs_create_file(alias, mode, parent, fwrt,		\
-				 &iwl_dbgfs_##name##_ops))		\
-		goto err;						\
+	debugfs_create_file(alias, mode, parent, fwrt,			\
+			    &iwl_dbgfs_##name##_ops);			\
 	} while (0)
 #define FWRT_DEBUGFS_ADD_FILE(name, parent, mode) \
 	FWRT_DEBUGFS_ADD_FILE_ALIAS(#name, name, parent, mode)
@@ -321,14 +320,10 @@ static ssize_t iwl_dbgfs_send_hcmd_write(struct iwl_fw_runtime *fwrt, char *buf,
 
 FWRT_DEBUGFS_WRITE_FILE_OPS(send_hcmd, 512);
 
-int iwl_fwrt_dbgfs_register(struct iwl_fw_runtime *fwrt,
+void iwl_fwrt_dbgfs_register(struct iwl_fw_runtime *fwrt,
 			    struct dentry *dbgfs_dir)
 {
 	INIT_DELAYED_WORK(&fwrt->timestamp.wk, iwl_fw_timestamp_marker_wk);
 	FWRT_DEBUGFS_ADD_FILE(timestamp_marker, dbgfs_dir, 0200);
 	FWRT_DEBUGFS_ADD_FILE(send_hcmd, dbgfs_dir, 0200);
-	return 0;
-err:
-	IWL_ERR(fwrt, "Can't create the fwrt debugfs directory\n");
-	return -ENOMEM;
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.h b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.h
index 88255035e8ef..fde40ff88451 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.h
@@ -63,14 +63,11 @@
 #include "runtime.h"
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-int iwl_fwrt_dbgfs_register(struct iwl_fw_runtime *fwrt,
+void iwl_fwrt_dbgfs_register(struct iwl_fw_runtime *fwrt,
 			    struct dentry *dbgfs_dir);
 
 #else
-static inline int iwl_fwrt_dbgfs_register(struct iwl_fw_runtime *fwrt,
-					  struct dentry *dbgfs_dir)
-{
-	return 0;
-}
+static inline void iwl_fwrt_dbgfs_register(struct iwl_fw_runtime *fwrt,
+					   struct dentry *dbgfs_dir) { }
 
 #endif /* CONFIG_IWLWIFI_DEBUGFS */
-- 
2.20.1

