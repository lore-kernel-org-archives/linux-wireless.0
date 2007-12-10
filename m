Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45596 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbXLJRWF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 12:22:05 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 27/48] libertas: fix lbs_rtap attribute in sysfs
Message-Id: <E1J1kpW-0006mI-Ed@shinybook.infradead.org> (sfid-20071210_172208_609702_4D6BD47B)
Date: Mon, 10 Dec 2007 10:46:02 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sat, 8 Dec 2007 18:29:16 +0000

At least it doesn't oops when you attempt to read or write it now.
Only when you enable it and then later turn it off. And when it's
enabled I don't see how it actually works.

But one fewer oops is good, for now...

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/dev.h  |    2 --
 drivers/net/wireless/libertas/main.c |   18 ++++++------------
 2 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index fb26f18..5cb2923 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -143,8 +143,6 @@ struct lbs_private {
 	   all other bits reserved 0 */
 	u8 dnld_sent;
 
-	struct device *hotplug_device;
-
 	/** thread to service interrupts */
 	struct task_struct *main_thread;
 	wait_queue_head_t waitq;
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index f595664..d03a2f8 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -256,8 +256,7 @@ void lbs_remove_rtap(struct lbs_private *priv);
 static ssize_t lbs_rtap_get(struct device *dev,
 		struct device_attribute *attr, char * buf)
 {
-	struct lbs_private *priv = (struct lbs_private *)
-		(to_net_dev(dev))->priv;
+	struct lbs_private *priv = to_net_dev(dev)->priv;
 	struct lbs_adapter *adapter = priv->adapter;
 	return snprintf(buf, 5, "0x%X\n", adapter->monitormode);
 }
@@ -269,8 +268,7 @@ static ssize_t lbs_rtap_set(struct device *dev,
 		struct device_attribute *attr, const char * buf, size_t count)
 {
 	int monitor_mode;
-	struct lbs_private *priv = (struct lbs_private *)
-		(to_net_dev(dev))->priv;
+	struct lbs_private *priv = to_net_dev(dev)->priv;
 	struct lbs_adapter *adapter = priv->adapter;
 
 	sscanf(buf, "%x", &monitor_mode);
@@ -1158,7 +1156,6 @@ struct lbs_private *lbs_add_card(void *card, struct device *dmdev)
 	priv->card = card;
 	priv->mesh_open = 0;
 	priv->infra_open = 0;
-	priv->hotplug_device = dmdev;
 
 	/* Setup the OS Interface to our functions */
 	dev->open = lbs_open;
@@ -1178,15 +1175,13 @@ struct lbs_private *lbs_add_card(void *card, struct device *dmdev)
 	SET_NETDEV_DEV(dev, dmdev);
 
 	priv->rtap_net_dev = NULL;
-	if (device_create_file(dmdev, &dev_attr_lbs_rtap))
-		goto err_init_adapter;
 
 	lbs_deb_thread("Starting main thread...\n");
 	init_waitqueue_head(&priv->waitq);
 	priv->main_thread = kthread_run(lbs_thread, dev, "lbs_main");
 	if (IS_ERR(priv->main_thread)) {
 		lbs_deb_thread("Error creating main thread.\n");
-		goto err_kthread_run;
+		goto err_init_adapter;
 	}
 
 	priv->work_thread = create_singlethread_workqueue("lbs_worker");
@@ -1196,9 +1191,6 @@ struct lbs_private *lbs_add_card(void *card, struct device *dmdev)
 
 	goto done;
 
-err_kthread_run:
-	device_remove_file(dmdev, &dev_attr_lbs_rtap);
-
 err_init_adapter:
 	lbs_free_adapter(priv);
 
@@ -1224,7 +1216,7 @@ int lbs_remove_card(struct lbs_private *priv)
 	lbs_remove_rtap(priv);
 
 	dev = priv->dev;
-	device_remove_file(priv->hotplug_device, &dev_attr_lbs_rtap);
+	device_remove_file(&dev->dev, &dev_attr_lbs_rtap);
 
 	cancel_delayed_work(&priv->scan_work);
 	cancel_delayed_work(&priv->assoc_work);
@@ -1273,6 +1265,8 @@ int lbs_start_card(struct lbs_private *priv)
 		lbs_pr_err("cannot register ethX device\n");
 		goto done;
 	}
+	if (device_create_file(&dev->dev, &dev_attr_lbs_rtap))
+		lbs_pr_err("cannot register lbs_rtap attribute\n");
 
 	lbs_debugfs_init_one(priv, dev);
 
-- 
1.5.3.4

