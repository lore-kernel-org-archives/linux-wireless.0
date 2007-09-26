Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:33833
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219AbXIZTJc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 15:09:32 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] mac80211: bss_tim_clear must use ~ instead of !
Date: Wed, 26 Sep 2007 21:08:47 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200709262108.47882.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We need to use bitwise NOT.
This also cleans up the code a little bit to make it more readable.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-2.6/net/mac80211/ieee80211_i.h
===================================================================
--- wireless-2.6.orig/net/mac80211/ieee80211_i.h	2007-09-26 21:04:03.000000000 +0200
+++ wireless-2.6/net/mac80211/ieee80211_i.h	2007-09-26 21:04:05.000000000 +0200
@@ -648,34 +648,34 @@ struct sta_attribute {
 	ssize_t (*store)(struct sta_info *, const char *buf, size_t count);
 };
 
-static inline void __bss_tim_set(struct ieee80211_if_ap *bss, int aid)
+static inline void __bss_tim_set(struct ieee80211_if_ap *bss, u16 aid)
 {
 	/*
-	 * This format has ben mandated by the IEEE specifications,
+	 * This format has been mandated by the IEEE specifications,
 	 * so this line may not be changed to use the __set_bit() format.
 	 */
-	bss->tim[(aid)/8] |= 1<<((aid) % 8);
+	bss->tim[aid / 8] |= (1 << (aid % 8));
 }
 
 static inline void bss_tim_set(struct ieee80211_local *local,
-			       struct ieee80211_if_ap *bss, int aid)
+			       struct ieee80211_if_ap *bss, u16 aid)
 {
 	read_lock_bh(&local->sta_lock);
 	__bss_tim_set(bss, aid);
 	read_unlock_bh(&local->sta_lock);
 }
 
-static inline void __bss_tim_clear(struct ieee80211_if_ap *bss, int aid)
+static inline void __bss_tim_clear(struct ieee80211_if_ap *bss, u16 aid)
 {
 	/*
-	 * This format has ben mandated by the IEEE specifications,
+	 * This format has been mandated by the IEEE specifications,
 	 * so this line may not be changed to use the __clear_bit() format.
 	 */
-	bss->tim[(aid)/8] &= !(1<<((aid) % 8));
+	bss->tim[aid / 8] &= ~(1 << (aid % 8));
 }
 
 static inline void bss_tim_clear(struct ieee80211_local *local,
-				 struct ieee80211_if_ap *bss, int aid)
+				 struct ieee80211_if_ap *bss, u16 aid)
 {
 	read_lock_bh(&local->sta_lock);
 	__bss_tim_clear(bss, aid);
