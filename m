Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB12C282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:27:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 552F621019
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548170839;
	bh=4t21YB1g2/PDm6iWXX9iM2C0d6tNcceYgtR7rP0G9RA=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=hH6oQiYusrDfDMxUAy/4bWSWyV4URfjG4ZcEtced4ncNGMYI4aCc1PNdI4psVZfkK
	 8MW90grVPh3LwCv/RqEltA0ANNgDPW4mLfU0ZIzcXhpdj34nk07799x/QxsPEXqe/Y
	 ITUz3zE2WI7Nd6fkBd/6UQkOi9yuTiqzm0yukS0k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729616AbfAVP1N (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:27:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:35374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728958AbfAVPW4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 10:22:56 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3642B217D4;
        Tue, 22 Jan 2019 15:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548170575;
        bh=4t21YB1g2/PDm6iWXX9iM2C0d6tNcceYgtR7rP0G9RA=;
        h=From:To:Cc:Subject:Date:From;
        b=bpnd4OvbWz0wtBeFwrPnvpHJp36MWtT7omLzo494FTBNCGCPkKF2flHnSKpb39jwK
         24ydNdSLTru3QrLYLKYNjhGXSQC9mbx7xv6SSpztReKL521gfUIQEizS3GXsKfuFAP
         /MaTG8iVddm75aLyOua5j5Izzs6+Um/uLkKZiSUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH] ti: wl18xx: no need to check return value of debugfs_create functions
Date:   Tue, 22 Jan 2019 16:21:27 +0100
Message-Id: <20190122152151.16139-28-gregkh@linuxfoundation.org>
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
 drivers/net/wireless/ti/wl18xx/debugfs.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/debugfs.c b/drivers/net/wireless/ti/wl18xx/debugfs.c
index 597e934c4630..5f4ec997ca59 100644
--- a/drivers/net/wireless/ti/wl18xx/debugfs.c
+++ b/drivers/net/wireless/ti/wl18xx/debugfs.c
@@ -422,20 +422,10 @@ static const struct file_operations radar_debug_mode_ops = {
 int wl18xx_debugfs_add_files(struct wl1271 *wl,
 			     struct dentry *rootdir)
 {
-	int ret = 0;
-	struct dentry *entry, *stats, *moddir;
+	struct dentry *stats, *moddir;
 
 	moddir = debugfs_create_dir(KBUILD_MODNAME, rootdir);
-	if (!moddir || IS_ERR(moddir)) {
-		entry = moddir;
-		goto err;
-	}
-
 	stats = debugfs_create_dir("fw_stats", moddir);
-	if (!stats || IS_ERR(stats)) {
-		entry = stats;
-		goto err;
-	}
 
 	DEBUGFS_ADD(clear_fw_stats, stats);
 
@@ -590,12 +580,4 @@ int wl18xx_debugfs_add_files(struct wl1271 *wl,
 	DEBUGFS_ADD(dynamic_fw_traces, moddir);
 
 	return 0;
-
-err:
-	if (IS_ERR(entry))
-		ret = PTR_ERR(entry);
-	else
-		ret = -ENOMEM;
-
-	return ret;
 }
-- 
2.20.1

