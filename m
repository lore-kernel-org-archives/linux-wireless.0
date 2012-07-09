Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34186 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab2GIMgL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 08:36:11 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: remove unused assignment
Date: Mon,  9 Jul 2012 14:35:59 +0200
Message-Id: <1341837359-17961-1-git-send-email-johannes@sipsolutions.net> (sfid-20120709_143614_632436_3C41AC7D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

ieee80211_mlme_notify_scan_completed() iterates all
interfaces and doesn't need to assign anything to
the sdata variable before the loop.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 46eef71..4efcbf8 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2972,7 +2972,7 @@ void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 /* scan finished notification */
 void ieee80211_mlme_notify_scan_completed(struct ieee80211_local *local)
 {
-	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
+	struct ieee80211_sub_if_data *sdata;
 
 	/* Restart STA timers */
 	rcu_read_lock();
-- 
1.7.10.4

