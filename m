Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:60521 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086Ab2CYOQE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Mar 2012 10:16:04 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qualcomm.com,
	Ray Chen <raychen@qca.qualcomm.com>
Subject: [PATCH v2 7/9] ath6kl: add htc ops
Date: Sun, 25 Mar 2012 17:15:27 +0300
Message-Id: <1332684929-6405-8-git-send-email-kvalo@qca.qualcomm.com> (sfid-20120325_161628_482306_3FCFDDF0)
In-Reply-To: <1332684929-6405-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1332684929-6405-1-git-send-email-kvalo@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation for adding HTC pipe implementation add htc-ops.h to make
it possible dynamically choose which HTC type is used.

Needed for full USB support.

Based on the code by Ray Chen <raychen@qca.qualcomm.com>.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Ray Chen <raychen@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/Makefile           |    2 +-
 drivers/net/wireless/ath/ath6kl/core.c             |   12 ++-
 drivers/net/wireless/ath/ath6kl/core.h             |    7 +-
 drivers/net/wireless/ath/ath6kl/htc-ops.h          |  113 ++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/htc.h              |   53 +++++-----
 .../net/wireless/ath/ath6kl/{htc.c => htc_mbox.c}  |   77 +++++++++----
 drivers/net/wireless/ath/ath6kl/init.c             |    3 +-
 drivers/net/wireless/ath/ath6kl/sdio.c             |    2 +-
 drivers/net/wireless/ath/ath6kl/txrx.c             |    3 +-
 drivers/net/wireless/ath/ath6kl/usb.c              |    2 +-
 10 files changed, 219 insertions(+), 55 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath6kl/htc-ops.h
 rename drivers/net/wireless/ath/ath6kl/{htc.c => htc_mbox.c} (96%)

diff --git a/drivers/net/wireless/ath/ath6kl/Makefile b/drivers/net/wireless/ath/ath6kl/Makefile
index 85746c3..f4ac817 100644
--- a/drivers/net/wireless/ath/ath6kl/Makefile
+++ b/drivers/net/wireless/ath/ath6kl/Makefile
@@ -25,7 +25,7 @@
 obj-$(CONFIG_ATH6KL) += ath6kl_core.o
 ath6kl_core-y += debug.o
 ath6kl_core-y += hif.o
-ath6kl_core-y += htc.o
+ath6kl_core-y += htc_mbox.o
 ath6kl_core-y += bmi.o
 ath6kl_core-y += cfg80211.o
 ath6kl_core-y += init.o
diff --git a/drivers/net/wireless/ath/ath6kl/core.c b/drivers/net/wireless/ath/ath6kl/core.c
index 45e641f..bb9fe38 100644
--- a/drivers/net/wireless/ath/ath6kl/core.c
+++ b/drivers/net/wireless/ath/ath6kl/core.c
@@ -23,6 +23,7 @@
 
 #include "debug.h"
 #include "hif-ops.h"
+#include "htc-ops.h"
 #include "cfg80211.h"
 
 unsigned int debug_mask;
@@ -39,12 +40,21 @@ module_param(uart_debug, uint, 0644);
 module_param(ath6kl_p2p, uint, 0644);
 module_param(testmode, uint, 0644);
 
-int ath6kl_core_init(struct ath6kl *ar)
+int ath6kl_core_init(struct ath6kl *ar, enum ath6kl_htc_type htc_type)
 {
 	struct ath6kl_bmi_target_info targ_info;
 	struct net_device *ndev;
 	int ret = 0, i;
 
+	switch (htc_type) {
+	case ATH6KL_HTC_TYPE_MBOX:
+		ath6kl_htc_mbox_attach(ar);
+		break;
+	default:
+		WARN_ON(1);
+		return -ENOMEM;
+	}
+
 	ar->ath6kl_wq = create_singlethread_workqueue("ath6kl");
 	if (!ar->ath6kl_wq)
 		return -ENOMEM;
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 6485ef0..d0bcb06 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -454,6 +454,10 @@ enum ath6kl_hif_type {
 	ATH6KL_HIF_TYPE_USB,
 };
 
+enum ath6kl_htc_type {
+	ATH6KL_HTC_TYPE_MBOX,
+};
+
 /* Max number of filters that hw supports */
 #define ATH6K_MAX_MC_FILTERS_PER_LIST 7
 struct ath6kl_mc_filter {
@@ -568,6 +572,7 @@ struct ath6kl {
 
 	struct ath6kl_bmi bmi;
 	const struct ath6kl_hif_ops *hif_ops;
+	const struct ath6kl_htc_ops *htc_ops;
 	struct wmi *wmi;
 	int tx_pending[ENDPOINT_MAX];
 	int total_tx_data_pend;
@@ -823,7 +828,7 @@ int ath6kl_init_hw_params(struct ath6kl *ar);
 void ath6kl_check_wow_status(struct ath6kl *ar);
 
 struct ath6kl *ath6kl_core_create(struct device *dev);
-int ath6kl_core_init(struct ath6kl *ar);
+int ath6kl_core_init(struct ath6kl *ar, enum ath6kl_htc_type htc_type);
 void ath6kl_core_cleanup(struct ath6kl *ar);
 void ath6kl_core_destroy(struct ath6kl *ar);
 
diff --git a/drivers/net/wireless/ath/ath6kl/htc-ops.h b/drivers/net/wireless/ath/ath6kl/htc-ops.h
new file mode 100644
index 0000000..2d4eed5
--- /dev/null
+++ b/drivers/net/wireless/ath/ath6kl/htc-ops.h
@@ -0,0 +1,113 @@
+/*
+ * Copyright (c) 2004-2011 Atheros Communications Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef HTC_OPS_H
+#define HTC_OPS_H
+
+#include "htc.h"
+#include "debug.h"
+
+static inline void *ath6kl_htc_create(struct ath6kl *ar)
+{
+	return ar->htc_ops->create(ar);
+}
+
+static inline int ath6kl_htc_wait_target(struct htc_target *target)
+{
+	return target->dev->ar->htc_ops->wait_target(target);
+}
+
+static inline int ath6kl_htc_start(struct htc_target *target)
+{
+	return target->dev->ar->htc_ops->start(target);
+}
+
+static inline int ath6kl_htc_conn_service(struct htc_target *target,
+					  struct htc_service_connect_req *req,
+					  struct htc_service_connect_resp *resp)
+{
+	return target->dev->ar->htc_ops->conn_service(target, req, resp);
+}
+
+static inline int ath6kl_htc_tx(struct htc_target *target,
+				struct htc_packet *packet)
+{
+	return target->dev->ar->htc_ops->tx(target, packet);
+}
+
+static inline void ath6kl_htc_stop(struct htc_target *target)
+{
+	return target->dev->ar->htc_ops->stop(target);
+}
+
+static inline void ath6kl_htc_cleanup(struct htc_target *target)
+{
+	return target->dev->ar->htc_ops->cleanup(target);
+}
+
+static inline void ath6kl_htc_flush_txep(struct htc_target *target,
+					 enum htc_endpoint_id endpoint,
+					 u16 tag)
+{
+	return target->dev->ar->htc_ops->flush_txep(target, endpoint, tag);
+}
+
+static inline void ath6kl_htc_flush_rx_buf(struct htc_target *target)
+{
+	return target->dev->ar->htc_ops->flush_rx_buf(target);
+}
+
+static inline void ath6kl_htc_activity_changed(struct htc_target *target,
+					       enum htc_endpoint_id endpoint,
+					       bool active)
+{
+	return target->dev->ar->htc_ops->activity_changed(target, endpoint,
+							  active);
+}
+
+static inline int ath6kl_htc_get_rxbuf_num(struct htc_target *target,
+					   enum htc_endpoint_id endpoint)
+{
+	return target->dev->ar->htc_ops->get_rxbuf_num(target, endpoint);
+}
+
+static inline int ath6kl_htc_add_rxbuf_multiple(struct htc_target *target,
+						struct list_head *pktq)
+{
+	return target->dev->ar->htc_ops->add_rxbuf_multiple(target, pktq);
+}
+
+static inline int ath6kl_htc_credit_setup(struct htc_target *target,
+					  struct ath6kl_htc_credit_info *info)
+{
+	return target->dev->ar->htc_ops->credit_setup(target, info);
+}
+
+static inline void ath6kl_htc_tx_complete(struct ath6kl *ar,
+					  struct sk_buff *skb)
+{
+	ar->htc_ops->tx_complete(ar, skb);
+}
+
+
+static inline void ath6kl_htc_rx_complete(struct ath6kl *ar,
+					  struct sk_buff *skb, u8 pipe)
+{
+	ar->htc_ops->rx_complete(ar, skb, pipe);
+}
+
+
+#endif
diff --git a/drivers/net/wireless/ath/ath6kl/htc.h b/drivers/net/wireless/ath/ath6kl/htc.h
index 0ba8deb..43cb2cf 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.h
+++ b/drivers/net/wireless/ath/ath6kl/htc.h
@@ -519,6 +519,32 @@ struct htc_control_buffer {
 	u8 *buf;
 };
 
+struct ath6kl_htc_ops {
+	void* (*create)(struct ath6kl *ar);
+	int (*wait_target)(struct htc_target *target);
+	int (*start)(struct htc_target *target);
+	int (*conn_service)(struct htc_target *target,
+			    struct htc_service_connect_req *req,
+			    struct htc_service_connect_resp *resp);
+	int  (*tx)(struct htc_target *target, struct htc_packet *packet);
+	void (*stop)(struct htc_target *target);
+	void (*cleanup)(struct htc_target *target);
+	void (*flush_txep)(struct htc_target *target,
+			   enum htc_endpoint_id endpoint, u16 tag);
+	void (*flush_rx_buf)(struct htc_target *target);
+	void (*activity_changed)(struct htc_target *target,
+				 enum htc_endpoint_id endpoint,
+				 bool active);
+	int (*get_rxbuf_num)(struct htc_target *target,
+			     enum htc_endpoint_id endpoint);
+	int (*add_rxbuf_multiple)(struct htc_target *target,
+				  struct list_head *pktq);
+	int (*credit_setup)(struct htc_target *target,
+			    struct ath6kl_htc_credit_info *cred_info);
+	int (*tx_complete)(struct ath6kl *ar, struct sk_buff *skb);
+	int (*rx_complete)(struct ath6kl *ar, struct sk_buff *skb, u8 pipe);
+};
+
 struct ath6kl_device;
 
 /* our HTC target state */
@@ -569,34 +595,9 @@ struct htc_target {
 	u32 ac_tx_count[WMM_NUM_AC];
 };
 
-void *ath6kl_htc_create(struct ath6kl *ar);
-void ath6kl_htc_set_credit_dist(struct htc_target *target,
-				struct ath6kl_htc_credit_info *cred_info,
-				u16 svc_pri_order[], int len);
-int ath6kl_htc_wait_target(struct htc_target *target);
-int ath6kl_htc_start(struct htc_target *target);
-int ath6kl_htc_conn_service(struct htc_target *target,
-			    struct htc_service_connect_req *req,
-			    struct htc_service_connect_resp *resp);
-int ath6kl_htc_tx(struct htc_target *target, struct htc_packet *packet);
-void ath6kl_htc_stop(struct htc_target *target);
-void ath6kl_htc_cleanup(struct htc_target *target);
-void ath6kl_htc_flush_txep(struct htc_target *target,
-			   enum htc_endpoint_id endpoint, u16 tag);
-void ath6kl_htc_flush_rx_buf(struct htc_target *target);
-void ath6kl_htc_indicate_activity_change(struct htc_target *target,
-					 enum htc_endpoint_id endpoint,
-					 bool active);
-int ath6kl_htc_get_rxbuf_num(struct htc_target *target,
-			     enum htc_endpoint_id endpoint);
-int ath6kl_htc_add_rxbuf_multiple(struct htc_target *target,
-				  struct list_head *pktq);
 int ath6kl_htc_rxmsg_pending_handler(struct htc_target *target,
 				     u32 msg_look_ahead, int *n_pkts);
 
-int ath6kl_credit_setup(struct htc_target *htc_target,
-			struct ath6kl_htc_credit_info *cred_info);
-
 static inline void set_htc_pkt_info(struct htc_packet *packet, void *context,
 				    u8 *buf, unsigned int len,
 				    enum htc_endpoint_id eid, u16 tag)
@@ -636,4 +637,6 @@ static inline int get_queue_depth(struct list_head *queue)
 	return depth;
 }
 
+void ath6kl_htc_mbox_attach(struct ath6kl *ar);
+
 #endif
diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
similarity index 96%
rename from drivers/net/wireless/ath/ath6kl/htc.c
rename to drivers/net/wireless/ath/ath6kl/htc_mbox.c
index 9d55541..d26d772 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
@@ -23,6 +23,14 @@
 
 #define CALC_TXRX_PADDED_LEN(dev, len)  (__ALIGN_MASK((len), (dev)->block_mask))
 
+static void ath6kl_htc_mbox_cleanup(struct htc_target *target);
+static void ath6kl_htc_mbox_stop(struct htc_target *target);
+static int ath6kl_htc_mbox_add_rxbuf_multiple(struct htc_target *target,
+					      struct list_head *pkt_queue);
+static void ath6kl_htc_set_credit_dist(struct htc_target *target,
+				       struct ath6kl_htc_credit_info *cred_info,
+				       u16 svc_pri_order[], int len);
+
 /* threshold to re-enable Tx bundling for an AC*/
 #define TX_RESUME_BUNDLE_THRESHOLD	1500
 
@@ -130,8 +138,8 @@ static void ath6kl_credit_init(struct ath6kl_htc_credit_info *cred_info,
 }
 
 /* initialize and setup credit distribution */
-int ath6kl_credit_setup(struct htc_target *htc_target,
-			struct ath6kl_htc_credit_info *cred_info)
+static int ath6kl_htc_mbox_credit_setup(struct htc_target *htc_target,
+			       struct ath6kl_htc_credit_info *cred_info)
 {
 	u16 servicepriority[5];
 
@@ -1065,7 +1073,7 @@ static int htc_setup_tx_complete(struct htc_target *target)
 	return status;
 }
 
-void ath6kl_htc_set_credit_dist(struct htc_target *target,
+static void ath6kl_htc_set_credit_dist(struct htc_target *target,
 				struct ath6kl_htc_credit_info *credit_info,
 				u16 srvc_pri_order[], int list_len)
 {
@@ -1093,7 +1101,8 @@ void ath6kl_htc_set_credit_dist(struct htc_target *target,
 	}
 }
 
-int ath6kl_htc_tx(struct htc_target *target, struct htc_packet *packet)
+static int ath6kl_htc_mbox_tx(struct htc_target *target,
+			      struct htc_packet *packet)
 {
 	struct htc_endpoint *endpoint;
 	struct list_head queue;
@@ -1121,7 +1130,7 @@ int ath6kl_htc_tx(struct htc_target *target, struct htc_packet *packet)
 }
 
 /* flush endpoint TX queue */
-void ath6kl_htc_flush_txep(struct htc_target *target,
+static void ath6kl_htc_mbox_flush_txep(struct htc_target *target,
 			   enum htc_endpoint_id eid, u16 tag)
 {
 	struct htc_packet *packet, *tmp_pkt;
@@ -1173,12 +1182,13 @@ static void ath6kl_htc_flush_txep_all(struct htc_target *target)
 		if (endpoint->svc_id == 0)
 			/* not in use.. */
 			continue;
-		ath6kl_htc_flush_txep(target, i, HTC_TX_PACKET_TAG_ALL);
+		ath6kl_htc_mbox_flush_txep(target, i, HTC_TX_PACKET_TAG_ALL);
 	}
 }
 
-void ath6kl_htc_indicate_activity_change(struct htc_target *target,
-					 enum htc_endpoint_id eid, bool active)
+static void ath6kl_htc_mbox_activity_changed(struct htc_target *target,
+					     enum htc_endpoint_id eid,
+					     bool active)
 {
 	struct htc_endpoint *endpoint = &target->endpoint[eid];
 	bool dist = false;
@@ -1246,7 +1256,7 @@ static int htc_add_rxbuf(struct htc_target *target, struct htc_packet *packet)
 
 	INIT_LIST_HEAD(&queue);
 	list_add_tail(&packet->list, &queue);
-	return ath6kl_htc_add_rxbuf_multiple(target, &queue);
+	return ath6kl_htc_mbox_add_rxbuf_multiple(target, &queue);
 }
 
 static void htc_reclaim_rxbuf(struct htc_target *target,
@@ -2288,7 +2298,7 @@ fail_ctrl_rx:
 	return NULL;
 }
 
-int ath6kl_htc_add_rxbuf_multiple(struct htc_target *target,
+static int ath6kl_htc_mbox_add_rxbuf_multiple(struct htc_target *target,
 				  struct list_head *pkt_queue)
 {
 	struct htc_endpoint *endpoint;
@@ -2350,7 +2360,7 @@ int ath6kl_htc_add_rxbuf_multiple(struct htc_target *target,
 	return status;
 }
 
-void ath6kl_htc_flush_rx_buf(struct htc_target *target)
+static void ath6kl_htc_mbox_flush_rx_buf(struct htc_target *target)
 {
 	struct htc_endpoint *endpoint;
 	struct htc_packet *packet, *tmp_pkt;
@@ -2392,7 +2402,7 @@ void ath6kl_htc_flush_rx_buf(struct htc_target *target)
 	}
 }
 
-int ath6kl_htc_conn_service(struct htc_target *target,
+static int ath6kl_htc_mbox_conn_service(struct htc_target *target,
 			    struct htc_service_connect_req *conn_req,
 			    struct htc_service_connect_resp *conn_resp)
 {
@@ -2564,7 +2574,7 @@ static void reset_ep_state(struct htc_target *target)
 	INIT_LIST_HEAD(&target->cred_dist_list);
 }
 
-int ath6kl_htc_get_rxbuf_num(struct htc_target *target,
+static int ath6kl_htc_mbox_get_rxbuf_num(struct htc_target *target,
 			     enum htc_endpoint_id endpoint)
 {
 	int num;
@@ -2624,7 +2634,7 @@ static void htc_setup_msg_bndl(struct htc_target *target)
 	}
 }
 
-int ath6kl_htc_wait_target(struct htc_target *target)
+static int ath6kl_htc_mbox_wait_target(struct htc_target *target)
 {
 	struct htc_packet *packet = NULL;
 	struct htc_ready_ext_msg *rdy_msg;
@@ -2693,12 +2703,12 @@ int ath6kl_htc_wait_target(struct htc_target *target)
 	connect.svc_id = HTC_CTRL_RSVD_SVC;
 
 	/* connect fake service */
-	status = ath6kl_htc_conn_service((void *)target, &connect, &resp);
+	status = ath6kl_htc_mbox_conn_service((void *)target, &connect, &resp);
 
 	if (status)
 		/*
 		 * FIXME: this call doesn't make sense, the caller should
-		 * call ath6kl_htc_cleanup() when it wants remove htc
+		 * call ath6kl_htc_mbox_cleanup() when it wants remove htc
 		 */
 		ath6kl_hif_cleanup_scatter(target->dev->ar);
 
@@ -2715,7 +2725,7 @@ fail_wait_target:
  * Start HTC, enable interrupts and let the target know
  * host has finished setup.
  */
-int ath6kl_htc_start(struct htc_target *target)
+static int ath6kl_htc_mbox_start(struct htc_target *target)
 {
 	struct htc_packet *packet;
 	int status;
@@ -2752,7 +2762,7 @@ int ath6kl_htc_start(struct htc_target *target)
 	status = ath6kl_hif_unmask_intrs(target->dev);
 
 	if (status)
-		ath6kl_htc_stop(target);
+		ath6kl_htc_mbox_stop(target);
 
 	return status;
 }
@@ -2796,7 +2806,7 @@ static int ath6kl_htc_reset(struct htc_target *target)
 }
 
 /* htc_stop: stop interrupt reception, and flush all queued buffers */
-void ath6kl_htc_stop(struct htc_target *target)
+static void ath6kl_htc_mbox_stop(struct htc_target *target)
 {
 	spin_lock_bh(&target->htc_lock);
 	target->htc_flags |= HTC_OP_STATE_STOPPING;
@@ -2811,12 +2821,12 @@ void ath6kl_htc_stop(struct htc_target *target)
 
 	ath6kl_htc_flush_txep_all(target);
 
-	ath6kl_htc_flush_rx_buf(target);
+	ath6kl_htc_mbox_flush_rx_buf(target);
 
 	ath6kl_htc_reset(target);
 }
 
-void *ath6kl_htc_create(struct ath6kl *ar)
+static void *ath6kl_htc_mbox_create(struct ath6kl *ar)
 {
 	struct htc_target *target = NULL;
 	int status = 0;
@@ -2857,13 +2867,13 @@ void *ath6kl_htc_create(struct ath6kl *ar)
 	return target;
 
 err_htc_cleanup:
-	ath6kl_htc_cleanup(target);
+	ath6kl_htc_mbox_cleanup(target);
 
 	return NULL;
 }
 
 /* cleanup the HTC instance */
-void ath6kl_htc_cleanup(struct htc_target *target)
+static void ath6kl_htc_mbox_cleanup(struct htc_target *target)
 {
 	struct htc_packet *packet, *tmp_packet;
 
@@ -2888,3 +2898,24 @@ void ath6kl_htc_cleanup(struct htc_target *target)
 	kfree(target->dev);
 	kfree(target);
 }
+
+static const struct ath6kl_htc_ops ath6kl_htc_mbox_ops = {
+	.create = ath6kl_htc_mbox_create,
+	.wait_target = ath6kl_htc_mbox_wait_target,
+	.start = ath6kl_htc_mbox_start,
+	.conn_service = ath6kl_htc_mbox_conn_service,
+	.tx = ath6kl_htc_mbox_tx,
+	.stop = ath6kl_htc_mbox_stop,
+	.cleanup = ath6kl_htc_mbox_cleanup,
+	.flush_txep = ath6kl_htc_mbox_flush_txep,
+	.flush_rx_buf = ath6kl_htc_mbox_flush_rx_buf,
+	.activity_changed = ath6kl_htc_mbox_activity_changed,
+	.get_rxbuf_num = ath6kl_htc_mbox_get_rxbuf_num,
+	.add_rxbuf_multiple = ath6kl_htc_mbox_add_rxbuf_multiple,
+	.credit_setup = ath6kl_htc_mbox_credit_setup,
+};
+
+void ath6kl_htc_mbox_attach(struct ath6kl *ar)
+{
+	ar->htc_ops = &ath6kl_htc_mbox_ops;
+}
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index d33691e..092e4cd 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -27,6 +27,7 @@
 #include "target.h"
 #include "debug.h"
 #include "hif-ops.h"
+#include "htc-ops.h"
 
 static const struct ath6kl_hw hw_list[] = {
 	{
@@ -1510,7 +1511,7 @@ int ath6kl_init_hw_start(struct ath6kl *ar)
 	}
 
 	/* setup credit distribution */
-	ath6kl_credit_setup(ar->htc_target, &ar->credit_state_info);
+	ath6kl_htc_credit_setup(ar->htc_target, &ar->credit_state_info);
 
 	/* start HTC */
 	ret = ath6kl_htc_start(ar->htc_target);
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 5352864..44ea7a7 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -1362,7 +1362,7 @@ static int ath6kl_sdio_probe(struct sdio_func *func,
 		goto err_core_alloc;
 	}
 
-	ret = ath6kl_core_init(ar);
+	ret = ath6kl_core_init(ar, ATH6KL_HTC_TYPE_MBOX);
 	if (ret) {
 		ath6kl_err("Failed to init ath6kl core\n");
 		goto err_core_alloc;
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 5559c9b..fdcc6ee 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -17,6 +17,7 @@
 
 #include "core.h"
 #include "debug.h"
+#include "htc-ops.h"
 
 /*
  * tid - tid_mux0..tid_mux3
@@ -572,7 +573,7 @@ void ath6kl_indicate_tx_activity(void *devt, u8 traffic_class, bool active)
 
 notify_htc:
 	/* notify HTC, this may cause credit distribution changes */
-	ath6kl_htc_indicate_activity_change(ar->htc_target, eid, active);
+	ath6kl_htc_activity_changed(ar->htc_target, eid, active);
 }
 
 enum htc_send_full_action ath6kl_tx_queue_full(struct htc_target *target,
diff --git a/drivers/net/wireless/ath/ath6kl/usb.c b/drivers/net/wireless/ath/ath6kl/usb.c
index 325b122..991fbc5 100644
--- a/drivers/net/wireless/ath/ath6kl/usb.c
+++ b/drivers/net/wireless/ath/ath6kl/usb.c
@@ -368,7 +368,7 @@ static int ath6kl_usb_probe(struct usb_interface *interface,
 
 	ar_usb->ar = ar;
 
-	ret = ath6kl_core_init(ar);
+	ret = ath6kl_core_init(ar, ATH6KL_HTC_TYPE_MBOX);
 	if (ret) {
 		ath6kl_err("Failed to init ath6kl core: %d\n", ret);
 		goto err_core_free;
-- 
1.7.1

