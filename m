Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA9EAC47082
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jun 2021 09:32:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A391261208
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jun 2021 09:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhFHJe3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jun 2021 05:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhFHJe3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jun 2021 05:34:29 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CACEC061787
        for <linux-wireless@vger.kernel.org>; Tue,  8 Jun 2021 02:32:36 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lqY65-003gsH-RM; Tue, 08 Jun 2021 11:32:33 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/4] mac80211: fix 'reset' debugfs locking
Date:   Tue,  8 Jun 2021 11:32:27 +0200
Message-Id: <20210608113226.14020430e449.I78e19db0a55a8295a376e15ac4cf77dbb4c6fb51@changeid>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

cfg80211 now calls suspend/resume with the wiphy lock
held, and while there's a problem with that needing
to be fixed, we should do the same in debugfs.

Fixes: a05829a7222e ("cfg80211: avoid holding the RTNL when calling the driver")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 9245c0421bda..b5ff61b6448a 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -4,7 +4,7 @@
  *
  * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
- * Copyright (C) 2018 - 2019 Intel Corporation
+ * Copyright (C) 2018 - 2019, 2021 Intel Corporation
  */
 
 #include <linux/debugfs.h>
@@ -389,8 +389,10 @@ static ssize_t reset_write(struct file *file, const char __user *user_buf,
 	struct ieee80211_local *local = file->private_data;
 
 	rtnl_lock();
+	wiphy_lock(local->hw.wiphy);
 	__ieee80211_suspend(&local->hw, NULL);
 	__ieee80211_resume(&local->hw);
+	wiphy_unlock(local->hw.wiphy);
 	rtnl_unlock();
 
 	return count;
-- 
2.31.1

