Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:36212 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbbKMLSe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2015 06:18:34 -0500
From: Saurabh Sengar <saurabh.truth@gmail.com>
To: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	sameo@linux.intel.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Saurabh Sengar <saurabh.truth@gmail.com>
Subject: [PATCH] NFC: added the sysfs entry for nfcsim workqueue delay
Date: Fri, 13 Nov 2015 16:48:19 +0530
Message-Id: <1447413499-25747-1-git-send-email-saurabh.truth@gmail.com> (sfid-20151113_121933_539801_234610A4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

added the sysfs entry for nfcsim workqueue delay, as tx_delay

Signed-off-by: Saurabh Sengar <saurabh.truth@gmail.com>
---
implementing the TODO task

 drivers/nfc/nfcsim.c | 38 +++++++++++++++++++++++++++++++++++---
 1 file changed, 35 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/nfcsim.c b/drivers/nfc/nfcsim.c
index 26ac9e5..e77be35 100644
--- a/drivers/nfc/nfcsim.c
+++ b/drivers/nfc/nfcsim.c
@@ -32,6 +32,8 @@
 #define NFCSIM_POLL_TARGET	2
 #define NFCSIM_POLL_DUAL	(NFCSIM_POLL_INITIATOR | NFCSIM_POLL_TARGET)
 
+#define TX_DEFAULT_DELAY	5
+
 struct nfcsim {
 	struct nfc_dev *nfc_dev;
 
@@ -62,12 +64,41 @@ static struct nfcsim *dev1;
 
 static struct workqueue_struct *wq;
 
+
+static int tx_delay = TX_DEFAULT_DELAY;
+
+static ssize_t show_tx_delay(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	int n;
+
+	n = scnprintf(buf, PAGE_SIZE, "%d\n", tx_delay);
+	return n;
+}
+
+static ssize_t store_tx_delay(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	if (kstrtouint(buf, 0, &tx_delay) < 0)
+		return -EINVAL;
+
+	if (tx_delay < 0)
+		return -EINVAL;
+
+	return count;
+}
+
+static DEVICE_ATTR(tx_delay, 0644, show_tx_delay, store_tx_delay);
+
 static void nfcsim_cleanup_dev(struct nfcsim *dev, u8 shutdown)
 {
 	DEV_DBG(dev, "shutdown=%d\n", shutdown);
 
 	mutex_lock(&dev->lock);
 
+	device_remove_file(&dev->nfc_dev->dev, &dev_attr_tx_delay);
 	dev->polling_mode = NFCSIM_POLL_NONE;
 	dev->shutting_down = shutdown;
 	dev->cb = NULL;
@@ -320,10 +351,8 @@ static int nfcsim_tx(struct nfc_dev *nfc_dev, struct nfc_target *target,
 	 * If packet transmission occurs immediately between them, we have a
 	 * non-stop flow of several tens of thousands SYMM packets per second
 	 * and a burning cpu.
-	 *
-	 * TODO: Add support for a sysfs entry to control this delay.
 	 */
-	queue_delayed_work(wq, &peer->recv_work, msecs_to_jiffies(5));
+	queue_delayed_work(wq, &peer->recv_work, msecs_to_jiffies(tx_delay));
 
 	mutex_unlock(&peer->lock);
 
@@ -461,6 +490,9 @@ static struct nfcsim *nfcsim_init_dev(void)
 	if (rc)
 		goto free_nfc_dev;
 
+	rc = device_create_file(&dev->nfc_dev->dev, &dev_attr_tx_delay);
+	if (rc)
+		pr_err("error creating sysfs entry\n");
 	return dev;
 
 free_nfc_dev:
-- 
1.9.1
