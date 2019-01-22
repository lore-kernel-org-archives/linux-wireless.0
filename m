Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83B41C282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:27:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B96321019
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548170841;
	bh=urRGes8OWVXQNU55psX7X+TVwJjeaCJAm4+Qrs4zg5g=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=VvSf4y1Tgvz8XyOg12bH/504+wAZz7iTYUXv7QLoPISvYI4UzxOLXMnrdD8zIVnmS
	 LZYGNsb9KVeqHYFrkBnjt3VKmx4O2QbunCogXNszmTA/adwg3oW5l5YZTEj8pEpVSh
	 W2yaYsRmE8UfyW33boUGowC/F/SR8brpQ9EHAOfM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbfAVPW4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:22:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:35282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729732AbfAVPWy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 10:22:54 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31203217D6;
        Tue, 22 Jan 2019 15:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548170572;
        bh=urRGes8OWVXQNU55psX7X+TVwJjeaCJAm4+Qrs4zg5g=;
        h=From:To:Cc:Subject:Date:From;
        b=fgHV5vwzwre/UXaZHDDOh7WrGpFsxbuS4A9t32Kj6FIqjFTkQnlJv3PkqJQHs54Dt
         C/lKxiwvgZUqaamycfP3CN44v0vBXsN+XwkZvZGoPMD8C7BWSwkQ5EvbawuhzMg9kq
         Jh0M8GMuhSZ/dcAWr34zVqWgzdYpjZtX+gzaUs98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH] ti: wl12xx: no need to check return value of debugfs_create functions
Date:   Tue, 22 Jan 2019 16:21:26 +0100
Message-Id: <20190122152151.16139-27-gregkh@linuxfoundation.org>
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
 drivers/net/wireless/ti/wl12xx/debugfs.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/debugfs.c b/drivers/net/wireless/ti/wl12xx/debugfs.c
index 0521cbf858cf..6c3c04eca8fd 100644
--- a/drivers/net/wireless/ti/wl12xx/debugfs.c
+++ b/drivers/net/wireless/ti/wl12xx/debugfs.c
@@ -125,20 +125,10 @@ WL12XX_DEBUGFS_FWSTATS_FILE(rxpipe, tx_xfr_host_int_trig_rx_data, "%u");
 int wl12xx_debugfs_add_files(struct wl1271 *wl,
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
 
 	DEBUGFS_FWSTATS_ADD(tx, internal_desc_overflow);
 
@@ -232,12 +222,4 @@ int wl12xx_debugfs_add_files(struct wl1271 *wl,
 	DEBUGFS_FWSTATS_ADD(rxpipe, tx_xfr_host_int_trig_rx_data);
 
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

