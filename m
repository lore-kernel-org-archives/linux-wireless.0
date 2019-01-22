Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E454C282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:27:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE3D421019
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548170829;
	bh=CXox3C/G3+yHsw0vm9mRoDQYOAcTRf0dWx7eRGxPWt0=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=Pq50NaDMbNXi6hV5howYtAAvyMZHX3DVN2YSMHXpx7QD7NJj7B6phwiRl3ONeKNBv
	 1DAaykQorvqpQtjAGJIGOj15dzZdsBDYC5tZWCBmjUzpLVKF3Y/3mE2rGEB2FU8GrW
	 EfcdKhbnMcv2a7osIkojbtsfvF0vYKB9uyznnScM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729762AbfAVPXA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:23:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:35438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729750AbfAVPW6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 10:22:58 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1D1E217D6;
        Tue, 22 Jan 2019 15:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548170578;
        bh=CXox3C/G3+yHsw0vm9mRoDQYOAcTRf0dWx7eRGxPWt0=;
        h=From:To:Cc:Subject:Date:From;
        b=kJhPAUpW0izjSgl3aNLtvEf2tGOEYNR+JDCNo9oCzNEZ1odlFDQSMekoqA1b2q7YI
         J0nhbVaZLDvV2C1Q/qTRdv6cyYLWPlXtVacP1oZ4TnYBLsVTTVejEIMWyqcg9DeUDg
         yM4KLqQQBMOtRaD2HMQ+xxmmhJYPAHfD9B+EnD8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Solomon Peachy <pizza@shaftnet.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: [PATCH] cw1200: no need to check return value of debugfs_create functions
Date:   Tue, 22 Jan 2019 16:21:28 +0100
Message-Id: <20190122152151.16139-29-gregkh@linuxfoundation.org>
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

Cc: Solomon Peachy <pizza@shaftnet.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/st/cw1200/debug.c | 26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/st/cw1200/debug.c b/drivers/net/wireless/st/cw1200/debug.c
index 2231ba08bc1f..d94266d9d0b8 100644
--- a/drivers/net/wireless/st/cw1200/debug.c
+++ b/drivers/net/wireless/st/cw1200/debug.c
@@ -371,28 +371,14 @@ int cw1200_debug_init(struct cw1200_common *priv)
 
 	d->debugfs_phy = debugfs_create_dir("cw1200",
 					    priv->hw->wiphy->debugfsdir);
-	if (!d->debugfs_phy)
-		goto err;
-
-	if (!debugfs_create_file("status", 0400, d->debugfs_phy,
-				 priv, &cw1200_status_fops))
-		goto err;
-
-	if (!debugfs_create_file("counters", 0400, d->debugfs_phy,
-				 priv, &cw1200_counters_fops))
-		goto err;
-
-	if (!debugfs_create_file("wsm_dumps", 0200, d->debugfs_phy,
-				 priv, &fops_wsm_dumps))
-		goto err;
+	debugfs_create_file("status", 0400, d->debugfs_phy, priv,
+			    &cw1200_status_fops);
+	debugfs_create_file("counters", 0400, d->debugfs_phy, priv,
+			    &cw1200_counters_fops);
+	debugfs_create_file("wsm_dumps", 0200, d->debugfs_phy, priv,
+			    &fops_wsm_dumps);
 
 	return 0;
-
-err:
-	priv->debug = NULL;
-	debugfs_remove_recursive(d->debugfs_phy);
-	kfree(d);
-	return ret;
 }
 
 void cw1200_debug_release(struct cw1200_common *priv)
-- 
2.20.1

