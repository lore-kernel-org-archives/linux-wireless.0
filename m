Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 076BEC77B61
	for <linux-wireless@archiver.kernel.org>; Sun, 16 Apr 2023 08:36:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbjDPIf7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 16 Apr 2023 04:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjDPIf6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Apr 2023 04:35:58 -0400
Received: from hust.edu.cn (unknown [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 118F12D59;
        Sun, 16 Apr 2023 01:35:56 -0700 (PDT)
Received: from localhost.localdomain ([222.20.126.128])
        (user=ysxu@hust.edu.cn mech=LOGIN bits=0)
        by mx1.hust.edu.cn  with ESMTP id 33G8Uhvq027287-33G8Uhvr027287
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Sun, 16 Apr 2023 16:30:47 +0800
From:   yingsha xu <ysxu@hust.edu.cn>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Benc <jbenc@suse.cz>,
        "John W. Linville" <linville@tuxdriver.com>
Cc:     hust-os-kernel-patches@googlegroups.com,
        yingsha xu <ysxu@hust.edu.cn>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: mac80211: use IS_ERR to check return value
Date:   Sun, 16 Apr 2023 16:30:27 +0800
Message-Id: <20230416083028.14044-1-ysxu@hust.edu.cn>
X-Mailer: git-send-email 2.17.1
X-FEAS-AUTH-USER: ysxu@hust.edu.cn
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

According to the annotation of function debugfs_create_fs, if
an error occurs, ERR_PTR(-ERROR) will be returned instead of
a null pointer or zero value.

Fix it by using IS_ERR().

Fixes: e9f207f0ff90 ("[MAC80211]: Add debugfs attributes.")
Signed-off-by: yingsha xu <ysxu@hust.edu.cn>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
---
 net/mac80211/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index dfb9f55e2685..672bf969ad88 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -674,7 +674,7 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	statsd = debugfs_create_dir("statistics", phyd);
 
 	/* if the dir failed, don't put all the other things into the root! */
-	if (!statsd)
+	if (IS_ERR(statsd))
 		return;
 
 #ifdef CONFIG_MAC80211_DEBUG_COUNTERS
-- 
2.17.1

