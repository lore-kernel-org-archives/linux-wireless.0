Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:7641 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbbGUFXS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2015 01:23:18 -0400
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH 1/2] ath10k: Fix memory alloc failure in qca99x0 during wmi svc rdy event
Date: Tue, 21 Jul 2015 10:52:57 +0530
Message-ID: <1437456178-7862-1-git-send-email-rmani@qti.qualcomm.com> (sfid-20150721_072321_355697_9E5E7800)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Host memory required for firmware is allocated while handling
wmi service ready event. Right now, wmi service ready is handled
in tasklet context and it calls dma_alloc_coherent() with atomic
flag (GFP_ATOMIC) to allocate memory in host needed for firmware.
The problem is, dma_alloc_coherent() with GFP_ATOMIC fails in
the platform (at least in AP platform) where it has less atomic
pool memory (< 2mb). QCA99X0 requires around 2 MB of host memory
for one card, having additional QCA99X0 card in the same platform
will require similarly amount of memory. So, it's not guaranteed that
all the platform will have enough atomic memory pool.

Fix this issue, by handling wmi service ready event in workqueue
context and calling dma_alloc_coherent() with GFP_KERNEL. mac80211 work
queue will not be ready at the time of handling wmi service ready.
So, it can't be used to handle wmi service ready. Also, register work
gets scheduled during insmod in existing ath10k_wq and waits for
wmi service ready to completed. Both workqueue can't be used for
this purpose. New auxiliary workqueue is added to handle wmi service
ready.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c    | 11 +++++++++-
 drivers/net/wireless/ath/ath10k/core.h    |  5 +++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  2 +-
 drivers/net/wireless/ath/ath10k/wmi.c     | 34 +++++++++++++++++++++++++------
 4 files changed, 44 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index f79fa6c..b037c34 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1606,6 +1606,10 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 	if (!ar->workqueue)
 		goto err_free_mac;
 
+	ar->workqueue_aux = create_singlethread_workqueue("ath10k_aux_wq");
+	if (!ar->workqueue_aux)
+		goto err_free_wq;
+
 	mutex_init(&ar->conf_mutex);
 	spin_lock_init(&ar->data_lock);
 
@@ -1626,10 +1630,12 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 
 	ret = ath10k_debug_create(ar);
 	if (ret)
-		goto err_free_wq;
+		goto err_free_aux_wq;
 
 	return ar;
 
+err_free_aux_wq:
+	destroy_workqueue(ar->workqueue_aux);
 err_free_wq:
 	destroy_workqueue(ar->workqueue);
 
@@ -1645,6 +1651,9 @@ void ath10k_core_destroy(struct ath10k *ar)
 	flush_workqueue(ar->workqueue);
 	destroy_workqueue(ar->workqueue);
 
+	flush_workqueue(ar->workqueue_aux);
+	destroy_workqueue(ar->workqueue_aux);
+
 	ath10k_debug_destroy(ar);
 	ath10k_mac_destroy(ar);
 }
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 78e0705..08b0972 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -673,6 +673,8 @@ struct ath10k {
 	struct completion vdev_setup_done;
 
 	struct workqueue_struct *workqueue;
+	/* Auxiliary workqueue */
+	struct workqueue_struct *workqueue_aux;
 
 	/* prevents concurrent FW reconfiguration */
 	struct mutex conf_mutex;
@@ -695,6 +697,9 @@ struct ath10k {
 	int num_active_peers;
 	int num_tids;
 
+	struct work_struct svc_rdy_work;
+	struct sk_buff *svc_rdy_skb;
+
 	struct work_struct offchan_tx_work;
 	struct sk_buff_head offchan_tx_queue;
 	struct completion offchan_tx_completed;
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 4189d4a..d9832dc 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -519,7 +519,7 @@ static void ath10k_wmi_tlv_op_rx(struct ath10k *ar, struct sk_buff *skb)
 		break;
 	case WMI_TLV_SERVICE_READY_EVENTID:
 		ath10k_wmi_event_service_ready(ar, skb);
-		break;
+		return;
 	case WMI_TLV_READY_EVENTID:
 		ath10k_wmi_event_ready(ar, skb);
 		break;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 0791a43..dc85355 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3789,7 +3789,7 @@ static int ath10k_wmi_alloc_host_mem(struct ath10k *ar, u32 req_id,
 	ar->wmi.mem_chunks[idx].vaddr = dma_alloc_coherent(ar->dev,
 							   pool_size,
 							   &paddr,
-							   GFP_ATOMIC);
+							   GFP_KERNEL);
 	if (!ar->wmi.mem_chunks[idx].vaddr) {
 		ath10k_warn(ar, "failed to allocate memory chunk\n");
 		return -ENOMEM;
@@ -3878,12 +3878,19 @@ ath10k_wmi_10x_op_pull_svc_rdy_ev(struct ath10k *ar, struct sk_buff *skb,
 	return 0;
 }
 
-void ath10k_wmi_event_service_ready(struct ath10k *ar, struct sk_buff *skb)
+void ath10k_wmi_event_service_ready_work(struct work_struct *work)
 {
+	struct ath10k *ar = container_of(work, struct ath10k, svc_rdy_work);
+	struct sk_buff *skb = ar->svc_rdy_skb;
 	struct wmi_svc_rdy_ev_arg arg = {};
 	u32 num_units, req_id, unit_size, num_mem_reqs, num_unit_info, i;
 	int ret;
 
+	if (!skb) {
+		ath10k_warn(ar, "invalid service ready event skb\n");
+		return;
+	}
+
 	ret = ath10k_wmi_pull_svc_rdy(ar, skb, &arg);
 	if (ret) {
 		ath10k_warn(ar, "failed to parse service ready: %d\n", ret);
@@ -4003,9 +4010,17 @@ void ath10k_wmi_event_service_ready(struct ath10k *ar, struct sk_buff *skb)
 		   __le32_to_cpu(arg.eeprom_rd),
 		   __le32_to_cpu(arg.num_mem_reqs));
 
+	dev_kfree_skb(skb);
+	ar->svc_rdy_skb = NULL;
 	complete(&ar->wmi.service_ready);
 }
 
+void ath10k_wmi_event_service_ready(struct ath10k *ar, struct sk_buff *skb)
+{
+	ar->svc_rdy_skb = skb;
+	queue_work(ar->workqueue_aux, &ar->svc_rdy_work);
+}
+
 static int ath10k_wmi_op_pull_rdy_ev(struct ath10k *ar, struct sk_buff *skb,
 				     struct wmi_rdy_ev_arg *arg)
 {
@@ -4177,7 +4192,7 @@ static void ath10k_wmi_op_rx(struct ath10k *ar, struct sk_buff *skb)
 		break;
 	case WMI_SERVICE_READY_EVENTID:
 		ath10k_wmi_event_service_ready(ar, skb);
-		break;
+		return;
 	case WMI_READY_EVENTID:
 		ath10k_wmi_event_ready(ar, skb);
 		break;
@@ -4298,7 +4313,7 @@ static void ath10k_wmi_10_1_op_rx(struct ath10k *ar, struct sk_buff *skb)
 		break;
 	case WMI_10X_SERVICE_READY_EVENTID:
 		ath10k_wmi_event_service_ready(ar, skb);
-		break;
+		return;
 	case WMI_10X_READY_EVENTID:
 		ath10k_wmi_event_ready(ar, skb);
 		break;
@@ -4409,7 +4424,7 @@ static void ath10k_wmi_10_2_op_rx(struct ath10k *ar, struct sk_buff *skb)
 		break;
 	case WMI_10_2_SERVICE_READY_EVENTID:
 		ath10k_wmi_event_service_ready(ar, skb);
-		break;
+		return;
 	case WMI_10_2_READY_EVENTID:
 		ath10k_wmi_event_ready(ar, skb);
 		break;
@@ -4461,7 +4476,7 @@ static void ath10k_wmi_10_4_op_rx(struct ath10k *ar, struct sk_buff *skb)
 		break;
 	case WMI_10_4_SERVICE_READY_EVENTID:
 		ath10k_wmi_event_service_ready(ar, skb);
-		break;
+		return;
 	case WMI_10_4_SCAN_EVENTID:
 		ath10k_wmi_event_scan(ar, skb);
 		break;
@@ -6514,6 +6529,8 @@ int ath10k_wmi_attach(struct ath10k *ar)
 	init_completion(&ar->wmi.service_ready);
 	init_completion(&ar->wmi.unified_ready);
 
+	INIT_WORK(&ar->svc_rdy_work, ath10k_wmi_event_service_ready_work);
+
 	return 0;
 }
 
@@ -6521,6 +6538,11 @@ void ath10k_wmi_detach(struct ath10k *ar)
 {
 	int i;
 
+	cancel_work_sync(&ar->svc_rdy_work);
+
+	if (ar->svc_rdy_skb)
+		dev_kfree_skb(ar->svc_rdy_skb);
+
 	/* free the host memory chunks requested by firmware */
 	for (i = 0; i < ar->wmi.num_mem_chunks; i++) {
 		dma_free_coherent(ar->dev,
-- 
1.8.1.2

