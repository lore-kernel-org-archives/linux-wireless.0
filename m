Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.189]:19445 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbYDABCW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 21:02:22 -0400
Received: by rv-out-0910.google.com with SMTP id k20so1061450rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2008 18:02:21 -0700 (PDT)
To: linux-wireless@vger.kernel.org
From: Luis Carlos Cobo <luisca@cozybit.com>
Cc: johannes@sipsolutions.net
Date: Mon, 31 Mar 2008 15:21:23 -0700
Subject: [PATCH] mac80211: fix spinlock recursion on sta expiration
Message-ID: <47f1899c.02578c0a.0489.586f@mx.google.com> (sfid-20080401_020225_352005_ABD8BB5D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 net/mac80211/ieee80211_sta.c |    2 +-
 net/mac80211/sta_info.c      |    2 +-
 net/mac80211/sta_info.h      |    1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index f9cf2f1..cfe6fcc 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -3081,7 +3081,7 @@ static void ieee80211_sta_expire(struct net_device *dev, unsigned long exp_time)
 		if (time_after(jiffies, sta->last_rx + exp_time)) {
 			printk(KERN_DEBUG "%s: expiring inactive STA %s\n",
 			       dev->name, print_mac(mac, sta->addr));
-			sta_info_unlink(&sta);
+			__sta_info_unlink(&sta);
 			if (sta)
 				list_add(&sta->list, &tmp_list);
 		}
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index f708367..ba02b43 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -409,7 +409,7 @@ static struct sta_info *__sta_info_unpin(struct sta_info *sta)
 	return ret;
 }
 
-static void __sta_info_unlink(struct sta_info **sta)
+void __sta_info_unlink(struct sta_info **sta)
 {
 	struct ieee80211_local *local = (*sta)->local;
 	struct ieee80211_sub_if_data *sdata = (*sta)->sdata;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 5e39a41..d4d6dcb 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -347,6 +347,7 @@ int sta_info_insert(struct sta_info *sta);
  * has already unlinked it.
  */
 void sta_info_unlink(struct sta_info **sta);
+void __sta_info_unlink(struct sta_info **sta);
 
 void sta_info_destroy(struct sta_info *sta);
 void sta_info_set_tim_bit(struct sta_info *sta);
-- 
1.5.4.3



