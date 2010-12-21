Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tulikuusama.dnainternet.net ([83.102.40.132]:33344 "EHLO
	tulikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751799Ab0LUUoq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 15:44:46 -0500
Subject: [PATCH 6/7] rndis_wlan: add support for set_cqm_rssi_config
To: "John W. Linville" <linville@tuxdriver.com>
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 21 Dec 2010 22:44:42 +0200
Message-ID: <20101221204442.12250.39841.stgit@fate.lan>
In-Reply-To: <20101221204405.12250.35410.stgit@fate.lan>
References: <20101221204405.12250.35410.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Device poller already reads current RSSI, so add support for
set_cqm_rssi_config there.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/rndis_wlan.c |   51 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 50 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index aa21d86..0cd971a 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -478,6 +478,9 @@ struct rndis_wlan_private {
 	struct mutex command_lock;
 	unsigned long work_pending;
 	int last_qual;
+	s32 cqm_rssi_thold;
+	u32 cqm_rssi_hyst;
+	int last_cqm_event_rssi;
 
 	struct ieee80211_supported_band band;
 	struct ieee80211_channel channels[ARRAY_SIZE(rndis_channels)];
@@ -569,6 +572,10 @@ static int rndis_del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 
 static int rndis_flush_pmksa(struct wiphy *wiphy, struct net_device *netdev);
 
+static int rndis_set_cqm_rssi_config(struct wiphy *wiphy,
+					struct net_device *dev,
+					s32 rssi_thold, u32 rssi_hyst);
+
 static const struct cfg80211_ops rndis_config_ops = {
 	.change_virtual_intf = rndis_change_virtual_intf,
 	.scan = rndis_scan,
@@ -588,6 +595,7 @@ static const struct cfg80211_ops rndis_config_ops = {
 	.set_pmksa = rndis_set_pmksa,
 	.del_pmksa = rndis_del_pmksa,
 	.flush_pmksa = rndis_flush_pmksa,
+	.set_cqm_rssi_config = rndis_set_cqm_rssi_config,
 };
 
 static void *rndis_wiphy_privid = &rndis_wiphy_privid;
@@ -2566,6 +2574,19 @@ static int rndis_flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
 	return rndis_set_oid(usbdev, OID_802_11_PMKID, &pmkid, sizeof(pmkid));
 }
 
+static int rndis_set_cqm_rssi_config(struct wiphy *wiphy,
+					struct net_device *dev,
+					s32 rssi_thold, u32 rssi_hyst)
+{
+	struct rndis_wlan_private *priv = wiphy_priv(wiphy);
+
+	priv->cqm_rssi_thold = rssi_thold;
+	priv->cqm_rssi_hyst = rssi_hyst;
+	priv->last_cqm_event_rssi = 0;
+
+	return 0;
+}
+
 static void rndis_wlan_craft_connected_bss(struct usbnet *usbdev, u8 *bssid,
 					   struct ndis_80211_assoc_info *info)
 {
@@ -3095,6 +3116,32 @@ static int rndis_wlan_get_caps(struct usbnet *usbdev, struct wiphy *wiphy)
 	return retval;
 }
 
+static void rndis_do_cqm(struct usbnet *usbdev, s32 rssi)
+{
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
+	enum nl80211_cqm_rssi_threshold_event event;
+	int thold, hyst, last_event;
+
+	if (priv->cqm_rssi_thold >= 0 || rssi >= 0)
+		return;
+	if (priv->infra_mode != NDIS_80211_INFRA_INFRA)
+		return;
+
+	last_event = priv->last_cqm_event_rssi;
+	thold = priv->cqm_rssi_thold;
+	hyst = priv->cqm_rssi_hyst;
+
+	if (rssi < thold && (last_event == 0 || rssi < last_event - hyst))
+		event = NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW;
+	else if (rssi > thold && (last_event == 0 || rssi > last_event + hyst))
+		event = NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH;
+	else
+		return;
+
+	priv->last_cqm_event_rssi = rssi;
+	cfg80211_cqm_rssi_notify(usbdev->net, event, GFP_KERNEL);
+}
+
 #define DEVICE_POLLER_JIFFIES (HZ)
 static void rndis_device_poller(struct work_struct *work)
 {
@@ -3129,8 +3176,10 @@ static void rndis_device_poller(struct work_struct *work)
 
 	len = sizeof(rssi);
 	ret = rndis_query_oid(usbdev, OID_802_11_RSSI, &rssi, &len);
-	if (ret == 0)
+	if (ret == 0) {
 		priv->last_qual = level_to_qual(le32_to_cpu(rssi));
+		rndis_do_cqm(usbdev, le32_to_cpu(rssi));
+	}
 
 	netdev_dbg(usbdev->net, "dev-poller: OID_802_11_RSSI -> %d, rssi:%d, qual: %d\n",
 		   ret, le32_to_cpu(rssi), level_to_qual(le32_to_cpu(rssi)));

