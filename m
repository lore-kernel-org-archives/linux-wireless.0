Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42523 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbbH1Lv6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2015 07:51:58 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH] ath10k: Fix DMA alloc failure for target requested memory chunks
Date: Fri, 28 Aug 2015 17:21:34 +0530
Message-ID: <1440762694-11578-1-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20150828_135202_419652_18213A7D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During long hours of stress testing like AP interface up/down along
with continuous ping flood from a station doing connect/disconnect,
it is observed that the system is not able to allocate DMA consistent
memory of size > 512KB chunks as requested by firmware in WMI_SERVICE_EVENTID.
With the system memory getting fragmented during the run based on the
size of the memory requested, the failure to return physically continguous
memory of high order can happen. Once the system gets to this situation,
bringing up the wifi interface will fail and a system reboot may be needed
to make it work again. This problem is obseved with QCA99X0.

To fix this issue, allocate the DMA memory requested by firmware during
device probe time and keep it during the life time of the device. WMI service
ready event handler is changed to allocate the memory chunks if it is
not already allocated or if the memory allocated for the previous ready
event is not same as the current requested ones. After this patch the
memory usage when wifi is inactive will be inceased by few 100KB to
3MB based on the target type.

Failure happens with the following stack trace

[29557.488773] kworker/u4:1: page allocation failure: order:8, mode:0xd0
[29557.494297] CPU: 0 PID: 8402 Comm: kworker/u4:1 Not tainted 3.14.43 #7
[29557.500793] Workqueue: ath10k_aux_wq ath10k_wmi_event_service_ready_work [ath10k_core]
[29557.508602] [<c021e9b0>] (unwind_backtrace) from [<c021ba90>] (show_stack+0x10/0x14)
[29557.516580] [<c021ba90>] (show_stack) from [<c03bdddc>] (dump_stack+0x88/0xcc)
[29557.523612] [<c03bdddc>] (dump_stack) from [<c0290e34>] (warn_alloc_failed+0xdc/0x108)
[29557.531515] [<c0290e34>] (warn_alloc_failed) from [<c0292d88>] (__alloc_pages_nodemask+0x4f0/0x654)
[29557.540485] [<c0292d88>] (__alloc_pages_nodemask) from [<c0222b48>] (__dma_alloc_buffer.isra.20+0x2c/0x104)
[29557.550260] [<c0222b48>] (__dma_alloc_buffer.isra.20) from [<c0222c34>] (__alloc_remap_buffer.isra.23+0x14/0xb8)
[29557.560413] [<c0222c34>] (__alloc_remap_buffer.isra.23) from [<c022305c>] (__dma_alloc+0x224/0x2b8)
[29557.569490] [<c022305c>] (__dma_alloc) from [<c0223208>] (arm_dma_alloc+0x84/0x90)
[29557.577010] [<c0223208>] (arm_dma_alloc) from [<bf5159d0>] (ath10k_wmi_event_service_ready_work+0x2f8/0x420 [ath10k_core])
[29557.588055] [<bf5159d0>] (ath10k_wmi_event_service_ready_work [ath10k_core]) from [<c024260c>] (process_one_work+0x20c/0x328)
[29557.599305] [<c024260c>] (process_one_work) from [<c02432d0>] (worker_thread+0x228/0x360)
[29557.607470] [<c02432d0>] (worker_thread) from [<c0247f88>] (kthread+0xd8/0xec)
[29557.614750] [<c0247f88>] (kthread) from [<c0208d18>] (ret_from_fork+0x14/0x3c)
[29557.712751] Normal: 696*4kB (UEMR) 512*8kB (UEMR) 367*16kB (UEMR) 404*32kB (UEMR) 455*64kB (UEMR) 424*128kB (UEMR) 379*256kB (UMR) 327*512kB (UMR) 1*1024kB (R) 0*2048kB 0*4096kB = 374544kB

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |  1 +
 drivers/net/wireless/ath/ath10k/wmi.c  | 76 +++++++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/wmi.h  |  1 +
 3 files changed, 72 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index b87b986..6e5aeed 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1714,6 +1714,7 @@ void ath10k_core_destroy(struct ath10k *ar)
 	destroy_workqueue(ar->workqueue_aux);
 
 	ath10k_debug_destroy(ar);
+	ath10k_wmi_free_host_mem(ar);
 	ath10k_mac_destroy(ar);
 }
 EXPORT_SYMBOL(ath10k_core_destroy);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index ce01107..87d9de2 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3917,6 +3917,53 @@ static int ath10k_wmi_alloc_host_mem(struct ath10k *ar, u32 req_id,
 	return 0;
 }
 
+static bool
+ath10k_wmi_is_host_mem_allocated(struct ath10k *ar,
+				 const struct wlan_host_mem_req **mem_reqs,
+				 u32 num_mem_reqs)
+{
+	u32 req_id, num_units, unit_size, num_unit_info;
+	u32 pool_size;
+	int i, j;
+	bool found;
+
+	if (ar->wmi.num_mem_chunks != num_mem_reqs)
+		return false;
+
+	for (i = 0; i < num_mem_reqs; ++i) {
+		req_id = __le32_to_cpu(mem_reqs[i]->req_id);
+		num_units = __le32_to_cpu(mem_reqs[i]->num_units);
+		unit_size = __le32_to_cpu(mem_reqs[i]->unit_size);
+		num_unit_info = __le32_to_cpu(mem_reqs[i]->num_unit_info);
+
+		if (num_unit_info & NUM_UNITS_IS_NUM_ACTIVE_PEERS) {
+			if (ar->num_active_peers)
+				num_units = ar->num_active_peers + 1;
+			else
+				num_units = ar->max_num_peers + 1;
+		} else if (num_unit_info & NUM_UNITS_IS_NUM_PEERS) {
+			num_units = ar->max_num_peers + 1;
+		} else if (num_unit_info & NUM_UNITS_IS_NUM_VDEVS) {
+			num_units = ar->max_num_vdevs + 1;
+		}
+
+		found = false;
+		for (j = 0; j < ar->wmi.num_mem_chunks; j++) {
+			if (ar->wmi.mem_chunks[j].req_id == req_id) {
+				pool_size = num_units * round_up(unit_size, 4);
+				if (ar->wmi.mem_chunks[j].len == pool_size) {
+					found = true;
+					break;
+				}
+			}
+		}
+		if (!found)
+			return false;
+	}
+
+	return true;
+}
+
 static int
 ath10k_wmi_main_op_pull_svc_rdy_ev(struct ath10k *ar, struct sk_buff *skb,
 				   struct wmi_svc_rdy_ev_arg *arg)
@@ -3997,6 +4044,7 @@ static void ath10k_wmi_event_service_ready_work(struct work_struct *work)
 	struct wmi_svc_rdy_ev_arg arg = {};
 	u32 num_units, req_id, unit_size, num_mem_reqs, num_unit_info, i;
 	int ret;
+	bool allocated;
 
 	if (!skb) {
 		ath10k_warn(ar, "invalid service ready event skb\n");
@@ -4073,6 +4121,18 @@ static void ath10k_wmi_event_service_ready_work(struct work_struct *work)
 	 * and WMI_SERVICE_IRAM_TIDS, etc.
 	 */
 
+	allocated = ath10k_wmi_is_host_mem_allocated(ar, arg.mem_reqs,
+						     num_mem_reqs);
+	if (allocated)
+		goto skip_mem_alloc;
+
+	/* Either this event is received during boot time or there is a change
+	 * in memory requirement from firmware when compared to last request.
+	 * Free any old memory and do a fresh allocation based on the current
+	 * memory requirement.
+	 */
+	ath10k_wmi_free_host_mem(ar);
+
 	for (i = 0; i < num_mem_reqs; ++i) {
 		req_id = __le32_to_cpu(arg.mem_reqs[i]->req_id);
 		num_units = __le32_to_cpu(arg.mem_reqs[i]->num_units);
@@ -4108,6 +4168,7 @@ static void ath10k_wmi_event_service_ready_work(struct work_struct *work)
 			return;
 	}
 
+skip_mem_alloc:
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi event service ready min_tx_power 0x%08x max_tx_power 0x%08x ht_cap 0x%08x vht_cap 0x%08x sw_ver0 0x%08x sw_ver1 0x%08x fw_build 0x%08x phy_capab 0x%08x num_rf_chains 0x%08x eeprom_rd 0x%08x num_mem_reqs 0x%08x\n",
 		   __le32_to_cpu(arg.min_tx_power),
@@ -6660,15 +6721,10 @@ int ath10k_wmi_attach(struct ath10k *ar)
 	return 0;
 }
 
-void ath10k_wmi_detach(struct ath10k *ar)
+void ath10k_wmi_free_host_mem(struct ath10k *ar)
 {
 	int i;
 
-	cancel_work_sync(&ar->svc_rdy_work);
-
-	if (ar->svc_rdy_skb)
-		dev_kfree_skb(ar->svc_rdy_skb);
-
 	/* free the host memory chunks requested by firmware */
 	for (i = 0; i < ar->wmi.num_mem_chunks; i++) {
 		dma_free_coherent(ar->dev,
@@ -6679,3 +6735,11 @@ void ath10k_wmi_detach(struct ath10k *ar)
 
 	ar->wmi.num_mem_chunks = 0;
 }
+
+void ath10k_wmi_detach(struct ath10k *ar)
+{
+	cancel_work_sync(&ar->svc_rdy_work);
+
+	if (ar->svc_rdy_skb)
+		dev_kfree_skb(ar->svc_rdy_skb);
+}
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 52d3503..3e5a159 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -6067,6 +6067,7 @@ struct ath10k_fw_stats_peer;
 
 int ath10k_wmi_attach(struct ath10k *ar);
 void ath10k_wmi_detach(struct ath10k *ar);
+void ath10k_wmi_free_host_mem(struct ath10k *ar);
 int ath10k_wmi_wait_for_service_ready(struct ath10k *ar);
 int ath10k_wmi_wait_for_unified_ready(struct ath10k *ar);
 
-- 
1.9.1

