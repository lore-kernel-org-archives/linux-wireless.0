Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:17580 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943Ab2GFT7U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 15:59:20 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Eric Lapuyade <eric.lapuyade@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 11/33] NFC: nfc_targets_found() should accept zero target found
Date: Fri,  6 Jul 2012 22:09:31 +0200
Message-Id: <1341605393-32056-12-git-send-email-sameo@linux.intel.com> (sfid-20120706_220533_916592_B478FE69)
In-Reply-To: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
References: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eric Lapuyade <eric.lapuyade@intel.com>

The semantics for a zero target found event is that the polling operation
could not complete.

Signed-off-by: Eric Lapuyade <eric.lapuyade@intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/core.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/net/nfc/core.c b/net/nfc/core.c
index 94ccf07..749ee48 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -560,6 +560,8 @@ EXPORT_SYMBOL(nfc_alloc_recv_skb);
  * The device driver must call this function when one or many nfc targets
  * are found. After calling this function, the device driver must stop
  * polling for targets.
+ * NOTE: This function can be called with targets=NULL and n_targets=0 to
+ * notify a driver error, meaning that the polling operation cannot complete.
  * IMPORTANT: this function must not be called from an atomic context.
  * In addition, it must also not be called from a context that would prevent
  * the NFC Core to call other nfc ops entry point concurrently.
@@ -586,13 +588,18 @@ int nfc_targets_found(struct nfc_dev *dev,
 	dev->targets_generation++;
 
 	kfree(dev->targets);
-	dev->targets = kmemdup(targets, n_targets * sizeof(struct nfc_target),
-			       GFP_ATOMIC);
+	dev->targets = NULL;
 
-	if (!dev->targets) {
-		dev->n_targets = 0;
-		device_unlock(&dev->dev);
-		return -ENOMEM;
+	if (targets) {
+		dev->targets = kmemdup(targets,
+				       n_targets * sizeof(struct nfc_target),
+				       GFP_ATOMIC);
+
+		if (!dev->targets) {
+			dev->n_targets = 0;
+			device_unlock(&dev->dev);
+			return -ENOMEM;
+		}
 	}
 
 	dev->n_targets = n_targets;
-- 
1.7.10

