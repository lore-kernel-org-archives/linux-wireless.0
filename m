Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:63366 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab1JRGr6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 02:47:58 -0400
Date: Tue, 18 Oct 2011 09:47:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] rndis_wlan: add range check in del_key()
Message-ID: <20111018064729.GQ27732@elgon.mountain> (sfid-20111018_084803_556321_DCB3993A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wifi drivers can have up to 6 keys but the rndis_wlan only has 4 so
it needs to have its own checks to make sure we don't go out of
bounds.  The add_key() function already checks but I added some
checks to del_key() and set_default_key().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 0c13840..da78369 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -414,6 +414,7 @@ struct ndis_80211_pmkid {
 #define RNDIS_WLAN_ALG_TKIP	(1<<1)
 #define RNDIS_WLAN_ALG_CCMP	(1<<2)
 
+#define RNDIS_WLAN_NUM_KEYS		4
 #define RNDIS_WLAN_KEY_MGMT_NONE	0
 #define RNDIS_WLAN_KEY_MGMT_802_1X	(1<<0)
 #define RNDIS_WLAN_KEY_MGMT_PSK		(1<<1)
@@ -516,7 +517,7 @@ struct rndis_wlan_private {
 
 	/* encryption stuff */
 	int  encr_tx_key_index;
-	struct rndis_wlan_encr_key encr_keys[4];
+	struct rndis_wlan_encr_key encr_keys[RNDIS_WLAN_NUM_KEYS];
 	int  wpa_version;
 
 	u8 command_buffer[COMMAND_BUFFER_SIZE];
@@ -1535,6 +1536,9 @@ static int remove_key(struct usbnet *usbdev, int index, const u8 *bssid)
 	bool is_wpa;
 	int ret;
 
+	if (index >= RNDIS_WLAN_NUM_KEYS)
+		return -ENOENT;
+
 	if (priv->encr_keys[index].len == 0)
 		return 0;
 
@@ -2451,6 +2455,9 @@ static int rndis_set_default_key(struct wiphy *wiphy, struct net_device *netdev,
 
 	netdev_dbg(usbdev->net, "%s(%i)\n", __func__, key_index);
 
+	if (key_index >= RNDIS_WLAN_NUM_KEYS)
+		return -ENOENT;
+
 	priv->encr_tx_key_index = key_index;
 
 	if (is_wpa_key(priv, key_index))
