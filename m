Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37948 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab3J2KDJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Oct 2013 06:03:09 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi, Max Stepanov <Max.Stepanov@intel.com>
Subject: [RFC] mac80211: add generic cipher scheme support
Date: Tue, 29 Oct 2013 11:03:04 +0100
Message-Id: <1383040984-26552-1-git-send-email-johannes@sipsolutions.net> (sfid-20131029_110323_061873_35DF7F38)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Max Stepanov <Max.Stepanov@intel.com>

This adds generic cipher scheme support to mac80211, such schemes
are fully under control by the driver. On hw registration drivers
may specify additional HW ciphers with a scheme how these ciphers
have to be handled by mac80211 TX/RR. A cipher scheme specifies a
cipher suite value, a size of the security header to be added to
or stripped from frames and how the PN is to be verified on RX.

Signed-off-by: Max Stepanov <Max.Stepanov@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     |  36 +++++++++++
 net/mac80211/cfg.c         |  31 ++++++++--
 net/mac80211/ieee80211_i.h |  10 ++++
 net/mac80211/iface.c       |   5 ++
 net/mac80211/key.c         |  58 +++++++++++-------
 net/mac80211/key.h         |  13 +++-
 net/mac80211/main.c        | 145 +++++++++++++++++++++++++++++++--------------
 net/mac80211/mesh_hwmp.c   |   4 +-
 net/mac80211/mlme.c        |   4 ++
 net/mac80211/rx.c          |  65 +++++++++++++++-----
 net/mac80211/sta_info.h    |  10 +++-
 net/mac80211/tx.c          |  14 +++--
 net/mac80211/util.c        |  68 +++++++++++++++++++++
 net/mac80211/wpa.c         | 116 ++++++++++++++++++++++++++++++++++++
 net/mac80211/wpa.h         |   2 +
 15 files changed, 480 insertions(+), 101 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7ceed99..cca02b2 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1229,6 +1229,36 @@ struct ieee80211_key_conf {
 };
 
 /**
+ * struct ieee80211_cipher_scheme - cipher scheme
+ *
+ * This structure contains a cipher scheme information defining
+ * the secure packet crypto handling.
+ *
+ * @cipher: a cipher suite selector
+ * @iftype: a cipher iftype bit mask indicating an allowed cipher usage
+ * @hdr_len: a length of a security header used the cipher
+ * @pn_len: a length of a packet number in the security header
+ * @pn_off: an offset of pn from the beginning of the security header
+ * @key_idx_off: an offset of key index byte in the security header
+ * @key_idx_mask: a bit mask of key_idx bits
+ * @key_idx_shift: a bit shift needed to get key_idx
+ *     key_idx value calculation:
+ *      (sec_header_base[key_idx_off] & key_idx_mask) >> key_idx_shift
+ * @mic_len: a mic length in bytes
+ */
+struct ieee80211_cipher_scheme {
+	u32 cipher;
+	u16 iftype;
+	u8 hdr_len;
+	u8 pn_len;
+	u8 pn_off;
+	u8 key_idx_off;
+	u8 key_idx_mask;
+	u8 key_idx_shift;
+	u8 mic_len;
+};
+
+/**
  * enum set_key_cmd - key command
  *
  * Used with the set_key() callback in &struct ieee80211_ops, this
@@ -1636,6 +1666,10 @@ enum ieee80211_hw_flags {
  * @uapsd_max_sp_len: maximum number of total buffered frames the WMM AP may
  *	deliver to a WMM STA during any Service Period triggered by the WMM STA.
  *	Use IEEE80211_WMM_IE_STA_QOSINFO_SP_* for correct values.
+ *
+ * @n_cipher_schemes: a size of an array of cipher schemes definitions.
+ * @cipher_schemes: a pointer to an array of cipher scheme definitions
+ *	supported by HW.
  */
 struct ieee80211_hw {
 	struct ieee80211_conf conf;
@@ -1663,6 +1697,8 @@ struct ieee80211_hw {
 	netdev_features_t netdev_features;
 	u8 uapsd_queues;
 	u8 uapsd_max_sp_len;
+	u8 n_cipher_schemes;
+	const struct ieee80211_cipher_scheme *cipher_schemes;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index ed1e9a8..f2bbe3d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -133,7 +133,9 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 			     struct key_params *params)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta = NULL;
+	const struct ieee80211_cipher_scheme *cs = NULL;
 	struct ieee80211_key *key;
 	int err;
 
@@ -145,22 +147,28 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_TKIP:
 	case WLAN_CIPHER_SUITE_WEP104:
-		if (IS_ERR(sdata->local->wep_tx_tfm))
+		if (IS_ERR(local->wep_tx_tfm))
 			return -EINVAL;
 		break;
+	case WLAN_CIPHER_SUITE_CCMP:
+	case WLAN_CIPHER_SUITE_AES_CMAC:
+	case WLAN_CIPHER_SUITE_GCMP:
+		break;
 	default:
+		cs = ieee80211_cs_get(local, params->cipher, sdata->vif.type);
 		break;
 	}
 
 	key = ieee80211_key_alloc(params->cipher, key_idx, params->key_len,
-				  params->key, params->seq_len, params->seq);
+				  params->key, params->seq_len, params->seq,
+				  cs);
 	if (IS_ERR(key))
 		return PTR_ERR(key);
 
 	if (pairwise)
 		key->conf.flags |= IEEE80211_KEY_FLAG_PAIRWISE;
 
-	mutex_lock(&sdata->local->sta_mtx);
+	mutex_lock(&local->sta_mtx);
 
 	if (mac_addr) {
 		if (ieee80211_vif_is_mesh(&sdata->vif))
@@ -216,10 +224,13 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 		break;
 	}
 
+	if (sta)
+		sta->cipher_scheme = cs;
+
 	err = ieee80211_key_link(key, sdata, sta);
 
  out_unlock:
-	mutex_unlock(&sdata->local->sta_mtx);
+	mutex_unlock(&local->sta_mtx);
 
 	return err;
 }
@@ -244,7 +255,7 @@ static int ieee80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 			goto out_unlock;
 
 		if (pairwise)
-			key = key_mtx_dereference(local, sta->ptk);
+			key = key_mtx_dereference(local, sta->ptk[key_idx]);
 		else
 			key = key_mtx_dereference(local, sta->gtk[key_idx]);
 	} else
@@ -291,7 +302,7 @@ static int ieee80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 			goto out;
 
 		if (pairwise)
-			key = rcu_dereference(sta->ptk);
+			key = rcu_dereference(sta->ptk[key_idx]);
 		else if (key_idx < NUM_DEFAULT_KEYS)
 			key = rcu_dereference(sta->gtk[key_idx]);
 	} else
@@ -968,11 +979,19 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	 */
 	sdata->control_port_protocol = params->crypto.control_port_ethertype;
 	sdata->control_port_no_encrypt = params->crypto.control_port_no_encrypt;
+	sdata->encrypt_headroom = ieee80211_cs_headroom(sdata->local,
+							&params->crypto,
+							sdata->vif.type);
+
 	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list) {
 		vlan->control_port_protocol =
 			params->crypto.control_port_ethertype;
 		vlan->control_port_no_encrypt =
 			params->crypto.control_port_no_encrypt;
+		vlan->encrypt_headroom =
+			ieee80211_cs_headroom(sdata->local,
+					      &params->crypto,
+					      vlan->vif.type);
 	}
 
 	sdata->vif.bss_conf.beacon_int = params->beacon_interval;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 5cfa160..de1bb78 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -727,6 +727,7 @@ struct ieee80211_sub_if_data {
 	u16 sequence_number;
 	__be16 control_port_protocol;
 	bool control_port_no_encrypt;
+	int encrypt_headroom;
 
 	struct ieee80211_tx_queue_params tx_conf[IEEE80211_NUM_ACS];
 
@@ -1745,6 +1746,15 @@ void ieee80211_dfs_radar_detected_work(struct work_struct *work);
 int ieee80211_send_action_csa(struct ieee80211_sub_if_data *sdata,
 			      struct cfg80211_csa_settings *csa_settings);
 
+bool ieee80211_cs_valid(const struct ieee80211_cipher_scheme *cs);
+bool ieee80211_cs_list_valid(const struct ieee80211_cipher_scheme *cs, int n);
+const struct ieee80211_cipher_scheme *
+ieee80211_cs_get(struct ieee80211_local *local, u32 cipher,
+		 enum nl80211_iftype iftype);
+int ieee80211_cs_headroom(struct ieee80211_local *local,
+			  struct cfg80211_crypto_settings *crypto,
+			  enum nl80211_iftype iftype);
+
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
 #else
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index ff101ea..ad28e3d 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -401,6 +401,8 @@ int ieee80211_add_virtual_monitor(struct ieee80211_local *local)
 	snprintf(sdata->name, IFNAMSIZ, "%s-monitor",
 		 wiphy_name(local->hw.wiphy));
 
+	sdata->encrypt_headroom = IEEE80211_ENCRYPT_HEADROOM;
+
 	ieee80211_set_default_queues(sdata);
 
 	ret = drv_add_interface(local, sdata);
@@ -1270,6 +1272,7 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 
 	sdata->control_port_protocol = cpu_to_be16(ETH_P_PAE);
 	sdata->control_port_no_encrypt = false;
+	sdata->encrypt_headroom = IEEE80211_ENCRYPT_HEADROOM;
 
 	sdata->noack_map = 0;
 
@@ -1686,6 +1689,8 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 	sdata->ap_power_level = IEEE80211_UNSET_POWER_LEVEL;
 	sdata->user_power_level = local->user_power_level;
 
+	sdata->encrypt_headroom = IEEE80211_ENCRYPT_HEADROOM;
+
 	/* setup type-dependent data */
 	ieee80211_setup_sdata(sdata, type);
 
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index ab84680..e568d98 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -267,22 +267,22 @@ static void ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 	if (new)
 		list_add_tail(&new->list, &sdata->key_list);
 
-	if (sta && pairwise) {
-		rcu_assign_pointer(sta->ptk, new);
-	} else if (sta) {
-		if (old)
-			idx = old->conf.keyidx;
-		else
-			idx = new->conf.keyidx;
-		rcu_assign_pointer(sta->gtk[idx], new);
-	} else {
-		WARN_ON(new && old && new->conf.keyidx != old->conf.keyidx);
+	WARN_ON(new && old && new->conf.keyidx != old->conf.keyidx);
 
-		if (old)
-			idx = old->conf.keyidx;
-		else
-			idx = new->conf.keyidx;
+	if (old)
+		idx = old->conf.keyidx;
+	else
+		idx = new->conf.keyidx;
 
+	if (sta) {
+		if (pairwise) {
+			rcu_assign_pointer(sta->ptk[idx], new);
+			sta->ptk_idx = idx;
+		} else {
+			rcu_assign_pointer(sta->gtk[idx], new);
+			sta->gtk_idx = idx;
+		}
+	} else {
 		defunikey = old &&
 			old == key_mtx_dereference(sdata->local,
 						sdata->default_unicast_key);
@@ -316,9 +316,11 @@ static void ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 		list_del(&old->list);
 }
 
-struct ieee80211_key *ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
-					  const u8 *key_data,
-					  size_t seq_len, const u8 *seq)
+struct ieee80211_key *
+ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
+		    const u8 *key_data,
+		    size_t seq_len, const u8 *seq,
+		    const struct ieee80211_cipher_scheme *cs)
 {
 	struct ieee80211_key *key;
 	int i, j, err;
@@ -397,6 +399,18 @@ struct ieee80211_key *ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 			return ERR_PTR(err);
 		}
 		break;
+	default:
+		if (cs) {
+			size_t len = (seq_len > MAX_PN_LEN) ?
+						MAX_PN_LEN : seq_len;
+
+			key->conf.iv_len = cs->hdr_len;
+			key->conf.icv_len = cs->mic_len;
+			for (i = 0; i < IEEE80211_NUM_TIDS + 1; i++)
+				for (j = 0; j < len; j++)
+					key->u.gen.rx_pn[i][j] =
+							seq[len - j - 1];
+		}
 	}
 	memcpy(key->conf.key, key_data, key_len);
 	INIT_LIST_HEAD(&key->list);
@@ -479,7 +493,7 @@ int ieee80211_key_link(struct ieee80211_key *key,
 	mutex_lock(&sdata->local->key_mtx);
 
 	if (sta && pairwise)
-		old_key = key_mtx_dereference(sdata->local, sta->ptk);
+		old_key = key_mtx_dereference(sdata->local, sta->ptk[idx]);
 	else if (sta)
 		old_key = key_mtx_dereference(sdata->local, sta->gtk[idx]);
 	else
@@ -629,8 +643,10 @@ void ieee80211_free_sta_keys(struct ieee80211_local *local,
 		list_add(&key->list, &keys);
 	}
 
-	key = key_mtx_dereference(local, sta->ptk);
-	if (key) {
+	for (i = 0; i < NUM_DEFAULT_KEYS; i++) {
+		key = key_mtx_dereference(local, sta->ptk[i]);
+		if (!key)
+			continue;
 		ieee80211_key_replace(key->sdata, key->sta,
 				key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE,
 				key, NULL);
@@ -881,7 +897,7 @@ ieee80211_gtk_rekey_add(struct ieee80211_vif *vif,
 
 	key = ieee80211_key_alloc(keyconf->cipher, keyconf->keyidx,
 				  keyconf->keylen, keyconf->key,
-				  0, NULL);
+				  0, NULL, NULL);
 	if (IS_ERR(key))
 		return ERR_CAST(key);
 
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index aaae0ed..0aebb88 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -18,6 +18,7 @@
 
 #define NUM_DEFAULT_KEYS 4
 #define NUM_DEFAULT_MGMT_KEYS 2
+#define MAX_PN_LEN 16
 
 struct ieee80211_local;
 struct ieee80211_sub_if_data;
@@ -93,6 +94,10 @@ struct ieee80211_key {
 			u32 replays; /* dot11RSNAStatsCMACReplays */
 			u32 icverrors; /* dot11RSNAStatsCMACICVErrors */
 		} aes_cmac;
+		struct {
+			/* generic cipher scheme */
+			u8 rx_pn[IEEE80211_NUM_TIDS + 1][MAX_PN_LEN];
+		} gen;
 	} u;
 
 	/* number of times this key has been used */
@@ -113,9 +118,11 @@ struct ieee80211_key {
 	struct ieee80211_key_conf conf;
 };
 
-struct ieee80211_key *ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
-					  const u8 *key_data,
-					  size_t seq_len, const u8 *seq);
+struct ieee80211_key *
+ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
+		    const u8 *key_data,
+		    size_t seq_len, const u8 *seq,
+		    const struct ieee80211_cipher_scheme *cs);
 /*
  * Insert a key into data structures (sdata, sta if necessary)
  * to make it used, free old key. On failure, also free the new key.
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 21d5d44..bdb0b6c 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -651,15 +651,14 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 }
 EXPORT_SYMBOL(ieee80211_alloc_hw);
 
-int ieee80211_register_hw(struct ieee80211_hw *hw)
+static int ieee80211_init_cipher_suites(struct ieee80211_local *local)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
-	int result, i;
-	enum ieee80211_band band;
-	int channels, max_bitrates;
-	bool supp_ht, supp_vht;
-	netdev_features_t feature_whitelist;
-	struct cfg80211_chan_def dflt_chandef = {};
+	bool have_wep = !(IS_ERR(local->wep_tx_tfm) ||
+			  IS_ERR(local->wep_rx_tfm));
+	bool have_mfp = local->hw.flags & IEEE80211_HW_MFP_CAPABLE;
+	const struct ieee80211_cipher_scheme *cs = local->hw.cipher_schemes;
+	int n_suites = 0, r = 0, w = 0;
+	u32 *suites;
 	static const u32 cipher_suites[] = {
 		/* keep WEP first, it may be removed below */
 		WLAN_CIPHER_SUITE_WEP40,
@@ -671,6 +670,93 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		WLAN_CIPHER_SUITE_AES_CMAC
 	};
 
+	/* Driver specifies the ciphers, we have nothing to do... */
+	if (local->hw.wiphy->cipher_suites && have_wep)
+		return 0;
+
+	/* Set up cipher suites if driver relies on mac80211 cipher defs */
+	if (!local->hw.wiphy->cipher_suites && !cs) {
+		local->hw.wiphy->cipher_suites = cipher_suites;
+		local->hw.wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
+
+		if (!have_mfp)
+			local->hw.wiphy->n_cipher_suites--;
+
+		if (!have_wep) {
+			local->hw.wiphy->cipher_suites += 2;
+			local->hw.wiphy->n_cipher_suites -= 2;
+		}
+
+		return 0;
+	}
+
+	if (!local->hw.wiphy->cipher_suites) {
+		/*
+		 * Driver specifies cipher schemes only
+		 * We start counting ciphers defined by schemes, TKIP and CCMP
+		 */
+		n_suites = local->hw.n_cipher_schemes + 2;
+
+		/* check if we have WEP40 and WEP104 */
+		if (have_wep)
+			n_suites += 2;
+
+		/* check if we have AES_CMAC */
+		if (have_mfp)
+			n_suites++;
+
+		suites = kmalloc(sizeof(u32) * n_suites, GFP_KERNEL);
+		if (!suites)
+			return -ENOMEM;
+
+		suites[w++] = WLAN_CIPHER_SUITE_CCMP;
+		suites[w++] = WLAN_CIPHER_SUITE_TKIP;
+
+		if (have_wep) {
+			suites[w++] = WLAN_CIPHER_SUITE_WEP40;
+			suites[w++] = WLAN_CIPHER_SUITE_WEP104;
+		}
+
+		if (have_mfp)
+			suites[w++] = WLAN_CIPHER_SUITE_AES_CMAC;
+
+		for (r = 0; r < local->hw.n_cipher_schemes; r++)
+			suites[w++] = cs[r].cipher;
+	} else {
+		/* Driver provides cipher suites, but we need to exclude WEP */
+		suites = kmemdup(local->hw.wiphy->cipher_suites,
+				 sizeof(u32) * local->hw.wiphy->n_cipher_suites,
+				 GFP_KERNEL);
+		if (!suites)
+			return -ENOMEM;
+
+		for (r = 0; r < local->hw.wiphy->n_cipher_suites; r++) {
+			u32 suite = local->hw.wiphy->cipher_suites[r];
+
+			if (suite == WLAN_CIPHER_SUITE_WEP40 ||
+			    suite == WLAN_CIPHER_SUITE_WEP104)
+				continue;
+			suites[w++] = suite;
+		}
+	}
+
+	local->hw.wiphy->cipher_suites = suites;
+	local->hw.wiphy->n_cipher_suites = w;
+	local->wiphy_ciphers_allocated = true;
+
+	return 0;
+}
+
+int ieee80211_register_hw(struct ieee80211_hw *hw)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	int result, i;
+	enum ieee80211_band band;
+	int channels, max_bitrates;
+	bool supp_ht, supp_vht;
+	netdev_features_t feature_whitelist;
+	struct cfg80211_chan_def dflt_chandef = {};
+
 	if (hw->flags & IEEE80211_HW_QUEUE_CONTROL &&
 	    (local->hw.offchannel_tx_hw_queue == IEEE80211_INVAL_HW_QUEUE ||
 	     local->hw.offchannel_tx_hw_queue >= local->hw.queues))
@@ -851,43 +937,12 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	if (local->hw.wiphy->max_scan_ie_len)
 		local->hw.wiphy->max_scan_ie_len -= local->scan_ies_len;
 
-	/* Set up cipher suites unless driver already did */
-	if (!local->hw.wiphy->cipher_suites) {
-		local->hw.wiphy->cipher_suites = cipher_suites;
-		local->hw.wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
-		if (!(local->hw.flags & IEEE80211_HW_MFP_CAPABLE))
-			local->hw.wiphy->n_cipher_suites--;
-	}
-	if (IS_ERR(local->wep_tx_tfm) || IS_ERR(local->wep_rx_tfm)) {
-		if (local->hw.wiphy->cipher_suites == cipher_suites) {
-			local->hw.wiphy->cipher_suites += 2;
-			local->hw.wiphy->n_cipher_suites -= 2;
-		} else {
-			u32 *suites;
-			int r, w = 0;
-
-			/* Filter out WEP */
-
-			suites = kmemdup(
-				local->hw.wiphy->cipher_suites,
-				sizeof(u32) * local->hw.wiphy->n_cipher_suites,
-				GFP_KERNEL);
-			if (!suites) {
-				result = -ENOMEM;
-				goto fail_wiphy_register;
-			}
-			for (r = 0; r < local->hw.wiphy->n_cipher_suites; r++) {
-				u32 suite = local->hw.wiphy->cipher_suites[r];
-				if (suite == WLAN_CIPHER_SUITE_WEP40 ||
-				    suite == WLAN_CIPHER_SUITE_WEP104)
-					continue;
-				suites[w++] = suite;
-			}
-			local->hw.wiphy->cipher_suites = suites;
-			local->hw.wiphy->n_cipher_suites = w;
-			local->wiphy_ciphers_allocated = true;
-		}
-	}
+	WARN_ON(!ieee80211_cs_list_valid(local->hw.cipher_schemes,
+					 local->hw.n_cipher_schemes));
+
+	result = ieee80211_init_cipher_suites(local);
+	if (result < 0)
+		goto fail_wiphy_register;
 
 	if (!local->ops->remain_on_channel)
 		local->hw.wiphy->max_remain_on_channel_duration = 5000;
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 486819c..56e0c072 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -254,13 +254,13 @@ int mesh_path_error_tx(struct ieee80211_sub_if_data *sdata,
 		return -EAGAIN;
 
 	skb = dev_alloc_skb(local->tx_headroom +
-			    IEEE80211_ENCRYPT_HEADROOM +
+			    sdata->encrypt_headroom +
 			    IEEE80211_ENCRYPT_TAILROOM +
 			    hdr_len +
 			    2 + 15 /* PERR IE */);
 	if (!skb)
 		return -1;
-	skb_reserve(skb, local->tx_headroom + IEEE80211_ENCRYPT_HEADROOM);
+	skb_reserve(skb, local->tx_headroom + sdata->encrypt_headroom);
 	mgmt = (struct ieee80211_mgmt *) skb_put(skb, hdr_len);
 	memset(mgmt, 0, hdr_len);
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 5b2b0a1..98d6d1e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1745,6 +1745,8 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 
 	ifmgd->flags = 0;
 	ieee80211_vif_release_channel(sdata);
+
+	sdata->encrypt_headroom = IEEE80211_ENCRYPT_HEADROOM;
 }
 
 void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
@@ -4112,6 +4114,8 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 
 	sdata->control_port_protocol = req->crypto.control_port_ethertype;
 	sdata->control_port_no_encrypt = req->crypto.control_port_no_encrypt;
+	sdata->encrypt_headroom = ieee80211_cs_headroom(local, &req->crypto,
+							sdata->vif.type);
 
 	/* kick off associate process */
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 23f49e8..e1b71d8 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -638,6 +638,27 @@ static int ieee80211_get_mmie_keyidx(struct sk_buff *skb)
 	return le16_to_cpu(mmie->key_id);
 }
 
+static int iwl80211_get_cs_keyid(const struct ieee80211_cipher_scheme *cs,
+				 struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	__le16 fc;
+	int hdrlen;
+	u8 keyid;
+
+	fc = hdr->frame_control;
+	hdrlen = ieee80211_hdrlen(fc);
+
+	if (skb->len < hdrlen + cs->hdr_len)
+		return -EINVAL;
+
+	skb_copy_bits(skb, hdrlen + cs->key_idx_off, &keyid, 1);
+	keyid &= cs->key_idx_mask;
+	keyid >>= cs->key_idx_shift;
+
+	return keyid;
+}
+
 static ieee80211_rx_result ieee80211_rx_mesh_check(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
@@ -1368,6 +1389,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 	struct ieee80211_key *sta_ptk = NULL;
 	int mmie_keyidx = -1;
 	__le16 fc;
+	const struct ieee80211_cipher_scheme *cs = NULL;
 
 	/*
 	 * Key selection 101
@@ -1405,11 +1427,19 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 
 	/* start without a key */
 	rx->key = NULL;
+	fc = hdr->frame_control;
 
-	if (rx->sta)
-		sta_ptk = rcu_dereference(rx->sta->ptk);
+	if (rx->sta) {
+		int keyid = rx->sta->ptk_idx;
 
-	fc = hdr->frame_control;
+		if (ieee80211_has_protected(fc) && rx->sta->cipher_scheme) {
+			cs = rx->sta->cipher_scheme;
+			keyid = iwl80211_get_cs_keyid(cs, rx->skb);
+			if (unlikely(keyid < 0))
+				return RX_DROP_UNUSABLE;
+		}
+		sta_ptk = rcu_dereference(rx->sta->ptk[keyid]);
+	}
 
 	if (!ieee80211_has_protected(fc))
 		mmie_keyidx = ieee80211_get_mmie_keyidx(rx->skb);
@@ -1471,6 +1501,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 		return RX_CONTINUE;
 	} else {
 		u8 keyid;
+
 		/*
 		 * The device doesn't give us the IV so we won't be
 		 * able to look up the key. That's ok though, we
@@ -1486,15 +1517,21 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 
 		hdrlen = ieee80211_hdrlen(fc);
 
-		if (rx->skb->len < 8 + hdrlen)
-			return RX_DROP_UNUSABLE; /* TODO: count this? */
+		if (cs) {
+			keyidx = iwl80211_get_cs_keyid(cs, rx->skb);
 
-		/*
-		 * no need to call ieee80211_wep_get_keyidx,
-		 * it verifies a bunch of things we've done already
-		 */
-		skb_copy_bits(rx->skb, hdrlen + 3, &keyid, 1);
-		keyidx = keyid >> 6;
+			if (unlikely(keyidx < 0))
+				return RX_DROP_UNUSABLE;
+		} else {
+			if (rx->skb->len < 8 + hdrlen)
+				return RX_DROP_UNUSABLE; /* TODO: count this? */
+			/*
+			 * no need to call ieee80211_wep_get_keyidx,
+			 * it verifies a bunch of things we've done already
+			 */
+			skb_copy_bits(rx->skb, hdrlen + 3, &keyid, 1);
+			keyidx = keyid >> 6;
+		}
 
 		/* check per-station GTK first, if multicast packet */
 		if (is_multicast_ether_addr(hdr->addr1) && rx->sta)
@@ -1542,11 +1579,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 		result = ieee80211_crypto_aes_cmac_decrypt(rx);
 		break;
 	default:
-		/*
-		 * We can reach here only with HW-only algorithms
-		 * but why didn't it decrypt the frame?!
-		 */
-		return RX_DROP_UNUSABLE;
+		result = ieee80211_crypto_hw_decrypt(rx);
 	}
 
 	/* the hdr variable is invalid after the decrypt handlers */
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 3ef06a2..6b0d6c2 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -231,8 +231,10 @@ struct sta_ampdu_mlme {
  * @hnext: hash table linked list pointer
  * @local: pointer to the global information
  * @sdata: virtual interface this station belongs to
- * @ptk: peer key negotiated with this station, if any
+ * @ptk: peer keys negotiated with this station, if any
+ * @ptk_idx: last installed peer key index
  * @gtk: group keys negotiated with this station, if any
+ * @gtk_idx: last installed group key index
  * @rate_ctrl: rate control algorithm reference
  * @rate_ctrl_priv: rate control private per-STA pointer
  * @last_tx_rate: rate used for last transmit, to report to userspace as
@@ -303,6 +305,7 @@ struct sta_ampdu_mlme {
  * @chain_signal_avg: signal average (per chain)
  * @known_smps_mode: the smps_mode the client thinks we are in. Relevant for
  *	AP only.
+ * @cipher_scheme: optional cipher scheme for this station
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -312,7 +315,9 @@ struct sta_info {
 	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_key __rcu *gtk[NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS];
-	struct ieee80211_key __rcu *ptk;
+	struct ieee80211_key __rcu *ptk[NUM_DEFAULT_KEYS];
+	u8 gtk_idx;
+	u8 ptk_idx;
 	struct rate_control_ref *rate_ctrl;
 	void *rate_ctrl_priv;
 	spinlock_t lock;
@@ -414,6 +419,7 @@ struct sta_info {
 	unsigned int beacon_loss_count;
 
 	enum ieee80211_smps_mode known_smps_mode;
+	const struct ieee80211_cipher_scheme *cipher_scheme;
 
 	/* keep last! */
 	struct ieee80211_sta sta;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 9868cb7..e84627f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -557,7 +557,8 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 
 	if (unlikely(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT))
 		tx->key = NULL;
-	else if (tx->sta && (key = rcu_dereference(tx->sta->ptk)))
+	else if (tx->sta &&
+		 (key = rcu_dereference(tx->sta->ptk[tx->sta->ptk_idx])))
 		tx->key = key;
 	else if (ieee80211_is_mgmt(hdr->frame_control) &&
 		 is_multicast_ether_addr(hdr->addr1) &&
@@ -840,15 +841,16 @@ static int ieee80211_fragment(struct ieee80211_tx_data *tx,
 		rem -= fraglen;
 		tmp = dev_alloc_skb(local->tx_headroom +
 				    frag_threshold +
-				    IEEE80211_ENCRYPT_HEADROOM +
+				    tx->sdata->encrypt_headroom +
 				    IEEE80211_ENCRYPT_TAILROOM);
 		if (!tmp)
 			return -ENOMEM;
 
 		__skb_queue_tail(&tx->skbs, tmp);
 
-		skb_reserve(tmp, local->tx_headroom +
-				 IEEE80211_ENCRYPT_HEADROOM);
+		skb_reserve(tmp,
+			    local->tx_headroom + tx->sdata->encrypt_headroom);
+
 		/* copy control information */
 		memcpy(tmp->cb, skb->cb, sizeof(tmp->cb));
 
@@ -1484,7 +1486,7 @@ void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
 
 	headroom = local->tx_headroom;
 	if (may_encrypt)
-		headroom += IEEE80211_ENCRYPT_HEADROOM;
+		headroom += sdata->encrypt_headroom;
 	headroom -= skb_headroom(skb);
 	headroom = max_t(int, 0, headroom);
 
@@ -2108,7 +2110,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	 */
 
 	if (head_need > 0 || skb_cloned(skb)) {
-		head_need += IEEE80211_ENCRYPT_HEADROOM;
+		head_need += sdata->encrypt_headroom;
 		head_need += local->tx_headroom;
 		head_need = max_t(int, 0, head_need);
 		if (ieee80211_skb_resize(sdata, skb, head_need, true)) {
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index a38d582..17a12cd 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2471,3 +2471,71 @@ int ieee80211_send_action_csa(struct ieee80211_sub_if_data *sdata,
 	ieee80211_tx_skb(sdata, skb);
 	return 0;
 }
+
+bool ieee80211_cs_valid(const struct ieee80211_cipher_scheme *cs)
+{
+	return !(cs == NULL || cs->cipher == 0 ||
+		 cs->hdr_len < cs->pn_len + cs->pn_off ||
+		 cs->hdr_len <= cs->key_idx_off ||
+		 cs->key_idx_shift > 7 ||
+		 cs->key_idx_mask == 0);
+}
+
+bool ieee80211_cs_list_valid(const struct ieee80211_cipher_scheme *cs, int n)
+{
+	int i;
+
+	/* Ensure we have enough iftype bitmap space for all iftype values */
+	WARN_ON((NUM_NL80211_IFTYPES / 8 + 1) > sizeof(cs[0].iftype));
+
+	for (i = 0; i < n; i++)
+		if (!ieee80211_cs_valid(&cs[i]))
+			return false;
+
+	return true;
+}
+
+const struct ieee80211_cipher_scheme *
+ieee80211_cs_get(struct ieee80211_local *local, u32 cipher,
+		 enum nl80211_iftype iftype)
+{
+	const struct ieee80211_cipher_scheme *l = local->hw.cipher_schemes;
+	int n = local->hw.n_cipher_schemes;
+	int i;
+	const struct ieee80211_cipher_scheme *cs = NULL;
+
+	for (i = 0; i < n; i++) {
+		if (l[i].cipher == cipher) {
+			cs = &l[i];
+			break;
+		}
+	}
+
+	if (!cs || !(cs->iftype & BIT(iftype)))
+		return NULL;
+
+	return cs;
+}
+
+int ieee80211_cs_headroom(struct ieee80211_local *local,
+			  struct cfg80211_crypto_settings *crypto,
+			  enum nl80211_iftype iftype)
+{
+	const struct ieee80211_cipher_scheme *cs;
+	int headroom = IEEE80211_ENCRYPT_HEADROOM;
+	int i;
+
+	for (i = 0; i < crypto->n_ciphers_pairwise; i++) {
+		cs = ieee80211_cs_get(local, crypto->ciphers_pairwise[i],
+				      iftype);
+
+		if (cs && headroom < cs->hdr_len)
+			headroom = cs->hdr_len;
+	}
+
+	cs = ieee80211_cs_get(local, crypto->cipher_group, iftype);
+	if (cs && headroom < cs->hdr_len)
+		headroom = cs->hdr_len;
+
+	return headroom;
+}
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index d657282..7313d37 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -545,6 +545,106 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx)
 	return RX_CONTINUE;
 }
 
+static ieee80211_tx_result
+ieee80211_crypto_cs_encrypt(struct ieee80211_tx_data *tx,
+			    struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_key *key = tx->key;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	const struct ieee80211_cipher_scheme *cs = key->sta->cipher_scheme;
+	int hdrlen;
+	u8 *pos;
+
+	if (info->control.hw_key &&
+	    !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE)) {
+		/* hwaccel has no need for preallocated head room */
+		return TX_CONTINUE;
+	}
+
+	if (unlikely(skb_headroom(skb) < cs->hdr_len &&
+		     pskb_expand_head(skb, cs->hdr_len, 0, GFP_ATOMIC)))
+		return TX_DROP;
+
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+
+	pos = skb_push(skb, cs->hdr_len);
+	memmove(pos, pos + cs->hdr_len, hdrlen);
+	skb_set_network_header(skb, skb_network_offset(skb) + cs->hdr_len);
+
+	return TX_CONTINUE;
+}
+
+static inline int ieee80211_crypto_cs_pn_compare(u8 *pn1, u8 *pn2, int len)
+{
+	int i;
+
+	/* pn is little endian */
+	for (i = len - 1; i >= 0; i--) {
+		if (pn1[i] < pn2[i])
+			return -1;
+		else if (pn1[i] > pn2[i])
+			return 1;
+	}
+
+	return 0;
+}
+
+static ieee80211_rx_result
+ieee80211_crypto_cs_decrypt(struct ieee80211_rx_data *rx)
+{
+	struct ieee80211_key *key = rx->key;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
+	const struct ieee80211_cipher_scheme *cs = NULL;
+	int hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
+	int data_len;
+	u8 *rx_pn;
+	u8 *skb_pn;
+	u8 qos_tid;
+
+	if (!rx->sta || !rx->sta->cipher_scheme ||
+	    !(status->flag & RX_FLAG_DECRYPTED))
+		return RX_DROP_UNUSABLE;
+
+	if (!ieee80211_is_data(hdr->frame_control))
+		return RX_CONTINUE;
+
+	cs = rx->sta->cipher_scheme;
+
+	data_len = rx->skb->len - hdrlen - cs->hdr_len;
+
+	if (data_len < 0)
+		return RX_DROP_UNUSABLE;
+
+	if (ieee80211_is_data_qos(hdr->frame_control))
+		qos_tid = *ieee80211_get_qos_ctl(hdr) &
+				IEEE80211_QOS_CTL_TID_MASK;
+	else
+		qos_tid = 0;
+
+	if (skb_linearize(rx->skb))
+		return RX_DROP_UNUSABLE;
+
+	hdr = (struct ieee80211_hdr *)rx->skb->data;
+
+	rx_pn = key->u.gen.rx_pn[qos_tid];
+	skb_pn = rx->skb->data + hdrlen + cs->pn_off;
+
+	if (ieee80211_crypto_cs_pn_compare(skb_pn, rx_pn, cs->pn_len) <= 0)
+		return RX_DROP_UNUSABLE;
+
+	memcpy(rx_pn, skb_pn, cs->pn_len);
+
+	/* remove security header and MIC */
+	if (pskb_trim(rx->skb, rx->skb->len - cs->mic_len))
+		return RX_DROP_UNUSABLE;
+
+	memmove(rx->skb->data + cs->hdr_len, rx->skb->data, hdrlen);
+	skb_pull(rx->skb, cs->hdr_len);
+
+	return RX_CONTINUE;
+}
 
 static void bip_aad(struct sk_buff *skb, u8 *aad)
 {
@@ -685,6 +785,7 @@ ieee80211_crypto_hw_encrypt(struct ieee80211_tx_data *tx)
 {
 	struct sk_buff *skb;
 	struct ieee80211_tx_info *info = NULL;
+	ieee80211_tx_result res;
 
 	skb_queue_walk(&tx->skbs, skb) {
 		info  = IEEE80211_SKB_CB(skb);
@@ -692,9 +793,24 @@ ieee80211_crypto_hw_encrypt(struct ieee80211_tx_data *tx)
 		/* handle hw-only algorithm */
 		if (!info->control.hw_key)
 			return TX_DROP;
+
+		if (tx->key->sta->cipher_scheme) {
+			res = ieee80211_crypto_cs_encrypt(tx, skb);
+			if (res != TX_CONTINUE)
+				return res;
+		}
 	}
 
 	ieee80211_tx_set_protected(tx);
 
 	return TX_CONTINUE;
 }
+
+ieee80211_rx_result
+ieee80211_crypto_hw_decrypt(struct ieee80211_rx_data *rx)
+{
+	if (rx->sta->cipher_scheme)
+		return ieee80211_crypto_cs_decrypt(rx);
+
+	return RX_DROP_UNUSABLE;
+}
diff --git a/net/mac80211/wpa.h b/net/mac80211/wpa.h
index 07e33f8..62e5a12 100644
--- a/net/mac80211/wpa.h
+++ b/net/mac80211/wpa.h
@@ -34,5 +34,7 @@ ieee80211_rx_result
 ieee80211_crypto_aes_cmac_decrypt(struct ieee80211_rx_data *rx);
 ieee80211_tx_result
 ieee80211_crypto_hw_encrypt(struct ieee80211_tx_data *tx);
+ieee80211_rx_result
+ieee80211_crypto_hw_decrypt(struct ieee80211_rx_data *rx);
 
 #endif /* WPA_H */
-- 
1.8.4.rc3

