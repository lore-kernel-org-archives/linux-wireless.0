Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14100 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755191Ab2DJRfj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 13:35:39 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>,
	Eric Lapuyade <eric.lapuyade@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Eric Lapuyade <eric.lapuyade@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 09/18] NFC: Changed target activated state logic
Date: Tue, 10 Apr 2012 19:43:11 +0200
Message-Id: <1334079800-10671-10-git-send-email-sameo@linux.intel.com> (sfid-20120410_193541_309427_57120922)
In-Reply-To: <1334079800-10671-1-git-send-email-sameo@linux.intel.com>
References: <1334079800-10671-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eric Lapuyade <eric.lapuyade@intel.com>

Signed-off-by: Eric Lapuyade <eric.lapuyade@intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 include/net/nfc/nfc.h |    3 ++-
 net/nfc/core.c        |   24 +++++++++++++++++++++---
 2 files changed, 23 insertions(+), 4 deletions(-)

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
index db88429..44a7018 100644
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
@@ -211,6 +211,8 @@ int nfc_dep_link_up(struct nfc_dev *dev, int target_index, u8 comm_mode)
 	}
 
 	rc = dev->ops->dep_link_up(dev, target_index, comm_mode, gb, gb_len);
+	if (!rc)
+		dev->activated_target_idx = target_index;
 
 error:
 	device_unlock(&dev->dev);
@@ -246,6 +248,7 @@ int nfc_dep_link_down(struct nfc_dev *dev)
 	rc = dev->ops->dep_link_down(dev);
 	if (!rc) {
 		dev->dep_link_up = false;
+		dev->activated_target_idx = NFC_TARGET_IDX_NONE;
 		nfc_llcp_mac_is_down(dev);
 		nfc_genl_dep_link_down_event(dev);
 	}
@@ -290,7 +293,7 @@ int nfc_activate_target(struct nfc_dev *dev, u32 target_idx, u32 protocol)
 
 	rc = dev->ops->activate_target(dev, target_idx, protocol);
 	if (!rc)
-		dev->remote_activated = true;
+		dev->activated_target_idx = target_idx;
 
 error:
 	device_unlock(&dev->dev);
@@ -318,7 +321,7 @@ int nfc_deactivate_target(struct nfc_dev *dev, u32 target_idx)
 	}
 
 	dev->ops->deactivate_target(dev, target_idx);
-	dev->remote_activated = false;
+	dev->activated_target_idx = NFC_TARGET_IDX_NONE;
 
 error:
 	device_unlock(&dev->dev);
@@ -352,6 +355,18 @@ int nfc_data_exchange(struct nfc_dev *dev, u32 target_idx, struct sk_buff *skb,
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
 	rc = dev->ops->data_exchange(dev, target_idx, skb, cb, cb_context);
 
 error:
@@ -482,6 +497,7 @@ int nfc_target_lost(struct nfc_dev *dev, u32 target_idx)
 
 	dev->targets_generation++;
 	dev->n_targets--;
+	dev->activated_target_idx = NFC_TARGET_IDX_NONE;
 
 	if (dev->n_targets) {
 		memcpy(&dev->targets[i], &dev->targets[i + 1],
@@ -575,6 +591,8 @@ struct nfc_dev *nfc_allocate_device(struct nfc_ops *ops,
 	/* first generation must not be 0 */
 	dev->targets_generation = 1;
 
+	dev->activated_target_idx = NFC_TARGET_IDX_NONE;
+
 	return dev;
 }
 EXPORT_SYMBOL(nfc_allocate_device);
-- 
1.7.9.1

