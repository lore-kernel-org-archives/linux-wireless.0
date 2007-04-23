Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:38272 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161544AbXDWS6U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2007 14:58:20 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 06/13] mac80211: avoid flush_scheduled_work
Date: Mon, 23 Apr 2007 14:48:13 -0400
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Message-Id: <20070423184813.7029.75057.stgit@magic.sourmilk.net>
In-Reply-To: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

flush_scheduled_work in ieee80211_if_shutdown is called with rtnl held,
which can lead to deadlocks. This patch eliminates that by adding a new
single thread workqueue which can be safely flushed. It is also available
for driver use.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 include/net/mac80211.h         |    4 ++++
 net/mac80211/ieee80211.c       |   30 +++++++++++++-----------------
 net/mac80211/ieee80211_iface.c |    2 +-
 net/mac80211/ieee80211_sta.c   |   24 ++++++++++++++++--------
 net/mac80211/sta_info.c        |    4 ++--
 5 files changed, 36 insertions(+), 28 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 6392c44..b4b6619 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -465,6 +465,10 @@ struct ieee80211_hw {
 	/* assigned by mac80211, don't write */
 	struct ieee80211_conf conf;
 
+	/* Single thread workqueue available for driver use 
+	 * Allocated by mac80211 on registration */
+	struct workqueue_struct *workqueue;
+
 	/* Pointer to the private area that was
 	 * allocated with this struct for you. */
 	void *priv;
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 8a3c749..25ea011 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -2234,18 +2234,13 @@ static void ieee80211_if_shutdown(struct net_device *dev)
 	case IEEE80211_IF_TYPE_IBSS:
 		sdata->u.sta.state = IEEE80211_DISABLED;
 		del_timer_sync(&sdata->u.sta.timer);
-		flush_scheduled_work();
 		skb_queue_purge(&sdata->u.sta.skb_queue);
 		if (!local->ops->hw_scan &&
 		    local->scan_dev == sdata->dev) {
 			local->sta_scanning = 0;
 			cancel_delayed_work(&local->scan_work);
-			flush_scheduled_work();
-			/* see comment in ieee80211_unregister_hw to
-			 * understand why this works */
-			local->scan_dev = NULL;
-		} else
-			flush_scheduled_work();
+		}
+		flush_workqueue(local->hw.workqueue);
 		break;
 	}
 }
@@ -2460,6 +2455,7 @@ static int ieee80211_stop(struct net_device *dev)
 	}
 
 	netif_stop_queue(dev);
+	ieee80211_if_shutdown(dev);
 
 	if (sdata->type == IEEE80211_IF_TYPE_MNTR) {
 		local->monitors--;
@@ -2486,7 +2482,6 @@ static int ieee80211_stop(struct net_device *dev)
 		conf.mac_addr = dev->dev_addr;
 		local->ops->remove_interface(local_to_hw(local), &conf);
 	}
-	ieee80211_if_shutdown(dev);
 
 	ieee80211_start_hard_monitor(local);
 
@@ -4726,12 +4721,20 @@ EXPORT_SYMBOL(ieee80211_alloc_hw);
 int ieee80211_register_hw(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
+	const char *name;
 	int result;
 
 	result = wiphy_register(local->hw.wiphy);
 	if (result < 0)
 		return result;
 
+	name = wiphy_dev(local->hw.wiphy)->driver->name;
+	local->hw.workqueue = create_singlethread_workqueue(name);
+	if (!local->hw.workqueue) {
+		result = -ENOMEM;
+		goto fail_workqueue;
+	}
+
 	debugfs_hw_add(local);
 
 	local->hw.conf.beacon_int = 1000;
@@ -4806,6 +4809,7 @@ fail_dev:
 	sta_info_stop(local);
 fail_sta_info:
 	debugfs_hw_del(local);
+fail_workqueue:
 	wiphy_unregister(local->hw.wiphy);
 	return result;
 }
@@ -4872,15 +4876,6 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 
 	if (local->stat_time)
 		del_timer_sync(&local->stat_timer);
-	if (!local->ops->hw_scan && local->scan_dev) {
-		local->sta_scanning = 0;
-		cancel_delayed_work(&local->scan_work);
-		flush_scheduled_work();
-		/* The scan_work is guaranteed not to be called at this
-		 * point. It is not scheduled and not running now. It can be
-		 * scheduled again only by sta_work (stopped by now) or under
-		 * rtnl lock. */
-	}
 
 	ieee80211_rx_bss_list_deinit(local->mdev);
 	ieee80211_clear_tx_pending(local);
@@ -4900,6 +4895,7 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 	skb_queue_purge(&local->skb_queue);
 	skb_queue_purge(&local->skb_queue_unreliable);
 
+	destroy_workqueue(local->hw.workqueue);
 	wiphy_unregister(local->hw.wiphy);
 	ieee80211_wep_free(local);
 	ieee80211_led_exit(local);
diff --git a/net/mac80211/ieee80211_iface.c b/net/mac80211/ieee80211_iface.c
index 719bc21..cf0f32e 100644
--- a/net/mac80211/ieee80211_iface.c
+++ b/net/mac80211/ieee80211_iface.c
@@ -179,7 +179,7 @@ void ieee80211_if_set_type(struct net_device *dev, int type)
 		ifsta = &sdata->u.sta;
 		INIT_WORK(&ifsta->work, ieee80211_sta_work);
 		setup_timer(&ifsta->timer, ieee80211_sta_timer,
-			    (unsigned long) ifsta);
+			    (unsigned long) sdata);
 		skb_queue_head_init(&ifsta->skb_queue);
 
 		ifsta->capab = WLAN_CAPABILITY_ESS;
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 3d16ed8..0e9e4f9 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -1730,6 +1730,7 @@ static void ieee80211_rx_mgmt_probe_req(struct net_device *dev,
 void ieee80211_sta_rx_mgmt(struct net_device *dev, struct sk_buff *skb,
 			   struct ieee80211_rx_status *rx_status)
 {
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_if_sta *ifsta;
 	struct ieee80211_mgmt *mgmt;
@@ -1755,7 +1756,7 @@ void ieee80211_sta_rx_mgmt(struct net_device *dev, struct sk_buff *skb,
 	case IEEE80211_STYPE_DEAUTH:
 	case IEEE80211_STYPE_DISASSOC:
 		skb_queue_tail(&ifsta->skb_queue, skb);
-		schedule_work(&ifsta->work);
+		queue_work(local->hw.workqueue, &ifsta->work);
 		return;
 	default:
 		printk(KERN_DEBUG "%s: received unknown management frame - "
@@ -1900,9 +1901,13 @@ static void ieee80211_sta_merge_ibss(struct net_device *dev,
 
 void ieee80211_sta_timer(unsigned long data)
 {
-	struct ieee80211_if_sta *ifsta = (struct ieee80211_if_sta *) data;
+	struct ieee80211_sub_if_data *sdata =
+		(struct ieee80211_sub_if_data *) data;
+	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	struct ieee80211_local *local = wdev_priv(&sdata->wdev);
+
 	set_bit(IEEE80211_STA_REQ_RUN, &ifsta->request);
-	schedule_work(&ifsta->work);
+	queue_work(local->hw.workqueue, &ifsta->work);
 }
 
 
@@ -2013,6 +2018,7 @@ static void ieee80211_sta_reset_auth(struct net_device *dev,
 void ieee80211_sta_req_auth(struct net_device *dev,
 			    struct ieee80211_if_sta *ifsta)
 {
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (sdata->type != IEEE80211_IF_TYPE_STA)
@@ -2021,7 +2027,7 @@ void ieee80211_sta_req_auth(struct net_device *dev,
 	if ((ifsta->bssid_set || ifsta->auto_bssid_sel) &&
 	    (ifsta->ssid_set || ifsta->auto_ssid_sel)) {
 		set_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request);
-		schedule_work(&ifsta->work);
+		queue_work(local->hw.workqueue, &ifsta->work);
 	}
 }
 
@@ -2574,7 +2580,7 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw)
 		if (sdata->type == IEEE80211_IF_TYPE_STA) {
 			if (sdata->u.sta.associated)
 				ieee80211_send_nullfunc(local, sdata, 0);
-			ieee80211_sta_timer((unsigned long)&sdata->u.sta);
+			ieee80211_sta_timer((unsigned long)sdata);
 		}
 		netif_wake_queue(sdata->dev);
 	}
@@ -2666,7 +2672,8 @@ void ieee80211_sta_scan_work(struct work_struct *work)
 	}
 
 	if (local->sta_scanning)
-		schedule_delayed_work(&local->scan_work, next_delay);
+		queue_delayed_work(local->hw.workqueue, &local->scan_work,
+				   next_delay);
 }
 
 
@@ -2735,7 +2742,8 @@ static int ieee80211_sta_start_scan(struct net_device *dev,
 	local->scan_channel_idx = 0;
 	local->scan_dev = dev;
 	/* TODO: start scan as soon as all nullfunc frames are ACKed */
-	schedule_delayed_work(&local->scan_work, IEEE80211_CHANNEL_TIME);
+	queue_delayed_work(local->hw.workqueue, &local->scan_work,
+			   IEEE80211_CHANNEL_TIME);
 
 	return 0;
 }
@@ -2757,7 +2765,7 @@ int ieee80211_sta_req_scan(struct net_device *dev, u8 *ssid, size_t ssid_len)
 	}
 
 	set_bit(IEEE80211_STA_REQ_SCAN, &ifsta->request);
-	schedule_work(&ifsta->work);
+	queue_work(local->hw.workqueue, &ifsta->work);
 	return 0;
 }
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 4e341f6..62f90b4 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -184,7 +184,7 @@ struct sta_info * sta_info_add(struct ieee80211_local *local,
 		/* procfs entry adding might sleep, so schedule process context
 		 * task for adding proc entry for STAs that do not yet have
 		 * one. */
-		schedule_work(&local->sta_proc_add);
+		queue_work(local->hw.workqueue, &local->sta_proc_add);
 	}
 
 	return sta;
@@ -275,7 +275,7 @@ void sta_info_free(struct sta_info *sta, int locked)
 
 	if (in_atomic()) {
 		list_add(&sta->list, &local->deleted_sta_list);
-		schedule_work(&local->sta_proc_add);
+		queue_work(local->hw.workqueue, &local->sta_proc_add);
 	} else
 		finish_sta_info_free(local, sta);
 }

