Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:35940 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbZBWQjP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 11:39:15 -0500
From: Kalle Valo <kalle.valo@nokia.com>
Subject: [RFC PATCH v1 3/3] mac80211: add beacon filtering support
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Date: Mon, 23 Feb 2009 18:37:38 +0200
Message-ID: <20090223163738.20939.25890.stgit@tikku> (sfid-20090223_173917_558042_EC281C54)
In-Reply-To: <20090223163626.20939.4879.stgit@tikku>
References: <20090223163626.20939.4879.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add IEEE80211_HW_BEACON_FILTERING flag so that driver inform that it supports
beacon filtering. Drivers need to call the new function
ieee80211_beacon_loss() to notify about beacon loss.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 include/net/mac80211.h     |    2 ++
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/iface.c       |    3 +++
 net/mac80211/mlme.c        |   34 +++++++++++++++++++++++++++++++++-
 4 files changed, 40 insertions(+), 1 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e01c63a..f74bada 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -903,6 +903,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_PS_NULLFUNC_STACK			= 1<<11,
 	IEEE80211_HW_SUPPORTS_DYNAMIC_PS		= 1<<12,
 	IEEE80211_HW_MFP_CAPABLE			= 1<<13,
+	IEEE80211_HW_BEACON_FILTERING			= 1<<14,
 };
 
 /**
@@ -1971,6 +1972,7 @@ void ieee80211_stop_tx_ba_cb_irqsafe(struct ieee80211_hw *hw, const u8 *ra,
 struct ieee80211_sta *ieee80211_find_sta(struct ieee80211_hw *hw,
 					 const u8 *addr);
 
+void ieee80211_beacon_loss(struct ieee80211_hw *hw);
 
 /* Rate control API */
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 2a19e4c..5cd6296 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -272,6 +272,7 @@ struct ieee80211_if_managed {
 	struct timer_list chswitch_timer;
 	struct work_struct work;
 	struct work_struct chswitch_work;
+	struct work_struct beacon_loss_work;
 
 	u8 bssid[ETH_ALEN], prev_bssid[ETH_ALEN];
 
@@ -1080,6 +1081,7 @@ void ieee80211_send_nullfunc(struct ieee80211_local *local,
 			     struct ieee80211_sub_if_data *sdata,
 			     int powersave);
 void ieee80211_rx_trigger(struct ieee80211_sub_if_data *sdata);
+void ieee80211_beacon_loss_work(struct work_struct *work);
 
 void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
 				     enum queue_stop_reason reason);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 2acc416..e0fa20f 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -470,6 +470,9 @@ static int ieee80211_stop(struct net_device *dev)
 		 */
 		cancel_work_sync(&sdata->u.mgd.work);
 		cancel_work_sync(&sdata->u.mgd.chswitch_work);
+
+		cancel_work_sync(&sdata->u.mgd.beacon_loss_work);
+
 		/*
 		 * When we get here, the interface is marked down.
 		 * Call synchronize_rcu() to wait for the RX path
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d2cc1e0..22cc8e4 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -919,6 +919,36 @@ void ieee80211_rx_trigger(struct ieee80211_sub_if_data *sdata)
 	}
 }
 
+void ieee80211_beacon_loss_work(struct work_struct *work)
+{
+	struct ieee80211_sub_if_data *sdata =
+		container_of(work, struct ieee80211_sub_if_data,
+			     u.mgd.beacon_loss_work);
+
+	printk(KERN_DEBUG "%s: beacon loss from AP %pM "
+	       "- disassociating\n", sdata->dev->name, sdata->u.mgd.bssid);
+
+	ieee80211_set_disassoc(sdata, true, true,
+			       WLAN_REASON_PREV_AUTH_NOT_VALID);
+}
+
+void ieee80211_beacon_loss(struct ieee80211_hw *hw)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_sub_if_data *sdata;
+
+	rcu_read_lock();
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (sdata->vif.type != NL80211_IFTYPE_STATION)
+			continue;
+
+		queue_work(local->hw.workqueue,
+			   &sdata->u.mgd.beacon_loss_work);
+	}
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(ieee80211_beacon_loss);
+
 static void ieee80211_associated(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
@@ -953,7 +983,8 @@ static void ieee80211_associated(struct ieee80211_sub_if_data *sdata)
 		goto unlock;
 	}
 
-	if (time_after(jiffies,
+	if (!(local->hw.flags & IEEE80211_HW_BEACON_FILTERING) &&
+	    time_after(jiffies,
 		       ifmgd->last_beacon + IEEE80211_MONITORING_INTERVAL)) {
 		printk(KERN_DEBUG "%s: beacon loss from AP %pM "
 		       "- sending probe request\n",
@@ -1834,6 +1865,7 @@ void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 	ifmgd = &sdata->u.mgd;
 	INIT_WORK(&ifmgd->work, ieee80211_sta_work);
 	INIT_WORK(&ifmgd->chswitch_work, ieee80211_chswitch_work);
+	INIT_WORK(&ifmgd->beacon_loss_work, ieee80211_beacon_loss_work);
 	setup_timer(&ifmgd->timer, ieee80211_sta_timer,
 		    (unsigned long) sdata);
 	setup_timer(&ifmgd->chswitch_timer, ieee80211_chswitch_timer,

