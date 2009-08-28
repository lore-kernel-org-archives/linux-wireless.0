Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:42900 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbZH1K2D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 06:28:03 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [RFC PATCH 04/10] rndis_wlan: add cfg80211 get_station
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 28 Aug 2009 13:28:03 +0300
Message-ID: <20090828102803.15684.91877.stgit@fate.lan>
In-Reply-To: <20090828102742.15684.10566.stgit@fate.lan>
References: <20090828102742.15684.10566.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add cfg80211 get_station and convert SIOCGIWRATE and get_wireless_stats
to cfg80211.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |  118 ++++++++++++++++++-------------------
 1 files changed, 57 insertions(+), 61 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 93b504b..1be0172 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -444,17 +444,14 @@ struct rndis_wlan_private {
 	struct delayed_work scan_work;
 	struct work_struct work;
 	struct mutex command_lock;
-	spinlock_t stats_lock;
 	unsigned long work_pending;
+	int last_qual;
 
 	struct ieee80211_supported_band band;
 	struct ieee80211_channel channels[ARRAY_SIZE(rndis_channels)];
 	struct ieee80211_rate rates[ARRAY_SIZE(rndis_rates)];
 	u32 cipher_suites[ARRAY_SIZE(rndis_cipher_suites)];
 
-	struct iw_statistics iwstats;
-	struct iw_statistics privstats;
-
 	int caps;
 	int multicast_size;
 
@@ -472,6 +469,7 @@ struct rndis_wlan_private {
 	int radio_on;
 	int infra_mode;
 	bool connected;
+	u8 bssid[ETH_ALEN];
 	struct ndis_80211_ssid essid;
 	__le32 current_command_oid;
 
@@ -530,6 +528,9 @@ static int rndis_del_key(struct wiphy *wiphy, struct net_device *netdev,
 static int rndis_set_default_key(struct wiphy *wiphy, struct net_device *netdev,
 								u8 key_index);
 
+static int rndis_get_station(struct wiphy *wiphy, struct net_device *dev,
+					u8 *mac, struct station_info *sinfo);
+
 static struct cfg80211_ops rndis_config_ops = {
 	.change_virtual_intf = rndis_change_virtual_intf,
 	.scan = rndis_scan,
@@ -544,6 +545,7 @@ static struct cfg80211_ops rndis_config_ops = {
 	.add_key = rndis_add_key,
 	.del_key = rndis_del_key,
 	.set_default_key = rndis_set_default_key,
+	.get_station = rndis_get_station,
 };
 
 static void *rndis_wiphy_privid = &rndis_wiphy_privid;
@@ -1931,6 +1933,7 @@ static int rndis_disconnect(struct wiphy *wiphy, struct net_device *dev,
 	devdbg(usbdev, "cfg80211.disconnect(%d)", reason_code);
 
 	priv->connected = false;
+	memset(priv->bssid, 0, ETH_ALEN);
 
 	return deauthenticate(usbdev);
 }
@@ -2037,6 +2040,7 @@ static int rndis_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
 	devdbg(usbdev, "cfg80211.leave_ibss()");
 
 	priv->connected = false;
+	memset(priv->bssid, 0, ETH_ALEN);
 
 	return deauthenticate(usbdev);
 }
@@ -2114,6 +2118,43 @@ static int rndis_set_default_key(struct wiphy *wiphy, struct net_device *netdev,
 	return add_wep_key(usbdev, key.material, key.len, key_index);
 }
 
+static void rndis_fill_station_info(struct usbnet *usbdev,
+						struct station_info *sinfo)
+{
+	__le32 linkspeed, rssi;
+	int ret, len;
+
+	memset(sinfo, 0, sizeof(*sinfo));
+
+	len = sizeof(linkspeed);
+	ret = rndis_query_oid(usbdev, OID_GEN_LINK_SPEED, &linkspeed, &len);
+	if (ret == 0) {
+		sinfo->txrate.legacy = le32_to_cpu(linkspeed) / 1000;
+		sinfo->filled |= STATION_INFO_TX_BITRATE;
+	}
+
+	len = sizeof(rssi);
+	ret = rndis_query_oid(usbdev, OID_802_11_RSSI, &rssi, &len);
+	if (ret == 0) {
+		sinfo->signal = level_to_qual(le32_to_cpu(rssi));
+		sinfo->filled |= STATION_INFO_SIGNAL;
+	}	
+}
+
+static int rndis_get_station(struct wiphy *wiphy, struct net_device *dev,
+					u8 *mac, struct station_info *sinfo)
+{
+	struct rndis_wlan_private *priv = wiphy_priv(wiphy);
+	struct usbnet *usbdev = priv->usbdev;
+
+	if (compare_ether_addr(priv->bssid, mac))
+		return -ENOENT;
+
+	rndis_fill_station_info(usbdev, sinfo);
+
+	return 0;
+}
+
 /*
  * wireless extension handlers
  */
@@ -2459,7 +2500,6 @@ static int rndis_iw_set_encode_ext(struct net_device *dev,
 				(u8 *)&ext->addr.sa_data, ext->rx_seq, cipher,
 				flags);
 }
-#endif
 
 
 static int rndis_iw_get_rate(struct net_device *dev,
@@ -2492,6 +2532,7 @@ static struct iw_statistics *rndis_get_wireless_stats(struct net_device *dev)
 
 	return &priv->iwstats;
 }
+#endif
 
 
 #define IW_IOCTL(x) [(x) - SIOCSIWCOMMIT]
@@ -2510,7 +2551,7 @@ static const iw_handler rndis_iw_handler[] =
 	IW_IOCTL(SIOCGIWSCAN)      = (iw_handler) cfg80211_wext_giwscan,
 	IW_IOCTL(SIOCSIWESSID)     = (iw_handler) cfg80211_wext_siwessid,
 	IW_IOCTL(SIOCGIWESSID)     = (iw_handler) cfg80211_wext_giwessid,
-	IW_IOCTL(SIOCGIWRATE)      = rndis_iw_get_rate,
+	IW_IOCTL(SIOCGIWRATE)      = (iw_handler) cfg80211_wext_giwrate,
 	IW_IOCTL(SIOCSIWRTS)       = (iw_handler) cfg80211_wext_siwrts,
 	IW_IOCTL(SIOCGIWRTS)       = (iw_handler) cfg80211_wext_giwrts,
 	IW_IOCTL(SIOCSIWFRAG)      = (iw_handler) cfg80211_wext_siwfrag,
@@ -2539,7 +2580,7 @@ static const struct iw_handler_def rndis_iw_handlers = {
 	.standard = (iw_handler *)rndis_iw_handler,
 	.private  = (iw_handler *)rndis_wlan_private_handler,
 	.private_args = (struct iw_priv_args *)rndis_wlan_private_args,
-	.get_wireless_stats = rndis_get_wireless_stats,
+	.get_wireless_stats = cfg80211_wireless_stats,
 };
 
 
@@ -2614,6 +2655,7 @@ static void rndis_wlan_do_link_up_work(struct usbnet *usbdev)
 		cfg80211_ibss_joined(usbdev->net, bssid, GFP_KERNEL);
 
 	priv->connected = true;
+	memcpy(priv->bssid, bssid, ETH_ALEN);
 
 	usbnet_resume_rx(usbdev);
 	netif_carrier_on(usbdev->net);
@@ -2928,64 +2970,30 @@ static void rndis_update_wireless_stats(struct work_struct *work)
 	struct rndis_wlan_private *priv =
 		container_of(work, struct rndis_wlan_private, stats_work.work);
 	struct usbnet *usbdev = priv->usbdev;
-	struct iw_statistics iwstats;
 	__le32 rssi, tmp;
 	int len, ret, j;
-	unsigned long flags;
 	int update_jiffies = STATS_UPDATE_JIFFIES;
 	void *buf;
 
-	spin_lock_irqsave(&priv->stats_lock, flags);
-	memcpy(&iwstats, &priv->privstats, sizeof(iwstats));
-	spin_unlock_irqrestore(&priv->stats_lock, flags);
-
-	/* only update stats when connected */
-	if (!is_associated(usbdev)) {
-		iwstats.qual.qual = 0;
-		iwstats.qual.level = 0;
-		iwstats.qual.updated = IW_QUAL_QUAL_UPDATED
-				| IW_QUAL_LEVEL_UPDATED
-				| IW_QUAL_NOISE_INVALID
-				| IW_QUAL_QUAL_INVALID
-				| IW_QUAL_LEVEL_INVALID;
+	/* Only check/do workaround when connected. Calling is_associated()
+	 * also polls device with rndis_command() and catches for media link
+	 * indications.
+	 */
+	if (!is_associated(usbdev))
 		goto end;
-	}
 
 	len = sizeof(rssi);
 	ret = rndis_query_oid(usbdev, OID_802_11_RSSI, &rssi, &len);
+	if (ret == 0)
+		priv->last_qual = level_to_qual(le32_to_cpu(rssi));
 
 	devdbg(usbdev, "stats: OID_802_11_RSSI -> %d, rssi:%d", ret,
 							le32_to_cpu(rssi));
-	if (ret == 0) {
-		memset(&iwstats.qual, 0, sizeof(iwstats.qual));
-		iwstats.qual.qual  = level_to_qual(le32_to_cpu(rssi));
-		iwstats.qual.level = level_to_qual(le32_to_cpu(rssi));
-		iwstats.qual.updated = IW_QUAL_QUAL_UPDATED
-				| IW_QUAL_LEVEL_UPDATED
-				| IW_QUAL_NOISE_INVALID;
-	}
-
-	memset(&iwstats.discard, 0, sizeof(iwstats.discard));
-
-	len = sizeof(tmp);
-	ret = rndis_query_oid(usbdev, OID_GEN_XMIT_ERROR, &tmp, &len);
-	if (ret == 0)
-		iwstats.discard.misc += le32_to_cpu(tmp);
-
-	len = sizeof(tmp);
-	ret = rndis_query_oid(usbdev, OID_GEN_RCV_ERROR, &tmp, &len);
-	if (ret == 0)
-		iwstats.discard.misc += le32_to_cpu(tmp);
-
-	len = sizeof(tmp);
-	ret = rndis_query_oid(usbdev, OID_GEN_RCV_NO_BUFFER, &tmp, &len);
-	if (ret == 0)
-		iwstats.discard.misc += le32_to_cpu(tmp);
 
 	/* Workaround transfer stalls on poor quality links.
 	 * TODO: find right way to fix these stalls (as stalls do not happen
 	 * with ndiswrapper/windows driver). */
-	if (iwstats.qual.qual <= 25) {
+	if (priv->last_qual <= 25) {
 		/* Decrease stats worker interval to catch stalls.
 		 * faster. Faster than 400-500ms causes packet loss,
 		 * Slower doesn't catch stalls fast enough.
@@ -3013,9 +3021,6 @@ static void rndis_update_wireless_stats(struct work_struct *work)
 		kfree(buf);
 	}
 end:
-	spin_lock_irqsave(&priv->stats_lock, flags);
-	memcpy(&priv->privstats, &iwstats, sizeof(iwstats));
-	spin_unlock_irqrestore(&priv->stats_lock, flags);
 
 	if (update_jiffies >= HZ)
 		update_jiffies = round_jiffies_relative(update_jiffies);
@@ -3146,7 +3151,6 @@ static int rndis_wlan_bind(struct usbnet *usbdev, struct usb_interface *intf)
 	priv->usbdev = usbdev;
 
 	mutex_init(&priv->command_lock);
-	spin_lock_init(&priv->stats_lock);
 
 	/* because rndis_command() sleeps we need to use workqueue */
 	priv->workqueue = create_singlethread_workqueue("rndis_wlan");
@@ -3183,14 +3187,6 @@ static int rndis_wlan_bind(struct usbnet *usbdev, struct usb_interface *intf)
 	else
 		usbdev->net->flags &= ~IFF_MULTICAST;
 
-	priv->iwstats.qual.qual = 0;
-	priv->iwstats.qual.level = 0;
-	priv->iwstats.qual.updated = IW_QUAL_QUAL_UPDATED
-					| IW_QUAL_LEVEL_UPDATED
-					| IW_QUAL_NOISE_INVALID
-					| IW_QUAL_QUAL_INVALID
-					| IW_QUAL_LEVEL_INVALID;
-
 	/* fill-out wiphy structure and register w/ cfg80211 */
 	memcpy(wiphy->perm_addr, usbdev->net->dev_addr, ETH_ALEN);
 	wiphy->privid = rndis_wiphy_privid;

