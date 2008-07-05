Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52532 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091AbYGEXvT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2008 19:51:19 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1KFHXA-0003JR-F3
	for linux-wireless@vger.kernel.org; Sun, 06 Jul 2008 01:51:17 +0200
Message-Id: <20080705235014.991145000@sipsolutions.net> (sfid-20080706_015141_415210_D4B1E4C5)
References: <20080705234735.210585000@sipsolutions.net>
Date: Sun, 06 Jul 2008 01:47:39 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFT 4/4] mac80211: revamp beacon configuration
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes mac80211's beacon configuration handling
to never pass skbs to the driver directly but rather always
require the driver to use ieee80211_beacon_get(). Additionally,
it introduces "change flags" on the config_interface() call
to enable drivers to figure out what is changing. Finally, it
removes the beacon_update() driver callback in favour of
having IBSS beacon delivered by ieee80211_beacon_get() as well.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/ath5k/base.c           |   13 +++
 drivers/net/wireless/b43/main.c             |   48 +++++-------
 drivers/net/wireless/b43legacy/main.c       |   45 ++++-------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   19 ++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   18 +++-
 drivers/net/wireless/rt2x00/rt2400pci.c     |    2 
 drivers/net/wireless/rt2x00/rt2500pci.c     |    2 
 drivers/net/wireless/rt2x00/rt2500usb.c     |    2 
 drivers/net/wireless/rt2x00/rt2x00.h        |    2 
 drivers/net/wireless/rt2x00/rt2x00dev.c     |   10 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c     |   22 ++++-
 drivers/net/wireless/rt2x00/rt61pci.c       |    2 
 drivers/net/wireless/rt2x00/rt73usb.c       |    2 
 drivers/net/wireless/zd1211rw/zd_mac.c      |   21 +----
 include/net/mac80211.h                      |   49 ++++--------
 net/mac80211/cfg.c                          |    4 -
 net/mac80211/ieee80211_i.h                  |    3 
 net/mac80211/main.c                         |   59 ++++++--------
 net/mac80211/mlme.c                         |  112 +++++++++++-----------------
 net/mac80211/tx.c                           |   36 +++++----
 net/mac80211/wext.c                         |    2 
 21 files changed, 225 insertions(+), 248 deletions(-)

--- everything.orig/include/net/mac80211.h	2008-07-05 23:32:56.000000000 +0200
+++ everything/include/net/mac80211.h	2008-07-05 23:33:20.000000000 +0200
@@ -519,33 +519,38 @@ struct ieee80211_if_init_conf {
 };
 
 /**
+ * enum ieee80211_if_conf_change - interface config change flags
+ *
+ * @IEEE80211_IFCC_BSSID: The BSSID changed.
+ * @IEEE80211_IFCC_SSID: The SSID changed.
+ * @IEEE80211_IFCC_BEACON: The beacon for this interface changed
+ *	(currently AP and MESH only), use ieee80211_beacon_get().
+ */
+enum ieee80211_if_conf_change {
+	IEEE80211_IFCC_BSSID	= BIT(0),
+	IEEE80211_IFCC_SSID	= BIT(1),
+	IEEE80211_IFCC_BEACON	= BIT(2),
+};
+
+/**
  * struct ieee80211_if_conf - configuration of an interface
  *
- * @type: type of the interface. This is always the same as was specified in
- *	&struct ieee80211_if_init_conf. The type of an interface never changes
- *	during the life of the interface; this field is present only for
- *	convenience.
+ * @changed: parameters that have changed, see &enum ieee80211_if_conf_change.
  * @bssid: BSSID of the network we are associated to/creating.
  * @ssid: used (together with @ssid_len) by drivers for hardware that
  *	generate beacons independently. The pointer is valid only during the
  *	config_interface() call, so copy the value somewhere if you need
  *	it.
  * @ssid_len: length of the @ssid field.
- * @beacon: beacon template. Valid only if @host_gen_beacon_template in
- *	&struct ieee80211_hw is set. The driver is responsible of freeing
- *	the sk_buff.
- * @beacon_control: tx_control for the beacon template, this field is only
- *	valid when the @beacon field was set.
  *
  * This structure is passed to the config_interface() callback of
  * &struct ieee80211_hw.
  */
 struct ieee80211_if_conf {
-	int type;
+	u32 changed;
 	u8 *bssid;
 	u8 *ssid;
 	size_t ssid_len;
-	struct sk_buff *beacon;
 };
 
 /**
@@ -673,15 +678,6 @@ enum ieee80211_tkip_key_type {
  * any particular flags. There are some exceptions to this rule,
  * however, so you are advised to review these flags carefully.
  *
- * @IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE:
- *	The device only needs to be supplied with a beacon template.
- *	If you need the host to generate each beacon then don't use
- *	this flag and call ieee80211_beacon_get() when you need the
- *	next beacon frame. Note that if you set this flag, you must
- *	implement the set_tim() callback for powersave mode to work
- *	properly.
- *	This flag is only relevant for access-point mode.
- *
  * @IEEE80211_HW_RX_INCLUDES_FCS:
  *	Indicates that received frames passed to the stack include
  *	the FCS at the end.
@@ -1141,17 +1137,6 @@ enum ieee80211_ampdu_mlme_action {
  *	function is optional if the firmware/hardware takes full care of
  *	TSF synchronization.
  *
- * @beacon_update: Setup beacon data for IBSS beacons. Unlike access point,
- *	IBSS uses a fixed beacon frame which is configured using this
- *	function.
- *	If the driver returns success (0) from this callback, it owns
- *	the skb. That means the driver is responsible to kfree_skb() it.
- *	The control structure is not dynamically allocated. That means the
- *	driver does not own the pointer and if it needs it somewhere
- *	outside of the context of this function, it must copy it
- *	somewhere else.
- *	This handler is required only for IBSS mode.
- *
  * @tx_last_beacon: Determine whether the last IBSS beacon was sent by us.
  *	This is needed only for IBSS mode and the result of this function is
  *	used to determine whether to reply to Probe Requests.
@@ -1209,8 +1194,6 @@ struct ieee80211_ops {
 			    struct ieee80211_tx_queue_stats *stats);
 	u64 (*get_tsf)(struct ieee80211_hw *hw);
 	void (*reset_tsf)(struct ieee80211_hw *hw);
-	int (*beacon_update)(struct ieee80211_hw *hw,
-			     struct sk_buff *skb);
 	int (*tx_last_beacon)(struct ieee80211_hw *hw);
 	int (*ampdu_action)(struct ieee80211_hw *hw,
 			    enum ieee80211_ampdu_mlme_action action,
--- everything.orig/net/mac80211/cfg.c	2008-07-05 23:33:18.000000000 +0200
+++ everything/net/mac80211/cfg.c	2008-07-05 23:33:20.000000000 +0200
@@ -469,7 +469,7 @@ static int ieee80211_config_beacon(struc
 
 	kfree(old);
 
-	return ieee80211_if_config_beacon(sdata->dev);
+	return ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON);
 }
 
 static int ieee80211_add_beacon(struct wiphy *wiphy, struct net_device *dev,
@@ -523,7 +523,7 @@ static int ieee80211_del_beacon(struct w
 	synchronize_rcu();
 	kfree(old);
 
-	return ieee80211_if_config_beacon(dev);
+	return ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON);
 }
 
 /* Layer 2 Update frame (802.2 Type 1 LLC XID Update response) */
--- everything.orig/net/mac80211/ieee80211_i.h	2008-07-05 23:33:18.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-07-05 23:33:20.000000000 +0200
@@ -854,8 +854,7 @@ static inline int ieee80211_bssid_match(
 
 /* ieee80211.c */
 int ieee80211_hw_config(struct ieee80211_local *local);
-int ieee80211_if_config(struct net_device *dev);
-int ieee80211_if_config_beacon(struct net_device *dev);
+int ieee80211_if_config(struct ieee80211_sub_if_data *sdata, u32 changed);
 void ieee80211_tx_set_protected(struct ieee80211_tx_data *tx);
 u32 ieee80211_handle_ht(struct ieee80211_local *local, int enable_ht,
 			struct ieee80211_ht_info *req_ht_cap,
--- everything.orig/net/mac80211/main.c	2008-07-05 23:33:16.000000000 +0200
+++ everything/net/mac80211/main.c	2008-07-05 23:33:20.000000000 +0200
@@ -306,7 +306,8 @@ static int ieee80211_open(struct net_dev
 		if (res)
 			goto err_stop;
 
-		ieee80211_if_config(dev);
+		if (ieee80211_vif_is_mesh(&sdata->vif))
+			ieee80211_start_mesh(sdata->dev);
 		ieee80211_reset_erp_info(dev);
 		ieee80211_enable_keys(sdata);
 
@@ -979,57 +980,47 @@ void ieee80211_if_setup(struct net_devic
 
 /* everything else */
 
-static int __ieee80211_if_config(struct net_device *dev,
-				 struct sk_buff *beacon)
+int ieee80211_if_config(struct ieee80211_sub_if_data *sdata, u32 changed)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_conf conf;
 
-	if (!local->ops->config_interface || !netif_running(dev))
+	if (WARN_ON(!netif_running(sdata->dev)))
+		return 0;
+
+	if (!local->ops->config_interface)
 		return 0;
 
 	memset(&conf, 0, sizeof(conf));
-	conf.type = sdata->vif.type;
+	conf.changed = changed;
+
 	if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
 	    sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
 		conf.bssid = sdata->u.sta.bssid;
 		conf.ssid = sdata->u.sta.ssid;
 		conf.ssid_len = sdata->u.sta.ssid_len;
-	} else if (ieee80211_vif_is_mesh(&sdata->vif)) {
-		conf.beacon = beacon;
-		ieee80211_start_mesh(dev);
 	} else if (sdata->vif.type == IEEE80211_IF_TYPE_AP) {
+		conf.bssid = sdata->dev->dev_addr;
 		conf.ssid = sdata->u.ap.ssid;
 		conf.ssid_len = sdata->u.ap.ssid_len;
-		conf.beacon = beacon;
+	} else if (ieee80211_vif_is_mesh(&sdata->vif)) {
+		u8 zero[ETH_ALEN] = { 0 };
+		conf.bssid = zero;
+		conf.ssid = zero;
+		conf.ssid_len = 0;
+	} else {
+		WARN_ON(1);
+		return -EINVAL;
 	}
-	return local->ops->config_interface(local_to_hw(local),
-					    &sdata->vif, &conf);
-}
 
-int ieee80211_if_config(struct net_device *dev)
-{
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT &&
-	    (local->hw.flags & IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE))
-		return ieee80211_if_config_beacon(dev);
-	return __ieee80211_if_config(dev, NULL);
-}
+	if (WARN_ON(!conf.bssid && (changed & IEEE80211_IFCC_BSSID)))
+		return -EINVAL;
 
-int ieee80211_if_config_beacon(struct net_device *dev)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct sk_buff *skb;
+	if (WARN_ON(!conf.ssid && (changed & IEEE80211_IFCC_SSID)))
+		return -EINVAL;
 
-	if (!(local->hw.flags & IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE))
-		return 0;
-	skb = ieee80211_beacon_get(local_to_hw(local), &sdata->vif);
-	if (!skb)
-		return -ENOMEM;
-	return __ieee80211_if_config(dev, skb);
+	return local->ops->config_interface(local_to_hw(local),
+					    &sdata->vif, &conf);
 }
 
 int ieee80211_hw_config(struct ieee80211_local *local)
--- everything.orig/net/mac80211/mlme.c	2008-07-05 23:33:10.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-07-05 23:33:20.000000000 +0200
@@ -2403,8 +2403,6 @@ static int ieee80211_sta_join_ibss(struc
 	int res, rates, i, j;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
-	struct ieee80211_tx_info *control;
-	struct rate_selection ratesel;
 	u8 *pos;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_supported_band *sband;
@@ -2422,7 +2420,7 @@ static int ieee80211_sta_join_ibss(struc
 		local->ops->reset_tsf(local_to_hw(local));
 	}
 	memcpy(ifsta->bssid, bss->bssid, ETH_ALEN);
-	res = ieee80211_if_config(dev);
+	res = ieee80211_if_config(sdata, IEEE80211_IFCC_BSSID);
 	if (res)
 		return res;
 
@@ -2436,19 +2434,16 @@ static int ieee80211_sta_join_ibss(struc
 	if (res)
 		return res;
 
-	/* Set beacon template */
+	/* Build IBSS probe response */
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom + 400);
-	do {
-		if (!skb)
-			break;
-
+	if (skb) {
 		skb_reserve(skb, local->hw.extra_tx_headroom);
 
 		mgmt = (struct ieee80211_mgmt *)
 			skb_put(skb, 24 + sizeof(mgmt->u.beacon));
 		memset(mgmt, 0, 24 + sizeof(mgmt->u.beacon));
 		mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
-						   IEEE80211_STYPE_BEACON);
+						   IEEE80211_STYPE_PROBE_RESP);
 		memset(mgmt->da, 0xff, ETH_ALEN);
 		memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
 		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
@@ -2492,61 +2487,22 @@ static int ieee80211_sta_join_ibss(struc
 			memcpy(pos, &bss->supp_rates[8], rates);
 		}
 
-		control = IEEE80211_SKB_CB(skb);
-
-		rate_control_get_rate(dev, sband, skb, &ratesel);
-		if (ratesel.rate_idx < 0) {
-			printk(KERN_DEBUG "%s: Failed to determine TX rate "
-			       "for IBSS beacon\n", dev->name);
-			break;
-		}
-		control->control.vif = &sdata->vif;
-		control->tx_rate_idx = ratesel.rate_idx;
-		if (sdata->bss_conf.use_short_preamble &&
-		    sband->bitrates[ratesel.rate_idx].flags & IEEE80211_RATE_SHORT_PREAMBLE)
-			control->flags |= IEEE80211_TX_CTL_SHORT_PREAMBLE;
-		control->antenna_sel_tx = local->hw.conf.antenna_sel_tx;
-		control->flags |= IEEE80211_TX_CTL_NO_ACK;
-		control->flags |= IEEE80211_TX_CTL_DO_NOT_ENCRYPT;
-		control->control.retry_limit = 1;
-
-		ifsta->probe_resp = skb_copy(skb, GFP_ATOMIC);
-		if (ifsta->probe_resp) {
-			mgmt = (struct ieee80211_mgmt *)
-				ifsta->probe_resp->data;
-			mgmt->frame_control =
-				IEEE80211_FC(IEEE80211_FTYPE_MGMT,
-					     IEEE80211_STYPE_PROBE_RESP);
-		} else {
-			printk(KERN_DEBUG "%s: Could not allocate ProbeResp "
-			       "template for IBSS\n", dev->name);
-		}
-
-		if (local->ops->beacon_update &&
-		    local->ops->beacon_update(local_to_hw(local), skb) == 0) {
-			printk(KERN_DEBUG "%s: Configured IBSS beacon "
-			       "template\n", dev->name);
-			skb = NULL;
-		}
+		ifsta->probe_resp = skb;
 
-		rates = 0;
-		sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-		for (i = 0; i < bss->supp_rates_len; i++) {
-			int bitrate = (bss->supp_rates[i] & 0x7f) * 5;
-			for (j = 0; j < sband->n_bitrates; j++)
-				if (sband->bitrates[j].bitrate == bitrate)
-					rates |= BIT(j);
-		}
-		ifsta->supp_rates_bits[local->hw.conf.channel->band] = rates;
-
-		ieee80211_sta_def_wmm_params(dev, bss, 1);
-	} while (0);
+		ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON);
+	}
 
-	if (skb) {
-		printk(KERN_DEBUG "%s: Failed to configure IBSS beacon "
-		       "template\n", dev->name);
-		dev_kfree_skb(skb);
+	rates = 0;
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+	for (i = 0; i < bss->supp_rates_len; i++) {
+		int bitrate = (bss->supp_rates[i] & 0x7f) * 5;
+		for (j = 0; j < sband->n_bitrates; j++)
+			if (sband->bitrates[j].bitrate == bitrate)
+				rates |= BIT(j);
 	}
+	ifsta->supp_rates_bits[local->hw.conf.channel->band] = rates;
+
+	ieee80211_sta_def_wmm_params(dev, bss, 1);
 
 	ifsta->state = IEEE80211_IBSS_JOINED;
 	mod_timer(&ifsta->timer, jiffies + IEEE80211_IBSS_MERGE_INTERVAL);
@@ -3330,7 +3286,7 @@ static void ieee80211_mesh_housekeeping(
 
 	free_plinks = mesh_plink_availables(sdata);
 	if (free_plinks != sdata->u.sta.accepting_plinks)
-		ieee80211_if_config_beacon(dev);
+		ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON);
 
 	mod_timer(&ifsta->timer, jiffies +
 			IEEE80211_MESH_HOUSEKEEPING_INTERVAL);
@@ -3752,28 +3708,45 @@ int ieee80211_sta_set_ssid(struct net_de
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_if_sta *ifsta;
+	int res;
 
 	if (len > IEEE80211_MAX_SSID_LEN)
 		return -EINVAL;
 
 	ifsta = &sdata->u.sta;
 
-	if (ifsta->ssid_len != len || memcmp(ifsta->ssid, ssid, len) != 0)
+	if (ifsta->ssid_len != len || memcmp(ifsta->ssid, ssid, len) != 0) {
+		memset(ifsta->ssid, 0, sizeof(ifsta->ssid));
+		memcpy(ifsta->ssid, ssid, len);
+		ifsta->ssid_len = len;
 		ifsta->flags &= ~IEEE80211_STA_PREV_BSSID_SET;
-	memcpy(ifsta->ssid, ssid, len);
-	memset(ifsta->ssid + len, 0, IEEE80211_MAX_SSID_LEN - len);
-	ifsta->ssid_len = len;
+
+		res = 0;
+		/*
+		 * Hack! MLME code needs to be cleaned up to have different
+		 * entry points for configuration and internal selection change
+		 */
+		if (netif_running(sdata->dev))
+			res = ieee80211_if_config(sdata, IEEE80211_IFCC_SSID);
+		if (res) {
+			printk(KERN_DEBUG "%s: Failed to config new SSID to "
+			       "the low-level driver\n", dev->name);
+			return res;
+		}
+	}
 
 	if (len)
 		ifsta->flags |= IEEE80211_STA_SSID_SET;
 	else
 		ifsta->flags &= ~IEEE80211_STA_SSID_SET;
+
 	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS &&
 	    !(ifsta->flags & IEEE80211_STA_BSSID_SET)) {
 		ifsta->ibss_join_req = jiffies;
 		ifsta->state = IEEE80211_IBSS_SEARCH;
 		return ieee80211_sta_find_ibss(dev, ifsta);
 	}
+
 	return 0;
 }
 
@@ -3799,7 +3772,12 @@ int ieee80211_sta_set_bssid(struct net_d
 
 	if (memcmp(ifsta->bssid, bssid, ETH_ALEN) != 0) {
 		memcpy(ifsta->bssid, bssid, ETH_ALEN);
-		res = ieee80211_if_config(dev);
+		res = 0;
+		/*
+		 * Hack! See also ieee80211_sta_set_ssid.
+		 */
+		if (netif_running(sdata->dev))
+			res = ieee80211_if_config(sdata, IEEE80211_IFCC_BSSID);
 		if (res) {
 			printk(KERN_DEBUG "%s: Failed to config new BSSID to "
 			       "the low-level driver\n", dev->name);
--- everything.orig/net/mac80211/wext.c	2008-07-05 23:33:18.000000000 +0200
+++ everything/net/mac80211/wext.c	2008-07-05 23:33:20.000000000 +0200
@@ -444,7 +444,7 @@ static int ieee80211_ioctl_siwessid(stru
 		memset(sdata->u.ap.ssid + len, 0,
 		       IEEE80211_MAX_SSID_LEN - len);
 		sdata->u.ap.ssid_len = len;
-		return ieee80211_if_config(dev);
+		return ieee80211_if_config(sdata, IEEE80211_IFCC_SSID);
 	}
 	return -EOPNOTSUPP;
 }
--- everything.orig/drivers/net/wireless/b43/main.c	2008-07-05 23:32:57.000000000 +0200
+++ everything/drivers/net/wireless/b43/main.c	2008-07-05 23:33:20.000000000 +0200
@@ -1675,14 +1675,24 @@ static void b43_beacon_update_trigger_wo
 
 /* Asynchronously update the packet templates in template RAM.
  * Locking: Requires wl->irq_lock to be locked. */
-static void b43_update_templates(struct b43_wl *wl, struct sk_buff *beacon)
+static void b43_update_templates(struct b43_wl *wl)
 {
+	struct sk_buff *beacon;
+
 	/* This is the top half of the ansynchronous beacon update.
 	 * The bottom half is the beacon IRQ.
 	 * Beacon update must be asynchronous to avoid sending an
 	 * invalid beacon. This can happen for example, if the firmware
 	 * transmits a beacon while we are updating it. */
 
+	/* We could modify the existing beacon and set the aid bit in
+	 * the TIM field, but that would probably require resizing and
+	 * moving of data within the beacon template.
+	 * Simply request a new beacon and let mac80211 do the hard work. */
+	beacon = ieee80211_beacon_get(wl->hw, wl->vif);
+	if (unlikely(!beacon))
+		return;
+
 	if (wl->current_beacon)
 		dev_kfree_skb_any(wl->current_beacon);
 	wl->current_beacon = beacon;
@@ -3645,10 +3655,14 @@ static int b43_op_config_interface(struc
 	if (b43_status(dev) >= B43_STAT_INITIALIZED) {
 		if (b43_is_mode(wl, IEEE80211_IF_TYPE_AP) ||
 		    b43_is_mode(wl, IEEE80211_IF_TYPE_MESH_POINT)) {
-			B43_WARN_ON(conf->type != wl->if_type);
-			b43_set_ssid(dev, conf->ssid, conf->ssid_len);
-			if (conf->beacon)
-				b43_update_templates(wl, conf->beacon);
+			B43_WARN_ON(vif->type != wl->if_type);
+			if (conf->changed & IEEE80211_IFCC_SSID)
+				b43_set_ssid(dev, conf->ssid, conf->ssid_len);
+			if (conf->changed & IEEE80211_IFCC_BEACON)
+				b43_update_templates(wl);
+		} else if (b43_is_mode(wl, IEEE80211_IF_TYPE_IBSS)) {
+			if (conf->changed & IEEE80211_IFCC_BEACON)
+				b43_update_templates(wl);
 		}
 		b43_write_mac_bssid_templates(dev);
 	}
@@ -4336,31 +4350,10 @@ out_unlock:
 static int b43_op_beacon_set_tim(struct ieee80211_hw *hw, int aid, int set)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
-	struct sk_buff *beacon;
-	unsigned long flags;
-
-	/* We could modify the existing beacon and set the aid bit in
-	 * the TIM field, but that would probably require resizing and
-	 * moving of data within the beacon template.
-	 * Simply request a new beacon and let mac80211 do the hard work. */
-	beacon = ieee80211_beacon_get(hw, wl->vif);
-	if (unlikely(!beacon))
-		return -ENOMEM;
-	spin_lock_irqsave(&wl->irq_lock, flags);
-	b43_update_templates(wl, beacon);
-	spin_unlock_irqrestore(&wl->irq_lock, flags);
-
-	return 0;
-}
-
-static int b43_op_ibss_beacon_update(struct ieee80211_hw *hw,
-				     struct sk_buff *beacon)
-{
-	struct b43_wl *wl = hw_to_b43_wl(hw);
 	unsigned long flags;
 
 	spin_lock_irqsave(&wl->irq_lock, flags);
-	b43_update_templates(wl, beacon);
+	b43_update_templates(wl);
 	spin_unlock_irqrestore(&wl->irq_lock, flags);
 
 	return 0;
@@ -4391,7 +4384,6 @@ static const struct ieee80211_ops b43_hw
 	.stop			= b43_op_stop,
 	.set_retry_limit	= b43_op_set_retry_limit,
 	.set_tim		= b43_op_beacon_set_tim,
-	.beacon_update		= b43_op_ibss_beacon_update,
 	.sta_notify		= b43_op_sta_notify,
 };
 
--- everything.orig/drivers/net/wireless/ath5k/base.c	2008-07-05 23:32:57.000000000 +0200
+++ everything/drivers/net/wireless/ath5k/base.c	2008-07-05 23:33:20.000000000 +0200
@@ -207,7 +207,6 @@ static struct ieee80211_ops ath5k_hw_ops
 	.get_tx_stats 	= ath5k_get_tx_stats,
 	.get_tsf 	= ath5k_get_tsf,
 	.reset_tsf 	= ath5k_reset_tsf,
-	.beacon_update 	= ath5k_beacon_update,
 };
 
 /*
@@ -2785,6 +2784,18 @@ ath5k_config_interface(struct ieee80211_
 		 * a clean way of letting us retrieve this yet. */
 		ath5k_hw_set_associd(ah, ah->ah_bssid, 0);
 	}
+
+	if (conf->changed & IEEE80211_IFCC_BEACON &&
+	    vif->type == IEEE80211_IF_TYPE_IBSS) {
+		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
+		if (!beacon) {
+			ret = -ENOMEM;
+			goto unlock;
+		}
+		/* call old handler for now */
+		ath5k_beacon_update(hw, beacon);
+	}
+
 	mutex_unlock(&sc->lock);
 
 	return ath5k_reset(hw);
--- everything.orig/drivers/net/wireless/b43legacy/main.c	2008-07-05 23:32:57.000000000 +0200
+++ everything/drivers/net/wireless/b43legacy/main.c	2008-07-05 23:33:20.000000000 +0200
@@ -1138,14 +1138,22 @@ static void b43legacy_write_probe_resp_t
 
 /* Asynchronously update the packet templates in template RAM.
  * Locking: Requires wl->irq_lock to be locked. */
-static void b43legacy_update_templates(struct b43legacy_wl *wl,
-				       struct sk_buff *beacon)
+static void b43legacy_update_templates(struct b43legacy_wl *wl)
 {
+	struct sk_buff *beacon;
 	/* This is the top half of the ansynchronous beacon update. The bottom
 	 * half is the beacon IRQ. Beacon update must be asynchronous to avoid
 	 * sending an invalid beacon. This can happen for example, if the
 	 * firmware transmits a beacon while we are updating it. */
 
+	/* We could modify the existing beacon and set the aid bit in the TIM
+	 * field, but that would probably require resizing and moving of data
+	 * within the beacon template. Simply request a new beacon and let
+	 * mac80211 do the hard work. */
+	beacon = ieee80211_beacon_get(wl->hw, wl->vif);
+	if (unlikely(!beacon))
+		return;
+
 	if (wl->current_beacon)
 		dev_kfree_skb_any(wl->current_beacon);
 	wl->current_beacon = beacon;
@@ -2727,10 +2735,13 @@ static int b43legacy_op_config_interface
 		memset(wl->bssid, 0, ETH_ALEN);
 	if (b43legacy_status(dev) >= B43legacy_STAT_INITIALIZED) {
 		if (b43legacy_is_mode(wl, IEEE80211_IF_TYPE_AP)) {
-			B43legacy_WARN_ON(conf->type != IEEE80211_IF_TYPE_AP);
+			B43legacy_WARN_ON(vif->type != IEEE80211_IF_TYPE_AP);
 			b43legacy_set_ssid(dev, conf->ssid, conf->ssid_len);
-			if (conf->beacon)
-				b43legacy_update_templates(wl, conf->beacon);
+			if (conf->changed & IEEE80211_IFCC_BEACON)
+				b43legacy_update_templates(wl);
+		} else if (b43legacy_is_mode(wl, IEEE80211_IF_TYPE_IBSS)) {
+			if (conf->changed & IEEE80211_IFCC_BEACON)
+				b43legacy_update_templates(wl);
 		}
 		b43legacy_write_mac_bssid_templates(dev);
 	}
@@ -3396,31 +3407,10 @@ static int b43legacy_op_beacon_set_tim(s
 				       int aid, int set)
 {
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
-	struct sk_buff *beacon;
-	unsigned long flags;
-
-	/* We could modify the existing beacon and set the aid bit in the TIM
-	 * field, but that would probably require resizing and moving of data
-	 * within the beacon template. Simply request a new beacon and let
-	 * mac80211 do the hard work. */
-	beacon = ieee80211_beacon_get(hw, wl->vif);
-	if (unlikely(!beacon))
-		return -ENOMEM;
-	spin_lock_irqsave(&wl->irq_lock, flags);
-	b43legacy_update_templates(wl, beacon);
-	spin_unlock_irqrestore(&wl->irq_lock, flags);
-
-	return 0;
-}
-
-static int b43legacy_op_ibss_beacon_update(struct ieee80211_hw *hw,
-					   struct sk_buff *beacon)
-{
-	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
 	unsigned long flags;
 
 	spin_lock_irqsave(&wl->irq_lock, flags);
-	b43legacy_update_templates(wl, beacon);
+	b43legacy_update_templates(wl);
 	spin_unlock_irqrestore(&wl->irq_lock, flags);
 
 	return 0;
@@ -3440,7 +3430,6 @@ static const struct ieee80211_ops b43leg
 	.stop			= b43legacy_op_stop,
 	.set_retry_limit	= b43legacy_op_set_retry_limit,
 	.set_tim		= b43legacy_op_beacon_set_tim,
-	.beacon_update		= b43legacy_op_ibss_beacon_update,
 };
 
 /* Hard-reset the chip. Do not call this directly.
--- everything.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-07-05 23:32:56.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-07-05 23:33:20.000000000 +0200
@@ -6889,6 +6889,9 @@ static void iwl3945_config_ap(struct iwl
 	 * clear sta table, add BCAST sta... */
 }
 
+/* temporary */
+static int iwl3945_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb);
+
 static int iwl3945_mac_config_interface(struct ieee80211_hw *hw,
 					struct ieee80211_vif *vif,
 				    struct ieee80211_if_conf *conf)
@@ -6906,10 +6909,21 @@ static int iwl3945_mac_config_interface(
 		return 0;
 	}
 
+	/* handle this temporarily here */
+	if (priv->iw_mode == IEEE80211_IF_TYPE_IBSS &&
+	    conf->changed & IEEE80211_IFCC_BEACON) {
+		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
+		if (!beacon)
+			return -ENOMEM;
+		rc = iwl3945_mac_beacon_update(hw, beacon);
+		if (rc)
+			return rc;
+	}
+
 	/* XXX: this MUST use conf->mac_addr */
 
 	if ((priv->iw_mode == IEEE80211_IF_TYPE_AP) &&
-	    (!conf->beacon || !conf->ssid_len)) {
+	    (!conf->ssid_len)) {
 		IWL_DEBUG_MAC80211
 		    ("Leaving in AP mode because HostAPD is not ready.\n");
 		return 0;
@@ -6941,7 +6955,7 @@ static int iwl3945_mac_config_interface(
 		if (priv->ibss_beacon)
 			dev_kfree_skb(priv->ibss_beacon);
 
-		priv->ibss_beacon = conf->beacon;
+		priv->ibss_beacon = ieee80211_beacon_get(hw, vif);
 	}
 
 	if (iwl3945_is_rfkill(priv))
@@ -7922,7 +7936,6 @@ static struct ieee80211_ops iwl3945_hw_o
 	.conf_tx = iwl3945_mac_conf_tx,
 	.get_tsf = iwl3945_mac_get_tsf,
 	.reset_tsf = iwl3945_mac_reset_tsf,
-	.beacon_update = iwl3945_mac_beacon_update,
 	.hw_scan = iwl3945_mac_hw_scan
 };
 
--- everything.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-07-05 23:32:56.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-07-05 23:33:20.000000000 +0200
@@ -2912,6 +2912,9 @@ static void iwl4965_config_ap(struct iwl
 	 * clear sta table, add BCAST sta... */
 }
 
+/* temporary */
+static int iwl4965_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb);
+
 static int iwl4965_mac_config_interface(struct ieee80211_hw *hw,
 					struct ieee80211_vif *vif,
 				    struct ieee80211_if_conf *conf)
@@ -2929,8 +2932,18 @@ static int iwl4965_mac_config_interface(
 		return 0;
 	}
 
+	if (priv->iw_mode == IEEE80211_IF_TYPE_IBSS &&
+	    conf->changed & IEEE80211_IFCC_BEACON) {
+		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
+		if (!beacon)
+			return -ENOMEM;
+		rc = iwl4965_mac_beacon_update(hw, beacon);
+		if (rc)
+			return rc;
+	}
+
 	if ((priv->iw_mode == IEEE80211_IF_TYPE_AP) &&
-	    (!conf->beacon || !conf->ssid_len)) {
+	    (!conf->ssid_len)) {
 		IWL_DEBUG_MAC80211
 		    ("Leaving in AP mode because HostAPD is not ready.\n");
 		return 0;
@@ -2962,7 +2975,7 @@ static int iwl4965_mac_config_interface(
 		if (priv->ibss_beacon)
 			dev_kfree_skb(priv->ibss_beacon);
 
-		priv->ibss_beacon = conf->beacon;
+		priv->ibss_beacon = ieee80211_beacon_get(hw, vif);
 	}
 
 	if (iwl_is_rfkill(priv))
@@ -4090,7 +4103,6 @@ static struct ieee80211_ops iwl4965_hw_o
 	.get_tx_stats = iwl4965_mac_get_tx_stats,
 	.conf_tx = iwl4965_mac_conf_tx,
 	.reset_tsf = iwl4965_mac_reset_tsf,
-	.beacon_update = iwl4965_mac_beacon_update,
 	.bss_info_changed = iwl4965_bss_info_changed,
 	.ampdu_action = iwl4965_mac_ampdu_action,
 	.hw_scan = iwl4965_mac_hw_scan
--- everything.orig/drivers/net/wireless/rt2x00/rt2400pci.c	2008-07-05 23:32:57.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2400pci.c	2008-07-05 23:33:20.000000000 +0200
@@ -1558,7 +1558,6 @@ static const struct ieee80211_ops rt2400
 	.conf_tx		= rt2400pci_conf_tx,
 	.get_tx_stats		= rt2x00mac_get_tx_stats,
 	.get_tsf		= rt2400pci_get_tsf,
-	.beacon_update		= rt2400pci_beacon_update,
 	.tx_last_beacon		= rt2400pci_tx_last_beacon,
 };
 
@@ -1578,6 +1577,7 @@ static const struct rt2x00lib_ops rt2400
 	.write_tx_data		= rt2x00pci_write_tx_data,
 	.kick_tx_queue		= rt2400pci_kick_tx_queue,
 	.fill_rxdone		= rt2400pci_fill_rxdone,
+	.beacon_update		= rt2400pci_beacon_update,
 	.config_filter		= rt2400pci_config_filter,
 	.config_intf		= rt2400pci_config_intf,
 	.config_erp		= rt2400pci_config_erp,
--- everything.orig/drivers/net/wireless/rt2x00/rt2500pci.c	2008-07-05 23:32:57.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2500pci.c	2008-07-05 23:33:20.000000000 +0200
@@ -1875,7 +1875,6 @@ static const struct ieee80211_ops rt2500
 	.conf_tx		= rt2x00mac_conf_tx,
 	.get_tx_stats		= rt2x00mac_get_tx_stats,
 	.get_tsf		= rt2500pci_get_tsf,
-	.beacon_update		= rt2500pci_beacon_update,
 	.tx_last_beacon		= rt2500pci_tx_last_beacon,
 };
 
@@ -1895,6 +1894,7 @@ static const struct rt2x00lib_ops rt2500
 	.write_tx_data		= rt2x00pci_write_tx_data,
 	.kick_tx_queue		= rt2500pci_kick_tx_queue,
 	.fill_rxdone		= rt2500pci_fill_rxdone,
+	.beacon_update		= rt2500pci_beacon_update,
 	.config_filter		= rt2500pci_config_filter,
 	.config_intf		= rt2500pci_config_intf,
 	.config_erp		= rt2500pci_config_erp,
--- everything.orig/drivers/net/wireless/rt2x00/rt2500usb.c	2008-07-05 23:32:57.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2500usb.c	2008-07-05 23:33:20.000000000 +0200
@@ -1775,7 +1775,6 @@ static const struct ieee80211_ops rt2500
 	.bss_info_changed	= rt2x00mac_bss_info_changed,
 	.conf_tx		= rt2x00mac_conf_tx,
 	.get_tx_stats		= rt2x00mac_get_tx_stats,
-	.beacon_update		= rt2500usb_beacon_update,
 };
 
 static const struct rt2x00lib_ops rt2500usb_rt2x00_ops = {
@@ -1793,6 +1792,7 @@ static const struct rt2x00lib_ops rt2500
 	.get_tx_data_len	= rt2500usb_get_tx_data_len,
 	.kick_tx_queue		= rt2500usb_kick_tx_queue,
 	.fill_rxdone		= rt2500usb_fill_rxdone,
+	.beacon_update		= rt2500usb_beacon_update,
 	.config_filter		= rt2500usb_config_filter,
 	.config_intf		= rt2500usb_config_intf,
 	.config_erp		= rt2500usb_config_erp,
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00.h	2008-07-05 23:32:57.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2x00.h	2008-07-05 23:33:20.000000000 +0200
@@ -534,6 +534,8 @@ struct rt2x00lib_ops {
 	/*
 	 * Configuration handlers.
 	 */
+	int (*beacon_update) (struct ieee80211_hw *hw, struct sk_buff *bcn);
+
 	void (*config_filter) (struct rt2x00_dev *rt2x00dev,
 			       const unsigned int filter_flags);
 	void (*config_intf) (struct rt2x00_dev *rt2x00dev,
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00dev.c	2008-07-05 23:32:57.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2x00dev.c	2008-07-05 23:33:20.000000000 +0200
@@ -409,7 +409,6 @@ static void rt2x00lib_intf_scheduled_ite
 {
 	struct rt2x00_dev *rt2x00dev = data;
 	struct rt2x00_intf *intf = vif_to_intf(vif);
-	struct sk_buff *skb;
 	struct ieee80211_bss_conf conf;
 	int delayed_flags;
 
@@ -436,10 +435,11 @@ static void rt2x00lib_intf_scheduled_ite
 		return;
 
 	if (delayed_flags & DELAYED_UPDATE_BEACON) {
-		skb = ieee80211_beacon_get(rt2x00dev->hw, vif);
-		if (skb &&
-		    rt2x00dev->ops->hw->beacon_update(rt2x00dev->hw, skb))
-			dev_kfree_skb(skb);
+		struct ieee80211_if_conf conf;
+		conf.bssid = conf.ssid = NULL;
+		conf.ssid_len = 0;
+		conf.changed = IEEE80211_IFCC_BEACON;
+		rt2x00dev->ops->hw->config_interface(rt2x00dev->hw, vif, &conf);
 	}
 
 	if (delayed_flags & DELAYED_CONFIG_ERP)
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00mac.c	2008-07-05 23:32:57.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2x00mac.c	2008-07-05 23:33:20.000000000 +0200
@@ -348,6 +348,7 @@ int rt2x00mac_config_interface(struct ie
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct rt2x00_intf *intf = vif_to_intf(vif);
+	struct sk_buff *beacon;
 	int status;
 
 	/*
@@ -363,8 +364,11 @@ int rt2x00mac_config_interface(struct ie
 	 * If the interface does not work in master mode,
 	 * then the bssid value in the interface structure
 	 * should now be set.
+	 *
+	 * conf->bssid can be NULL if coming from the internal
+	 * beacon update routine.
 	 */
-	if (conf->type != IEEE80211_IF_TYPE_AP)
+	if (conf->bssid && vif->type != IEEE80211_IF_TYPE_AP)
 		memcpy(&intf->bssid, conf->bssid, ETH_ALEN);
 
 	spin_unlock(&intf->lock);
@@ -375,17 +379,23 @@ int rt2x00mac_config_interface(struct ie
 	 * values as arguments we make keep access to rt2x00_intf thread safe
 	 * even without the lock.
 	 */
-	rt2x00lib_config_intf(rt2x00dev, intf, conf->type, NULL, conf->bssid);
+	rt2x00lib_config_intf(rt2x00dev, intf, vif->type, NULL, conf->bssid);
 
 	/*
-	 * We only need to initialize the beacon when master mode is enabled.
+	 * We only need to initialize the beacon when in master/ibss mode.
 	 */
-	if (conf->type != IEEE80211_IF_TYPE_AP || !conf->beacon)
+	if ((vif->type != IEEE80211_IF_TYPE_AP &&
+	     vif->type != IEEE80211_IF_TYPE_IBSS) ||
+	    !(conf->changed & IEEE80211_IFCC_BEACON))
 		return 0;
 
-	status = rt2x00dev->ops->hw->beacon_update(rt2x00dev->hw, conf->beacon);
+	beacon = ieee80211_beacon_get(rt2x00dev->hw, vif);
+	if (!beacon)
+		return -ENOMEM;
+
+	status = rt2x00dev->ops->lib->beacon_update(rt2x00dev->hw, beacon);
 	if (status)
-		dev_kfree_skb(conf->beacon);
+		dev_kfree_skb(beacon);
 
 	return status;
 }
--- everything.orig/drivers/net/wireless/rt2x00/rt61pci.c	2008-07-05 23:32:57.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt61pci.c	2008-07-05 23:33:20.000000000 +0200
@@ -2427,7 +2427,6 @@ static const struct ieee80211_ops rt61pc
 	.conf_tx		= rt2x00mac_conf_tx,
 	.get_tx_stats		= rt2x00mac_get_tx_stats,
 	.get_tsf		= rt61pci_get_tsf,
-	.beacon_update		= rt61pci_beacon_update,
 };
 
 static const struct rt2x00lib_ops rt61pci_rt2x00_ops = {
@@ -2449,6 +2448,7 @@ static const struct rt2x00lib_ops rt61pc
 	.write_tx_data		= rt2x00pci_write_tx_data,
 	.kick_tx_queue		= rt61pci_kick_tx_queue,
 	.fill_rxdone		= rt61pci_fill_rxdone,
+	.beacon_update		= rt61pci_beacon_update,
 	.config_filter		= rt61pci_config_filter,
 	.config_intf		= rt61pci_config_intf,
 	.config_erp		= rt61pci_config_erp,
--- everything.orig/drivers/net/wireless/rt2x00/rt73usb.c	2008-07-05 23:32:57.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt73usb.c	2008-07-05 23:33:20.000000000 +0200
@@ -2031,7 +2031,6 @@ static const struct ieee80211_ops rt73us
 	.conf_tx		= rt2x00mac_conf_tx,
 	.get_tx_stats		= rt2x00mac_get_tx_stats,
 	.get_tsf		= rt73usb_get_tsf,
-	.beacon_update		= rt73usb_beacon_update,
 };
 
 static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
@@ -2052,6 +2051,7 @@ static const struct rt2x00lib_ops rt73us
 	.get_tx_data_len	= rt73usb_get_tx_data_len,
 	.kick_tx_queue		= rt73usb_kick_tx_queue,
 	.fill_rxdone		= rt73usb_fill_rxdone,
+	.beacon_update		= rt73usb_beacon_update,
 	.config_filter		= rt73usb_config_filter,
 	.config_intf		= rt73usb_config_intf,
 	.config_erp		= rt73usb_config_erp,
--- everything.orig/drivers/net/wireless/zd1211rw/zd_mac.c	2008-07-05 23:32:57.000000000 +0200
+++ everything/drivers/net/wireless/zd1211rw/zd_mac.c	2008-07-05 23:33:20.000000000 +0200
@@ -703,9 +703,12 @@ static int zd_op_config_interface(struct
 	if (mac->type == IEEE80211_IF_TYPE_MESH_POINT ||
 	    mac->type == IEEE80211_IF_TYPE_IBSS) {
 		associated = true;
-		if (conf->beacon) {
-			zd_mac_config_beacon(hw, conf->beacon);
-			kfree_skb(conf->beacon);
+		if (conf->changed & IEEE80211_IFCC_BEACON) {
+			struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
+			if (!beacon)
+				return -ENOMEM;
+			zd_mac_config_beacon(hw, beacon);
+			kfree_skb(beacon);
 			zd_set_beacon_interval(&mac->chip, BCN_MODE_IBSS |
 					hw->conf.beacon_int);
 		}
@@ -861,17 +864,6 @@ static void zd_op_bss_info_changed(struc
 	}
 }
 
-static int zd_op_beacon_update(struct ieee80211_hw *hw,
-			       struct sk_buff *skb)
-{
-	struct zd_mac *mac = zd_hw_mac(hw);
-	zd_mac_config_beacon(hw, skb);
-	kfree_skb(skb);
-	zd_set_beacon_interval(&mac->chip, BCN_MODE_IBSS |
-					hw->conf.beacon_int);
-	return 0;
-}
-
 static const struct ieee80211_ops zd_ops = {
 	.tx			= zd_op_tx,
 	.start			= zd_op_start,
@@ -882,7 +874,6 @@ static const struct ieee80211_ops zd_ops
 	.config_interface	= zd_op_config_interface,
 	.configure_filter	= zd_op_configure_filter,
 	.bss_info_changed	= zd_op_bss_info_changed,
-	.beacon_update		= zd_op_beacon_update,
 };
 
 struct ieee80211_hw *zd_mac_alloc_hw(struct usb_interface *intf)
--- everything.orig/net/mac80211/tx.c	2008-07-05 23:33:10.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-07-05 23:33:20.000000000 +0200
@@ -1795,17 +1795,17 @@ struct sk_buff *ieee80211_beacon_get(str
 				     struct ieee80211_vif *vif)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	struct sk_buff *skb;
+	struct sk_buff *skb = NULL;
 	struct ieee80211_tx_info *info;
 	struct net_device *bdev;
 	struct ieee80211_sub_if_data *sdata = NULL;
 	struct ieee80211_if_ap *ap = NULL;
+	struct ieee80211_if_sta *ifsta = NULL;
 	struct rate_selection rsel;
 	struct beacon_data *beacon;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_mgmt *mgmt;
 	int *num_beacons;
-	bool err = true;
 	enum ieee80211_band band = local->hw.conf.channel->band;
 	u8 *pos;
 
@@ -1859,9 +1859,24 @@ struct sk_buff *ieee80211_beacon_get(str
 				       beacon->tail, beacon->tail_len);
 
 			num_beacons = &ap->num_beacons;
+		} else
+			goto out;
+	} else if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
+		struct ieee80211_hdr *hdr;
+		ifsta = &sdata->u.sta;
 
-			err = false;
-		}
+		if (!ifsta->probe_resp)
+			goto out;
+
+		skb = skb_copy(ifsta->probe_resp, GFP_ATOMIC);
+		if (!skb)
+			goto out;
+
+		hdr = (struct ieee80211_hdr *) skb->data;
+		hdr->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
+						  IEEE80211_STYPE_BEACON);
+
+		num_beacons = &ifsta->num_beacons;
 	} else if (ieee80211_vif_is_mesh(&sdata->vif)) {
 		/* headroom, head length, tail length and maximum TIM length */
 		skb = dev_alloc_skb(local->tx_headroom + 400);
@@ -1888,17 +1903,8 @@ struct sk_buff *ieee80211_beacon_get(str
 		mesh_mgmt_ies_add(skb, sdata->dev);
 
 		num_beacons = &sdata->u.sta.num_beacons;
-
-		err = false;
-	}
-
-	if (err) {
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-		if (net_ratelimit())
-			printk(KERN_DEBUG "no beacon data avail for %s\n",
-			       bdev->name);
-#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
-		skb = NULL;
+	} else {
+		WARN_ON(1);
 		goto out;
 	}
 

-- 

