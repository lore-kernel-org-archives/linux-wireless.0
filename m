Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43122 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab2FCUci (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jun 2012 16:32:38 -0400
Received: by wgbdr13 with SMTP id dr13so3445213wgb.1
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jun 2012 13:32:37 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>, stable@vger.kernel.org
Subject: [PATCH] mac80211: fix non RCU-safe sta_list manipulation
Date: Sun,  3 Jun 2012 23:32:32 +0300
Message-Id: <1338755552-13349-1-git-send-email-arik@wizery.com> (sfid-20120603_223240_776709_74DBF9DD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sta_info_cleanup locks the sta_list using rcu_read_lock however
the delete operation isn't rcu safe. A race between sta_info_cleanup
timer being called and a STA being removed can occur which leads
to a panic while traversing sta_list. Fix this by switching to the
RCU-safe versions.

Cc: stable@vger.kernel.org
Reported-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 net/mac80211/sta_info.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index f5c2b7e..a37c905 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -378,7 +378,7 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 	/* make the station visible */
 	sta_info_hash_add(local, sta);
 
-	list_add(&sta->list, &local->sta_list);
+	list_add_rcu(&sta->list, &local->sta_list);
 
 	set_sta_flag(sta, WLAN_STA_INSERTED);
 
@@ -688,7 +688,7 @@ int __must_check __sta_info_destroy(struct sta_info *sta)
 	if (ret)
 		return ret;
 
-	list_del(&sta->list);
+	list_del_rcu(&sta->list);
 
 	mutex_lock(&local->key_mtx);
 	for (i = 0; i < NUM_DEFAULT_KEYS; i++)
-- 
1.7.9.5

