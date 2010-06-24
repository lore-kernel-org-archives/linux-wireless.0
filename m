Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:41038 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940Ab0FXXog (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jun 2010 19:44:36 -0400
Message-ID: <4C23EDE1.3030505@openwrt.org>
Date: Fri, 25 Jun 2010 01:44:33 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: fix the for_each_sta_info macro
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Because of an ambiguity in the for_each_sta_info macro, it can
currently only be used if the third parameter is set to 'sta'.
Fix this by renaming the parameter to '_sta'.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -427,20 +427,20 @@ void for_each_sta_info_type_check(struct ieee80211_local *local,
 {
 }
 
-#define for_each_sta_info(local, _addr, sta, nxt) 			\
+#define for_each_sta_info(local, _addr, _sta, nxt) 			\
 	for (	/* initialise loop */					\
-		sta = rcu_dereference(local->sta_hash[STA_HASH(_addr)]),\
-		nxt = sta ? rcu_dereference(sta->hnext) : NULL;		\
+		_sta = rcu_dereference(local->sta_hash[STA_HASH(_addr)]),\
+		nxt = _sta ? rcu_dereference(_sta->hnext) : NULL;	\
 		/* typecheck */						\
-		for_each_sta_info_type_check(local, (_addr), sta, nxt),	\
+		for_each_sta_info_type_check(local, (_addr), _sta, nxt),\
 		/* continue condition */				\
-		sta;							\
+		_sta;							\
 		/* advance loop */					\
-		sta = nxt,						\
-		nxt = sta ? rcu_dereference(sta->hnext) : NULL		\
+		_sta = nxt,						\
+		nxt = _sta ? rcu_dereference(_sta->hnext) : NULL	\
 	     )								\
 	/* compare address and run code only if it matches */		\
-	if (memcmp(sta->sta.addr, (_addr), ETH_ALEN) == 0)
+	if (memcmp(_sta->sta.addr, (_addr), ETH_ALEN) == 0)
 
 /*
  * Get STA info by index, BROKEN!
