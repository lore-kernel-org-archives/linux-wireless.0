Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3.dnainternet.fi ([87.94.96.71]:15342 "EHLO
	smtp3.dnainternet.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757476AbZEVOkh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 10:40:37 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 4/4] rndis_wlan: do not try to restore wpa keys using
	add_wep_key()
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Date: Fri, 22 May 2009 17:40:34 +0300
Message-ID: <20090522144034.8134.34598.stgit@fate.lan>
In-Reply-To: <20090522144012.8134.27669.stgit@fate.lan>
References: <20090522144012.8134.27669.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

set_infra_mode() tried to restore wpa keys using add_wep_key(). This never
worked so prevent driver from trying.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 16427a6..2465e62 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -405,6 +405,7 @@ struct rndis_wext_private {
 	int  encr_tx_key_index;
 	char encr_keys[4][32];
 	int  encr_key_len[4];
+	char encr_key_wpa[4];
 	int  wpa_version;
 	int  wpa_keymgmt;
 	int  wpa_authalg;
@@ -956,7 +957,7 @@ static int set_infra_mode(struct usbnet *usbdev, int mode)
 	if (priv->wpa_keymgmt == 0 ||
 		priv->wpa_keymgmt == IW_AUTH_KEY_MGMT_802_1X) {
 		for (i = 0; i < 4; i++) {
-			if (priv->encr_key_len[i] > 0)
+			if (priv->encr_key_len[i] > 0 && !priv->encr_key_wpa[i])
 				add_wep_key(usbdev, priv->encr_keys[i],
 						priv->encr_key_len[i], i);
 		}
@@ -1027,6 +1028,7 @@ static int add_wep_key(struct usbnet *usbdev, char *key, int key_len, int index)
 	}
 
 	priv->encr_key_len[index] = key_len;
+	priv->encr_key_wpa[index] = 0;
 	memcpy(&priv->encr_keys[index], key, key_len);
 
 	return 0;
@@ -1092,7 +1094,8 @@ static int add_wpa_key(struct usbnet *usbdev, const u8 *key, int key_len,
 		return ret;
 
 	priv->encr_key_len[index] = key_len;
-	memcpy(&priv->encr_keys[index], ndis_key.material, key_len);
+	priv->encr_key_wpa[index] = 1;
+
 	if (flags & ndis_80211_addkey_transmit_key)
 		priv->encr_tx_key_index = index;
 
@@ -1112,6 +1115,7 @@ static int remove_key(struct usbnet *usbdev, int index, u8 bssid[ETH_ALEN])
 		return 0;
 
 	priv->encr_key_len[index] = 0;
+	priv->encr_key_wpa[index] = 0;
 	memset(&priv->encr_keys[index], 0, sizeof(priv->encr_keys[index]));
 
 	if (priv->wpa_cipher_pair == IW_AUTH_CIPHER_TKIP ||

