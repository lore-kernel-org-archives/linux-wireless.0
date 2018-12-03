Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0937BC04EB9
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 13:31:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C465520850
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 13:31:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="szPcHjbY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C465520850
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbeLCNcv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 08:32:51 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33819 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbeLCNcv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 08:32:51 -0500
Received: by mail-pg1-f194.google.com with SMTP id 17so5740876pgg.1;
        Mon, 03 Dec 2018 05:31:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Vv+Jso5Cu154zWL31wEKKL+Cxc5/IY3r+EdUjHnkACY=;
        b=szPcHjbYjBkyc0cB5lHIzBWyLw8VXOqJmmqGHLOjow8xTNpPs874EHTvbNgPZxeQDY
         tGVZvC3PqhD5dK7OEVgjHShxZSj/qZHvrLPqeHCcgkPrW8xP9wOgc61iChJXeUmjIGPw
         E4cqpofBajXje1l8dUa7/LvfY6eENQOEafmnAmRGo2tItk4TttyewvaqlmMQU4/rO89w
         irgYdh2aiAHu8w0gFHk7CJMFZ5Gz59FRWzAWwXtaoAXy1cYzbw3aJp0j1Y4pKUnyEvfv
         4gBles1hGEMmP2GTAFAMWHZTSn0StP4C0DRwZaAz4rIyncHxi+AErQRkj91mZIx1Upmu
         C1DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Vv+Jso5Cu154zWL31wEKKL+Cxc5/IY3r+EdUjHnkACY=;
        b=To5Orfh1E14ZUdHfkEnNFxAGL3sYX11FNhivRSdcwQQa4oASy6ECQcE+V8BGKTjDnf
         +SsDeD5IevkSf2CVuB0Dccq94+WDfpwJZDlxII4MpWQFUjd1YpbxnuwsiMuOT3iz0yNP
         t/VZ0RfOHRbHS/53cqfvSRhAQD6bHWuq43MS6WU4pyzcKj7il+TpZqV5SfeEVkuZ+o5a
         nIttPiNssmZWyA9VAgVs+7Vsqde/ieEte4Ivb9lKjGBposIazqntG2qLe8dMzot96UFR
         afUR1xWKm7Wjm4SCqqKNW66pLX4oT2liEudYPuFe7KUh3SHABKYm8cC5n9wcwE8qC0AV
         wtoQ==
X-Gm-Message-State: AA+aEWbySgqVUYkWjwbRLUm+gOlBBzp9kASYYYFR+PDbteloNqPhJz/R
        FMCEWx11FKmmpYAqqEIWfLOaGJl4i0M=
X-Google-Smtp-Source: AFSGD/X/UixODgGe+0E6rX/MfiepPOMU3kRCJq2X6tcnK4O0AUIbHtuIe2M8Lg+qEz/G4utanI024g==
X-Received: by 2002:a63:1f4e:: with SMTP id q14mr12725673pgm.88.1543843908870;
        Mon, 03 Dec 2018 05:31:48 -0800 (PST)
Received: from localhost (68.168.130.77.16clouds.com. [68.168.130.77])
        by smtp.gmail.com with ESMTPSA id v62sm26951764pfd.163.2018.12.03.05.31.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Dec 2018 05:31:47 -0800 (PST)
From:   Yangtao Li <tiny.windzz@gmail.com>
To:     pizza@shaftnet.org, kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yangtao Li <tiny.windzz@gmail.com>
Subject: [PATCH] wireless/cw1200: convert to DEFINE_SHOW_ATTRIBUTE
Date:   Mon,  3 Dec 2018 08:31:45 -0500
Message-Id: <20181203133145.12430-1-tiny.windzz@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
---
 drivers/net/wireless/st/cw1200/debug.c | 32 ++++----------------------
 1 file changed, 4 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/st/cw1200/debug.c b/drivers/net/wireless/st/cw1200/debug.c
index 295cb1a29f25..2231ba08bc1f 100644
--- a/drivers/net/wireless/st/cw1200/debug.c
+++ b/drivers/net/wireless/st/cw1200/debug.c
@@ -289,19 +289,7 @@ static int cw1200_status_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static int cw1200_status_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, &cw1200_status_show,
-		inode->i_private);
-}
-
-static const struct file_operations fops_status = {
-	.open = cw1200_status_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
+DEFINE_SHOW_ATTRIBUTE(cw1200_status);
 
 static int cw1200_counters_show(struct seq_file *seq, void *v)
 {
@@ -345,19 +333,7 @@ static int cw1200_counters_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static int cw1200_counters_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, &cw1200_counters_show,
-		inode->i_private);
-}
-
-static const struct file_operations fops_counters = {
-	.open = cw1200_counters_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
+DEFINE_SHOW_ATTRIBUTE(cw1200_counters);
 
 static ssize_t cw1200_wsm_dumps(struct file *file,
 	const char __user *user_buf, size_t count, loff_t *ppos)
@@ -399,11 +375,11 @@ int cw1200_debug_init(struct cw1200_common *priv)
 		goto err;
 
 	if (!debugfs_create_file("status", 0400, d->debugfs_phy,
-				 priv, &fops_status))
+				 priv, &cw1200_status_fops))
 		goto err;
 
 	if (!debugfs_create_file("counters", 0400, d->debugfs_phy,
-				 priv, &fops_counters))
+				 priv, &cw1200_counters_fops))
 		goto err;
 
 	if (!debugfs_create_file("wsm_dumps", 0200, d->debugfs_phy,
-- 
2.17.0

