Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sinikuusama.dnainternet.net ([83.102.40.134]:49818 "EHLO
	sinikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752490Ab0ERIUw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 May 2010 04:20:52 -0400
Subject: [PATCH] rndis_wlan: replace wireless_send_event with
	cfg80211_disconnected in rndis_wlan_do_link_down_work
To: "John W. Linville" <linville@tuxdriver.com>
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: =?utf-8?q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>,
	linux-wireless@vger.kernel.org
Date: Tue, 18 May 2010 11:20:51 +0300
Message-ID: <20100518082051.18988.85196.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove (hopefully) last use of WEXT in rndis_wlan. Replace wireless_send_event
with missing cfg80211_disconnected in rndis_wlan_do_link_down_work.

Reported-by: "Rogério Brito" <rbrito@ime.usp.br>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/rndis_wlan.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 393f600..b280ad1 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2572,14 +2572,18 @@ static void rndis_wlan_do_link_up_work(struct usbnet *usbdev)
 
 static void rndis_wlan_do_link_down_work(struct usbnet *usbdev)
 {
-	union iwreq_data evt;
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 
-	netif_carrier_off(usbdev->net);
+	if (priv->connected) {
+		priv->connected = false;
+		memset(priv->bssid, 0, ETH_ALEN);
+
+		deauthenticate(usbdev);
 
-	evt.data.flags = 0;
-	evt.data.length = 0;
-	memset(evt.ap_addr.sa_data, 0, ETH_ALEN);
-	wireless_send_event(usbdev->net, SIOCGIWAP, &evt, NULL);
+		cfg80211_disconnected(usbdev->net, 0, NULL, 0, GFP_KERNEL);
+	}
+
+	netif_carrier_off(usbdev->net);
 }
 
 static void rndis_wlan_worker(struct work_struct *work)

