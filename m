Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:54498 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbYFBPnV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2008 11:43:21 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 1/4] rndis_wlan: do link-down state change in worker thread
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Date: Mon, 02 Jun 2008 18:35:21 +0300
Message-ID: <20080602153521.22793.4271.stgit@nanoha.lan> (sfid-20080602_174323_556934_33E21167)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rndis_wext_link_change() is called from within rndis_command() so it
isn't very good place to do any work. Move to worker thread.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 3954897..aaeeec8 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -310,8 +310,9 @@ enum wpa_key_mgmt { KEY_MGMT_802_1X, KEY_MGMT_PSK, KEY_MGMT_NONE,
 #define CAP_MODE_MASK		7
 #define CAP_SUPPORT_TXPOWER	8
 
-#define WORK_CONNECTION_EVENT	(1<<0)
-#define WORK_SET_MULTICAST_LIST	(1<<1)
+#define WORK_LINK_UP		(1<<0)
+#define WORK_LINK_DOWN		(1<<1)
+#define WORK_SET_MULTICAST_LIST	(1<<2)
 
 /* RNDIS device private data */
 struct rndis_wext_private {
@@ -2213,7 +2214,7 @@ static void rndis_wext_worker(struct work_struct *work)
 	int assoc_size = sizeof(*info) + IW_CUSTOM_MAX + 32;
 	int ret, offset;
 
-	if (test_and_clear_bit(WORK_CONNECTION_EVENT, &priv->work_pending)) {
+	if (test_and_clear_bit(WORK_LINK_UP, &priv->work_pending)) {
 		info = kzalloc(assoc_size, GFP_KERNEL);
 		if (!info)
 			goto get_bssid;
@@ -2251,6 +2252,13 @@ get_bssid:
 		}
 	}
 
+	if (test_and_clear_bit(WORK_LINK_DOWN, &priv->work_pending)) {
+		evt.data.flags = 0;
+		evt.data.length = 0;
+		memset(evt.ap_addr.sa_data, 0, ETH_ALEN);
+		wireless_send_event(usbdev->net, SIOCGIWAP, &evt, NULL);
+	}
+
 	if (test_and_clear_bit(WORK_SET_MULTICAST_LIST, &priv->work_pending))
 		set_multicast_list(usbdev);
 }
@@ -2267,18 +2275,10 @@ static void rndis_wext_set_multicast_list(struct net_device *dev)
 static void rndis_wext_link_change(struct usbnet *dev, int state)
 {
 	struct rndis_wext_private *priv = get_rndis_wext_priv(dev);
-	union iwreq_data evt;
 
-	if (state) {
-		/* queue work to avoid recursive calls into rndis_command */
-		set_bit(WORK_CONNECTION_EVENT, &priv->work_pending);
-		queue_work(priv->workqueue, &priv->work);
-	} else {
-		evt.data.flags = 0;
-		evt.data.length = 0;
-		memset(evt.ap_addr.sa_data, 0, ETH_ALEN);
-		wireless_send_event(dev->net, SIOCGIWAP, &evt, NULL);
-	}
+	/* queue work to avoid recursive calls into rndis_command */
+	set_bit(state ? WORK_LINK_UP : WORK_LINK_DOWN, &priv->work_pending);
+	queue_work(priv->workqueue, &priv->work);
 }
 
 

