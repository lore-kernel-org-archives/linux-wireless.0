Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:46870 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab0KIRgZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 12:36:25 -0500
Subject: [PATCH 2/2] rndis_wlan: workaround poor scanning with BCM4320a
To: "John W. Linville" <linville@tuxdriver.com>
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: =?utf-8?b?THXDrXM=?= Picciochi <Pitxyoki@gmail.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 09 Nov 2010 19:25:56 +0200
Message-ID: <20101109172556.11708.61234.stgit@fate.lan>
In-Reply-To: <20101109172547.11708.73988.stgit@fate.lan>
References: <20101109172547.11708.73988.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

BCM4320a devices seem to sometimes do scanning pretty poorly. This can be
workaround by issuing new scan every second, while not yet connected. By this
new scanning method device catches beacons much faster. Fixes bug #20822.

Reported-by: Luís Picciochi <Pitxyoki@gmail.com>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/rndis_wlan.c |   67 +++++++++++++++++++++++++++++++------
 1 files changed, 56 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 0a423c4..8a77ff6 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -156,6 +156,12 @@ MODULE_PARM_DESC(workaround_interval,
 #define RNDIS_STATUS_ADAPTER_NOT_OPEN		cpu_to_le32(0xc0010012)
 
 
+/* Known device types */
+#define RNDIS_UNKNOWN	0
+#define RNDIS_BCM4320A	1
+#define RNDIS_BCM4320B	2
+
+
 /* NDIS data structures. Taken from wpa_supplicant driver_ndis.c
  * slightly modified for datatype endianess, etc
  */
@@ -478,6 +484,7 @@ struct rndis_wlan_private {
 	struct ieee80211_rate rates[ARRAY_SIZE(rndis_rates)];
 	u32 cipher_suites[ARRAY_SIZE(rndis_cipher_suites)];
 
+	int device_type;
 	int caps;
 	int multicast_size;
 
@@ -997,6 +1004,16 @@ static void restore_keys(struct usbnet *usbdev);
 static int rndis_check_bssid_list(struct usbnet *usbdev, u8 *match_bssid,
 					bool *matched);
 
+static int rndis_start_bssid_list_scan(struct usbnet *usbdev)
+{
+	__le32 tmp;
+
+	/* Note: OID_802_11_BSSID_LIST_SCAN clears internal BSS list. */
+	tmp = cpu_to_le32(1);
+	return rndis_set_oid(usbdev, OID_802_11_BSSID_LIST_SCAN, &tmp,
+							sizeof(tmp));
+}
+
 static int set_essid(struct usbnet *usbdev, struct ndis_80211_ssid *ssid)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
@@ -1905,7 +1922,7 @@ static int rndis_scan(struct wiphy *wiphy, struct net_device *dev,
 	struct usbnet *usbdev = netdev_priv(dev);
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	int ret;
-	__le32 tmp;
+	int delay = SCAN_DELAY_JIFFIES;
 
 	netdev_dbg(usbdev->net, "cfg80211.scan\n");
 
@@ -1922,13 +1939,13 @@ static int rndis_scan(struct wiphy *wiphy, struct net_device *dev,
 
 	priv->scan_request = request;
 
-	tmp = cpu_to_le32(1);
-	ret = rndis_set_oid(usbdev, OID_802_11_BSSID_LIST_SCAN, &tmp,
-							sizeof(tmp));
+	ret = rndis_start_bssid_list_scan(usbdev);
 	if (ret == 0) {
+		if (priv->device_type == RNDIS_BCM4320A)
+			delay = HZ;
+
 		/* Wait before retrieving scan results from device */
-		queue_delayed_work(priv->workqueue, &priv->scan_work,
-			SCAN_DELAY_JIFFIES);
+		queue_delayed_work(priv->workqueue, &priv->scan_work, delay);
 	}
 
 	return ret;
@@ -3046,8 +3063,21 @@ static void rndis_device_poller(struct work_struct *work)
 	 * also polls device with rndis_command() and catches for media link
 	 * indications.
 	 */
-	if (!is_associated(usbdev))
+	if (!is_associated(usbdev)) {
+		/* Workaround bad scanning in BCM4320a devices with active
+		 * background scanning when not associated.
+		 */
+		if (priv->device_type == RNDIS_BCM4320A && priv->radio_on &&
+		    !priv->scan_request) {
+			/* Get previous scan results */
+			rndis_check_bssid_list(usbdev, NULL, NULL);
+
+			/* Initiate new scan */
+			rndis_start_bssid_list_scan(usbdev);
+		}
+
 		goto end;
+	}
 
 	len = sizeof(rssi);
 	ret = rndis_query_oid(usbdev, OID_802_11_RSSI, &rssi, &len);
@@ -3104,10 +3134,12 @@ end:
 /*
  * driver/device initialization
  */
-static void rndis_copy_module_params(struct usbnet *usbdev)
+static void rndis_copy_module_params(struct usbnet *usbdev, int device_type)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 
+	priv->device_type = device_type;
+
 	priv->param_country[0] = modparam_country[0];
 	priv->param_country[1] = modparam_country[1];
 	priv->param_country[2] = 0;
@@ -3150,12 +3182,25 @@ static void rndis_copy_module_params(struct usbnet *usbdev)
 		priv->param_workaround_interval = modparam_workaround_interval;
 }
 
+static int unknown_early_init(struct usbnet *usbdev)
+{
+	/* copy module parameters for unknown so that iwconfig reports txpower
+	 * and workaround parameter is copied to private structure correctly.
+	 */
+	rndis_copy_module_params(usbdev, RNDIS_UNKNOWN);
+
+	/* This is unknown device, so do not try set configuration parameters.
+	 */
+
+	return 0;
+}
+
 static int bcm4320a_early_init(struct usbnet *usbdev)
 {
 	/* copy module parameters for bcm4320a so that iwconfig reports txpower
 	 * and workaround parameter is copied to private structure correctly.
 	 */
-	rndis_copy_module_params(usbdev);
+	rndis_copy_module_params(usbdev, RNDIS_BCM4320A);
 
 	/* bcm4320a doesn't handle configuration parameters well. Try
 	 * set any and you get partially zeroed mac and broken device.
@@ -3169,7 +3214,7 @@ static int bcm4320b_early_init(struct usbnet *usbdev)
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	char buf[8];
 
-	rndis_copy_module_params(usbdev);
+	rndis_copy_module_params(usbdev, RNDIS_BCM4320B);
 
 	/* Early initialization settings, setting these won't have effect
 	 * if called after generic_rndis_bind().
@@ -3432,7 +3477,7 @@ static const struct driver_info rndis_wlan_info = {
 	.tx_fixup =	rndis_tx_fixup,
 	.reset =	rndis_wlan_reset,
 	.stop =		rndis_wlan_stop,
-	.early_init =	bcm4320a_early_init,
+	.early_init =	unknown_early_init,
 	.indication =	rndis_wlan_indication,
 };
 

