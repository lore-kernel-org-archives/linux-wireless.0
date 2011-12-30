Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40569 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab1L3LTL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Dec 2011 06:19:11 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH] mac80211: remove dead code
Date: Fri, 30 Dec 2011 16:49:01 +0530
Message-ID: <1325243941-8803-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111230_121914_654813_A4DF6F20)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

ieee80211_offchannel_enable_all_ps function is no longer used
and looks like its logic is extensively handled in
ieee80211_offchannel_stop_vifs

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 net/mac80211/ieee80211_i.h |    2 --
 net/mac80211/offchannel.c  |   17 -----------------
 2 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c3f3e43..2f0642d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1221,8 +1221,6 @@ int ieee80211_request_sched_scan_stop(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sched_scan_stopped_work(struct work_struct *work);
 
 /* off-channel helpers */
-void ieee80211_offchannel_enable_all_ps(struct ieee80211_local *local,
-					bool tell_ap);
 void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
 				    bool offchannel_ps_enable);
 void ieee80211_offchannel_return(struct ieee80211_local *local,
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index e4330d8..8818180 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -138,23 +138,6 @@ void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
 	mutex_unlock(&local->iflist_mtx);
 }
 
-void ieee80211_offchannel_enable_all_ps(struct ieee80211_local *local,
-					bool tell_ap)
-{
-	struct ieee80211_sub_if_data *sdata;
-
-	mutex_lock(&local->iflist_mtx);
-	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (!ieee80211_sdata_running(sdata))
-			continue;
-
-		if (sdata->vif.type == NL80211_IFTYPE_STATION &&
-		    sdata->u.mgd.associated)
-			ieee80211_offchannel_ps_enable(sdata, tell_ap);
-	}
-	mutex_unlock(&local->iflist_mtx);
-}
-
 void ieee80211_offchannel_return(struct ieee80211_local *local,
 				 bool offchannel_ps_disable)
 {
-- 
1.7.0.4

