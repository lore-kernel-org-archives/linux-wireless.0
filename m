Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:58383 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab1J1FGc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 01:06:32 -0400
Subject: [PATCH] rndis_wlan: release BSS structures returned by
 cfg80211_inform_bss()
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Fri, 28 Oct 2011 08:05:58 +0300
Message-ID: <20111028050558.10908.8413.stgit@localhost6.localdomain6> (sfid-20111028_070635_703366_0FA92F60)
In-Reply-To: <1319719502.3944.5.camel@jlt3.sipsolutions.net>
References: <1319719502.3944.5.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch fixes rndis_wlan to release referenced BSS structure returned by
cfg80211_inform_bss().

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/rndis_wlan.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 15464d5..9cc4b8c 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -1972,11 +1972,12 @@ static int rndis_scan(struct wiphy *wiphy, struct net_device *dev,
 	return ret;
 }
 
-static struct cfg80211_bss *rndis_bss_info_update(struct usbnet *usbdev,
-					struct ndis_80211_bssid_ex *bssid)
+static bool rndis_bss_info_update(struct usbnet *usbdev,
+				  struct ndis_80211_bssid_ex *bssid)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	struct ieee80211_channel *channel;
+	struct cfg80211_bss *bss;
 	s32 signal;
 	u64 timestamp;
 	u16 capability;
@@ -2015,9 +2016,12 @@ static struct cfg80211_bss *rndis_bss_info_update(struct usbnet *usbdev,
 	capability = le16_to_cpu(fixed->capabilities);
 	beacon_interval = le16_to_cpu(fixed->beacon_interval);
 
-	return cfg80211_inform_bss(priv->wdev.wiphy, channel, bssid->mac,
+	bss = cfg80211_inform_bss(priv->wdev.wiphy, channel, bssid->mac,
 		timestamp, capability, beacon_interval, ie, ie_len, signal,
 		GFP_KERNEL);
+	cfg80211_put_bss(bss);
+
+	return (bss != NULL);
 }
 
 static struct ndis_80211_bssid_ex *next_bssid_list_item(
@@ -2641,6 +2645,7 @@ static void rndis_wlan_craft_connected_bss(struct usbnet *usbdev, u8 *bssid,
 	struct ieee80211_channel *channel;
 	struct ndis_80211_conf config;
 	struct ndis_80211_ssid ssid;
+	struct cfg80211_bss *bss;
 	s32 signal;
 	u64 timestamp;
 	u16 capability;
@@ -2714,9 +2719,10 @@ static void rndis_wlan_craft_connected_bss(struct usbnet *usbdev, u8 *bssid,
 		bssid, (u32)timestamp, capability, beacon_interval, ie_len,
 		ssid.essid, signal);
 
-	cfg80211_inform_bss(priv->wdev.wiphy, channel, bssid,
+	bss = cfg80211_inform_bss(priv->wdev.wiphy, channel, bssid,
 		timestamp, capability, beacon_interval, ie_buf, ie_len,
 		signal, GFP_KERNEL);
+	cfg80211_put_bss(bss);
 }
 
 /*

