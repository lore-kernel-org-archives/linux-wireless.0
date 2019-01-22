Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64CBDC282C5
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:27:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 335F021019
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548170864;
	bh=HS4aXKQmebGrdsMiif7Y1nQunYRDgADCZwklnp4H9cY=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=rAkaKw1tvs2jKJ/rdqMzN66oxyWg3El8VDox2NcpNn7bbeAntHNYM1gZiMQih743R
	 9hyIvh0Juz2K0/xaEH9gnxzAy/K5sQ2gnTYf8c4B6gCyG3VmahFV6+OSjzc1yzMHqo
	 5cCYCmLOg7NY7wiZZAWtaW2EFFFkI06Apwu7Byl4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729656AbfAVPWm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:22:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:34926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729648AbfAVPWk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 10:22:40 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19412217D4;
        Tue, 22 Jan 2019 15:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548170559;
        bh=HS4aXKQmebGrdsMiif7Y1nQunYRDgADCZwklnp4H9cY=;
        h=From:To:Cc:Subject:Date:From;
        b=eFU1icmhN+Mfb3d3Di2rrcOpwNjlR3+2bVWhhHNDQThA/UfgOS1BYbIhsmPSOg8be
         4WDVtL41d2/FPapQSRKTqqfGIuO5tWT7TXHjO2zlbi3Zni2Y/qMXEF+1XjFdhrtaGr
         7qBFgE08W87iStFbWVn9lyKeEolfv+7ZaFY/18Jk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: [PATCH] iwlwifi: fw: no need to check return value of debugfs_create functions
Date:   Tue, 22 Jan 2019 16:21:21 +0100
Message-Id: <20190122152151.16139-22-gregkh@linuxfoundation.org>
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

