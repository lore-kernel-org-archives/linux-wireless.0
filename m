Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764745AbXKTWsk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 17:48:40 -0500
Subject: [PATCH 5/6] libertas: separate mesh connectivity from that of the
	main interface
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Andres Salomon <dilinger@debian.org>,
	Javier Cardona <javier@cozybit.com>,
	Brajesh Dave <brajeshd@marvell.com>
Content-Type: text/plain
Date: Tue, 20 Nov 2007 17:44:14 -0500
Message-Id: <1195598654.32309.30.camel@localhost.localdomain> (sfid-20071120_224846_274626_5A81A43A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Brajesh Dave <brajeshd@marvell.com>

The transmit and receive traffic as soon as the mesh interface is
brought up.

Test case 1:  Bring up only the mesh interface and ping.  No need for
any iwconfig commands on the main interface.

$ ifconfig msh0 192.168.5.3
$ iwconfig msh0 channel X
$ ping 192.168.5.2
If ping succeeds, PASS

Test case 2:  Associate with the main interface, and turn off AP.  Mesh
interface should not lose connectivity.

$ iwconfig eth0 mode managed essid "my_ssid"
$ ifconfig msh0 192.168.5.3
$ ping 192.168.5.2
<turn off access point>
If ping continues uninterrupted, PASS

This feature requires firmware version 5.110.19.p0 or newer, available
here: http://dev.laptop.org/pub/firmware/libertas/

Signed-off-by: Ashish Shukla <ashishs@marvell.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
Signed-off-by: Dan Williams <dcbw@redhat.com>

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 5b2a1c7..b4d1b14 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1755,7 +1755,8 @@ int lbs_execute_next_command(lbs_private * priv)
 		 */
 		if ((adapter->psmode != LBS802_11POWERMODECAM) &&
 		    (adapter->psstate == PS_STATE_FULL_POWER) &&
-		    (adapter->connect_status == LBS_CONNECTED)) {
+		    ((adapter->connect_status == LBS_CONNECTED) ||
+		    (adapter->mesh_connect_status == LBS_CONNECTED))) {
 			if (adapter->secinfo.WPAenabled ||
 			    adapter->secinfo.WPA2enabled) {
 				/* check for valid WPA group keys */
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 6c1fdb8..11b93f2 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -979,7 +979,7 @@ int lbs_process_event(lbs_private * priv)
 			break;
 		}
 		lbs_pr_info("EVENT: MESH_AUTO_STARTED\n");
-		adapter->connect_status = LBS_CONNECTED;
+		adapter->mesh_connect_status = LBS_CONNECTED;
 		if (priv->mesh_open == 1) {
 			netif_wake_queue(priv->mesh_dev);
 			netif_carrier_on(priv->mesh_dev);
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 27db5d4..433b9bd 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -291,6 +291,7 @@ struct _lbs_adapter {
 	/** NIC Operation characteristics */
 	u16 currentpacketfilter;
 	u32 connect_status;
+	u32 mesh_connect_status;
 	u16 regioncode;
 	u16 txpowerlevel;
 
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 043a33d..26176d5 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -73,10 +73,11 @@ static void if_usb_write_bulk_callback(struct urb *urb)
 			if (!adapter->cur_cmd)
 				wake_up_interruptible(&priv->waitq);
 
-			if ((adapter->connect_status == LBS_CONNECTED)) {
+			if (adapter->connect_status == LBS_CONNECTED)
 				netif_wake_queue(dev);
+
+			if (priv->mesh_dev && (adapter->mesh_connect_status == LBS_CONNECTED))
 				netif_wake_queue(priv->mesh_dev);
-			}
 		}
 	} else {
 		/* print the failure status number for debug */
diff --git a/drivers/net/wireless/libertas/join.c b/drivers/net/wireless/libertas/join.c
index 90c25f4..3854d91 100644
--- a/drivers/net/wireless/libertas/join.c
+++ b/drivers/net/wireless/libertas/join.c
@@ -795,10 +795,6 @@ int lbs_ret_80211_associate(lbs_private *priv,
 	netif_carrier_on(priv->dev);
 	netif_wake_queue(priv->dev);
 
-	if (priv->mesh_dev) {
-		netif_carrier_on(priv->mesh_dev);
-		netif_wake_queue(priv->mesh_dev);
-	}
 
 	memcpy(wrqu.ap_addr.sa_data, adapter->curbssparams.bssid, ETH_ALEN);
 	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
@@ -884,11 +880,6 @@ int lbs_ret_80211_ad_hoc_start(lbs_private *priv,
 	netif_carrier_on(priv->dev);
 	netif_wake_queue(priv->dev);
 
-	if (priv->mesh_dev) {
-		netif_carrier_on(priv->mesh_dev);
-		netif_wake_queue(priv->mesh_dev);
-	}
-
 	memset(&wrqu, 0, sizeof(wrqu));
 	memcpy(wrqu.ap_addr.sa_data, adapter->curbssparams.bssid, ETH_ALEN);
 	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 959e898..541fb67 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -406,13 +406,15 @@ static int lbs_dev_open(struct net_device *dev)
 
 	priv->open = 1;
 
-	if (adapter->connect_status == LBS_CONNECTED) {
+	if (adapter->connect_status == LBS_CONNECTED)
 		netif_carrier_on(priv->dev);
-		if (priv->mesh_dev)
-			netif_carrier_on(priv->mesh_dev);
-	} else {
+	else
 		netif_carrier_off(priv->dev);
-		if (priv->mesh_dev)
+
+	if (priv->mesh_dev) {
+		if (adapter->mesh_connect_status == LBS_CONNECTED)
+			netif_carrier_on(priv->mesh_dev);
+		else
 			netif_carrier_off(priv->mesh_dev);
 	}
 
@@ -433,6 +435,11 @@ static int lbs_mesh_open(struct net_device *dev)
 		return -1;
 	priv->mesh_open = 1 ;
 	netif_wake_queue(priv->mesh_dev);
+
+	priv->adapter->mesh_connect_status = LBS_CONNECTED;
+
+	netif_carrier_on(priv->mesh_dev);
+	netif_wake_queue(priv->mesh_dev);
 	if (priv->infra_open == 0)
 		return lbs_dev_open(priv->dev) ;
 	return 0;
@@ -548,7 +555,7 @@ static int lbs_mesh_pre_start_xmit(struct sk_buff *skb,
 
 	SET_MESH_FRAME(skb);
 
-	ret = lbs_hard_start_xmit(skb, priv->dev);
+	ret = lbs_hard_start_xmit(skb, priv->mesh_dev);
 	lbs_deb_leave_args(LBS_DEB_MESH, "ret %d", ret);
 	return ret;
 }
@@ -595,9 +602,12 @@ static void lbs_tx_timeout(struct net_device *dev)
 			lbs_send_tx_feedback(priv);
 		} else
 			wake_up_interruptible(&priv->waitq);
-	} else if (priv->adapter->connect_status == LBS_CONNECTED) {
-		netif_wake_queue(priv->dev);
-		if (priv->mesh_dev)
+	} else if (dev == priv->dev) {
+		if (priv->adapter->connect_status == LBS_CONNECTED)
+			netif_wake_queue(priv->dev);
+
+	} else if (dev == priv->mesh_dev) {
+		if (priv->adapter->mesh_connect_status == LBS_CONNECTED)
 			netif_wake_queue(priv->mesh_dev);
 	}
 
@@ -1054,6 +1064,7 @@ static int lbs_init_adapter(lbs_private *priv)
 	memset(adapter->current_addr, 0xff, ETH_ALEN);
 
 	adapter->connect_status = LBS_DISCONNECTED;
+	adapter->mesh_connect_status = LBS_DISCONNECTED;
 	adapter->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
 	adapter->mode = IW_MODE_INFRA;
 	adapter->curbssparams.channel = DEFAULT_AD_HOC_CHANNEL;
diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
index 30e1a8e..13a0838 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -297,7 +297,8 @@ static void lbs_scan_create_channel_list(lbs_private *priv,
 
 	for (rgnidx = 0; rgnidx < ARRAY_SIZE(adapter->region_channel); rgnidx++) {
 		if (priv->adapter->enable11d &&
-		    adapter->connect_status != LBS_CONNECTED) {
+		    (adapter->connect_status != LBS_CONNECTED) &&
+		    (adapter->mesh_connect_status != LBS_CONNECTED)) {
 			/* Scan all the supported chan for the first scan */
 			if (!adapter->universal_channel[rgnidx].valid)
 				continue;
@@ -897,13 +898,14 @@ int lbs_scan_networks(lbs_private *priv,
 	mutex_unlock(&adapter->lock);
 #endif
 
-	if (priv->adapter->connect_status == LBS_CONNECTED) {
+	if (adapter->connect_status == LBS_CONNECTED) {
 		netif_carrier_on(priv->dev);
 		netif_wake_queue(priv->dev);
-		if (priv->mesh_dev) {
-			netif_carrier_on(priv->mesh_dev);
-			netif_wake_queue(priv->mesh_dev);
-		}
+	}
+
+	if (priv->mesh_dev && (adapter->mesh_connect_status == LBS_CONNECTED)) {
+		netif_carrier_on(priv->mesh_dev);
+		netif_wake_queue(priv->mesh_dev);
 	}
 
 out:
diff --git a/drivers/net/wireless/libertas/tx.c b/drivers/net/wireless/libertas/tx.c
index 93725ce..267274b 100644
--- a/drivers/net/wireless/libertas/tx.c
+++ b/drivers/net/wireless/libertas/tx.c
@@ -273,10 +273,11 @@ void lbs_send_tx_feedback(lbs_private *priv)
 	lbs_upload_rx_packet(priv, adapter->currenttxskb);
 	adapter->currenttxskb = NULL;
 	priv->adapter->TxLockFlag = 0;
-	if (priv->adapter->connect_status == LBS_CONNECTED) {
+
+	if (adapter->connect_status == LBS_CONNECTED)
 		netif_wake_queue(priv->dev);
-		if (priv->mesh_dev)
-			netif_wake_queue(priv->mesh_dev);
-	}
+
+	if (priv->mesh_dev && (adapter->mesh_connect_status == LBS_CONNECTED))
+		netif_wake_queue(priv->mesh_dev);
 }
 EXPORT_SYMBOL_GPL(lbs_send_tx_feedback);
diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index a7e2ad3..d4d11f9 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -160,7 +160,8 @@ static void copy_active_data_rates(lbs_adapter *adapter, u8 *rates)
 {
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	if (adapter->connect_status != LBS_CONNECTED)
+	if ((adapter->connect_status != LBS_CONNECTED) &&
+		(adapter->mesh_connect_status != LBS_CONNECTED))
 		memcpy(rates, lbs_bg_rates, MAX_RATES);
 	else
 		memcpy(rates, adapter->curbssparams.rates, MAX_RATES);
@@ -280,7 +281,7 @@ static int mesh_get_nick(struct net_device *dev, struct iw_request_info *info,
 
 	/* Use nickname to indicate that mesh is on */
 
-	if (adapter->connect_status == LBS_CONNECTED) {
+	if (adapter->mesh_connect_status == LBS_CONNECTED) {
 		strncpy(extra, "Mesh", 12);
 		extra[12] = '\0';
 		dwrq->length = strlen(extra);
@@ -595,7 +596,8 @@ static int lbs_get_range(struct net_device *dev, struct iw_request_info *info,
 
 	range->num_frequency = 0;
 	if (priv->adapter->enable11d &&
-	    adapter->connect_status == LBS_CONNECTED) {
+	    (adapter->connect_status == LBS_CONNECTED ||
+	    adapter->mesh_connect_status == LBS_CONNECTED)) {
 		u8 chan_no;
 		u8 band;
 
@@ -834,7 +836,8 @@ static struct iw_statistics *lbs_get_wireless_stats(struct net_device *dev)
 	priv->wstats.status = adapter->mode;
 
 	/* If we're not associated, all quality values are meaningless */
-	if (adapter->connect_status != LBS_CONNECTED)
+	if ((adapter->connect_status != LBS_CONNECTED) &&
+	    (adapter->mesh_connect_status != LBS_CONNECTED))
 		goto out;
 
 	/* Quality by RSSI */

