Return-Path: <SRS0=C4Uy=DS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5FDEC433E7
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Oct 2020 11:18:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9EFC207FB
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Oct 2020 11:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729936AbgJKLSH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 11 Oct 2020 07:18:07 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:24868 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729862AbgJKLSE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Oct 2020 07:18:04 -0400
X-IronPort-AV: E=Sophos;i="5.77,362,1596492000"; 
   d="scan'208";a="471985691"
Received: from palace.rsr.lip6.fr (HELO palace.lip6.fr) ([132.227.105.202])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/AES256-SHA256; 11 Oct 2020 13:18:00 +0200
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     =?UTF-8?q?Valdis=20Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>,
        Joe Perches <joe@perches.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] mac80211: use semicolons rather than commas to separate statements
Date:   Sun, 11 Oct 2020 12:34:55 +0200
Message-Id: <1602412498-32025-3-git-send-email-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1602412498-32025-1-git-send-email-Julia.Lawall@inria.fr>
References: <1602412498-32025-1-git-send-email-Julia.Lawall@inria.fr>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Replace commas with semicolons.  Commas introduce unnecessary
variability in the code structure and are hard to see.  What is done
is essentially described by the following Coccinelle semantic patch
(http://coccinelle.lip6.fr/):

// <smpl>
@@ expression e1,e2; @@
e1
-,
+;
e2
... when any
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 net/mac80211/debugfs_sta.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 829dcad69c2c..6a51b8b58f9e 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -274,7 +274,7 @@ static ssize_t sta_aql_read(struct file *file, char __user *userbuf,
 		"Q limit[low/high]: VO: %u/%u VI: %u/%u BE: %u/%u BK: %u/%u\n",
 		q_depth[0], q_depth[1], q_depth[2], q_depth[3],
 		q_limit_l[0], q_limit_h[0], q_limit_l[1], q_limit_h[1],
-		q_limit_l[2], q_limit_h[2], q_limit_l[3], q_limit_h[3]),
+		q_limit_l[2], q_limit_h[2], q_limit_l[3], q_limit_h[3]);
 
 	rv = simple_read_from_buffer(userbuf, count, ppos, buf, p - buf);
 	kfree(buf);

