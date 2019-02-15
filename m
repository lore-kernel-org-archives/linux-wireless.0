Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5A2AC10F02
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:49:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B2E921929
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:49:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436629AbfBOLtj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 06:49:39 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:60436 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2436494AbfBOLti (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 06:49:38 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gubzr-0008TN-Kl; Fri, 15 Feb 2019 13:49:36 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Date:   Fri, 15 Feb 2019 13:49:12 +0200
Message-Id: <20190215114924.2545-9-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190215114924.2545-1-luca@coelho.fi>
References: <20190215114924.2545-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 08/20] iwlwifi: dvm: no need to check return value of debugfs_create functions
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
index e64cdafc5623..d4b19673b06a 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
@@ -37,31 +37,8 @@
 
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
@@ -2348,21 +2325,15 @@ DEBUGFS_READ_WRITE_FILE_OPS(calib_disabled);
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
@@ -2422,13 +2393,6 @@ int iwl_dbgfs_register(struct iwl_priv *priv, struct dentry *dbgfs_dir)
 
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
index 114f0ab022a7..7c68a86ed9e1 100644
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

