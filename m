Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbXJIRyE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 13:54:04 -0400
Subject: [PATCH] ipw2200: batch non-user-requested scan result notifications
From: Dan Williams <dcbw@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: yi.zhu@intel.com, ipw2100-devel@lists.sourceforge.net
Content-Type: text/plain
Date: Tue, 09 Oct 2007 13:55:24 -0400
Message-Id: <1191952524.617.7.camel@localhost.localdomain> (sfid-20071009_185410_180894_E4E0AEC4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ipw2200 makes extensive use of background scanning when unassociated or
down.  Unfortunately, the firmware sends scan completed events many
times per second, which the driver pushes directly up to userspace.
This needlessly wakes up processes listening for wireless events many
times per second.  Batch together scan completed events for
non-user-requested scans and send them up to userspace every 4 seconds.
Scan completed events resulting from an SIOCSIWSCAN call are pushed up
without delay.

Signed-off-by: Dan Williams <dcbw@redhat.com>

diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index 61497c4..da91b3b 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -1740,8 +1740,10 @@ static int ipw_radio_kill_sw(struct ipw_priv *priv, int disable_radio)
 	if (disable_radio) {
 		priv->status |= STATUS_RF_KILL_SW;
 
-		if (priv->workqueue)
+		if (priv->workqueue) {
 			cancel_delayed_work(&priv->request_scan);
+			cancel_delayed_work(&priv->scan_event);
+		}
 		queue_work(priv->workqueue, &priv->down);
 	} else {
 		priv->status &= ~STATUS_RF_KILL_SW;
@@ -1992,6 +1994,7 @@ static void ipw_irq_tasklet(struct ipw_priv *priv)
 		wake_up_interruptible(&priv->wait_command_queue);
 		priv->status &= ~(STATUS_ASSOCIATED | STATUS_ASSOCIATING);
 		cancel_delayed_work(&priv->request_scan);
+		cancel_delayed_work(&priv->scan_event);
 		schedule_work(&priv->link_down);
 		queue_delayed_work(priv->workqueue, &priv->rf_kill, 2 * HZ);
 		handled |= IPW_INTA_BIT_RF_KILL_DONE;
@@ -4341,6 +4344,37 @@ static void ipw_handle_missed_beacon(struct ipw_priv *priv,
 	IPW_DEBUG_NOTIF("Missed beacon: %d\n", missed_count);
 }
 
+static void ipw_scan_event(struct work_struct *work)
+{
+	union iwreq_data wrqu;
+
+	struct ipw_priv *priv =
+		container_of(work, struct ipw_priv, scan_event.work);
+
+	wrqu.data.length = 0;
+	wrqu.data.flags = 0;
+	wireless_send_event(priv->net_dev, SIOCGIWSCAN, &wrqu, NULL);
+}
+
+static void handle_scan_event(struct ipw_priv *priv)
+{
+	/* Only userspace-requested scan completion events go out immediately */
+	if (!priv->user_requested_scan) {
+		if (!delayed_work_pending(&priv->scan_event))
+			queue_delayed_work(priv->workqueue, &priv->scan_event,
+					 round_jiffies(msecs_to_jiffies(4000)));
+	} else {
+		union iwreq_data wrqu;
+
+		priv->user_requested_scan = 0;
+		cancel_delayed_work(&priv->scan_event);
+
+		wrqu.data.length = 0;
+		wrqu.data.flags = 0;
+		wireless_send_event(priv->net_dev, SIOCGIWSCAN, &wrqu, NULL);
+	}
+}
+
 /**
  * Handle host notification packet.
  * Called from interrupt routine
@@ -4702,14 +4736,8 @@ static void ipw_rx_notification(struct ipw_priv *priv,
 			 * on how the scan was initiated. User space can just
 			 * sync on periodic scan to get fresh data...
 			 * Jean II */
-			if (x->status == SCAN_COMPLETED_STATUS_COMPLETE) {
-				union iwreq_data wrqu;
-
-				wrqu.data.length = 0;
-				wrqu.data.flags = 0;
-				wireless_send_event(priv->net_dev, SIOCGIWSCAN,
-						    &wrqu, NULL);
-			}
+			if (x->status == SCAN_COMPLETED_STATUS_COMPLETE)
+				handle_scan_event(priv);
 			break;
 		}
 
@@ -9472,6 +9500,10 @@ static int ipw_wx_set_scan(struct net_device *dev,
 	struct ipw_priv *priv = ieee80211_priv(dev);
 	struct iw_scan_req *req = (struct iw_scan_req *)extra;
 
+	mutex_lock(&priv->mutex);
+	priv->user_requested_scan = 1;
+	mutex_unlock(&priv->mutex);
+
 	if (wrqu->data.length == sizeof(struct iw_scan_req)) {
 		if (wrqu->data.flags & IW_SCAN_THIS_ESSID) {
 			ipw_request_direct_scan(priv, req->essid,
@@ -10647,6 +10679,7 @@ static void ipw_link_up(struct ipw_priv *priv)
 	}
 
 	cancel_delayed_work(&priv->request_scan);
+	cancel_delayed_work(&priv->scan_event);
 	ipw_reset_stats(priv);
 	/* Ensure the rate is updated immediately */
 	priv->last_rate = ipw_get_current_rate(priv);
@@ -10684,7 +10717,8 @@ static void ipw_link_down(struct ipw_priv *priv)
 	if (!(priv->status & STATUS_EXIT_PENDING)) {
 		/* Queue up another scan... */
 		queue_delayed_work(priv->workqueue, &priv->request_scan, 0);
-	}
+	} else
+		cancel_delayed_work(&priv->scan_event);
 }
 
 static void ipw_bg_link_down(struct work_struct *work)
@@ -10714,6 +10748,7 @@ static int ipw_setup_deferred_work(struct ipw_priv *priv)
 	INIT_WORK(&priv->up, ipw_bg_up);
 	INIT_WORK(&priv->down, ipw_bg_down);
 	INIT_DELAYED_WORK(&priv->request_scan, ipw_request_scan);
+	INIT_DELAYED_WORK(&priv->scan_event, ipw_scan_event);
 	INIT_WORK(&priv->request_passive_scan, ipw_request_passive_scan);
 	INIT_DELAYED_WORK(&priv->gather_stats, ipw_bg_gather_stats);
 	INIT_WORK(&priv->abort_scan, ipw_bg_abort_scan);
@@ -11746,6 +11781,7 @@ static void ipw_pci_remove(struct pci_dev *pdev)
 	cancel_delayed_work(&priv->adhoc_check);
 	cancel_delayed_work(&priv->gather_stats);
 	cancel_delayed_work(&priv->request_scan);
+	cancel_delayed_work(&priv->scan_event);
 	cancel_delayed_work(&priv->rf_kill);
 	cancel_delayed_work(&priv->scan_check);
 	destroy_workqueue(priv->workqueue);
diff --git a/drivers/net/wireless/ipw2200.h b/drivers/net/wireless/ipw2200.h
index 626a240..58b8fe5 100644
--- a/drivers/net/wireless/ipw2200.h
+++ b/drivers/net/wireless/ipw2200.h
@@ -1288,6 +1288,8 @@ struct ipw_priv {
 
 	struct iw_public_data wireless_data;
 
+	int user_requested_scan;
+
 	struct workqueue_struct *workqueue;
 
 	struct delayed_work adhoc_check;
@@ -1296,6 +1298,7 @@ struct ipw_priv {
 	struct work_struct system_config;
 	struct work_struct rx_replenish;
 	struct delayed_work request_scan;
+	struct delayed_work scan_event;
   	struct work_struct request_passive_scan;
 	struct work_struct adapter_restart;
 	struct delayed_work rf_kill;

