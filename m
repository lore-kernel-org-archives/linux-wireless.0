Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52483 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab2COON3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 10:13:29 -0400
Subject: [PATCH] rndis_wlan: don't report station signal
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Mar 2012 15:13:25 +0100
Message-ID: <1331820805.3432.17.camel@jlt3.sipsolutions.net> (sfid-20120315_151332_776986_E60095A8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The station signal value is supposed to be in dBm
which the device can't give, so don't report it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/rndis_wlan.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/drivers/net/wireless/rndis_wlan.c	2012-03-10 09:17:00.000000000 +0100
+++ b/drivers/net/wireless/rndis_wlan.c	2012-03-15 15:11:52.000000000 +0100
@@ -2505,7 +2505,7 @@ static int rndis_set_default_key(struct
 static void rndis_fill_station_info(struct usbnet *usbdev,
 						struct station_info *sinfo)
 {
-	__le32 linkspeed, rssi;
+	__le32 linkspeed;
 	int ret, len;
 
 	memset(sinfo, 0, sizeof(*sinfo));
@@ -2516,13 +2516,6 @@ static void rndis_fill_station_info(stru
 		sinfo->txrate.legacy = le32_to_cpu(linkspeed) / 1000;
 		sinfo->filled |= STATION_INFO_TX_BITRATE;
 	}
-
-	len = sizeof(rssi);
-	ret = rndis_query_oid(usbdev, OID_802_11_RSSI, &rssi, &len);
-	if (ret == 0) {
-		sinfo->signal = level_to_qual(le32_to_cpu(rssi));
-		sinfo->filled |= STATION_INFO_SIGNAL;
-	}
 }
 
 static int rndis_get_station(struct wiphy *wiphy, struct net_device *dev,


