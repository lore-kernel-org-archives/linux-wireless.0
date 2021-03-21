Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 979FFC433DB
	for <linux-wireless@archiver.kernel.org>; Sun, 21 Mar 2021 14:24:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B58D61943
	for <linux-wireless@archiver.kernel.org>; Sun, 21 Mar 2021 14:24:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhCUOYM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 21 Mar 2021 10:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbhCUOXo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 Mar 2021 10:23:44 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB1BC061574
        for <linux-wireless@vger.kernel.org>; Sun, 21 Mar 2021 07:23:44 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lNyzT-001N7J-9W; Sun, 21 Mar 2021 15:23:39 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, bup-list@googlegroups.com
Subject: [PATCH] bup: cat-file: fix error print
Date:   Sun, 21 Mar 2021 15:23:33 +0100
Message-Id: <20210321142333.16326-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Some variable renaming and bytes issues, if a target cannot
be found in cat-file.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 lib/cmd/cat-file-cmd.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/cmd/cat-file-cmd.py b/lib/cmd/cat-file-cmd.py
index 388ca03abcbe..ebe27ce43a0a 100755
--- a/lib/cmd/cat-file-cmd.py
+++ b/lib/cmd/cat-file-cmd.py
@@ -56,7 +56,7 @@ resolved = vfs.resolve(repo, target, follow=False)
 leaf_name, leaf_item = resolved[-1]
 if not leaf_item:
     log('error: cannot access %r in %r\n'
-        % ('/'.join(name for name, item in resolved), path))
+        % (b'/'.join(name for name, item in resolved), target))
     sys.exit(1)
 
 mode = vfs.item_mode(leaf_item)
-- 
2.30.2

