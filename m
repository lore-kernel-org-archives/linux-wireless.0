Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83DCCC282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:28:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53751217D6
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548170881;
	bh=vJt3fJtaSvAhSbSKziKYEFt4JWMeK///oumcWnn9Uhs=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=XCsN7xk5b1mzKzbveUTLdNul2Kvbg8c8MJFJfVlmNh2CXkaRhcA3zbavMNeJuJrDq
	 Er1U8a9x5f1FRpCWRIuWOxqZdmQ/lrd+9jOVBQCGiRlfQB/f/XULe0AQQf5XLN0B2F
	 KaCHfIfl8kxKAz3jGx5MqMb3LhguipOpeTQvudiA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729585AbfAVPWa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:22:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:34644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729244AbfAVPWa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 10:22:30 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6430E217D4;
        Tue, 22 Jan 2019 15:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548170548;
        bh=vJt3fJtaSvAhSbSKziKYEFt4JWMeK///oumcWnn9Uhs=;
        h=From:To:Cc:Subject:Date:From;
        b=XRl/HRFPoeZ1nonjHkieZYOdVgfG/cAY7HVqISRCOJor5QQWPxOkzyCATB3Ph01L0
         XJ/sGqpRF/apYKnypLZK0N9bjciw/4HOcCNtN6RVqO+BEIehIQsDPSXEkXdAy9BG2V
         HciqLp0LrZPk6CoCdvoRJ9gIAP2zV3Ff/Ifqv5J8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: [PATCH] iwlegacy: no need to check return value of debugfs_create functions
Date:   Tue, 22 Jan 2019 16:21:18 +0100
Message-Id: <20190122152151.16139-19-gregkh@linuxfoundation.org>
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

Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../net/wireless/intel/iwlegacy/3945-mac.c    |  5 +--
 .../net/wireless/intel/iwlegacy/4965-mac.c    |  5 +--
 drivers/net/wireless/intel/iwlegacy/common.h  |  6 ++--
 drivers/net/wireless/intel/iwlegacy/debug.c   | 34 +++----------------
 4 files changed, 8 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/3945-mac.c b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
index 57e3b6cca234..271977f7fbb0 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
@@ -3756,10 +3756,7 @@ il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto out_remove_sysfs;
 
-	err = il_dbgfs_register(il, DRV_NAME);
-	if (err)
-		IL_ERR("failed to create debugfs files. Ignoring error: %d\n",
-		       err);
+	il_dbgfs_register(il, DRV_NAME);
 
 	/* Start monitoring the killswitch */
 	queue_delayed_work(il->workqueue, &il->_3945.rfkill_poll, 2 * HZ);
diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
index 6b4488a178a7..94222ae464ae 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -4988,10 +4988,7 @@ il4965_ucode_callback(const struct firmware *ucode_raw, void *context)
 	if (err)
 		goto out_unbind;
 
-	err = il_dbgfs_register(il, DRV_NAME);
-	if (err)
-		IL_ERR("failed to create debugfs files. Ignoring error: %d\n",
-		       err);
+	il_dbgfs_register(il, DRV_NAME);
 
 	err = sysfs_create_group(&il->pci_dev->dev.kobj, &il_attribute_group);
 	if (err) {
diff --git a/drivers/net/wireless/intel/iwlegacy/common.h b/drivers/net/wireless/intel/iwlegacy/common.h
index dc6a74a05983..b079c64ca014 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.h
+++ b/drivers/net/wireless/intel/iwlegacy/common.h
@@ -2974,13 +2974,11 @@ il_print_hex_dump(struct il_priv *il, int level, const void *p, u32 len)
 #endif /* CONFIG_IWLEGACY_DEBUG */
 
 #ifdef CONFIG_IWLEGACY_DEBUGFS
-int il_dbgfs_register(struct il_priv *il, const char *name);
+void il_dbgfs_register(struct il_priv *il, const char *name);
 void il_dbgfs_unregister(struct il_priv *il);
 #else
-static inline int
-il_dbgfs_register(struct il_priv *il, const char *name)
+static inline void il_dbgfs_register(struct il_priv *il, const char *name)
 {
-	return 0;
 }
 
 static inline void
diff --git a/drivers/net/wireless/intel/iwlegacy/debug.c b/drivers/net/wireless/intel/iwlegacy/debug.c
index d76073def677..fa211412e0ac 100644
--- a/drivers/net/wireless/intel/iwlegacy/debug.c
+++ b/drivers/net/wireless/intel/iwlegacy/debug.c
@@ -128,23 +128,12 @@ EXPORT_SYMBOL(il_update_stats);
 
 /* create and remove of files */
 #define DEBUGFS_ADD_FILE(name, parent, mode) do {			\
-	if (!debugfs_create_file(#name, mode, parent, il,		\
-			 &il_dbgfs_##name##_ops))		\
-		goto err;						\
+	debugfs_create_file(#name, mode, parent, il,			\
+			    &il_dbgfs_##name##_ops);			\
 } while (0)
 
 #define DEBUGFS_ADD_BOOL(name, parent, ptr) do {			\
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
+	debugfs_create_bool(#name, 0600, parent, ptr);			\
 } while (0)
 
 /* file operation */
@@ -1341,27 +1330,18 @@ DEBUGFS_WRITE_FILE_OPS(wd_timeout);
  * Create the debugfs files and directories
  *
  */
-int
+void
 il_dbgfs_register(struct il_priv *il, const char *name)
 {
 	struct dentry *phyd = il->hw->wiphy->debugfsdir;
 	struct dentry *dir_drv, *dir_data, *dir_rf, *dir_debug;
 
 	dir_drv = debugfs_create_dir(name, phyd);
-	if (!dir_drv)
-		return -ENOMEM;
-
 	il->debugfs_dir = dir_drv;
 
 	dir_data = debugfs_create_dir("data", dir_drv);
-	if (!dir_data)
-		goto err;
 	dir_rf = debugfs_create_dir("rf", dir_drv);
-	if (!dir_rf)
-		goto err;
 	dir_debug = debugfs_create_dir("debug", dir_drv);
-	if (!dir_debug)
-		goto err;
 
 	DEBUGFS_ADD_FILE(nvm, dir_data, 0400);
 	DEBUGFS_ADD_FILE(sram, dir_data, 0600);
@@ -1399,12 +1379,6 @@ il_dbgfs_register(struct il_priv *il, const char *name)
 		DEBUGFS_ADD_BOOL(disable_chain_noise, dir_rf,
 				 &il->disable_chain_noise_cal);
 	DEBUGFS_ADD_BOOL(disable_tx_power, dir_rf, &il->disable_tx_power_cal);
-	return 0;
-
-err:
-	IL_ERR("Can't create the debugfs directory\n");
-	il_dbgfs_unregister(il);
-	return -ENOMEM;
 }
 EXPORT_SYMBOL(il_dbgfs_register);
 
-- 
2.20.1

