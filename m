Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:4013 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838Ab2CWLNU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2012 07:13:20 -0400
Message-ID: <4F6C5B05.40003@linux.intel.com> (sfid-20120323_121324_722485_6CAC30A3)
Date: Fri, 23 Mar 2012 12:14:13 +0100
From: Eric Lapuyade <eric.lapuyade@linux.intel.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
CC: Samuel Ortiz <sameo@linux.intel.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Subject: [PATCH] NFC: Changed target activated state logic
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As we need to maintain the currently activated target idx, use this variable instead of the redundant remote_activated bool.

Signed-off-by: Eric Lapuyade <eric.lapuyade@intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 include/net/nfc/nfc.h |    3 ++-
 net/nfc/core.c        |    8 +++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
index f4f6950..7273ff1 100644
--- a/include/net/nfc/nfc.h
+++ b/include/net/nfc/nfc.h
@@ -66,6 +66,7 @@ struct nfc_ops {
 
 #define NFC_TARGET_IDX_ANY -1
 #define NFC_MAX_GT_LEN 48
+#define NFC_TARGET_IDX_NONE 0xffffffff
 
 struct nfc_target {
 	u32 idx;
@@ -97,7 +98,7 @@ struct nfc_dev {
 	struct device dev;
 	bool dev_up;
 	bool polling;
-	bool remote_activated;
+	u32 activated_target_idx;
 	bool dep_link_up;
 	u32 dep_rf_mode;
 	struct nfc_genl_data genl_data;
diff --git a/net/nfc/core.c b/net/nfc/core.c
index d3a2cfb..e9936d9 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -95,7 +95,7 @@ int nfc_dev_down(struct nfc_dev *dev)
 		goto error;
 	}
 
-	if (dev->polling || dev->remote_activated) {
+	if (dev->polling || dev->activated_target_idx != NFC_TARGET_IDX_NONE) {
 		rc = -EBUSY;
 		goto error;
 	}
@@ -290,7 +290,7 @@ int nfc_activate_target(struct nfc_dev *dev, u32 target_idx, u32 protocol)
 
 	rc = dev->ops->activate_target(dev, target_idx, protocol);
 	if (!rc)
-		dev->remote_activated = true;
+		dev->activated_target_idx = target_idx;
 
 error:
 	device_unlock(&dev->dev);
@@ -318,7 +318,7 @@ int nfc_deactivate_target(struct nfc_dev *dev, u32 target_idx)
 	}
 
 	dev->ops->deactivate_target(dev, target_idx);
-	dev->remote_activated = false;
+	dev->activated_target_idx = NFC_TARGET_IDX_NONE;
 
 error:
 	device_unlock(&dev->dev);
@@ -587,6 +587,8 @@ struct nfc_dev *nfc_allocate_device(struct nfc_ops *ops,
 	/* first generation must not be 0 */
 	dev->targets_generation = 1;
 
+	dev->activated_target_idx = NFC_TARGET_IDX_NONE;
+
 	return dev;
 }
 EXPORT_SYMBOL(nfc_allocate_device);
-- 
1.7.6.5

