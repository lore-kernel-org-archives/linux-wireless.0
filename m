Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5656AC282C5
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:24:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18913217D8
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548170658;
	bh=efw6pBkIp0k7AQbq8JdQ6FqmYPAXGro3w8ye/pSMz3w=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=YAGNOpj9oc8Y5OHDWuoBcaPTqZa0J4R8vj+dcSMUgdTcG5L6afv57Gk2XbSV5q+9h
	 5++Q7ywYn/5lU+1/hOmTbJBtt9/2uigkru7buxY9CN6gVW36IMH7O9lnASqEkMOUl0
	 OUtrxpv2BATH4uCnhjtUatL/Pv+m63cee+rmOoCc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730074AbfAVPYN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:24:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:37874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730062AbfAVPYM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 10:24:12 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 446D6217D6;
        Tue, 22 Jan 2019 15:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548170651;
        bh=efw6pBkIp0k7AQbq8JdQ6FqmYPAXGro3w8ye/pSMz3w=;
        h=From:To:Cc:Subject:Date:From;
        b=q42QrFy1Dn/39BxcZ314YMMCz22kUktqpSOTfhrpoKEeG49C1Ge0PW+ezshqvmz/q
         TjMBbZ5F9Sqad8yW0aik138p3abT+SKmcxukVl+b3Z62fagy2Glc3Y73FHaSGTJQTh
         CxKEXA5J4j4Aq3iWVcIAF7qInVHiUZ/uzHk/+syA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH] libertas: no need to check return value of debugfs_create functions
Date:   Tue, 22 Jan 2019 16:21:36 +0100
Message-Id: <20190122152151.16139-37-gregkh@linuxfoundation.org>
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
Cc: libertas-dev@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/libertas/debugfs.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/debugfs.c b/drivers/net/wireless/marvell/libertas/debugfs.c
index c83f44f9ddf1..fe14814af300 100644
--- a/drivers/net/wireless/marvell/libertas/debugfs.c
+++ b/drivers/net/wireless/marvell/libertas/debugfs.c
@@ -708,8 +708,6 @@ void lbs_debugfs_init_one(struct lbs_private *priv, struct net_device *dev)
 		goto exit;
 
 	priv->debugfs_dir = debugfs_create_dir(dev->name, lbs_dir);
-	if (!priv->debugfs_dir)
-		goto exit;
 
 	for (i=0; i<ARRAY_SIZE(debugfs_files); i++) {
 		files = &debugfs_files[i];
@@ -721,8 +719,6 @@ void lbs_debugfs_init_one(struct lbs_private *priv, struct net_device *dev)
 	}
 
 	priv->events_dir = debugfs_create_dir("subscribed_events", priv->debugfs_dir);
-	if (!priv->events_dir)
-		goto exit;
 
 	for (i=0; i<ARRAY_SIZE(debugfs_events_files); i++) {
 		files = &debugfs_events_files[i];
@@ -734,8 +730,6 @@ void lbs_debugfs_init_one(struct lbs_private *priv, struct net_device *dev)
 	}
 
 	priv->regs_dir = debugfs_create_dir("registers", priv->debugfs_dir);
-	if (!priv->regs_dir)
-		goto exit;
 
 	for (i=0; i<ARRAY_SIZE(debugfs_regs_files); i++) {
 		files = &debugfs_regs_files[i];
-- 
2.20.1

