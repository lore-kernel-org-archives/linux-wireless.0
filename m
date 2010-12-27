Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64201 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab0L0OIQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Dec 2010 09:08:16 -0500
Received: by mail-ww0-f44.google.com with SMTP id 36so9024113wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Dec 2010 06:08:15 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 05/10] rt2x00: Fix pointer errors.
Date: Mon, 27 Dec 2010 15:05:55 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201012271504.30848.IvDoorn@gmail.com> <201012271505.15849.IvDoorn@gmail.com> <201012271505.36104.IvDoorn@gmail.com>
In-Reply-To: <201012271505.36104.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012271505.56572.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

Fix some pointer errors in the various calls to memcpy, memset and memmove.

Although none of these errors are fatal (the expression used now results in
the same pointer value) it is better to use the proper expression.
All errors are having to deal with arrays.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00config.c |    8 ++++----
 drivers/net/wireless/rt2x00/rt2x00mac.c    |    8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 70ca937..e7f67d5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -62,13 +62,13 @@ void rt2x00lib_config_intf(struct rt2x00_dev *rt2x00dev,
 	 * This will prevent the device being confused when it wants
 	 * to ACK frames or consideres itself associated.
 	 */
-	memset(&conf.mac, 0, sizeof(conf.mac));
+	memset(conf.mac, 0, sizeof(conf.mac));
 	if (mac)
-		memcpy(&conf.mac, mac, ETH_ALEN);
+		memcpy(conf.mac, mac, ETH_ALEN);
 
-	memset(&conf.bssid, 0, sizeof(conf.bssid));
+	memset(conf.bssid, 0, sizeof(conf.bssid));
 	if (bssid)
-		memcpy(&conf.bssid, bssid, ETH_ALEN);
+		memcpy(conf.bssid, bssid, ETH_ALEN);
 
 	flags |= CONFIG_UPDATE_TYPE;
 	if (mac || (!rt2x00dev->intf_ap_count && !rt2x00dev->intf_sta_count))
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index f8775c4..a2266c7 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -471,17 +471,17 @@ EXPORT_SYMBOL_GPL(rt2x00mac_set_tim);
 static void memcpy_tkip(struct rt2x00lib_crypto *crypto, u8 *key, u8 key_len)
 {
 	if (key_len > NL80211_TKIP_DATA_OFFSET_ENCR_KEY)
-		memcpy(&crypto->key,
+		memcpy(crypto->key,
 		       &key[NL80211_TKIP_DATA_OFFSET_ENCR_KEY],
 		       sizeof(crypto->key));
 
 	if (key_len > NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY)
-		memcpy(&crypto->tx_mic,
+		memcpy(crypto->tx_mic,
 		       &key[NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY],
 		       sizeof(crypto->tx_mic));
 
 	if (key_len > NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY)
-		memcpy(&crypto->rx_mic,
+		memcpy(crypto->rx_mic,
 		       &key[NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY],
 		       sizeof(crypto->rx_mic));
 }
@@ -532,7 +532,7 @@ int rt2x00mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	if (crypto.cipher == CIPHER_TKIP)
 		memcpy_tkip(&crypto, &key->key[0], key->keylen);
 	else
-		memcpy(&crypto.key, &key->key[0], key->keylen);
+		memcpy(crypto.key, &key->key[0], key->keylen);
 	/*
 	 * Each BSS has a maximum of 4 shared keys.
 	 * Shared key index values:
-- 
1.7.2.3

