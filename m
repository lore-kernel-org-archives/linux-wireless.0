Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17A21C433EF
	for <linux-wireless@archiver.kernel.org>; Sun, 20 Feb 2022 08:23:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233810AbiBTIXo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 20 Feb 2022 03:23:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbiBTIXl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 20 Feb 2022 03:23:41 -0500
Received: from smtp.smtpout.orange.fr (smtp06.smtpout.orange.fr [80.12.242.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10C350455
        for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2022 00:23:20 -0800 (PST)
Received: from pop-os.home ([90.126.236.122])
        by smtp.orange.fr with ESMTPA
        id LhUznwc1MuCn2LhUznucfY; Sun, 20 Feb 2022 09:23:19 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 20 Feb 2022 09:23:19 +0100
X-ME-IP: 90.126.236.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] mac80211: Use GFP_KERNEL instead of GFP_ATOMIC when possible
Date:   Sun, 20 Feb 2022 09:23:15 +0100
Message-Id: <194a0e2ff00c3fae88cc9fba47431747360c8242.1645345378.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Previous memory allocations in this function already use GFP_KERNEL, so
use __dev_alloc_skb() and an explicit GFP_KERNEL instead of an implicit
GFP_ATOMIC.

This gives more opportunities of successful allocation.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 net/mac80211/mesh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 1d3b4ad32965..5275f4f32a78 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -853,7 +853,7 @@ ieee80211_mesh_build_beacon(struct ieee80211_if_mesh *ifmsh)
 
 	bcn = kzalloc(sizeof(*bcn) + head_len + tail_len, GFP_KERNEL);
 	/* need an skb for IE builders to operate on */
-	skb = dev_alloc_skb(max(head_len, tail_len));
+	skb = __dev_alloc_skb(max(head_len, tail_len), GFP_KERNEL);
 
 	if (!bcn || !skb)
 		goto out_free;
-- 
2.32.0

