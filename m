Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:5438 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809Ab3DKLKj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 07:10:39 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	"Linux NFC" <linux-nfc@lists.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [RFC] [PATCH 2/2 v2] NFC: RFKILL support
Date: Thu, 11 Apr 2013 13:09:22 +0200
Message-Id: <1365678562-5583-3-git-send-email-sameo@linux.intel.com> (sfid-20130411_131042_193846_1F12C6D1)
In-Reply-To: <1365678562-5583-1-git-send-email-sameo@linux.intel.com>
References: <1365678562-5583-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All NFC devices will now get proper RFKILL support as long as they provide
some dev_up and dev_down hooks. Rfkilling an NFC device will bring it down
while it is left to userspace to bring it back up when being rfkill unblocked.
This is very similar to what Bluetooth does.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 include/net/nfc/nfc.h |    2 ++
 net/nfc/core.c        |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
index 87a6417..5eb80bb 100644
--- a/include/net/nfc/nfc.h
+++ b/include/net/nfc/nfc.h
@@ -122,6 +122,8 @@ struct nfc_dev {
 
 	bool shutting_down;
 
+	struct rfkill *rfkill;
+
 	struct nfc_ops *ops;
 };
 #define to_nfc_dev(_dev) container_of(_dev, struct nfc_dev, dev)
diff --git a/net/nfc/core.c b/net/nfc/core.c
index c571ca9..40d2527 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -27,6 +27,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/rfkill.h>
 #include <linux/nfc.h>
 
 #include <net/genetlink.h>
@@ -58,6 +59,11 @@ int nfc_dev_up(struct nfc_dev *dev)
 
 	device_lock(&dev->dev);
 
+	if (dev->rfkill && rfkill_blocked(dev->rfkill)) {
+		rc = -ERFKILL;
+		goto error;
+	}
+
 	if (!device_is_registered(&dev->dev)) {
 		rc = -ENODEV;
 		goto error;
@@ -117,6 +123,24 @@ error:
 	return rc;
 }
 
+static int nfc_rfkill_set_block(void *data, bool blocked)
+{
+	struct nfc_dev *dev = data;
+
+	pr_debug("%s blocked %d", dev_name(&dev->dev), blocked);
+
+	if (!blocked)
+		return 0;
+
+	nfc_dev_down(dev);
+
+	return 0;
+}
+
+static const struct rfkill_ops nfc_rfkill_ops = {
+	.set_block = nfc_rfkill_set_block,
+};
+
 /**
  * nfc_start_poll - start polling for nfc targets
  *
@@ -840,6 +864,15 @@ int nfc_register_device(struct nfc_dev *dev)
 		pr_debug("The userspace won't be notified that the device %s was added\n",
 			 dev_name(&dev->dev));
 
+	dev->rfkill = rfkill_alloc(dev_name(&dev->dev), &dev->dev,
+				   RFKILL_TYPE_NFC, &nfc_rfkill_ops, dev);
+	if (dev->rfkill) {
+		if (rfkill_register(dev->rfkill) < 0) {
+			rfkill_destroy(dev->rfkill);
+			dev->rfkill = NULL;
+		}
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL(nfc_register_device);
@@ -857,6 +890,11 @@ void nfc_unregister_device(struct nfc_dev *dev)
 
 	id = dev->idx;
 
+	if (dev->rfkill) {
+		rfkill_unregister(dev->rfkill);
+		rfkill_destroy(dev->rfkill);
+	}
+
 	if (dev->ops->check_presence) {
 		device_lock(&dev->dev);
 		dev->shutting_down = true;
-- 
1.7.10.4

