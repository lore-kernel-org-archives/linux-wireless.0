Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34927 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbZGJAjz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 20:39:55 -0400
Subject: [PATCH] mac80211: fix multi-use timer
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 10 Jul 2009 02:39:48 +0200
Message-Id: <1247186388.1905.11.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have, sometimes, multiple things that want to
run but don't have their own timer. Introduce a
new function to mac80211's mlme run_again() that
makes sure that the timer will run again at the
_first_ needed time, use that function and also
properly reprogram the timer once it fired.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |   40 +++++++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 7 deletions(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-07-09 17:04:43.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-07-09 22:08:56.000000000 +0200
@@ -72,6 +72,26 @@ static inline void ASSERT_MGD_MTX(struct
 	WARN_ON(!mutex_is_locked(&ifmgd->mtx));
 }
 
+/*
+ * We can have multiple work items (and connection probing)
+ * scheduling this timer, but we need to take care to only
+ * reschedule it when it should fire _earlier_ than it was
+ * asked for before, or if it's not pending right now. This
+ * function ensures that. Note that it then is required to
+ * run this function for all timeouts after the first one
+ * has happened -- the work that runs from this timer will
+ * do that.
+ */
+static void run_again(struct ieee80211_if_managed *ifmgd,
+			     unsigned long timeout)
+{
+	ASSERT_MGD_MTX(ifmgd);
+
+	if (!timer_pending(&ifmgd->timer) ||
+	    time_before(timeout, ifmgd->timer.expires))
+		mod_timer(&ifmgd->timer, timeout);
+}
+
 static int ecw2cw(int ecw)
 {
 	return (1 << ecw) - 1;
@@ -916,7 +936,7 @@ ieee80211_direct_probe(struct ieee80211_
 	ieee80211_send_probe_req(sdata, NULL, wk->ssid, wk->ssid_len, NULL, 0);
 
 	wk->timeout = jiffies + IEEE80211_AUTH_TIMEOUT;
-	mod_timer(&ifmgd->timer, wk->timeout);
+	run_again(ifmgd, wk->timeout);
 
 	return RX_MGMT_NONE;
 }
@@ -958,7 +978,7 @@ ieee80211_authenticate(struct ieee80211_
 	wk->auth_transaction = 2;
 
 	wk->timeout = jiffies + IEEE80211_AUTH_TIMEOUT;
-	mod_timer(&ifmgd->timer, wk->timeout);
+	run_again(ifmgd, wk->timeout);
 
 	return RX_MGMT_NONE;
 }
@@ -1079,7 +1099,7 @@ ieee80211_associate(struct ieee80211_sub
 	ieee80211_send_assoc(sdata, wk);
 
 	wk->timeout = jiffies + IEEE80211_ASSOC_TIMEOUT;
-	mod_timer(&ifmgd->timer, wk->timeout);
+	run_again(ifmgd, wk->timeout);
 
 	return RX_MGMT_NONE;
 }
@@ -1140,7 +1160,7 @@ void ieee80211_beacon_loss_work(struct w
 	ieee80211_send_probe_req(sdata, ifmgd->associated->cbss.bssid,
 				 ssid + 2, ssid[1], NULL, 0);
 
-	mod_timer(&ifmgd->timer, jiffies + IEEE80211_PROBE_WAIT);
+	run_again(ifmgd, jiffies + IEEE80211_PROBE_WAIT);
  out:
 	mutex_unlock(&ifmgd->mtx);
 }
@@ -1350,8 +1370,7 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee
 		       sdata->dev->name, tu, ms);
 		wk->timeout = jiffies + msecs_to_jiffies(ms);
 		if (ms > IEEE80211_ASSOC_TIMEOUT)
-			mod_timer(&ifmgd->timer,
-				  jiffies + msecs_to_jiffies(ms));
+			run_again(ifmgd, jiffies + msecs_to_jiffies(ms));
 		return RX_MGMT_NONE;
 	}
 
@@ -1981,8 +2000,15 @@ static void ieee80211_sta_work(struct wo
 	}
 
 	list_for_each_entry_safe(wk, tmp, &ifmgd->work_list, list) {
-		if (time_before(jiffies, wk->timeout))
+		if (time_is_after_jiffies(wk->timeout)) {
+			/*
+			 * This work item isn't supposed to be worked on
+			 * right now, but take care to adjust the timer
+			 * properly.
+			 */
+			run_again(ifmgd, wk->timeout);
 			continue;
+		}
 
 		switch (wk->state) {
 		default:


