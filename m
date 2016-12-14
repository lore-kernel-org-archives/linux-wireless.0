Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:35805 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753783AbcLNQay (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Dec 2016 11:30:54 -0500
Received: by mail-wm0-f54.google.com with SMTP id a197so121171274wmd.0
        for <linux-wireless@vger.kernel.org>; Wed, 14 Dec 2016 08:29:44 -0800 (PST)
From: Koen Vandeputte <koen.vandeputte@ncentric.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Koen Vandeputte <koen.vandeputte@ncentric.com>
Subject: [PATCH] mac80211: only alloc mem if a station doesnt exist yet
Date: Wed, 14 Dec 2016 17:28:59 +0100
Message-Id: <1481732939-8237-1-git-send-email-koen.vandeputte@ncentric.com> (sfid-20161214_173102_236741_ED29F149)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This speeds up the function in case a station already exists by avoiding
calling an expensive kzalloc just to free it again after the next check.

Signed-off-by: Koen Vandeputte <koen.vandeputte@ncentric.com>
---
 net/mac80211/sta_info.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 1711bae..0a42e6e 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -513,23 +513,23 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 {
 	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	struct station_info *sinfo;
+	struct station_info *sinfo = NULL;
 	int err = 0;
 
 	lockdep_assert_held(&local->sta_mtx);
 
-	sinfo = kzalloc(sizeof(struct station_info), GFP_KERNEL);
-	if (!sinfo) {
-		err = -ENOMEM;
-		goto out_err;
-	}
-
 	/* check if STA exists already */
 	if (sta_info_get_bss(sdata, sta->sta.addr)) {
 		err = -EEXIST;
 		goto out_err;
 	}
 
+	sinfo = kzalloc(sizeof(struct station_info), GFP_KERNEL);
+	if (!sinfo) {
+		err = -ENOMEM;
+		goto out_err;
+	}
+
 	local->num_sta++;
 	local->sta_generation++;
 	smp_mb();
-- 
2.7.4
