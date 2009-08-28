Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:43342 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbZH1K2N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 06:28:13 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [RFC PATCH 06/10] rndis_wlan: rename wireless stats worker to device
	poller
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 28 Aug 2009 13:28:14 +0300
Message-ID: <20090828102814.15684.82322.stgit@fate.lan>
In-Reply-To: <20090828102742.15684.10566.stgit@fate.lan>
References: <20090828102742.15684.10566.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stats worker no longer poll stats from device anymore. It's still
needed to poll device control channel for connect/disconnect events,
so rename stats worker as device poller.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |   36 +++++++++++++++++++-----------------
 1 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index ac873d0..919b268 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -440,7 +440,7 @@ struct rndis_wlan_private {
 	struct cfg80211_scan_request *scan_request;
 
 	struct workqueue_struct *workqueue;
-	struct delayed_work stats_work;
+	struct delayed_work dev_poller_work;
 	struct delayed_work scan_work;
 	struct work_struct work;
 	struct mutex command_lock;
@@ -2984,15 +2984,16 @@ static int rndis_wlan_get_caps(struct usbnet *usbdev)
 }
 
 
-#define STATS_UPDATE_JIFFIES (HZ)
-static void rndis_update_wireless_stats(struct work_struct *work)
+#define DEVICE_POLLER_JIFFIES (HZ)
+static void rndis_device_poller(struct work_struct *work)
 {
 	struct rndis_wlan_private *priv =
-		container_of(work, struct rndis_wlan_private, stats_work.work);
+		container_of(work, struct rndis_wlan_private,
+							dev_poller_work.work);
 	struct usbnet *usbdev = priv->usbdev;
 	__le32 rssi, tmp;
 	int len, ret, j;
-	int update_jiffies = STATS_UPDATE_JIFFIES;
+	int update_jiffies = DEVICE_POLLER_JIFFIES;
 	void *buf;
 
 	/* Only check/do workaround when connected. Calling is_associated()
@@ -3007,8 +3008,8 @@ static void rndis_update_wireless_stats(struct work_struct *work)
 	if (ret == 0)
 		priv->last_qual = level_to_qual(le32_to_cpu(rssi));
 
-	devdbg(usbdev, "stats: OID_802_11_RSSI -> %d, rssi:%d", ret,
-							le32_to_cpu(rssi));
+	devdbg(usbdev, "dev-poller: OID_802_11_RSSI -> %d, rssi:%d, qual: %d",
+		ret, le32_to_cpu(rssi), level_to_qual(le32_to_cpu(rssi)));
 
 	/* Workaround transfer stalls on poor quality links.
 	 * TODO: find right way to fix these stalls (as stalls do not happen
@@ -3019,8 +3020,8 @@ static void rndis_update_wireless_stats(struct work_struct *work)
 		 * Slower doesn't catch stalls fast enough.
 		 */
 		j = msecs_to_jiffies(priv->param_workaround_interval);
-		if (j > STATS_UPDATE_JIFFIES)
-			j = STATS_UPDATE_JIFFIES;
+		if (j > DEVICE_POLLER_JIFFIES)
+			j = DEVICE_POLLER_JIFFIES;
 		else if (j <= 0)
 			j = 1;
 		update_jiffies = j;
@@ -3040,8 +3041,8 @@ static void rndis_update_wireless_stats(struct work_struct *work)
 		rndis_query_oid(usbdev, OID_802_11_BSSID_LIST, buf, &len);
 		kfree(buf);
 	}
-end:
 
+end:
 	if (update_jiffies >= HZ)
 		update_jiffies = round_jiffies_relative(update_jiffies);
 	else {
@@ -3050,7 +3051,8 @@ end:
 			update_jiffies = j;
 	}
 
-	queue_delayed_work(priv->workqueue, &priv->stats_work, update_jiffies);
+	queue_delayed_work(priv->workqueue, &priv->dev_poller_work,
+								update_jiffies);
 }
 
 
@@ -3175,7 +3177,7 @@ static int rndis_wlan_bind(struct usbnet *usbdev, struct usb_interface *intf)
 	/* because rndis_command() sleeps we need to use workqueue */
 	priv->workqueue = create_singlethread_workqueue("rndis_wlan");
 	INIT_WORK(&priv->work, rndis_wlan_worker);
-	INIT_DELAYED_WORK(&priv->stats_work, rndis_update_wireless_stats);
+	INIT_DELAYED_WORK(&priv->dev_poller_work, rndis_device_poller);
 	INIT_DELAYED_WORK(&priv->scan_work, rndis_get_scan_results);
 
 	/* try bind rndis_host */
@@ -3252,7 +3254,7 @@ static int rndis_wlan_bind(struct usbnet *usbdev, struct usb_interface *intf)
 	return 0;
 
 fail:
-	cancel_delayed_work_sync(&priv->stats_work);
+	cancel_delayed_work_sync(&priv->dev_poller_work);
 	cancel_delayed_work_sync(&priv->scan_work);
 	cancel_work_sync(&priv->work);
 	flush_workqueue(priv->workqueue);
@@ -3270,7 +3272,7 @@ static void rndis_wlan_unbind(struct usbnet *usbdev, struct usb_interface *intf)
 	/* turn radio off */
 	disassociate(usbdev, 0);
 
-	cancel_delayed_work_sync(&priv->stats_work);
+	cancel_delayed_work_sync(&priv->dev_poller_work);
 	cancel_delayed_work_sync(&priv->scan_work);
 	cancel_work_sync(&priv->work);
 	flush_workqueue(priv->workqueue);
@@ -3301,8 +3303,8 @@ static int rndis_wlan_reset(struct usbnet *usbdev)
 	   (set_multicast_list() also turns on current packet filter) */
 	set_multicast_list(usbdev);
 
-	queue_delayed_work(priv->workqueue, &priv->stats_work,
-		round_jiffies_relative(STATS_UPDATE_JIFFIES));
+	queue_delayed_work(priv->workqueue, &priv->dev_poller_work,
+		round_jiffies_relative(DEVICE_POLLER_JIFFIES));
 
 	return deauthenticate(usbdev);
 }
@@ -3319,7 +3321,7 @@ static int rndis_wlan_stop(struct usbnet *usbdev)
 	retval = disassociate(usbdev, 0);
 
 	priv->work_pending = 0;
-	cancel_delayed_work_sync(&priv->stats_work);
+	cancel_delayed_work_sync(&priv->dev_poller_work);
 	cancel_delayed_work_sync(&priv->scan_work);
 	cancel_work_sync(&priv->work);
 	flush_workqueue(priv->workqueue);

