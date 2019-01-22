Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D09C282C6
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:23:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C0D4217D6
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548170584;
	bh=8CaKk1YiZ5EpXj47z8uilPB4GkN41eABgNytxrs0mLg=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=xQVmpmgtwJP3R4p0Ml2s2F/THjz+r6llN7tdgQA78jZ+qJ+hKyUKA/ec7CRqJcaTr
	 jqP0xx8vZNdqV7zYB3YzmGEcluwHYqYfoNwEYD2KLE38Sd9Q6q/QgMsuUFYHUJtFYV
	 FDOIkTuNEYUo3CMg1ziD1cMEuQbsXRzNevRN9ztI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729773AbfAVPXD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:23:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:35530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729771AbfAVPXC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 10:23:02 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D11B4217D4;
        Tue, 22 Jan 2019 15:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548170581;
        bh=8CaKk1YiZ5EpXj47z8uilPB4GkN41eABgNytxrs0mLg=;
        h=From:To:Cc:Subject:Date:From;
        b=tPCRY7Dsa0uzvQoFi7cJMRdtNOPoJqdkollAHUU8v8pynWeqr6gAcFA0VYdNrOg2k
         kDC+g2lok4t3BxnG7jSjauv/0CClRRZhDnxn3gXXwxO6ZeRHKLuJ/0ktK4x3kZR7Tn
         zsAK0UnfMzpVwjGuprpxWgkc5eV629padH3w4qRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: [PATCH] b43: no need to check return value of debugfs_create functions
Date:   Tue, 22 Jan 2019 16:21:29 +0100
Message-Id: <20190122152151.16139-30-gregkh@linuxfoundation.org>
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

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Cc: b43-dev@lists.infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/b43/debugfs.c | 36 +++++----------------
 1 file changed, 8 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/debugfs.c b/drivers/net/wireless/broadcom/b43/debugfs.c
index 77046384dd80..976c8ec4e992 100644
--- a/drivers/net/wireless/broadcom/b43/debugfs.c
+++ b/drivers/net/wireless/broadcom/b43/debugfs.c
@@ -668,15 +668,13 @@ static void b43_remove_dynamic_debug(struct b43_wldev *dev)
 static void b43_add_dynamic_debug(struct b43_wldev *dev)
 {
 	struct b43_dfsentry *e = dev->dfsentry;
-	struct dentry *d;
 
-#define add_dyn_dbg(name, id, initstate) do {		\
-	e->dyn_debug[id] = (initstate);			\
-	d = debugfs_create_bool(name, 0600, e->subdir,	\
-				&(e->dyn_debug[id]));	\
-	if (!IS_ERR(d))					\
-		e->dyn_debug_dentries[id] = d;		\
-				} while (0)
+#define add_dyn_dbg(name, id, initstate) do {			\
+	e->dyn_debug[id] = (initstate);				\
+	e->dyn_debug_dentries[id] =				\
+		debugfs_create_bool(name, 0600, e->subdir,	\
+				&(e->dyn_debug[id]));		\
+	} while (0)
 
 	add_dyn_dbg("debug_xmitpower", B43_DBG_XMITPOWER, false);
 	add_dyn_dbg("debug_dmaoverflow", B43_DBG_DMAOVERFLOW, false);
@@ -718,19 +716,6 @@ void b43_debugfs_add_device(struct b43_wldev *dev)
 
 	snprintf(devdir, sizeof(devdir), "%s", wiphy_name(dev->wl->hw->wiphy));
 	e->subdir = debugfs_create_dir(devdir, rootdir);
-	if (!e->subdir || IS_ERR(e->subdir)) {
-		if (e->subdir == ERR_PTR(-ENODEV)) {
-			b43dbg(dev->wl, "DebugFS (CONFIG_DEBUG_FS) not "
-			       "enabled in kernel config\n");
-		} else {
-			b43err(dev->wl, "debugfs: cannot create %s directory\n",
-			       devdir);
-		}
-		dev->dfsentry = NULL;
-		kfree(log->log);
-		kfree(e);
-		return;
-	}
 
 	e->mmio16read_next = 0xFFFF; /* invalid address */
 	e->mmio32read_next = 0xFFFF; /* invalid address */
@@ -741,13 +726,10 @@ void b43_debugfs_add_device(struct b43_wldev *dev)
 
 #define ADD_FILE(name, mode)	\
 	do {							\
-		struct dentry *d;				\
-		d = debugfs_create_file(__stringify(name),	\
+		e->file_##name.dentry =				\
+			debugfs_create_file(__stringify(name),	\
 					mode, e->subdir, dev,	\
 					&fops_##name.fops);	\
-		e->file_##name.dentry = NULL;			\
-		if (!IS_ERR(d))					\
-			e->file_##name.dentry = d;		\
 	} while (0)
 
 
@@ -818,8 +800,6 @@ void b43_debugfs_log_txstat(struct b43_wldev *dev,
 void b43_debugfs_init(void)
 {
 	rootdir = debugfs_create_dir(KBUILD_MODNAME, NULL);
-	if (IS_ERR(rootdir))
-		rootdir = NULL;
 }
 
 void b43_debugfs_exit(void)
-- 
2.20.1

