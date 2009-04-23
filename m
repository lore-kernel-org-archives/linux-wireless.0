Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37536 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbZDWAWv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 20:22:51 -0400
Subject: [RFC/RFT] mac80211: turn off radio when idle
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
Content-Type: text/plain
Date: Thu, 23 Apr 2009 02:22:15 +0200
Message-Id: <1240446135.30082.170.camel@johannes.local> (sfid-20090423_022256_627296_5ACA8C66)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we aren't doing anything in mac80211, we can turn off
the radio. Not doing anything means:

 * no monitor interfaces
 * no AP/mesh/wds interfaces
 * any station interfaces are in DISABLED state
 * any IBSS interfaces aren't trying to be in a network
 * we aren't trying to scan

By creating a new function that verifies these conditions and
calling it at strategic points where the states of those
conditions change, we can easily make mac80211 turn off the
radio whenever we are idle to save power.

Additionally, this fixes a small quirk where a recalculated
powersave state is passed to the driver even if the hardware
is about to stopped completely.

Finally, also return an error (-ENOLINK) when somebody tries
to join an IBSS, connect to an AP or scan when the radio was
manually disabled with iwconfig.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
This totally messes up iwlwifi: http://paste.pocoo.org/show/113789/

You'll see:
[ 1455.006896] phy0: turning off radio - idle
...
[ 1455.020180] phy0: turning on radio - scan
[ 1455.020202] ieee80211 phy0: U iwl_mac_config enter to channel 1 changed 0x1
[ 1455.031724] ieee80211 phy0: U iwl_mac_config leave - RF-KILL - waiting for uCode
[ 1455.031739] ieee80211 phy0: U iwl_mac_config leave
[ 1455.031752] ieee80211 phy0: U iwl_mac_hw_scan enter
[ 1455.031764] ieee80211 phy0: U iwl_mac_hw_scan leave - not ready or exit pending
[ 1455.031798] phy0: turning off radio - idle

at that point, things get so confused that you can't even scan any more
because something isn't properly reporting to cfg80211 that the scan
ended (but wasn't successful.)

But disregarding iwlwifi, which we can fix by making enable-radio do
something else, what do you think?

 net/mac80211/cfg.c         |   21 ++++++++---
 net/mac80211/ibss.c        |    5 ++
 net/mac80211/ieee80211_i.h |    5 ++
 net/mac80211/iface.c       |   81 +++++++++++++++++++++++++++++++++++++++++++--
 net/mac80211/mlme.c        |   10 +++++
 net/mac80211/scan.c        |    8 ++++
 net/mac80211/wext.c        |    9 ++---
 7 files changed, 126 insertions(+), 13 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-04-22 23:16:43.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-04-22 23:26:07.000000000 +0200
@@ -745,6 +745,8 @@ struct ieee80211_local {
 	int user_power_level; /* in dBm */
 	int power_constr_level; /* in dBm */
 
+	bool wext_power_disabled;
+
 	struct work_struct restart_work;
 
 #ifdef CONFIG_MAC80211_DEBUGFS
@@ -987,6 +989,9 @@ int ieee80211_if_change_type(struct ieee
 			     enum nl80211_iftype type);
 void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata);
 void ieee80211_remove_interfaces(struct ieee80211_local *local);
+u32 __ieee80211_recalc_radio_enable(struct ieee80211_local *local);
+void ieee80211_recalc_radio_enable(struct ieee80211_local *local);
+
 
 /* tx handling */
 void ieee80211_clear_tx_pending(struct ieee80211_local *local);
--- wireless-testing.orig/net/mac80211/iface.c	2009-04-22 23:26:28.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2009-04-23 00:04:23.000000000 +0200
@@ -302,6 +302,8 @@ static int ieee80211_open(struct net_dev
 	if (sdata->flags & IEEE80211_SDATA_PROMISC)
 		atomic_inc(&local->iff_promiscs);
 
+	hw_reconf_flags |= __ieee80211_recalc_radio_enable(local);
+
 	local->open_count++;
 	if (hw_reconf_flags) {
 		ieee80211_hw_config(local, hw_reconf_flags);
@@ -549,6 +551,10 @@ static int ieee80211_stop(struct net_dev
 
 	sdata->bss = NULL;
 
+	hw_reconf_flags |= __ieee80211_recalc_radio_enable(local);
+
+	ieee80211_recalc_ps(local, -1);
+
 	if (local->open_count == 0) {
 		if (netif_running(local->mdev))
 			dev_close(local->mdev);
@@ -567,8 +573,6 @@ static int ieee80211_stop(struct net_dev
 		hw_reconf_flags = 0;
 	}
 
-	ieee80211_recalc_ps(local, -1);
-
 	/* do after stop to avoid reconfiguring when we stop anyway */
 	if (hw_reconf_flags)
 		ieee80211_hw_config(local, hw_reconf_flags);
@@ -894,3 +898,76 @@ void ieee80211_remove_interfaces(struct 
 		unregister_netdevice(sdata->dev);
 	}
 }
+
+u32 __ieee80211_recalc_radio_enable(struct ieee80211_local *local)
+{
+	struct ieee80211_sub_if_data *sdata;
+	int count = 0;
+
+	if (local->wext_power_disabled) {
+		if (local->hw.conf.radio_enabled) {
+			local->hw.conf.radio_enabled = false;
+			return IEEE80211_CONF_CHANGE_RADIO_ENABLED;
+		}
+
+		return 0;
+	}
+
+	if (local->hw_scanning || local->sw_scanning) {
+		if (!local->hw.conf.radio_enabled) {
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+			printk(KERN_DEBUG "%s: turning on radio - scan\n",
+			       wiphy_name(local->hw.wiphy));
+#endif
+			local->hw.conf.radio_enabled = true;
+			return IEEE80211_CONF_CHANGE_RADIO_ENABLED;
+		}
+
+		return 0;
+	}
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
+	if (!count && local->hw.conf.radio_enabled) {
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+		printk(KERN_DEBUG "%s: turning off radio - idle\n",
+		       wiphy_name(local->hw.wiphy));
+#endif
+		local->hw.conf.radio_enabled = false;
+		return IEEE80211_CONF_CHANGE_RADIO_ENABLED;
+	}
+
+	if (count && !local->hw.conf.radio_enabled) {
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+		printk(KERN_DEBUG "%s: turning on radio - in use\n",
+		       wiphy_name(local->hw.wiphy));
+#endif
+		local->hw.conf.radio_enabled = true;
+		return IEEE80211_CONF_CHANGE_RADIO_ENABLED;
+	}
+
+	return 0;
+}
+
+void ieee80211_recalc_radio_enable(struct ieee80211_local *local)
+{
+	u32 chg;
+
+	mutex_lock(&local->iflist_mtx);
+	chg = __ieee80211_recalc_radio_enable(local);
+	mutex_unlock(&local->iflist_mtx);
+	ieee80211_hw_config(local, chg);
+}
--- wireless-testing.orig/net/mac80211/wext.c	2009-04-22 23:17:19.000000000 +0200
+++ wireless-testing/net/mac80211/wext.c	2009-04-22 23:56:27.000000000 +0200
@@ -446,10 +446,9 @@ static int ieee80211_ioctl_siwtxpower(st
 		local->user_power_level = new_power_level;
 	}
 
-	if (local->hw.conf.radio_enabled != !(data->txpower.disabled)) {
-		local->hw.conf.radio_enabled = !(data->txpower.disabled);
-		reconf_flags |= IEEE80211_CONF_CHANGE_RADIO_ENABLED;
-		ieee80211_led_radio(local, local->hw.conf.radio_enabled);
+	if (local->wext_power_disabled != !!data->txpower.disabled) {
+		local->wext_power_disabled = !!data->txpower.disabled;
+		reconf_flags |= __ieee80211_recalc_radio_enable(local);
 	}
 
 	if (reconf || reconf_flags)
@@ -465,7 +464,7 @@ static int ieee80211_ioctl_giwtxpower(st
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 
 	data->txpower.fixed = 1;
-	data->txpower.disabled = !(local->hw.conf.radio_enabled);
+	data->txpower.disabled = local->wext_power_disabled;
 	data->txpower.value = local->hw.conf.power_level;
 	data->txpower.flags = IW_TXPOW_DBM;
 
--- wireless-testing.orig/net/mac80211/cfg.c	2009-04-22 23:31:09.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2009-04-22 23:44:01.000000000 +0200
@@ -1161,9 +1161,10 @@ static int ieee80211_scan(struct wiphy *
 			  struct net_device *dev,
 			  struct cfg80211_scan_request *req)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	if (sdata->local->wext_power_disabled)
+		return -ENOLINK;
 
 	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
 	    sdata->vif.type != NL80211_IFTYPE_ADHOC &&
@@ -1177,9 +1178,10 @@ static int ieee80211_scan(struct wiphy *
 static int ieee80211_auth(struct wiphy *wiphy, struct net_device *dev,
 			  struct cfg80211_auth_request *req)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	if (sdata->local->wext_power_disabled)
+		return -ENOLINK;
 
 	switch (req->auth_type) {
 	case NL80211_AUTHTYPE_OPEN_SYSTEM:
@@ -1232,10 +1234,11 @@ static int ieee80211_auth(struct wiphy *
 static int ieee80211_assoc(struct wiphy *wiphy, struct net_device *dev,
 			   struct cfg80211_assoc_request *req)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	int ret;
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	if (sdata->local->wext_power_disabled)
+		return -ENOLINK;
 
 	if (memcmp(sdata->u.mgd.bssid, req->peer_addr, ETH_ALEN) != 0 ||
 	    !(sdata->u.mgd.flags & IEEE80211_STA_AUTHENTICATED))
@@ -1288,6 +1291,9 @@ static int ieee80211_join_ibss(struct wi
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
+	if (sdata->local->wext_power_disabled)
+		return -ENOLINK;
+
 	return ieee80211_ibss_join(sdata, params);
 }
 
@@ -1295,6 +1301,9 @@ static int ieee80211_leave_ibss(struct w
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
+	if (sdata->local->wext_power_disabled)
+		return -ENOLINK;
+
 	return ieee80211_ibss_leave(sdata);
 }
 
--- wireless-testing.orig/net/mac80211/ibss.c	2009-04-22 23:32:32.000000000 +0200
+++ wireless-testing/net/mac80211/ibss.c	2009-04-22 23:41:23.000000000 +0200
@@ -859,6 +859,8 @@ int ieee80211_ibss_join(struct ieee80211
 	sdata->u.ibss.state = IEEE80211_IBSS_MLME_SEARCH;
 	sdata->u.ibss.ibss_join_req = jiffies;
 
+	ieee80211_recalc_radio_enable(sdata->local);
+
 	set_bit(IEEE80211_IBSS_REQ_RUN, &sdata->u.ibss.request);
 	queue_work(sdata->local->hw.workqueue, &sdata->u.ibss.work);
 
@@ -886,6 +888,9 @@ int ieee80211_ibss_leave(struct ieee8021
 
 	skb_queue_purge(&sdata->u.ibss.skb_queue);
 	memset(sdata->u.ibss.bssid, 0, ETH_ALEN);
+	sdata->u.ibss.ssid_len = 0;
+
+	ieee80211_recalc_radio_enable(sdata->local);
 
 	return 0;
 }
--- wireless-testing.orig/net/mac80211/scan.c	2009-04-22 23:34:32.000000000 +0200
+++ wireless-testing/net/mac80211/scan.c	2009-04-22 23:36:50.000000000 +0200
@@ -348,6 +348,7 @@ void ieee80211_scan_completed(struct iee
 	mutex_unlock(&local->iflist_mtx);
 
  done:
+	ieee80211_recalc_radio_enable(local);
 	ieee80211_mlme_notify_scan_completed(local);
 	ieee80211_ibss_notify_scan_completed(local);
 	ieee80211_mesh_notify_scan_completed(local);
@@ -477,12 +478,16 @@ int ieee80211_start_scan(struct ieee8021
 		req->ie_len = ielen;
 
 		local->hw_scanning = true;
+
+		ieee80211_recalc_radio_enable(local);
+
 		rc = local->ops->hw_scan(local_to_hw(local), req);
 		if (rc) {
 			local->hw_scanning = false;
 			kfree(ies);
 			req->ie_len = local->orig_ies_len;
 			req->ie = local->orig_ies;
+			ieee80211_recalc_radio_enable(local);
 			return rc;
 		}
 		local->scan_sdata = scan_sdata;
@@ -503,6 +508,9 @@ int ieee80211_start_scan(struct ieee8021
 	 * ieee80211_tx_h_check_assoc().
 	 */
 	local->sw_scanning = true;
+
+	ieee80211_recalc_radio_enable(local);
+
 	if (local->ops->sw_scan_start)
 		local->ops->sw_scan_start(local_to_hw(local));
 
--- wireless-testing.orig/net/mac80211/mlme.c	2009-04-22 23:29:23.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-04-22 23:41:42.000000000 +0200
@@ -889,6 +889,7 @@ static void ieee80211_direct_probe(struc
 		printk(KERN_DEBUG "%s: direct probe to AP %pM timed out\n",
 		       sdata->dev->name, ifmgd->bssid);
 		ifmgd->state = IEEE80211_STA_MLME_DISABLED;
+		ieee80211_recalc_radio_enable(local);
 		ieee80211_sta_send_apinfo(sdata);
 
 		/*
@@ -939,6 +940,7 @@ static void ieee80211_authenticate(struc
 		       " timed out\n",
 		       sdata->dev->name, ifmgd->bssid);
 		ifmgd->state = IEEE80211_STA_MLME_DISABLED;
+		ieee80211_recalc_radio_enable(local);
 		ieee80211_sta_send_apinfo(sdata);
 		ieee80211_rx_bss_remove(sdata, ifmgd->bssid,
 				sdata->local->hw.conf.channel->center_freq,
@@ -1035,6 +1037,7 @@ static void ieee80211_set_disassoc(struc
 
 	if (self_disconnected || reason == WLAN_REASON_DISASSOC_STA_HAS_LEFT) {
 		ifmgd->state = IEEE80211_STA_MLME_DISABLED;
+		ieee80211_recalc_radio_enable(local);
 		ieee80211_rx_bss_remove(sdata, ifmgd->bssid,
 				sdata->local->hw.conf.channel->center_freq,
 				ifmgd->ssid, ifmgd->ssid_len);
@@ -1122,6 +1125,7 @@ static void ieee80211_associate(struct i
 		       " timed out\n",
 		       sdata->dev->name, ifmgd->bssid);
 		ifmgd->state = IEEE80211_STA_MLME_DISABLED;
+		ieee80211_recalc_radio_enable(local);
 		ieee80211_sta_send_apinfo(sdata);
 		ieee80211_rx_bss_remove(sdata, ifmgd->bssid,
 				sdata->local->hw.conf.channel->center_freq,
@@ -1142,6 +1146,7 @@ static void ieee80211_associate(struct i
 		printk(KERN_DEBUG "%s: mismatch in privacy configuration and "
 		       "mixed-cell disabled - abort association\n", sdata->dev->name);
 		ifmgd->state = IEEE80211_STA_MLME_DISABLED;
+		ieee80211_recalc_radio_enable(local);
 		return;
 	}
 
@@ -1280,6 +1285,7 @@ static void ieee80211_auth_completed(str
 	if (ifmgd->flags & IEEE80211_STA_EXT_SME) {
 		/* Wait for SME to request association */
 		ifmgd->state = IEEE80211_STA_MLME_DISABLED;
+		ieee80211_recalc_radio_enable(sdata->local);
 	} else
 		ieee80211_associate(sdata);
 }
@@ -1516,6 +1522,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 		if (ifmgd->flags & IEEE80211_STA_EXT_SME) {
 			/* Wait for SME to decide what to do next */
 			ifmgd->state = IEEE80211_STA_MLME_DISABLED;
+			ieee80211_recalc_radio_enable(local);
 		}
 		return;
 	}
@@ -2091,6 +2098,7 @@ static int ieee80211_sta_config_auth(str
 		} else {
 			ifmgd->assoc_scan_tries = 0;
 			ifmgd->state = IEEE80211_STA_MLME_DISABLED;
+			ieee80211_recalc_radio_enable(local);
 		}
 	}
 	return -1;
@@ -2140,6 +2148,8 @@ static void ieee80211_sta_work(struct wo
 	} else if (!test_and_clear_bit(IEEE80211_STA_REQ_RUN, &ifmgd->request))
 		return;
 
+	ieee80211_recalc_radio_enable(local);
+
 	switch (ifmgd->state) {
 	case IEEE80211_STA_MLME_DISABLED:
 		break;


