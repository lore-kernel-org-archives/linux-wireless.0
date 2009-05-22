Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4.dnainternet.fi ([87.94.96.72]:5423 "EHLO
	smtp4.dnainternet.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173AbZEVOkV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 10:40:21 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 2/4] rndis_wlan: explain bits used in key setup code.
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Date: Fri, 22 May 2009 17:40:20 +0300
Message-ID: <20090522144020.8134.76073.stgit@fate.lan>
In-Reply-To: <20090522144012.8134.27669.stgit@fate.lan>
References: <20090522144012.8134.27669.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver uses some unnamed bits to control encryption setup. Move these to
enumerations with proper names explaining their meaning.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index f9b0a35..8609d28 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -196,6 +196,18 @@ enum ndis_80211_priv_filter {
 	ndis_80211_priv_8021x_wep
 };
 
+enum ndis_80211_addkey_bits {
+	ndis_80211_addkey_8021x_auth = cpu_to_le32(1 << 28),
+	ndis_80211_addkey_set_init_recv_seq = cpu_to_le32(1 << 29),
+	ndis_80211_addkey_pairwise_key = cpu_to_le32(1 << 30),
+	ndis_80211_addkey_transmit_key = cpu_to_le32(1 << 31),
+};
+
+enum ndis_80211_addwep_bits {
+	ndis_80211_addwep_perclient_key = cpu_to_le32(1 << 30),
+	ndis_80211_addwep_transmit_key = cpu_to_le32(1 << 31),
+};
+
 struct ndis_80211_ssid {
 	__le32 length;
 	u8 essid[NDIS_802_11_LENGTH_SSID];
@@ -998,7 +1010,7 @@ static int add_wep_key(struct usbnet *usbdev, char *key, int key_len, int index)
 	memcpy(&ndis_key.material, key, key_len);
 
 	if (index == priv->encr_tx_key_index) {
-		ndis_key.index |= cpu_to_le32(1 << 31);
+		ndis_key.index |= ndis_80211_addwep_transmit_key;
 		ret = set_encr_mode(usbdev, IW_AUTH_CIPHER_WEP104,
 						IW_AUTH_CIPHER_NONE);
 		if (ret)
@@ -1044,7 +1056,8 @@ static int remove_key(struct usbnet *usbdev, int index, u8 bssid[ETH_ALEN])
 		if (bssid) {
 			/* pairwise key */
 			if (memcmp(bssid, ffff_bssid, ETH_ALEN) != 0)
-				remove_key.index |= cpu_to_le32(1 << 30);
+				remove_key.index |=
+					ndis_80211_addkey_pairwise_key;
 			memcpy(remove_key.bssid, bssid,
 					sizeof(remove_key.bssid));
 		} else
@@ -1626,7 +1639,7 @@ static int rndis_iw_set_encode_ext(struct net_device *dev,
 
 	if (ext->ext_flags & IW_ENCODE_EXT_RX_SEQ_VALID) {
 		memcpy(ndis_key.rsc, ext->rx_seq, 6);
-		ndis_key.index |= cpu_to_le32(1 << 29);
+		ndis_key.index |= ndis_80211_addkey_set_init_recv_seq;
 	}
 
 	addr = ext->addr.sa_data;
@@ -1638,12 +1651,12 @@ static int rndis_iw_set_encode_ext(struct net_device *dev,
 			get_bssid(usbdev, ndis_key.bssid);
 	} else {
 		/* pairwise key */
-		ndis_key.index |= cpu_to_le32(1 << 30);
+		ndis_key.index |= ndis_80211_addkey_pairwise_key;
 		memcpy(ndis_key.bssid, addr, ETH_ALEN);
 	}
 
 	if (ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY)
-		ndis_key.index |= cpu_to_le32(1 << 31);
+		ndis_key.index |= ndis_80211_addkey_transmit_key;
 
 	if (ext->alg == IW_ENCODE_ALG_TKIP && ext->key_len == 32) {
 		/* wpa_supplicant gives us the Michael MIC RX/TX keys in

