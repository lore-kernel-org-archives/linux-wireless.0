Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:36188 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758026Ab2B2OY7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 09:24:59 -0500
Subject: [PATCH 1/3] rndis_wlan: fix le16/le32_to_cpu mix up with
 config.beacon_period
To: "John W. Linville" <linville@tuxdriver.com>
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org,
	Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 29 Feb 2012 16:24:54 +0200
Message-ID: <20120229142454.9946.57205.stgit@localhost6.localdomain6> (sfid-20120229_152503_097154_4750EE0A)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

'beacon_period' in 'struct ndis_80211_conf' is __le32 instead of __le16 so
le32_to_cpu must be used instead of le16_to_cpu.

Also correct 'beacon_interval' variables used for passing this value forward
from u16 to u32 and rename those variables 'beacon_period' This is to avoid
confusion because 'beacon_interval' is defined as __le16 at other structure,
'struct ndis_80211_fixed_ies'.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/rndis_wlan.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index a330c69..6a6e729 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -1350,7 +1350,7 @@ static int set_channel(struct usbnet *usbdev, int channel)
 }
 
 static struct ieee80211_channel *get_current_channel(struct usbnet *usbdev,
-						     u16 *beacon_interval)
+						     u32 *beacon_period)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	struct ieee80211_channel *channel;
@@ -1370,8 +1370,8 @@ static struct ieee80211_channel *get_current_channel(struct usbnet *usbdev,
 	if (!channel)
 		return NULL;
 
-	if (beacon_interval)
-		*beacon_interval = le16_to_cpu(config.beacon_period);
+	if (beacon_period)
+		*beacon_period = le32_to_cpu(config.beacon_period);
 	return channel;
 }
 
@@ -2683,7 +2683,7 @@ static void rndis_wlan_craft_connected_bss(struct usbnet *usbdev, u8 *bssid,
 	s32 signal;
 	u64 timestamp;
 	u16 capability;
-	u16 beacon_interval = 0;
+	u32 beacon_period = 0;
 	__le32 rssi;
 	u8 ie_buf[34];
 	int len, ret, ie_len;
@@ -2708,7 +2708,7 @@ static void rndis_wlan_craft_connected_bss(struct usbnet *usbdev, u8 *bssid,
 	}
 
 	/* Get channel and beacon interval */
-	channel = get_current_channel(usbdev, &beacon_interval);
+	channel = get_current_channel(usbdev, &beacon_period);
 	if (!channel) {
 		netdev_warn(usbdev->net, "%s(): could not get channel.\n",
 					__func__);
@@ -2738,11 +2738,11 @@ static void rndis_wlan_craft_connected_bss(struct usbnet *usbdev, u8 *bssid,
 	netdev_dbg(usbdev->net, "%s(): channel:%d(freq), bssid:[%pM], tsf:%d, "
 		"capa:%x, beacon int:%d, resp_ie(len:%d, essid:'%.32s'), "
 		"signal:%d\n", __func__, (channel ? channel->center_freq : -1),
-		bssid, (u32)timestamp, capability, beacon_interval, ie_len,
+		bssid, (u32)timestamp, capability, beacon_period, ie_len,
 		ssid.essid, signal);
 
 	bss = cfg80211_inform_bss(priv->wdev.wiphy, channel, bssid,
-		timestamp, capability, beacon_interval, ie_buf, ie_len,
+		timestamp, capability, beacon_period, ie_buf, ie_len,
 		signal, GFP_KERNEL);
 	cfg80211_put_bss(bss);
 }

