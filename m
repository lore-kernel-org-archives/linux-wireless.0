Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50281 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042AbYIJWMK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 18:12:10 -0400
Message-Id: <20080910220409.405099000@sipsolutions.net> (sfid-20080911_001220_595106_8A3B3439)
References: <20080910220145.707263000@sipsolutions.net>
Date: Thu, 11 Sep 2008 00:01:47 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 02/18] mac80211: move STA timer restart
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This I shouldn't have moved to the scan implementation, move
it back to the MLME where it belongs, to the notification.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |   13 +++++++++++++
 net/mac80211/scan.c |   14 --------------
 2 files changed, 13 insertions(+), 14 deletions(-)

--- everything.orig/net/mac80211/mlme.c	2008-09-10 23:57:50.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-10 23:57:52.000000000 +0200
@@ -2625,6 +2625,13 @@ void ieee80211_sta_work(struct work_stru
 	}
 }
 
+static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
+{
+	if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
+	    ieee80211_vif_is_mesh(&sdata->vif))
+		ieee80211_sta_timer((unsigned long)sdata);
+}
+
 void ieee80211_mlme_notify_scan_completed(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
@@ -2637,4 +2644,10 @@ void ieee80211_mlme_notify_scan_complete
 		    !ieee80211_sta_active_ibss(sdata)))
 			ieee80211_sta_find_ibss(sdata, ifsta);
 	}
+
+	/* Restart STA timers */
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &local->interfaces, list)
+		ieee80211_restart_sta_timer(sdata);
+	rcu_read_unlock();
 }
--- everything.orig/net/mac80211/scan.c	2008-09-10 23:50:30.000000000 +0200
+++ everything/net/mac80211/scan.c	2008-09-10 23:57:52.000000000 +0200
@@ -424,13 +424,6 @@ static void ieee80211_send_nullfunc(stru
 	ieee80211_tx_skb(sdata, skb, 0);
 }
 
-static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
-{
-	if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
-	    ieee80211_vif_is_mesh(&sdata->vif))
-		ieee80211_sta_timer((unsigned long)sdata);
-}
-
 void ieee80211_scan_completed(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
@@ -446,11 +439,6 @@ void ieee80211_scan_completed(struct iee
 		if (ieee80211_hw_config(local))
 			printk(KERN_DEBUG "%s: failed to restore operational "
 			       "channel after scan\n", wiphy_name(local->hw.wiphy));
-		/* Restart STA timer for HW scan case */
-		rcu_read_lock();
-		list_for_each_entry_rcu(sdata, &local->interfaces, list)
-			ieee80211_restart_sta_timer(sdata);
-		rcu_read_unlock();
 
 		goto done;
 	}
@@ -483,8 +471,6 @@ void ieee80211_scan_completed(struct iee
 			}
 		} else
 			netif_tx_wake_all_queues(sdata->dev);
-
-		ieee80211_restart_sta_timer(sdata);
 	}
 	rcu_read_unlock();
 

-- 

