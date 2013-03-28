Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:38545 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755888Ab3C1JSo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Mar 2013 05:18:44 -0400
Received: from romuald.bergerie (unknown [88.178.86.202])
	by smtp1-g21.free.fr (Postfix) with ESMTP id ACC459402B3
	for <linux-wireless@vger.kernel.org>; Thu, 28 Mar 2013 10:18:32 +0100 (CET)
From: "Vincent" <vincent.stehle@laposte.net>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	=?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
Subject: [PATCH] mac80211: fix uninitialized variable
Date: Thu, 28 Mar 2013 10:11:34 +0100
Message-Id: <1364461894-30555-1-git-send-email-vincent.stehle@laposte.net> (sfid-20130328_101848_526291_9C4AC36F)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix one code path where chanctx_conf is tested as being non-NULL while it may
be uninitialized.

This fixes the following warning:

  net/mac80211/tx.c: In function ‘ieee80211_subif_start_xmit’:
  net/mac80211/tx.c:1828:27: warning: ‘chanctx_conf’ may be used uninitialized in this function [-Wmaybe-uninitialized]

Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Cc: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8914d2d..57a5722 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1777,7 +1777,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	bool multicast;
 	u32 info_flags = 0;
 	u16 info_id = 0;
-	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct ieee80211_chanctx_conf *chanctx_conf = NULL;
 	struct ieee80211_sub_if_data *ap_sdata;
 	enum ieee80211_band band;
 
-- 
1.7.10.4

