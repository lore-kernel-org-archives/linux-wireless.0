Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAE64C282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:25:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89BDF217D6
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548170754;
	bh=Y+3f8hnkKRWgcyaq0Lvv7s9wQSn+ZZfJmrDS7NBu5Ko=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=Yr/s5H2B0tx8agHwj+792nWvoO6FUOhl9eY2Z1GTPVBwyppcZy/jCt7MrOsq4yDsV
	 Vv6RWja5GW4qcMREtjEwB5UpU56djmldubltm1XoUZ1fdoHPuIU2xoyvaN3uYsThTR
	 hTZHOv+c584aGrMAQ2DA7hQ2noSh/aNl+LiSegr0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729838AbfAVPX2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:23:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:36502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729829AbfAVPX2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 10:23:28 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F14C0217D8;
        Tue, 22 Jan 2019 15:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548170607;
        bh=Y+3f8hnkKRWgcyaq0Lvv7s9wQSn+ZZfJmrDS7NBu5Ko=;
        h=From:To:Cc:Subject:Date:From;
        b=VlRle62t3lI5Ryf4yTULFjKUjjEdPyXTit3q/zjb1it0Md5PI+rZ15BvrAxVuIEMV
         HyOWdi7bhm2C1++hA5QkGB6k3ccw4uwRnC3XH8voFzDSegxKJFZA46z4hiWFZg+rTJ
         iQztU4Ibpph6MzKt8SWNNHSishYw5LVMgJVOjot4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: [PATCH] rsi: no need to check return value of debugfs_create functions
Date:   Tue, 22 Jan 2019 16:21:32 +0100
Message-Id: <20190122152151.16139-33-gregkh@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/rsi/rsi_91x_debugfs.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_debugfs.c b/drivers/net/wireless/rsi/rsi_91x_debugfs.c
index 8c6ca8e689e4..d0c35f3e2012 100644
--- a/drivers/net/wireless/rsi/rsi_91x_debugfs.c
+++ b/drivers/net/wireless/rsi/rsi_91x_debugfs.c
@@ -297,11 +297,6 @@ int rsi_init_dbgfs(struct rsi_hw *adapter)
 
 	dev_dbgfs->subdir = debugfs_create_dir(devdir, NULL);
 
-	if (!dev_dbgfs->subdir) {
-		kfree(dev_dbgfs);
-		return -ENOMEM;
-	}
-
 	for (ii = 0; ii < adapter->num_debugfs_entries; ii++) {
 		files = &dev_debugfs_files[ii];
 		dev_dbgfs->rsi_files[ii] =
-- 
2.20.1

