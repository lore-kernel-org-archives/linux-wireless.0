Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:11023 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758479Ab3DJWKA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 18:10:00 -0400
Date: Thu, 11 Apr 2013 00:09:20 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Berg, Johannes" <johannes.berg@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Linux NFC <linux-nfc@lists.01.org>,
	Marcel Holtmann <marcel.holtmann@intel.com>
Subject: [RFC] [PATCH] NFC: RFKILL support
Message-ID: <20130410220920.GA10780@zurbaran> (sfid-20130411_001007_029260_2CFF26EC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All NFC devices will now get proper RFKILL support as long as they provide
some dev_up and dev_down hooks. Rfkilling an NFC device will bring it down
while it is left to userspace to bring it back up when being rfkill unblocked.
This is very similar to what Bluetooth does.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 include/net/nfc/nfc.h       |    2 ++
 include/uapi/linux/rfkill.h |    1 +
 net/nfc/core.c              |   38 ++++++++++++++++++++++++++++++++++++++
 net/rfkill/core.c           |    4 +++-
 4 files changed, 44 insertions(+), 1 deletion(-)

---

John, I'm not asking for this patch to be included into wireless-next. I'd
like to get Johannes comments/ACK on it and I'll then include it with my next
NFC pull request.

---
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
diff --git a/include/uapi/linux/rfkill.h b/include/uapi/linux/rfkill.h
index 2753c6c..5b4086f 100644
--- a/include/uapi/linux/rfkill.h
+++ b/include/uapi/linux/rfkill.h
@@ -48,6 +48,7 @@ enum rfkill_type {
 	RFKILL_TYPE_WWAN,
 	RFKILL_TYPE_GPS,
 	RFKILL_TYPE_FM,
+	RFKILL_TYPE_NFC,
 	NUM_RFKILL_TYPES,
 };
 
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
diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 9b9be52..1cec5e4 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -587,7 +587,7 @@ static ssize_t rfkill_name_show(struct device *dev,
 
 static const char *rfkill_get_type_str(enum rfkill_type type)
 {
-	BUILD_BUG_ON(NUM_RFKILL_TYPES != RFKILL_TYPE_FM + 1);
+	BUILD_BUG_ON(NUM_RFKILL_TYPES != RFKILL_TYPE_NFC + 1);
 
 	switch (type) {
 	case RFKILL_TYPE_WLAN:
@@ -604,6 +604,8 @@ static const char *rfkill_get_type_str(enum rfkill_type type)
 		return "gps";
 	case RFKILL_TYPE_FM:
 		return "fm";
+	case RFKILL_TYPE_NFC:
+		return "nfc";
 	default:
 		BUG();
 	}
-- 
1.7.10.4

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
