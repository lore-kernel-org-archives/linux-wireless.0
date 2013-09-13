Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952Ab3IMKiM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Sep 2013 06:38:12 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: ilw@linux.intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 2/5] Revert "mac80211: cleanup suspend/resume on ibss mode"
Date: Fri, 13 Sep 2013 12:36:05 +0200
Message-Id: <1379068568-27552-3-git-send-email-sgruszka@redhat.com> (sfid-20130913_123823_421383_90598D2C)
In-Reply-To: <1379068568-27552-1-git-send-email-sgruszka@redhat.com>
References: <1379068568-27552-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit a61829437e68c8b2036cf5005ed0e875451c9120.
---
 net/mac80211/ibss.c        | 29 ++++++++++++++++++++++++++++-
 net/mac80211/ieee80211_i.h |  4 ++++
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index a12afe7..91d1b29 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1155,9 +1155,36 @@ static void ieee80211_ibss_timer(unsigned long data)
 {
 	struct ieee80211_sub_if_data *sdata =
 		(struct ieee80211_sub_if_data *) data;
+	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+	struct ieee80211_local *local = sdata->local;
 
-	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
+	if (local->quiescing) {
+		ifibss->timer_running = true;
+		return;
+	}
+
+	ieee80211_queue_work(&local->hw, &sdata->work);
+}
+
+#ifdef CONFIG_PM
+void ieee80211_ibss_quiesce(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+
+	if (del_timer_sync(&ifibss->timer))
+		ifibss->timer_running = true;
+}
+
+void ieee80211_ibss_restart(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+
+	if (ifibss->timer_running) {
+		add_timer(&ifibss->timer);
+		ifibss->timer_running = false;
+	}
 }
+#endif
 
 void ieee80211_ibss_setup_sdata(struct ieee80211_sub_if_data *sdata)
 {
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 4b7ef89..96ac8f8 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -492,6 +492,8 @@ struct ieee80211_if_ibss {
 
 	u32 basic_rates;
 
+	bool timer_running;
+
 	bool fixed_bssid;
 	bool fixed_channel;
 	bool privacy;
@@ -1329,6 +1331,8 @@ void ieee80211_ibss_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 			struct cfg80211_ibss_params *params);
 int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata);
+void ieee80211_ibss_quiesce(struct ieee80211_sub_if_data *sdata);
+void ieee80211_ibss_restart(struct ieee80211_sub_if_data *sdata);
 void ieee80211_ibss_work(struct ieee80211_sub_if_data *sdata);
 void ieee80211_ibss_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 				   struct sk_buff *skb);
-- 
1.8.3.1

