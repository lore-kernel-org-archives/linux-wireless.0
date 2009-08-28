Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:59939 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbZH1K2I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 06:28:08 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [RFC PATCH 05/10] rndis_wlan: add cfg80211 dump_station
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 28 Aug 2009 13:28:09 +0300
Message-ID: <20090828102808.15684.14742.stgit@fate.lan>
In-Reply-To: <20090828102742.15684.10566.stgit@fate.lan>
References: <20090828102742.15684.10566.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 1be0172..ac873d0 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -531,6 +531,9 @@ static int rndis_set_default_key(struct wiphy *wiphy, struct net_device *netdev,
 static int rndis_get_station(struct wiphy *wiphy, struct net_device *dev,
 					u8 *mac, struct station_info *sinfo);
 
+static int rndis_dump_station(struct wiphy *wiphy, struct net_device *dev,
+			       int idx, u8 *mac, struct station_info *sinfo);
+
 static struct cfg80211_ops rndis_config_ops = {
 	.change_virtual_intf = rndis_change_virtual_intf,
 	.scan = rndis_scan,
@@ -546,6 +549,7 @@ static struct cfg80211_ops rndis_config_ops = {
 	.del_key = rndis_del_key,
 	.set_default_key = rndis_set_default_key,
 	.get_station = rndis_get_station,
+	.dump_station = rndis_dump_station,
 };
 
 static void *rndis_wiphy_privid = &rndis_wiphy_privid;
@@ -2155,6 +2159,22 @@ static int rndis_get_station(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
+static int rndis_dump_station(struct wiphy *wiphy, struct net_device *dev,
+			       int idx, u8 *mac, struct station_info *sinfo)
+{
+	struct rndis_wlan_private *priv = wiphy_priv(wiphy);
+	struct usbnet *usbdev = priv->usbdev;
+
+	if (idx != 0)
+		return -ENOENT;
+
+	memcpy(mac, priv->bssid, ETH_ALEN);
+
+	rndis_fill_station_info(usbdev, sinfo);
+
+	return 0;
+}
+
 /*
  * wireless extension handlers
  */

