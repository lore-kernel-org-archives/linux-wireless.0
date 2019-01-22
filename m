Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CA90C282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:27:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5841621019
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548170874;
	bh=nBrGcDE7Pw+pn4QyBLUB+9ZiL5OpjxRNjarc5YJWOQQ=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=OL4uWaLDPuaNYh1XdUXCCIGK4Fb0LtI942IJzrU0EW04gSYplkNDgzR+QSCmU74T3
	 uTsXTWJx58q0nj9wrKsTAlqjlVCiqTjq0obNbrLgnQZ3PKiltCxyvYiSOKZKUZghZB
	 JvUiT8nEaBMr2A9xik6jogme5MTiRANh9CXk8t+U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729621AbfAVPWe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:22:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:34708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729597AbfAVPWc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 10:22:32 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46A9220879;
        Tue, 22 Jan 2019 15:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548170551;
        bh=nBrGcDE7Pw+pn4QyBLUB+9ZiL5OpjxRNjarc5YJWOQQ=;
        h=From:To:Cc:Subject:Date:From;
        b=lsPLko11prSaTgOTkP3Birtd7uGSSkcJk1WmlDYfAtqWwQvpvEMO/8jguqi/d3nnI
         ZR306q6XFBnG6z5I1vU5AxsAupTBurpsVskzhl45KCCgUETu4cOXK5YtERC7wCRv6X
         hoK97zlBEYV8Au/CbvDBhqSUEE+Ih8PEt/o7avhQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: [PATCH] iwlwifi: dvm: no need to check return value of debugfs_create functions
Date:   Tue, 22 Jan 2019 16:21:19 +0100
Message-Id: <20190122152151.16139-20-gregkh@linuxfoundation.org>
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
 drivers/net/wireless/intel/iwlwifi/dvm/agn.h  |  9 ++--
 .../net/wireless/intel/iwlwifi/dvm/debugfs.c  | 44 ++-----------------
 drivers/net/wireless/intel/iwlwifi/dvm/main.c |  5 +--
 3 files changed, 8 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/agn.h b/drivers/net/wireless/intel/iwlwifi/dvm/agn.h
index 431e13c6ee35..254a5ce52456 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/agn.h
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/agn.h
@@ -439,13 +439,10 @@ static inline void iwl_dvm_set_pmi(struct iwl_priv *priv, bool state)
 }
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-int iwl_dbgfs_register(struct iwl_priv *priv, struct dentry *dbgfs_dir);
+void iwl_dbgfs_register(struct iwl_priv *priv, struct dentry *dbgfs_dir);
 #else
-static inline int iwl_dbgfs_register(struct iwl_priv *priv,
-				     struct dentry *dbgfs_dir)
-{
-	return 0;
-}
+static inline void iwl_dbgfs_register(struct iwl_priv *priv,
+				      struct dentry *dbgfs_dir) { }
 #endif /* CONFIG_IWLWIFI_DEBUGFS */
 
 #ifdef CONFIG_IWLWIFI_DEBUG
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
index 3d2e44a642de..2ee9e4e28dba 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
@@ -36,31 +36,8 @@
 
 /* create and remove of files */
 #define DEBUGFS_ADD_FILE(name, parent, mode) do {			\
-	if (!debugfs_create_file(#name, mode, parent, priv,		\
-				 &iwl_dbgfs_##name##_ops))		\
-		goto err;						\
-} while (0)
-
-#define DEBUGFS_ADD_BOOL(name, parent, ptr) do {			\
-	struct dentry *__tmp;						\
-	__tmp = debugfs_create_bool(#name, 0600, parent, ptr);		\
-	if (IS_ERR(__tmp) || !__tmp)					\
-		goto err;						\
-} while (0)
-
-#define DEBUGFS_ADD_X32(name, parent, ptr) do {				\
-	struct dentry *__tmp;						\
-	__tmp = debugfs_create_x32(#name, 0600, parent, ptr);		\
-	if (IS_ERR(__tmp) || !__tmp)					\
-		goto err;						\
-} while (0)
-
-#define DEBUGFS_ADD_U32(name, parent, ptr, mode) do {			\
-	struct dentry *__tmp;						\
-	__tmp = debugfs_create_u32(#name, mode,				\
-				   parent, ptr);			\
-	if (IS_ERR(__tmp) || !__tmp)					\
-		goto err;						\
+	debugfs_create_file(#name, mode, parent, priv,			\
+			    &iwl_dbgfs_##name##_ops);			\
 } while (0)
 
 /* file operation */
@@ -2347,21 +2324,15 @@ DEBUGFS_READ_WRITE_FILE_OPS(calib_disabled);
  * Create the debugfs files and directories
  *
  */
-int iwl_dbgfs_register(struct iwl_priv *priv, struct dentry *dbgfs_dir)
+void iwl_dbgfs_register(struct iwl_priv *priv, struct dentry *dbgfs_dir)
 {
 	struct dentry *dir_data, *dir_rf, *dir_debug;
 
 	priv->debugfs_dir = dbgfs_dir;
 
 	dir_data = debugfs_create_dir("data", dbgfs_dir);
-	if (!dir_data)
-		goto err;
 	dir_rf = debugfs_create_dir("rf", dbgfs_dir);
-	if (!dir_rf)
-		goto err;
 	dir_debug = debugfs_create_dir("debug", dbgfs_dir);
-	if (!dir_debug)
-		goto err;
 
 	DEBUGFS_ADD_FILE(nvm, dir_data, 0400);
 	DEBUGFS_ADD_FILE(sram, dir_data, 0600);
@@ -2421,13 +2392,6 @@ int iwl_dbgfs_register(struct iwl_priv *priv, struct dentry *dbgfs_dir)
 
 		snprintf(buf, 100, "../../%pd2", dev_dir);
 
-		if (!debugfs_create_symlink("iwlwifi", mac80211_dir, buf))
-			goto err;
+		debugfs_create_symlink("iwlwifi", mac80211_dir, buf);
 	}
-
-	return 0;
-
-err:
-	IWL_ERR(priv, "failed to create the dvm debugfs entries\n");
-	return -ENOMEM;
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/main.c b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
index c219bca5cff4..bd912b6a0b38 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -1509,13 +1509,10 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	if (iwlagn_mac_setup_register(priv, &fw->ucode_capa))
 		goto out_destroy_workqueue;
 
-	if (iwl_dbgfs_register(priv, dbgfs_dir))
-		goto out_mac80211_unregister;
+	iwl_dbgfs_register(priv, dbgfs_dir);
 
 	return op_mode;
 
-out_mac80211_unregister:
-	iwlagn_mac_unregister(priv);
 out_destroy_workqueue:
 	iwl_tt_exit(priv);
 	iwl_cancel_deferred_work(priv);
-- 
2.20.1

