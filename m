Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:39208 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbZHFSRs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 14:17:48 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH] rndis_wlan: wait association to complete
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Date: Thu, 06 Aug 2009 21:17:47 +0300
Message-ID: <20090806181746.31308.15687.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix WPA authentication problems by waiting to association to complete.
Otherwise userspace (wpa_supplicant) receives authentication packets before
association events from driver.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |   47 +++++++++++++++++++++++++++++++++----
 1 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 828dc18..f2e7505 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -378,6 +378,7 @@ enum wpa_key_mgmt { KEY_MGMT_802_1X, KEY_MGMT_PSK, KEY_MGMT_NONE,
 #define WORK_LINK_UP		(1<<0)
 #define WORK_LINK_DOWN		(1<<1)
 #define WORK_SET_MULTICAST_LIST	(1<<2)
+#define WORK_ASSOC_WAIT		(1<<3)
 
 #define COMMAND_BUFFER_SIZE	(CONTROL_BUFFER_SIZE + sizeof(struct rndis_set))
 
@@ -436,6 +437,7 @@ struct rndis_wlan_private {
 	struct work_struct work;
 	struct mutex command_lock;
 	spinlock_t stats_lock;
+	struct completion assoc_wait;
 	unsigned long work_pending;
 
 	struct ieee80211_supported_band band;
@@ -936,7 +938,9 @@ static int get_essid(struct usbnet *usbdev, struct ndis_80211_ssid *ssid)
 }
 
 
-static int set_essid(struct usbnet *usbdev, struct ndis_80211_ssid *ssid)
+#define ASSOC_TIMEOUT_JIFFIES (HZ*10)
+static int set_essid(struct usbnet *usbdev, struct ndis_80211_ssid *ssid,
+								bool wait)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	int ret;
@@ -948,6 +952,21 @@ static int set_essid(struct usbnet *usbdev, struct ndis_80211_ssid *ssid)
 		devdbg(usbdev, "set_essid: radio_on = 1");
 	}
 
+	if (!wait)
+		return ret;
+
+	/* If we return now, userspace would get association events too late
+	 * (after receiving first packets from access point). This causes
+	 * WPA authentication to fail.
+	 */
+	set_bit(WORK_ASSOC_WAIT, &priv->work_pending);
+	queue_work(priv->workqueue, &priv->work);
+
+	wait_for_completion_interruptible_timeout(&priv->assoc_wait,
+							ASSOC_TIMEOUT_JIFFIES);
+
+	clear_bit(WORK_ASSOC_WAIT, &priv->work_pending);
+
 	return ret;
 }
 
@@ -1009,7 +1028,7 @@ static int disassociate(struct usbnet *usbdev, int reset_ssid)
 		ssid.essid[1] = 0xff;
 		for (i = 2; i < sizeof(ssid.essid); i++)
 			ssid.essid[i] = 0x1 + (ssid.essid[i] * 0xfe / 0xff);
-		ret = set_essid(usbdev, &ssid);
+		ret = set_essid(usbdev, &ssid, false);
 	}
 	return ret;
 }
@@ -1765,7 +1784,7 @@ static int rndis_iw_set_essid(struct net_device *dev,
 	if (!wrqu->essid.flags || length == 0)
 		return disassociate(usbdev, 1);
 	else
-		return set_essid(usbdev, &ssid);
+		return set_essid(usbdev, &ssid, true);
 }
 
 
@@ -2006,7 +2025,7 @@ static int rndis_iw_set_encode(struct net_device *dev,
 
 	if (index == priv->encr_tx_key_index)
 		/* ndis drivers want essid to be set after setting encr */
-		set_essid(usbdev, &priv->essid);
+		set_essid(usbdev, &priv->essid, false);
 
 	return 0;
 }
@@ -2288,7 +2307,20 @@ static void rndis_wlan_worker(struct work_struct *work)
 	unsigned char bssid[ETH_ALEN];
 	struct ndis_80211_assoc_info *info;
 	int assoc_size = sizeof(*info) + IW_CUSTOM_MAX + 32;
-	int ret, offset;
+	int ret, offset, len;
+	__le32 tmp = 0;
+
+	if (test_bit(WORK_ASSOC_WAIT, &priv->work_pending)) {
+		/* dummy OID to poll device */
+		len = sizeof(tmp);
+		rndis_query_oid(usbdev, OID_GEN_XMIT_ERROR, &tmp, &len);
+
+		/* requeue work if no link up response from device */
+		if (!test_bit(WORK_LINK_UP, &priv->work_pending)) {
+			msleep(10);
+			queue_work(priv->workqueue, &priv->work);
+		}
+	}
 
 	if (test_and_clear_bit(WORK_LINK_UP, &priv->work_pending)) {
 		netif_carrier_on(usbdev->net);
@@ -2328,6 +2360,8 @@ get_bssid:
 			memcpy(evt.ap_addr.sa_data, bssid, ETH_ALEN);
 			wireless_send_event(usbdev->net, SIOCGIWAP, &evt, NULL);
 		}
+
+		complete_all(&priv->assoc_wait);
 	}
 
 	if (test_and_clear_bit(WORK_LINK_DOWN, &priv->work_pending)) {
@@ -2830,6 +2864,7 @@ static int rndis_wlan_bind(struct usbnet *usbdev, struct usb_interface *intf)
 
 	mutex_init(&priv->command_lock);
 	spin_lock_init(&priv->stats_lock);
+	init_completion(&priv->assoc_wait);
 
 	/* because rndis_command() sleeps we need to use workqueue */
 	priv->workqueue = create_singlethread_workqueue("rndis_wlan");
@@ -2932,6 +2967,7 @@ static void rndis_wlan_unbind(struct usbnet *usbdev, struct usb_interface *intf)
 	/* turn radio off */
 	disassociate(usbdev, 0);
 
+	complete_all(&priv->assoc_wait);
 	cancel_delayed_work_sync(&priv->stats_work);
 	cancel_delayed_work_sync(&priv->scan_work);
 	cancel_work_sync(&priv->work);
@@ -2981,6 +3017,7 @@ static int rndis_wlan_stop(struct usbnet *usbdev)
 	retval = disassociate(usbdev, 0);
 
 	priv->work_pending = 0;
+	complete_all(&priv->assoc_wait);
 	cancel_delayed_work_sync(&priv->stats_work);
 	cancel_delayed_work_sync(&priv->scan_work);
 	cancel_work_sync(&priv->work);

