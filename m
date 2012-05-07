Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:21850 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378Ab2EGKb6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 06:31:58 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Eric Lapuyade <eric.lapuyade@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 02/20] NFC: Cache the core NFC active target pointer instead of its index
Date: Mon,  7 May 2012 12:31:13 +0200
Message-Id: <1336386691-24840-3-git-send-email-sameo@linux.intel.com> (sfid-20120507_123201_204561_591DDFD5)
In-Reply-To: <1336386691-24840-1-git-send-email-sameo@linux.intel.com>
References: <1336386691-24840-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eric Lapuyade <eric.lapuyade@intel.com>

The NFC Core now caches the active nfc target pointer, thereby avoiding
the need to lookup the target table for each invocation of a driver ops.
Consequently, pn533, HCI and NCI now directly receive an nfc_target
pointer instead of a target index.

Cc: Ilan Elias <ilane@ti.com>
Signed-off-by: Eric Lapuyade <eric.lapuyade@intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/pn533.c   |   16 +++++-----
 include/net/nfc/nfc.h |   18 ++++++-----
 net/nfc/core.c        |   81 +++++++++++++++++++++++++++++++++++++------------
 net/nfc/hci/core.c    |   36 ++++------------------
 net/nfc/nci/core.c    |   27 ++++++++--------
 5 files changed, 99 insertions(+), 79 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index e6ec16d..766e0bb 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -1194,8 +1194,8 @@ static int pn533_activate_target_nfcdep(struct pn533 *dev)
 	return rc;
 }
 
-static int pn533_activate_target(struct nfc_dev *nfc_dev, u32 target_idx,
-								u32 protocol)
+static int pn533_activate_target(struct nfc_dev *nfc_dev,
+				 struct nfc_target *target, u32 protocol)
 {
 	struct pn533 *dev = nfc_get_drvdata(nfc_dev);
 	int rc;
@@ -1243,7 +1243,8 @@ static int pn533_activate_target(struct nfc_dev *nfc_dev, u32 target_idx,
 	return 0;
 }
 
-static void pn533_deactivate_target(struct nfc_dev *nfc_dev, u32 target_idx)
+static void pn533_deactivate_target(struct nfc_dev *nfc_dev,
+				    struct nfc_target *target)
 {
 	struct pn533 *dev = nfc_get_drvdata(nfc_dev);
 	u8 tg;
@@ -1351,7 +1352,7 @@ static int pn533_in_dep_link_up_complete(struct pn533 *dev, void *arg,
 	return 0;
 }
 
-static int pn533_dep_link_up(struct nfc_dev *nfc_dev, int target_idx,
+static int pn533_dep_link_up(struct nfc_dev *nfc_dev, struct nfc_target *target,
 			     u8 comm_mode, u8* gb, size_t gb_len)
 {
 	struct pn533 *dev = nfc_get_drvdata(nfc_dev);
@@ -1552,10 +1553,9 @@ error:
 	return 0;
 }
 
-static int pn533_data_exchange(struct nfc_dev *nfc_dev, u32 target_idx,
-						struct sk_buff *skb,
-						data_exchange_cb_t cb,
-						void *cb_context)
+static int pn533_data_exchange(struct nfc_dev *nfc_dev,
+			       struct nfc_target *target, struct sk_buff *skb,
+			       data_exchange_cb_t cb, void *cb_context)
 {
 	struct pn533 *dev = nfc_get_drvdata(nfc_dev);
 	struct pn533_frame *out_frame, *in_frame;
diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
index 313d00f..8ba1747 100644
--- a/include/net/nfc/nfc.h
+++ b/include/net/nfc/nfc.h
@@ -48,26 +48,28 @@ struct nfc_dev;
 typedef void (*data_exchange_cb_t)(void *context, struct sk_buff *skb,
 								int err);
 
+struct nfc_target;
+
 struct nfc_ops {
 	int (*dev_up)(struct nfc_dev *dev);
 	int (*dev_down)(struct nfc_dev *dev);
 	int (*start_poll)(struct nfc_dev *dev, u32 protocols);
 	void (*stop_poll)(struct nfc_dev *dev);
-	int (*dep_link_up)(struct nfc_dev *dev, int target_idx, u8 comm_mode,
-			   u8 *gb, size_t gb_len);
+	int (*dep_link_up)(struct nfc_dev *dev, struct nfc_target *target,
+			   u8 comm_mode, u8 *gb, size_t gb_len);
 	int (*dep_link_down)(struct nfc_dev *dev);
-	int (*activate_target)(struct nfc_dev *dev, u32 target_idx,
+	int (*activate_target)(struct nfc_dev *dev, struct nfc_target *target,
 			       u32 protocol);
-	void (*deactivate_target)(struct nfc_dev *dev, u32 target_idx);
-	int (*data_exchange)(struct nfc_dev *dev, u32 target_idx,
+	void (*deactivate_target)(struct nfc_dev *dev,
+				  struct nfc_target *target);
+	int (*data_exchange)(struct nfc_dev *dev, struct nfc_target *target,
 			     struct sk_buff *skb, data_exchange_cb_t cb,
 			     void *cb_context);
-	int (*check_presence)(struct nfc_dev *dev, u32 target_idx);
+	int (*check_presence)(struct nfc_dev *dev, struct nfc_target *target);
 };
 
 #define NFC_TARGET_IDX_ANY -1
 #define NFC_MAX_GT_LEN 48
-#define NFC_TARGET_IDX_NONE 0xffffffff
 
 struct nfc_target {
 	u32 idx;
@@ -99,7 +101,7 @@ struct nfc_dev {
 	struct device dev;
 	bool dev_up;
 	bool polling;
-	u32 activated_target_idx;
+	struct nfc_target *active_target;
 	bool dep_link_up;
 	u32 dep_rf_mode;
 	struct nfc_genl_data genl_data;
diff --git a/net/nfc/core.c b/net/nfc/core.c
index da35327..5d86f6c 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -97,7 +97,7 @@ int nfc_dev_down(struct nfc_dev *dev)
 		goto error;
 	}
 
-	if (dev->polling || dev->activated_target_idx != NFC_TARGET_IDX_NONE) {
+	if (dev->polling || dev->active_target) {
 		rc = -EBUSY;
 		goto error;
 	}
@@ -183,11 +183,27 @@ error:
 	return rc;
 }
 
+static struct nfc_target *nfc_find_target(struct nfc_dev *dev, u32 target_idx)
+{
+	int i;
+
+	if (dev->n_targets == 0)
+		return NULL;
+
+	for (i = 0; i < dev->n_targets ; i++) {
+		if (dev->targets[i].idx == target_idx)
+			return &dev->targets[i];
+	}
+
+	return NULL;
+}
+
 int nfc_dep_link_up(struct nfc_dev *dev, int target_index, u8 comm_mode)
 {
 	int rc = 0;
 	u8 *gb;
 	size_t gb_len;
+	struct nfc_target *target;
 
 	pr_debug("dev_name=%s comm %d\n", dev_name(&dev->dev), comm_mode);
 
@@ -212,9 +228,15 @@ int nfc_dep_link_up(struct nfc_dev *dev, int target_index, u8 comm_mode)
 		goto error;
 	}
 
-	rc = dev->ops->dep_link_up(dev, target_index, comm_mode, gb, gb_len);
+	target = nfc_find_target(dev, target_index);
+	if (target == NULL) {
+		rc = -ENOTCONN;
+		goto error;
+	}
+
+	rc = dev->ops->dep_link_up(dev, target, comm_mode, gb, gb_len);
 	if (!rc)
-		dev->activated_target_idx = target_index;
+		dev->active_target = target;
 
 error:
 	device_unlock(&dev->dev);
@@ -250,7 +272,7 @@ int nfc_dep_link_down(struct nfc_dev *dev)
 	rc = dev->ops->dep_link_down(dev);
 	if (!rc) {
 		dev->dep_link_up = false;
-		dev->activated_target_idx = NFC_TARGET_IDX_NONE;
+		dev->active_target = NULL;
 		nfc_llcp_mac_is_down(dev);
 		nfc_genl_dep_link_down_event(dev);
 	}
@@ -282,6 +304,7 @@ EXPORT_SYMBOL(nfc_dep_link_is_up);
 int nfc_activate_target(struct nfc_dev *dev, u32 target_idx, u32 protocol)
 {
 	int rc;
+	struct nfc_target *target;
 
 	pr_debug("dev_name=%s target_idx=%u protocol=%u\n",
 		 dev_name(&dev->dev), target_idx, protocol);
@@ -293,9 +316,20 @@ int nfc_activate_target(struct nfc_dev *dev, u32 target_idx, u32 protocol)
 		goto error;
 	}
 
-	rc = dev->ops->activate_target(dev, target_idx, protocol);
+	if (dev->active_target) {
+		rc = -EBUSY;
+		goto error;
+	}
+
+	target = nfc_find_target(dev, target_idx);
+	if (target == NULL) {
+		rc = -ENOTCONN;
+		goto error;
+	}
+
+	rc = dev->ops->activate_target(dev, target, protocol);
 	if (!rc) {
-		dev->activated_target_idx = target_idx;
+		dev->active_target = target;
 
 		if (dev->ops->check_presence)
 			mod_timer(&dev->check_pres_timer, jiffies +
@@ -327,11 +361,21 @@ int nfc_deactivate_target(struct nfc_dev *dev, u32 target_idx)
 		goto error;
 	}
 
+	if (dev->active_target == NULL) {
+		rc = -ENOTCONN;
+		goto error;
+	}
+
+	if (dev->active_target->idx != target_idx) {
+		rc = -ENOTCONN;
+		goto error;
+	}
+
 	if (dev->ops->check_presence)
 		del_timer_sync(&dev->check_pres_timer);
 
-	dev->ops->deactivate_target(dev, target_idx);
-	dev->activated_target_idx = NFC_TARGET_IDX_NONE;
+	dev->ops->deactivate_target(dev, dev->active_target);
+	dev->active_target = NULL;
 
 error:
 	device_unlock(&dev->dev);
@@ -365,13 +409,13 @@ int nfc_data_exchange(struct nfc_dev *dev, u32 target_idx, struct sk_buff *skb,
 		goto error;
 	}
 
-	if (dev->activated_target_idx == NFC_TARGET_IDX_NONE) {
+	if (dev->active_target == NULL) {
 		rc = -ENOTCONN;
 		kfree_skb(skb);
 		goto error;
 	}
 
-	if (target_idx != dev->activated_target_idx) {
+	if (dev->active_target->idx != target_idx) {
 		rc = -EADDRNOTAVAIL;
 		kfree_skb(skb);
 		goto error;
@@ -380,7 +424,8 @@ int nfc_data_exchange(struct nfc_dev *dev, u32 target_idx, struct sk_buff *skb,
 	if (dev->ops->check_presence)
 		del_timer_sync(&dev->check_pres_timer);
 
-	rc = dev->ops->data_exchange(dev, target_idx, skb, cb, cb_context);
+	rc = dev->ops->data_exchange(dev, dev->active_target, skb, cb,
+				     cb_context);
 
 	if (!rc && dev->ops->check_presence)
 		mod_timer(&dev->check_pres_timer, jiffies +
@@ -514,7 +559,7 @@ int nfc_target_lost(struct nfc_dev *dev, u32 target_idx)
 
 	dev->targets_generation++;
 	dev->n_targets--;
-	dev->activated_target_idx = NFC_TARGET_IDX_NONE;
+	dev->active_target = NULL;
 
 	if (dev->n_targets) {
 		memcpy(&dev->targets[i], &dev->targets[i + 1],
@@ -556,15 +601,14 @@ static void nfc_check_pres_work(struct work_struct *work)
 
 	device_lock(&dev->dev);
 
-	if (dev->activated_target_idx != NFC_TARGET_IDX_NONE &&
-	    timer_pending(&dev->check_pres_timer) == 0) {
-		rc = dev->ops->check_presence(dev, dev->activated_target_idx);
+	if (dev->active_target && timer_pending(&dev->check_pres_timer) == 0) {
+		rc = dev->ops->check_presence(dev, dev->active_target);
 		if (!rc) {
 			mod_timer(&dev->check_pres_timer, jiffies +
 				  msecs_to_jiffies(NFC_CHECK_PRES_FREQ_MS));
 		} else {
-			nfc_target_lost(dev, dev->activated_target_idx);
-			dev->activated_target_idx = NFC_TARGET_IDX_NONE;
+			nfc_target_lost(dev, dev->active_target->idx);
+			dev->active_target = NULL;
 		}
 	}
 
@@ -643,8 +687,6 @@ struct nfc_dev *nfc_allocate_device(struct nfc_ops *ops,
 	/* first generation must not be 0 */
 	dev->targets_generation = 1;
 
-	dev->activated_target_idx = NFC_TARGET_IDX_NONE;
-
 	if (ops->check_presence) {
 		char name[32];
 		init_timer(&dev->check_pres_timer);
@@ -662,7 +704,6 @@ struct nfc_dev *nfc_allocate_device(struct nfc_ops *ops,
 		}
 	}
 
-
 	return dev;
 }
 EXPORT_SYMBOL(nfc_allocate_device);
diff --git a/net/nfc/hci/core.c b/net/nfc/hci/core.c
index 86fd00d..545c19f 100644
--- a/net/nfc/hci/core.c
+++ b/net/nfc/hci/core.c
@@ -520,50 +520,26 @@ static void hci_stop_poll(struct nfc_dev *nfc_dev)
 	}
 }
 
-static struct nfc_target *hci_find_target(struct nfc_hci_dev *hdev,
-					  u32 target_idx)
+static int hci_activate_target(struct nfc_dev *nfc_dev,
+			       struct nfc_target *target, u32 protocol)
 {
-	int i;
-	if (hdev->poll_started == false || hdev->targets == NULL)
-		return NULL;
-
-	for (i = 0; i < hdev->target_count; i++) {
-		if (hdev->targets[i].idx == target_idx)
-			return &hdev->targets[i];
-	}
-
-	return NULL;
-}
-
-static int hci_activate_target(struct nfc_dev *nfc_dev, u32 target_idx,
-			       u32 protocol)
-{
-	struct nfc_hci_dev *hdev = nfc_get_drvdata(nfc_dev);
-
-	if (hci_find_target(hdev, target_idx) == NULL)
-		return -ENOMEDIUM;
-
 	return 0;
 }
 
-static void hci_deactivate_target(struct nfc_dev *nfc_dev, u32 target_idx)
+static void hci_deactivate_target(struct nfc_dev *nfc_dev,
+				  struct nfc_target *target)
 {
 }
 
-static int hci_data_exchange(struct nfc_dev *nfc_dev, u32 target_idx,
+static int hci_data_exchange(struct nfc_dev *nfc_dev, struct nfc_target *target,
 			     struct sk_buff *skb, data_exchange_cb_t cb,
 			     void *cb_context)
 {
 	struct nfc_hci_dev *hdev = nfc_get_drvdata(nfc_dev);
 	int r;
-	struct nfc_target *target;
 	struct sk_buff *res_skb = NULL;
 
-	pr_debug("target_idx=%d\n", target_idx);
-
-	target = hci_find_target(hdev, target_idx);
-	if (target == NULL)
-		return -ENOMEDIUM;
+	pr_debug("target_idx=%d\n", target->idx);
 
 	switch (target->hci_reader_gate) {
 	case NFC_HCI_RF_READER_A_GATE:
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 8737c20..d560e6f 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -436,16 +436,16 @@ static void nci_stop_poll(struct nfc_dev *nfc_dev)
 		    msecs_to_jiffies(NCI_RF_DEACTIVATE_TIMEOUT));
 }
 
-static int nci_activate_target(struct nfc_dev *nfc_dev, __u32 target_idx,
-			       __u32 protocol)
+static int nci_activate_target(struct nfc_dev *nfc_dev,
+			       struct nfc_target *target, __u32 protocol)
 {
 	struct nci_dev *ndev = nfc_get_drvdata(nfc_dev);
 	struct nci_rf_discover_select_param param;
-	struct nfc_target *target = NULL;
+	struct nfc_target *nci_target = NULL;
 	int i;
 	int rc = 0;
 
-	pr_debug("target_idx %d, protocol 0x%x\n", target_idx, protocol);
+	pr_debug("target_idx %d, protocol 0x%x\n", target->idx, protocol);
 
 	if ((atomic_read(&ndev->state) != NCI_W4_HOST_SELECT) &&
 	    (atomic_read(&ndev->state) != NCI_POLL_ACTIVE)) {
@@ -459,25 +459,25 @@ static int nci_activate_target(struct nfc_dev *nfc_dev, __u32 target_idx,
 	}
 
 	for (i = 0; i < ndev->n_targets; i++) {
-		if (ndev->targets[i].idx == target_idx) {
-			target = &ndev->targets[i];
+		if (ndev->targets[i].idx == target->idx) {
+			nci_target = &ndev->targets[i];
 			break;
 		}
 	}
 
-	if (!target) {
+	if (!nci_target) {
 		pr_err("unable to find the selected target\n");
 		return -EINVAL;
 	}
 
-	if (!(target->supported_protocols & (1 << protocol))) {
+	if (!(nci_target->supported_protocols & (1 << protocol))) {
 		pr_err("target does not support the requested protocol 0x%x\n",
 		       protocol);
 		return -EINVAL;
 	}
 
 	if (atomic_read(&ndev->state) == NCI_W4_HOST_SELECT) {
-		param.rf_discovery_id = target->logical_idx;
+		param.rf_discovery_id = nci_target->logical_idx;
 
 		if (protocol == NFC_PROTO_JEWEL)
 			param.rf_protocol = NCI_RF_PROTOCOL_T1T;
@@ -501,11 +501,12 @@ static int nci_activate_target(struct nfc_dev *nfc_dev, __u32 target_idx,
 	return rc;
 }
 
-static void nci_deactivate_target(struct nfc_dev *nfc_dev, __u32 target_idx)
+static void nci_deactivate_target(struct nfc_dev *nfc_dev,
+				  struct nfc_target *target)
 {
 	struct nci_dev *ndev = nfc_get_drvdata(nfc_dev);
 
-	pr_debug("target_idx %d\n", target_idx);
+	pr_debug("target_idx %d\n", target->idx);
 
 	if (!ndev->target_active_prot) {
 		pr_err("unable to deactivate target, no active target\n");
@@ -520,14 +521,14 @@ static void nci_deactivate_target(struct nfc_dev *nfc_dev, __u32 target_idx)
 	}
 }
 
-static int nci_data_exchange(struct nfc_dev *nfc_dev, __u32 target_idx,
+static int nci_data_exchange(struct nfc_dev *nfc_dev, struct nfc_target *target,
 			     struct sk_buff *skb,
 			     data_exchange_cb_t cb, void *cb_context)
 {
 	struct nci_dev *ndev = nfc_get_drvdata(nfc_dev);
 	int rc;
 
-	pr_debug("target_idx %d, len %d\n", target_idx, skb->len);
+	pr_debug("target_idx %d, len %d\n", target->idx, skb->len);
 
 	if (!ndev->target_active_prot) {
 		pr_err("unable to exchange data, no active target\n");
-- 
1.7.9.1

