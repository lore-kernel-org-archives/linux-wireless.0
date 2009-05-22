Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4.dnainternet.fi ([87.94.96.72]:5446 "EHLO
	smtp4.dnainternet.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756969AbZEVOk2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 10:40:28 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 3/4] rndis_wlan: split add_wpa_key from rndis_iw_set_encode_ext
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Date: Fri, 22 May 2009 17:40:27 +0300
Message-ID: <20090522144027.8134.86470.stgit@fate.lan>
In-Reply-To: <20090522144012.8134.27669.stgit@fate.lan>
References: <20090522144012.8134.27669.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Split add_wpa_key() from rndis_iw_set_encode_ext so that conversion to cfg80211
would be easier later on.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |  129 ++++++++++++++++++++++---------------
 1 files changed, 76 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 8609d28..16427a6 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -1033,6 +1033,73 @@ static int add_wep_key(struct usbnet *usbdev, char *key, int key_len, int index)
 }
 
 
+static int add_wpa_key(struct usbnet *usbdev, const u8 *key, int key_len,
+			int index, const struct sockaddr *addr,
+			const u8 *rx_seq, int alg, int flags)
+{
+	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
+	struct ndis_80211_key ndis_key;
+	int ret;
+
+	if (index < 0 || index >= 4)
+		return -EINVAL;
+	if (key_len > sizeof(ndis_key.material) || key_len < 0)
+		return -EINVAL;
+	if ((flags & ndis_80211_addkey_set_init_recv_seq) && !rx_seq)
+		return -EINVAL;
+	if ((flags & ndis_80211_addkey_pairwise_key) && !addr)
+		return -EINVAL;
+
+	devdbg(usbdev, "add_wpa_key(%i): flags:%i%i%i", index,
+			!!(flags & ndis_80211_addkey_transmit_key),
+			!!(flags & ndis_80211_addkey_pairwise_key),
+			!!(flags & ndis_80211_addkey_set_init_recv_seq));
+
+	memset(&ndis_key, 0, sizeof(ndis_key));
+
+	ndis_key.size = cpu_to_le32(sizeof(ndis_key) -
+				sizeof(ndis_key.material) + key_len);
+	ndis_key.length = cpu_to_le32(key_len);
+	ndis_key.index = cpu_to_le32(index) | flags;
+
+	if (alg == IW_ENCODE_ALG_TKIP && key_len == 32) {
+		/* wpa_supplicant gives us the Michael MIC RX/TX keys in
+		 * different order than NDIS spec, so swap the order here. */
+		memcpy(ndis_key.material, key, 16);
+		memcpy(ndis_key.material + 16, key + 24, 8);
+		memcpy(ndis_key.material + 24, key + 16, 8);
+	} else
+		memcpy(ndis_key.material, key, key_len);
+
+	if (flags & ndis_80211_addkey_set_init_recv_seq)
+		memcpy(ndis_key.rsc, rx_seq, 6);
+
+	if (flags & ndis_80211_addkey_pairwise_key) {
+		/* pairwise key */
+		memcpy(ndis_key.bssid, addr->sa_data, ETH_ALEN);
+	} else {
+		/* group key */
+		if (priv->infra_mode == ndis_80211_infra_adhoc)
+			memset(ndis_key.bssid, 0xff, ETH_ALEN);
+		else
+			get_bssid(usbdev, ndis_key.bssid);
+	}
+
+	ret = rndis_set_oid(usbdev, OID_802_11_ADD_KEY, &ndis_key,
+					le32_to_cpu(ndis_key.size));
+	devdbg(usbdev, "add_wpa_key: OID_802_11_ADD_KEY -> %08X", ret);
+	if (ret != 0)
+		return ret;
+
+	priv->encr_key_len[index] = key_len;
+	memcpy(&priv->encr_keys[index], ndis_key.material, key_len);
+	if (flags & ndis_80211_addkey_transmit_key)
+		priv->encr_tx_key_index = index;
+
+	return 0;
+}
+
+
 /* remove_key is for both wep and wpa */
 static int remove_key(struct usbnet *usbdev, int index, u8 bssid[ETH_ALEN])
 {
@@ -1602,9 +1669,7 @@ static int rndis_iw_set_encode_ext(struct net_device *dev,
 	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
 	struct usbnet *usbdev = netdev_priv(dev);
 	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
-	struct ndis_80211_key ndis_key;
-	int keyidx, ret;
-	u8 *addr;
+	int keyidx, flags;
 
 	keyidx = wrqu->encoding.flags & IW_ENCODE_INDEX;
 
@@ -1627,58 +1692,16 @@ static int rndis_iw_set_encode_ext(struct net_device *dev,
 	    ext->alg == IW_ENCODE_ALG_NONE || ext->key_len == 0)
 		return remove_key(usbdev, keyidx, NULL);
 
-	if (ext->key_len > sizeof(ndis_key.material))
-		return -1;
-
-	memset(&ndis_key, 0, sizeof(ndis_key));
-
-	ndis_key.size = cpu_to_le32(sizeof(ndis_key) -
-				sizeof(ndis_key.material) + ext->key_len);
-	ndis_key.length = cpu_to_le32(ext->key_len);
-	ndis_key.index = cpu_to_le32(keyidx);
-
-	if (ext->ext_flags & IW_ENCODE_EXT_RX_SEQ_VALID) {
-		memcpy(ndis_key.rsc, ext->rx_seq, 6);
-		ndis_key.index |= ndis_80211_addkey_set_init_recv_seq;
-	}
-
-	addr = ext->addr.sa_data;
-	if (ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY) {
-		/* group key */
-		if (priv->infra_mode == ndis_80211_infra_adhoc)
-			memset(ndis_key.bssid, 0xff, ETH_ALEN);
-		else
-			get_bssid(usbdev, ndis_key.bssid);
-	} else {
-		/* pairwise key */
-		ndis_key.index |= ndis_80211_addkey_pairwise_key;
-		memcpy(ndis_key.bssid, addr, ETH_ALEN);
-	}
-
+	flags = 0;
+	if (ext->ext_flags & IW_ENCODE_EXT_RX_SEQ_VALID)
+		flags |= ndis_80211_addkey_set_init_recv_seq;
+	if (!(ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY))
+		flags |= ndis_80211_addkey_pairwise_key;
 	if (ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY)
-		ndis_key.index |= ndis_80211_addkey_transmit_key;
-
-	if (ext->alg == IW_ENCODE_ALG_TKIP && ext->key_len == 32) {
-		/* wpa_supplicant gives us the Michael MIC RX/TX keys in
-		 * different order than NDIS spec, so swap the order here. */
-		memcpy(ndis_key.material, ext->key, 16);
-		memcpy(ndis_key.material + 16, ext->key + 24, 8);
-		memcpy(ndis_key.material + 24, ext->key + 16, 8);
-	} else
-		memcpy(ndis_key.material, ext->key, ext->key_len);
+		flags |= ndis_80211_addkey_transmit_key;
 
-	ret = rndis_set_oid(usbdev, OID_802_11_ADD_KEY, &ndis_key,
-					le32_to_cpu(ndis_key.size));
-	devdbg(usbdev, "SIOCSIWENCODEEXT: OID_802_11_ADD_KEY -> %08X", ret);
-	if (ret != 0)
-		return ret;
-
-	priv->encr_key_len[keyidx] = ext->key_len;
-	memcpy(&priv->encr_keys[keyidx], ndis_key.material, ext->key_len);
-	if (ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY)
-		priv->encr_tx_key_index = keyidx;
-
-	return 0;
+	return add_wpa_key(usbdev, ext->key, ext->key_len, keyidx, &ext->addr,
+				ext->rx_seq, ext->alg, flags);
 }
 
 

