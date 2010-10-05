Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36250 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab0JERjb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 13:39:31 -0400
Subject: [PATCH] cfg80211/mac80211: allow per-station GTKs
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 19:39:30 +0200
Message-ID: <1286300370.3641.17.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This adds API to allow adding per-station GTKs,
updates mac80211 to support it, and also allows
drivers to remove a key from hwaccel again when
this may be necessary due to multiple GTKs.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Never really got feedback on this, but I think it's ok...

 drivers/net/wireless/iwmc3200wifi/cfg80211.c |    7 +
 drivers/net/wireless/libertas/cfg.c          |    4 -
 drivers/net/wireless/rndis_wlan.c            |   12 +--
 include/linux/nl80211.h                      |   12 +++
 include/net/cfg80211.h                       |    9 +-
 include/net/mac80211.h                       |   24 ++++++
 net/mac80211/cfg.c                           |   32 ++++++---
 net/mac80211/ieee80211_i.h                   |    2 
 net/mac80211/key.c                           |   95 +++++++++++++++++----------
 net/mac80211/key.h                           |    3 
 net/mac80211/rx.c                            |   43 +++++++-----
 net/mac80211/sta_info.c                      |   10 +-
 net/mac80211/sta_info.h                      |    6 +
 net/mac80211/tx.c                            |    2 
 net/wireless/core.h                          |    2 
 net/wireless/ibss.c                          |    2 
 net/wireless/nl80211.c                       |   87 ++++++++++++++++++++++--
 net/wireless/sme.c                           |    2 
 net/wireless/util.c                          |   12 ++-
 net/wireless/wext-compat.c                   |   38 +++++++---
 20 files changed, 294 insertions(+), 110 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2010-10-05 19:33:49.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2010-10-05 19:38:24.000000000 +0200
@@ -1041,6 +1041,13 @@ enum ieee80211_tkip_key_type {
  * @IEEE80211_HW_NEED_DTIM_PERIOD:
  *	This device needs to know the DTIM period for the BSS before
  *	associating.
+ *
+ * @IEEE80211_HW_SUPPORTS_PER_STA_GTK: The device's crypto engine supports
+ *	per-station GTKs as used by IBSS RSN or during fast transition. If
+ *	the device doesn't support per-station GTKs, but can be asked not
+ *	to decrypt group addressed frames, then IBSS RSN support is still
+ *	possible but software crypto will be used. Advertise the wiphy flag
+ *	only in that case.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -1064,6 +1071,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_REPORTS_TX_ACK_STATUS		= 1<<18,
 	IEEE80211_HW_CONNECTION_MONITOR			= 1<<19,
 	IEEE80211_HW_SUPPORTS_CQM_RSSI			= 1<<20,
+	IEEE80211_HW_SUPPORTS_PER_STA_GTK		= 1<<21,
 };
 
 /**
@@ -2578,6 +2586,22 @@ void ieee80211_chswitch_done(struct ieee
 void ieee80211_request_smps(struct ieee80211_vif *vif,
 			    enum ieee80211_smps_mode smps_mode);
 
+/**
+ * ieee80211_key_removed - disable hw acceleration for key
+ * @key_conf: The key hw acceleration should be disabled for
+ *
+ * This allows drivers to indicate that the given key has been
+ * removed from hardware acceleration, due to a new key that
+ * was added. Don't use this if the key can continue to be used
+ * for TX, if the key restriction is on RX only it is permitted
+ * to keep the key for TX only and not call this function.
+ *
+ * Due to locking constraints, it may only be called during
+ * @set_key. This function must be allowed to sleep, and the
+ * key it tries to disable may still be used until it returns.
+ */
+void ieee80211_key_removed(struct ieee80211_key_conf *key_conf);
+
 /* Rate control API */
 
 /**
--- wireless-testing.orig/include/net/cfg80211.h	2010-10-05 19:38:23.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2010-10-05 19:38:24.000000000 +0200
@@ -1128,13 +1128,14 @@ struct cfg80211_ops {
 				       struct vif_params *params);
 
 	int	(*add_key)(struct wiphy *wiphy, struct net_device *netdev,
-			   u8 key_index, const u8 *mac_addr,
+			   u8 key_index, bool pairwise, const u8 *mac_addr,
 			   struct key_params *params);
 	int	(*get_key)(struct wiphy *wiphy, struct net_device *netdev,
-			   u8 key_index, const u8 *mac_addr, void *cookie,
+			   u8 key_index, bool pairwise, const u8 *mac_addr,
+			   void *cookie,
 			   void (*callback)(void *cookie, struct key_params*));
 	int	(*del_key)(struct wiphy *wiphy, struct net_device *netdev,
-			   u8 key_index, const u8 *mac_addr);
+			   u8 key_index, bool pairwise, const u8 *mac_addr);
 	int	(*set_default_key)(struct wiphy *wiphy,
 				   struct net_device *netdev,
 				   u8 key_index);
@@ -1302,6 +1303,7 @@ struct cfg80211_ops {
  * @WIPHY_FLAG_CONTROL_PORT_PROTOCOL: This device supports setting the
  *	control port protocol ethertype. The device also honours the
  *	control_port_no_encrypt flag.
+ * @WIPHY_FLAG_IBSS_RSN: The device supports IBSS RSN.
  */
 enum wiphy_flags {
 	WIPHY_FLAG_CUSTOM_REGULATORY		= BIT(0),
@@ -1312,6 +1314,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_4ADDR_AP			= BIT(5),
 	WIPHY_FLAG_4ADDR_STATION		= BIT(6),
 	WIPHY_FLAG_CONTROL_PORT_PROTOCOL	= BIT(7),
+	WIPHY_FLAG_IBSS_RSN			= BIT(7),
 };
 
 struct mac_address {
--- wireless-testing.orig/net/mac80211/key.c	2010-10-05 19:33:50.000000000 +0200
+++ wireless-testing/net/mac80211/key.c	2010-10-05 19:38:24.000000000 +0200
@@ -68,15 +68,21 @@ static int ieee80211_key_enable_hw_accel
 
 	might_sleep();
 
-	if (!key->local->ops->set_key) {
-		ret = -EOPNOTSUPP;
+	if (!key->local->ops->set_key)
 		goto out_unsupported;
-	}
 
 	assert_key_lock(key->local);
 
 	sta = get_sta_for_key(key);
 
+	/*
+	 * If this is a per-STA GTK, check if it
+	 * is supported; if not, return.
+	 */
+	if (sta && !(key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE) &&
+	    !(key->local->hw.flags & IEEE80211_HW_SUPPORTS_PER_STA_GTK))
+		goto out_unsupported;
+
 	sdata = key->sdata;
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 		sdata = container_of(sdata->bss,
@@ -85,31 +91,28 @@ static int ieee80211_key_enable_hw_accel
 
 	ret = drv_set_key(key->local, SET_KEY, sdata, sta, &key->conf);
 
-	if (!ret)
+	if (!ret) {
 		key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
+		return 0;
+	}
 
-	if (ret && ret != -ENOSPC && ret != -EOPNOTSUPP)
+	if (ret != -ENOSPC && ret != -EOPNOTSUPP)
 		wiphy_err(key->local->hw.wiphy,
 			  "failed to set key (%d, %pM) to hardware (%d)\n",
 			  key->conf.keyidx, sta ? sta->addr : bcast_addr, ret);
 
-out_unsupported:
-	if (ret) {
-		switch (key->conf.cipher) {
-		case WLAN_CIPHER_SUITE_WEP40:
-		case WLAN_CIPHER_SUITE_WEP104:
-		case WLAN_CIPHER_SUITE_TKIP:
-		case WLAN_CIPHER_SUITE_CCMP:
-		case WLAN_CIPHER_SUITE_AES_CMAC:
-			/* all of these we can do in software */
-			ret = 0;
-			break;
-		default:
-			ret = -EINVAL;
-		}
+ out_unsupported:
+	switch (key->conf.cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
+	case WLAN_CIPHER_SUITE_TKIP:
+	case WLAN_CIPHER_SUITE_CCMP:
+	case WLAN_CIPHER_SUITE_AES_CMAC:
+		/* all of these we can do in software */
+		return 0;
+	default:
+		return -EINVAL;
 	}
-
-	return ret;
 }
 
 static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
@@ -147,6 +150,26 @@ static void ieee80211_key_disable_hw_acc
 	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
 }
 
+void ieee80211_key_removed(struct ieee80211_key_conf *key_conf)
+{
+	struct ieee80211_key *key;
+
+	key = container_of(key_conf, struct ieee80211_key, conf);
+
+	might_sleep();
+	assert_key_lock(key->local);
+
+	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
+
+	/*
+	 * Flush TX path to avoid attempts to use this key
+	 * after this function returns. Until then, drivers
+	 * must be prepared to handle the key.
+	 */
+	synchronize_rcu();
+}
+EXPORT_SYMBOL_GPL(ieee80211_key_removed);
+
 static void __ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata,
 					int idx)
 {
@@ -202,6 +225,7 @@ void ieee80211_set_default_mgmt_key(stru
 
 static void __ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 				    struct sta_info *sta,
+				    bool pairwise,
 				    struct ieee80211_key *old,
 				    struct ieee80211_key *new)
 {
@@ -210,8 +234,14 @@ static void __ieee80211_key_replace(stru
 	if (new)
 		list_add(&new->list, &sdata->key_list);
 
-	if (sta) {
-		rcu_assign_pointer(sta->key, new);
+	if (sta && pairwise) {
+		rcu_assign_pointer(sta->ptk, new);
+	} else if (sta) {
+		if (old)
+			idx = old->conf.keyidx;
+		else
+			idx = new->conf.keyidx;
+		rcu_assign_pointer(sta->gtk[idx], new);
 	} else {
 		WARN_ON(new && old && new->conf.keyidx != old->conf.keyidx);
 
@@ -355,6 +385,7 @@ int ieee80211_key_link(struct ieee80211_
 {
 	struct ieee80211_key *old_key;
 	int idx, ret;
+	bool pairwise = key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE;
 
 	BUG_ON(!sdata);
 	BUG_ON(!key);
@@ -371,13 +402,6 @@ int ieee80211_key_link(struct ieee80211_
 		 */
 		if (test_sta_flags(sta, WLAN_STA_WME))
 			key->conf.flags |= IEEE80211_KEY_FLAG_WMM_STA;
-
-		/*
-		 * This key is for a specific sta interface,
-		 * inform the driver that it should try to store
-		 * this key as pairwise key.
-		 */
-		key->conf.flags |= IEEE80211_KEY_FLAG_PAIRWISE;
 	} else {
 		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 			struct sta_info *ap;
@@ -399,12 +423,14 @@ int ieee80211_key_link(struct ieee80211_
 
 	mutex_lock(&sdata->local->key_mtx);
 
-	if (sta)
-		old_key = sta->key;
+	if (sta && pairwise)
+		old_key = sta->ptk;
+	else if (sta)
+		old_key = sta->gtk[idx];
 	else
 		old_key = sdata->keys[idx];
 
-	__ieee80211_key_replace(sdata, sta, old_key, key);
+	__ieee80211_key_replace(sdata, sta, pairwise, old_key, key);
 	__ieee80211_key_destroy(old_key);
 
 	ieee80211_debugfs_key_add(key);
@@ -423,7 +449,8 @@ static void __ieee80211_key_free(struct
 	 */
 	if (key->sdata)
 		__ieee80211_key_replace(key->sdata, key->sta,
-					key, NULL);
+				key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE,
+				key, NULL);
 	__ieee80211_key_destroy(key);
 }
 
--- wireless-testing.orig/drivers/net/wireless/iwmc3200wifi/cfg80211.c	2010-10-05 19:33:50.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwmc3200wifi/cfg80211.c	2010-10-05 19:38:24.000000000 +0200
@@ -161,7 +161,7 @@ static int iwm_key_init(struct iwm_key *
 }
 
 static int iwm_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
-				u8 key_index, const u8 *mac_addr,
+				u8 key_index, bool pairwise, const u8 *mac_addr,
 				struct key_params *params)
 {
 	struct iwm_priv *iwm = ndev_to_iwm(ndev);
@@ -181,7 +181,8 @@ static int iwm_cfg80211_add_key(struct w
 }
 
 static int iwm_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev,
-				u8 key_index, const u8 *mac_addr, void *cookie,
+				u8 key_index, bool pairwise, const u8 *mac_addr,
+				void *cookie,
 				void (*callback)(void *cookie,
 						 struct key_params*))
 {
@@ -206,7 +207,7 @@ static int iwm_cfg80211_get_key(struct w
 
 
 static int iwm_cfg80211_del_key(struct wiphy *wiphy, struct net_device *ndev,
-				u8 key_index, const u8 *mac_addr)
+				u8 key_index, bool pairwise, const u8 *mac_addr)
 {
 	struct iwm_priv *iwm = ndev_to_iwm(ndev);
 	struct iwm_key *key = &iwm->keys[key_index];
--- wireless-testing.orig/drivers/net/wireless/libertas/cfg.c	2010-10-05 19:33:50.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/cfg.c	2010-10-05 19:38:24.000000000 +0200
@@ -1440,7 +1440,7 @@ static int lbs_cfg_set_default_key(struc
 
 
 static int lbs_cfg_add_key(struct wiphy *wiphy, struct net_device *netdev,
-			   u8 idx, const u8 *mac_addr,
+			   u8 idx, bool pairwise, const u8 *mac_addr,
 			   struct key_params *params)
 {
 	struct lbs_private *priv = wiphy_priv(wiphy);
@@ -1500,7 +1500,7 @@ static int lbs_cfg_add_key(struct wiphy
 
 
 static int lbs_cfg_del_key(struct wiphy *wiphy, struct net_device *netdev,
-			   u8 key_index, const u8 *mac_addr)
+			   u8 key_index, bool pairwise, const u8 *mac_addr)
 {
 
 	lbs_deb_enter(LBS_DEB_CFG80211);
--- wireless-testing.orig/drivers/net/wireless/rndis_wlan.c	2010-10-05 19:33:50.000000000 +0200
+++ wireless-testing/drivers/net/wireless/rndis_wlan.c	2010-10-05 19:38:24.000000000 +0200
@@ -540,11 +540,11 @@ static int rndis_set_channel(struct wiph
 	struct ieee80211_channel *chan, enum nl80211_channel_type channel_type);
 
 static int rndis_add_key(struct wiphy *wiphy, struct net_device *netdev,
-					u8 key_index, const u8 *mac_addr,
-					struct key_params *params);
+			 u8 key_index, bool pairwise, const u8 *mac_addr,
+			 struct key_params *params);
 
 static int rndis_del_key(struct wiphy *wiphy, struct net_device *netdev,
-					u8 key_index, const u8 *mac_addr);
+			 u8 key_index, bool pairwise, const u8 *mac_addr);
 
 static int rndis_set_default_key(struct wiphy *wiphy, struct net_device *netdev,
 								u8 key_index);
@@ -2308,8 +2308,8 @@ static int rndis_set_channel(struct wiph
 }
 
 static int rndis_add_key(struct wiphy *wiphy, struct net_device *netdev,
-					u8 key_index, const u8 *mac_addr,
-					struct key_params *params)
+			 u8 key_index, bool pairwise, const u8 *mac_addr,
+			 struct key_params *params)
 {
 	struct rndis_wlan_private *priv = wiphy_priv(wiphy);
 	struct usbnet *usbdev = priv->usbdev;
@@ -2344,7 +2344,7 @@ static int rndis_add_key(struct wiphy *w
 }
 
 static int rndis_del_key(struct wiphy *wiphy, struct net_device *netdev,
-					u8 key_index, const u8 *mac_addr)
+			 u8 key_index, bool pairwise, const u8 *mac_addr)
 {
 	struct rndis_wlan_private *priv = wiphy_priv(wiphy);
 	struct usbnet *usbdev = priv->usbdev;
--- wireless-testing.orig/net/mac80211/cfg.c	2010-10-05 19:33:49.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2010-10-05 19:38:24.000000000 +0200
@@ -75,7 +75,7 @@ static int ieee80211_change_iface(struct
 }
 
 static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
-			     u8 key_idx, const u8 *mac_addr,
+			     u8 key_idx, bool pairwise, const u8 *mac_addr,
 			     struct key_params *params)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -103,6 +103,9 @@ static int ieee80211_add_key(struct wiph
 	if (IS_ERR(key))
 		return PTR_ERR(key);
 
+	if (pairwise)
+		key->conf.flags |= IEEE80211_KEY_FLAG_PAIRWISE;
+
 	mutex_lock(&sdata->local->sta_mtx);
 
 	if (mac_addr) {
@@ -125,7 +128,7 @@ static int ieee80211_add_key(struct wiph
 }
 
 static int ieee80211_del_key(struct wiphy *wiphy, struct net_device *dev,
-			     u8 key_idx, const u8 *mac_addr)
+			     u8 key_idx, bool pairwise, const u8 *mac_addr)
 {
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
@@ -142,10 +145,17 @@ static int ieee80211_del_key(struct wiph
 		if (!sta)
 			goto out_unlock;
 
-		if (sta->key) {
-			ieee80211_key_free(sdata->local, sta->key);
-			WARN_ON(sta->key);
-			ret = 0;
+		if (pairwise) {
+			if (sta->ptk) {
+				ieee80211_key_free(sdata->local, sta->ptk);
+				ret = 0;
+			}
+		} else {
+			if (sta->gtk[key_idx]) {
+				ieee80211_key_free(sdata->local,
+						   sta->gtk[key_idx]);
+				ret = 0;
+			}
 		}
 
 		goto out_unlock;
@@ -167,7 +177,8 @@ static int ieee80211_del_key(struct wiph
 }
 
 static int ieee80211_get_key(struct wiphy *wiphy, struct net_device *dev,
-			     u8 key_idx, const u8 *mac_addr, void *cookie,
+			     u8 key_idx, bool pairwise, const u8 *mac_addr,
+			     void *cookie,
 			     void (*callback)(void *cookie,
 					      struct key_params *params))
 {
@@ -175,7 +186,7 @@ static int ieee80211_get_key(struct wiph
 	struct sta_info *sta = NULL;
 	u8 seq[6] = {0};
 	struct key_params params;
-	struct ieee80211_key *key;
+	struct ieee80211_key *key = NULL;
 	u32 iv32;
 	u16 iv16;
 	int err = -ENOENT;
@@ -189,7 +200,10 @@ static int ieee80211_get_key(struct wiph
 		if (!sta)
 			goto out;
 
-		key = sta->key;
+		if (pairwise)
+			key = sta->ptk;
+		else if (key_idx < NUM_DEFAULT_KEYS)
+			key = sta->gtk[key_idx];
 	} else
 		key = sdata->keys[key_idx];
 
--- wireless-testing.orig/net/mac80211/sta_info.h	2010-10-05 19:33:54.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.h	2010-10-05 19:38:24.000000000 +0200
@@ -199,7 +199,8 @@ enum plink_state {
  * @hnext: hash table linked list pointer
  * @local: pointer to the global information
  * @sdata: virtual interface this station belongs to
- * @key: peer key negotiated with this station, if any
+ * @ptk: peer key negotiated with this station, if any
+ * @gtk: group keys negotiated with this station, if any
  * @rate_ctrl: rate control algorithm reference
  * @rate_ctrl_priv: rate control private per-STA pointer
  * @last_tx_rate: rate used for last transmit, to report to userspace as
@@ -254,7 +255,8 @@ struct sta_info {
 	struct sta_info *hnext;
 	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_key *key;
+	struct ieee80211_key *gtk[NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS];
+	struct ieee80211_key *ptk;
 	struct rate_control_ref *rate_ctrl;
 	void *rate_ctrl_priv;
 	spinlock_t lock;
--- wireless-testing.orig/net/mac80211/sta_info.c	2010-10-05 19:33:54.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.c	2010-10-05 19:38:24.000000000 +0200
@@ -616,7 +616,7 @@ static int __must_check __sta_info_destr
 	struct ieee80211_sub_if_data *sdata;
 	struct sk_buff *skb;
 	unsigned long flags;
-	int ret;
+	int ret, i;
 
 	might_sleep();
 
@@ -644,10 +644,10 @@ static int __must_check __sta_info_destr
 	if (ret)
 		return ret;
 
-	if (sta->key) {
-		ieee80211_key_free(local, sta->key);
-		WARN_ON(sta->key);
-	}
+	for (i = 0; i < NUM_DEFAULT_KEYS; i++)
+		ieee80211_key_free(local, sta->gtk[i]);
+	if (sta->ptk)
+		ieee80211_key_free(local, sta->ptk);
 
 	sta->dead = true;
 
--- wireless-testing.orig/net/mac80211/rx.c	2010-10-05 19:33:50.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2010-10-05 19:38:24.000000000 +0200
@@ -845,7 +845,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 	int keyidx;
 	int hdrlen;
 	ieee80211_rx_result result = RX_DROP_UNUSABLE;
-	struct ieee80211_key *stakey = NULL;
+	struct ieee80211_key *sta_ptk = NULL;
 	int mmie_keyidx = -1;
 	__le16 fc;
 
@@ -887,15 +887,15 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 	rx->key = NULL;
 
 	if (rx->sta)
-		stakey = rcu_dereference(rx->sta->key);
+		sta_ptk = rcu_dereference(rx->sta->ptk);
 
 	fc = hdr->frame_control;
 
 	if (!ieee80211_has_protected(fc))
 		mmie_keyidx = ieee80211_get_mmie_keyidx(rx->skb);
 
-	if (!is_multicast_ether_addr(hdr->addr1) && stakey) {
-		rx->key = stakey;
+	if (!is_multicast_ether_addr(hdr->addr1) && sta_ptk) {
+		rx->key = sta_ptk;
 		if ((status->flag & RX_FLAG_DECRYPTED) &&
 		    (status->flag & RX_FLAG_IV_STRIPPED))
 			return RX_CONTINUE;
@@ -911,7 +911,10 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 		if (mmie_keyidx < NUM_DEFAULT_KEYS ||
 		    mmie_keyidx >= NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS)
 			return RX_DROP_MONITOR; /* unexpected BIP keyidx */
-		rx->key = rcu_dereference(rx->sdata->keys[mmie_keyidx]);
+		if (rx->sta)
+			rx->key = rcu_dereference(rx->sta->gtk[mmie_keyidx]);
+		if (!rx->key)
+			rx->key = rcu_dereference(rx->sdata->keys[mmie_keyidx]);
 	} else if (!ieee80211_has_protected(fc)) {
 		/*
 		 * The frame was not protected, so skip decryption. However, we
@@ -954,17 +957,25 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 		skb_copy_bits(rx->skb, hdrlen + 3, &keyid, 1);
 		keyidx = keyid >> 6;
 
-		rx->key = rcu_dereference(rx->sdata->keys[keyidx]);
-
-		/*
-		 * RSNA-protected unicast frames should always be sent with
-		 * pairwise or station-to-station keys, but for WEP we allow
-		 * using a key index as well.
-		 */
-		if (rx->key && rx->key->conf.cipher != WLAN_CIPHER_SUITE_WEP40 &&
-		    rx->key->conf.cipher != WLAN_CIPHER_SUITE_WEP104 &&
-		    !is_multicast_ether_addr(hdr->addr1))
-			rx->key = NULL;
+		/* check per-station GTK first, if multicast packet */
+		if (is_multicast_ether_addr(hdr->addr1) && rx->sta)
+			rx->key = rcu_dereference(rx->sta->gtk[keyidx]);
+
+		/* if not found, try default key */
+		if (!rx->key) {
+			rx->key = rcu_dereference(rx->sdata->keys[keyidx]);
+
+			/*
+			 * RSNA-protected unicast frames should always be
+			 * sent with pairwise or station-to-station keys,
+			 * but for WEP we allow using a key index as well.
+			 */
+			if (rx->key &&
+			    rx->key->conf.cipher != WLAN_CIPHER_SUITE_WEP40 &&
+			    rx->key->conf.cipher != WLAN_CIPHER_SUITE_WEP104 &&
+			    !is_multicast_ether_addr(hdr->addr1))
+				rx->key = NULL;
+		}
 	}
 
 	if (rx->key) {
--- wireless-testing.orig/net/mac80211/tx.c	2010-10-05 19:33:50.000000000 +0200
+++ wireless-testing/net/mac80211/tx.c	2010-10-05 19:38:24.000000000 +0200
@@ -529,7 +529,7 @@ ieee80211_tx_h_select_key(struct ieee802
 
 	if (unlikely(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT))
 		tx->key = NULL;
-	else if (tx->sta && (key = rcu_dereference(tx->sta->key)))
+	else if (tx->sta && (key = rcu_dereference(tx->sta->ptk)))
 		tx->key = key;
 	else if (ieee80211_is_mgmt(hdr->frame_control) &&
 		 is_multicast_ether_addr(hdr->addr1) &&
--- wireless-testing.orig/net/wireless/ibss.c	2010-10-05 19:33:49.000000000 +0200
+++ wireless-testing/net/wireless/ibss.c	2010-10-05 19:38:24.000000000 +0200
@@ -160,7 +160,7 @@ static void __cfg80211_clear_ibss(struct
 	 */
 	if (rdev->ops->del_key)
 		for (i = 0; i < 6; i++)
-			rdev->ops->del_key(wdev->wiphy, dev, i, NULL);
+			rdev->ops->del_key(wdev->wiphy, dev, i, false, NULL);
 
 	if (wdev->current_bss) {
 		cfg80211_unhold_bss(wdev->current_bss);
--- wireless-testing.orig/net/wireless/nl80211.c	2010-10-05 19:38:23.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2010-10-05 19:38:24.000000000 +0200
@@ -93,6 +93,7 @@ static const struct nla_policy nl80211_p
 	[NL80211_ATTR_KEY_CIPHER] = { .type = NLA_U32 },
 	[NL80211_ATTR_KEY_DEFAULT] = { .type = NLA_FLAG },
 	[NL80211_ATTR_KEY_SEQ] = { .type = NLA_BINARY, .len = 8 },
+	[NL80211_ATTR_KEY_TYPE] = { .type = NLA_U32 },
 
 	[NL80211_ATTR_BEACON_INTERVAL] = { .type = NLA_U32 },
 	[NL80211_ATTR_DTIM_PERIOD] = { .type = NLA_U32 },
@@ -168,7 +169,7 @@ static const struct nla_policy nl80211_p
 	[NL80211_ATTR_FRAME_TYPE] = { .type = NLA_U16 },
 };
 
-/* policy for the attributes */
+/* policy for the key attributes */
 static const struct nla_policy nl80211_key_policy[NL80211_KEY_MAX + 1] = {
 	[NL80211_KEY_DATA] = { .type = NLA_BINARY, .len = WLAN_MAX_KEY_LEN },
 	[NL80211_KEY_IDX] = { .type = NLA_U8 },
@@ -176,6 +177,7 @@ static const struct nla_policy nl80211_k
 	[NL80211_KEY_SEQ] = { .type = NLA_BINARY, .len = 8 },
 	[NL80211_KEY_DEFAULT] = { .type = NLA_FLAG },
 	[NL80211_KEY_DEFAULT_MGMT] = { .type = NLA_FLAG },
+	[NL80211_KEY_TYPE] = { .type = NLA_U32 },
 };
 
 /* ifidx get helper */
@@ -306,6 +308,7 @@ static int nl80211_msg_put_channel(struc
 struct key_parse {
 	struct key_params p;
 	int idx;
+	int type;
 	bool def, defmgmt;
 };
 
@@ -336,6 +339,12 @@ static int nl80211_parse_key_new(struct
 	if (tb[NL80211_KEY_CIPHER])
 		k->p.cipher = nla_get_u32(tb[NL80211_KEY_CIPHER]);
 
+	if (tb[NL80211_KEY_TYPE]) {
+		k->type = nla_get_u32(tb[NL80211_KEY_TYPE]);
+		if (k->type < 0 || k->type >= NUM_NL80211_KEYTYPES)
+			return -EINVAL;
+	}
+
 	return 0;
 }
 
@@ -360,6 +369,12 @@ static int nl80211_parse_key_old(struct
 	k->def = !!info->attrs[NL80211_ATTR_KEY_DEFAULT];
 	k->defmgmt = !!info->attrs[NL80211_ATTR_KEY_DEFAULT_MGMT];
 
+	if (info->attrs[NL80211_ATTR_KEY_TYPE]) {
+		k->type = nla_get_u32(info->attrs[NL80211_ATTR_KEY_TYPE]);
+		if (k->type < 0 || k->type >= NUM_NL80211_KEYTYPES)
+			return -EINVAL;
+	}
+
 	return 0;
 }
 
@@ -369,6 +384,7 @@ static int nl80211_parse_key(struct genl
 
 	memset(k, 0, sizeof(*k));
 	k->idx = -1;
+	k->type = -1;
 
 	if (info->attrs[NL80211_ATTR_KEY])
 		err = nl80211_parse_key_new(info->attrs[NL80211_ATTR_KEY], k);
@@ -433,7 +449,7 @@ nl80211_parse_connkeys(struct cfg80211_r
 		} else if (parse.defmgmt)
 			goto error;
 		err = cfg80211_validate_key_settings(rdev, &parse.p,
-						     parse.idx, NULL);
+						     parse.idx, false, NULL);
 		if (err)
 			goto error;
 		result->params[parse.idx].cipher = parse.p.cipher;
@@ -516,6 +532,9 @@ static int nl80211_send_wiphy(struct sk_
 	NLA_PUT_U16(msg, NL80211_ATTR_MAX_SCAN_IE_LEN,
 		    dev->wiphy.max_scan_ie_len);
 
+	if (dev->wiphy.flags & WIPHY_FLAG_IBSS_RSN)
+		NLA_PUT_FLAG(msg, NL80211_ATTR_SUPPORT_IBSS_RSN);
+
 	NLA_PUT(msg, NL80211_ATTR_CIPHER_SUITES,
 		sizeof(u32) * dev->wiphy.n_cipher_suites,
 		dev->wiphy.cipher_suites);
@@ -1398,7 +1417,8 @@ static int nl80211_get_key(struct sk_buf
 	int err;
 	struct net_device *dev = info->user_ptr[1];
 	u8 key_idx = 0;
-	u8 *mac_addr = NULL;
+	const u8 *mac_addr = NULL;
+	bool pairwise;
 	struct get_key_cookie cookie = {
 		.error = 0,
 	};
@@ -1414,6 +1434,17 @@ static int nl80211_get_key(struct sk_buf
 	if (info->attrs[NL80211_ATTR_MAC])
 		mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
 
+	pairwise = !!mac_addr;
+	if (info->attrs[NL80211_ATTR_KEY_TYPE]) {
+		u32 kt = nla_get_u32(info->attrs[NL80211_ATTR_KEY_TYPE]);
+		if (kt >= NUM_NL80211_KEYTYPES)
+			return -EINVAL;
+		if (kt != NL80211_KEYTYPE_GROUP &&
+		    kt != NL80211_KEYTYPE_PAIRWISE)
+			return -EINVAL;
+		pairwise = kt == NL80211_KEYTYPE_PAIRWISE;
+	}
+
 	if (!rdev->ops->get_key)
 		return -EOPNOTSUPP;
 
@@ -1434,8 +1465,12 @@ static int nl80211_get_key(struct sk_buf
 	if (mac_addr)
 		NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr);
 
-	err = rdev->ops->get_key(&rdev->wiphy, dev, key_idx, mac_addr,
-				&cookie, get_key_callback);
+	if (pairwise && mac_addr &&
+	    !(rdev->wiphy.flags & WIPHY_FLAG_IBSS_RSN))
+		return -ENOENT;
+
+	err = rdev->ops->get_key(&rdev->wiphy, dev, key_idx, pairwise,
+				 mac_addr, &cookie, get_key_callback);
 
 	if (err)
 		goto free_msg;
@@ -1505,7 +1540,7 @@ static int nl80211_new_key(struct sk_buf
 	int err;
 	struct net_device *dev = info->user_ptr[1];
 	struct key_parse key;
-	u8 *mac_addr = NULL;
+	const u8 *mac_addr = NULL;
 
 	err = nl80211_parse_key(info, &key);
 	if (err)
@@ -1517,16 +1552,31 @@ static int nl80211_new_key(struct sk_buf
 	if (info->attrs[NL80211_ATTR_MAC])
 		mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
 
+	if (key.type == -1) {
+		if (mac_addr)
+			key.type = NL80211_KEYTYPE_PAIRWISE;
+		else
+			key.type = NL80211_KEYTYPE_GROUP;
+	}
+
+	/* for now */
+	if (key.type != NL80211_KEYTYPE_PAIRWISE &&
+	    key.type != NL80211_KEYTYPE_GROUP)
+		return -EINVAL;
+
 	if (!rdev->ops->add_key)
 		return -EOPNOTSUPP;
 
-	if (cfg80211_validate_key_settings(rdev, &key.p, key.idx, mac_addr))
+	if (cfg80211_validate_key_settings(rdev, &key.p, key.idx,
+					   key.type == NL80211_KEYTYPE_PAIRWISE,
+					   mac_addr))
 		return -EINVAL;
 
 	wdev_lock(dev->ieee80211_ptr);
 	err = nl80211_key_allowed(dev->ieee80211_ptr);
 	if (!err)
 		err = rdev->ops->add_key(&rdev->wiphy, dev, key.idx,
+					 key.type == NL80211_KEYTYPE_PAIRWISE,
 					 mac_addr, &key.p);
 	wdev_unlock(dev->ieee80211_ptr);
 
@@ -1548,13 +1598,32 @@ static int nl80211_del_key(struct sk_buf
 	if (info->attrs[NL80211_ATTR_MAC])
 		mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
 
+	if (key.type == -1) {
+		if (mac_addr)
+			key.type = NL80211_KEYTYPE_PAIRWISE;
+		else
+			key.type = NL80211_KEYTYPE_GROUP;
+	}
+
+	/* for now */
+	if (key.type != NL80211_KEYTYPE_PAIRWISE &&
+	    key.type != NL80211_KEYTYPE_GROUP)
+		return -EINVAL;
+
 	if (!rdev->ops->del_key)
 		return -EOPNOTSUPP;
 
 	wdev_lock(dev->ieee80211_ptr);
 	err = nl80211_key_allowed(dev->ieee80211_ptr);
+
+	if (key.type == NL80211_KEYTYPE_PAIRWISE && mac_addr &&
+	    !(rdev->wiphy.flags & WIPHY_FLAG_IBSS_RSN))
+		err = -ENOENT;
+
 	if (!err)
-		err = rdev->ops->del_key(&rdev->wiphy, dev, key.idx, mac_addr);
+		err = rdev->ops->del_key(&rdev->wiphy, dev, key.idx,
+					 key.type == NL80211_KEYTYPE_PAIRWISE,
+					 mac_addr);
 
 #ifdef CONFIG_CFG80211_WEXT
 	if (!err) {
@@ -3162,6 +3231,8 @@ static int nl80211_authenticate(struct s
 		return err;
 
 	if (key.idx >= 0) {
+		if (key.type != -1 && key.type != NL80211_KEYTYPE_GROUP)
+			return -EINVAL;
 		if (!key.p.key || !key.p.key_len)
 			return -EINVAL;
 		if ((key.p.cipher != WLAN_CIPHER_SUITE_WEP40 ||
--- wireless-testing.orig/net/wireless/sme.c	2010-10-05 19:33:49.000000000 +0200
+++ wireless-testing/net/wireless/sme.c	2010-10-05 19:38:24.000000000 +0200
@@ -698,7 +698,7 @@ void __cfg80211_disconnected(struct net_
 	 */
 	if (rdev->ops->del_key)
 		for (i = 0; i < 6; i++)
-			rdev->ops->del_key(wdev->wiphy, dev, i, NULL);
+			rdev->ops->del_key(wdev->wiphy, dev, i, false, NULL);
 
 #ifdef CONFIG_CFG80211_WEXT
 	memset(&wrqu, 0, sizeof(wrqu));
--- wireless-testing.orig/net/wireless/util.c	2010-10-05 19:33:49.000000000 +0200
+++ wireless-testing/net/wireless/util.c	2010-10-05 19:38:24.000000000 +0200
@@ -144,19 +144,25 @@ void ieee80211_set_bitrate_flags(struct
 
 int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 				   struct key_params *params, int key_idx,
-				   const u8 *mac_addr)
+				   bool pairwise, const u8 *mac_addr)
 {
 	int i;
 
 	if (key_idx > 5)
 		return -EINVAL;
 
+	if (!pairwise && mac_addr && !(rdev->wiphy.flags & WIPHY_FLAG_IBSS_RSN))
+		return -EINVAL;
+
+	if (pairwise && !mac_addr)
+		return -EINVAL;
+
 	/*
 	 * Disallow pairwise keys with non-zero index unless it's WEP
 	 * (because current deployments use pairwise WEP keys with
 	 * non-zero indizes but 802.11i clearly specifies to use zero)
 	 */
-	if (mac_addr && key_idx &&
+	if (pairwise && key_idx &&
 	    params->cipher != WLAN_CIPHER_SUITE_WEP40 &&
 	    params->cipher != WLAN_CIPHER_SUITE_WEP104)
 		return -EINVAL;
@@ -677,7 +683,7 @@ void cfg80211_upload_connect_keys(struct
 	for (i = 0; i < 6; i++) {
 		if (!wdev->connect_keys->params[i].cipher)
 			continue;
-		if (rdev->ops->add_key(wdev->wiphy, dev, i, NULL,
+		if (rdev->ops->add_key(wdev->wiphy, dev, i, false, NULL,
 					&wdev->connect_keys->params[i])) {
 			printk(KERN_ERR "%s: failed to set key %d\n",
 				dev->name, i);
--- wireless-testing.orig/net/wireless/core.h	2010-10-05 19:33:49.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2010-10-05 19:38:24.000000000 +0200
@@ -375,7 +375,7 @@ bool cfg80211_sme_failed_reassoc(struct
 /* internal helpers */
 int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 				   struct key_params *params, int key_idx,
-				   const u8 *mac_addr);
+				   bool pairwise, const u8 *mac_addr);
 void __cfg80211_disconnected(struct net_device *dev, const u8 *ie,
 			     size_t ie_len, u16 reason, bool from_ap);
 void cfg80211_sme_scan_done(struct net_device *dev);
--- wireless-testing.orig/net/wireless/wext-compat.c	2010-10-05 19:33:49.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.c	2010-10-05 19:38:24.000000000 +0200
@@ -432,14 +432,17 @@ int cfg80211_wext_giwretry(struct net_de
 EXPORT_SYMBOL_GPL(cfg80211_wext_giwretry);
 
 static int __cfg80211_set_encryption(struct cfg80211_registered_device *rdev,
-				     struct net_device *dev, const u8 *addr,
-				     bool remove, bool tx_key, int idx,
-				     struct key_params *params)
+				     struct net_device *dev, bool pairwise,
+				     const u8 *addr, bool remove, bool tx_key,
+				     int idx, struct key_params *params)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int err, i;
 	bool rejoin = false;
 
+	if (pairwise && !addr)
+		return -EINVAL;
+
 	if (!wdev->wext.keys) {
 		wdev->wext.keys = kzalloc(sizeof(*wdev->wext.keys),
 					      GFP_KERNEL);
@@ -478,7 +481,13 @@ static int __cfg80211_set_encryption(str
 				__cfg80211_leave_ibss(rdev, wdev->netdev, true);
 				rejoin = true;
 			}
-			err = rdev->ops->del_key(&rdev->wiphy, dev, idx, addr);
+
+			if (!pairwise && addr &&
+			    !(rdev->wiphy.flags & WIPHY_FLAG_IBSS_RSN))
+				err = -ENOENT;
+			else
+				err = rdev->ops->del_key(&rdev->wiphy, dev, idx,
+							 pairwise, addr);
 		}
 		wdev->wext.connect.privacy = false;
 		/*
@@ -507,12 +516,13 @@ static int __cfg80211_set_encryption(str
 	if (addr)
 		tx_key = false;
 
-	if (cfg80211_validate_key_settings(rdev, params, idx, addr))
+	if (cfg80211_validate_key_settings(rdev, params, idx, pairwise, addr))
 		return -EINVAL;
 
 	err = 0;
 	if (wdev->current_bss)
-		err = rdev->ops->add_key(&rdev->wiphy, dev, idx, addr, params);
+		err = rdev->ops->add_key(&rdev->wiphy, dev, idx,
+					 pairwise, addr, params);
 	if (err)
 		return err;
 
@@ -563,17 +573,17 @@ static int __cfg80211_set_encryption(str
 }
 
 static int cfg80211_set_encryption(struct cfg80211_registered_device *rdev,
-				   struct net_device *dev, const u8 *addr,
-				   bool remove, bool tx_key, int idx,
-				   struct key_params *params)
+				   struct net_device *dev, bool pairwise,
+				   const u8 *addr, bool remove, bool tx_key,
+				   int idx, struct key_params *params)
 {
 	int err;
 
 	/* devlist mutex needed for possible IBSS re-join */
 	mutex_lock(&rdev->devlist_mtx);
 	wdev_lock(dev->ieee80211_ptr);
-	err = __cfg80211_set_encryption(rdev, dev, addr, remove,
-					tx_key, idx, params);
+	err = __cfg80211_set_encryption(rdev, dev, pairwise, addr,
+					remove, tx_key, idx, params);
 	wdev_unlock(dev->ieee80211_ptr);
 	mutex_unlock(&rdev->devlist_mtx);
 
@@ -635,7 +645,7 @@ int cfg80211_wext_siwencode(struct net_d
 	else if (!remove)
 		return -EINVAL;
 
-	return cfg80211_set_encryption(rdev, dev, NULL, remove,
+	return cfg80211_set_encryption(rdev, dev, false, NULL, remove,
 				       wdev->wext.default_key == -1,
 				       idx, &params);
 }
@@ -725,7 +735,9 @@ int cfg80211_wext_siwencodeext(struct ne
 	}
 
 	return cfg80211_set_encryption(
-			rdev, dev, addr, remove,
+			rdev, dev,
+			!(ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY),
+			addr, remove,
 			ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY,
 			idx, &params);
 }
--- wireless-testing.orig/include/linux/nl80211.h	2010-10-05 19:38:23.000000000 +0200
+++ wireless-testing/include/linux/nl80211.h	2010-10-05 19:38:24.000000000 +0200
@@ -812,6 +812,9 @@ enum nl80211_commands {
  *      This is used in association with @NL80211_ATTR_WIPHY_TX_POWER_SETTING
  *      for non-automatic settings.
  *
+ * @NL80211_ATTR_SUPPORT_IBSS_RSN: The device supports IBSS RSN, which mostly
+ *	means support for per-station GTKs.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -979,6 +982,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_CONTROL_PORT_ETHERTYPE,
 	NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT,
 
+	NL80211_ATTR_SUPPORT_IBSS_RSN,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1668,11 +1673,14 @@ enum nl80211_auth_type {
  * @NL80211_KEYTYPE_GROUP: Group (broadcast/multicast) key
  * @NL80211_KEYTYPE_PAIRWISE: Pairwise (unicast/individual) key
  * @NL80211_KEYTYPE_PEERKEY: PeerKey (DLS)
+ * @NUM_NL80211_KEYTYPES: number of defined key types
  */
 enum nl80211_key_type {
 	NL80211_KEYTYPE_GROUP,
 	NL80211_KEYTYPE_PAIRWISE,
 	NL80211_KEYTYPE_PEERKEY,
+
+	NUM_NL80211_KEYTYPES
 };
 
 /**
@@ -1703,6 +1711,9 @@ enum nl80211_wpa_versions {
  *	CCMP keys, each six bytes in little endian
  * @NL80211_KEY_DEFAULT: flag indicating default key
  * @NL80211_KEY_DEFAULT_MGMT: flag indicating default management key
+ * @NL80211_KEY_TYPE: the key type from enum nl80211_key_type, if not
+ *	specified the default depends on whether a MAC address was
+ *	given with the command using the key or not (u32)
  * @__NL80211_KEY_AFTER_LAST: internal
  * @NL80211_KEY_MAX: highest key attribute
  */
@@ -1714,6 +1725,7 @@ enum nl80211_key_attributes {
 	NL80211_KEY_SEQ,
 	NL80211_KEY_DEFAULT,
 	NL80211_KEY_DEFAULT_MGMT,
+	NL80211_KEY_TYPE,
 
 	/* keep last */
 	__NL80211_KEY_AFTER_LAST,
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-10-05 19:33:54.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-10-05 19:38:24.000000000 +0200
@@ -548,8 +548,6 @@ struct ieee80211_sub_if_data {
 	struct ieee80211_fragment_entry	fragments[IEEE80211_FRAGMENT_MAX];
 	unsigned int fragment_next;
 
-#define NUM_DEFAULT_KEYS 4
-#define NUM_DEFAULT_MGMT_KEYS 2
 	struct ieee80211_key *keys[NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS];
 	struct ieee80211_key *default_key;
 	struct ieee80211_key *default_mgmt_key;
--- wireless-testing.orig/net/mac80211/key.h	2010-10-05 19:33:50.000000000 +0200
+++ wireless-testing/net/mac80211/key.h	2010-10-05 19:38:24.000000000 +0200
@@ -16,6 +16,9 @@
 #include <linux/rcupdate.h>
 #include <net/mac80211.h>
 
+#define NUM_DEFAULT_KEYS 4
+#define NUM_DEFAULT_MGMT_KEYS 2
+
 #define WEP_IV_LEN		4
 #define WEP_ICV_LEN		4
 #define ALG_TKIP_KEY_LEN	32


