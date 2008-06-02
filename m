Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761237AbYFBN7K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2008 09:59:10 -0400
Subject: Re: IW_SCAN_CAPA_ESSID vs hidden ESSID
From: Dan Williams <dcbw@redhat.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1212354884.4722.26.camel@deadeye.i.decadent.org.uk>
References: <1212354884.4722.26.camel@deadeye.i.decadent.org.uk>
Content-Type: text/plain
Date: Mon, 02 Jun 2008 09:58:57 -0400
Message-Id: <1212415137.21075.10.camel@localhost.localdomain> (sfid-20080602_155918_548550_5D091E3F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-06-01 at 22:14 +0100, Ben Hutchings wrote:
> Since upgrading from Linux 2.6.24 to .25, I have found that
> NetworkManager cannot associate my Intel wireless card, handled by the
> ipw2200 driver, with my AP, which has a hidden SSID.
> 
> NetworkManager thinks that wpa_supplicant should be able to scan for
> specific hidden SSIDs if the underlying driver advertises
> IW_SCAN_CAPA_ESSID, which ipw2200 does since 2.6.25:
> 
> 	/* Use "AP_SCAN 2" if:
> 	 * - The wireless network is non-broadcast and the driver doesn't support
> 	 *     scanning specific SSIDs
> 	 * - The wireless network is Ad-Hoc
> 	 * - The wireless driver does not support WPA (stupid drivers...)
> 	 */
> 	is_adhoc = (nm_ap_get_mode(ap) == IW_MODE_ADHOC);
> 	if (is_adhoc || !supports_wpa)
> 		ap_scan = "AP_SCAN 2";
> 	else if (!nm_ap_get_broadcast (ap))
> 		ap_scan = self->priv->has_scan_capa_ssid ? "AP_SCAN 1" : "AP_SCAN 2";
> 
> However, this doesn't work because the scan results just have an empty
> string or "<hidden>" (not consistently, which is weird).
> 
> So one of these components is doing the wrong thing.  Is it that:
> 
> 1. ipw2200 or ieee80211 should copy the selected ESSID into scan results

It does, if the AP responds to the probe request, which it should be
doing.

> 2. wpa_supplicant should not check the ESSID of scan results if it has
> already selected an ESSId
> 3. NetworkManager should not expect IW_SCAN_CAPA_ESSID to mean that this
> will work

That was the whole point of SCAN_CAPA_ESSID.  If the driver advertises
it, it is expected to work.  If it doesn't work, there's an issue in the
driver.  I've found it to work pretty reliably with my ipw2200 so far
with hidden APs, though 

One issue with ipw2200 specifically is that it does aggressive
background scans, and those background scans will supercede a scan
request for a direct SSID scan.  I posted a patch for that issue to
linux-wireless@ but need to rework some bits of it.  That made the issue
significantly better.

If possible, can you apply the attached patch and rebuild and see if
that helps it?

Dan


diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index a56d9fc..8a09ebc 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -1753,6 +1753,8 @@ static int ipw_radio_kill_sw(struct ipw_priv *priv, int disable_radio)
 
 		if (priv->workqueue) {
 			cancel_delayed_work(&priv->request_scan);
+			cancel_delayed_work(&priv->request_direct_scan);
+			cancel_delayed_work(&priv->request_passive_scan);
 			cancel_delayed_work(&priv->scan_event);
 		}
 		queue_work(priv->workqueue, &priv->down);
@@ -2005,6 +2007,8 @@ static void ipw_irq_tasklet(struct ipw_priv *priv)
 		wake_up_interruptible(&priv->wait_command_queue);
 		priv->status &= ~(STATUS_ASSOCIATED | STATUS_ASSOCIATING);
 		cancel_delayed_work(&priv->request_scan);
+		cancel_delayed_work(&priv->request_direct_scan);
+		cancel_delayed_work(&priv->request_passive_scan);
 		cancel_delayed_work(&priv->scan_event);
 		schedule_work(&priv->link_down);
 		queue_delayed_work(priv->workqueue, &priv->rf_kill, 2 * HZ);
@@ -4712,6 +4716,12 @@ static void ipw_rx_notification(struct ipw_priv *priv,
 			priv->status &= ~STATUS_SCAN_FORCED;
 #endif				/* CONFIG_IPW2200_MONITOR */
 
+			/* Do queued direct scans first */
+			if (priv->status & STATUS_DIRECT_SCAN_PENDING) {
+				queue_delayed_work(priv->workqueue,
+						   &priv->request_direct_scan, 0);
+			}
+
 			if (!(priv->status & (STATUS_ASSOCIATED |
 					      STATUS_ASSOCIATING |
 					      STATUS_ROAMING |
@@ -6279,7 +6289,7 @@ static int ipw_request_scan_helper(struct ipw_priv *priv, int type)
 	mutex_lock(&priv->mutex);
 
 	if (priv->status & STATUS_SCANNING) {
-		IPW_DEBUG_HC("Concurrent scan requested.  Ignoring.\n");
+		IPW_DEBUG_HC("Concurrent scan requested.  Queuing.\n");
 		priv->status |= STATUS_SCAN_PENDING;
 		goto done;
 	}
@@ -6292,7 +6302,7 @@ static int ipw_request_scan_helper(struct ipw_priv *priv, int type)
 	}
 
 	if (priv->status & STATUS_RF_KILL_MASK) {
-		IPW_DEBUG_HC("Aborting scan due to RF Kill activation\n");
+		IPW_DEBUG_HC("Queuing scan due to RF Kill activation\n");
 		priv->status |= STATUS_SCAN_PENDING;
 		goto done;
 	}
@@ -6402,7 +6412,7 @@ done:
 static void ipw_request_passive_scan(struct work_struct *work)
 {
 	struct ipw_priv *priv =
-		container_of(work, struct ipw_priv, request_passive_scan);
+		container_of(work, struct ipw_priv, request_passive_scan.work);
   	ipw_request_scan_helper(priv, IW_SCAN_TYPE_PASSIVE);
 }
 
@@ -6413,6 +6423,91 @@ static void ipw_request_scan(struct work_struct *work)
 	ipw_request_scan_helper(priv, IW_SCAN_TYPE_ACTIVE);
 }
 
+static int ipw_request_direct_scan_helper(struct ipw_priv *priv)
+{
+	struct ipw_scan_request_ext scan;
+	int err = 0, scan_type;
+
+	if (!(priv->status & STATUS_INIT) ||
+	    (priv->status & STATUS_EXIT_PENDING))
+		return 0;
+
+	mutex_lock(&priv->mutex);
+
+	if (priv->direct_scan_ssid_len == 0) {
+		IPW_DEBUG_HC("Direct scan requested but no SSID to scan for\n");
+		priv->status &= ~STATUS_DIRECT_SCAN_PENDING;
+		goto done;
+	}
+
+	if (priv->status & STATUS_RF_KILL_MASK) {
+		IPW_DEBUG_HC("Queuing scan due to RF kill activation\n");
+		priv->status |= STATUS_DIRECT_SCAN_PENDING;
+		goto done;
+	}
+
+	if (priv->status & STATUS_SCANNING) {
+		IPW_DEBUG_HC("Concurrent scan requested.  Queuing.\n");
+		priv->status |= STATUS_DIRECT_SCAN_PENDING;
+		goto done;
+	}
+
+	if (priv->status & STATUS_SCAN_ABORTING) {
+		IPW_DEBUG_HC("Scan request while abort pending.  Queuing.\n");
+		priv->status |= STATUS_DIRECT_SCAN_PENDING;
+		goto done;
+	}
+
+	IPW_DEBUG_HC("starting request direct scan!\n");
+
+	memset(&scan, 0, sizeof(scan));
+
+	if (priv->config & CFG_SPEED_SCAN)
+		scan.dwell_time[IPW_SCAN_ACTIVE_BROADCAST_SCAN] =
+		    cpu_to_le16(30);
+	else
+		scan.dwell_time[IPW_SCAN_ACTIVE_BROADCAST_SCAN] =
+		    cpu_to_le16(20);
+
+	scan.dwell_time[IPW_SCAN_ACTIVE_BROADCAST_AND_DIRECT_SCAN] =
+	    cpu_to_le16(20);
+	scan.dwell_time[IPW_SCAN_PASSIVE_FULL_DWELL_SCAN] = cpu_to_le16(120);
+	scan.dwell_time[IPW_SCAN_ACTIVE_DIRECT_SCAN] = cpu_to_le16(20);
+
+	scan.full_scan_index = cpu_to_le32(ieee80211_get_scans(priv->ieee));
+
+	err = ipw_send_ssid(priv, priv->direct_scan_ssid,
+	                    priv->direct_scan_ssid_len);
+	if (err) {
+		IPW_DEBUG_HC("Attempt to send SSID command failed\n");
+		goto done;
+	}
+	scan_type = IPW_SCAN_ACTIVE_BROADCAST_AND_DIRECT_SCAN;
+
+	ipw_add_scan_channels(priv, &scan, scan_type);
+
+	err = ipw_send_scan_request_ext(priv, &scan);
+	if (err) {
+		IPW_DEBUG_HC("Sending scan command failed: %08X\n", err);
+		goto done;
+	}
+
+	priv->status |= STATUS_SCANNING;
+	priv->status &= ~STATUS_DIRECT_SCAN_PENDING;
+	priv->direct_scan_ssid_len = 0;
+
+done:
+	mutex_unlock(&priv->mutex);
+	return err;
+}
+
+static void ipw_request_direct_scan(struct work_struct *work)
+{
+	struct ipw_priv *priv =
+		container_of(work, struct ipw_priv, request_direct_scan.work);
+  	ipw_request_direct_scan_helper(priv);
+}
+
 static void ipw_bg_abort_scan(struct work_struct *work)
 {
 	struct ipw_priv *priv =
@@ -9454,99 +9549,38 @@ static int ipw_wx_get_retry(struct net_device *dev,
 	return 0;
 }
 
-static int ipw_request_direct_scan(struct ipw_priv *priv, char *essid,
-				   int essid_len)
-{
-	struct ipw_scan_request_ext scan;
-	int err = 0, scan_type;
-
-	if (!(priv->status & STATUS_INIT) ||
-	    (priv->status & STATUS_EXIT_PENDING))
-		return 0;
-
-	mutex_lock(&priv->mutex);
-
-	if (priv->status & STATUS_RF_KILL_MASK) {
-		IPW_DEBUG_HC("Aborting scan due to RF kill activation\n");
-		priv->status |= STATUS_SCAN_PENDING;
-		goto done;
-	}
-
-	IPW_DEBUG_HC("starting request direct scan!\n");
-
-	if (priv->status & (STATUS_SCANNING | STATUS_SCAN_ABORTING)) {
-		/* We should not sleep here; otherwise we will block most
-		 * of the system (for instance, we hold rtnl_lock when we
-		 * get here).
-		 */
-		err = -EAGAIN;
-		goto done;
-	}
-	memset(&scan, 0, sizeof(scan));
-
-	if (priv->config & CFG_SPEED_SCAN)
-		scan.dwell_time[IPW_SCAN_ACTIVE_BROADCAST_SCAN] =
-		    cpu_to_le16(30);
-	else
-		scan.dwell_time[IPW_SCAN_ACTIVE_BROADCAST_SCAN] =
-		    cpu_to_le16(20);
-
-	scan.dwell_time[IPW_SCAN_ACTIVE_BROADCAST_AND_DIRECT_SCAN] =
-	    cpu_to_le16(20);
-	scan.dwell_time[IPW_SCAN_PASSIVE_FULL_DWELL_SCAN] = cpu_to_le16(120);
-	scan.dwell_time[IPW_SCAN_ACTIVE_DIRECT_SCAN] = cpu_to_le16(20);
-
-	scan.full_scan_index = cpu_to_le32(ieee80211_get_scans(priv->ieee));
-
-	err = ipw_send_ssid(priv, essid, essid_len);
-	if (err) {
-		IPW_DEBUG_HC("Attempt to send SSID command failed\n");
-		goto done;
-	}
-	scan_type = IPW_SCAN_ACTIVE_BROADCAST_AND_DIRECT_SCAN;
-
-	ipw_add_scan_channels(priv, &scan, scan_type);
-
-	err = ipw_send_scan_request_ext(priv, &scan);
-	if (err) {
-		IPW_DEBUG_HC("Sending scan command failed: %08X\n", err);
-		goto done;
-	}
-
-	priv->status |= STATUS_SCANNING;
-
-      done:
-	mutex_unlock(&priv->mutex);
-	return err;
-}
-
 static int ipw_wx_set_scan(struct net_device *dev,
 			   struct iw_request_info *info,
 			   union iwreq_data *wrqu, char *extra)
 {
 	struct ipw_priv *priv = ieee80211_priv(dev);
 	struct iw_scan_req *req = (struct iw_scan_req *)extra;
+	struct delayed_work *work = NULL;
 
 	mutex_lock(&priv->mutex);
+
 	priv->user_requested_scan = 1;
-	mutex_unlock(&priv->mutex);
 
 	if (wrqu->data.length == sizeof(struct iw_scan_req)) {
 		if (wrqu->data.flags & IW_SCAN_THIS_ESSID) {
-			ipw_request_direct_scan(priv, req->essid,
-						req->essid_len);
-			return 0;
-		}
-		if (req->scan_type == IW_SCAN_TYPE_PASSIVE) {
-			queue_work(priv->workqueue,
-				   &priv->request_passive_scan);
-			return 0;
+			int len = min((int)req->essid_len,
+			              (int)sizeof(priv->direct_scan_ssid));
+			memcpy(priv->direct_scan_ssid, req->essid, len);
+			priv->direct_scan_ssid_len = len;
+			work = &priv->request_direct_scan;
+		} else if (req->scan_type == IW_SCAN_TYPE_PASSIVE) {
+			work = &priv->request_passive_scan;
 		}
-	}
+	} else {
+		/* Normal active broadcast scan */
+		work = &priv->request_scan;
+ 	}
+
+	mutex_unlock(&priv->mutex);
 
 	IPW_DEBUG_WX("Start scan\n");
 
-	queue_delayed_work(priv->workqueue, &priv->request_scan, 0);
+	queue_delayed_work(priv->workqueue, work, 0);
 
 	return 0;
 }
@@ -10709,6 +10743,8 @@ static void ipw_link_up(struct ipw_priv *priv)
 	}
 
 	cancel_delayed_work(&priv->request_scan);
+	cancel_delayed_work(&priv->request_direct_scan);
+	cancel_delayed_work(&priv->request_passive_scan);
 	cancel_delayed_work(&priv->scan_event);
 	ipw_reset_stats(priv);
 	/* Ensure the rate is updated immediately */
@@ -10739,6 +10775,8 @@ static void ipw_link_down(struct ipw_priv *priv)
 
 	/* Cancel any queued work ... */
 	cancel_delayed_work(&priv->request_scan);
+	cancel_delayed_work(&priv->request_direct_scan);
+	cancel_delayed_work(&priv->request_passive_scan);
 	cancel_delayed_work(&priv->adhoc_check);
 	cancel_delayed_work(&priv->gather_stats);
 
@@ -10778,8 +10816,9 @@ static int __devinit ipw_setup_deferred_work(struct ipw_priv *priv)
 	INIT_WORK(&priv->up, ipw_bg_up);
 	INIT_WORK(&priv->down, ipw_bg_down);
 	INIT_DELAYED_WORK(&priv->request_scan, ipw_request_scan);
+	INIT_DELAYED_WORK(&priv->request_direct_scan, ipw_request_direct_scan);
+	INIT_DELAYED_WORK(&priv->request_passive_scan, ipw_request_passive_scan);
 	INIT_DELAYED_WORK(&priv->scan_event, ipw_scan_event);
-	INIT_WORK(&priv->request_passive_scan, ipw_request_passive_scan);
 	INIT_DELAYED_WORK(&priv->gather_stats, ipw_bg_gather_stats);
 	INIT_WORK(&priv->abort_scan, ipw_bg_abort_scan);
 	INIT_WORK(&priv->roam, ipw_bg_roam);
@@ -11811,6 +11850,8 @@ static void __devexit ipw_pci_remove(struct pci_dev *pdev)
 	cancel_delayed_work(&priv->adhoc_check);
 	cancel_delayed_work(&priv->gather_stats);
 	cancel_delayed_work(&priv->request_scan);
+	cancel_delayed_work(&priv->request_direct_scan);
+	cancel_delayed_work(&priv->request_passive_scan);
 	cancel_delayed_work(&priv->scan_event);
 	cancel_delayed_work(&priv->rf_kill);
 	cancel_delayed_work(&priv->scan_check);
diff --git a/drivers/net/wireless/ipw2200.h b/drivers/net/wireless/ipw2200.h
index fdc187e..89f7130 100644
--- a/drivers/net/wireless/ipw2200.h
+++ b/drivers/net/wireless/ipw2200.h
@@ -1033,6 +1033,7 @@ struct ipw_cmd {
 #define STATUS_DISASSOC_PENDING (1<<12)
 #define STATUS_STATE_PENDING    (1<<13)
 
+#define STATUS_DIRECT_SCAN_PENDING (1<<19)
 #define STATUS_SCAN_PENDING     (1<<20)
 #define STATUS_SCANNING         (1<<21)
 #define STATUS_SCAN_ABORTING    (1<<22)
@@ -1288,6 +1289,8 @@ struct ipw_priv {
 	struct iw_public_data wireless_data;
 
 	int user_requested_scan;
+	u8 direct_scan_ssid[IW_ESSID_MAX_SIZE];
+	u8 direct_scan_ssid_len;
 
 	struct workqueue_struct *workqueue;
 
@@ -1297,8 +1300,9 @@ struct ipw_priv {
 	struct work_struct system_config;
 	struct work_struct rx_replenish;
 	struct delayed_work request_scan;
+	struct delayed_work request_direct_scan;
+  	struct delayed_work request_passive_scan;
 	struct delayed_work scan_event;
-  	struct work_struct request_passive_scan;
 	struct work_struct adapter_restart;
 	struct delayed_work rf_kill;
 	struct work_struct up;





