Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:55880 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaDUEzG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2014 00:55:06 -0400
Received: by mail-pb0-f44.google.com with SMTP id rp16so3355250pbb.31
        for <linux-wireless@vger.kernel.org>; Sun, 20 Apr 2014 21:55:06 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 05/12] mac80211: remove unnecessary BUG_ON()
Date: Mon, 21 Apr 2014 12:53:00 +0800
Message-Id: <fd686aea6dc877a9d6ecbfabba68b4e1e8b645d0.1398055854.git.gamerh2o@gmail.com> (sfid-20140421_065517_859253_3DD62FF9)
In-Reply-To: <cover.1398055853.git.gamerh2o@gmail.com>
References: <cover.1398055853.git.gamerh2o@gmail.com>
In-Reply-To: <cover.1398055853.git.gamerh2o@gmail.com>
References: <cover.1398055853.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The BUG_ON(!err) can't be triggered in the code path, so remove
it.

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 net/mac80211/sta_info.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 137a192..c34a5f9 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -552,7 +552,7 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 int sta_info_insert_rcu(struct sta_info *sta) __acquires(RCU)
 {
 	struct ieee80211_local *local = sta->local;
-	int err = 0;
+	int err;
 
 	might_sleep();
 
@@ -570,7 +570,6 @@ int sta_info_insert_rcu(struct sta_info *sta) __acquires(RCU)
 
 	return 0;
  out_free:
-	BUG_ON(!err);
 	sta_info_free(local, sta);
 	return err;
 }
-- 
1.9.0

