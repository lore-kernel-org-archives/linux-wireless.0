Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:1904 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932626AbZJFNo6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 09:44:58 -0400
Received: by ey-out-2122.google.com with SMTP id 4so799735eyf.19
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2009 06:43:50 -0700 (PDT)
Message-ID: <4ACB4BA3.9090406@gmail.com>
Date: Tue, 06 Oct 2009 15:52:35 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mac80211: use kfree_skb() to free struct sk_buff pointers
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kfree_skb() should be used to free struct sk_buff pointers.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index dd65643..aeb65b3 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -339,7 +339,7 @@ void ieee80211_add_pending_skb(struct ieee80211_local *local,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
 	if (WARN_ON(!info->control.vif)) {
-		kfree(skb);
+		kfree_skb(skb);
 		return;
 	}
 
@@ -367,7 +367,7 @@ int ieee80211_add_pending_skbs(struct ieee80211_local *local,
 		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
 		if (WARN_ON(!info->control.vif)) {
-			kfree(skb);
+			kfree_skb(skb);
 			continue;
 		}
 
