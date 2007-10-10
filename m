Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574AbXJJQ0t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 12:26:49 -0400
Subject: [PATCH] ipw2100: send WEXT scan events
From: Dan Williams <dcbw@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: yi.zhu@intel.com, ipw2100-devel@lists.sourceforge.net
Content-Type: text/plain
Date: Wed, 10 Oct 2007 12:28:07 -0400
Message-Id: <1192033687.9739.39.camel@localhost.localdomain> (sfid-20071010_172655_386016_4F859F59)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ipw2100 wasn't sending WEXT scan events at all on scan completion.  And
like ipw2200, the driver aggressively auto-scans, requiring
non-user-requested scan events to be batched together and sent at
specific intervals instead of many times per seconds.

Signed-off-by: Dan Williams <dcbw@redhat.com>

diff --git a/drivers/net/wireless/ipw2100.c b/drivers/net/wireless/ipw2100.c
index 8990585..e690609 100644
--- a/drivers/net/wireless/ipw2100.c
+++ b/drivers/net/wireless/ipw2100.c
@@ -2102,12 +2102,46 @@ static void isr_indicate_rf_kill(struct ipw2100_priv *priv, u32 status)
 	queue_delayed_work(priv->workqueue, &priv->rf_kill, round_jiffies(HZ));
 }
 
+static void send_scan_event(void *data)
+{
+	struct ipw2100_priv *priv = data;
+	union iwreq_data wrqu;
+
+	wrqu.data.length = 0;
+	wrqu.data.flags = 0;
+	wireless_send_event(priv->net_dev, SIOCGIWSCAN, &wrqu, NULL);
+}
+
+static void ipw2100_scan_event_later(struct work_struct *work)
+{
+	send_scan_event(container_of(work, struct ipw2100_priv,
+					scan_event_later.work));
+}
+
+static void ipw2100_scan_event_now(struct work_struct *work)
+{
+	send_scan_event(container_of(work, struct ipw2100_priv,
+					scan_event_now));
+}
+
 static void isr_scan_complete(struct ipw2100_priv *priv, u32 status)
 {
 	IPW_DEBUG_SCAN("scan complete\n");
 	/* Age the scan results... */
 	priv->ieee->scans++;
 	priv->status &= ~STATUS_SCANNING;
+
+	/* Only userspace-requested scan completion events go out immediately */
+	if (!priv->user_requested_scan) {
+		if (!delayed_work_pending(&priv->scan_event_later))
+			queue_delayed_work(priv->workqueue,
+					&priv->scan_event_later,
+					round_jiffies(msecs_to_jiffies(4000)));
+	} else {
+		priv->user_requested_scan = 0;
+		cancel_delayed_work(&priv->scan_event_later);
+		queue_work(priv->workqueue, &priv->scan_event_now);
+	}
 }
 
 #ifdef CONFIG_IPW2100_DEBUG
@@ -4376,6 +4410,7 @@ static void ipw2100_kill_workqueue(struct ipw2100_priv *priv)
 		cancel_delayed_work(&priv->wx_event_work);
 		cancel_delayed_work(&priv->hang_check);
 		cancel_delayed_work(&priv->rf_kill);
+		cancel_delayed_work(&priv->scan_event_later);
 		destroy_workqueue(priv->workqueue);
 		priv->workqueue = NULL;
 	}
@@ -6118,6 +6153,8 @@ static struct net_device *ipw2100_alloc_device(struct pci_dev *pci_dev,
 	INIT_DELAYED_WORK(&priv->wx_event_work, ipw2100_wx_event_work);
 	INIT_DELAYED_WORK(&priv->hang_check, ipw2100_hang_check);
 	INIT_DELAYED_WORK(&priv->rf_kill, ipw2100_rf_kill);
+	INIT_WORK(&priv->scan_event_now, ipw2100_scan_event_now);
+	INIT_DELAYED_WORK(&priv->scan_event_later, ipw2100_scan_event_later);
 
 	tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
 		     ipw2100_irq_tasklet, (unsigned long)priv);
@@ -7427,6 +7464,8 @@ static int ipw2100_wx_set_scan(struct net_device *dev,
 	}
 
 	IPW_DEBUG_WX("Initiating scan...\n");
+
+	priv->user_requested_scan = 1;
 	if (ipw2100_set_scan_options(priv) || ipw2100_start_scan(priv)) {
 		IPW_DEBUG_WX("Start scan failed.\n");
 
diff --git a/drivers/net/wireless/ipw2100.h b/drivers/net/wireless/ipw2100.h
index de7d384..1ee3348 100644
--- a/drivers/net/wireless/ipw2100.h
+++ b/drivers/net/wireless/ipw2100.h
@@ -588,6 +588,10 @@ struct ipw2100_priv {
 	struct delayed_work wx_event_work;
 	struct delayed_work hang_check;
 	struct delayed_work rf_kill;
+	struct work_struct scan_event_now;
+	struct delayed_work scan_event_later;
+
+	int user_requested_scan;
 
 	u32 interrupts;
 	int tx_interrupts;

