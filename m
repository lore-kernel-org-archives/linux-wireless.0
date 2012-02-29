Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:36269 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758036Ab2B2OZI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 09:25:08 -0500
Subject: [PATCH 3/3] rndis_wlan: use u8 for key indexes
To: "John W. Linville" <linville@tuxdriver.com>
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 29 Feb 2012 16:25:05 +0200
Message-ID: <20120229142505.9946.1019.stgit@localhost6.localdomain6> (sfid-20120229_152513_752077_A724DAE4)
In-Reply-To: <20120229142454.9946.57205.stgit@localhost6.localdomain6>
References: <20120229142454.9946.57205.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211 uses u8 for key indexes and so should rndis_wlan.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/rndis_wlan.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 3e0f058..7764668 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -518,7 +518,7 @@ struct rndis_wlan_private {
 	__le32 current_command_oid;
 
 	/* encryption stuff */
-	int  encr_tx_key_index;
+	u8 encr_tx_key_index;
 	struct rndis_wlan_encr_key encr_keys[RNDIS_WLAN_NUM_KEYS];
 	int  wpa_version;
 
@@ -634,7 +634,7 @@ static u32 get_bcm4320_power_dbm(struct rndis_wlan_private *priv)
 	}
 }
 
-static bool is_wpa_key(struct rndis_wlan_private *priv, int idx)
+static bool is_wpa_key(struct rndis_wlan_private *priv, u8 idx)
 {
 	int cipher = priv->encr_keys[idx].cipher;
 
@@ -1377,7 +1377,7 @@ static struct ieee80211_channel *get_current_channel(struct usbnet *usbdev,
 
 /* index must be 0 - N, as per NDIS  */
 static int add_wep_key(struct usbnet *usbdev, const u8 *key, int key_len,
-								int index)
+								u8 index)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	struct ndis_80211_wep_key ndis_key;
@@ -1387,7 +1387,7 @@ static int add_wep_key(struct usbnet *usbdev, const u8 *key, int key_len,
 	netdev_dbg(usbdev->net, "%s(idx: %d, len: %d)\n",
 		   __func__, index, key_len);
 
-	if (index < 0 || index >= RNDIS_WLAN_NUM_KEYS)
+	if (index >= RNDIS_WLAN_NUM_KEYS)
 		return -EINVAL;
 
 	if (key_len == 5)
@@ -1430,7 +1430,7 @@ static int add_wep_key(struct usbnet *usbdev, const u8 *key, int key_len,
 }
 
 static int add_wpa_key(struct usbnet *usbdev, const u8 *key, int key_len,
-			int index, const u8 *addr, const u8 *rx_seq,
+			u8 index, const u8 *addr, const u8 *rx_seq,
 			int seq_len, u32 cipher, __le32 flags)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
@@ -1438,7 +1438,7 @@ static int add_wpa_key(struct usbnet *usbdev, const u8 *key, int key_len,
 	bool is_addr_ok;
 	int ret;
 
-	if (index < 0 || index >= RNDIS_WLAN_NUM_KEYS) {
+	if (index >= RNDIS_WLAN_NUM_KEYS) {
 		netdev_dbg(usbdev->net, "%s(): index out of range (%i)\n",
 			   __func__, index);
 		return -EINVAL;
@@ -1526,7 +1526,7 @@ static int add_wpa_key(struct usbnet *usbdev, const u8 *key, int key_len,
 	return 0;
 }
 
-static int restore_key(struct usbnet *usbdev, int key_idx)
+static int restore_key(struct usbnet *usbdev, u8 key_idx)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	struct rndis_wlan_encr_key key;
@@ -1552,13 +1552,13 @@ static void restore_keys(struct usbnet *usbdev)
 		restore_key(usbdev, i);
 }
 
-static void clear_key(struct rndis_wlan_private *priv, int idx)
+static void clear_key(struct rndis_wlan_private *priv, u8 idx)
 {
 	memset(&priv->encr_keys[idx], 0, sizeof(priv->encr_keys[idx]));
 }
 
 /* remove_key is for both wep and wpa */
-static int remove_key(struct usbnet *usbdev, int index, const u8 *bssid)
+static int remove_key(struct usbnet *usbdev, u8 index, const u8 *bssid)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	struct ndis_80211_remove_key remove_key;

