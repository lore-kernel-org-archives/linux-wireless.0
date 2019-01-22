Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C7BEC282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:27:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F16E721019
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548170855;
	bh=TbYRExZuIfzRcn4mCV5OtcYXDb+ooEgdD1g1TTi3r1Y=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=R60FQeo8rvAVi9jFx56CZNaGgdCCBtFe4/xUaHNjuDty+3ds2aFwhc1XMz30BauCN
	 QRi2YZnIrKm9bIVtQ8ymUoPon7M7e5KFQZTeerBUK97+QJrwmqFrK8LAFWUtVNN5FG
	 Zu47wQ3tm9vX00w8sqvRn7oWJiaF03kC7Q7IQuv0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729698AbfAVPWt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:22:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:35146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729676AbfAVPWs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 10:22:48 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1630B217D6;
        Tue, 22 Jan 2019 15:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548170567;
        bh=TbYRExZuIfzRcn4mCV5OtcYXDb+ooEgdD1g1TTi3r1Y=;
        h=From:To:Cc:Subject:Date:From;
        b=rZtbmfv9xFEBWYF+/6UW21z3+FDJHYKsnlhq0xEK7o/yl6tOKApXgbbfzKy/6MeT0
         qUX8JcQsPJ3Zs8h/MedtH91r33w6b6iqoXKtwYk29iB0cX8DtpGgVdYXO6rwRWuVJI
         ozvBdlPE0MnrdblVB1XGiAmztm6fw+FUugvQ6+lM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH] ti: wlcore: no need to check return value of debugfs_create functions
Date:   Tue, 22 Jan 2019 16:21:24 +0100
Message-Id: <20190122152151.16139-25-gregkh@linuxfoundation.org>
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
 drivers/net/wireless/ti/wlcore/debugfs.c | 28 ++++--------------------
 drivers/net/wireless/ti/wlcore/debugfs.h | 10 +++------
 2 files changed, 7 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
index aeb74e74698e..68acd901d384 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -1301,11 +1301,10 @@ static const struct file_operations fw_logger_ops = {
 	.llseek = default_llseek,
 };
 
-static int wl1271_debugfs_add_files(struct wl1271 *wl,
-				    struct dentry *rootdir)
+static void wl1271_debugfs_add_files(struct wl1271 *wl,
+				     struct dentry *rootdir)
 {
-	int ret = 0;
-	struct dentry *entry, *streaming;
+	struct dentry *streaming;
 
 	DEBUGFS_ADD(tx_queue_len, rootdir);
 	DEBUGFS_ADD(retry_count, rootdir);
@@ -1330,23 +1329,11 @@ static int wl1271_debugfs_add_files(struct wl1271 *wl,
 	DEBUGFS_ADD(fw_logger, rootdir);
 
 	streaming = debugfs_create_dir("rx_streaming", rootdir);
-	if (!streaming || IS_ERR(streaming))
-		goto err;
 
 	DEBUGFS_ADD_PREFIX(rx_streaming, interval, streaming);
 	DEBUGFS_ADD_PREFIX(rx_streaming, always, streaming);
 
 	DEBUGFS_ADD_PREFIX(dev, mem, rootdir);
-
-	return 0;
-
-err:
-	if (IS_ERR(entry))
-		ret = PTR_ERR(entry);
-	else
-		ret = -ENOMEM;
-
-	return ret;
 }
 
 void wl1271_debugfs_reset(struct wl1271 *wl)
@@ -1367,11 +1354,6 @@ int wl1271_debugfs_init(struct wl1271 *wl)
 	rootdir = debugfs_create_dir(KBUILD_MODNAME,
 				     wl->hw->wiphy->debugfsdir);
 
-	if (IS_ERR(rootdir)) {
-		ret = PTR_ERR(rootdir);
-		goto out;
-	}
-
 	wl->stats.fw_stats = kzalloc(wl->stats.fw_stats_len, GFP_KERNEL);
 	if (!wl->stats.fw_stats) {
 		ret = -ENOMEM;
@@ -1380,9 +1362,7 @@ int wl1271_debugfs_init(struct wl1271 *wl)
 
 	wl->stats.fw_stats_update = jiffies;
 
-	ret = wl1271_debugfs_add_files(wl, rootdir);
-	if (ret < 0)
-		goto out_exit;
+	wl1271_debugfs_add_files(wl, rootdir);
 
 	ret = wlcore_debugfs_init(wl, rootdir);
 	if (ret < 0)
diff --git a/drivers/net/wireless/ti/wlcore/debugfs.h b/drivers/net/wireless/ti/wlcore/debugfs.h
index bf14676e6515..a4952c4f587e 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.h
+++ b/drivers/net/wireless/ti/wlcore/debugfs.h
@@ -53,19 +53,15 @@ static const struct file_operations name## _ops = {			\
 
 #define DEBUGFS_ADD(name, parent)					\
 	do {								\
-		entry = debugfs_create_file(#name, 0400, parent,	\
-					    wl, &name## _ops);		\
-		if (!entry || IS_ERR(entry))				\
-			goto err;					\
+		debugfs_create_file(#name, 0400, parent,		\
+				    wl, &name## _ops);			\
 	} while (0)
 
 
 #define DEBUGFS_ADD_PREFIX(prefix, name, parent)			\
 	do {								\
-		entry = debugfs_create_file(#name, 0400, parent,	\
+		debugfs_create_file(#name, 0400, parent,		\
 				    wl, &prefix## _## name## _ops);	\
-		if (!entry || IS_ERR(entry))				\
-			goto err;					\
 	} while (0)
 
 #define DEBUGFS_FWSTATS_FILE(sub, name, fmt, struct_type)		\
-- 
2.20.1

