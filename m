Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:26259 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756148Ab2EGKcU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 06:32:20 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Eric Lapuyade <eric.lapuyade@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 04/20] NFC: Specify usage for targets found and target lost events
Date: Mon,  7 May 2012 12:31:15 +0200
Message-Id: <1336386691-24840-5-git-send-email-sameo@linux.intel.com> (sfid-20120507_123223_443538_DA548BFB)
In-Reply-To: <1336386691-24840-1-git-send-email-sameo@linux.intel.com>
References: <1336386691-24840-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eric Lapuyade <eric.lapuyade@intel.com>

It is now specified that nfc_target_found() and nfc_target_lost() core
functions must not be called from an atomic context. This allow us to
serialize calls and protect the targets table using the nfc device lock
instead of a spinlock.

Signed-off-by: Eric Lapuyade <eric.lapuyade@intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 include/net/nfc/nfc.h |    1 -
 net/nfc/core.c        |   35 ++++++++++++++++++++++++++---------
 net/nfc/netlink.c     |    4 ++--
 3 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
index 8ba1747..cee20aa 100644
--- a/include/net/nfc/nfc.h
+++ b/include/net/nfc/nfc.h
@@ -97,7 +97,6 @@ struct nfc_dev {
 	struct nfc_target *targets;
 	int n_targets;
 	int targets_generation;
-	spinlock_t targets_lock;
 	struct device dev;
 	bool dev_up;
 	bool polling;
diff --git a/net/nfc/core.c b/net/nfc/core.c
index 5d86f6c..02e1fda 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -501,6 +501,9 @@ EXPORT_SYMBOL(nfc_alloc_recv_skb);
  * The device driver must call this function when one or many nfc targets
  * are found. After calling this function, the device driver must stop
  * polling for targets.
+ * IMPORTANT: this function must not be called from an atomic context.
+ * In addition, it must also not be called from a context that would prevent
+ * the NFC Core to call other nfc ops entry point concurrently.
  */
 int nfc_targets_found(struct nfc_dev *dev,
 		      struct nfc_target *targets, int n_targets)
@@ -514,7 +517,7 @@ int nfc_targets_found(struct nfc_dev *dev,
 	for (i = 0; i < n_targets; i++)
 		targets[i].idx = dev->target_next_idx++;
 
-	spin_lock_bh(&dev->targets_lock);
+	device_lock(&dev->dev);
 
 	dev->targets_generation++;
 
@@ -524,12 +527,12 @@ int nfc_targets_found(struct nfc_dev *dev,
 
 	if (!dev->targets) {
 		dev->n_targets = 0;
-		spin_unlock_bh(&dev->targets_lock);
+		device_unlock(&dev->dev);
 		return -ENOMEM;
 	}
 
 	dev->n_targets = n_targets;
-	spin_unlock_bh(&dev->targets_lock);
+	device_unlock(&dev->dev);
 
 	nfc_genl_targets_found(dev);
 
@@ -537,6 +540,18 @@ int nfc_targets_found(struct nfc_dev *dev,
 }
 EXPORT_SYMBOL(nfc_targets_found);
 
+/**
+ * nfc_target_lost - inform that an activated target went out of field
+ *
+ * @dev: The nfc device that had the activated target in field
+ * @target_idx: the nfc index of the target
+ *
+ * The device driver must call this function when the activated target
+ * goes out of the field.
+ * IMPORTANT: this function must not be called from an atomic context.
+ * In addition, it must also not be called from a context that would prevent
+ * the NFC Core to call other nfc ops entry point concurrently.
+ */
 int nfc_target_lost(struct nfc_dev *dev, u32 target_idx)
 {
 	struct nfc_target *tg;
@@ -544,7 +559,7 @@ int nfc_target_lost(struct nfc_dev *dev, u32 target_idx)
 
 	pr_debug("dev_name %s n_target %d\n", dev_name(&dev->dev), target_idx);
 
-	spin_lock_bh(&dev->targets_lock);
+	device_lock(&dev->dev);
 
 	for (i = 0; i < dev->n_targets; i++) {
 		tg = &dev->targets[i];
@@ -553,7 +568,7 @@ int nfc_target_lost(struct nfc_dev *dev, u32 target_idx)
 	}
 
 	if (i == dev->n_targets) {
-		spin_unlock_bh(&dev->targets_lock);
+		device_unlock(&dev->dev);
 		return -EINVAL;
 	}
 
@@ -569,7 +584,7 @@ int nfc_target_lost(struct nfc_dev *dev, u32 target_idx)
 		dev->targets = NULL;
 	}
 
-	spin_unlock_bh(&dev->targets_lock);
+	device_unlock(&dev->dev);
 
 	nfc_genl_target_lost(dev, target_idx);
 
@@ -607,8 +622,10 @@ static void nfc_check_pres_work(struct work_struct *work)
 			mod_timer(&dev->check_pres_timer, jiffies +
 				  msecs_to_jiffies(NFC_CHECK_PRES_FREQ_MS));
 		} else {
-			nfc_target_lost(dev, dev->active_target->idx);
-			dev->active_target = NULL;
+			u32 active_target_idx = dev->active_target->idx;
+			device_unlock(&dev->dev);
+			nfc_target_lost(dev, active_target_idx);
+			return;
 		}
 	}
 
@@ -681,9 +698,9 @@ struct nfc_dev *nfc_allocate_device(struct nfc_ops *ops,
 	dev->tx_headroom = tx_headroom;
 	dev->tx_tailroom = tx_tailroom;
 
-	spin_lock_init(&dev->targets_lock);
 	nfc_genl_data_init(&dev->genl_data);
 
+
 	/* first generation must not be 0 */
 	dev->targets_generation = 1;
 
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 6c558bc..cc89e4f 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -124,7 +124,7 @@ static int nfc_genl_dump_targets(struct sk_buff *skb,
 		cb->args[1] = (long) dev;
 	}
 
-	spin_lock_bh(&dev->targets_lock);
+	device_lock(&dev->dev);
 
 	cb->seq = dev->targets_generation;
 
@@ -137,7 +137,7 @@ static int nfc_genl_dump_targets(struct sk_buff *skb,
 		i++;
 	}
 
-	spin_unlock_bh(&dev->targets_lock);
+	device_unlock(&dev->dev);
 
 	cb->args[0] = i;
 
-- 
1.7.9.1

