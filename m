Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:37568 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab0EaHDA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 May 2010 03:03:00 -0400
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o4V72T6X030479
	for <linux-wireless@vger.kernel.org>; Mon, 31 May 2010 02:02:59 -0500
Received: from localhost.localdomain (wimaxnb.nmp.nokia.com [172.22.211.32])
	by mgw-sa02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o4V72dcZ011221
	for <linux-wireless@vger.kernel.org>; Mon, 31 May 2010 10:02:43 +0300
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCHv2 1/1] mac80211: Add interface for driver to temporarily disable dynamic ps
Date: Mon, 31 May 2010 10:05:47 +0300
Message-Id: <1275289547-7104-2-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1275289547-7104-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1275289547-7104-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This mechanism introduced in this patch applies (at least) for hardware
designs using a single shared antenna for both WLAN and BT. In these designs,
the antenna must be toggled between WLAN and BT.

In those hardware, managing WLAN co-existence with Bluetooth requires WLAN
full power save whenever there is Bluetooth activity in order for WLAN to be
able to periodically relinquish the antenna to be used for BT. This is because
BT can only access the shared antenna when WLAN is idle or asleep.

Some hardware, for instance the wl1271, are able to indicate to the host
whenever there is BT traffic. In essence, the hardware will send an indication
to the host whenever there is, for example, SCO traffic or A2DP traffic, and
will send another indication when the traffic is over.

The hardware gets information of Bluetooth traffic via hardware co-existence
control lines - these lines are used to negotiate the shared antenna
ownership. The hardware will give the antenna to BT whenever WLAN is sleeping.

This patch adds the interface to mac80211 to facilitate temporarily disabling
of dynamic power save as per request of the WLAN driver. This interface will
immediately force WLAN to full powersave, hence allowing BT coexistence as
described above.

In these kind of shared antenna desings, when WLAN powersave is fully disabled,
Bluetooth will not work simultaneously with WLAN at all. This patch does not
address that problem. This interface will not change PSM state, so if PSM is
disabled it will remain so. Solving this problem requires knowledge about BT
state, and is best done in user-space.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 include/net/mac80211.h     |   15 +++++++++++++++
 net/mac80211/ieee80211_i.h |    3 +++
 net/mac80211/iface.c       |    1 +
 net/mac80211/mlme.c        |   20 +++++++++++++++++++-
 net/mac80211/rx.c          |    3 ++-
 net/mac80211/tx.c          |    4 ++++
 6 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index de22cbf..e4a97ea 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2460,6 +2460,21 @@ void ieee80211_beacon_loss(struct ieee80211_vif *vif);
 void ieee80211_connection_loss(struct ieee80211_vif *vif);
 
 /**
+ * ieee80211_disable_dyn_ps - force mac80211 to temporarily disable dynamic psm
+ *
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ *
+ * Some hardware require full power save to manage simultaneous BT traffic
+ * on the WLAN frequency. Full PSM is required periodically, whenever there are
+ * burst of BT traffic. The hardware gets information of BT traffic via
+ * hardware co-existence lines, and consequentially requests mac80211 to
+ * (temporarily) enter full psm.
+ * This function will only temporarily disable dynamic PS, not enable PSM if
+ * it was not already enabled.
+ */
+void ieee80211_disable_dyn_ps(struct ieee80211_vif *vif, bool disable);
+
+/**
  * ieee80211_cqm_rssi_notify - inform a configured connection quality monitoring
  *	rssi threshold triggered
  *
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 1a9e2da..cab32c7 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -505,6 +505,9 @@ struct ieee80211_sub_if_data {
 	 */
 	bool ht_opmode_valid;
 
+	/* dynamic powersave temporarily disabled by driver */
+	bool disable_dyn_ps;
+
 	/* Fragment table for host-based reassembly */
 	struct ieee80211_fragment_entry	fragments[IEEE80211_FRAGMENT_MAX];
 	unsigned int fragment_next;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 50deb01..ac2b8a5 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -421,6 +421,7 @@ static int ieee80211_stop(struct net_device *dev)
 
 	del_timer_sync(&local->dynamic_ps_timer);
 	cancel_work_sync(&local->dynamic_ps_enable_work);
+	sdata->disable_dyn_ps = false;
 
 	/* APs need special treatment */
 	if (sdata->vif.type == NL80211_IFTYPE_AP) {
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0839c4e..aaa86ee 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -478,6 +478,24 @@ static void ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
 	}
 }
 
+void ieee80211_disable_dyn_ps(struct ieee80211_vif *vif, bool disable)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct ieee80211_local *local = sdata->local;
+
+	WARN_ON(sdata->vif.type != NL80211_IFTYPE_STATION);
+
+	sdata->disable_dyn_ps = disable;
+
+	/* immediately go to psm */
+	if (disable && timer_pending(&local->dynamic_ps_timer)) {
+		ieee80211_queue_work(&local->hw,
+				     &local->dynamic_ps_enable_work);
+		del_timer_sync(&local->dynamic_ps_timer);
+	}
+}
+EXPORT_SYMBOL(ieee80211_disable_dyn_ps);
+
 /* powersave */
 static void ieee80211_enable_ps(struct ieee80211_local *local,
 				struct ieee80211_sub_if_data *sdata)
@@ -491,7 +509,7 @@ static void ieee80211_enable_ps(struct ieee80211_local *local,
 	if (local->scanning)
 		return;
 
-	if (conf->dynamic_ps_timeout > 0 &&
+	if (conf->dynamic_ps_timeout > 0 && !sdata->disable_dyn_ps &&
 	    !(local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS)) {
 		mod_timer(&local->dynamic_ps_timer, jiffies +
 			  msecs_to_jiffies(conf->dynamic_ps_timeout));
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 6e2a7bc..e11d52b 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1793,7 +1793,8 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 
 	if (ieee80211_is_data(hdr->frame_control) &&
 	    !is_multicast_ether_addr(hdr->addr1) &&
-	    local->hw.conf.dynamic_ps_timeout > 0 && local->ps_sdata) {
+	    local->hw.conf.dynamic_ps_timeout > 0 && !sdata->disable_dyn_ps &&
+	    local->ps_sdata) {
 			mod_timer(&local->dynamic_ps_timer, jiffies +
 			 msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
 	}
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 680bcb7..6f6b046 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -194,6 +194,10 @@ ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
 	if (local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS)
 		return TX_CONTINUE;
 
+	/* dynamic PS has not been temporarily disabled by driver */
+	if (tx->sdata->disable_dyn_ps)
+		return TX_CONTINUE;
+
 	/* dynamic power save disabled */
 	if (local->hw.conf.dynamic_ps_timeout <= 0)
 		return TX_CONTINUE;
-- 
1.6.3.3

