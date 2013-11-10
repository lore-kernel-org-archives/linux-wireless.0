Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:64175 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab3KJVwg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Nov 2013 16:52:36 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH v2] mac80211: add assoc beacon timeout logic
Date: Sun, 10 Nov 2013 15:45:45 -0600
Message-Id: <1384119945-31213-1-git-send-email-felipe.contreras@gmail.com> (sfid-20131110_225256_421235_7DC64F5B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We don't want to be waiting forever for a beacon that will never come,
just continue the association.

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---

The previous version depended on some cleanup patches, plus had some unclear
rerun logic.

 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/mlme.c        | 32 ++++++++++++++++++++++++++------
 2 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 611abfc..e1f858d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -358,6 +358,7 @@ struct ieee80211_mgd_assoc_data {
 	const u8 *supp_rates;
 
 	unsigned long timeout;
+	unsigned long beacon_timeout;
 	int tries;
 
 	u16 capability;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 86e4ad5..68f76f7 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -38,6 +38,7 @@
 #define IEEE80211_ASSOC_TIMEOUT		(HZ / 5)
 #define IEEE80211_ASSOC_TIMEOUT_LONG	(HZ / 2)
 #define IEEE80211_ASSOC_TIMEOUT_SHORT	(HZ / 10)
+#define IEEE80211_ASSOC_BEACON_TIMEOUT	2 * HZ
 #define IEEE80211_ASSOC_MAX_TRIES	3
 
 static int max_nullfunc_tries = 2;
@@ -3475,6 +3476,24 @@ void ieee80211_mgd_conn_tx_status(struct ieee80211_sub_if_data *sdata,
 	ieee80211_queue_work(&local->hw, &sdata->work);
 }
 
+static int check_beacon(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct ieee80211_mgd_assoc_data *assoc_data = ifmgd->assoc_data;
+
+	if (!assoc_data->need_beacon || ifmgd->have_beacon)
+		return true;
+
+	if (time_after(jiffies, assoc_data->beacon_timeout)) {
+		sdata_info(sdata, "no beacon from %pM\n", assoc_data->bss->bssid);
+		return true;
+	}
+
+	assoc_data->timeout = TU_TO_EXP_TIME(assoc_data->bss->beacon_interval);
+	run_again(sdata, assoc_data->timeout);
+	return false;
+}
+
 void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
@@ -3533,12 +3552,12 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 
 	if (ifmgd->assoc_data && ifmgd->assoc_data->timeout_started &&
 	    time_after(jiffies, ifmgd->assoc_data->timeout)) {
-		if ((ifmgd->assoc_data->need_beacon && !ifmgd->have_beacon) ||
-		    ieee80211_do_assoc(sdata)) {
-			struct cfg80211_bss *bss = ifmgd->assoc_data->bss;
-
-			ieee80211_destroy_assoc_data(sdata, false);
-			cfg80211_assoc_timeout(sdata->dev, bss);
+		if (check_beacon(sdata)) {
+			if (ieee80211_do_assoc(sdata)) {
+				struct cfg80211_bss *bss = ifmgd->assoc_data->bss;
+				ieee80211_destroy_assoc_data(sdata, false);
+				cfg80211_assoc_timeout(sdata->dev, bss);
+			}
 		}
 	} else if (ifmgd->assoc_data && ifmgd->assoc_data->timeout_started)
 		run_again(sdata, ifmgd->assoc_data->timeout);
@@ -4335,6 +4354,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 		sdata_info(sdata, "waiting for beacon from %pM\n",
 			   ifmgd->bssid);
 		assoc_data->timeout = TU_TO_EXP_TIME(req->bss->beacon_interval);
+		assoc_data->beacon_timeout = jiffies + IEEE80211_ASSOC_BEACON_TIMEOUT;
 		assoc_data->timeout_started = true;
 		assoc_data->need_beacon = true;
 	} else if (beacon_ies) {
-- 
1.8.4.2+fc1

