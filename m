Return-Path: <SRS0=1uwz=AX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC7DDC433E5
	for <linux-wireless@archiver.kernel.org>; Sun, 12 Jul 2020 17:36:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 925AC20702
	for <linux-wireless@archiver.kernel.org>; Sun, 12 Jul 2020 17:36:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729386AbgGLRf7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 12 Jul 2020 13:35:59 -0400
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:46515 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729364AbgGLRfy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 12 Jul 2020 13:35:54 -0400
Received: from localhost.localdomain ([93.22.148.52])
        by mwinf5d89 with ME
        id 2Hbs23007183tQl03Hbsju; Sun, 12 Jul 2020 19:35:53 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 12 Jul 2020 19:35:53 +0200
X-ME-IP: 93.22.148.52
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 2/2] nl80211: Simplify error handling path in 'nl80211_trigger_scan()'
Date:   Sun, 12 Jul 2020 19:35:51 +0200
Message-Id: <20200712173551.274448-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Re-write the end of 'nl80211_trigger_scan()' with a more standard, easy to
understand and future proof version.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 net/wireless/nl80211.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a671ee5f5da7..898e5f53f263 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7993,15 +7993,18 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	rdev->scan_req = request;
 	err = rdev_scan(rdev, request);
 
-	if (!err) {
-		nl80211_send_scan_start(rdev, wdev);
-		if (wdev->netdev)
-			dev_hold(wdev->netdev);
-	} else {
+	if (err)
+		goto out_free;
+
+	nl80211_send_scan_start(rdev, wdev);
+	if (wdev->netdev)
+		dev_hold(wdev->netdev);
+
+	return 0;
+
  out_free:
-		rdev->scan_req = NULL;
-		kfree(request);
-	}
+	rdev->scan_req = NULL;
+	kfree(request);
 
 	return err;
 }
-- 
2.25.1

