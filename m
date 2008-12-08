Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36583 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbYLHTpC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 14:45:02 -0500
Subject: [RFT] mac80211: clean up set_key callback
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, Chr <chunkeey@web.de>,
	Tomas Winkler <tomasw@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Bob Copeland <me@bobcopeland.com>,
	Michael Buesch <mb@bu3sch.de>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Kalle Valo <kalle.valo@nokia.com>
Content-Type: text/plain
Date: Mon, 08 Dec 2008 18:23:55 +0100
Message-Id: <1228757035.22164.94.camel@johannes.berg> (sfid-20081208_204509_147879_F79ED5BB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The set_key callback now seems rather odd, passing a MAC address
instead of a station struct, and a local address instead of a
vif struct. Change that.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
That all-zeroes vs. all-ones for group/tx-only keys was confusing and is
removed, this could possibly affect drivers that support multi-BSS
operation.

iwlwifi said:

       if (is_zero_ether_addr(addr))
               /* only support pairwise keys */
               return -EOPNOTSUPP;

but the comment is obviously wrong since we used to pass in all-ones for
the address for group keys, so it did support them. Change this
accordingly, and ignore the multi-BSS case since iwlwifi doesn't support
AP operation at all.

 drivers/net/wireless/ath5k/base.c           |    9 ++--
 drivers/net/wireless/ath9k/main.c           |   20 ++++------
 drivers/net/wireless/b43/main.c             |   18 ++++-----
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   10 +++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   12 +++---
 drivers/net/wireless/p54/p54common.c        |    6 +--
 drivers/net/wireless/rt2x00/rt2x00.h        |    2 -
 drivers/net/wireless/rt2x00/rt2x00mac.c     |   14 +++----
 include/net/mac80211.h                      |   20 ++++------
 net/mac80211/key.c                          |   53 ++++++++++++++--------------
 10 files changed, 80 insertions(+), 84 deletions(-)

--- everything.orig/include/net/mac80211.h	2008-12-08 17:25:24.000000000 +0100
+++ everything/include/net/mac80211.h	2008-12-08 17:58:51.000000000 +0100
@@ -710,8 +710,8 @@ enum ieee80211_key_flags {
  * 	- Temporal Encryption Key (128 bits)
  * 	- Temporal Authenticator Tx MIC Key (64 bits)
  * 	- Temporal Authenticator Rx MIC Key (64 bits)
- * @icv_len: FIXME
- * @iv_len: FIXME
+ * @icv_len: The ICV length for this key type
+ * @iv_len: The IV length for this key type
  */
 struct ieee80211_key_conf {
 	enum ieee80211_key_alg alg;
@@ -1017,16 +1017,12 @@ ieee80211_get_alt_retry_rate(const struc
  *
  * The set_key() callback in the &struct ieee80211_ops for a given
  * device is called to enable hardware acceleration of encryption and
- * decryption. The callback takes an @address parameter that will be
- * the broadcast address for default keys, the other station's hardware
- * address for individual keys or the zero address for keys that will
- * be used only for transmission.
+ * decryption. The callback takes a @sta parameter that will be NULL
+ * for default keys or keys used for transmission only, or point to
+ * the station information for the peer for individual keys.
  * Multiple transmission keys with the same key index may be used when
  * VLANs are configured for an access point.
  *
- * The @local_address parameter will always be set to our own address,
- * this is only relevant if you support multiple local addresses.
- *
  * When transmitting, the TX control data will use the @hw_key_idx
  * selected by the driver by modifying the &struct ieee80211_key_conf
  * pointed to by the @key parameter to the set_key() function.
@@ -1231,8 +1227,8 @@ enum ieee80211_ampdu_mlme_action {
  *
  * @set_key: See the section "Hardware crypto acceleration"
  *	This callback can sleep, and is only called between add_interface
- *	and remove_interface calls, i.e. while the interface with the
- *	given local_address is enabled.
+ *	and remove_interface calls, i.e. while the given virtual interface
+ *	is enabled.
  *
  * @update_tkip_key: See the section "Hardware crypto acceleration"
  * 	This callback will be called in the context of Rx. Called for drivers
@@ -1311,7 +1307,7 @@ struct ieee80211_ops {
 	int (*set_tim)(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 		       bool set);
 	int (*set_key)(struct ieee80211_hw *hw, enum set_key_cmd cmd,
-		       const u8 *local_address, const u8 *address,
+		       struct ieee80211_vif *vif, struct ieee80211_sta *sta,
 		       struct ieee80211_key_conf *key);
 	void (*update_tkip_key)(struct ieee80211_hw *hw,
 			struct ieee80211_key_conf *conf, const u8 *address,
--- everything.orig/net/mac80211/key.c	2008-12-08 17:26:21.000000000 +0100
+++ everything/net/mac80211/key.c	2008-12-08 17:38:32.000000000 +0100
@@ -47,7 +47,6 @@
  */
 
 static const u8 bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
-static const u8 zero_addr[ETH_ALEN];
 
 /* key mutex: used to synchronise todo runners */
 static DEFINE_MUTEX(key_mutex);
@@ -108,29 +107,18 @@ static void assert_key_lock(void)
 	WARN_ON(!mutex_is_locked(&key_mutex));
 }
 
-static const u8 *get_mac_for_key(struct ieee80211_key *key)
+static struct ieee80211_sta *get_sta_for_key(struct ieee80211_key *key)
 {
-	const u8 *addr = bcast_addr;
-
-	/*
-	 * If we're an AP we won't ever receive frames with a non-WEP
-	 * group key so we tell the driver that by using the zero MAC
-	 * address to indicate a transmit-only key.
-	 */
-	if (key->conf.alg != ALG_WEP &&
-	    (key->sdata->vif.type == NL80211_IFTYPE_AP ||
-	     key->sdata->vif.type == NL80211_IFTYPE_AP_VLAN))
-		addr = zero_addr;
-
 	if (key->sta)
-		addr = key->sta->sta.addr;
+		return &key->sta->sta;
 
-	return addr;
+	return NULL;
 }
 
 static void ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 {
-	const u8 *addr;
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sta *sta;
 	int ret;
 	DECLARE_MAC_BUF(mac);
 
@@ -140,11 +128,16 @@ static void ieee80211_key_enable_hw_acce
 	if (!key->local->ops->set_key)
 		return;
 
-	addr = get_mac_for_key(key);
+	sta = get_sta_for_key(key);
+
+	sdata = key->sdata;
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+		sdata = container_of(sdata->bss,
+				     struct ieee80211_sub_if_data,
+				     u.ap);
 
 	ret = key->local->ops->set_key(local_to_hw(key->local), SET_KEY,
-				       key->sdata->dev->dev_addr, addr,
-				       &key->conf);
+				       &sdata->vif, sta, &key->conf);
 
 	if (!ret) {
 		spin_lock(&todo_lock);
@@ -156,12 +149,14 @@ static void ieee80211_key_enable_hw_acce
 		printk(KERN_ERR "mac80211-%s: failed to set key "
 		       "(%d, %s) to hardware (%d)\n",
 		       wiphy_name(key->local->hw.wiphy),
-		       key->conf.keyidx, print_mac(mac, addr), ret);
+		       key->conf.keyidx,
+		       print_mac(mac, sta ? sta->addr : bcast_addr), ret);
 }
 
 static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 {
-	const u8 *addr;
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sta *sta;
 	int ret;
 	DECLARE_MAC_BUF(mac);
 
@@ -178,17 +173,23 @@ static void ieee80211_key_disable_hw_acc
 	}
 	spin_unlock(&todo_lock);
 
-	addr = get_mac_for_key(key);
+	sta = get_sta_for_key(key);
+	sdata = key->sdata;
+
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+		sdata = container_of(sdata->bss,
+				     struct ieee80211_sub_if_data,
+				     u.ap);
 
 	ret = key->local->ops->set_key(local_to_hw(key->local), DISABLE_KEY,
-				       key->sdata->dev->dev_addr, addr,
-				       &key->conf);
+				       &sdata->vif, sta, &key->conf);
 
 	if (ret)
 		printk(KERN_ERR "mac80211-%s: failed to remove key "
 		       "(%d, %s) from hardware (%d)\n",
 		       wiphy_name(key->local->hw.wiphy),
-		       key->conf.keyidx, print_mac(mac, addr), ret);
+		       key->conf.keyidx,
+		       print_mac(mac, sta ? sta->addr : bcast_addr), ret);
 
 	spin_lock(&todo_lock);
 	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
--- everything.orig/drivers/net/wireless/ath5k/base.c	2008-12-08 17:39:05.000000000 +0100
+++ everything/drivers/net/wireless/ath5k/base.c	2008-12-08 17:41:03.000000000 +0100
@@ -232,7 +232,7 @@ static void ath5k_configure_filter(struc
 		int mc_count, struct dev_mc_list *mclist);
 static int ath5k_set_key(struct ieee80211_hw *hw,
 		enum set_key_cmd cmd,
-		const u8 *local_addr, const u8 *addr,
+		struct ieee80211_vif *vif, struct ieee80211_sta *sta,
 		struct ieee80211_key_conf *key);
 static int ath5k_get_stats(struct ieee80211_hw *hw,
 		struct ieee80211_low_level_stats *stats);
@@ -2986,8 +2986,8 @@ static void ath5k_configure_filter(struc
 
 static int
 ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
-		const u8 *local_addr, const u8 *addr,
-		struct ieee80211_key_conf *key)
+	      struct ieee80211_vif *vif, struct ieee80211_sta *sta,
+	      struct ieee80211_key_conf *key)
 {
 	struct ath5k_softc *sc = hw->priv;
 	int ret = 0;
@@ -3010,7 +3010,8 @@ ath5k_set_key(struct ieee80211_hw *hw, e
 
 	switch (cmd) {
 	case SET_KEY:
-		ret = ath5k_hw_set_key(sc->ah, key->keyidx, key, addr);
+		ret = ath5k_hw_set_key(sc->ah, key->keyidx, key,
+				       sta ? sta->addr : NULL);
 		if (ret) {
 			ATH5K_ERR(sc, "can't set the key\n");
 			goto unlock;
--- everything.orig/drivers/net/wireless/ath9k/main.c	2008-12-08 17:41:24.000000000 +0100
+++ everything/drivers/net/wireless/ath9k/main.c	2008-12-08 18:10:07.000000000 +0100
@@ -724,9 +724,10 @@ static int ath_key_config(struct ath_sof
 {
 	struct ieee80211_vif *vif;
 	struct ath9k_keyval hk;
-	const u8 *mac = NULL;
 	int ret = 0;
 	enum nl80211_iftype opmode;
+	static const u8 bcast_addr[ETH_ALEN] =
+		{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, };
 
 	memset(&hk, 0, sizeof(hk));
 
@@ -767,29 +768,26 @@ static int ath_key_config(struct ath_sof
 	 *   BUT we will plumb a cleartext key so that we can do
 	 *   per-Sta default key table lookup in software.
 	 */
-	if (is_broadcast_ether_addr(addr)) {
+	if (!addr) {
 		switch (opmode) {
 		case NL80211_IFTYPE_STATION:
 			/* default key:  could be group WPA key
 			 * or could be static WEP key */
-			mac = NULL;
 			break;
 		case NL80211_IFTYPE_ADHOC:
-			break;
 		case NL80211_IFTYPE_AP:
+			addr = bcast_addr;
 			break;
 		default:
 			ASSERT(0);
 			break;
 		}
-	} else {
-		mac = addr;
 	}
 
 	if (key->alg == ALG_TKIP)
-		ret = ath_setkey_tkip(sc, key, &hk, mac);
+		ret = ath_setkey_tkip(sc, key, &hk, addr);
 	else
-		ret = ath_keyset(sc, key->keyidx, &hk, mac);
+		ret = ath_keyset(sc, key->keyidx, &hk, addr);
 
 	if (!ret)
 		return -EIO;
@@ -2302,8 +2300,8 @@ static int ath9k_conf_tx(struct ieee8021
 
 static int ath9k_set_key(struct ieee80211_hw *hw,
 			 enum set_key_cmd cmd,
-			 const u8 *local_addr,
-			 const u8 *addr,
+			 struct ieee80211_vif *vif,
+			 struct ieee80211_sta *sta,
 			 struct ieee80211_key_conf *key)
 {
 	struct ath_softc *sc = hw->priv;
@@ -2313,7 +2311,7 @@ static int ath9k_set_key(struct ieee8021
 
 	switch (cmd) {
 	case SET_KEY:
-		ret = ath_key_config(sc, addr, key);
+		ret = ath_key_config(sc, sta ? sta->addr : NULL, key);
 		if (!ret) {
 			set_bit(key->keyidx, sc->sc_keymap);
 			key->hw_key_idx = key->keyidx;
--- everything.orig/drivers/net/wireless/b43/main.c	2008-12-08 17:42:05.000000000 +0100
+++ everything/drivers/net/wireless/b43/main.c	2008-12-08 17:49:40.000000000 +0100
@@ -3508,8 +3508,8 @@ static void b43_op_bss_info_changed(stru
 }
 
 static int b43_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
-			   const u8 *local_addr, const u8 *addr,
-			   struct ieee80211_key_conf *key)
+			  struct ieee80211_vif *vif, struct ieee80211_sta *sta,
+			  struct ieee80211_key_conf *key)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev;
@@ -3567,17 +3567,13 @@ static int b43_op_set_key(struct ieee802
 			goto out_unlock;
 		}
 
-		if (is_broadcast_ether_addr(addr)) {
+		if (!sta) {
 			/* addr is FF:FF:FF:FF:FF:FF for default keys */
 			err = b43_key_write(dev, index, algorithm,
 					    key->key, key->keylen, NULL, key);
 		} else {
-			/*
-			 * either pairwise key or address is 00:00:00:00:00:00
-			 * for transmit-only keys
-			 */
-			err = b43_key_write(dev, -1, algorithm,
-					    key->key, key->keylen, addr, key);
+			err = b43_key_write(dev, -1, algorithm, key->key,
+					    key->keylen, sta->addr, key);
 		}
 		if (err)
 			goto out_unlock;
@@ -3604,10 +3600,12 @@ out_unlock:
 	spin_unlock_irqrestore(&wl->irq_lock, flags);
 	mutex_unlock(&wl->mutex);
 	if (!err) {
+		static const u8 bcast_addr[ETH_ALEN] =
+			{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
 		b43dbg(wl, "%s hardware based encryption for keyidx: %d, "
 		       "mac: %s\n",
 		       cmd == SET_KEY ? "Using" : "Disabling", key->keyidx,
-		       print_mac(mac, addr));
+		       print_mac(mac, sta ? sta->addr : bcast_addr));
 	}
 	return err;
 }
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-12-08 17:46:45.000000000 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-12-08 18:13:37.000000000 +0100
@@ -3039,7 +3039,8 @@ static void iwl_mac_update_tkip_key(stru
 }
 
 static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
-			   const u8 *local_addr, const u8 *addr,
+			   struct ieee80211_vif *vif,
+			   struct ieee80211_sta *sta,
 			   struct ieee80211_key_conf *key)
 {
 	struct iwl_priv *priv = hw->priv;
@@ -3047,6 +3048,9 @@ static int iwl_mac_set_key(struct ieee80
 	int ret = 0;
 	u8 sta_id = IWL_INVALID_STATION;
 	u8 is_default_wep_key = 0;
+	static const u8 bcast_addr[ETH_ALEN] =
+		{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, };
+	static const u8 *addr;
 
 	IWL_DEBUG_MAC80211("enter\n");
 
@@ -3055,9 +3059,7 @@ static int iwl_mac_set_key(struct ieee80
 		return -EOPNOTSUPP;
 	}
 
-	if (is_zero_ether_addr(addr))
-		/* only support pairwise keys */
-		return -EOPNOTSUPP;
+	addr = sta ? sta->addr : bcast_addr;
 
 	sta_id = iwl_find_station(priv, addr);
 	if (sta_id == IWL_INVALID_STATION) {
--- everything.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-12-08 17:46:16.000000000 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-12-08 18:14:45.000000000 +0100
@@ -7033,12 +7033,16 @@ out_unlock:
 }
 
 static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
-			   const u8 *local_addr, const u8 *addr,
-			   struct ieee80211_key_conf *key)
+			       struct ieee80211_vif *vif,
+			       struct ieee80211_sta *sta,
+			       struct ieee80211_key_conf *key)
 {
 	struct iwl3945_priv *priv = hw->priv;
 	int rc = 0;
 	u8 sta_id;
+	static const u8 bcast_addr[ETH_ALEN] =
+		{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, };
+	const u8 *addr;
 
 	IWL_DEBUG_MAC80211("enter\n");
 
@@ -7047,9 +7051,7 @@ static int iwl3945_mac_set_key(struct ie
 		return -EOPNOTSUPP;
 	}
 
-	if (is_zero_ether_addr(addr))
-		/* only support pairwise keys */
-		return -EOPNOTSUPP;
+	addr = sta ? sta->addr : bcast_addr;
 
 	sta_id = iwl3945_hw_find_station(priv, addr);
 	if (sta_id == IWL_INVALID_STATION) {
--- everything.orig/drivers/net/wireless/p54/p54common.c	2008-12-08 17:47:11.000000000 +0100
+++ everything/drivers/net/wireless/p54/p54common.c	2008-12-08 17:53:09.000000000 +0100
@@ -1938,7 +1938,7 @@ static void p54_bss_info_changed(struct 
 }
 
 static int p54_set_key(struct ieee80211_hw *dev, enum set_key_cmd cmd,
-		       const u8 *local_address, const u8 *address,
+		       struct ieee80211_vif *vif, struct ieee80211_sta *sta,
 		       struct ieee80211_key_conf *key)
 {
 	struct p54_common *priv = dev->priv;
@@ -2002,8 +2002,8 @@ static int p54_set_key(struct ieee80211_
 	rxkey->entry = key->keyidx;
 	rxkey->key_id = key->keyidx;
 	rxkey->key_type = algo;
-	if (address)
-		memcpy(rxkey->mac, address, ETH_ALEN);
+	if (sta)
+		memcpy(rxkey->mac, sta->addr, ETH_ALEN);
 	else
 		memset(rxkey->mac, ~0, ETH_ALEN);
 	if (key->alg != ALG_TKIP) {
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00.h	2008-12-08 17:47:42.000000000 +0100
+++ everything/drivers/net/wireless/rt2x00/rt2x00.h	2008-12-08 17:47:52.000000000 +0100
@@ -982,7 +982,7 @@ void rt2x00mac_configure_filter(struct i
 				int mc_count, struct dev_addr_list *mc_list);
 #ifdef CONFIG_RT2X00_LIB_CRYPTO
 int rt2x00mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
-		      const u8 *local_address, const u8 *address,
+		      struct ieee80211_vif *vif, struct ieee80211_sta *sta,
 		      struct ieee80211_key_conf *key);
 #else
 #define rt2x00mac_set_key	NULL
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00mac.c	2008-12-08 17:48:03.000000000 +0100
+++ everything/drivers/net/wireless/rt2x00/rt2x00mac.c	2008-12-08 17:57:43.000000000 +0100
@@ -483,15 +483,17 @@ EXPORT_SYMBOL_GPL(rt2x00mac_configure_fi
 
 #ifdef CONFIG_RT2X00_LIB_CRYPTO
 int rt2x00mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
-		      const u8 *local_address, const u8 *address,
+		      struct ieee80211_vif *vif, struct ieee80211_sta *sta,
 		      struct ieee80211_key_conf *key)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct ieee80211_sta *sta;
+	struct rt2x00_intf *intf = vif_to_intf(vif);
 	int (*set_key) (struct rt2x00_dev *rt2x00dev,
 			struct rt2x00lib_crypto *crypto,
 			struct ieee80211_key_conf *key);
 	struct rt2x00lib_crypto crypto;
+	static const u8 bcast_addr[ETH_ALEN] =
+		{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, };
 
 	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
 		return 0;
@@ -509,15 +511,14 @@ int rt2x00mac_set_key(struct ieee80211_h
 	if (rt2x00dev->intf_sta_count)
 		crypto.bssidx = 0;
 	else
-		crypto.bssidx =
-		    local_address[5] & (rt2x00dev->ops->max_ap_intf - 1);
+		crypto.bssidx = intf->mac[5] & (rt2x00dev->ops->max_ap_intf - 1);
 
 	crypto.cipher = rt2x00crypto_key_to_cipher(key);
 	if (crypto.cipher == CIPHER_NONE)
 		return -EOPNOTSUPP;
 
 	crypto.cmd = cmd;
-	crypto.address = address;
+	crypto.address = sta ? sta->addr : bcast_addr;
 
 	if (crypto.cipher == CIPHER_TKIP) {
 		if (key->keylen > NL80211_TKIP_DATA_OFFSET_ENCR_KEY)
@@ -542,11 +543,8 @@ int rt2x00mac_set_key(struct ieee80211_h
 	 * Some drivers need this information when updating the
 	 * hardware key (either adding or removing).
 	 */
-	rcu_read_lock();
-	sta = ieee80211_find_sta(hw, address);
 	if (sta)
 		crypto.aid = sta->aid;
-	rcu_read_unlock();
 
 	/*
 	 * Each BSS has a maximum of 4 shared keys.


