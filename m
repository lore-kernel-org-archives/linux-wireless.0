Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:47863 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753408AbZHYPMH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2009 11:12:07 -0400
Date: Tue, 25 Aug 2009 17:44:28 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Check pending scan request after having
	processed mgd work
Message-ID: <20090825144427.GA20726@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the queued management work items are processed in
ieee80211_sta_work() an item could be removed. This could change the
anybusy from true to false, so we better check whether we can start a
new scan only after having processed the pending work first.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/mlme.c |   28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

--- uml.orig/net/mac80211/mlme.c	2009-08-25 17:29:08.000000000 +0300
+++ uml/net/mac80211/mlme.c	2009-08-25 17:32:04.000000000 +0300
@@ -2123,25 +2123,9 @@ static void ieee80211_sta_work(struct wo
 		}
 	}
 
-	list_for_each_entry(wk, &ifmgd->work_list, list) {
-		if (wk->state != IEEE80211_MGD_STATE_IDLE) {
-			anybusy = true;
-			break;
-		}
-	}
 
 	ieee80211_recalc_idle(local);
 
-	if (!anybusy) {
-		mutex_unlock(&ifmgd->mtx);
-
-		if (test_and_clear_bit(IEEE80211_STA_REQ_SCAN, &ifmgd->request))
-			ieee80211_queue_delayed_work(&local->hw,
-						     &local->scan_work,
-						     round_jiffies_relative(0));
-		return;
-	}
-
 	list_for_each_entry_safe(wk, tmp, &ifmgd->work_list, list) {
 		if (time_is_after_jiffies(wk->timeout)) {
 			/*
@@ -2187,6 +2171,18 @@ static void ieee80211_sta_work(struct wo
 		}
 	}
 
+	list_for_each_entry(wk, &ifmgd->work_list, list) {
+		if (wk->state != IEEE80211_MGD_STATE_IDLE) {
+			anybusy = true;
+			break;
+		}
+	}
+	if (!anybusy &&
+	    test_and_clear_bit(IEEE80211_STA_REQ_SCAN, &ifmgd->request))
+		ieee80211_queue_delayed_work(&local->hw,
+					     &local->scan_work,
+					     round_jiffies_relative(0));
+
 	mutex_unlock(&ifmgd->mtx);
 
 	list_for_each_entry_safe(wk, tmp, &free_work, list) {

-- 
Jouni Malinen                                            PGP id EFC895FA
