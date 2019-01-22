Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2873C282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:27:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B08BE21019
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548170847;
	bh=Tz1YeAbVLwTmc/DeRS5sKPM1MCatSL6DfQQ4kWQo4C8=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=JMxOpX11JEpTfA58yOrvMJascaE+0U8yTK4dLDV8Km1nK0UzonOwaFHbHs6pysi15
	 Evs99r1qK0CB0CYe0ziogxPBkR5CbKYoEvDJ+L5ghQIlCXBrpXiYK7SXT/4OoT7+gk
	 2SVqowY6sm0mmYWEwVE8STS7WAaRrF9nWN6FMqZg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729441AbfAVP1X (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:27:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:35216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729708AbfAVPWv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 10:22:51 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A678C20879;
        Tue, 22 Jan 2019 15:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548170570;
        bh=Tz1YeAbVLwTmc/DeRS5sKPM1MCatSL6DfQQ4kWQo4C8=;
        h=From:To:Cc:Subject:Date:From;
        b=Vi7hIkuRN6aEIbAHABQPFxItQKuCdT8wTtjfPC1bWGxyHiZSYFS5mxzt6pkovWa5c
         dqZDEX7L5tDtfY+unzp1jFxl2koZu3mBYWqxpRVeMGbkFAJVT9SCR1kFAVEFu8Zvio
         MAJ+tDVl5bnd9ZtPvTX5tSDHf4A9OpEsT0rTKnII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH] ti: wl1251: no need to check return value of debugfs_create functions
Date:   Tue, 22 Jan 2019 16:21:25 +0100
Message-Id: <20190122152151.16139-26-gregkh@linuxfoundation.org>
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
Cc: Tony Lindgren <tony@atomide.com>
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ti/wl1251/debugfs.c | 59 ++----------------------
 1 file changed, 5 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/debugfs.c b/drivers/net/wireless/ti/wl1251/debugfs.c
index 448da1f8c22f..c99b23aaa70e 100644
--- a/drivers/net/wireless/ti/wl1251/debugfs.c
+++ b/drivers/net/wireless/ti/wl1251/debugfs.c
@@ -54,11 +54,6 @@ static const struct file_operations name## _ops = {			\
 #define DEBUGFS_ADD(name, parent)					\
 	wl->debugfs.name = debugfs_create_file(#name, 0400, parent,	\
 					       wl, &name## _ops);	\
-	if (IS_ERR(wl->debugfs.name)) {					\
-		ret = PTR_ERR(wl->debugfs.name);			\
-		wl->debugfs.name = NULL;				\
-		goto out;						\
-	}
 
 #define DEBUGFS_DEL(name)						\
 	do {								\
@@ -354,10 +349,8 @@ static void wl1251_debugfs_delete_files(struct wl1251 *wl)
 	DEBUGFS_DEL(excessive_retries);
 }
 
-static int wl1251_debugfs_add_files(struct wl1251 *wl)
+static void wl1251_debugfs_add_files(struct wl1251 *wl)
 {
-	int ret = 0;
-
 	DEBUGFS_FWSTATS_ADD(tx, internal_desc_overflow);
 
 	DEBUGFS_FWSTATS_ADD(rx, out_of_mem);
@@ -453,12 +446,6 @@ static int wl1251_debugfs_add_files(struct wl1251 *wl)
 	DEBUGFS_ADD(tx_queue_status, wl->debugfs.rootdir);
 	DEBUGFS_ADD(retry_count, wl->debugfs.rootdir);
 	DEBUGFS_ADD(excessive_retries, wl->debugfs.rootdir);
-
-out:
-	if (ret < 0)
-		wl1251_debugfs_delete_files(wl);
-
-	return ret;
 }
 
 void wl1251_debugfs_reset(struct wl1251 *wl)
@@ -471,56 +458,20 @@ void wl1251_debugfs_reset(struct wl1251 *wl)
 
 int wl1251_debugfs_init(struct wl1251 *wl)
 {
-	int ret;
+	wl->stats.fw_stats = kzalloc(sizeof(*wl->stats.fw_stats), GFP_KERNEL);
+	if (!wl->stats.fw_stats)
+		return -ENOMEM;
 
 	wl->debugfs.rootdir = debugfs_create_dir(KBUILD_MODNAME, NULL);
 
-	if (IS_ERR(wl->debugfs.rootdir)) {
-		ret = PTR_ERR(wl->debugfs.rootdir);
-		wl->debugfs.rootdir = NULL;
-		goto err;
-	}
-
 	wl->debugfs.fw_statistics = debugfs_create_dir("fw-statistics",
 						       wl->debugfs.rootdir);
 
-	if (IS_ERR(wl->debugfs.fw_statistics)) {
-		ret = PTR_ERR(wl->debugfs.fw_statistics);
-		wl->debugfs.fw_statistics = NULL;
-		goto err_root;
-	}
-
-	wl->stats.fw_stats = kzalloc(sizeof(*wl->stats.fw_stats),
-				      GFP_KERNEL);
-
-	if (!wl->stats.fw_stats) {
-		ret = -ENOMEM;
-		goto err_fw;
-	}
-
 	wl->stats.fw_stats_update = jiffies;
 
-	ret = wl1251_debugfs_add_files(wl);
-
-	if (ret < 0)
-		goto err_file;
+	wl1251_debugfs_add_files(wl);
 
 	return 0;
-
-err_file:
-	kfree(wl->stats.fw_stats);
-	wl->stats.fw_stats = NULL;
-
-err_fw:
-	debugfs_remove(wl->debugfs.fw_statistics);
-	wl->debugfs.fw_statistics = NULL;
-
-err_root:
-	debugfs_remove(wl->debugfs.rootdir);
-	wl->debugfs.rootdir = NULL;
-
-err:
-	return ret;
 }
 
 void wl1251_debugfs_exit(struct wl1251 *wl)
-- 
2.20.1

