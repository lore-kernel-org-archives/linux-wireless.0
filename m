Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50453 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761649AbZFOPis (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 11:38:48 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <samuel.ortiz@intel.com>
Subject: [PATCH 08/12][w-t] iwmc3200wifi: cfg80211 key hooks implemetation
Date: Mon, 15 Jun 2009 17:39:24 +0200
Message-Id: <d0337f0d1ddef69bbb0144eb894bafd0580550d6.1245076752.git.samuel@sortiz.org>
In-Reply-To: <87c8d2a38226859644cfd3217366a4e42d9e7d81.1245076752.git.samuel@sortiz.org>
References: <cover.1245076752.git.samuel@sortiz.org>
 <8843005a4ec0cad33483426a4ecc7656bce24243.1245076752.git.samuel@sortiz.org>
 <afbb543a0654cc171faa882457cc603d3f038d27.1245076752.git.samuel@sortiz.org>
 <9b2b9b463d1313b871f56ad77b48b4960653b766.1245076752.git.samuel@sortiz.org>
 <ed1078e3b1524ac3bf3888b0881e40bddc8fb690.1245076752.git.samuel@sortiz.org>
 <99a6f971c65b2fb751206cff9e428eb60037629b.1245076752.git.samuel@sortiz.org>
 <f3d3b8fac2046f9c26773232c585b4c688b8df03.1245076752.git.samuel@sortiz.org>
 <87c8d2a38226859644cfd3217366a4e42d9e7d81.1245076752.git.samuel@sortiz.org>
In-Reply-To: <cover.1245076752.git.samuel@sortiz.org>
References: <cover.1245076752.git.samuel@sortiz.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <samuel.ortiz@intel.com>

This patch implements the new cfg80211 privacy related hooks: add/get/set_key
and the set_default_key one.
With this implementation we can now call the wext-compat *encode* routines and
reduce our own wext code.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/cfg80211.c |  172 ++++++++++++++++
 drivers/net/wireless/iwmc3200wifi/commands.c |   72 +++-----
 drivers/net/wireless/iwmc3200wifi/commands.h |    3 +-
 drivers/net/wireless/iwmc3200wifi/iwm.h      |   14 +-
 drivers/net/wireless/iwmc3200wifi/main.c     |    4 +-
 drivers/net/wireless/iwmc3200wifi/wext.c     |  286 ++------------------------
 6 files changed, 219 insertions(+), 332 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/cfg80211.c b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
index 96f714e..ad62b20 100644
--- a/drivers/net/wireless/iwmc3200wifi/cfg80211.c
+++ b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
@@ -23,6 +23,7 @@
 
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/etherdevice.h>
 #include <linux/wireless.h>
 #include <linux/ieee80211.h>
 #include <net/cfg80211.h>
@@ -130,6 +131,173 @@ static struct ieee80211_supported_band iwm_band_5ghz = {
 	.n_bitrates = iwm_a_rates_size,
 };
 
+static int iwm_key_init(struct iwm_key *key, u8 key_index,
+			const u8 *mac_addr, struct key_params *params)
+{
+	key->hdr.key_idx = key_index;
+	if (!mac_addr || is_broadcast_ether_addr(mac_addr)) {
+		key->hdr.multicast = 1;
+		memset(key->hdr.mac, 0xff, ETH_ALEN);
+	} else {
+		key->hdr.multicast = 0;
+		memcpy(key->hdr.mac, mac_addr, ETH_ALEN);
+	}
+
+	if (params) {
+		if (params->key_len > WLAN_MAX_KEY_LEN ||
+		    params->seq_len > IW_ENCODE_SEQ_MAX_SIZE)
+			return -EINVAL;
+
+		key->cipher = params->cipher;
+		key->key_len = params->key_len;
+		key->seq_len = params->seq_len;
+		memcpy(key->key, params->key, key->key_len);
+		memcpy(key->seq, params->seq, key->seq_len);
+	}
+
+	return 0;
+}
+
+static int iwm_reset_profile(struct iwm_priv *iwm)
+{
+	int ret;
+
+	if (!iwm->umac_profile_active)
+		return 0;
+
+	/*
+	 * If there is a current active profile, but no
+	 * default key, it's not worth trying to associate again.
+	 */
+	if (iwm->default_key < 0)
+		return 0;
+
+	/*
+	 * Here we have an active profile, but a key setting changed.
+	 * We thus have to invalidate the current profile, and push the
+	 * new one. Keys will be pushed when association takes place.
+	 */
+	ret = iwm_invalidate_mlme_profile(iwm);
+	if (ret < 0) {
+		IWM_ERR(iwm, "Couldn't invalidate profile\n");
+		return ret;
+	}
+
+	return iwm_send_mlme_profile(iwm);
+}
+
+static int iwm_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
+				u8 key_index, const u8 *mac_addr,
+				struct key_params *params)
+{
+	struct iwm_priv *iwm = ndev_to_iwm(ndev);
+	struct iwm_key *key = &iwm->keys[key_index];
+	int ret;
+
+	IWM_DBG_WEXT(iwm, DBG, "Adding key for %pM\n", mac_addr);
+
+	memset(key, 0, sizeof(struct iwm_key));
+	ret = iwm_key_init(key, key_index, mac_addr, params);
+	if (ret < 0) {
+		IWM_ERR(iwm, "Invalid key_params\n");
+		return ret;
+	}
+
+	/*
+	 * The WEP keys can be set before or after setting the essid.
+	 * We need to handle both cases by simply pushing the keys after
+	 * we send the profile.
+	 * If the profile is not set yet (i.e. we're pushing keys before
+	 * the essid), we set the cipher appropriately.
+	 * If the profile is set, we havent associated yet because our
+	 * cipher was incorrectly set. So we invalidate and send the
+	 * profile again.
+	 */
+	if (key->cipher == WLAN_CIPHER_SUITE_WEP40 ||
+	    key->cipher == WLAN_CIPHER_SUITE_WEP104) {
+		u8 *ucast_cipher = &iwm->umac_profile->sec.ucast_cipher;
+		u8 *mcast_cipher = &iwm->umac_profile->sec.mcast_cipher;
+
+		IWM_DBG_WEXT(iwm, DBG, "WEP key\n");
+
+		if (key->cipher == WLAN_CIPHER_SUITE_WEP40)
+			*ucast_cipher = *mcast_cipher = UMAC_CIPHER_TYPE_WEP_40;
+		if (key->cipher == WLAN_CIPHER_SUITE_WEP104)
+			*ucast_cipher = *mcast_cipher =
+				UMAC_CIPHER_TYPE_WEP_104;
+
+		return iwm_reset_profile(iwm);
+	}
+
+	return iwm_set_key(iwm, 0, key);
+}
+
+static int iwm_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev,
+				u8 key_index, const u8 *mac_addr, void *cookie,
+				void (*callback)(void *cookie,
+						 struct key_params*))
+{
+	struct iwm_priv *iwm = ndev_to_iwm(ndev);
+	struct iwm_key *key = &iwm->keys[key_index];
+	struct key_params params;
+
+	IWM_DBG_WEXT(iwm, DBG, "Getting key %d\n", key_index);
+
+	memset(&params, 0, sizeof(params));
+
+	params.cipher = key->cipher;
+	params.key_len = key->key_len;
+	params.seq_len = key->seq_len;
+	params.seq = key->seq;
+	params.key = key->key;
+
+	callback(cookie, &params);
+
+	return key->key_len ? 0 : -ENOENT;
+}
+
+
+static int iwm_cfg80211_del_key(struct wiphy *wiphy, struct net_device *ndev,
+				u8 key_index, const u8 *mac_addr)
+{
+	struct iwm_priv *iwm = ndev_to_iwm(ndev);
+	struct iwm_key *key = &iwm->keys[key_index];
+
+	if (!iwm->keys[key_index].key_len) {
+		IWM_DBG_WEXT(iwm, DBG, "Key %d not used\n", key_index);
+		return 0;
+	}
+
+	if (key_index == iwm->default_key)
+		iwm->default_key = -1;
+
+	return iwm_set_key(iwm, 1, key);
+}
+
+static int iwm_cfg80211_set_default_key(struct wiphy *wiphy,
+					struct net_device *ndev,
+					u8 key_index)
+{
+	struct iwm_priv *iwm = ndev_to_iwm(ndev);
+	int ret;
+
+	IWM_DBG_WEXT(iwm, DBG, "Default key index is: %d\n", key_index);
+
+	if (!iwm->keys[key_index].key_len) {
+		IWM_ERR(iwm, "Key %d not used\n", key_index);
+		return -EINVAL;
+	}
+
+	ret = iwm_set_tx_key(iwm, key_index);
+	if (ret < 0)
+		return ret;
+
+	iwm->default_key = key_index;
+
+	return iwm_reset_profile(iwm);
+}
+
+
 int iwm_cfg80211_inform_bss(struct iwm_priv *iwm)
 {
 	struct wiphy *wiphy = iwm_to_wiphy(iwm);
@@ -331,6 +499,10 @@ static int iwm_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
 
 static struct cfg80211_ops iwm_cfg80211_ops = {
 	.change_virtual_intf = iwm_cfg80211_change_iface,
+	.add_key = iwm_cfg80211_add_key,
+	.get_key = iwm_cfg80211_get_key,
+	.del_key = iwm_cfg80211_del_key,
+	.set_default_key = iwm_cfg80211_set_default_key,
 	.scan = iwm_cfg80211_scan,
 	.set_wiphy_params = iwm_cfg80211_set_wiphy_params,
 	.join_ibss = iwm_cfg80211_join_ibss,
diff --git a/drivers/net/wireless/iwmc3200wifi/commands.c b/drivers/net/wireless/iwmc3200wifi/commands.c
index 337a884..145f6f5 100644
--- a/drivers/net/wireless/iwmc3200wifi/commands.c
+++ b/drivers/net/wireless/iwmc3200wifi/commands.c
@@ -524,9 +524,6 @@ int iwm_set_tx_key(struct iwm_priv *iwm, u8 key_idx)
 {
 	struct iwm_umac_tx_key_id tx_key_id;
 
-	if (!iwm->default_key || !iwm->default_key->in_use)
-		return -EINVAL;
-
 	tx_key_id.hdr.oid = UMAC_WIFI_IF_CMD_GLOBAL_TX_KEY_ID;
 	tx_key_id.hdr.buf_size = cpu_to_le16(sizeof(struct iwm_umac_tx_key_id) -
 					     sizeof(struct iwm_umac_wifi_if));
@@ -569,10 +566,9 @@ static int iwm_check_profile(struct iwm_priv *iwm)
 	return 0;
 }
 
-int iwm_set_key(struct iwm_priv *iwm, bool remove, bool set_tx_key,
-		struct iwm_key *key)
+int iwm_set_key(struct iwm_priv *iwm, bool remove, struct iwm_key *key)
 {
-	int ret;
+	int ret = 0;
 	u8 cmd[64], *sta_addr, *key_data, key_len;
 	s8 key_idx;
 	u16 cmd_size = 0;
@@ -582,9 +578,6 @@ int iwm_set_key(struct iwm_priv *iwm, bool remove, bool set_tx_key,
 	struct iwm_umac_key_tkip *tkip = (struct iwm_umac_key_tkip *)cmd;
 	struct iwm_umac_key_ccmp *ccmp = (struct iwm_umac_key_ccmp *)cmd;
 
-	if (set_tx_key)
-		iwm->default_key = key;
-
 	/*
 	 * We check if our current profile is valid.
 	 * If not, we dont push the key, we just cache them,
@@ -603,8 +596,7 @@ int iwm_set_key(struct iwm_priv *iwm, bool remove, bool set_tx_key,
 	key_idx = key->hdr.key_idx;
 
 	if (!remove) {
-		IWM_DBG_WEXT(iwm, DBG, "key_idx:%d set tx key:%d\n",
-			     key_idx, set_tx_key);
+		IWM_DBG_WEXT(iwm, DBG, "key_idx:%d\n", key_idx);
 		IWM_DBG_WEXT(iwm, DBG, "key_len:%d\n", key_len);
 		IWM_DBG_WEXT(iwm, DBG, "MAC:%pM, idx:%d, multicast:%d\n",
 		       key_hdr->mac, key_hdr->key_idx, key_hdr->multicast);
@@ -616,8 +608,8 @@ int iwm_set_key(struct iwm_priv *iwm, bool remove, bool set_tx_key,
 			     iwm->umac_profile->sec.auth_type,
 			     iwm->umac_profile->sec.flags);
 
-		switch (key->alg) {
-		case UMAC_CIPHER_TYPE_WEP_40:
+		switch (key->cipher) {
+		case WLAN_CIPHER_SUITE_WEP40:
 			wep40->hdr.oid = UMAC_WIFI_IF_CMD_ADD_WEP40_KEY;
 			wep40->hdr.buf_size =
 				cpu_to_le16(sizeof(struct iwm_umac_key_wep40) -
@@ -631,7 +623,7 @@ int iwm_set_key(struct iwm_priv *iwm, bool remove, bool set_tx_key,
 			cmd_size = sizeof(struct iwm_umac_key_wep40);
 			break;
 
-		case UMAC_CIPHER_TYPE_WEP_104:
+		case WLAN_CIPHER_SUITE_WEP104:
 			wep104->hdr.oid = UMAC_WIFI_IF_CMD_ADD_WEP104_KEY;
 			wep104->hdr.buf_size =
 				cpu_to_le16(sizeof(struct iwm_umac_key_wep104) -
@@ -645,7 +637,7 @@ int iwm_set_key(struct iwm_priv *iwm, bool remove, bool set_tx_key,
 			cmd_size = sizeof(struct iwm_umac_key_wep104);
 			break;
 
-		case UMAC_CIPHER_TYPE_CCMP:
+		case WLAN_CIPHER_SUITE_CCMP:
 			key_hdr->key_idx++;
 			ccmp->hdr.oid = UMAC_WIFI_IF_CMD_ADD_CCMP_KEY;
 			ccmp->hdr.buf_size =
@@ -657,13 +649,13 @@ int iwm_set_key(struct iwm_priv *iwm, bool remove, bool set_tx_key,
 
 			memcpy(ccmp->key, key_data, key_len);
 
-			if (key->flags & IW_ENCODE_EXT_RX_SEQ_VALID)
-				memcpy(ccmp->iv_count, key->rx_seq, 6);
+			if (key->seq_len)
+				memcpy(ccmp->iv_count, key->seq, key->seq_len);
 
 			cmd_size = sizeof(struct iwm_umac_key_ccmp);
 			break;
 
-		case UMAC_CIPHER_TYPE_TKIP:
+		case WLAN_CIPHER_SUITE_TKIP:
 			key_hdr->key_idx++;
 			tkip->hdr.oid = UMAC_WIFI_IF_CMD_ADD_TKIP_KEY;
 			tkip->hdr.buf_size =
@@ -680,8 +672,8 @@ int iwm_set_key(struct iwm_priv *iwm, bool remove, bool set_tx_key,
 			       key_data + IWM_TKIP_KEY_SIZE + IWM_TKIP_MIC_SIZE,
 			       IWM_TKIP_MIC_SIZE);
 
-			if (key->flags & IW_ENCODE_EXT_RX_SEQ_VALID)
-				memcpy(ccmp->iv_count, key->rx_seq, 6);
+			if (key->seq_len)
+				memcpy(ccmp->iv_count, key->seq, key->seq_len);
 
 			cmd_size = sizeof(struct iwm_umac_key_tkip);
 			break;
@@ -690,8 +682,8 @@ int iwm_set_key(struct iwm_priv *iwm, bool remove, bool set_tx_key,
 			return -ENOTSUPP;
 		}
 
-		if ((key->alg == UMAC_CIPHER_TYPE_CCMP) ||
-		    (key->alg == UMAC_CIPHER_TYPE_TKIP))
+		if ((key->cipher == WLAN_CIPHER_SUITE_TKIP) ||
+		    (key->cipher == WLAN_CIPHER_SUITE_CCMP))
 			/*
 			 * UGLY_UGLY_UGLY
 			 * Copied HACK from the MWG driver.
@@ -702,23 +694,11 @@ int iwm_set_key(struct iwm_priv *iwm, bool remove, bool set_tx_key,
 			schedule_timeout_interruptible(usecs_to_jiffies(300));
 
 		ret =  iwm_send_wifi_if_cmd(iwm, cmd, cmd_size, 1);
-		if (ret < 0)
-			goto err;
-
-		/*
-		 * We need a default key only if it is set and
-		 * if we're doing WEP.
-		 */
-		if (iwm->default_key == key &&
-			((key->alg == UMAC_CIPHER_TYPE_WEP_40) ||
-			 (key->alg == UMAC_CIPHER_TYPE_WEP_104))) {
-			ret = iwm_set_tx_key(iwm, key_idx);
-			if (ret < 0)
-				goto err;
-		}
 	} else {
 		struct iwm_umac_key_remove key_remove;
 
+		IWM_DBG_WEXT(iwm, ERR, "Removing key_idx:%d\n", key_idx);
+
 		key_remove.hdr.oid = UMAC_WIFI_IF_CMD_REMOVE_KEY;
 		key_remove.hdr.buf_size =
 			cpu_to_le16(sizeof(struct iwm_umac_key_remove) -
@@ -732,13 +712,9 @@ int iwm_set_key(struct iwm_priv *iwm, bool remove, bool set_tx_key,
 		if (ret < 0)
 			return ret;
 
-		iwm->keys[key_idx].in_use = 0;
+		iwm->keys[key_idx].key_len = 0;
 	}
 
-	return 0;
-
- err:
-	kfree(key);
 	return ret;
 }
 
@@ -761,22 +737,24 @@ int iwm_send_mlme_profile(struct iwm_priv *iwm)
 	}
 
 	for (i = 0; i < IWM_NUM_KEYS; i++)
-		if (iwm->keys[i].in_use) {
-			int default_key = 0;
+		if (iwm->keys[i].key_len) {
 			struct iwm_key *key = &iwm->keys[i];
 
-			if (key == iwm->default_key)
-				default_key = 1;
-
 			/* Wait for the profile before sending the keys */
 			wait_event_interruptible_timeout(iwm->mlme_queue,
 			     (test_bit(IWM_STATUS_ASSOCIATING, &iwm->status) ||
 			      test_bit(IWM_STATUS_ASSOCIATED, &iwm->status)),
 							 3 * HZ);
 
-			ret = iwm_set_key(iwm, 0, default_key, key);
+			ret = iwm_set_key(iwm, 0, key);
 			if (ret < 0)
 				return ret;
+
+			if (iwm->default_key == i) {
+				ret = iwm_set_tx_key(iwm, i);
+				if (ret < 0)
+					return ret;
+			}
 		}
 
 	return 0;
diff --git a/drivers/net/wireless/iwmc3200wifi/commands.h b/drivers/net/wireless/iwmc3200wifi/commands.h
index 36b13a1..3510df8 100644
--- a/drivers/net/wireless/iwmc3200wifi/commands.h
+++ b/drivers/net/wireless/iwmc3200wifi/commands.h
@@ -406,8 +406,7 @@ int iwm_send_mlme_profile(struct iwm_priv *iwm);
 int iwm_invalidate_mlme_profile(struct iwm_priv *iwm);
 int iwm_send_packet(struct iwm_priv *iwm, struct sk_buff *skb, int pool_id);
 int iwm_set_tx_key(struct iwm_priv *iwm, u8 key_idx);
-int iwm_set_key(struct iwm_priv *iwm, bool remove, bool set_tx_key,
-		struct iwm_key *key);
+int iwm_set_key(struct iwm_priv *iwm, bool remove, struct iwm_key *key);
 int iwm_send_umac_stats_req(struct iwm_priv *iwm, u32 flags);
 int iwm_send_umac_channel_list(struct iwm_priv *iwm);
 int iwm_scan_ssids(struct iwm_priv *iwm, struct cfg80211_ssid *ssids,
diff --git a/drivers/net/wireless/iwmc3200wifi/iwm.h b/drivers/net/wireless/iwmc3200wifi/iwm.h
index af11ea2..a08c6e9 100644
--- a/drivers/net/wireless/iwmc3200wifi/iwm.h
+++ b/drivers/net/wireless/iwmc3200wifi/iwm.h
@@ -162,13 +162,11 @@ struct iwm_umac_key_hdr {
 
 struct iwm_key {
 	struct iwm_umac_key_hdr hdr;
-	u8 in_use;
-	u8 alg;
-	u32 flags;
-	u8 tx_seq[IW_ENCODE_SEQ_MAX_SIZE];
-	u8 rx_seq[IW_ENCODE_SEQ_MAX_SIZE];
-	u8 key_len;
-	u8 key[32];
+	u32 cipher;
+	u8 key[WLAN_MAX_KEY_LEN];
+	u8 seq[IW_ENCODE_SEQ_MAX_SIZE];
+	int key_len;
+	int seq_len;
 };
 
 #define IWM_RX_ID_HASH  0xff
@@ -277,7 +275,7 @@ struct iwm_priv {
 	struct iwm_tx_queue txq[IWM_TX_QUEUES];
 
 	struct iwm_key keys[IWM_NUM_KEYS];
-	struct iwm_key *default_key;
+	s8 default_key;
 
 	DECLARE_BITMAP(wifi_ntfy, WIFI_IF_NTFY_MAX);
 	wait_queue_head_t wifi_ntfy_queue;
diff --git a/drivers/net/wireless/iwmc3200wifi/main.c b/drivers/net/wireless/iwmc3200wifi/main.c
index f8e5d1b..3ac5a16 100644
--- a/drivers/net/wireless/iwmc3200wifi/main.c
+++ b/drivers/net/wireless/iwmc3200wifi/main.c
@@ -230,7 +230,7 @@ int iwm_priv_init(struct iwm_priv *iwm)
 	for (i = 0; i < IWM_NUM_KEYS; i++)
 		memset(&iwm->keys[i], 0, sizeof(struct iwm_key));
 
-	iwm->default_key = NULL;
+	iwm->default_key = -1;
 
 	init_timer(&iwm->watchdog);
 	iwm->watchdog.function = iwm_watchdog;
@@ -713,7 +713,7 @@ int __iwm_down(struct iwm_priv *iwm)
 	iwm->umac_profile = NULL;
 	iwm_bss_list_clean(iwm);
 
-	iwm->default_key = NULL;
+	iwm->default_key = -1;
 	iwm->core_enabled = 0;
 
 	ret = iwm_bus_disable(iwm);
diff --git a/drivers/net/wireless/iwmc3200wifi/wext.c b/drivers/net/wireless/iwmc3200wifi/wext.c
index 8891949..3062f37 100644
--- a/drivers/net/wireless/iwmc3200wifi/wext.c
+++ b/drivers/net/wireless/iwmc3200wifi/wext.c
@@ -84,6 +84,8 @@ static int iwm_wext_siwap(struct net_device *dev, struct iw_request_info *info,
 	struct iwm_priv *iwm = ndev_to_iwm(dev);
 	int ret;
 
+	IWM_DBG_WEXT(iwm, DBG, "Set BSSID: %pM\n", ap_addr->sa_data);
+
 	if (iwm->conf.mode == UMAC_MODE_IBSS)
 		return cfg80211_ibss_wext_siwap(dev, info, ap_addr, extra);
 
@@ -116,8 +118,7 @@ static int iwm_wext_siwap(struct net_device *dev, struct iw_request_info *info,
 		 */
 		if (is_zero_ether_addr(ap_addr->sa_data)) {
 			for (i = 0; i < IWM_NUM_KEYS; i++)
-				iwm->keys[i].in_use = 0;
-
+				iwm->keys[i].key_len = 0;
 		}
 
 		ret = iwm_invalidate_mlme_profile(iwm);
@@ -163,6 +164,8 @@ static int iwm_wext_siwessid(struct net_device *dev,
 	size_t len = data->length;
 	int ret;
 
+	IWM_DBG_WEXT(iwm, DBG, "Set ESSID: >%s<\n", ssid);
+
 	if (iwm->conf.mode == UMAC_MODE_IBSS)
 		return cfg80211_ibss_wext_siwessid(dev, info, data, ssid);
 
@@ -212,27 +215,6 @@ static int iwm_wext_giwessid(struct net_device *dev,
 	return 0;
 }
 
-static struct iwm_key *
-iwm_key_init(struct iwm_priv *iwm, u8 key_idx, bool in_use,
-	     struct iw_encode_ext *ext, u8 alg)
-{
-	struct iwm_key *key = &iwm->keys[key_idx];
-
-	memset(key, 0, sizeof(struct iwm_key));
-	memcpy(key->hdr.mac, ext->addr.sa_data, ETH_ALEN);
-	key->hdr.key_idx = key_idx;
-	if (is_broadcast_ether_addr(ext->addr.sa_data))
-		key->hdr.multicast = 1;
-
-	key->in_use = in_use;
-	key->flags = ext->ext_flags;
-	key->alg = alg;
-	key->key_len = ext->key_len;
-	memcpy(key->key, ext->key, ext->key_len);
-
-	return key;
-}
-
 static int iwm_wext_giwrate(struct net_device *dev,
 			    struct iw_request_info *info,
 			    struct iw_param *rate, char *extra)
@@ -244,184 +226,6 @@ static int iwm_wext_giwrate(struct net_device *dev,
 	return 0;
 }
 
-static int iwm_wext_siwencode(struct net_device *dev,
-			      struct iw_request_info *info,
-			      struct iw_point *erq, char *key_buf)
-{
-	struct iwm_priv *iwm = ndev_to_iwm(dev);
-	struct iwm_key *uninitialized_var(key);
-	int idx, i, uninitialized_var(alg), remove = 0, ret;
-
-	IWM_DBG_WEXT(iwm, DBG, "key len: %d\n", erq->length);
-	IWM_DBG_WEXT(iwm, DBG, "flags: 0x%x\n", erq->flags);
-
-	if (!iwm->umac_profile) {
-		IWM_ERR(iwm, "UMAC profile not allocated yet\n");
-		return -ENODEV;
-	}
-
-	if (erq->length == WLAN_KEY_LEN_WEP40) {
-		alg = UMAC_CIPHER_TYPE_WEP_40;
-		iwm->umac_profile->sec.ucast_cipher = UMAC_CIPHER_TYPE_WEP_40;
-		iwm->umac_profile->sec.mcast_cipher = UMAC_CIPHER_TYPE_WEP_40;
-	} else if (erq->length == WLAN_KEY_LEN_WEP104) {
-		alg = UMAC_CIPHER_TYPE_WEP_104;
-		iwm->umac_profile->sec.ucast_cipher = UMAC_CIPHER_TYPE_WEP_104;
-		iwm->umac_profile->sec.mcast_cipher = UMAC_CIPHER_TYPE_WEP_104;
-	}
-
-	if (erq->flags & IW_ENCODE_RESTRICTED)
-		iwm->umac_profile->sec.auth_type = UMAC_AUTH_TYPE_LEGACY_PSK;
-	else
-		iwm->umac_profile->sec.auth_type = UMAC_AUTH_TYPE_OPEN;
-
-	idx = erq->flags & IW_ENCODE_INDEX;
-	if (idx == 0) {
-		if (iwm->default_key)
-			for (i = 0; i < IWM_NUM_KEYS; i++) {
-				if (iwm->default_key == &iwm->keys[i]) {
-					idx = i;
-					break;
-				}
-			}
-		else
-			iwm->default_key = &iwm->keys[idx];
-	} else if (idx < 1 || idx > 4) {
-		return -EINVAL;
-	} else
-		idx--;
-
-	if (erq->flags & IW_ENCODE_DISABLED)
-		remove = 1;
-	else if (erq->length == 0) {
-		if (!iwm->keys[idx].in_use)
-			return -EINVAL;
-		iwm->default_key = &iwm->keys[idx];
-	}
-
-	if (erq->length) {
-		key = &iwm->keys[idx];
-		memset(key, 0, sizeof(struct iwm_key));
-		memset(key->hdr.mac, 0xff, ETH_ALEN);
-		key->hdr.key_idx = idx;
-		key->hdr.multicast = 1;
-		key->in_use = !remove;
-		key->alg = alg;
-		key->key_len = erq->length;
-		memcpy(key->key, key_buf, erq->length);
-
-		IWM_DBG_WEXT(iwm, DBG, "Setting key %d, default: %d\n",
-			     idx, !!iwm->default_key);
-	}
-
-	if (remove) {
-		if ((erq->flags & IW_ENCODE_NOKEY) || (erq->length == 0)) {
-			int j;
-			for (j = 0; j < IWM_NUM_KEYS; j++)
-				if (iwm->keys[j].in_use) {
-					struct iwm_key *k = &iwm->keys[j];
-
-					k->in_use = 0;
-					ret = iwm_set_key(iwm, remove, 0, k);
-					if (ret < 0)
-						return ret;
-				}
-
-			iwm->umac_profile->sec.ucast_cipher =
-							UMAC_CIPHER_TYPE_NONE;
-			iwm->umac_profile->sec.mcast_cipher =
-							UMAC_CIPHER_TYPE_NONE;
-			iwm->umac_profile->sec.auth_type =
-							UMAC_AUTH_TYPE_OPEN;
-
-			return 0;
-		} else {
-			key->in_use = 0;
-			return iwm_set_key(iwm, remove, 0, key);
-		}
-	}
-
-	/*
-	 * If we havent set a profile yet, we cant set keys.
-	 * Keys will be pushed after we're associated.
-	 */
-	if (!iwm->umac_profile_active)
-		return 0;
-
-	/*
-	 * If there is a current active profile, but no
-	 * default key, it's not worth trying to associate again.
-	 */
-	if (!iwm->default_key)
-		return 0;
-
-	/*
-	 * Here we have an active profile, but a key setting changed.
-	 * We thus have to invalidate the current profile, and push the
-	 * new one. Keys will be pushed when association takes place.
-	 */
-	ret = iwm_invalidate_mlme_profile(iwm);
-	if (ret < 0) {
-		IWM_ERR(iwm, "Couldn't invalidate profile\n");
-		return ret;
-	}
-
-	return iwm_send_mlme_profile(iwm);
-}
-
-static int iwm_wext_giwencode(struct net_device *dev,
-			      struct iw_request_info *info,
-			      struct iw_point *erq, char *key)
-{
-	struct iwm_priv *iwm = ndev_to_iwm(dev);
-	int idx, i;
-
-	idx = erq->flags & IW_ENCODE_INDEX;
-	if (idx < 1 || idx > 4) {
-		idx = -1;
-		if (!iwm->default_key) {
-			erq->length = 0;
-			erq->flags |= IW_ENCODE_NOKEY;
-			return 0;
-		} else
-			for (i = 0; i < IWM_NUM_KEYS; i++) {
-				if (iwm->default_key == &iwm->keys[i]) {
-					idx = i;
-					break;
-				}
-			}
-		if (idx < 0)
-			return -EINVAL;
-	} else
-		idx--;
-
-	erq->flags = idx + 1;
-
-	if (!iwm->keys[idx].in_use) {
-		erq->length = 0;
-		erq->flags |= IW_ENCODE_DISABLED;
-		return 0;
-	}
-
-	memcpy(key, iwm->keys[idx].key,
-	       min_t(int, erq->length, iwm->keys[idx].key_len));
-	erq->length = iwm->keys[idx].key_len;
-	erq->flags |= IW_ENCODE_ENABLED;
-
-	if (iwm->umac_profile->mode == UMAC_MODE_BSS) {
-		switch (iwm->umac_profile->sec.auth_type) {
-		case UMAC_AUTH_TYPE_OPEN:
-			erq->flags |= IW_ENCODE_OPEN;
-			break;
-		default:
-			erq->flags |= IW_ENCODE_RESTRICTED;
-			break;
-		}
-	}
-
-	return 0;
-}
-
 static int iwm_set_wpa_version(struct iwm_priv *iwm, u8 wpa_version)
 {
 	if (wpa_version & IW_AUTH_WPA_VERSION_WPA2)
@@ -481,6 +285,8 @@ static int iwm_set_key_mgt(struct iwm_priv *iwm, u8 key_mgt)
 {
 	u8 *auth_type = &iwm->umac_profile->sec.auth_type;
 
+	IWM_DBG_WEXT(iwm, DBG, "key_mgt: 0x%x\n", key_mgt);
+
 	if (key_mgt == IW_AUTH_KEY_MGMT_802_1X)
 		*auth_type = UMAC_AUTH_TYPE_8021X;
 	else if (key_mgt == IW_AUTH_KEY_MGMT_PSK) {
@@ -530,6 +336,8 @@ static int iwm_set_auth_alg(struct iwm_priv *iwm, u8 auth_alg)
 {
 	u8 *auth_type = &iwm->umac_profile->sec.auth_type;
 
+	IWM_DBG_WEXT(iwm, DBG, "auth_alg: 0x%x\n", auth_alg);
+
 	switch (auth_alg) {
 	case IW_AUTH_ALG_OPEN_SYSTEM:
 		*auth_type = UMAC_AUTH_TYPE_OPEN;
@@ -541,6 +349,7 @@ static int iwm_set_auth_alg(struct iwm_priv *iwm, u8 auth_alg)
 				return -EINVAL;
 			*auth_type = UMAC_AUTH_TYPE_RSNA_PSK;
 		} else {
+			IWM_DBG_WEXT(iwm, DBG, "WEP shared key\n");
 			*auth_type = UMAC_AUTH_TYPE_LEGACY_PSK;
 		}
 		break;
@@ -603,75 +412,6 @@ static int iwm_wext_giwauth(struct net_device *dev,
 	return 0;
 }
 
-static int iwm_wext_siwencodeext(struct net_device *dev,
-				 struct iw_request_info *info,
-				 struct iw_point *erq, char *extra)
-{
-	struct iwm_priv *iwm = ndev_to_iwm(dev);
-	struct iwm_key *key;
-	struct iw_encode_ext *ext = (struct iw_encode_ext *) extra;
-	int uninitialized_var(alg), idx, i, remove = 0;
-
-	IWM_DBG_WEXT(iwm, DBG, "alg: 0x%x\n", ext->alg);
-	IWM_DBG_WEXT(iwm, DBG, "key len: %d\n", ext->key_len);
-	IWM_DBG_WEXT(iwm, DBG, "ext_flags: 0x%x\n", ext->ext_flags);
-	IWM_DBG_WEXT(iwm, DBG, "flags: 0x%x\n", erq->flags);
-	IWM_DBG_WEXT(iwm, DBG, "length: 0x%x\n", erq->length);
-
-	switch (ext->alg) {
-	case IW_ENCODE_ALG_NONE:
-		remove = 1;
-		break;
-	case IW_ENCODE_ALG_WEP:
-		if (ext->key_len == WLAN_KEY_LEN_WEP40)
-			alg = UMAC_CIPHER_TYPE_WEP_40;
-		else if (ext->key_len == WLAN_KEY_LEN_WEP104)
-			alg = UMAC_CIPHER_TYPE_WEP_104;
-		else {
-			IWM_ERR(iwm, "Invalid key length: %d\n", ext->key_len);
-			return -EINVAL;
-		}
-
-		break;
-	case IW_ENCODE_ALG_TKIP:
-		alg = UMAC_CIPHER_TYPE_TKIP;
-		break;
-	case IW_ENCODE_ALG_CCMP:
-		alg = UMAC_CIPHER_TYPE_CCMP;
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
-
-	idx = erq->flags & IW_ENCODE_INDEX;
-
-	if (idx == 0) {
-		if (iwm->default_key)
-			for (i = 0; i < IWM_NUM_KEYS; i++) {
-				if (iwm->default_key == &iwm->keys[i]) {
-					idx = i;
-					break;
-				}
-			}
-	} else if (idx < 1 || idx > 4) {
-		return -EINVAL;
-	} else
-		idx--;
-
-	if (erq->flags & IW_ENCODE_DISABLED)
-		remove = 1;
-	else if ((erq->length == 0) ||
-		 (ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY)) {
-		iwm->default_key = &iwm->keys[idx];
-		if (iwm->umac_profile_active && ext->alg == IW_ENCODE_ALG_WEP)
-			return iwm_set_tx_key(iwm, idx);
-	}
-
-	key = iwm_key_init(iwm, idx, !remove, ext, alg);
-
-	return iwm_set_key(iwm, remove, !iwm->default_key, key);
-}
-
 static const iw_handler iwm_handlers[] =
 {
 	(iw_handler) NULL,				/* SIOCSIWCOMMIT */
@@ -716,8 +456,8 @@ static const iw_handler iwm_handlers[] =
 	(iw_handler) NULL,				/* SIOCGIWTXPOW */
 	(iw_handler) NULL,				/* SIOCSIWRETRY */
 	(iw_handler) NULL,				/* SIOCGIWRETRY */
-	(iw_handler) iwm_wext_siwencode,		/* SIOCSIWENCODE */
-	(iw_handler) iwm_wext_giwencode,		/* SIOCGIWENCODE */
+	(iw_handler) cfg80211_wext_siwencode,		/* SIOCSIWENCODE */
+	(iw_handler) cfg80211_wext_giwencode,		/* SIOCGIWENCODE */
 	(iw_handler) iwm_wext_siwpower,			/* SIOCSIWPOWER */
 	(iw_handler) iwm_wext_giwpower,			/* SIOCGIWPOWER */
 	(iw_handler) NULL,				/* -- hole -- */
@@ -726,7 +466,7 @@ static const iw_handler iwm_handlers[] =
 	(iw_handler) NULL,				/* SIOCGIWGENIE */
 	(iw_handler) iwm_wext_siwauth,			/* SIOCSIWAUTH */
 	(iw_handler) iwm_wext_giwauth,			/* SIOCGIWAUTH */
-	(iw_handler) iwm_wext_siwencodeext,	        /* SIOCSIWENCODEEXT */
+	(iw_handler) cfg80211_wext_siwencodeext,	/* SIOCSIWENCODEEXT */
 	(iw_handler) NULL,				/* SIOCGIWENCODEEXT */
 	(iw_handler) NULL,				/* SIOCSIWPMKSA */
 	(iw_handler) NULL,				/* -- hole -- */
-- 
1.6.3.1

