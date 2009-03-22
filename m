Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:51790 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbZCVT6S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 15:58:18 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH v4 5/5] mac80211: add beacon filtering support
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
Date: Sun, 22 Mar 2009 21:57:35 +0200
Message-ID: <20090322195734.26460.31012.stgit@tikku> (sfid-20090322_205820_707418_BC0133FD)
In-Reply-To: <20090322195619.26460.48292.stgit@tikku>
References: <20090322195619.26460.48292.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Add IEEE80211_HW_BEACON_FILTERING flag so that driver inform that it supports
beacon filtering. Drivers need to call the new function
ieee80211_beacon_loss() to notify about beacon loss.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 Documentation/DocBook/mac80211.tmpl |    6 ++++
 include/net/mac80211.h              |   33 ++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h          |    2 +
 net/mac80211/iface.c                |    3 ++
 net/mac80211/mlme.c                 |   49 ++++++++++++++++++++++++++++++++++-
 5 files changed, 92 insertions(+), 1 deletions(-)

diff --git a/Documentation/DocBook/mac80211.tmpl b/Documentation/DocBook/mac80211.tmpl
index 8af6d96..fbeaffc 100644
--- a/Documentation/DocBook/mac80211.tmpl
+++ b/Documentation/DocBook/mac80211.tmpl
@@ -227,6 +227,12 @@ usage should require reading the full document.
 !Pinclude/net/mac80211.h Powersave support
     </chapter>
 
+    <chapter id="beacon-filter">
+      <title>Beacon filter support</title>
+!Pinclude/net/mac80211.h Beacon filter support
+!Finclude/net/mac80211.h ieee80211_beacon_loss
+    </chapter>
+
     <chapter id="qos">
       <title>Multiple queues and QoS support</title>
       <para>TBD</para>
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 174dc1d..d881ed8 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -882,6 +882,10 @@ enum ieee80211_tkip_key_type {
  *
  * @IEEE80211_HW_MFP_CAPABLE:
  *	Hardware supports management frame protection (MFP, IEEE 802.11w).
+ *
+ * @IEEE80211_HW_BEACON_FILTER:
+ *	Hardware supports dropping of irrelevant beacon frames to
+ *	avoid waking up cpu.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_RX_INCLUDES_FCS			= 1<<1,
@@ -897,6 +901,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_PS_NULLFUNC_STACK			= 1<<11,
 	IEEE80211_HW_SUPPORTS_DYNAMIC_PS		= 1<<12,
 	IEEE80211_HW_MFP_CAPABLE			= 1<<13,
+	IEEE80211_HW_BEACON_FILTER			= 1<<14,
 };
 
 /**
@@ -1121,6 +1126,24 @@ ieee80211_get_alt_retry_rate(const struct ieee80211_hw *hw,
  */
 
 /**
+ * DOC: Beacon filter support
+ *
+ * Some hardware have beacon filter support to reduce host cpu wakeups
+ * which will reduce system power consumption. It usuallly works so that
+ * the firmware creates a checksum of the beacon but omits all constantly
+ * changing elements (TSF, TIM etc). Whenever the checksum changes the
+ * beacon is forwarded to the host, otherwise it will be just dropped. That
+ * way the host will only receive beacons where some relevant information
+ * (for example ERP protection or WMM settings) have changed.
+ *
+ * Beacon filter support is informed with %IEEE80211_HW_BEACON_FILTER flag.
+ * The driver needs to enable beacon filter support whenever power save is
+ * enabled, that is %IEEE80211_CONF_PS is set. When power save is enabled,
+ * the stack will not check for beacon miss at all and the driver needs to
+ * notify about complete loss of beacons with ieee80211_beacon_loss().
+ */
+
+/**
  * DOC: Frame filtering
  *
  * mac80211 requires to see many management frames for proper
@@ -1970,6 +1993,16 @@ void ieee80211_stop_tx_ba_cb_irqsafe(struct ieee80211_hw *hw, const u8 *ra,
 struct ieee80211_sta *ieee80211_find_sta(struct ieee80211_hw *hw,
 					 const u8 *addr);
 
+/**
+ * ieee80211_beacon_loss - inform hardware does not receive beacons
+ *
+ * @vif: &struct ieee80211_vif pointer from &struct ieee80211_if_init_conf.
+ *
+ * When beacon filtering is enabled with IEEE80211_HW_BEACON_FILTERING and
+ * IEEE80211_CONF_PS is set, the driver needs to inform whenever the
+ * hardware is not receiving beacons with this function.
+ */
+void ieee80211_beacon_loss(struct ieee80211_vif *vif);
 
 /* Rate control API */
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 73226a9..3a01f35 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -274,6 +274,7 @@ struct ieee80211_if_managed {
 	struct timer_list chswitch_timer;
 	struct work_struct work;
 	struct work_struct chswitch_work;
+	struct work_struct beacon_loss_work;
 
 	u8 bssid[ETH_ALEN], prev_bssid[ETH_ALEN];
 
@@ -1087,6 +1088,7 @@ void ieee80211_send_nullfunc(struct ieee80211_local *local,
 			     int powersave);
 void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
 			     struct ieee80211_hdr *hdr);
+void ieee80211_beacon_loss_work(struct work_struct *work);
 
 void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
 				     enum queue_stop_reason reason);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 34f4798..2de6398 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -478,6 +478,9 @@ static int ieee80211_stop(struct net_device *dev)
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
index b3f784f..8865692 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -610,6 +610,8 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 		bss_info_changed |= ieee80211_handle_bss_capability(sdata,
 			bss->cbss.capability, bss->has_erp_value, bss->erp_value);
 
+		cfg80211_hold_bss(&bss->cbss);
+
 		ieee80211_rx_bss_put(local, bss);
 	}
 
@@ -751,6 +753,8 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_conf *conf = &local_to_hw(local)->conf;
+	struct ieee80211_bss *bss;
 	struct sta_info *sta;
 	u32 changed = 0, config_changed = 0;
 
@@ -774,6 +778,15 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_sta_tear_down_BA_sessions(sta);
 
+	bss = ieee80211_rx_bss_get(local, ifmgd->bssid,
+				   conf->channel->center_freq,
+				   ifmgd->ssid, ifmgd->ssid_len);
+
+	if (bss) {
+		cfg80211_unhold_bss(&bss->cbss);
+		ieee80211_rx_bss_put(local, bss);
+	}
+
 	if (self_disconnected) {
 		if (deauth)
 			ieee80211_send_deauth_disassoc(sdata,
@@ -926,6 +939,33 @@ void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
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
+void ieee80211_beacon_loss(struct ieee80211_vif *vif)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+
+	queue_work(sdata->local->hw.workqueue,
+		   &sdata->u.mgd.beacon_loss_work);
+}
+EXPORT_SYMBOL(ieee80211_beacon_loss);
+
 static void ieee80211_associated(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
@@ -960,7 +1000,13 @@ static void ieee80211_associated(struct ieee80211_sub_if_data *sdata)
 		goto unlock;
 	}
 
-	if (time_after(jiffies,
+	/*
+	 * Beacon filtering is only enabled with power save and then the
+	 * stack should not check for beacon loss.
+	 */
+	if (!((local->hw.flags & IEEE80211_HW_BEACON_FILTER) &&
+	      (local->hw.conf.flags & IEEE80211_CONF_PS)) &&
+	    time_after(jiffies,
 		       ifmgd->last_beacon + IEEE80211_MONITORING_INTERVAL)) {
 		printk(KERN_DEBUG "%s: beacon loss from AP %pM "
 		       "- sending probe request\n",
@@ -1870,6 +1916,7 @@ void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 	ifmgd = &sdata->u.mgd;
 	INIT_WORK(&ifmgd->work, ieee80211_sta_work);
 	INIT_WORK(&ifmgd->chswitch_work, ieee80211_chswitch_work);
+	INIT_WORK(&ifmgd->beacon_loss_work, ieee80211_beacon_loss_work);
 	setup_timer(&ifmgd->timer, ieee80211_sta_timer,
 		    (unsigned long) sdata);
 	setup_timer(&ifmgd->chswitch_timer, ieee80211_chswitch_timer,

