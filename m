Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51290 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757101Ab3BMN0M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 08:26:12 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: jan.brummer@tabos.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: always unblock CSA queue stop when disconnecting
Date: Wed, 13 Feb 2013 14:26:06 +0100
Message-Id: <1360761966-32111-1-git-send-email-johannes@sipsolutions.net> (sfid-20130213_142616_988845_62AF5833)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In some cases when disconnecting after (or during?) CSA
the queues might not recover, and then the only way to
recover is reloading the module.

Fix this by always unblocking the queue CSA reason when
disconnecting.

Reported-by: Jan-Michael Brummer <jan.brummer@tabos.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d75c650..f9da6de 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2059,6 +2059,9 @@ static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata)
 			       WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,
 			       true, frame_buf);
 	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
+	ieee80211_wake_queues_by_reason(&sdata->local->hw,
+					IEEE80211_MAX_QUEUE_MAP,
+					IEEE80211_QUEUE_STOP_REASON_CSA);
 	mutex_unlock(&ifmgd->mtx);
 
 	/*
@@ -2099,9 +2102,6 @@ static void ieee80211_csa_connection_drop_work(struct work_struct *work)
 		container_of(work, struct ieee80211_sub_if_data,
 			     u.mgd.csa_connection_drop_work);
 
-	ieee80211_wake_queues_by_reason(&sdata->local->hw,
-					IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_CSA);
 	__ieee80211_disconnect(sdata);
 }
 
-- 
1.8.0

