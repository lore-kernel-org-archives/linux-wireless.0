Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3976 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606AbXJZVHW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 17:07:22 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: stable@kernel.org
Cc: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ipw2100: send WEXT scan events
Date: Fri, 26 Oct 2007 17:04:37 -0400
Message-Id: <11934326831029-git-send-email-linville@tuxdriver.com> (sfid-20071026_220727_834078_BD7EA113)
In-Reply-To: <11934326821662-git-send-email-linville@tuxdriver.com>
References: <11934326793639-git-send-email-linville@tuxdriver.com>
 <11934326801557-git-send-email-linville@tuxdriver.com>
 <11934326803769-git-send-email-linville@tuxdriver.com>
 <11934326803330-git-send-email-linville@tuxdriver.com>
 <11934326811535-git-send-email-linville@tuxdriver.com>
 <11934326813508-git-send-email-linville@tuxdriver.com>
 <1193432681145-git-send-email-linville@tuxdriver.com>
 <11934326812028-git-send-email-linville@tuxdriver.com>
 <11934326813245-git-send-email-linville@tuxdriver.com>
 <11934326823646-git-send-email-linville@tuxdriver.com>
 <11934326821301-git-send-email-linville@tuxdriver.com>
 <11934326823109-git-send-email-linville@tuxdriver.com>
 <11934326821662-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Williams <dcbw@redhat.com>

ipw2100 wasn't sending WEXT scan events at all on scan completion.  And
like ipw2200, the driver aggressively auto-scans, requiring
non-user-requested scan events to be batched together and sent at
specific intervals instead of many times per seconds.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ipw2100.c |   39 +++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ipw2100.h |    4 ++++
 2 files changed, 43 insertions(+), 0 deletions(-)

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
-- 
1.5.2.4

