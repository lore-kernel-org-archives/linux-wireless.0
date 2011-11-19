Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:41449 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab1KSLEJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Nov 2011 06:04:09 -0500
Subject: [PATCH 1/5] rndis_wlan: split getting current channel to separate
 function
To: "John W. Linville" <linville@tuxdriver.com>
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org
Date: Sat, 19 Nov 2011 13:04:05 +0200
Message-ID: <20111119110405.11950.91713.stgit@localhost6.localdomain6> (sfid-20111119_120431_201573_26BF6997)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Split getting current channel channel from hardware to separate function
as this function will be needed later in patch 'pass channel info to
cfg80211_roamed()'.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/rndis_wlan.c |   49 +++++++++++++++++++++++--------------
 1 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 620e3c0..37c4c40 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -1347,6 +1347,32 @@ static int set_channel(struct usbnet *usbdev, int channel)
 	return ret;
 }
 
+static struct ieee80211_channel *get_current_channel(struct usbnet *usbdev,
+						     u16 *beacon_interval)
+{
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
+	struct ieee80211_channel *channel;
+	struct ndis_80211_conf config;
+	int len, ret;
+
+	/* Get channel and beacon interval */
+	len = sizeof(config);
+	ret = rndis_query_oid(usbdev, OID_802_11_CONFIGURATION, &config, &len);
+	netdev_dbg(usbdev->net, "%s(): OID_802_11_CONFIGURATION -> %d\n",
+				__func__, ret);
+	if (ret < 0)
+		return NULL;
+
+	channel = ieee80211_get_channel(priv->wdev.wiphy,
+				KHZ_TO_MHZ(le32_to_cpu(config.ds_config)));
+	if (!channel)
+		return NULL;
+
+	if (beacon_interval)
+		*beacon_interval = le16_to_cpu(config.beacon_period);
+	return channel;
+}
+
 /* index must be 0 - N, as per NDIS  */
 static int add_wep_key(struct usbnet *usbdev, const u8 *key, int key_len,
 								int index)
@@ -2650,13 +2676,12 @@ static void rndis_wlan_craft_connected_bss(struct usbnet *usbdev, u8 *bssid,
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	struct ieee80211_channel *channel;
-	struct ndis_80211_conf config;
 	struct ndis_80211_ssid ssid;
 	struct cfg80211_bss *bss;
 	s32 signal;
 	u64 timestamp;
 	u16 capability;
-	u16 beacon_interval;
+	u16 beacon_interval = 0;
 	__le32 rssi;
 	u8 ie_buf[34];
 	int len, ret, ie_len;
@@ -2681,22 +2706,10 @@ static void rndis_wlan_craft_connected_bss(struct usbnet *usbdev, u8 *bssid,
 	}
 
 	/* Get channel and beacon interval */
-	len = sizeof(config);
-	ret = rndis_query_oid(usbdev, OID_802_11_CONFIGURATION, &config, &len);
-	netdev_dbg(usbdev->net, "%s(): OID_802_11_CONFIGURATION -> %d\n",
-				__func__, ret);
-	if (ret >= 0) {
-		beacon_interval = le16_to_cpu(config.beacon_period);
-		channel = ieee80211_get_channel(priv->wdev.wiphy,
-				KHZ_TO_MHZ(le32_to_cpu(config.ds_config)));
-		if (!channel) {
-			netdev_warn(usbdev->net, "%s(): could not get channel."
-						 "\n", __func__);
-			return;
-		}
-	} else {
-		netdev_warn(usbdev->net, "%s(): could not get configuration.\n",
-					 __func__);
+	channel = get_current_channel(usbdev, &beacon_interval);
+	if (!channel) {
+		netdev_warn(usbdev->net, "%s(): could not get channel.\n",
+					__func__);
 		return;
 	}
 

