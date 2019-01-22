Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C2C5C282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:24:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C553217D6
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548170681;
	bh=D5zPW7w5hU6nCIZyErADRirT5vqubHja16L1TmqXObw=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=CjzSlXzj+prg78SlEX+ekW1kJa0/2wDwVZ6izU/tZ6Fodhyor4TRo1qb3PVpHrjD5
	 AKZ3XXG3penXFKjcsQvX3+7dXuNWaZtqmJdpdLF5stBeCxK5gonIjFuGiPsJ+zMw0m
	 vRIdW810ukM7UjWbqdNmDq2dLfGvnRGYi1sS5Wl4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730117AbfAVPY3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:24:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:38152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729476AbfAVPY1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 10:24:27 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 706E3217D6;
        Tue, 22 Jan 2019 15:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548170665;
        bh=D5zPW7w5hU6nCIZyErADRirT5vqubHja16L1TmqXObw=;
        h=From:To:Cc:Subject:Date:From;
        b=VYdVPf6s6E2boW+5GziFV74dxU8FUtJrZOZD5USxBtiZkS5nVzMMYZfLuSMS9yuml
         yYpy8+6sI7SCygeNcYUi0+Voq4ZvxYx7pvZgQLjnVoW1QkJry+Cl/5D4oWgYDV4+bG
         Oe++IAxRParu54HJZIPsVFRC1DAd3iZJADsvXgj4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: [PATCH] brcm80211: no need to check return value of debugfs_create functions
Date:   Tue, 22 Jan 2019 16:21:31 +0100
Message-Id: <20190122152151.16139-32-gregkh@linuxfoundation.org>
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

Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>
Cc: Hante Meuleman <hante.meuleman@broadcom.com>
Cc: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Cc: Wright Feng <wright.feng@cypress.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list.pdl@broadcom.com
Cc: brcm80211-dev-list@cypress.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../broadcom/brcm80211/brcmsmac/debug.c       | 26 +++----------------
 .../broadcom/brcm80211/brcmsmac/debug.h       |  2 +-
 2 files changed, 5 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/debug.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/debug.c
index 3bd54f125776..6d776ef6ff54 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/debug.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/debug.c
@@ -37,27 +37,18 @@ static struct dentry *root_folder;
 void brcms_debugfs_init(void)
 {
 	root_folder = debugfs_create_dir(KBUILD_MODNAME, NULL);
-	if (IS_ERR(root_folder))
-		root_folder = NULL;
 }
 
 void brcms_debugfs_exit(void)
 {
-	if (!root_folder)
-		return;
-
 	debugfs_remove_recursive(root_folder);
 	root_folder = NULL;
 }
 
-int brcms_debugfs_attach(struct brcms_pub *drvr)
+void brcms_debugfs_attach(struct brcms_pub *drvr)
 {
-	if (!root_folder)
-		return -ENODEV;
-
 	drvr->dbgfs_dir = debugfs_create_dir(
 		 dev_name(&drvr->wlc->hw->d11core->dev), root_folder);
-	return PTR_ERR_OR_ZERO(drvr->dbgfs_dir);
 }
 
 void brcms_debugfs_detach(struct brcms_pub *drvr)
@@ -195,7 +186,7 @@ static const struct file_operations brcms_debugfs_def_ops = {
 	.llseek = seq_lseek
 };
 
-static int
+static void
 brcms_debugfs_add_entry(struct brcms_pub *drvr, const char *fn,
 			int (*read_fn)(struct seq_file *seq, void *data))
 {
@@ -203,27 +194,18 @@ brcms_debugfs_add_entry(struct brcms_pub *drvr, const char *fn,
 	struct dentry *dentry =  drvr->dbgfs_dir;
 	struct brcms_debugfs_entry *entry;
 
-	if (IS_ERR_OR_NULL(dentry))
-		return -ENOENT;
-
 	entry = devm_kzalloc(dev, sizeof(*entry), GFP_KERNEL);
 	if (!entry)
-		return -ENOMEM;
+		return;
 
 	entry->read = read_fn;
 	entry->drvr = drvr;
 
-	dentry = debugfs_create_file(fn, 0444, dentry, entry,
-				     &brcms_debugfs_def_ops);
-
-	return PTR_ERR_OR_ZERO(dentry);
+	debugfs_create_file(fn, 0444, dentry, entry, &brcms_debugfs_def_ops);
 }
 
 void brcms_debugfs_create_files(struct brcms_pub *drvr)
 {
-	if (IS_ERR_OR_NULL(drvr->dbgfs_dir))
-		return;
-
 	brcms_debugfs_add_entry(drvr, "hardware", brcms_debugfs_hardware_read);
 	brcms_debugfs_add_entry(drvr, "macstat", brcms_debugfs_macstat_read);
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/debug.h b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/debug.h
index 822781cf15d4..56898e6d789d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/debug.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/debug.h
@@ -68,7 +68,7 @@ void __brcms_dbg(struct device *dev, u32 level, const char *func,
 struct brcms_pub;
 void brcms_debugfs_init(void);
 void brcms_debugfs_exit(void);
-int brcms_debugfs_attach(struct brcms_pub *drvr);
+void brcms_debugfs_attach(struct brcms_pub *drvr);
 void brcms_debugfs_detach(struct brcms_pub *drvr);
 struct dentry *brcms_debugfs_get_devdir(struct brcms_pub *drvr);
 void brcms_debugfs_create_files(struct brcms_pub *drvr);
-- 
2.20.1

