Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60624 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbZD2Jcv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2009 05:32:51 -0400
Subject: [PATCH] mac80211: tell driver when idle
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 29 Apr 2009 11:32:17 +0200
Message-Id: <1240997537.593.35.camel@johannes.local> (sfid-20090429_113258_830522_7A916290)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we aren't doing anything in mac80211, we can turn off
much of the hardware, depending on the driver/hw. Not doing
anything, aka being idle, means:

 * no monitor interfaces
 * no AP/mesh/wds interfaces
 * any station interfaces are in DISABLED state
 * any IBSS interfaces aren't trying to be in a network
 * we aren't trying to scan

By creating a new function that verifies these conditions and calling
it at strategic points where the states of those conditions change,
we can easily make mac80211 tell the driver when we are idle to save
power.

Additionally, this fixes a small quirk where a recalculated powersave
state is passed to the driver even if the hardware is about to stopped
completely.

This patch intentionally doesn't touch radio_enabled because that is
currently implemented to be a soft rfkill which is inappropriate here
when we need to be able to wake up with low latency.

One thing I'm not entirely sure about is this:

  phy0: device no longer idle - in use
  wlan0: direct probe to AP 00:11:24:91:07:4d try 1
  wlan0 direct probe responded
  wlan0: authenticate with AP 00:11:24:91:07:4d
  wlan0: authenticated
> phy0: device now idle
> phy0: device no longer idle - in use
  wlan0: associate with AP 00:11:24:91:07:4d
  wlan0: RX AssocResp from 00:11:24:91:07:4d (capab=0x401 status=0 aid=1)
  wlan0: associated

Is it appropriate to go into idle state for a short time when we have
just authenticated, but not associated yet? This happens only with the
userspace SME, because we cannot really know how long it will wait
before asking us to associate. Would going idle after a short timeout
be more appropriate? We may need to revisit this, depending on what
happens.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/mac80211_hwsim.c |    6 +-
 include/net/mac80211.h                |    8 +++
 net/mac80211/ibss.c                   |    5 ++
 net/mac80211/ieee80211_i.h            |    2 
 net/mac80211/iface.c                  |   78 +++++++++++++++++++++++++++++++++-
 net/mac80211/mlme.c                   |   10 ++++
 net/mac80211/scan.c                   |   17 +++----
 7 files changed, 112 insertions(+), 14 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-04-29 00:00:05.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-04-29 00:01:52.000000000 +0200
@@ -985,6 +985,8 @@ int ieee80211_if_change_type(struct ieee
 			     enum nl80211_iftype type);
 void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata);
 void ieee80211_remove_interfaces(struct ieee80211_local *local);
+u32 __ieee80211_recalc_idle(struct ieee80211_local *local);
+void ieee80211_recalc_idle(struct ieee80211_local *local);
 
 /* tx handling */
 void ieee80211_clear_tx_pending(struct ieee80211_local *local);
--- wireless-testing.orig/net/mac80211/iface.c	2009-04-29 00:00:05.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2009-04-29 00:01:52.000000000 +0200
@@ -301,6 +301,8 @@ static int ieee80211_open(struct net_dev
 	if (sdata->flags & IEEE80211_SDATA_PROMISC)
 		atomic_inc(&local->iff_promiscs);
 
+	hw_reconf_flags |= __ieee80211_recalc_idle(local);
+
 	local->open_count++;
 	if (hw_reconf_flags) {
 		ieee80211_hw_config(local, hw_reconf_flags);
@@ -548,6 +550,10 @@ static int ieee80211_stop(struct net_dev
 
 	sdata->bss = NULL;
 
+	hw_reconf_flags |= __ieee80211_recalc_idle(local);
+
+	ieee80211_recalc_ps(local, -1);
+
 	if (local->open_count == 0) {
 		if (netif_running(local->mdev))
 			dev_close(local->mdev);
@@ -565,8 +571,6 @@ static int ieee80211_stop(struct net_dev
 		hw_reconf_flags = 0;
 	}
 
-	ieee80211_recalc_ps(local, -1);
-
 	/* do after stop to avoid reconfiguring when we stop anyway */
 	if (hw_reconf_flags)
 		ieee80211_hw_config(local, hw_reconf_flags);
@@ -892,3 +896,73 @@ void ieee80211_remove_interfaces(struct 
 		unregister_netdevice(sdata->dev);
 	}
 }
+
+static u32 ieee80211_idle_off(struct ieee80211_local *local,
+			      const char *reason)
+{
+	if (!(local->hw.conf.flags & IEEE80211_CONF_IDLE))
+		return 0;
+
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+	printk(KERN_DEBUG "%s: device no longer idle - %s\n",
+	       wiphy_name(local->hw.wiphy), reason);
+#endif
+
+	local->hw.conf.flags &= ~IEEE80211_CONF_IDLE;
+	return IEEE80211_CONF_CHANGE_IDLE;
+}
+
+static u32 ieee80211_idle_on(struct ieee80211_local *local)
+{
+	if (local->hw.conf.flags & IEEE80211_CONF_IDLE)
+		return 0;
+
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+	printk(KERN_DEBUG "%s: device now idle\n",
+	       wiphy_name(local->hw.wiphy));
+#endif
+
+	local->hw.conf.flags |= IEEE80211_CONF_IDLE;
+	return IEEE80211_CONF_CHANGE_IDLE;
+}
+
+u32 __ieee80211_recalc_idle(struct ieee80211_local *local)
+{
+	struct ieee80211_sub_if_data *sdata;
+	int count = 0;
+
+	if (local->hw_scanning || local->sw_scanning)
+		return ieee80211_idle_off(local, "scanning");
+
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (!netif_running(sdata->dev))
+			continue;
+		/* do not count disabled managed interfaces */
+		if (sdata->vif.type == NL80211_IFTYPE_STATION &&
+		    sdata->u.mgd.state == IEEE80211_STA_MLME_DISABLED)
+			continue;
+		/* do not count unused IBSS interfaces */
+		if (sdata->vif.type == NL80211_IFTYPE_ADHOC &&
+		    !sdata->u.ibss.ssid_len)
+			continue;
+		/* count everything else */
+		count++;
+	}
+
+	if (!count)
+		return ieee80211_idle_on(local);
+	else
+		return ieee80211_idle_off(local, "in use");
+
+	return 0;
+}
+
+void ieee80211_recalc_idle(struct ieee80211_local *local)
+{
+	u32 chg;
+
+	mutex_lock(&local->iflist_mtx);
+	chg = __ieee80211_recalc_idle(local);
+	mutex_unlock(&local->iflist_mtx);
+	ieee80211_hw_config(local, chg);
+}
--- wireless-testing.orig/net/mac80211/ibss.c	2009-04-29 00:00:05.000000000 +0200
+++ wireless-testing/net/mac80211/ibss.c	2009-04-29 00:01:52.000000000 +0200
@@ -862,6 +862,8 @@ int ieee80211_ibss_join(struct ieee80211
 
 	sdata->u.ibss.ssid_len = params->ssid_len;
 
+	ieee80211_recalc_idle(sdata->local);
+
 	set_bit(IEEE80211_IBSS_REQ_RUN, &sdata->u.ibss.request);
 	queue_work(sdata->local->hw.workqueue, &sdata->u.ibss.work);
 
@@ -889,6 +891,9 @@ int ieee80211_ibss_leave(struct ieee8021
 
 	skb_queue_purge(&sdata->u.ibss.skb_queue);
 	memset(sdata->u.ibss.bssid, 0, ETH_ALEN);
+	sdata->u.ibss.ssid_len = 0;
+
+	ieee80211_recalc_idle(sdata->local);
 
 	return 0;
 }
--- wireless-testing.orig/net/mac80211/scan.c	2009-04-29 00:00:05.000000000 +0200
+++ wireless-testing/net/mac80211/scan.c	2009-04-29 00:01:52.000000000 +0200
@@ -302,17 +302,9 @@ void ieee80211_scan_completed(struct iee
 	/* we only have to protect scan_req and hw/sw scan */
 	mutex_unlock(&local->scan_mtx);
 
-	if (was_hw_scan) {
-		/*
-		 * Somebody might have requested channel change during scan
-		 * that we won't have acted upon, try now. ieee80211_hw_config
-		 * will set the flag based on actual changes.
-		 */
-		ieee80211_hw_config(local, 0);
-		goto done;
-	}
-
 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+	if (was_hw_scan)
+		goto done;
 
 	netif_tx_lock_bh(local->mdev);
 	netif_addr_lock(local->mdev);
@@ -351,6 +343,7 @@ void ieee80211_scan_completed(struct iee
 	mutex_unlock(&local->iflist_mtx);
 
  done:
+	ieee80211_recalc_idle(local);
 	ieee80211_mlme_notify_scan_completed(local);
 	ieee80211_ibss_notify_scan_completed(local);
 	ieee80211_mesh_notify_scan_completed(local);
@@ -471,6 +464,8 @@ static int __ieee80211_start_scan(struct
 	 * dependency, so that the scan completed calls
 	 * have more locking freedom.
 	 */
+
+	ieee80211_recalc_idle(local);
 	mutex_unlock(&local->scan_mtx);
 
 	if (local->ops->hw_scan)
@@ -487,6 +482,8 @@ static int __ieee80211_start_scan(struct
 		} else
 			local->sw_scanning = false;
 
+		ieee80211_recalc_idle(local);
+
 		local->scan_req = NULL;
 		local->scan_sdata = NULL;
 	}
--- wireless-testing.orig/net/mac80211/mlme.c	2009-04-29 00:01:49.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-04-29 00:01:52.000000000 +0200
@@ -897,6 +897,7 @@ static void ieee80211_direct_probe(struc
 		printk(KERN_DEBUG "%s: direct probe to AP %pM timed out\n",
 		       sdata->dev->name, ifmgd->bssid);
 		ifmgd->state = IEEE80211_STA_MLME_DISABLED;
+		ieee80211_recalc_idle(local);
 		cfg80211_send_auth_timeout(sdata->dev, ifmgd->bssid);
 
 		/*
@@ -945,6 +946,7 @@ static void ieee80211_authenticate(struc
 		       " timed out\n",
 		       sdata->dev->name, ifmgd->bssid);
 		ifmgd->state = IEEE80211_STA_MLME_DISABLED;
+		ieee80211_recalc_idle(local);
 		cfg80211_send_auth_timeout(sdata->dev, ifmgd->bssid);
 		ieee80211_rx_bss_remove(sdata, ifmgd->bssid,
 				sdata->local->hw.conf.channel->center_freq,
@@ -1041,6 +1043,7 @@ static void ieee80211_set_disassoc(struc
 
 	if (self_disconnected || reason == WLAN_REASON_DISASSOC_STA_HAS_LEFT) {
 		ifmgd->state = IEEE80211_STA_MLME_DISABLED;
+		ieee80211_recalc_idle(local);
 		ieee80211_rx_bss_remove(sdata, ifmgd->bssid,
 				sdata->local->hw.conf.channel->center_freq,
 				ifmgd->ssid, ifmgd->ssid_len);
@@ -1128,6 +1131,7 @@ static void ieee80211_associate(struct i
 		       " timed out\n",
 		       sdata->dev->name, ifmgd->bssid);
 		ifmgd->state = IEEE80211_STA_MLME_DISABLED;
+		ieee80211_recalc_idle(local);
 		cfg80211_send_assoc_timeout(sdata->dev, ifmgd->bssid);
 		ieee80211_rx_bss_remove(sdata, ifmgd->bssid,
 				sdata->local->hw.conf.channel->center_freq,
@@ -1148,6 +1152,7 @@ static void ieee80211_associate(struct i
 		printk(KERN_DEBUG "%s: mismatch in privacy configuration and "
 		       "mixed-cell disabled - abort association\n", sdata->dev->name);
 		ifmgd->state = IEEE80211_STA_MLME_DISABLED;
+		ieee80211_recalc_idle(local);
 		return;
 	}
 
@@ -1286,6 +1291,7 @@ static void ieee80211_auth_completed(str
 	if (ifmgd->flags & IEEE80211_STA_EXT_SME) {
 		/* Wait for SME to request association */
 		ifmgd->state = IEEE80211_STA_MLME_DISABLED;
+		ieee80211_recalc_idle(sdata->local);
 	} else
 		ieee80211_associate(sdata);
 }
@@ -1522,6 +1528,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 		if (ifmgd->flags & IEEE80211_STA_EXT_SME) {
 			/* Wait for SME to decide what to do next */
 			ifmgd->state = IEEE80211_STA_MLME_DISABLED;
+			ieee80211_recalc_idle(local);
 		}
 		return;
 	}
@@ -2090,6 +2097,7 @@ static int ieee80211_sta_config_auth(str
 		} else {
 			ifmgd->assoc_scan_tries = 0;
 			ifmgd->state = IEEE80211_STA_MLME_DISABLED;
+			ieee80211_recalc_idle(local);
 		}
 	}
 	return -1;
@@ -2133,6 +2141,8 @@ static void ieee80211_sta_work(struct wo
 	} else if (!test_and_clear_bit(IEEE80211_STA_REQ_RUN, &ifmgd->request))
 		return;
 
+	ieee80211_recalc_idle(local);
+
 	switch (ifmgd->state) {
 	case IEEE80211_STA_MLME_DISABLED:
 		break;
--- wireless-testing.orig/include/net/mac80211.h	2009-04-29 00:00:05.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2009-04-29 00:01:52.000000000 +0200
@@ -533,10 +533,16 @@ struct ieee80211_rx_status {
  *
  * @IEEE80211_CONF_RADIOTAP: add radiotap header at receive time (if supported)
  * @IEEE80211_CONF_PS: Enable 802.11 power save mode (managed mode only)
+ * @IEEE80211_CONF_IDLE: The device is running, but idle; if the flag is set
+ *	the driver should be prepared to handle configuration requests but
+ *	may turn the device off as much as possible. Typically, this flag will
+ *	be set when an interface is set UP but not associated or scanning, but
+ *	it can also be unset in that case when monitor interfaces are active.
  */
 enum ieee80211_conf_flags {
 	IEEE80211_CONF_RADIOTAP		= (1<<0),
 	IEEE80211_CONF_PS		= (1<<1),
+	IEEE80211_CONF_IDLE		= (1<<2),
 };
 
 
@@ -551,6 +557,7 @@ enum ieee80211_conf_flags {
  * @IEEE80211_CONF_CHANGE_POWER: the TX power changed
  * @IEEE80211_CONF_CHANGE_CHANNEL: the channel/channel_type changed
  * @IEEE80211_CONF_CHANGE_RETRY_LIMITS: retry limits changed
+ * @IEEE80211_CONF_CHANGE_IDLE: Idle flag changed
  */
 enum ieee80211_conf_changed {
 	IEEE80211_CONF_CHANGE_RADIO_ENABLED	= BIT(0),
@@ -561,6 +568,7 @@ enum ieee80211_conf_changed {
 	IEEE80211_CONF_CHANGE_POWER		= BIT(5),
 	IEEE80211_CONF_CHANGE_CHANNEL		= BIT(6),
 	IEEE80211_CONF_CHANGE_RETRY_LIMITS	= BIT(7),
+	IEEE80211_CONF_CHANGE_IDLE		= BIT(8),
 };
 
 static inline __deprecated enum ieee80211_conf_changed
--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2009-04-29 00:01:49.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2009-04-29 00:01:52.000000000 +0200
@@ -554,9 +554,11 @@ static int mac80211_hwsim_config(struct 
 	struct mac80211_hwsim_data *data = hw->priv;
 	struct ieee80211_conf *conf = &hw->conf;
 
-	printk(KERN_DEBUG "%s:%s (freq=%d radio_enabled=%d)\n",
+	printk(KERN_DEBUG "%s:%s (freq=%d radio_enabled=%d idle=%d ps=%d)\n",
 	       wiphy_name(hw->wiphy), __func__,
-	       conf->channel->center_freq, conf->radio_enabled);
+	       conf->channel->center_freq, conf->radio_enabled,
+	       !!(conf->flags & IEEE80211_CONF_IDLE),
+	       !!(conf->flags & IEEE80211_CONF_PS));
 
 	data->channel = conf->channel;
 	data->radio_enabled = conf->radio_enabled;


