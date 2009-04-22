Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49270 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbZDVPs4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 11:48:56 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Lwegu-0004lI-Oh
	for linux-wireless@vger.kernel.org; Wed, 22 Apr 2009 17:48:54 +0200
Message-Id: <20090422154644.464399343@sipsolutions.net> (sfid-20090422_174906_499124_4022B303)
References: <20090422154559.528196740@sipsolutions.net>
Date: Wed, 22 Apr 2009 17:46:01 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 2/2] mac80211: unify config_interface and bss_info_changed
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The config_interface method is a little strange, it contains the
BSSID and beacon updates, while bss_info_changed contains most
other BSS information for each interface. This patch removes
config_interface and rolls all the information it previously
passed to drivers into bss_info_changed.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Tested with ar9170, zd1211, p54 and iwlagn.

 drivers/net/wireless/adm8211.c              |   14 +-
 drivers/net/wireless/at76c50x-usb.c         |   15 +-
 drivers/net/wireless/ath/ar9170/main.c      |   39 +-----
 drivers/net/wireless/ath/ath5k/base.c       |   71 ++++------
 drivers/net/wireless/ath/ath9k/main.c       |  182 ++++++++++++----------------
 drivers/net/wireless/b43/main.c             |   64 ++++-----
 drivers/net/wireless/b43legacy/main.c       |   63 +++------
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    1 
 drivers/net/wireless/iwlwifi/iwl-core.c     |  156 ++++++++----------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    3 
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 
 drivers/net/wireless/libertas_tf/main.c     |   56 +++-----
 drivers/net/wireless/mac80211_hwsim.c       |   25 +--
 drivers/net/wireless/mwl8k.c                |   18 --
 drivers/net/wireless/p54/p54common.c        |   63 +++------
 drivers/net/wireless/rt2x00/rt2400pci.c     |    1 
 drivers/net/wireless/rt2x00/rt2500pci.c     |    1 
 drivers/net/wireless/rt2x00/rt2500usb.c     |    1 
 drivers/net/wireless/rt2x00/rt2x00.h        |    3 
 drivers/net/wireless/rt2x00/rt2x00mac.c     |   88 +++++--------
 drivers/net/wireless/rt2x00/rt61pci.c       |    1 
 drivers/net/wireless/rt2x00/rt73usb.c       |    1 
 drivers/net/wireless/rtl818x/rtl8180_dev.c  |   33 ++---
 drivers/net/wireless/rtl818x/rtl8187_dev.c  |   48 +++----
 drivers/net/wireless/zd1211rw/zd_mac.c      |   80 +++++-------
 include/net/mac80211.h                      |   51 ++-----
 net/mac80211/cfg.c                          |    8 -
 net/mac80211/ibss.c                         |   18 +-
 net/mac80211/ieee80211_i.h                  |    1 
 net/mac80211/main.c                         |  131 ++++++++------------
 net/mac80211/mesh.c                         |    6 
 net/mac80211/mlme.c                         |    8 -
 net/mac80211/scan.c                         |    8 -
 net/mac80211/util.c                         |   17 --
 34 files changed, 498 insertions(+), 778 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-04-22 15:43:12.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2009-04-22 15:43:26.000000000 +0200
@@ -150,6 +150,12 @@ struct ieee80211_low_level_stats {
  * @BSS_CHANGED_HT: 802.11n parameters changed
  * @BSS_CHANGED_BASIC_RATES: Basic rateset changed
  * @BSS_CHANGED_BEACON_INT: Beacon interval changed
+ * @BSS_CHANGED_BSSID: BSSID changed, for whatever
+ *	reason (IBSS and managed mode)
+ * @BSS_CHANGED_BEACON: Beacon data changed, retrieve
+ *	new beacon (beaconing modes)
+ * @BSS_CHANGED_BEACON_ENABLED: Beaconing should be
+ *	enabled/disabled (beaconing modes)
  */
 enum ieee80211_bss_change {
 	BSS_CHANGED_ASSOC		= 1<<0,
@@ -159,6 +165,9 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_HT                  = 1<<4,
 	BSS_CHANGED_BASIC_RATES		= 1<<5,
 	BSS_CHANGED_BEACON_INT		= 1<<6,
+	BSS_CHANGED_BSSID		= 1<<7,
+	BSS_CHANGED_BEACON		= 1<<8,
+	BSS_CHANGED_BEACON_ENABLED	= 1<<9,
 };
 
 /**
@@ -192,8 +201,11 @@ struct ieee80211_bss_ht_conf {
  * @basic_rates: bitmap of basic rates, each bit stands for an
  *	index into the rate table configured by the driver in
  *	the current band.
+ * @bssid: The BSSID for this BSS
+ * @enable_beacon: whether beaconing should be enabled or not
  */
 struct ieee80211_bss_conf {
+	const u8 *bssid;
 	/* association related data */
 	bool assoc;
 	u16 aid;
@@ -201,6 +213,7 @@ struct ieee80211_bss_conf {
 	bool use_cts_prot;
 	bool use_short_preamble;
 	bool use_short_slot;
+	bool enable_beacon;
 	u8 dtim_period;
 	u16 beacon_int;
 	u16 assoc_capability;
@@ -639,37 +652,6 @@ struct ieee80211_if_init_conf {
 };
 
 /**
- * enum ieee80211_if_conf_change - interface config change flags
- *
- * @IEEE80211_IFCC_BSSID: The BSSID changed.
- * @IEEE80211_IFCC_BEACON: The beacon for this interface changed
- *	(currently AP and MESH only), use ieee80211_beacon_get().
- * @IEEE80211_IFCC_BEACON_ENABLED: The enable_beacon value changed.
- */
-enum ieee80211_if_conf_change {
-	IEEE80211_IFCC_BSSID		= BIT(0),
-	IEEE80211_IFCC_BEACON		= BIT(1),
-	IEEE80211_IFCC_BEACON_ENABLED	= BIT(2),
-};
-
-/**
- * struct ieee80211_if_conf - configuration of an interface
- *
- * @changed: parameters that have changed, see &enum ieee80211_if_conf_change.
- * @bssid: BSSID of the network we are associated to/creating.
- * @enable_beacon: Indicates whether beacons can be sent.
- *	This is valid only for AP/IBSS/MESH modes.
- *
- * This structure is passed to the config_interface() callback of
- * &struct ieee80211_hw.
- */
-struct ieee80211_if_conf {
-	u32 changed;
-	const u8 *bssid;
-	bool enable_beacon;
-};
-
-/**
  * enum ieee80211_key_alg - key algorithm
  * @ALG_WEP: WEP40 or WEP104
  * @ALG_TKIP: TKIP
@@ -1337,10 +1319,6 @@ enum ieee80211_ampdu_mlme_action {
  *	This function should never fail but returns a negative error code
  *	if it does.
  *
- * @config_interface: Handler for configuration requests related to interfaces
- *	(e.g. BSSID changes.)
- *	Returns a negative error code which will be seen in userspace.
- *
  * @bss_info_changed: Handler for configuration requests related to BSS
  *	parameters that may vary during BSS's lifespan, and may affect low
  *	level driver (e.g. assoc/disassoc status, erp parameters).
@@ -1442,9 +1420,6 @@ struct ieee80211_ops {
 	void (*remove_interface)(struct ieee80211_hw *hw,
 				 struct ieee80211_if_init_conf *conf);
 	int (*config)(struct ieee80211_hw *hw, u32 changed);
-	int (*config_interface)(struct ieee80211_hw *hw,
-				struct ieee80211_vif *vif,
-				struct ieee80211_if_conf *conf);
 	void (*bss_info_changed)(struct ieee80211_hw *hw,
 				 struct ieee80211_vif *vif,
 				 struct ieee80211_bss_conf *info,
--- wireless-testing.orig/net/mac80211/ibss.c	2009-04-22 15:48:09.000000000 +0200
+++ wireless-testing/net/mac80211/ibss.c	2009-04-22 15:49:29.000000000 +0200
@@ -95,17 +95,10 @@ static void __ieee80211_sta_join_ibss(st
 
 	sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 
-	ieee80211_if_config(sdata, IEEE80211_IFCC_BSSID);
-
 	local->oper_channel = chan;
 	local->oper_channel_type = NL80211_CHAN_NO_HT;
 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 
-	sdata->vif.bss_conf.beacon_int = beacon_int;
-	bss_change = BSS_CHANGED_BEACON_INT;
-	bss_change |= ieee80211_reset_erp_info(sdata);
-	ieee80211_bss_info_change_notify(sdata, bss_change);
-
 	sband = local->hw.wiphy->bands[chan->band];
 
 	/* Build IBSS probe response */
@@ -161,8 +154,13 @@ static void __ieee80211_sta_join_ibss(st
 
 	rcu_assign_pointer(ifibss->presp, skb);
 
-	ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON |
-				   IEEE80211_IFCC_BEACON_ENABLED);
+	sdata->vif.bss_conf.beacon_int = beacon_int;
+	bss_change = BSS_CHANGED_BEACON_INT;
+	bss_change |= ieee80211_reset_erp_info(sdata);
+	bss_change |= BSS_CHANGED_BSSID;
+	bss_change |= BSS_CHANGED_BEACON;
+	bss_change |= BSS_CHANGED_BEACON_ENABLED;
+	ieee80211_bss_info_change_notify(sdata, bss_change);
 
 	rates = 0;
 	for (i = 0; i < supp_rates_len; i++) {
@@ -889,7 +887,7 @@ int ieee80211_ibss_leave(struct ieee8021
 	kfree(sdata->u.ibss.ie);
 	skb = sdata->u.ibss.presp;
 	rcu_assign_pointer(sdata->u.ibss.presp, NULL);
-	ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON_ENABLED);
+	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
 	synchronize_rcu();
 	kfree_skb(skb);
 
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-04-22 15:50:11.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-04-22 15:50:14.000000000 +0200
@@ -905,7 +905,6 @@ static inline int ieee80211_bssid_match(
 
 
 int ieee80211_hw_config(struct ieee80211_local *local, u32 changed);
-int ieee80211_if_config(struct ieee80211_sub_if_data *sdata, u32 changed);
 void ieee80211_tx_set_protected(struct ieee80211_tx_data *tx);
 void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
 				      u32 changed);
--- wireless-testing.orig/net/mac80211/main.c	2009-04-22 15:43:29.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2009-04-22 17:31:35.000000000 +0200
@@ -152,82 +152,6 @@ static void ieee80211_master_set_multica
 	ieee80211_configure_filter(local);
 }
 
-/* everything else */
-
-int ieee80211_if_config(struct ieee80211_sub_if_data *sdata, u32 changed)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_if_conf conf;
-
-	if (WARN_ON(!netif_running(sdata->dev)))
-		return 0;
-
-	memset(&conf, 0, sizeof(conf));
-
-	if (sdata->vif.type == NL80211_IFTYPE_STATION)
-		conf.bssid = sdata->u.mgd.bssid;
-	else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
-		conf.bssid = sdata->u.ibss.bssid;
-	else if (sdata->vif.type == NL80211_IFTYPE_AP)
-		conf.bssid = sdata->dev->dev_addr;
-	else if (ieee80211_vif_is_mesh(&sdata->vif)) {
-		static const u8 zero[ETH_ALEN] = { 0 };
-		conf.bssid = zero;
-	} else {
-		WARN_ON(1);
-		return -EINVAL;
-	}
-
-	if (!local->ops->config_interface)
-		return 0;
-
-	switch (sdata->vif.type) {
-	case NL80211_IFTYPE_AP:
-	case NL80211_IFTYPE_ADHOC:
-	case NL80211_IFTYPE_MESH_POINT:
-		break;
-	default:
-		/* do not warn to simplify caller in scan.c */
-		changed &= ~IEEE80211_IFCC_BEACON_ENABLED;
-		if (WARN_ON(changed & IEEE80211_IFCC_BEACON))
-			return -EINVAL;
-		changed &= ~IEEE80211_IFCC_BEACON;
-		break;
-	}
-
-	if (changed & IEEE80211_IFCC_BEACON_ENABLED) {
-		if (local->sw_scanning) {
-			conf.enable_beacon = false;
-		} else {
-			/*
-			 * Beacon should be enabled, but AP mode must
-			 * check whether there is a beacon configured.
-			 */
-			switch (sdata->vif.type) {
-			case NL80211_IFTYPE_AP:
-				conf.enable_beacon =
-					!!rcu_dereference(sdata->u.ap.beacon);
-				break;
-			case NL80211_IFTYPE_ADHOC:
-				conf.enable_beacon = !!sdata->u.ibss.presp;
-				break;
-			case NL80211_IFTYPE_MESH_POINT:
-				conf.enable_beacon = true;
-				break;
-			default:
-				/* not reached */
-				WARN_ON(1);
-				break;
-			}
-		}
-	}
-
-	conf.changed = changed;
-
-	return local->ops->config_interface(local_to_hw(local),
-					    &sdata->vif, &conf);
-}
-
 int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 {
 	struct ieee80211_channel *chan;
@@ -297,6 +221,61 @@ void ieee80211_bss_info_change_notify(st
 	if (!changed)
 		return;
 
+	if (sdata->vif.type == NL80211_IFTYPE_STATION)
+		sdata->vif.bss_conf.bssid = sdata->u.mgd.bssid;
+	else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		sdata->vif.bss_conf.bssid = sdata->u.ibss.bssid;
+	else if (sdata->vif.type == NL80211_IFTYPE_AP)
+		sdata->vif.bss_conf.bssid = sdata->dev->dev_addr;
+	else if (ieee80211_vif_is_mesh(&sdata->vif)) {
+		static const u8 zero[ETH_ALEN] = { 0 };
+		sdata->vif.bss_conf.bssid = zero;
+	} else {
+		WARN_ON(1);
+		return;
+	}
+
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_MESH_POINT:
+		break;
+	default:
+		/* do not warn to simplify caller in scan.c */
+		changed &= ~BSS_CHANGED_BEACON_ENABLED;
+		if (WARN_ON(changed & BSS_CHANGED_BEACON))
+			return;
+		break;
+	}
+
+	if (changed & BSS_CHANGED_BEACON_ENABLED) {
+		if (local->sw_scanning) {
+			sdata->vif.bss_conf.enable_beacon = false;
+		} else {
+			/*
+			 * Beacon should be enabled, but AP mode must
+			 * check whether there is a beacon configured.
+			 */
+			switch (sdata->vif.type) {
+			case NL80211_IFTYPE_AP:
+				sdata->vif.bss_conf.enable_beacon =
+					!!rcu_dereference(sdata->u.ap.beacon);
+				break;
+			case NL80211_IFTYPE_ADHOC:
+				sdata->vif.bss_conf.enable_beacon =
+					!!rcu_dereference(sdata->u.ibss.presp);
+				break;
+			case NL80211_IFTYPE_MESH_POINT:
+				sdata->vif.bss_conf.enable_beacon = true;
+				break;
+			default:
+				/* not reached */
+				WARN_ON(1);
+				break;
+			}
+		}
+	}
+
 	if (local->ops->bss_info_changed)
 		local->ops->bss_info_changed(local_to_hw(local),
 					     &sdata->vif,
--- wireless-testing.orig/net/mac80211/mlme.c	2009-04-22 15:49:39.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-04-22 15:50:01.000000000 +0200
@@ -2280,12 +2280,8 @@ int ieee80211_sta_set_bssid(struct ieee8
 		ifmgd->flags &= ~IEEE80211_STA_BSSID_SET;
 	}
 
-	if (netif_running(sdata->dev)) {
-		if (ieee80211_if_config(sdata, IEEE80211_IFCC_BSSID)) {
-			printk(KERN_DEBUG "%s: Failed to config new BSSID to "
-			       "the low-level driver\n", sdata->dev->name);
-		}
-	}
+	if (netif_running(sdata->dev))
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
 
 	return ieee80211_sta_commit(sdata);
 }
--- wireless-testing.orig/net/mac80211/scan.c	2009-04-22 15:47:17.000000000 +0200
+++ wireless-testing/net/mac80211/scan.c	2009-04-22 15:47:53.000000000 +0200
@@ -342,8 +342,8 @@ void ieee80211_scan_completed(struct iee
 		if (sdata->vif.type == NL80211_IFTYPE_AP ||
 		    sdata->vif.type == NL80211_IFTYPE_ADHOC ||
 		    sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
-			ieee80211_if_config(sdata,
-					    IEEE80211_IFCC_BEACON_ENABLED);
+			ieee80211_bss_info_change_notify(
+				sdata, BSS_CHANGED_BEACON_ENABLED);
 	}
 	mutex_unlock(&local->iflist_mtx);
 
@@ -515,8 +515,8 @@ int ieee80211_start_scan(struct ieee8021
 		if (sdata->vif.type == NL80211_IFTYPE_AP ||
 		    sdata->vif.type == NL80211_IFTYPE_ADHOC ||
 		    sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
-			ieee80211_if_config(sdata,
-					    IEEE80211_IFCC_BEACON_ENABLED);
+			ieee80211_bss_info_change_notify(
+				sdata, BSS_CHANGED_BEACON_ENABLED);
 
 		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 			if (sdata->u.mgd.flags & IEEE80211_STA_ASSOCIATED) {
--- wireless-testing.orig/net/mac80211/cfg.c	2009-04-22 15:50:19.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2009-04-22 15:51:24.000000000 +0200
@@ -521,8 +521,9 @@ static int ieee80211_config_beacon(struc
 
 	kfree(old);
 
-	return ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON |
-					  IEEE80211_IFCC_BEACON_ENABLED);
+	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED |
+						BSS_CHANGED_BEACON);
+	return 0;
 }
 
 static int ieee80211_add_beacon(struct wiphy *wiphy, struct net_device *dev,
@@ -573,7 +574,8 @@ static int ieee80211_del_beacon(struct w
 	synchronize_rcu();
 	kfree(old);
 
-	return ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON_ENABLED);
+	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
+	return 0;
 }
 
 /* Layer 2 Update frame (802.2 Type 1 LLC XID Update response) */
--- wireless-testing.orig/net/mac80211/mesh.c	2009-04-22 15:53:09.000000000 +0200
+++ wireless-testing/net/mac80211/mesh.c	2009-04-22 15:53:57.000000000 +0200
@@ -417,7 +417,7 @@ static void ieee80211_mesh_housekeeping(
 
 	free_plinks = mesh_plink_availables(sdata);
 	if (free_plinks != sdata->u.mesh.accepting_plinks)
-		ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON);
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
 
 	ifmsh->housekeeping = false;
 	mod_timer(&ifmsh->housekeeping_timer,
@@ -432,8 +432,8 @@ void ieee80211_start_mesh(struct ieee802
 
 	ifmsh->housekeeping = true;
 	queue_work(local->hw.workqueue, &ifmsh->work);
-	ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON |
-				   IEEE80211_IFCC_BEACON_ENABLED);
+	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON |
+						BSS_CHANGED_BEACON_ENABLED);
 }
 
 void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
--- wireless-testing.orig/net/mac80211/util.c	2009-04-22 15:51:40.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2009-04-22 15:52:55.000000000 +0200
@@ -1063,24 +1063,13 @@ int ieee80211_reconfig(struct ieee80211_
 		switch (sdata->vif.type) {
 		case NL80211_IFTYPE_STATION:
 			/* disable beacon change bits */
-			changed &= ~IEEE80211_IFCC_BEACON;
+			changed &= ~(BSS_CHANGED_BEACON |
+				     BSS_CHANGED_BEACON_ENABLED);
 			/* fall through */
 		case NL80211_IFTYPE_ADHOC:
 		case NL80211_IFTYPE_AP:
 		case NL80211_IFTYPE_MESH_POINT:
-			/*
-			 * Driver's config_interface can fail if rfkill is
-			 * enabled. Accommodate this return code.
-			 * FIXME: When mac80211 has knowledge of rfkill
-			 * state the code below can change back to:
-			 *   WARN(ieee80211_if_config(sdata, changed));
-			 *   ieee80211_bss_info_change_notify(sdata, ~0);
-			 */
-			if (ieee80211_if_config(sdata, changed))
-				printk(KERN_DEBUG "%s: failed to configure interface during resume\n",
-				       sdata->dev->name);
-			else
-				ieee80211_bss_info_change_notify(sdata, ~0);
+			ieee80211_bss_info_change_notify(sdata, changed);
 			break;
 		case NL80211_IFTYPE_WDS:
 			break;
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-agn.c	2009-04-22 15:56:25.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-agn.c	2009-04-22 15:56:29.000000000 +0200
@@ -2543,7 +2543,6 @@ static struct ieee80211_ops iwl_hw_ops =
 	.add_interface = iwl_mac_add_interface,
 	.remove_interface = iwl_mac_remove_interface,
 	.config = iwl_mac_config,
-	.config_interface = iwl_mac_config_interface,
 	.configure_filter = iwl_configure_filter,
 	.set_key = iwl_mac_set_key,
 	.update_tkip_key = iwl_mac_update_tkip_key,
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-core.c	2009-04-22 15:56:48.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-core.c	2009-04-22 17:38:00.000000000 +0200
@@ -2231,15 +2231,63 @@ static void iwl_ht_conf(struct iwl_priv 
 
 #define IWL_DELAY_NEXT_SCAN_AFTER_ASSOC (HZ*6)
 void iwl_bss_info_changed(struct ieee80211_hw *hw,
-				     struct ieee80211_vif *vif,
-				     struct ieee80211_bss_conf *bss_conf,
-				     u32 changes)
+			  struct ieee80211_vif *vif,
+			  struct ieee80211_bss_conf *bss_conf,
+			  u32 changes)
 {
 	struct iwl_priv *priv = hw->priv;
 	int ret;
 
 	IWL_DEBUG_MAC80211(priv, "changes = 0x%X\n", changes);
 
+	if (!iwl_is_alive(priv))
+		return;
+
+	mutex_lock(&priv->mutex);
+
+	if ((changes & BSS_CHANGED_BSSID) && !iwl_is_rfkill(priv)) {
+		/* If there is currently a HW scan going on in the background
+		 * then we need to cancel it else the RXON below will fail. */
+		if (iwl_scan_cancel_timeout(priv, 100)) {
+			IWL_WARN(priv, "Aborted scan still in progress "
+				    "after 100ms\n");
+			IWL_DEBUG_MAC80211(priv, "leaving - scan abort failed.\n");
+			mutex_unlock(&priv->mutex);
+			return;
+		}
+		memcpy(priv->staging_rxon.bssid_addr,
+		       bss_conf->bssid, ETH_ALEN);
+
+		/* TODO: Audit driver for usage of these members and see
+		 * if mac80211 deprecates them (priv->bssid looks like it
+		 * shouldn't be there, but I haven't scanned the IBSS code
+		 * to verify) - jpk */
+		memcpy(priv->bssid, bss_conf->bssid, ETH_ALEN);
+
+		if (priv->iw_mode == NL80211_IFTYPE_AP)
+			iwlcore_config_ap(priv);
+		else {
+			int rc = iwlcore_commit_rxon(priv);
+			if ((priv->iw_mode == NL80211_IFTYPE_STATION) && rc)
+				iwl_rxon_add_station(
+					priv, priv->active_rxon.bssid_addr, 1);
+		}
+	} else {
+		iwl_scan_cancel_timeout(priv, 100);
+		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+		iwlcore_commit_rxon(priv);
+	}
+
+	if (priv->iw_mode == NL80211_IFTYPE_ADHOC &&
+	    changes & BSS_CHANGED_BEACON) {
+		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
+
+		if (beacon)
+			iwl_mac_beacon_update(hw, beacon);
+	}
+
+	mutex_unlock(&priv->mutex);
+
 	if (changes & BSS_CHANGED_ERP_PREAMBLE) {
 		IWL_DEBUG_MAC80211(priv, "ERP_PREAMBLE %d\n",
 				   bss_conf->use_short_preamble);
@@ -2297,7 +2345,7 @@ void iwl_bss_info_changed(struct ieee802
 					&priv->staging_rxon,
 					sizeof(struct iwl_rxon_cmd));
 	}
-
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 EXPORT_SYMBOL(iwl_bss_info_changed);
 
@@ -2578,106 +2626,6 @@ out:
 }
 EXPORT_SYMBOL(iwl_mac_config);
 
-int iwl_mac_config_interface(struct ieee80211_hw *hw,
-					struct ieee80211_vif *vif,
-				    struct ieee80211_if_conf *conf)
-{
-	struct iwl_priv *priv = hw->priv;
-	int rc;
-
-	if (conf == NULL)
-		return -EIO;
-
-	if (priv->vif != vif) {
-		IWL_DEBUG_MAC80211(priv, "leave - priv->vif != vif\n");
-		return 0;
-	}
-
-	if (priv->iw_mode == NL80211_IFTYPE_ADHOC &&
-	    conf->changed & IEEE80211_IFCC_BEACON) {
-		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
-		if (!beacon)
-			return -ENOMEM;
-		mutex_lock(&priv->mutex);
-		rc = iwl_mac_beacon_update(hw, beacon);
-		mutex_unlock(&priv->mutex);
-		if (rc)
-			return rc;
-	}
-
-	if (!iwl_is_alive(priv))
-		return -EAGAIN;
-
-	mutex_lock(&priv->mutex);
-
-	if (conf->bssid)
-		IWL_DEBUG_MAC80211(priv, "bssid: %pM\n", conf->bssid);
-
-/*
- * very dubious code was here; the probe filtering flag is never set:
- *
-	if (unlikely(test_bit(STATUS_SCANNING, &priv->status)) &&
-	    !(priv->hw->flags & IEEE80211_HW_NO_PROBE_FILTERING)) {
- */
-
-	if (priv->iw_mode == NL80211_IFTYPE_AP) {
-		if (!conf->bssid) {
-			conf->bssid = priv->mac_addr;
-			memcpy(priv->bssid, priv->mac_addr, ETH_ALEN);
-			IWL_DEBUG_MAC80211(priv, "bssid was set to: %pM\n",
-					   conf->bssid);
-		}
-		if (priv->ibss_beacon)
-			dev_kfree_skb(priv->ibss_beacon);
-
-		priv->ibss_beacon = ieee80211_beacon_get(hw, vif);
-	}
-
-	if (iwl_is_rfkill(priv))
-		goto done;
-
-	if (conf->bssid && !is_zero_ether_addr(conf->bssid) &&
-	    !is_multicast_ether_addr(conf->bssid)) {
-		/* If there is currently a HW scan going on in the background
-		 * then we need to cancel it else the RXON below will fail. */
-		if (iwl_scan_cancel_timeout(priv, 100)) {
-			IWL_WARN(priv, "Aborted scan still in progress "
-				    "after 100ms\n");
-			IWL_DEBUG_MAC80211(priv, "leaving - scan abort failed.\n");
-			mutex_unlock(&priv->mutex);
-			return -EAGAIN;
-		}
-		memcpy(priv->staging_rxon.bssid_addr, conf->bssid, ETH_ALEN);
-
-		/* TODO: Audit driver for usage of these members and see
-		 * if mac80211 deprecates them (priv->bssid looks like it
-		 * shouldn't be there, but I haven't scanned the IBSS code
-		 * to verify) - jpk */
-		memcpy(priv->bssid, conf->bssid, ETH_ALEN);
-
-		if (priv->iw_mode == NL80211_IFTYPE_AP)
-			iwlcore_config_ap(priv);
-		else {
-			rc = iwlcore_commit_rxon(priv);
-			if ((priv->iw_mode == NL80211_IFTYPE_STATION) && rc)
-				iwl_rxon_add_station(
-					priv, priv->active_rxon.bssid_addr, 1);
-		}
-
-	} else {
-		iwl_scan_cancel_timeout(priv, 100);
-		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-		iwlcore_commit_rxon(priv);
-	}
-
- done:
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-	mutex_unlock(&priv->mutex);
-
-	return 0;
-}
-EXPORT_SYMBOL(iwl_mac_config_interface);
-
 int iwl_mac_get_tx_stats(struct ieee80211_hw *hw,
 			 struct ieee80211_tx_queue_stats *stats)
 {
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-core.h	2009-04-22 15:55:47.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-core.h	2009-04-22 15:55:53.000000000 +0200
@@ -281,9 +281,6 @@ void iwl_mac_remove_interface(struct iee
 				 struct ieee80211_if_init_conf *conf);
 int iwl_mac_config(struct ieee80211_hw *hw, u32 changed);
 void iwl_config_ap(struct iwl_priv *priv);
-int iwl_mac_config_interface(struct ieee80211_hw *hw,
-				struct ieee80211_vif *vif,
-				struct ieee80211_if_conf *conf);
 int iwl_mac_get_tx_stats(struct ieee80211_hw *hw,
 			 struct ieee80211_tx_queue_stats *stats);
 void iwl_mac_reset_tsf(struct ieee80211_hw *hw);
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2009-04-22 15:56:02.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl3945-base.c	2009-04-22 15:56:07.000000000 +0200
@@ -4016,7 +4016,6 @@ static struct ieee80211_ops iwl3945_hw_o
 	.add_interface = iwl_mac_add_interface,
 	.remove_interface = iwl_mac_remove_interface,
 	.config = iwl_mac_config,
-	.config_interface = iwl_mac_config_interface,
 	.configure_filter = iwl_configure_filter,
 	.set_key = iwl3945_mac_set_key,
 	.get_tx_stats = iwl_mac_get_tx_stats,
--- wireless-testing.orig/drivers/net/wireless/at76c50x-usb.c	2009-04-22 15:54:49.000000000 +0200
+++ wireless-testing/drivers/net/wireless/at76c50x-usb.c	2009-04-22 16:15:58.000000000 +0200
@@ -1965,13 +1965,18 @@ static int at76_config(struct ieee80211_
 	return 0;
 }
 
-static int at76_config_interface(struct ieee80211_hw *hw,
-				 struct ieee80211_vif *vif,
-				 struct ieee80211_if_conf *conf)
+static void at76_bss_info_changed(struct ieee80211_hw *hw,
+				  struct ieee80211_vif *vif,
+				  struct ieee80211_bss_conf *conf,
+				  u32 changed)
 {
 	struct at76_priv *priv = hw->priv;
 
 	at76_dbg(DBG_MAC80211, "%s():", __func__);
+
+	if (!(changed & BSS_CHANGED_BSSID))
+		return;
+
 	at76_dbg_dump(DBG_MAC80211, conf->bssid, ETH_ALEN, "bssid:");
 
 	mutex_lock(&priv->mtx);
@@ -1983,8 +1988,6 @@ static int at76_config_interface(struct 
 		at76_join(priv);
 
 	mutex_unlock(&priv->mtx);
-
-	return 0;
 }
 
 /* must be atomic */
@@ -2076,7 +2079,7 @@ static const struct ieee80211_ops at76_o
 	.add_interface = at76_add_interface,
 	.remove_interface = at76_remove_interface,
 	.config = at76_config,
-	.config_interface = at76_config_interface,
+	.bss_info_changed = at76_bss_info_changed,
 	.configure_filter = at76_configure_filter,
 	.start = at76_mac80211_start,
 	.stop = at76_mac80211_stop,
--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2009-04-22 16:11:54.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2009-04-22 16:13:36.000000000 +0200
@@ -588,23 +588,6 @@ static void mac80211_hwsim_configure_fil
 	*total_flags = data->rx_filter;
 }
 
-static int mac80211_hwsim_config_interface(struct ieee80211_hw *hw,
-					   struct ieee80211_vif *vif,
-					   struct ieee80211_if_conf *conf)
-{
-	struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
-
-	hwsim_check_magic(vif);
-	if (conf->changed & IEEE80211_IFCC_BSSID) {
-		DECLARE_MAC_BUF(mac);
-		printk(KERN_DEBUG "%s:%s: BSSID changed: %pM\n",
-		       wiphy_name(hw->wiphy), __func__,
-		       conf->bssid);
-		memcpy(vp->bssid, conf->bssid, ETH_ALEN);
-	}
-	return 0;
-}
-
 static void mac80211_hwsim_bss_info_changed(struct ieee80211_hw *hw,
 					    struct ieee80211_vif *vif,
 					    struct ieee80211_bss_conf *info,
@@ -618,6 +601,13 @@ static void mac80211_hwsim_bss_info_chan
 	printk(KERN_DEBUG "%s:%s(changed=0x%x)\n",
 	       wiphy_name(hw->wiphy), __func__, changed);
 
+	if (changed & BSS_CHANGED_BSSID) {
+		printk(KERN_DEBUG "%s:%s: BSSID changed: %pM\n",
+		       wiphy_name(hw->wiphy), __func__,
+		       info->bssid);
+		memcpy(vp->bssid, info->bssid, ETH_ALEN);
+	}
+
 	if (changed & BSS_CHANGED_ASSOC) {
 		printk(KERN_DEBUG "  %s: ASSOC: assoc=%d aid=%d\n",
 		       wiphy_name(hw->wiphy), info->assoc, info->aid);
@@ -709,7 +699,6 @@ static const struct ieee80211_ops mac802
 	.remove_interface = mac80211_hwsim_remove_interface,
 	.config = mac80211_hwsim_config,
 	.configure_filter = mac80211_hwsim_configure_filter,
-	.config_interface = mac80211_hwsim_config_interface,
 	.bss_info_changed = mac80211_hwsim_bss_info_changed,
 	.sta_notify = mac80211_hwsim_sta_notify,
 	.set_tim = mac80211_hwsim_set_tim,
--- wireless-testing.orig/drivers/net/wireless/adm8211.c	2009-04-22 16:17:42.000000000 +0200
+++ wireless-testing/drivers/net/wireless/adm8211.c	2009-04-22 16:19:43.000000000 +0200
@@ -1311,18 +1311,20 @@ static int adm8211_config(struct ieee802
 	return 0;
 }
 
-static int adm8211_config_interface(struct ieee80211_hw *dev,
-				    struct ieee80211_vif *vif,
-				    struct ieee80211_if_conf *conf)
+static void adm8211_bss_info_changed(struct ieee80211_hw *dev,
+				     struct ieee80211_vif *vif,
+				     struct ieee80211_bss_conf *conf,
+				     u32 changes)
 {
 	struct adm8211_priv *priv = dev->priv;
 
+	if (!(changes & BSS_CHANGED_BSSID))
+		return;
+
 	if (memcmp(conf->bssid, priv->bssid, ETH_ALEN)) {
 		adm8211_set_bssid(dev, conf->bssid);
 		memcpy(priv->bssid, conf->bssid, ETH_ALEN);
 	}
-
-	return 0;
 }
 
 static void adm8211_configure_filter(struct ieee80211_hw *dev,
@@ -1753,7 +1755,7 @@ static const struct ieee80211_ops adm821
 	.add_interface		= adm8211_add_interface,
 	.remove_interface	= adm8211_remove_interface,
 	.config			= adm8211_config,
-	.config_interface	= adm8211_config_interface,
+	.bss_info_changed	= adm8211_bss_info_changed,
 	.configure_filter	= adm8211_configure_filter,
 	.get_stats		= adm8211_get_stats,
 	.get_tx_stats		= adm8211_get_tx_stats,
--- wireless-testing.orig/drivers/net/wireless/mwl8k.c	2009-04-22 16:20:15.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mwl8k.c	2009-04-22 16:22:05.000000000 +0200
@@ -3089,19 +3089,6 @@ static int mwl8k_config(struct ieee80211
 	return rc ? -EINVAL : 0;
 }
 
-static int mwl8k_config_interface(struct ieee80211_hw *hw,
-				  struct ieee80211_vif *vif,
-				  struct ieee80211_if_conf *conf)
-{
-	struct mwl8k_vif *mv_vif = MWL8K_VIF(vif);
-	u32 changed = conf->changed;
-
-	if (changed & IEEE80211_IFCC_BSSID)
-		memcpy(mv_vif->bssid, conf->bssid, IEEE80211_ADDR_LEN);
-
-	return 0;
-}
-
 struct mwl8k_bss_info_changed_worker {
 	struct mwl8k_work_struct header;
 	struct ieee80211_vif *vif;
@@ -3183,8 +3170,12 @@ static void mwl8k_bss_info_changed(struc
 {
 	struct mwl8k_bss_info_changed_worker *worker;
 	struct mwl8k_priv *priv = hw->priv;
+	struct mwl8k_vif *mv_vif = MWL8K_VIF(vif);
 	int rc;
 
+	if (changed & BSS_CHANGED_BSSID)
+		memcpy(mv_vif->bssid, info->bssid, IEEE80211_ADDR_LEN);
+
 	if ((changed & BSS_CHANGED_ASSOC) == 0)
 		return;
 
@@ -3442,7 +3433,6 @@ static const struct ieee80211_ops mwl8k_
 	.add_interface		= mwl8k_add_interface,
 	.remove_interface	= mwl8k_remove_interface,
 	.config			= mwl8k_config,
-	.config_interface	= mwl8k_config_interface,
 	.bss_info_changed	= mwl8k_bss_info_changed,
 	.configure_filter	= mwl8k_configure_filter,
 	.set_rts_threshold	= mwl8k_set_rts_threshold,
--- wireless-testing.orig/drivers/net/wireless/ath/ar9170/main.c	2009-04-22 16:22:35.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ar9170/main.c	2009-04-22 16:24:27.000000000 +0200
@@ -1360,33 +1360,6 @@ out:
 	return err;
 }
 
-static int ar9170_op_config_interface(struct ieee80211_hw *hw,
-				      struct ieee80211_vif *vif,
-				      struct ieee80211_if_conf *conf)
-{
-	struct ar9170 *ar = hw->priv;
-	int err = 0;
-
-	mutex_lock(&ar->mutex);
-
-	if (conf->changed & IEEE80211_IFCC_BSSID) {
-		memcpy(ar->bssid, conf->bssid, ETH_ALEN);
-		err = ar9170_set_operating_mode(ar);
-	}
-
-	if (conf->changed & IEEE80211_IFCC_BEACON) {
-		err = ar9170_update_beacon(ar);
-
-		if (err)
-			goto out;
-		err = ar9170_set_beacon_timers(ar);
-	}
-
-out:
-	mutex_unlock(&ar->mutex);
-	return err;
-}
-
 static void ar9170_set_filters(struct work_struct *work)
 {
 	struct ar9170 *ar = container_of(work, struct ar9170,
@@ -1488,6 +1461,17 @@ static void ar9170_op_bss_info_changed(s
 
 	mutex_lock(&ar->mutex);
 
+	if (changed & BSS_CHANGED_BSSID) {
+		memcpy(ar->bssid, bss_conf->bssid, ETH_ALEN);
+		err = ar9170_set_operating_mode(ar);
+	}
+
+	if (changed & (BSS_CHANGED_BEACON | BSS_CHANGED_BEACON_ENABLED)) {
+		err = ar9170_update_beacon(ar);
+		if (!err)
+			ar9170_set_beacon_timers(ar);
+	}
+
 	ar9170_regwrite_begin(ar);
 
 	if (changed & BSS_CHANGED_ASSOC) {
@@ -1796,7 +1780,6 @@ static const struct ieee80211_ops ar9170
 	.add_interface		= ar9170_op_add_interface,
 	.remove_interface	= ar9170_op_remove_interface,
 	.config			= ar9170_op_config,
-	.config_interface	= ar9170_op_config_interface,
 	.configure_filter	= ar9170_op_configure_filter,
 	.conf_tx		= ar9170_conf_tx,
 	.bss_info_changed	= ar9170_op_bss_info_changed,
--- wireless-testing.orig/drivers/net/wireless/ath/ath5k/base.c	2009-04-22 16:24:51.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath5k/base.c	2009-04-22 16:27:45.000000000 +0200
@@ -227,9 +227,6 @@ static int ath5k_add_interface(struct ie
 static void ath5k_remove_interface(struct ieee80211_hw *hw,
 		struct ieee80211_if_init_conf *conf);
 static int ath5k_config(struct ieee80211_hw *hw, u32 changed);
-static int ath5k_config_interface(struct ieee80211_hw *hw,
-		struct ieee80211_vif *vif,
-		struct ieee80211_if_conf *conf);
 static void ath5k_configure_filter(struct ieee80211_hw *hw,
 		unsigned int changed_flags,
 		unsigned int *new_flags,
@@ -259,7 +256,6 @@ static const struct ieee80211_ops ath5k_
 	.add_interface 	= ath5k_add_interface,
 	.remove_interface = ath5k_remove_interface,
 	.config 	= ath5k_config,
-	.config_interface = ath5k_config_interface,
 	.configure_filter = ath5k_configure_filter,
 	.set_key 	= ath5k_set_key,
 	.get_stats 	= ath5k_get_stats,
@@ -2764,44 +2760,6 @@ ath5k_config(struct ieee80211_hw *hw, u3
 	return ret;
 }
 
-static int
-ath5k_config_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-			struct ieee80211_if_conf *conf)
-{
-	struct ath5k_softc *sc = hw->priv;
-	struct ath5k_hw *ah = sc->ah;
-	int ret = 0;
-
-	mutex_lock(&sc->lock);
-	if (sc->vif != vif) {
-		ret = -EIO;
-		goto unlock;
-	}
-	if (conf->changed & IEEE80211_IFCC_BSSID && conf->bssid) {
-		/* Cache for later use during resets */
-		memcpy(ah->ah_bssid, conf->bssid, ETH_ALEN);
-		/* XXX: assoc id is set to 0 for now, mac80211 doesn't have
-		 * a clean way of letting us retrieve this yet. */
-		ath5k_hw_set_associd(ah, ah->ah_bssid, 0);
-		mmiowb();
-	}
-	if (conf->changed & IEEE80211_IFCC_BEACON &&
-			(vif->type == NL80211_IFTYPE_ADHOC ||
-			 vif->type == NL80211_IFTYPE_MESH_POINT ||
-			 vif->type == NL80211_IFTYPE_AP)) {
-		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
-		if (!beacon) {
-			ret = -ENOMEM;
-			goto unlock;
-		}
-		ath5k_beacon_update(sc, beacon);
-	}
-
-unlock:
-	mutex_unlock(&sc->lock);
-	return ret;
-}
-
 #define SUPPORTED_FIF_FLAGS \
 	FIF_PROMISC_IN_BSS |  FIF_ALLMULTI | FIF_FCSFAIL | \
 	FIF_PLCPFAIL | FIF_CONTROL | FIF_OTHER_BSS | \
@@ -3082,15 +3040,40 @@ static void ath5k_bss_info_changed(struc
 				    u32 changes)
 {
 	struct ath5k_softc *sc = hw->priv;
+	struct ath5k_hw *ah = sc->ah;
+
+	mutex_lock(&sc->lock);
+	if (WARN_ON(sc->vif != vif))
+		goto unlock;
+
+	if (changes & BSS_CHANGED_BSSID) {
+		/* Cache for later use during resets */
+		memcpy(ah->ah_bssid, bss_conf->bssid, ETH_ALEN);
+		/* XXX: assoc id is set to 0 for now, mac80211 doesn't have
+		 * a clean way of letting us retrieve this yet. */
+		ath5k_hw_set_associd(ah, ah->ah_bssid, 0);
+		mmiowb();
+	}
 
 	if (changes & BSS_CHANGED_BEACON_INT)
 		sc->bintval = bss_conf->beacon_int;
 
 	if (changes & BSS_CHANGED_ASSOC) {
-		mutex_lock(&sc->lock);
 		sc->assoc = bss_conf->assoc;
 		if (sc->opmode == NL80211_IFTYPE_STATION)
 			set_beacon_filter(hw, sc->assoc);
-		mutex_unlock(&sc->lock);
 	}
+
+	if (changes & BSS_CHANGED_BEACON &&
+	    (vif->type == NL80211_IFTYPE_ADHOC ||
+	     vif->type == NL80211_IFTYPE_MESH_POINT ||
+	     vif->type == NL80211_IFTYPE_AP)) {
+		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
+
+		if (beacon)
+			ath5k_beacon_update(sc, beacon);
+	}
+
+ unlock:
+	mutex_unlock(&sc->lock);
 }
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/main.c	2009-04-22 16:28:20.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath9k/main.c	2009-04-22 16:33:24.000000000 +0200
@@ -2306,104 +2306,6 @@ skip_chan_change:
 	return 0;
 }
 
-static int ath9k_config_interface(struct ieee80211_hw *hw,
-				  struct ieee80211_vif *vif,
-				  struct ieee80211_if_conf *conf)
-{
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath_vif *avp = (void *)vif->drv_priv;
-	u32 rfilt = 0;
-	int error, i;
-
-	mutex_lock(&sc->mutex);
-
-	/* TODO: Need to decide which hw opmode to use for multi-interface
-	 * cases */
-	if (vif->type == NL80211_IFTYPE_AP &&
-	    ah->opmode != NL80211_IFTYPE_AP) {
-		ah->opmode = NL80211_IFTYPE_STATION;
-		ath9k_hw_setopmode(ah);
-		memcpy(sc->curbssid, sc->sc_ah->macaddr, ETH_ALEN);
-		sc->curaid = 0;
-		ath9k_hw_write_associd(sc);
-		/* Request full reset to get hw opmode changed properly */
-		sc->sc_flags |= SC_OP_FULL_RESET;
-	}
-
-	if ((conf->changed & IEEE80211_IFCC_BSSID) &&
-	    !is_zero_ether_addr(conf->bssid)) {
-		switch (vif->type) {
-		case NL80211_IFTYPE_STATION:
-		case NL80211_IFTYPE_ADHOC:
-		case NL80211_IFTYPE_MESH_POINT:
-			/* Set BSSID */
-			memcpy(sc->curbssid, conf->bssid, ETH_ALEN);
-			memcpy(avp->bssid, conf->bssid, ETH_ALEN);
-			sc->curaid = 0;
-			ath9k_hw_write_associd(sc);
-
-			/* Set aggregation protection mode parameters */
-			sc->config.ath_aggr_prot = 0;
-
-			DPRINTF(sc, ATH_DBG_CONFIG,
-				"RX filter 0x%x bssid %pM aid 0x%x\n",
-				rfilt, sc->curbssid, sc->curaid);
-
-			/* need to reconfigure the beacon */
-			sc->sc_flags &= ~SC_OP_BEACONS ;
-
-			break;
-		default:
-			break;
-		}
-	}
-
-	if ((vif->type == NL80211_IFTYPE_ADHOC) ||
-	    (vif->type == NL80211_IFTYPE_AP) ||
-	    (vif->type == NL80211_IFTYPE_MESH_POINT)) {
-		if ((conf->changed & IEEE80211_IFCC_BEACON) ||
-		    (conf->changed & IEEE80211_IFCC_BEACON_ENABLED &&
-		     conf->enable_beacon)) {
-			/*
-			 * Allocate and setup the beacon frame.
-			 *
-			 * Stop any previous beacon DMA.  This may be
-			 * necessary, for example, when an ibss merge
-			 * causes reconfiguration; we may be called
-			 * with beacon transmission active.
-			 */
-			ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
-
-			error = ath_beacon_alloc(aphy, vif);
-			if (error != 0) {
-				mutex_unlock(&sc->mutex);
-				return error;
-			}
-
-			ath_beacon_config(sc, vif);
-		}
-	}
-
-	/* Check for WLAN_CAPABILITY_PRIVACY ? */
-	if ((avp->av_opmode != NL80211_IFTYPE_STATION)) {
-		for (i = 0; i < IEEE80211_WEP_NKID; i++)
-			if (ath9k_hw_keyisvalid(sc->sc_ah, (u16)i))
-				ath9k_hw_keysetmac(sc->sc_ah,
-						   (u16)i,
-						   sc->curbssid);
-	}
-
-	/* Only legacy IBSS for now */
-	if (vif->type == NL80211_IFTYPE_ADHOC)
-		ath_update_chainmask(sc, 0);
-
-	mutex_unlock(&sc->mutex);
-
-	return 0;
-}
-
 #define SUPPORTED_FILTERS			\
 	(FIF_PROMISC_IN_BSS |			\
 	FIF_ALLMULTI |				\
@@ -2540,9 +2442,92 @@ static void ath9k_bss_info_changed(struc
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_vif *avp = (void *)vif->drv_priv;
+	u32 rfilt = 0;
+	int error, i;
 
 	mutex_lock(&sc->mutex);
 
+	/*
+	 * TODO: Need to decide which hw opmode to use for
+	 *       multi-interface cases
+	 * XXX: This belongs into add_interface!
+	 */
+	if (vif->type == NL80211_IFTYPE_AP &&
+	    ah->opmode != NL80211_IFTYPE_AP) {
+		ah->opmode = NL80211_IFTYPE_STATION;
+		ath9k_hw_setopmode(ah);
+		memcpy(sc->curbssid, sc->sc_ah->macaddr, ETH_ALEN);
+		sc->curaid = 0;
+		ath9k_hw_write_associd(sc);
+		/* Request full reset to get hw opmode changed properly */
+		sc->sc_flags |= SC_OP_FULL_RESET;
+	}
+
+	if ((changed & BSS_CHANGED_BSSID) &&
+	    !is_zero_ether_addr(bss_conf->bssid)) {
+		switch (vif->type) {
+		case NL80211_IFTYPE_STATION:
+		case NL80211_IFTYPE_ADHOC:
+		case NL80211_IFTYPE_MESH_POINT:
+			/* Set BSSID */
+			memcpy(sc->curbssid, bss_conf->bssid, ETH_ALEN);
+			memcpy(avp->bssid, bss_conf->bssid, ETH_ALEN);
+			sc->curaid = 0;
+			ath9k_hw_write_associd(sc);
+
+			/* Set aggregation protection mode parameters */
+			sc->config.ath_aggr_prot = 0;
+
+			DPRINTF(sc, ATH_DBG_CONFIG,
+				"RX filter 0x%x bssid %pM aid 0x%x\n",
+				rfilt, sc->curbssid, sc->curaid);
+
+			/* need to reconfigure the beacon */
+			sc->sc_flags &= ~SC_OP_BEACONS ;
+
+			break;
+		default:
+			break;
+		}
+	}
+
+	if ((vif->type == NL80211_IFTYPE_ADHOC) ||
+	    (vif->type == NL80211_IFTYPE_AP) ||
+	    (vif->type == NL80211_IFTYPE_MESH_POINT)) {
+		if ((changed & BSS_CHANGED_BEACON) ||
+		    (changed & BSS_CHANGED_BEACON_ENABLED &&
+		     bss_conf->enable_beacon)) {
+			/*
+			 * Allocate and setup the beacon frame.
+			 *
+			 * Stop any previous beacon DMA.  This may be
+			 * necessary, for example, when an ibss merge
+			 * causes reconfiguration; we may be called
+			 * with beacon transmission active.
+			 */
+			ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
+
+			error = ath_beacon_alloc(aphy, vif);
+			if (!error)
+				ath_beacon_config(sc, vif);
+		}
+	}
+
+	/* Check for WLAN_CAPABILITY_PRIVACY ? */
+	if ((avp->av_opmode != NL80211_IFTYPE_STATION)) {
+		for (i = 0; i < IEEE80211_WEP_NKID; i++)
+			if (ath9k_hw_keyisvalid(sc->sc_ah, (u16)i))
+				ath9k_hw_keysetmac(sc->sc_ah,
+						   (u16)i,
+						   sc->curbssid);
+	}
+
+	/* Only legacy IBSS for now */
+	if (vif->type == NL80211_IFTYPE_ADHOC)
+		ath_update_chainmask(sc, 0);
+
 	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
 		DPRINTF(sc, ATH_DBG_CONFIG, "BSS Changed PREAMBLE %d\n",
 			bss_conf->use_short_preamble);
@@ -2700,7 +2685,6 @@ struct ieee80211_ops ath9k_ops = {
 	.add_interface 	    = ath9k_add_interface,
 	.remove_interface   = ath9k_remove_interface,
 	.config 	    = ath9k_config,
-	.config_interface   = ath9k_config_interface,
 	.configure_filter   = ath9k_configure_filter,
 	.sta_notify         = ath9k_sta_notify,
 	.conf_tx 	    = ath9k_conf_tx,
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-04-22 16:33:32.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-04-22 16:36:22.000000000 +0200
@@ -3543,12 +3543,38 @@ static void b43_op_bss_info_changed(stru
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev;
+	unsigned long flags;
 
 	mutex_lock(&wl->mutex);
 
 	dev = wl->current_dev;
 	if (!dev || b43_status(dev) < B43_STAT_STARTED)
 		goto out_unlock_mutex;
+
+	B43_WARN_ON(wl->vif != vif);
+
+	if (changed & BSS_CHANGED_BSSID) {
+		spin_lock_irqsave(&wl->irq_lock, flags);
+		if (conf->bssid)
+			memcpy(wl->bssid, conf->bssid, ETH_ALEN);
+		else
+			memset(wl->bssid, 0, ETH_ALEN);
+
+		if (b43_status(dev) >= B43_STAT_INITIALIZED) {
+			if (b43_is_mode(wl, NL80211_IFTYPE_AP) ||
+			    b43_is_mode(wl, NL80211_IFTYPE_MESH_POINT)) {
+				B43_WARN_ON(vif->type != wl->if_type);
+				if (changed & BSS_CHANGED_BEACON)
+					b43_update_templates(wl);
+			} else if (b43_is_mode(wl, NL80211_IFTYPE_ADHOC)) {
+				if (changed & BSS_CHANGED_BEACON)
+					b43_update_templates(wl);
+			}
+			b43_write_mac_bssid_templates(dev);
+		}
+		spin_unlock_irqrestore(&wl->irq_lock, flags);
+	}
+
 	b43_mac_suspend(dev);
 
 	/* Update templates for AP/mesh mode. */
@@ -3571,8 +3597,6 @@ static void b43_op_bss_info_changed(stru
 	b43_mac_enable(dev);
 out_unlock_mutex:
 	mutex_unlock(&wl->mutex);
-
-	return;
 }
 
 static int b43_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
@@ -3730,41 +3754,6 @@ static void b43_op_configure_filter(stru
 	spin_unlock_irqrestore(&wl->irq_lock, flags);
 }
 
-static int b43_op_config_interface(struct ieee80211_hw *hw,
-				   struct ieee80211_vif *vif,
-				   struct ieee80211_if_conf *conf)
-{
-	struct b43_wl *wl = hw_to_b43_wl(hw);
-	struct b43_wldev *dev = wl->current_dev;
-	unsigned long flags;
-
-	if (!dev)
-		return -ENODEV;
-	mutex_lock(&wl->mutex);
-	spin_lock_irqsave(&wl->irq_lock, flags);
-	B43_WARN_ON(wl->vif != vif);
-	if (conf->bssid)
-		memcpy(wl->bssid, conf->bssid, ETH_ALEN);
-	else
-		memset(wl->bssid, 0, ETH_ALEN);
-	if (b43_status(dev) >= B43_STAT_INITIALIZED) {
-		if (b43_is_mode(wl, NL80211_IFTYPE_AP) ||
-		    b43_is_mode(wl, NL80211_IFTYPE_MESH_POINT)) {
-			B43_WARN_ON(vif->type != wl->if_type);
-			if (conf->changed & IEEE80211_IFCC_BEACON)
-				b43_update_templates(wl);
-		} else if (b43_is_mode(wl, NL80211_IFTYPE_ADHOC)) {
-			if (conf->changed & IEEE80211_IFCC_BEACON)
-				b43_update_templates(wl);
-		}
-		b43_write_mac_bssid_templates(dev);
-	}
-	spin_unlock_irqrestore(&wl->irq_lock, flags);
-	mutex_unlock(&wl->mutex);
-
-	return 0;
-}
-
 /* Locking: wl->mutex */
 static void b43_wireless_core_stop(struct b43_wldev *dev)
 {
@@ -4434,7 +4423,6 @@ static const struct ieee80211_ops b43_hw
 	.remove_interface	= b43_op_remove_interface,
 	.config			= b43_op_config,
 	.bss_info_changed	= b43_op_bss_info_changed,
-	.config_interface	= b43_op_config_interface,
 	.configure_filter	= b43_op_configure_filter,
 	.set_key		= b43_op_set_key,
 	.get_stats		= b43_op_get_stats,
--- wireless-testing.orig/drivers/net/wireless/b43legacy/main.c	2009-04-22 16:36:56.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43legacy/main.c	2009-04-22 16:38:53.000000000 +0200
@@ -2804,6 +2804,7 @@ static void b43legacy_op_bss_info_change
 	u32 savedirqs;
 
 	mutex_lock(&wl->mutex);
+	B43legacy_WARN_ON(wl->vif != vif);
 
 	dev = wl->current_dev;
 	phy = &dev->phy;
@@ -2817,8 +2818,29 @@ static void b43legacy_op_bss_info_change
 		goto out_unlock_mutex;
 	}
 	savedirqs = b43legacy_interrupt_disable(dev, B43legacy_IRQ_ALL);
-	spin_unlock_irqrestore(&wl->irq_lock, flags);
-	b43legacy_synchronize_irq(dev);
+
+	if (changed & BSS_CHANGED_BSSID) {
+		spin_unlock_irqrestore(&wl->irq_lock, flags);
+		b43legacy_synchronize_irq(dev);
+
+		if (conf->bssid)
+			memcpy(wl->bssid, conf->bssid, ETH_ALEN);
+		else
+			memset(wl->bssid, 0, ETH_ALEN);
+
+		if (b43legacy_status(dev) >= B43legacy_STAT_INITIALIZED) {
+			if (b43legacy_is_mode(wl, NL80211_IFTYPE_AP)) {
+				B43legacy_WARN_ON(vif->type != NL80211_IFTYPE_AP);
+				if (changed & BSS_CHANGED_BEACON)
+					b43legacy_update_templates(wl);
+			} else if (b43legacy_is_mode(wl, NL80211_IFTYPE_ADHOC)) {
+				if (changed & BSS_CHANGED_BEACON)
+					b43legacy_update_templates(wl);
+			}
+			b43legacy_write_mac_bssid_templates(dev);
+		}
+		spin_unlock_irqrestore(&wl->irq_lock, flags);
+	}
 
 	b43legacy_mac_suspend(dev);
 
@@ -2846,8 +2868,6 @@ static void b43legacy_op_bss_info_change
 	spin_unlock_irqrestore(&wl->irq_lock, flags);
  out_unlock_mutex:
 	mutex_unlock(&wl->mutex);
-
-	return;
 }
 
 static void b43legacy_op_configure_filter(struct ieee80211_hw *hw,
@@ -2889,40 +2909,6 @@ static void b43legacy_op_configure_filte
 	spin_unlock_irqrestore(&wl->irq_lock, flags);
 }
 
-static int b43legacy_op_config_interface(struct ieee80211_hw *hw,
-					 struct ieee80211_vif *vif,
-					 struct ieee80211_if_conf *conf)
-{
-	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
-	struct b43legacy_wldev *dev = wl->current_dev;
-	unsigned long flags;
-
-	if (!dev)
-		return -ENODEV;
-	mutex_lock(&wl->mutex);
-	spin_lock_irqsave(&wl->irq_lock, flags);
-	B43legacy_WARN_ON(wl->vif != vif);
-	if (conf->bssid)
-		memcpy(wl->bssid, conf->bssid, ETH_ALEN);
-	else
-		memset(wl->bssid, 0, ETH_ALEN);
-	if (b43legacy_status(dev) >= B43legacy_STAT_INITIALIZED) {
-		if (b43legacy_is_mode(wl, NL80211_IFTYPE_AP)) {
-			B43legacy_WARN_ON(vif->type != NL80211_IFTYPE_AP);
-			if (conf->changed & IEEE80211_IFCC_BEACON)
-				b43legacy_update_templates(wl);
-		} else if (b43legacy_is_mode(wl, NL80211_IFTYPE_ADHOC)) {
-			if (conf->changed & IEEE80211_IFCC_BEACON)
-				b43legacy_update_templates(wl);
-		}
-		b43legacy_write_mac_bssid_templates(dev);
-	}
-	spin_unlock_irqrestore(&wl->irq_lock, flags);
-	mutex_unlock(&wl->mutex);
-
-	return 0;
-}
-
 /* Locking: wl->mutex */
 static void b43legacy_wireless_core_stop(struct b43legacy_wldev *dev)
 {
@@ -3563,7 +3549,6 @@ static const struct ieee80211_ops b43leg
 	.remove_interface	= b43legacy_op_remove_interface,
 	.config			= b43legacy_op_dev_config,
 	.bss_info_changed	= b43legacy_op_bss_info_changed,
-	.config_interface	= b43legacy_op_config_interface,
 	.configure_filter	= b43legacy_op_configure_filter,
 	.get_stats		= b43legacy_op_get_stats,
 	.get_tx_stats		= b43legacy_op_get_tx_stats,
--- wireless-testing.orig/drivers/net/wireless/libertas_tf/main.c	2009-04-22 16:39:43.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas_tf/main.c	2009-04-22 16:42:01.000000000 +0200
@@ -366,36 +366,6 @@ static int lbtf_op_config(struct ieee802
 	return 0;
 }
 
-static int lbtf_op_config_interface(struct ieee80211_hw *hw,
-			struct ieee80211_vif *vif,
-			struct ieee80211_if_conf *conf)
-{
-	struct lbtf_private *priv = hw->priv;
-	struct sk_buff *beacon;
-
-	switch (priv->vif->type) {
-	case NL80211_IFTYPE_AP:
-	case NL80211_IFTYPE_MESH_POINT:
-		beacon = ieee80211_beacon_get(hw, vif);
-		if (beacon) {
-			lbtf_beacon_set(priv, beacon);
-			kfree_skb(beacon);
-			lbtf_beacon_ctrl(priv, 1, vif->bss_conf.beacon_int);
-		}
-		break;
-	default:
-		break;
-	}
-
-	if (conf->bssid) {
-		u8 null_bssid[ETH_ALEN] = {0};
-		bool activate = compare_ether_addr(conf->bssid, null_bssid);
-		lbtf_set_bssid(priv, activate, conf->bssid);
-	}
-
-	return 0;
-}
-
 #define SUPPORTED_FIF_FLAGS  (FIF_PROMISC_IN_BSS | FIF_ALLMULTI)
 static void lbtf_op_configure_filter(struct ieee80211_hw *hw,
 			unsigned int changed_flags,
@@ -451,6 +421,29 @@ static void lbtf_op_bss_info_changed(str
 			u32 changes)
 {
 	struct lbtf_private *priv = hw->priv;
+	struct sk_buff *beacon;
+
+	if (changes & (BSS_CHANGED_BEACON | BSS_CHANGED_BEACON_INT)) {
+		switch (priv->vif->type) {
+		case NL80211_IFTYPE_AP:
+		case NL80211_IFTYPE_MESH_POINT:
+			beacon = ieee80211_beacon_get(hw, vif);
+			if (beacon) {
+				lbtf_beacon_set(priv, beacon);
+				kfree_skb(beacon);
+				lbtf_beacon_ctrl(priv, 1,
+						 bss_conf->beacon_int);
+			}
+			break;
+		default:
+			break;
+		}
+	}
+
+	if (changes & BSS_CHANGED_BSSID) {
+		bool activate = !is_zero_ether_addr(bss_conf->bssid);
+		lbtf_set_bssid(priv, activate, bss_conf->bssid);
+	}
 
 	if (changes & BSS_CHANGED_ERP_PREAMBLE) {
 		if (bss_conf->use_short_preamble)
@@ -459,8 +452,6 @@ static void lbtf_op_bss_info_changed(str
 			priv->preamble = CMD_TYPE_LONG_PREAMBLE;
 		lbtf_set_radio_control(priv);
 	}
-
-	return;
 }
 
 static const struct ieee80211_ops lbtf_ops = {
@@ -470,7 +461,6 @@ static const struct ieee80211_ops lbtf_o
 	.add_interface		= lbtf_op_add_interface,
 	.remove_interface	= lbtf_op_remove_interface,
 	.config			= lbtf_op_config,
-	.config_interface	= lbtf_op_config_interface,
 	.configure_filter	= lbtf_op_configure_filter,
 	.bss_info_changed	= lbtf_op_bss_info_changed,
 };
--- wireless-testing.orig/drivers/net/wireless/p54/p54common.c	2009-04-22 16:42:31.000000000 +0200
+++ wireless-testing/drivers/net/wireless/p54/p54common.c	2009-04-22 16:45:47.000000000 +0200
@@ -2204,41 +2204,6 @@ out:
 	return ret;
 }
 
-static int p54_config_interface(struct ieee80211_hw *dev,
-				struct ieee80211_vif *vif,
-				struct ieee80211_if_conf *conf)
-{
-	struct p54_common *priv = dev->priv;
-	int ret = 0;
-
-	mutex_lock(&priv->conf_mutex);
-	if (conf->changed & IEEE80211_IFCC_BSSID) {
-		memcpy(priv->bssid, conf->bssid, ETH_ALEN);
-		ret = p54_setup_mac(dev);
-		if (ret)
-			goto out;
-	}
-
-	if (conf->changed & IEEE80211_IFCC_BEACON) {
-		ret = p54_scan(dev, P54_SCAN_EXIT, 0);
-		if (ret)
-			goto out;
-		ret = p54_setup_mac(dev);
-		if (ret)
-			goto out;
-		ret = p54_beacon_update(dev, vif);
-		if (ret)
-			goto out;
-		ret = p54_set_edcf(dev);
-		if (ret)
-			goto out;
-	}
-
-out:
-	mutex_unlock(&priv->conf_mutex);
-	return ret;
-}
-
 static void p54_configure_filter(struct ieee80211_hw *dev,
 				 unsigned int changed_flags,
 				 unsigned int *total_flags,
@@ -2342,8 +2307,32 @@ static void p54_bss_info_changed(struct 
 				 u32 changed)
 {
 	struct p54_common *priv = dev->priv;
+	int ret;
+
+	mutex_lock(&priv->conf_mutex);
+	if (changed & BSS_CHANGED_BSSID) {
+		memcpy(priv->bssid, info->bssid, ETH_ALEN);
+		ret = p54_setup_mac(dev);
+		if (ret)
+			goto out;
+	}
 
-	if (changed & BSS_CHANGED_ERP_SLOT) {
+	if (changed & BSS_CHANGED_BEACON) {
+		ret = p54_scan(dev, P54_SCAN_EXIT, 0);
+		if (ret)
+			goto out;
+		ret = p54_setup_mac(dev);
+		if (ret)
+			goto out;
+		ret = p54_beacon_update(dev, vif);
+		if (ret)
+			goto out;
+	}
+	/* XXX: this mimics having two callbacks... clean up */
+ out:
+	mutex_unlock(&priv->conf_mutex);
+
+	if (changed & (BSS_CHANGED_ERP_SLOT | BSS_CHANGED_BEACON)) {
 		priv->use_short_slot = info->use_short_slot;
 		p54_set_edcf(dev);
 	}
@@ -2364,7 +2353,6 @@ static void p54_bss_info_changed(struct 
 			p54_setup_mac(dev);
 		}
 	}
-
 }
 
 static int p54_set_key(struct ieee80211_hw *dev, enum set_key_cmd cmd,
@@ -2619,7 +2607,6 @@ static const struct ieee80211_ops p54_op
 	.sta_notify		= p54_sta_notify,
 	.set_key		= p54_set_key,
 	.config			= p54_config,
-	.config_interface	= p54_config_interface,
 	.bss_info_changed	= p54_bss_info_changed,
 	.configure_filter	= p54_configure_filter,
 	.conf_tx		= p54_conf_tx,
--- wireless-testing.orig/drivers/net/wireless/rt2x00/rt2x00.h	2009-04-22 16:46:25.000000000 +0200
+++ wireless-testing/drivers/net/wireless/rt2x00/rt2x00.h	2009-04-22 16:46:31.000000000 +0200
@@ -943,9 +943,6 @@ int rt2x00mac_add_interface(struct ieee8
 void rt2x00mac_remove_interface(struct ieee80211_hw *hw,
 				struct ieee80211_if_init_conf *conf);
 int rt2x00mac_config(struct ieee80211_hw *hw, u32 changed);
-int rt2x00mac_config_interface(struct ieee80211_hw *hw,
-			       struct ieee80211_vif *vif,
-			       struct ieee80211_if_conf *conf);
 void rt2x00mac_configure_filter(struct ieee80211_hw *hw,
 				unsigned int changed_flags,
 				unsigned int *total_flags,
--- wireless-testing.orig/drivers/net/wireless/rt2x00/rt2x00mac.c	2009-04-22 16:46:53.000000000 +0200
+++ wireless-testing/drivers/net/wireless/rt2x00/rt2x00mac.c	2009-04-22 16:50:25.000000000 +0200
@@ -390,56 +390,6 @@ int rt2x00mac_config(struct ieee80211_hw
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_config);
 
-int rt2x00mac_config_interface(struct ieee80211_hw *hw,
-			       struct ieee80211_vif *vif,
-			       struct ieee80211_if_conf *conf)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct rt2x00_intf *intf = vif_to_intf(vif);
-	int update_bssid = 0;
-	int status = 0;
-
-	/*
-	 * Mac80211 might be calling this function while we are trying
-	 * to remove the device or perhaps suspending it.
-	 */
-	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
-		return 0;
-
-	spin_lock(&intf->lock);
-
-	/*
-	 * conf->bssid can be NULL if coming from the internal
-	 * beacon update routine.
-	 */
-	if (conf->changed & IEEE80211_IFCC_BSSID && conf->bssid) {
-		update_bssid = 1;
-		memcpy(&intf->bssid, conf->bssid, ETH_ALEN);
-	}
-
-	spin_unlock(&intf->lock);
-
-	/*
-	 * Call rt2x00_config_intf() outside of the spinlock context since
-	 * the call will sleep for USB drivers. By using the ieee80211_if_conf
-	 * values as arguments we make keep access to rt2x00_intf thread safe
-	 * even without the lock.
-	 */
-	rt2x00lib_config_intf(rt2x00dev, intf, vif->type, NULL,
-			      update_bssid ? conf->bssid : NULL);
-
-	/*
-	 * Update the beacon.
-	 */
-	if (conf->changed & (IEEE80211_IFCC_BEACON |
-			     IEEE80211_IFCC_BEACON_ENABLED))
-		status = rt2x00queue_update_beacon(rt2x00dev, vif,
-						   conf->enable_beacon);
-
-	return status;
-}
-EXPORT_SYMBOL_GPL(rt2x00mac_config_interface);
-
 void rt2x00mac_configure_filter(struct ieee80211_hw *hw,
 				unsigned int changed_flags,
 				unsigned int *total_flags,
@@ -623,6 +573,44 @@ void rt2x00mac_bss_info_changed(struct i
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct rt2x00_intf *intf = vif_to_intf(vif);
 	unsigned int delayed = 0;
+	int update_bssid = 0;
+
+	/*
+	 * Mac80211 might be calling this function while we are trying
+	 * to remove the device or perhaps suspending it.
+	 */
+	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
+		return;
+
+	spin_lock(&intf->lock);
+
+	/*
+	 * conf->bssid can be NULL if coming from the internal
+	 * beacon update routine.
+	 */
+	if (changes & BSS_CHANGED_BSSID) {
+		update_bssid = 1;
+		memcpy(&intf->bssid, bss_conf->bssid, ETH_ALEN);
+	}
+
+	spin_unlock(&intf->lock);
+
+	/*
+	 * Call rt2x00_config_intf() outside of the spinlock context since
+	 * the call will sleep for USB drivers. By using the ieee80211_if_conf
+	 * values as arguments we make keep access to rt2x00_intf thread safe
+	 * even without the lock.
+	 */
+	if (changes & BSS_CHANGED_BSSID)
+		rt2x00lib_config_intf(rt2x00dev, intf, vif->type, NULL,
+				      update_bssid ? bss_conf->bssid : NULL);
+
+	/*
+	 * Update the beacon.
+	 */
+	if (changes & (BSS_CHANGED_BEACON | BSS_CHANGED_BEACON_ENABLED))
+		rt2x00queue_update_beacon(rt2x00dev, vif,
+					  bss_conf->enable_beacon);
 
 	/*
 	 * When the association status has changed we must reset the link
--- wireless-testing.orig/drivers/net/wireless/rt2x00/rt2400pci.c	2009-04-22 16:51:02.000000000 +0200
+++ wireless-testing/drivers/net/wireless/rt2x00/rt2400pci.c	2009-04-22 16:51:09.000000000 +0200
@@ -1580,7 +1580,6 @@ static const struct ieee80211_ops rt2400
 	.add_interface		= rt2x00mac_add_interface,
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,
-	.config_interface	= rt2x00mac_config_interface,
 	.configure_filter	= rt2x00mac_configure_filter,
 	.get_stats		= rt2x00mac_get_stats,
 	.bss_info_changed	= rt2x00mac_bss_info_changed,
--- wireless-testing.orig/drivers/net/wireless/rt2x00/rt2500pci.c	2009-04-22 16:51:02.000000000 +0200
+++ wireless-testing/drivers/net/wireless/rt2x00/rt2500pci.c	2009-04-22 16:51:11.000000000 +0200
@@ -1879,7 +1879,6 @@ static const struct ieee80211_ops rt2500
 	.add_interface		= rt2x00mac_add_interface,
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,
-	.config_interface	= rt2x00mac_config_interface,
 	.configure_filter	= rt2x00mac_configure_filter,
 	.get_stats		= rt2x00mac_get_stats,
 	.bss_info_changed	= rt2x00mac_bss_info_changed,
--- wireless-testing.orig/drivers/net/wireless/rt2x00/rt2500usb.c	2009-04-22 16:51:02.000000000 +0200
+++ wireless-testing/drivers/net/wireless/rt2x00/rt2500usb.c	2009-04-22 16:51:12.000000000 +0200
@@ -1908,7 +1908,6 @@ static const struct ieee80211_ops rt2500
 	.add_interface		= rt2x00mac_add_interface,
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,
-	.config_interface	= rt2x00mac_config_interface,
 	.configure_filter	= rt2x00mac_configure_filter,
 	.set_key		= rt2x00mac_set_key,
 	.get_stats		= rt2x00mac_get_stats,
--- wireless-testing.orig/drivers/net/wireless/rt2x00/rt61pci.c	2009-04-22 16:51:02.000000000 +0200
+++ wireless-testing/drivers/net/wireless/rt2x00/rt61pci.c	2009-04-22 16:51:13.000000000 +0200
@@ -2735,7 +2735,6 @@ static const struct ieee80211_ops rt61pc
 	.add_interface		= rt2x00mac_add_interface,
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,
-	.config_interface	= rt2x00mac_config_interface,
 	.configure_filter	= rt2x00mac_configure_filter,
 	.set_key		= rt2x00mac_set_key,
 	.get_stats		= rt2x00mac_get_stats,
--- wireless-testing.orig/drivers/net/wireless/rt2x00/rt73usb.c	2009-04-22 16:51:02.000000000 +0200
+++ wireless-testing/drivers/net/wireless/rt2x00/rt73usb.c	2009-04-22 16:51:14.000000000 +0200
@@ -2259,7 +2259,6 @@ static const struct ieee80211_ops rt73us
 	.add_interface		= rt2x00mac_add_interface,
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,
-	.config_interface	= rt2x00mac_config_interface,
 	.configure_filter	= rt2x00mac_configure_filter,
 	.set_key		= rt2x00mac_set_key,
 	.get_stats		= rt2x00mac_get_stats,
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8180_dev.c	2009-04-22 16:51:37.000000000 +0200
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8180_dev.c	2009-04-22 16:53:13.000000000 +0200
@@ -702,30 +702,26 @@ static int rtl8180_config(struct ieee802
 	return 0;
 }
 
-static int rtl8180_config_interface(struct ieee80211_hw *dev,
-				    struct ieee80211_vif *vif,
-				    struct ieee80211_if_conf *conf)
-{
-	struct rtl8180_priv *priv = dev->priv;
-	int i;
-
-	for (i = 0; i < ETH_ALEN; i++)
-		rtl818x_iowrite8(priv, &priv->map->BSSID[i], conf->bssid[i]);
-
-	if (is_valid_ether_addr(conf->bssid))
-		rtl818x_iowrite8(priv, &priv->map->MSR, RTL818X_MSR_INFRA);
-	else
-		rtl818x_iowrite8(priv, &priv->map->MSR, RTL818X_MSR_NO_LINK);
-
-	return 0;
-}
-
 static void rtl8180_bss_info_changed(struct ieee80211_hw *dev,
 				     struct ieee80211_vif *vif,
 				     struct ieee80211_bss_conf *info,
 				     u32 changed)
 {
 	struct rtl8180_priv *priv = dev->priv;
+	int i;
+
+	if (changed & BSS_CHANGED_BSSID) {
+		for (i = 0; i < ETH_ALEN; i++)
+			rtl818x_iowrite8(priv, &priv->map->BSSID[i],
+					 info->bssid[i]);
+
+		if (is_valid_ether_addr(info->bssid))
+			rtl818x_iowrite8(priv, &priv->map->MSR,
+					 RTL818X_MSR_INFRA);
+		else
+			rtl818x_iowrite8(priv, &priv->map->MSR,
+					 RTL818X_MSR_NO_LINK);
+	}
 
 	if (changed & BSS_CHANGED_ERP_SLOT && priv->rf->conf_erp)
 	        priv->rf->conf_erp(dev, info);
@@ -770,7 +766,6 @@ static const struct ieee80211_ops rtl818
 	.add_interface		= rtl8180_add_interface,
 	.remove_interface	= rtl8180_remove_interface,
 	.config			= rtl8180_config,
-	.config_interface	= rtl8180_config_interface,
 	.bss_info_changed	= rtl8180_bss_info_changed,
 	.configure_filter	= rtl8180_configure_filter,
 };
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c	2009-04-22 16:53:28.000000000 +0200
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c	2009-04-22 16:54:16.000000000 +0200
@@ -1090,32 +1090,6 @@ static int rtl8187_config(struct ieee802
 	return 0;
 }
 
-static int rtl8187_config_interface(struct ieee80211_hw *dev,
-				    struct ieee80211_vif *vif,
-				    struct ieee80211_if_conf *conf)
-{
-	struct rtl8187_priv *priv = dev->priv;
-	int i;
-	u8 reg;
-
-	mutex_lock(&priv->conf_mutex);
-	for (i = 0; i < ETH_ALEN; i++)
-		rtl818x_iowrite8(priv, &priv->map->BSSID[i], conf->bssid[i]);
-
-	if (is_valid_ether_addr(conf->bssid)) {
-		reg = RTL818X_MSR_INFRA;
-		if (priv->is_rtl8187b)
-			reg |= RTL818X_MSR_ENEDCA;
-		rtl818x_iowrite8(priv, &priv->map->MSR, reg);
-	} else {
-		reg = RTL818X_MSR_NO_LINK;
-		rtl818x_iowrite8(priv, &priv->map->MSR, reg);
-	}
-
-	mutex_unlock(&priv->conf_mutex);
-	return 0;
-}
-
 /*
  * With 8187B, AC_*_PARAM clashes with FEMR definition in struct rtl818x_csr for
  * example. Thus we have to use raw values for AC_*_PARAM register addresses.
@@ -1193,6 +1167,27 @@ static void rtl8187_bss_info_changed(str
 				     u32 changed)
 {
 	struct rtl8187_priv *priv = dev->priv;
+	int i;
+	u8 reg;
+
+	if (changed & BSS_CHANGED_BSSID) {
+		mutex_lock(&priv->conf_mutex);
+		for (i = 0; i < ETH_ALEN; i++)
+			rtl818x_iowrite8(priv, &priv->map->BSSID[i],
+					 info->bssid[i]);
+
+		if (is_valid_ether_addr(info->bssid)) {
+			reg = RTL818X_MSR_INFRA;
+			if (priv->is_rtl8187b)
+				reg |= RTL818X_MSR_ENEDCA;
+			rtl818x_iowrite8(priv, &priv->map->MSR, reg);
+		} else {
+			reg = RTL818X_MSR_NO_LINK;
+			rtl818x_iowrite8(priv, &priv->map->MSR, reg);
+		}
+
+		mutex_unlock(&priv->conf_mutex);
+	}
 
 	if (changed & (BSS_CHANGED_ERP_SLOT | BSS_CHANGED_ERP_PREAMBLE))
 		rtl8187_conf_erp(priv, info->use_short_slot,
@@ -1274,7 +1269,6 @@ static const struct ieee80211_ops rtl818
 	.add_interface		= rtl8187_add_interface,
 	.remove_interface	= rtl8187_remove_interface,
 	.config			= rtl8187_config,
-	.config_interface	= rtl8187_config_interface,
 	.bss_info_changed	= rtl8187_bss_info_changed,
 	.configure_filter	= rtl8187_configure_filter,
 	.conf_tx		= rtl8187_conf_tx
--- wireless-testing.orig/drivers/net/wireless/zd1211rw/zd_mac.c	2009-04-22 16:54:33.000000000 +0200
+++ wireless-testing/drivers/net/wireless/zd1211rw/zd_mac.c	2009-04-22 16:56:52.000000000 +0200
@@ -755,52 +755,6 @@ static int zd_op_config(struct ieee80211
 	return zd_chip_set_channel(&mac->chip, conf->channel->hw_value);
 }
 
-static int zd_op_config_interface(struct ieee80211_hw *hw,
-				  struct ieee80211_vif *vif,
-				   struct ieee80211_if_conf *conf)
-{
-	struct zd_mac *mac = zd_hw_mac(hw);
-	int associated;
-	int r;
-
-	if (mac->type == NL80211_IFTYPE_MESH_POINT ||
-	    mac->type == NL80211_IFTYPE_ADHOC) {
-		associated = true;
-		if (conf->changed & IEEE80211_IFCC_BEACON) {
-			struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
-
-			if (!beacon)
-				return -ENOMEM;
-			r = zd_mac_config_beacon(hw, beacon);
-			kfree_skb(beacon);
-
-			if (r < 0)
-				return r;
-		}
-
-		if (conf->changed & IEEE80211_IFCC_BEACON_ENABLED) {
-			u32 interval;
-
-			if (conf->enable_beacon)
-				interval = BCN_MODE_IBSS | hw->conf.beacon_int;
-			else
-				interval = 0;
-
-			r = zd_set_beacon_interval(&mac->chip, interval);
-			if (r < 0)
-				return r;
-		}
-	} else
-		associated = is_valid_ether_addr(conf->bssid);
-
-	spin_lock_irq(&mac->lock);
-	mac->associated = associated;
-	spin_unlock_irq(&mac->lock);
-
-	/* TODO: do hardware bssid filtering */
-	return 0;
-}
-
 static void zd_process_intr(struct work_struct *work)
 {
 	u16 int_status;
@@ -923,9 +877,42 @@ static void zd_op_bss_info_changed(struc
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
 	unsigned long flags;
+	int associated;
 
 	dev_dbg_f(zd_mac_dev(mac), "changes: %x\n", changes);
 
+	if (mac->type == NL80211_IFTYPE_MESH_POINT ||
+	    mac->type == NL80211_IFTYPE_ADHOC) {
+		associated = true;
+		if (changes & BSS_CHANGED_BEACON) {
+			struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
+
+			if (beacon) {
+				zd_mac_config_beacon(hw, beacon);
+				kfree_skb(beacon);
+			}
+		}
+
+		if (changes & BSS_CHANGED_BEACON_ENABLED) {
+			u32 interval;
+
+			if (bss_conf->enable_beacon)
+				interval = BCN_MODE_IBSS |
+						bss_conf->beacon_int;
+			else
+				interval = 0;
+
+			zd_set_beacon_interval(&mac->chip, interval);
+		}
+	} else
+		associated = is_valid_ether_addr(bss_conf->bssid);
+
+	spin_lock_irq(&mac->lock);
+	mac->associated = associated;
+	spin_unlock_irq(&mac->lock);
+
+	/* TODO: do hardware bssid filtering */
+
 	if (changes & BSS_CHANGED_ERP_PREAMBLE) {
 		spin_lock_irqsave(&mac->lock, flags);
 		mac->short_preamble = bss_conf->use_short_preamble;
@@ -952,7 +939,6 @@ static const struct ieee80211_ops zd_ops
 	.add_interface		= zd_op_add_interface,
 	.remove_interface	= zd_op_remove_interface,
 	.config			= zd_op_config,
-	.config_interface	= zd_op_config_interface,
 	.configure_filter	= zd_op_configure_filter,
 	.bss_info_changed	= zd_op_bss_info_changed,
 	.get_tsf		= zd_op_get_tsf,

-- 

