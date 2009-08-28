Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:34409 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbZH1K17 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 06:27:59 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [RFC PATCH 03/10] rndis_wlan: add cfg80211 key handling
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 28 Aug 2009 13:27:58 +0300
Message-ID: <20090828102758.15684.96477.stgit@fate.lan>
In-Reply-To: <20090828102742.15684.10566.stgit@fate.lan>
References: <20090828102742.15684.10566.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add cfg80211 add_key/del_key/set_default_key and convert wext to use theim.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |  133 +++++++++++++++++++++++++++++--------
 1 files changed, 103 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index ffb195d..93b504b 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -424,7 +424,7 @@ static const u32 rndis_cipher_suites[] = {
 
 struct rndis_wlan_encr_key {
 	int len;
-	int cipher;
+	u32 cipher;
 	u8 material[32];
 	u8 bssid[ETH_ALEN];
 	bool pairwise;
@@ -520,6 +520,16 @@ static int rndis_leave_ibss(struct wiphy *wiphy, struct net_device *dev);
 static int rndis_set_channel(struct wiphy *wiphy,
 	struct ieee80211_channel *chan, enum nl80211_channel_type channel_type);
 
+static int rndis_add_key(struct wiphy *wiphy, struct net_device *netdev,
+					u8 key_index, const u8 *mac_addr,
+					struct key_params *params);
+
+static int rndis_del_key(struct wiphy *wiphy, struct net_device *netdev,
+					u8 key_index, const u8 *mac_addr);
+
+static int rndis_set_default_key(struct wiphy *wiphy, struct net_device *netdev,
+								u8 key_index);
+
 static struct cfg80211_ops rndis_config_ops = {
 	.change_virtual_intf = rndis_change_virtual_intf,
 	.scan = rndis_scan,
@@ -531,6 +541,9 @@ static struct cfg80211_ops rndis_config_ops = {
 	.join_ibss = rndis_join_ibss,
 	.leave_ibss = rndis_leave_ibss,
 	.set_channel = rndis_set_channel,
+	.add_key = rndis_add_key,
+	.del_key = rndis_del_key,
+	.set_default_key = rndis_set_default_key,
 };
 
 static void *rndis_wiphy_privid = &rndis_wiphy_privid;
@@ -1258,7 +1271,10 @@ static int add_wep_key(struct usbnet *usbdev, const u8 *key, int key_len,
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	struct ndis_80211_wep_key ndis_key;
-	int cipher, ret;
+	u32 cipher;
+	int ret;
+
+	devdbg(usbdev, "add_wep_key(idx: %d, len: %d)", index, key_len);
 
 	if ((key_len != 5 && key_len != 13) || index < 0 || index > 3)
 		return -EINVAL;
@@ -1302,8 +1318,8 @@ static int add_wep_key(struct usbnet *usbdev, const u8 *key, int key_len,
 
 
 static int add_wpa_key(struct usbnet *usbdev, const u8 *key, int key_len,
-			int index, const u8 *addr, const u8 *rx_seq, int cipher,
-			int flags)
+			int index, const u8 *addr, const u8 *rx_seq,
+			int seq_len, u32 cipher, int flags)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	struct ndis_80211_key ndis_key;
@@ -1319,10 +1335,18 @@ static int add_wpa_key(struct usbnet *usbdev, const u8 *key, int key_len,
 			key_len);
 		return -EINVAL;
 	}
-	if ((flags & NDIS_80211_ADDKEY_SET_INIT_RECV_SEQ) && !rx_seq) {
-		devdbg(usbdev, "add_wpa_key: recv seq flag without buffer");
-		return -EINVAL;
+	if (flags & NDIS_80211_ADDKEY_SET_INIT_RECV_SEQ) {
+		if (!rx_seq || seq_len <= 0) {
+			devdbg(usbdev, "add_wpa_key: recv seq flag without"
+					"buffer");
+			return -EINVAL;
+		}
+		if (rx_seq && seq_len > sizeof(ndis_key.rsc)) {
+			devdbg(usbdev, "add_wpa_key: too big recv seq buffer");
+			return -EINVAL;
+		}
 	}
+
 	is_addr_ok = addr && !is_zero_ether_addr(addr) &&
 					!is_broadcast_ether_addr(addr);
 	if ((flags & NDIS_80211_ADDKEY_PAIRWISE_KEY) && !is_addr_ok) {
@@ -1353,7 +1377,7 @@ static int add_wpa_key(struct usbnet *usbdev, const u8 *key, int key_len,
 		memcpy(ndis_key.material, key, key_len);
 
 	if (flags & NDIS_80211_ADDKEY_SET_INIT_RECV_SEQ)
-		memcpy(ndis_key.rsc, rx_seq, 6);
+		memcpy(ndis_key.rsc, rx_seq, seq_len);
 
 	if (flags & NDIS_80211_ADDKEY_PAIRWISE_KEY) {
 		/* pairwise key */
@@ -1392,31 +1416,17 @@ static int restore_key(struct usbnet *usbdev, int key_idx)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	struct rndis_wlan_encr_key key;
-	int flags;
+
+	if (is_wpa_key(priv, key_idx))
+		return 0;
 
 	key = priv->encr_keys[key_idx];
 
-	devdbg(usbdev, "restore_key: %i:%s:%i", key_idx,
-		is_wpa_key(priv, key_idx) ? "wpa" : "wep",
-		key.len);
+	devdbg(usbdev, "restore_key: %i:%i", key_idx, key.len);
 
 	if (key.len == 0)
 		return 0;
 
-	if (is_wpa_key(priv, key_idx)) {
-		flags = 0;
-
-		/*if (priv->encr_tx_key_index == key_idx)
-			flags |= NDIS_80211_ADDKEY_TRANSMIT_KEY;*/
-
-		if (!is_zero_ether_addr(key.bssid) &&
-				!is_broadcast_ether_addr(key.bssid))
-			flags |= NDIS_80211_ADDKEY_PAIRWISE_KEY;
-
-		return add_wpa_key(usbdev, key.material, key.len, key_idx,
-					key.bssid, NULL, key.cipher, flags);
-	}
-
 	return add_wep_key(usbdev, key.material, key.len, key_idx);
 }
 
@@ -1437,7 +1447,7 @@ static void clear_key(struct rndis_wlan_private *priv, int idx)
 
 
 /* remove_key is for both wep and wpa */
-static int remove_key(struct usbnet *usbdev, int index, u8 bssid[ETH_ALEN])
+static int remove_key(struct usbnet *usbdev, int index, const u8 *bssid)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	struct ndis_80211_remove_key remove_key;
@@ -2041,6 +2051,69 @@ static int rndis_set_channel(struct wiphy *wiphy,
 			ieee80211_frequency_to_channel(chan->center_freq));
 }
 
+static int rndis_add_key(struct wiphy *wiphy, struct net_device *netdev,
+					u8 key_index, const u8 *mac_addr,
+					struct key_params *params)
+{
+	struct rndis_wlan_private *priv = wiphy_priv(wiphy);
+	struct usbnet *usbdev = priv->usbdev;
+	int flags;
+
+	devdbg(usbdev, "rndis_add_key(%i, %pM, %08x)", key_index, mac_addr,
+							params->cipher);
+
+	switch (params->cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
+		return add_wep_key(usbdev, params->key, params->key_len,
+								key_index);
+	case WLAN_CIPHER_SUITE_TKIP:
+	case WLAN_CIPHER_SUITE_CCMP:
+		flags = 0;
+
+		if (params->seq && params->seq_len > 0)
+			flags |= NDIS_80211_ADDKEY_SET_INIT_RECV_SEQ;
+		if (mac_addr)
+			flags |= NDIS_80211_ADDKEY_PAIRWISE_KEY |
+					NDIS_80211_ADDKEY_TRANSMIT_KEY;
+
+		return add_wpa_key(usbdev, params->key, params->key_len,
+				key_index, mac_addr, params->seq,
+				params->seq_len, params->cipher, flags);
+	default:
+		devdbg(usbdev, "rndis_add_key: unsupported cipher %08x",
+							params->cipher);
+		return -ENOTSUPP;
+	}
+}
+
+static int rndis_del_key(struct wiphy *wiphy, struct net_device *netdev,
+					u8 key_index, const u8 *mac_addr)
+{
+	struct rndis_wlan_private *priv = wiphy_priv(wiphy);
+	struct usbnet *usbdev = priv->usbdev;
+
+	devdbg(usbdev, "rndis_del_key(%i, %pM)", key_index, mac_addr);
+
+	return remove_key(usbdev, key_index, mac_addr);
+}
+
+static int rndis_set_default_key(struct wiphy *wiphy, struct net_device *netdev,
+								u8 key_index)
+{
+	struct rndis_wlan_private *priv = wiphy_priv(wiphy);
+	struct usbnet *usbdev = priv->usbdev;
+	struct rndis_wlan_encr_key key;
+
+	devdbg(usbdev, "rndis_set_default_key(%i)", key_index);
+
+	priv->encr_tx_key_index = key_index;
+
+	key = priv->encr_keys[key_index];
+
+	return add_wep_key(usbdev, key.material, key.len, key_index);
+}
+
 /*
  * wireless extension handlers
  */
@@ -2268,7 +2341,6 @@ static int rndis_iw_get_auth(struct net_device *dev,
 	}
 	return 0;
 }
-#endif
 
 
 static int rndis_iw_set_encode(struct net_device *dev,
@@ -2387,6 +2459,7 @@ static int rndis_iw_set_encode_ext(struct net_device *dev,
 				(u8 *)&ext->addr.sa_data, ext->rx_seq, cipher,
 				flags);
 }
+#endif
 
 
 static int rndis_iw_get_rate(struct net_device *dev,
@@ -2444,8 +2517,8 @@ static const iw_handler rndis_iw_handler[] =
 	IW_IOCTL(SIOCGIWFRAG)      = (iw_handler) cfg80211_wext_giwfrag,
 	IW_IOCTL(SIOCSIWTXPOW)     = (iw_handler) cfg80211_wext_siwtxpower,
 	IW_IOCTL(SIOCGIWTXPOW)     = (iw_handler) cfg80211_wext_giwtxpower,
-	IW_IOCTL(SIOCSIWENCODE)    = rndis_iw_set_encode,
-	IW_IOCTL(SIOCSIWENCODEEXT) = rndis_iw_set_encode_ext,
+	IW_IOCTL(SIOCSIWENCODE)    = (iw_handler) cfg80211_wext_siwencode,
+	IW_IOCTL(SIOCSIWENCODEEXT) = (iw_handler) cfg80211_wext_siwencodeext,
 	IW_IOCTL(SIOCSIWAUTH)      = (iw_handler) cfg80211_wext_siwauth,
 	IW_IOCTL(SIOCGIWAUTH)      = (iw_handler) cfg80211_wext_giwauth,
 	IW_IOCTL(SIOCSIWGENIE)     = (iw_handler) cfg80211_wext_siwgenie,

