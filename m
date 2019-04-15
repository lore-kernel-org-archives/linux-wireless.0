Return-Path: <SRS0=DbkN=SR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADBAAC10F0E
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 09:39:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83CFE206BA
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 09:39:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbfDOJji (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Apr 2019 05:39:38 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:35348 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfDOJji (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Apr 2019 05:39:38 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hFy5P-0003tf-Jz; Mon, 15 Apr 2019 11:39:35 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: don't attempt to rename ERR_PTR() debugfs dirs
Date:   Mon, 15 Apr 2019 11:39:33 +0200
Message-Id: <20190415093933.13852-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

We need to dereference the directory to get its parent to
be able to rename it, so it's clearly not safe to try to
do this with ERR_PTR() pointers. Skip in this case.

It seems that this is most likely what was causing the
report by syzbot, but I'm not entirely sure as it didn't
come with a reproducer this time.

Cc: stable@vger.kernel.org
Reported-by: syzbot+4ece1a28b8f4730547c9@syzkaller.appspotmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index cff0fb3578c9..deb3faf08337 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -841,7 +841,7 @@ void ieee80211_debugfs_rename_netdev(struct ieee80211_sub_if_data *sdata)
 
 	dir = sdata->vif.debugfs_dir;
 
-	if (!dir)
+	if (IS_ERR_OR_NULL(dir))
 		return;
 
 	sprintf(buf, "netdev:%s", sdata->name);
-- 
2.17.2

