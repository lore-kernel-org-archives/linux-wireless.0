Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:59691 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005Ab2CWLTA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2012 07:19:00 -0400
Message-ID: <4F6C5C59.2060708@linux.intel.com> (sfid-20120323_121906_748132_0D846530)
Date: Fri, 23 Mar 2012 12:19:53 +0100
From: Eric Lapuyade <eric.lapuyade@linux.intel.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
CC: Samuel Ortiz <sameo@linux.intel.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Subject: [PATCH] NFC: Add Core support to generate tag lost event
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some HW/drivers get notifications when a tag moves out of the radio field.
This notification is now forwarded to user space through netlink.

Signed-off-by: Eric Lapuyade <eric.lapuyade@intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 include/net/nfc/nfc.h |    5 +++
 net/nfc/core.c        |   84 ++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 88 insertions(+), 1 deletions(-)

diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
index 7273ff1..313d00f 100644
--- a/include/net/nfc/nfc.h
+++ b/include/net/nfc/nfc.h
@@ -62,6 +62,7 @@ struct nfc_ops {
 	int (*data_exchange)(struct nfc_dev *dev, u32 target_idx,
 			     struct sk_buff *skb, data_exchange_cb_t cb,
 			     void *cb_context);
+	int (*check_presence)(struct nfc_dev *dev, u32 target_idx);
 };
 
 #define NFC_TARGET_IDX_ANY -1
@@ -107,6 +108,10 @@ struct nfc_dev {
 	int tx_headroom;
 	int tx_tailroom;
 
+	struct timer_list check_pres_timer;
+	struct workqueue_struct *check_pres_wq;
+	struct work_struct check_pres_work;
+
 	struct nfc_ops *ops;
 };
 #define to_nfc_dev(_dev) container_of(_dev, struct nfc_dev, dev)
diff --git a/net/nfc/core.c b/net/nfc/core.c
index e9936d9..a580926 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -33,6 +33,8 @@
 
 #define VERSION "0.1"
 
+#define NFC_CHECK_PRES_FREQ_MS	2000
+
 int nfc_devlist_generation;
 DEFINE_MUTEX(nfc_devlist_mutex);
 
@@ -289,9 +291,14 @@ int nfc_activate_target(struct nfc_dev *dev, u32 target_idx, u32 protocol)
 	}
 
 	rc = dev->ops->activate_target(dev, target_idx, protocol);
-	if (!rc)
+	if (!rc) {
 		dev->activated_target_idx = target_idx;
 
+		if (dev->ops->check_presence)
+			mod_timer(&dev->check_pres_timer, jiffies +
+				  msecs_to_jiffies(NFC_CHECK_PRES_FREQ_MS));
+	}
+
 error:
 	device_unlock(&dev->dev);
 	return rc;
@@ -317,6 +324,9 @@ int nfc_deactivate_target(struct nfc_dev *dev, u32 target_idx)
 		goto error;
 	}
 
+	if (dev->ops->check_presence)
+		del_timer_sync(&dev->check_pres_timer);
+
 	dev->ops->deactivate_target(dev, target_idx);
 	dev->activated_target_idx = NFC_TARGET_IDX_NONE;
 
@@ -352,8 +362,27 @@ int nfc_data_exchange(struct nfc_dev *dev, u32 target_idx, struct sk_buff *skb,
 		goto error;
 	}
 
+	if (dev->activated_target_idx == NFC_TARGET_IDX_NONE) {
+		rc = -ENOTCONN;
+		kfree_skb(skb);
+		goto error;
+	}
+
+	if (target_idx != dev->activated_target_idx) {
+		rc = -EADDRNOTAVAIL;
+		kfree_skb(skb);
+		goto error;
+	}
+
+	if (dev->ops->check_presence)
+		del_timer_sync(&dev->check_pres_timer);
+
 	rc = dev->ops->data_exchange(dev, target_idx, skb, cb, cb_context);
 
+	if (!rc && dev->ops->check_presence)
+		mod_timer(&dev->check_pres_timer, jiffies +
+			  msecs_to_jiffies(NFC_CHECK_PRES_FREQ_MS));
+
 error:
 	device_unlock(&dev->dev);
 	return rc;
@@ -517,11 +546,46 @@ static void nfc_release(struct device *d)
 
 	pr_debug("dev_name=%s\n", dev_name(&dev->dev));
 
+	if (dev->ops->check_presence) {
+		del_timer_sync(&dev->check_pres_timer);
+		destroy_workqueue(dev->check_pres_wq);
+	}
+
 	nfc_genl_data_exit(&dev->genl_data);
 	kfree(dev->targets);
 	kfree(dev);
 }
 
+static void nfc_check_pres_work(struct work_struct *work)
+{
+	struct nfc_dev *dev = container_of(work, struct nfc_dev,
+					   check_pres_work);
+	int rc;
+
+	device_lock(&dev->dev);
+
+	if (dev->activated_target_idx != NFC_TARGET_IDX_NONE &&
+	    timer_pending(&dev->check_pres_timer) == 0) {
+		rc = dev->ops->check_presence(dev, dev->activated_target_idx);
+		if (!rc) {
+			mod_timer(&dev->check_pres_timer, jiffies +
+				  msecs_to_jiffies(NFC_CHECK_PRES_FREQ_MS));
+		} else {
+			nfc_target_lost(dev, dev->activated_target_idx);
+			dev->activated_target_idx = NFC_TARGET_IDX_NONE;
+		}
+	}
+
+	device_unlock(&dev->dev);
+}
+
+static void nfc_check_pres_timeout(unsigned long data)
+{
+	struct nfc_dev *dev = (struct nfc_dev *)data;
+
+	queue_work(dev->check_pres_wq, &dev->check_pres_work);
+}
+
 struct class nfc_class = {
 	.name = "nfc",
 	.dev_release = nfc_release,
@@ -589,6 +653,24 @@ struct nfc_dev *nfc_allocate_device(struct nfc_ops *ops,
 
 	dev->activated_target_idx = NFC_TARGET_IDX_NONE;
 
+	if (ops->check_presence) {
+		char name[32];
+		init_timer(&dev->check_pres_timer);
+		dev->check_pres_timer.data = (unsigned long)dev;
+		dev->check_pres_timer.function = nfc_check_pres_timeout;
+
+		INIT_WORK(&dev->check_pres_work, nfc_check_pres_work);
+		snprintf(name, sizeof(name), "nfc%d_check_pres_wq", dev->idx);
+		dev->check_pres_wq = alloc_workqueue(name, WQ_NON_REENTRANT |
+						     WQ_UNBOUND |
+						     WQ_MEM_RECLAIM, 1);
+		if (dev->check_pres_wq == NULL) {
+			kfree(dev);
+			return NULL;
+		}
+	}
+
+
 	return dev;
 }
 EXPORT_SYMBOL(nfc_allocate_device);
-- 
1.7.6.5

