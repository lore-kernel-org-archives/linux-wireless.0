Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36052 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbYIJWNv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 18:13:51 -0400
Message-Id: <20080910220408.031956000@sipsolutions.net> (sfid-20080911_001357_454746_5F711703)
References: <20080910220145.707263000@sipsolutions.net>
Date: Thu, 11 Sep 2008 00:01:46 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 01/18] mac80211: move ieee80211_sta_expire
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_sta_expire uses the internal __sta_info_unlink
function which can become static if this function is moved
to sta_info.c.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c     |   26 --------------------------
 net/mac80211/sta_info.c |   28 +++++++++++++++++++++++++++-
 net/mac80211/sta_info.h |    3 ++-
 3 files changed, 29 insertions(+), 28 deletions(-)

--- everything.orig/net/mac80211/mlme.c	2008-09-10 23:57:19.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-10 23:57:50.000000000 +0200
@@ -1944,32 +1944,6 @@ static int ieee80211_sta_active_ibss(str
 }
 
 
-static void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata, unsigned long exp_time)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct sta_info *sta, *tmp;
-	LIST_HEAD(tmp_list);
-	DECLARE_MAC_BUF(mac);
-	unsigned long flags;
-
-	spin_lock_irqsave(&local->sta_lock, flags);
-	list_for_each_entry_safe(sta, tmp, &local->sta_list, list)
-		if (time_after(jiffies, sta->last_rx + exp_time)) {
-#ifdef CONFIG_MAC80211_IBSS_DEBUG
-			printk(KERN_DEBUG "%s: expiring inactive STA %s\n",
-			       sdata->dev->name, print_mac(mac, sta->addr));
-#endif
-			__sta_info_unlink(&sta);
-			if (sta)
-				list_add(&sta->list, &tmp_list);
-		}
-	spin_unlock_irqrestore(&local->sta_lock, flags);
-
-	list_for_each_entry_safe(sta, tmp, &tmp_list, list)
-		sta_info_destroy(sta);
-}
-
-
 static void ieee80211_sta_merge_ibss(struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_if_sta *ifsta)
 {
--- everything.orig/net/mac80211/sta_info.c	2008-09-10 23:50:30.000000000 +0200
+++ everything/net/mac80211/sta_info.c	2008-09-10 23:57:50.000000000 +0200
@@ -424,7 +424,7 @@ void sta_info_clear_tim_bit(struct sta_i
 	spin_unlock_irqrestore(&sta->local->sta_lock, flags);
 }
 
-void __sta_info_unlink(struct sta_info **sta)
+static void __sta_info_unlink(struct sta_info **sta)
 {
 	struct ieee80211_local *local = (*sta)->local;
 	struct ieee80211_sub_if_data *sdata = (*sta)->sdata;
@@ -802,3 +802,29 @@ void sta_info_flush_delayed(struct ieee8
 		schedule_work(&local->sta_flush_work);
 	spin_unlock_irqrestore(&local->sta_lock, flags);
 }
+
+void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
+			  unsigned long exp_time)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta, *tmp;
+	LIST_HEAD(tmp_list);
+	DECLARE_MAC_BUF(mac);
+	unsigned long flags;
+
+	spin_lock_irqsave(&local->sta_lock, flags);
+	list_for_each_entry_safe(sta, tmp, &local->sta_list, list)
+		if (time_after(jiffies, sta->last_rx + exp_time)) {
+#ifdef CONFIG_MAC80211_IBSS_DEBUG
+			printk(KERN_DEBUG "%s: expiring inactive STA %s\n",
+			       sdata->dev->name, print_mac(mac, sta->addr));
+#endif
+			__sta_info_unlink(&sta);
+			if (sta)
+				list_add(&sta->list, &tmp_list);
+		}
+	spin_unlock_irqrestore(&local->sta_lock, flags);
+
+	list_for_each_entry_safe(sta, tmp, &tmp_list, list)
+		sta_info_destroy(sta);
+}
--- everything.orig/net/mac80211/sta_info.h	2008-09-10 23:50:30.000000000 +0200
+++ everything/net/mac80211/sta_info.h	2008-09-10 23:57:50.000000000 +0200
@@ -452,7 +452,6 @@ int sta_info_insert(struct sta_info *sta
  * has already unlinked it.
  */
 void sta_info_unlink(struct sta_info **sta);
-void __sta_info_unlink(struct sta_info **sta);
 
 void sta_info_destroy(struct sta_info *sta);
 void sta_info_set_tim_bit(struct sta_info *sta);
@@ -464,5 +463,7 @@ void sta_info_stop(struct ieee80211_loca
 int sta_info_flush(struct ieee80211_local *local,
 		    struct ieee80211_sub_if_data *sdata);
 void sta_info_flush_delayed(struct ieee80211_sub_if_data *sdata);
+void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
+			  unsigned long exp_time);
 
 #endif /* STA_INFO_H */

-- 

