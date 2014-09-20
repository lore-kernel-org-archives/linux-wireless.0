Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53643 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052AbaITSZu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Sep 2014 14:25:50 -0400
Received: by mail-wi0-f178.google.com with SMTP id z2so1010049wiv.17
        for <linux-wireless@vger.kernel.org>; Sat, 20 Sep 2014 11:25:49 -0700 (PDT)
From: Yegor Yefremov <yegorslists@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Yegor Yefremov <yegorslists@googlemail.com>
Subject: [PATCH 2/2] iw: fix memory leak
Date: Sat, 20 Sep 2014 20:25:25 +0200
Message-Id: <1411237525-5810-2-git-send-email-yegorslists@googlemail.com> (sfid-20140920_202553_867516_0CF4F262)
In-Reply-To: <1411237525-5810-1-git-send-email-yegorslists@googlemail.com>
References: <1411237525-5810-1-git-send-email-yegorslists@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Close f, when returning before while loop.

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
---
 coalesce.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/coalesce.c b/coalesce.c
index 0239915..0d80ceb 100644
--- a/coalesce.c
+++ b/coalesce.c
@@ -38,8 +38,10 @@ static int handle_coalesce_enable(struct nl80211_state *state, struct nl_cb *cb,
 		return 1;
 
 	nl_rules = nla_nest_start(msg, NL80211_ATTR_COALESCE_RULE);
-	if (!nl_rules)
+	if (!nl_rules) {
+		fclose(f);
 		return -ENOBUFS;
+	}
 
 	while (!feof(f)) {
 		char *eol;
-- 
1.8.3.2

