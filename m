Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:12674 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755590Ab2FFKHP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:07:15 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 11/29] NFC: Introduce target mode tx ops
Date: Wed,  6 Jun 2012 12:16:28 +0200
Message-Id: <1338977806-30279-12-git-send-email-sameo@linux.intel.com> (sfid-20120606_120722_703681_36CF5596)
In-Reply-To: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
References: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

And rename the initiator mode data exchange ops for consistency sake.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/pn533.c   |    8 ++++----
 include/net/nfc/nfc.h |    3 ++-
 net/nfc/core.c        |   37 ++++++++++++++++++++-----------------
 net/nfc/hci/core.c    |    8 ++++----
 net/nfc/nci/core.c    |    8 ++++----
 5 files changed, 34 insertions(+), 30 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index c6b9bc5..fd94c6f 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -1691,9 +1691,9 @@ error:
 	return 0;
 }
 
-static int pn533_data_exchange(struct nfc_dev *nfc_dev,
-			       struct nfc_target *target, struct sk_buff *skb,
-			       data_exchange_cb_t cb, void *cb_context)
+static int pn533_transceive(struct nfc_dev *nfc_dev,
+			    struct nfc_target *target, struct sk_buff *skb,
+			    data_exchange_cb_t cb, void *cb_context)
 {
 	struct pn533 *dev = nfc_get_drvdata(nfc_dev);
 	struct pn533_frame *out_frame, *in_frame;
@@ -1853,7 +1853,7 @@ struct nfc_ops pn533_nfc_ops = {
 	.stop_poll = pn533_stop_poll,
 	.activate_target = pn533_activate_target,
 	.deactivate_target = pn533_deactivate_target,
-	.data_exchange = pn533_data_exchange,
+	.im_transceive = pn533_transceive,
 };
 
 static int pn533_probe(struct usb_interface *interface,
diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
index a6a7b49..45c4c97 100644
--- a/include/net/nfc/nfc.h
+++ b/include/net/nfc/nfc.h
@@ -63,9 +63,10 @@ struct nfc_ops {
 			       u32 protocol);
 	void (*deactivate_target)(struct nfc_dev *dev,
 				  struct nfc_target *target);
-	int (*data_exchange)(struct nfc_dev *dev, struct nfc_target *target,
+	int (*im_transceive)(struct nfc_dev *dev, struct nfc_target *target,
 			     struct sk_buff *skb, data_exchange_cb_t cb,
 			     void *cb_context);
+	int (*tm_send)(struct nfc_dev *dev, struct sk_buff *skb);
 	int (*check_presence)(struct nfc_dev *dev, struct nfc_target *target);
 };
 
diff --git a/net/nfc/core.c b/net/nfc/core.c
index 722a0c7..76c1e20 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -413,27 +413,30 @@ int nfc_data_exchange(struct nfc_dev *dev, u32 target_idx, struct sk_buff *skb,
 		goto error;
 	}
 
-	if (dev->active_target == NULL) {
-		rc = -ENOTCONN;
-		kfree_skb(skb);
-		goto error;
-	}
+	if (dev->rf_mode == NFC_RF_INITIATOR && dev->active_target != NULL) {
+		if (dev->active_target->idx != target_idx) {
+			rc = -EADDRNOTAVAIL;
+			kfree_skb(skb);
+			goto error;
+		}
 
-	if (dev->active_target->idx != target_idx) {
-		rc = -EADDRNOTAVAIL;
+		if (dev->ops->check_presence)
+			del_timer_sync(&dev->check_pres_timer);
+
+		rc = dev->ops->im_transceive(dev, dev->active_target, skb, cb,
+					     cb_context);
+
+		if (!rc && dev->ops->check_presence)
+			mod_timer(&dev->check_pres_timer, jiffies +
+				  msecs_to_jiffies(NFC_CHECK_PRES_FREQ_MS));
+	} else if (dev->rf_mode == NFC_RF_TARGET && dev->ops->tm_send != NULL) {
+		rc = dev->ops->tm_send(dev, skb);
+	} else {
+		rc = -ENOTCONN;
 		kfree_skb(skb);
 		goto error;
 	}
 
-	if (dev->ops->check_presence)
-		del_timer_sync(&dev->check_pres_timer);
-
-	rc = dev->ops->data_exchange(dev, dev->active_target, skb, cb,
-				     cb_context);
-
-	if (!rc && dev->ops->check_presence)
-		mod_timer(&dev->check_pres_timer, jiffies +
-			  msecs_to_jiffies(NFC_CHECK_PRES_FREQ_MS));
 
 error:
 	device_unlock(&dev->dev);
@@ -727,7 +730,7 @@ struct nfc_dev *nfc_allocate_device(struct nfc_ops *ops,
 	struct nfc_dev *dev;
 
 	if (!ops->start_poll || !ops->stop_poll || !ops->activate_target ||
-	    !ops->deactivate_target || !ops->data_exchange)
+	    !ops->deactivate_target || !ops->im_transceive)
 		return NULL;
 
 	if (!supported_protocols)
diff --git a/net/nfc/hci/core.c b/net/nfc/hci/core.c
index 281f3a3..a8b0b71 100644
--- a/net/nfc/hci/core.c
+++ b/net/nfc/hci/core.c
@@ -512,9 +512,9 @@ static void hci_deactivate_target(struct nfc_dev *nfc_dev,
 {
 }
 
-static int hci_data_exchange(struct nfc_dev *nfc_dev, struct nfc_target *target,
-			     struct sk_buff *skb, data_exchange_cb_t cb,
-			     void *cb_context)
+static int hci_transceive(struct nfc_dev *nfc_dev, struct nfc_target *target,
+			  struct sk_buff *skb, data_exchange_cb_t cb,
+			  void *cb_context)
 {
 	struct nfc_hci_dev *hdev = nfc_get_drvdata(nfc_dev);
 	int r;
@@ -580,7 +580,7 @@ static struct nfc_ops hci_nfc_ops = {
 	.stop_poll = hci_stop_poll,
 	.activate_target = hci_activate_target,
 	.deactivate_target = hci_deactivate_target,
-	.data_exchange = hci_data_exchange,
+	.im_transceive = hci_transceive,
 	.check_presence = hci_check_presence,
 };
 
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 0f71898..766a02b 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -522,9 +522,9 @@ static void nci_deactivate_target(struct nfc_dev *nfc_dev,
 	}
 }
 
-static int nci_data_exchange(struct nfc_dev *nfc_dev, struct nfc_target *target,
-			     struct sk_buff *skb,
-			     data_exchange_cb_t cb, void *cb_context)
+static int nci_transceive(struct nfc_dev *nfc_dev, struct nfc_target *target,
+			  struct sk_buff *skb,
+			  data_exchange_cb_t cb, void *cb_context)
 {
 	struct nci_dev *ndev = nfc_get_drvdata(nfc_dev);
 	int rc;
@@ -557,7 +557,7 @@ static struct nfc_ops nci_nfc_ops = {
 	.stop_poll = nci_stop_poll,
 	.activate_target = nci_activate_target,
 	.deactivate_target = nci_deactivate_target,
-	.data_exchange = nci_data_exchange,
+	.im_transceive = nci_transceive,
 };
 
 /* ---- Interface to NCI drivers ---- */
-- 
1.7.9.1

