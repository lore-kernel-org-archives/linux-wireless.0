Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995AbYFBRxy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2008 13:53:54 -0400
Subject: [PATCH v2] ipw2200: queue direct scans
From: Dan Williams <dcbw@redhat.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org,
	ipw2100-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1208829043.5327.13.camel@debian.sh.intel.com>
References: <1208800153.30994.25.camel@localhost.localdomain>
	 <1208829043.5327.13.camel@debian.sh.intel.com>
Content-Type: text/plain; charset=utf8
Date: Mon, 02 Jun 2008 13:51:23 -0400
Message-Id: <1212429083.10093.18.camel@localhost.localdomain> (sfid-20080602_195402_566200_F321A528)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

=EF=BB=BFWhen another scan is in progress, a direct scan gets dropped o=
n the
floor.  However, that direct scan is usually the scan that's really
needed by userspace, and gets stomped on by all the broadcast scans the
ipw2200 driver issues internally.  Make sure the direct scan happens
eventually, and as a bonus ensure that the passive scan worker is
cleaned up when appropriate.

The change of request_passive_scan form a struct work to struct
delayed_work is only to make the set_wx_scan() code a bit simpler, it's
still only used with a delay of 0 to match previous behavior.

Signed-off-by: Dan Williams <dcbw@redhat.com>
----

v2: consolidate direct and normal scan helpers into
ipw_request_scan_helper() per Zhu Yi's request

diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2=
200.c
index d74c061..fa1fa44 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -1753,6 +1753,8 @@ static int ipw_radio_kill_sw(struct ipw_priv *pri=
v, int disable_radio)
=20
 		if (priv->workqueue) {
 			cancel_delayed_work(&priv->request_scan);
+			cancel_delayed_work(&priv->request_direct_scan);
+			cancel_delayed_work(&priv->request_passive_scan);
 			cancel_delayed_work(&priv->scan_event);
 		}
 		queue_work(priv->workqueue, &priv->down);
@@ -2005,6 +2007,8 @@ static void ipw_irq_tasklet(struct ipw_priv *priv=
)
 		wake_up_interruptible(&priv->wait_command_queue);
 		priv->status &=3D ~(STATUS_ASSOCIATED | STATUS_ASSOCIATING);
 		cancel_delayed_work(&priv->request_scan);
+		cancel_delayed_work(&priv->request_direct_scan);
+		cancel_delayed_work(&priv->request_passive_scan);
 		cancel_delayed_work(&priv->scan_event);
 		schedule_work(&priv->link_down);
 		queue_delayed_work(priv->workqueue, &priv->rf_kill, 2 * HZ);
@@ -4712,6 +4716,12 @@ static void ipw_rx_notification(struct ipw_priv =
*priv,
 			priv->status &=3D ~STATUS_SCAN_FORCED;
 #endif				/* CONFIG_IPW2200_MONITOR */
=20
+			/* Do queued direct scans first */
+			if (priv->status & STATUS_DIRECT_SCAN_PENDING) {
+				queue_delayed_work(priv->workqueue,
+						   &priv->request_direct_scan, 0);
+			}
+
 			if (!(priv->status & (STATUS_ASSOCIATED |
 					      STATUS_ASSOCIATING |
 					      STATUS_ROAMING |
@@ -6267,7 +6277,7 @@ static void ipw_add_scan_channels(struct ipw_priv=
 *priv,
 	}
 }
=20
-static int ipw_request_scan_helper(struct ipw_priv *priv, int type)
+static int ipw_request_scan_helper(struct ipw_priv *priv, int type, in=
t direct)
 {
 	struct ipw_scan_request_ext scan;
 	int err =3D 0, scan_type;
@@ -6278,22 +6288,31 @@ static int ipw_request_scan_helper(struct ipw_p=
riv *priv, int type)
=20
 	mutex_lock(&priv->mutex);
=20
+	if (direct && (priv->direct_scan_ssid_len =3D=3D 0)) {
+		IPW_DEBUG_HC("Direct scan requested but no SSID to scan for\n");
+		priv->status &=3D ~STATUS_DIRECT_SCAN_PENDING;
+		goto done;
+	}
+
 	if (priv->status & STATUS_SCANNING) {
-		IPW_DEBUG_HC("Concurrent scan requested.  Ignoring.\n");
-		priv->status |=3D STATUS_SCAN_PENDING;
+		IPW_DEBUG_HC("Concurrent scan requested.  Queuing.\n");
+		priv->status |=3D direct ? STATUS_DIRECT_SCAN_PENDING :
+					STATUS_SCAN_PENDING;
 		goto done;
 	}
=20
 	if (!(priv->status & STATUS_SCAN_FORCED) &&
 	    priv->status & STATUS_SCAN_ABORTING) {
 		IPW_DEBUG_HC("Scan request while abort pending.  Queuing.\n");
-		priv->status |=3D STATUS_SCAN_PENDING;
+		priv->status |=3D direct ? STATUS_DIRECT_SCAN_PENDING :
+					STATUS_SCAN_PENDING;
 		goto done;
 	}
=20
 	if (priv->status & STATUS_RF_KILL_MASK) {
-		IPW_DEBUG_HC("Aborting scan due to RF Kill activation\n");
-		priv->status |=3D STATUS_SCAN_PENDING;
+		IPW_DEBUG_HC("Queuing scan due to RF Kill activation\n");
+		priv->status |=3D direct ? STATUS_DIRECT_SCAN_PENDING :
+					STATUS_SCAN_PENDING;
 		goto done;
 	}
=20
@@ -6321,6 +6340,7 @@ static int ipw_request_scan_helper(struct ipw_pri=
v *priv, int type)
 		cpu_to_le16(20);
=20
   	scan.dwell_time[IPW_SCAN_PASSIVE_FULL_DWELL_SCAN] =3D cpu_to_le16(1=
20);
+	scan.dwell_time[IPW_SCAN_ACTIVE_DIRECT_SCAN] =3D cpu_to_le16(20);
=20
 #ifdef CONFIG_IPW2200_MONITOR
 	if (priv->ieee->iw_mode =3D=3D IW_MODE_MONITOR) {
@@ -6360,13 +6380,23 @@ static int ipw_request_scan_helper(struct ipw_p=
riv *priv, int type)
 			cpu_to_le16(2000);
 	} else {
 #endif				/* CONFIG_IPW2200_MONITOR */
-		/* If we are roaming, then make this a directed scan for the
-		 * current network.  Otherwise, ensure that every other scan
-		 * is a fast channel hop scan */
-		if ((priv->status & STATUS_ROAMING)
-		    || (!(priv->status & STATUS_ASSOCIATED)
-			&& (priv->config & CFG_STATIC_ESSID)
-			&& (le32_to_cpu(scan.full_scan_index) % 2))) {
+		/* Honor direct scans first, otherwise if we are roaming make
+		 * this a direct scan for the current network.  Finally,
+		 * ensure that every other scan is a fast channel hop scan */
+		if (direct) {
+			err =3D ipw_send_ssid(priv, priv->direct_scan_ssid,
+			                    priv->direct_scan_ssid_len);
+			if (err) {
+				IPW_DEBUG_HC("Attempt to send SSID command  "
+					     "failed\n");
+				goto done;
+			}
+
+			scan_type =3D IPW_SCAN_ACTIVE_BROADCAST_AND_DIRECT_SCAN;
+		} else if ((priv->status & STATUS_ROAMING)
+			   || (!(priv->status & STATUS_ASSOCIATED)
+			       && (priv->config & CFG_STATIC_ESSID)
+			       && (le32_to_cpu(scan.full_scan_index) % 2))) {
 			err =3D ipw_send_ssid(priv, priv->essid, priv->essid_len);
 			if (err) {
 				IPW_DEBUG_HC("Attempt to send SSID command "
@@ -6391,7 +6421,12 @@ send_request:
 	}
=20
 	priv->status |=3D STATUS_SCANNING;
-	priv->status &=3D ~STATUS_SCAN_PENDING;
+	if (direct) {
+		priv->status &=3D ~STATUS_DIRECT_SCAN_PENDING;
+		priv->direct_scan_ssid_len =3D 0;
+	} else
+		priv->status &=3D ~STATUS_SCAN_PENDING;
+
 	queue_delayed_work(priv->workqueue, &priv->scan_check,
 			   IPW_SCAN_CHECK_WATCHDOG);
 done:
@@ -6402,15 +6437,22 @@ done:
 static void ipw_request_passive_scan(struct work_struct *work)
 {
 	struct ipw_priv *priv =3D
-		container_of(work, struct ipw_priv, request_passive_scan);
-  	ipw_request_scan_helper(priv, IW_SCAN_TYPE_PASSIVE);
+		container_of(work, struct ipw_priv, request_passive_scan.work);
+  	ipw_request_scan_helper(priv, IW_SCAN_TYPE_PASSIVE, 0);
 }
=20
 static void ipw_request_scan(struct work_struct *work)
 {
 	struct ipw_priv *priv =3D
 		container_of(work, struct ipw_priv, request_scan.work);
-	ipw_request_scan_helper(priv, IW_SCAN_TYPE_ACTIVE);
+	ipw_request_scan_helper(priv, IW_SCAN_TYPE_ACTIVE, 0);
+}
+
+static void ipw_request_direct_scan(struct work_struct *work)
+{
+	struct ipw_priv *priv =3D
+		container_of(work, struct ipw_priv, request_direct_scan.work);
+  	ipw_request_scan_helper(priv, IW_SCAN_TYPE_ACTIVE, 1);
 }
=20
 static void ipw_bg_abort_scan(struct work_struct *work)
@@ -9454,99 +9496,38 @@ static int ipw_wx_get_retry(struct net_device *=
dev,
 	return 0;
 }
=20
-static int ipw_request_direct_scan(struct ipw_priv *priv, char *essid,
-				   int essid_len)
-{
-	struct ipw_scan_request_ext scan;
-	int err =3D 0, scan_type;
-
-	if (!(priv->status & STATUS_INIT) ||
-	    (priv->status & STATUS_EXIT_PENDING))
-		return 0;
-
-	mutex_lock(&priv->mutex);
-
-	if (priv->status & STATUS_RF_KILL_MASK) {
-		IPW_DEBUG_HC("Aborting scan due to RF kill activation\n");
-		priv->status |=3D STATUS_SCAN_PENDING;
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
-		err =3D -EAGAIN;
-		goto done;
-	}
-	memset(&scan, 0, sizeof(scan));
-
-	if (priv->config & CFG_SPEED_SCAN)
-		scan.dwell_time[IPW_SCAN_ACTIVE_BROADCAST_SCAN] =3D
-		    cpu_to_le16(30);
-	else
-		scan.dwell_time[IPW_SCAN_ACTIVE_BROADCAST_SCAN] =3D
-		    cpu_to_le16(20);
-
-	scan.dwell_time[IPW_SCAN_ACTIVE_BROADCAST_AND_DIRECT_SCAN] =3D
-	    cpu_to_le16(20);
-	scan.dwell_time[IPW_SCAN_PASSIVE_FULL_DWELL_SCAN] =3D cpu_to_le16(120=
);
-	scan.dwell_time[IPW_SCAN_ACTIVE_DIRECT_SCAN] =3D cpu_to_le16(20);
-
-	scan.full_scan_index =3D cpu_to_le32(ieee80211_get_scans(priv->ieee))=
;
-
-	err =3D ipw_send_ssid(priv, essid, essid_len);
-	if (err) {
-		IPW_DEBUG_HC("Attempt to send SSID command failed\n");
-		goto done;
-	}
-	scan_type =3D IPW_SCAN_ACTIVE_BROADCAST_AND_DIRECT_SCAN;
-
-	ipw_add_scan_channels(priv, &scan, scan_type);
-
-	err =3D ipw_send_scan_request_ext(priv, &scan);
-	if (err) {
-		IPW_DEBUG_HC("Sending scan command failed: %08X\n", err);
-		goto done;
-	}
-
-	priv->status |=3D STATUS_SCANNING;
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
 	struct ipw_priv *priv =3D ieee80211_priv(dev);
 	struct iw_scan_req *req =3D (struct iw_scan_req *)extra;
+	struct delayed_work *work =3D NULL;
=20
 	mutex_lock(&priv->mutex);
+
 	priv->user_requested_scan =3D 1;
-	mutex_unlock(&priv->mutex);
=20
 	if (wrqu->data.length =3D=3D sizeof(struct iw_scan_req)) {
 		if (wrqu->data.flags & IW_SCAN_THIS_ESSID) {
-			ipw_request_direct_scan(priv, req->essid,
-						req->essid_len);
-			return 0;
-		}
-		if (req->scan_type =3D=3D IW_SCAN_TYPE_PASSIVE) {
-			queue_work(priv->workqueue,
-				   &priv->request_passive_scan);
-			return 0;
+			int len =3D min((int)req->essid_len,
+			              (int)sizeof(priv->direct_scan_ssid));
+			memcpy(priv->direct_scan_ssid, req->essid, len);
+			priv->direct_scan_ssid_len =3D len;
+			work =3D &priv->request_direct_scan;
+		} else if (req->scan_type =3D=3D IW_SCAN_TYPE_PASSIVE) {
+			work =3D &priv->request_passive_scan;
 		}
-	}
+	} else {
+		/* Normal active broadcast scan */
+		work =3D &priv->request_scan;
+ 	}
+
+	mutex_unlock(&priv->mutex);
=20
 	IPW_DEBUG_WX("Start scan\n");
=20
-	queue_delayed_work(priv->workqueue, &priv->request_scan, 0);
+	queue_delayed_work(priv->workqueue, work, 0);
=20
 	return 0;
 }
@@ -10708,6 +10689,8 @@ static void ipw_link_up(struct ipw_priv *priv)
 	}
=20
 	cancel_delayed_work(&priv->request_scan);
+	cancel_delayed_work(&priv->request_direct_scan);
+	cancel_delayed_work(&priv->request_passive_scan);
 	cancel_delayed_work(&priv->scan_event);
 	ipw_reset_stats(priv);
 	/* Ensure the rate is updated immediately */
@@ -10738,6 +10721,8 @@ static void ipw_link_down(struct ipw_priv *priv=
)
=20
 	/* Cancel any queued work ... */
 	cancel_delayed_work(&priv->request_scan);
+	cancel_delayed_work(&priv->request_direct_scan);
+	cancel_delayed_work(&priv->request_passive_scan);
 	cancel_delayed_work(&priv->adhoc_check);
 	cancel_delayed_work(&priv->gather_stats);
=20
@@ -10777,8 +10762,9 @@ static int __devinit ipw_setup_deferred_work(st=
ruct ipw_priv *priv)
 	INIT_WORK(&priv->up, ipw_bg_up);
 	INIT_WORK(&priv->down, ipw_bg_down);
 	INIT_DELAYED_WORK(&priv->request_scan, ipw_request_scan);
+	INIT_DELAYED_WORK(&priv->request_direct_scan, ipw_request_direct_scan=
);
+	INIT_DELAYED_WORK(&priv->request_passive_scan, ipw_request_passive_sc=
an);
 	INIT_DELAYED_WORK(&priv->scan_event, ipw_scan_event);
-	INIT_WORK(&priv->request_passive_scan, ipw_request_passive_scan);
 	INIT_DELAYED_WORK(&priv->gather_stats, ipw_bg_gather_stats);
 	INIT_WORK(&priv->abort_scan, ipw_bg_abort_scan);
 	INIT_WORK(&priv->roam, ipw_bg_roam);
@@ -11812,6 +11798,8 @@ static void __devexit ipw_pci_remove(struct pci=
_dev *pdev)
 	cancel_delayed_work(&priv->adhoc_check);
 	cancel_delayed_work(&priv->gather_stats);
 	cancel_delayed_work(&priv->request_scan);
+	cancel_delayed_work(&priv->request_direct_scan);
+	cancel_delayed_work(&priv->request_passive_scan);
 	cancel_delayed_work(&priv->scan_event);
 	cancel_delayed_work(&priv->rf_kill);
 	cancel_delayed_work(&priv->scan_check);
diff --git a/drivers/net/wireless/ipw2200.h b/drivers/net/wireless/ipw2=
200.h
index cd3295b..d68732f 100644
--- a/drivers/net/wireless/ipw2200.h
+++ b/drivers/net/wireless/ipw2200.h
@@ -1037,6 +1037,7 @@ struct ipw_cmd {	 /* XXX */
 #define STATUS_DISASSOC_PENDING (1<<12)
 #define STATUS_STATE_PENDING    (1<<13)
=20
+#define STATUS_DIRECT_SCAN_PENDING (1<<19)
 #define STATUS_SCAN_PENDING     (1<<20)
 #define STATUS_SCANNING         (1<<21)
 #define STATUS_SCAN_ABORTING    (1<<22)
@@ -1292,6 +1293,8 @@ struct ipw_priv {
 	struct iw_public_data wireless_data;
=20
 	int user_requested_scan;
+	u8 direct_scan_ssid[IW_ESSID_MAX_SIZE];
+	u8 direct_scan_ssid_len;
=20
 	struct workqueue_struct *workqueue;
=20
@@ -1301,8 +1304,9 @@ struct ipw_priv {
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

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
