Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759785Ab3B0PAu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 10:00:50 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2 5/8] mac80211: cleanup suspend/resume on ibss mode
Date: Wed, 27 Feb 2013 16:00:39 +0100
Message-Id: <1361977242-17344-5-git-send-email-sgruszka@redhat.com> (sfid-20130227_160054_386399_D5AA0E66)
In-Reply-To: <1361977242-17344-1-git-send-email-sgruszka@redhat.com>
References: <1361977242-17344-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove not used any longer suspend/resume code.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/ibss.c        | 29 +----------------------------
 net/mac80211/ieee80211_i.h |  4 ----
 2 files changed, 1 insertion(+), 32 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 40b71df..539d4a1 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -985,36 +985,9 @@ static void ieee80211_ibss_timer(unsigned long data)
 {
 	struct ieee80211_sub_if_data *sdata =
 		(struct ieee80211_sub_if_data *) data;
-	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
-	struct ieee80211_local *local = sdata->local;
-
-	if (local->quiescing) {
-		ifibss->timer_running = true;
-		return;
-	}
-
-	ieee80211_queue_work(&local->hw, &sdata->work);
-}
-
-#ifdef CONFIG_PM
-void ieee80211_ibss_quiesce(struct ieee80211_sub_if_data *sdata)
-{
-	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 
-	if (del_timer_sync(&ifibss->timer))
-		ifibss->timer_running = true;
-}
-
-void ieee80211_ibss_restart(struct ieee80211_sub_if_data *sdata)
-{
-	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
-
-	if (ifibss->timer_running) {
-		add_timer(&ifibss->timer);
-		ifibss->timer_running = false;
-	}
+	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
 }
-#endif
 
 void ieee80211_ibss_setup_sdata(struct ieee80211_sub_if_data *sdata)
 {
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 5230694..bd13db3 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -489,8 +489,6 @@ struct ieee80211_if_ibss {
 
 	u32 basic_rates;
 
-	bool timer_running;
-
 	bool fixed_bssid;
 	bool fixed_channel;
 	bool privacy;
@@ -1295,8 +1293,6 @@ void ieee80211_ibss_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 			struct cfg80211_ibss_params *params);
 int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata);
-void ieee80211_ibss_quiesce(struct ieee80211_sub_if_data *sdata);
-void ieee80211_ibss_restart(struct ieee80211_sub_if_data *sdata);
 void ieee80211_ibss_work(struct ieee80211_sub_if_data *sdata);
 void ieee80211_ibss_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 				   struct sk_buff *skb);
-- 
1.7.11.7

