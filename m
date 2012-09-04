Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40980 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756944Ab2IDMSk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 08:18:40 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH] mac80211: Do not check for valid hw_queues for P2P_DEVICE
Date: Tue,  4 Sep 2012 14:19:15 +0200
Message-Id: <1346761155-23242-1-git-send-email-johannes@sipsolutions.net> (sfid-20120904_141844_559190_D4FE9A88)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

A P2P Device interface does not have a netdev, and is not
expected to be used for transmitting data, so there is no
need to assign hw queues for it.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 59f8adc..d747da5 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -278,13 +278,15 @@ static int ieee80211_check_queues(struct ieee80211_sub_if_data *sdata)
 	int n_queues = sdata->local->hw.queues;
 	int i;
 
-	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
-		if (WARN_ON_ONCE(sdata->vif.hw_queue[i] ==
-				 IEEE80211_INVAL_HW_QUEUE))
-			return -EINVAL;
-		if (WARN_ON_ONCE(sdata->vif.hw_queue[i] >=
-				 n_queues))
-			return -EINVAL;
+	if (sdata->vif.type != NL80211_IFTYPE_P2P_DEVICE) {
+		for (i = 0; i < IEEE80211_NUM_ACS; i++) {
+			if (WARN_ON_ONCE(sdata->vif.hw_queue[i] ==
+					 IEEE80211_INVAL_HW_QUEUE))
+				return -EINVAL;
+			if (WARN_ON_ONCE(sdata->vif.hw_queue[i] >=
+					 n_queues))
+				return -EINVAL;
+		}
 	}
 
 	if ((sdata->vif.type != NL80211_IFTYPE_AP) ||
-- 
1.7.10.4

