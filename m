Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:40012 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560AbZCNRPt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 13:15:49 -0400
From: Kalle Valo <kalle.valo@nokia.com>
Subject: [RFC PATCH v2 4/4] mac80211: add beacon filtering support
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sat, 14 Mar 2009 19:14:52 +0200
Message-ID: <20090314171452.11126.11618.stgit@tikku> (sfid-20090314_181550_987651_64F46447)
In-Reply-To: <20090314171234.11126.21125.stgit@tikku>
References: <20090314171234.11126.21125.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add IEEE80211_HW_BEACON_FILTERING flag so that driver inform that it supports
beacon filtering. Drivers need to call the new function
ieee80211_beacon_loss() to notify about beacon loss.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 include/net/mac80211.h     |   18 ++++++++++++++++++
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/iface.c       |    3 +++
 net/mac80211/mlme.c        |   39 ++++++++++++++++++++++++++++++++++++++-
 4 files changed, 61 insertions(+), 1 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9ef131d..1262b83 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -888,6 +888,13 @@ enum ieee80211_tkip_key_type {
  *
  * @IEEE80211_HW_MFP_CAPABLE:
  *	Hardware supports management frame protection (MFP, IEEE 802.11w).
+ *
+ * @IEEE80211_HW_BEACON_FILTER: Hardware can drop similar beacon frames to
+ *	avoid waking up cpu. Enabling this flag disables the beacon check
+ *	in mac80211 when in power save mode and the hardware must have an
+ *	event to notify that beacons are lost. Use ieee80211_beacon_loss()
+ *	to notify the event to the stack. The filtering must be enabled
+ *	only when IEEE80211_CONF_PS is set.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_RX_INCLUDES_FCS			= 1<<1,
@@ -903,6 +910,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_PS_NULLFUNC_STACK			= 1<<11,
 	IEEE80211_HW_SUPPORTS_DYNAMIC_PS		= 1<<12,
 	IEEE80211_HW_MFP_CAPABLE			= 1<<13,
+	IEEE80211_HW_BEACON_FILTER			= 1<<14,
 };
 
 /**
@@ -1981,6 +1989,16 @@ void ieee80211_stop_tx_ba_cb_irqsafe(struct ieee80211_hw *hw, const u8 *ra,
 struct ieee80211_sta *ieee80211_find_sta(struct ieee80211_hw *hw,
 					 const u8 *addr);
 
+/**
+ * ieee80211_beacon_loss - inform that hardware does not receive beacons
+ *
+ * @hw: pointer as obtained from ieee80211_alloc_hw()
+ *
+ * When beacon filtering is enabled with IEEE80211_HW_BEACON_FILTERING and
+ * IEEE80211_CONF_PS is set, the driver needs to inform whenever the
+ * hardware is not receiving beacons with this function.
+ */
+void ieee80211_beacon_loss(struct ieee80211_hw *hw);
 
 /* Rate control API */
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 5d3d0bf..488c112 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -272,6 +272,7 @@ struct ieee80211_if_managed {
 	struct timer_list chswitch_timer;
 	struct work_struct work;
 	struct work_struct chswitch_work;
+	struct work_struct beacon_loss_work;
 
 	u8 bssid[ETH_ALEN], prev_bssid[ETH_ALEN];
 
@@ -1083,6 +1084,7 @@ void ieee80211_send_nullfunc(struct ieee80211_local *local,
 			     int powersave);
 void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
 			     struct ieee80211_hdr *hdr);
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
index c235d39..053d75b 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -920,6 +920,41 @@ void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
 			  jiffies + IEEE80211_MONITORING_INTERVAL);
 }
 
+void ieee80211_beacon_loss_work(struct work_struct *work)
+{
+	struct ieee80211_sub_if_data *sdata =
+		container_of(work, struct ieee80211_sub_if_data,
+			     u.mgd.beacon_loss_work);
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+
+	printk(KERN_DEBUG "%s: driver reports beacon loss from AP %pM "
+	       "- sending probe request\n", sdata->dev->name,
+	       sdata->u.mgd.bssid);
+
+	ifmgd->flags |= IEEE80211_STA_PROBEREQ_POLL;
+	ieee80211_send_probe_req(sdata, ifmgd->bssid, ifmgd->ssid,
+				 ifmgd->ssid_len, NULL, 0);
+
+	mod_timer(&ifmgd->timer, jiffies + IEEE80211_MONITORING_INTERVAL);
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
@@ -954,7 +989,8 @@ static void ieee80211_associated(struct ieee80211_sub_if_data *sdata)
 		goto unlock;
 	}
 
-	if (time_after(jiffies,
+	if (!(local->hw.flags & IEEE80211_HW_BEACON_FILTER) &&
+	    time_after(jiffies,
 		       ifmgd->last_beacon + IEEE80211_MONITORING_INTERVAL)) {
 		printk(KERN_DEBUG "%s: beacon loss from AP %pM "
 		       "- sending probe request\n",
@@ -1839,6 +1875,7 @@ void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 	ifmgd = &sdata->u.mgd;
 	INIT_WORK(&ifmgd->work, ieee80211_sta_work);
 	INIT_WORK(&ifmgd->chswitch_work, ieee80211_chswitch_work);
+	INIT_WORK(&ifmgd->beacon_loss_work, ieee80211_beacon_loss_work);
 	setup_timer(&ifmgd->timer, ieee80211_sta_timer,
 		    (unsigned long) sdata);
 	setup_timer(&ifmgd->chswitch_timer, ieee80211_chswitch_timer,

