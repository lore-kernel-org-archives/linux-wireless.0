Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sirokuusama.dnainternet.net ([83.102.40.133]:56751 "EHLO
	sirokuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751688AbZG3QvX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 12:51:23 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 10/10] rndis_wlan: rework key handling
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Date: Thu, 30 Jul 2009 19:42:08 +0300
Message-ID: <20090730164208.28317.64301.stgit@fate.lan>
In-Reply-To: <20090730164120.28317.53313.stgit@fate.lan>
References: <20090730164120.28317.53313.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Organize key data in private structure better and store WPA keys, so
they can be restored as WEP keys.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |  188 ++++++++++++++++++++++++++++---------
 1 files changed, 142 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 3d92b77..828dc18 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -413,6 +413,15 @@ static const struct ieee80211_rate rndis_rates[] = {
 	{ .bitrate = 540 }
 };
 
+struct rndis_wlan_encr_key {
+	int len;
+	int cipher;
+	u8 material[32];
+	u8 bssid[ETH_ALEN];
+	bool pairwise;
+	bool tx_key;
+};
+
 /* RNDIS device private data */
 struct rndis_wlan_private {
 	struct usbnet *usbdev;
@@ -456,9 +465,7 @@ struct rndis_wlan_private {
 
 	/* encryption stuff */
 	int  encr_tx_key_index;
-	char encr_keys[4][32];
-	int  encr_key_len[4];
-	char encr_key_wpa[4];
+	struct rndis_wlan_encr_key encr_keys[4];
 	int  wpa_version;
 	int  wpa_keymgmt;
 	int  wpa_authalg;
@@ -525,6 +532,15 @@ static u32 get_bcm4320_power_dbm(struct rndis_wlan_private *priv)
 }
 
 
+static bool is_wpa_key(struct rndis_wlan_private *priv, int idx)
+{
+	int cipher = priv->encr_keys[idx].cipher;
+
+	return (cipher == WLAN_CIPHER_SUITE_CCMP ||
+		cipher == WLAN_CIPHER_SUITE_TKIP);
+}
+
+
 #ifdef DEBUG
 static const char *oid_to_string(__le32 oid)
 {
@@ -895,8 +911,7 @@ static int freq_to_dsconfig(struct iw_freq *freq, unsigned int *dsconfig)
 /*
  * common functions
  */
-static int
-add_wep_key(struct usbnet *usbdev, char *key, int key_len, int index);
+static void restore_keys(struct usbnet *usbdev);
 
 static int get_essid(struct usbnet *usbdev, struct ndis_80211_ssid *ssid)
 {
@@ -1115,7 +1130,7 @@ static int set_infra_mode(struct usbnet *usbdev, int mode)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	__le32 tmp;
-	int ret, i;
+	int ret;
 
 	devdbg(usbdev, "set_infra_mode: infra_mode=0x%x", priv->infra_mode);
 
@@ -1130,14 +1145,7 @@ static int set_infra_mode(struct usbnet *usbdev, int mode)
 	/* NDIS drivers clear keys when infrastructure mode is
 	 * changed. But Linux tools assume otherwise. So set the
 	 * keys */
-	if (priv->wpa_keymgmt == 0 ||
-		priv->wpa_keymgmt == IW_AUTH_KEY_MGMT_802_1X) {
-		for (i = 0; i < 4; i++) {
-			if (priv->encr_key_len[i] > 0 && !priv->encr_key_wpa[i])
-				add_wep_key(usbdev, priv->encr_keys[i],
-						priv->encr_key_len[i], i);
-		}
-	}
+	restore_keys(usbdev);
 
 	priv->infra_mode = mode;
 	return 0;
@@ -1204,11 +1212,16 @@ static int add_wep_key(struct usbnet *usbdev, char *key, int key_len, int index)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	struct ndis_80211_wep_key ndis_key;
-	int ret;
+	int cipher, ret;
 
-	if (key_len <= 0 || key_len > 32 || index < 0 || index >= 4)
+	if ((key_len != 5 || key_len != 13) || index < 0 || index > 3)
 		return -EINVAL;
 
+	if (key_len == 5)
+		cipher = WLAN_CIPHER_SUITE_WEP40;
+	else
+		cipher = WLAN_CIPHER_SUITE_WEP104;
+
 	memset(&ndis_key, 0, sizeof(ndis_key));
 
 	ndis_key.size = cpu_to_le32(sizeof(ndis_key));
@@ -1233,30 +1246,44 @@ static int add_wep_key(struct usbnet *usbdev, char *key, int key_len, int index)
 		return ret;
 	}
 
-	priv->encr_key_len[index] = key_len;
-	priv->encr_key_wpa[index] = 0;
-	memcpy(&priv->encr_keys[index], key, key_len);
+	priv->encr_keys[index].len = key_len;
+	priv->encr_keys[index].cipher = cipher;
+	memcpy(&priv->encr_keys[index].material, key, key_len);
+	memset(&priv->encr_keys[index].bssid, 0xff, ETH_ALEN);
 
 	return 0;
 }
 
 
 static int add_wpa_key(struct usbnet *usbdev, const u8 *key, int key_len,
-			int index, const struct sockaddr *addr,
-			const u8 *rx_seq, int alg, int flags)
+			int index, const u8 *addr, const u8 *rx_seq, int cipher,
+			int flags)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	struct ndis_80211_key ndis_key;
+	bool is_addr_ok;
 	int ret;
 
-	if (index < 0 || index >= 4)
+	if (index < 0 || index >= 4) {
+		devdbg(usbdev, "add_wpa_key: index out of range (%i)", index);
 		return -EINVAL;
-	if (key_len > sizeof(ndis_key.material) || key_len < 0)
+	}
+	if (key_len > sizeof(ndis_key.material) || key_len < 0) {
+		devdbg(usbdev, "add_wpa_key: key length out of range (%i)",
+			key_len);
 		return -EINVAL;
-	if ((flags & NDIS_80211_ADDKEY_SET_INIT_RECV_SEQ) && !rx_seq)
+	}
+	if ((flags & NDIS_80211_ADDKEY_SET_INIT_RECV_SEQ) && !rx_seq) {
+		devdbg(usbdev, "add_wpa_key: recv seq flag without buffer");
 		return -EINVAL;
-	if ((flags & NDIS_80211_ADDKEY_PAIRWISE_KEY) && !addr)
+	}
+	is_addr_ok = addr && memcmp(addr, zero_bssid, ETH_ALEN) != 0 &&
+			memcmp(addr, ffff_bssid, ETH_ALEN) != 0;
+	if ((flags & NDIS_80211_ADDKEY_PAIRWISE_KEY) && !is_addr_ok) {
+		devdbg(usbdev, "add_wpa_key: pairwise but bssid invalid (%pM)",
+			addr);
 		return -EINVAL;
+	}
 
 	devdbg(usbdev, "add_wpa_key(%i): flags:%i%i%i", index,
 			!!(flags & NDIS_80211_ADDKEY_TRANSMIT_KEY),
@@ -1270,7 +1297,7 @@ static int add_wpa_key(struct usbnet *usbdev, const u8 *key, int key_len,
 	ndis_key.length = cpu_to_le32(key_len);
 	ndis_key.index = cpu_to_le32(index) | flags;
 
-	if (alg == IW_ENCODE_ALG_TKIP && key_len == 32) {
+	if (cipher == WLAN_CIPHER_SUITE_TKIP && key_len == 32) {
 		/* wpa_supplicant gives us the Michael MIC RX/TX keys in
 		 * different order than NDIS spec, so swap the order here. */
 		memcpy(ndis_key.material, key, 16);
@@ -1284,7 +1311,7 @@ static int add_wpa_key(struct usbnet *usbdev, const u8 *key, int key_len,
 
 	if (flags & NDIS_80211_ADDKEY_PAIRWISE_KEY) {
 		/* pairwise key */
-		memcpy(ndis_key.bssid, addr->sa_data, ETH_ALEN);
+		memcpy(ndis_key.bssid, addr, ETH_ALEN);
 	} else {
 		/* group key */
 		if (priv->infra_mode == NDIS_80211_INFRA_ADHOC)
@@ -1299,8 +1326,14 @@ static int add_wpa_key(struct usbnet *usbdev, const u8 *key, int key_len,
 	if (ret != 0)
 		return ret;
 
-	priv->encr_key_len[index] = key_len;
-	priv->encr_key_wpa[index] = 1;
+	memset(&priv->encr_keys[index], 0, sizeof(priv->encr_keys[index]));
+	priv->encr_keys[index].len = key_len;
+	priv->encr_keys[index].cipher = cipher;
+	memcpy(&priv->encr_keys[index].material, key, key_len);
+	if (flags & NDIS_80211_ADDKEY_PAIRWISE_KEY)
+		memcpy(&priv->encr_keys[index].bssid, ndis_key.bssid, ETH_ALEN);
+	else
+		memset(&priv->encr_keys[index].bssid, 0xff, ETH_ALEN);
 
 	if (flags & NDIS_80211_ADDKEY_TRANSMIT_KEY)
 		priv->encr_tx_key_index = index;
@@ -1309,25 +1342,74 @@ static int add_wpa_key(struct usbnet *usbdev, const u8 *key, int key_len,
 }
 
 
+static int restore_key(struct usbnet *usbdev, int key_idx)
+{
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
+	struct rndis_wlan_encr_key key;
+	int flags;
+
+	key = priv->encr_keys[key_idx];
+
+	devdbg(usbdev, "restore_key: %i:%s:%i", key_idx,
+		is_wpa_key(priv, key_idx) ? "wpa" : "wep",
+		key.len);
+
+	if (key.len == 0)
+		return 0;
+
+	if (is_wpa_key(priv, key_idx)) {
+		flags = 0;
+
+		/*if (priv->encr_tx_key_index == key_idx)
+			flags |= NDIS_80211_ADDKEY_TRANSMIT_KEY;*/
+
+		if (memcmp(key.bssid, zero_bssid, ETH_ALEN) != 0 &&
+				memcmp(key.bssid, ffff_bssid, ETH_ALEN) != 0)
+			flags |= NDIS_80211_ADDKEY_PAIRWISE_KEY;
+
+		return add_wpa_key(usbdev, key.material, key.len, key_idx,
+					key.bssid, NULL, key.cipher, flags);
+	}
+
+	return add_wep_key(usbdev, key.material, key.len, key_idx);
+}
+
+
+static void restore_keys(struct usbnet *usbdev)
+{
+	int i;
+
+	for (i = 0; i < 4; i++)
+		restore_key(usbdev, i);
+}
+
+
+static void clear_key(struct rndis_wlan_private *priv, int idx)
+{
+	memset(&priv->encr_keys[idx], 0, sizeof(priv->encr_keys[idx]));
+}
+
+
 /* remove_key is for both wep and wpa */
 static int remove_key(struct usbnet *usbdev, int index, u8 bssid[ETH_ALEN])
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	struct ndis_80211_remove_key remove_key;
 	__le32 keyindex;
+	bool is_wpa;
 	int ret;
 
-	if (priv->encr_key_len[index] == 0)
+	if (priv->encr_keys[index].len == 0)
 		return 0;
 
-	priv->encr_key_len[index] = 0;
-	priv->encr_key_wpa[index] = 0;
-	memset(&priv->encr_keys[index], 0, sizeof(priv->encr_keys[index]));
+	is_wpa = is_wpa_key(priv, index);
 
-	if (priv->wpa_cipher_pair == IW_AUTH_CIPHER_TKIP ||
-	    priv->wpa_cipher_pair == IW_AUTH_CIPHER_CCMP ||
-	    priv->wpa_cipher_group == IW_AUTH_CIPHER_TKIP ||
-	    priv->wpa_cipher_group == IW_AUTH_CIPHER_CCMP) {
+	devdbg(usbdev, "remove_key: %i:%s:%i", index, is_wpa ? "wpa" : "wep",
+		priv->encr_keys[index].len);
+
+	clear_key(priv, index);
+
+	if (is_wpa) {
 		remove_key.size = cpu_to_le32(sizeof(remove_key));
 		remove_key.index = cpu_to_le32(index);
 		if (bssid) {
@@ -1871,8 +1953,9 @@ static int rndis_iw_set_encode(struct net_device *dev,
 {
 	struct usbnet *usbdev = netdev_priv(dev);
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
+	struct rndis_wlan_encr_key key;
 	int ret, index, key_len;
-	u8 *key;
+	u8 *keybuf;
 
 	index = (wrqu->encoding.flags & IW_ENCODE_INDEX);
 
@@ -1907,17 +1990,18 @@ static int rndis_iw_set_encode(struct net_device *dev,
 
 	if (wrqu->data.length > 0) {
 		key_len = wrqu->data.length;
-		key = extra;
+		keybuf = extra;
 	} else {
 		/* must be set as tx key */
-		if (priv->encr_key_len[index] == 0)
+		if (priv->encr_keys[index].len == 0)
 			return -EINVAL;
-		key_len = priv->encr_key_len[index];
 		key = priv->encr_keys[index];
+		key_len = key.len;
+		keybuf = key.material;
 		priv->encr_tx_key_index = index;
 	}
 
-	if (add_wep_key(usbdev, key, key_len, index) != 0)
+	if (add_wep_key(usbdev, keybuf, key_len, index) != 0)
 		return -EINVAL;
 
 	if (index == priv->encr_tx_key_index)
@@ -1934,7 +2018,7 @@ static int rndis_iw_set_encode_ext(struct net_device *dev,
 	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
 	struct usbnet *usbdev = netdev_priv(dev);
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
-	int keyidx, flags;
+	int keyidx, flags, cipher;
 
 	keyidx = wrqu->encoding.flags & IW_ENCODE_INDEX;
 
@@ -1944,8 +2028,10 @@ static int rndis_iw_set_encode_ext(struct net_device *dev,
 	else
 		keyidx = priv->encr_tx_key_index;
 
-	if (keyidx < 0 || keyidx >= 4)
+	if (keyidx < 0 || keyidx >= 4) {
+		devwarn(usbdev, "encryption index out of range (%u)", keyidx);
 		return -EINVAL;
+	}
 
 	if (ext->alg == WPA_ALG_WEP) {
 		if (ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY)
@@ -1953,10 +2039,19 @@ static int rndis_iw_set_encode_ext(struct net_device *dev,
 		return add_wep_key(usbdev, ext->key, ext->key_len, keyidx);
 	}
 
+	cipher = -1;
+	if (ext->alg == IW_ENCODE_ALG_TKIP)
+		cipher = WLAN_CIPHER_SUITE_TKIP;
+	else if (ext->alg == IW_ENCODE_ALG_CCMP)
+		cipher = WLAN_CIPHER_SUITE_CCMP;
+
 	if ((wrqu->encoding.flags & IW_ENCODE_DISABLED) ||
 	    ext->alg == IW_ENCODE_ALG_NONE || ext->key_len == 0)
 		return remove_key(usbdev, keyidx, NULL);
 
+	if (cipher == -1)
+		return -EOPNOTSUPP;
+
 	flags = 0;
 	if (ext->ext_flags & IW_ENCODE_EXT_RX_SEQ_VALID)
 		flags |= NDIS_80211_ADDKEY_SET_INIT_RECV_SEQ;
@@ -1965,8 +2060,9 @@ static int rndis_iw_set_encode_ext(struct net_device *dev,
 	if (ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY)
 		flags |= NDIS_80211_ADDKEY_TRANSMIT_KEY;
 
-	return add_wpa_key(usbdev, ext->key, ext->key_len, keyidx, &ext->addr,
-				ext->rx_seq, ext->alg, flags);
+	return add_wpa_key(usbdev, ext->key, ext->key_len, keyidx,
+				(u8 *)&ext->addr.sa_data, ext->rx_seq, cipher,
+				flags);
 }
 
 

