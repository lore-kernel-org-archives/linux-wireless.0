Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:50992 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057Ab3IZPrh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 11:47:37 -0400
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH v3 07/13] ath10k: implement host memory chunks
Date: Thu, 26 Sep 2013 17:47:11 +0200
Message-ID: <1380210437-4391-8-git-send-email-bartosz.markowski@tieto.com> (sfid-20130926_174741_592463_FC46D36B)
In-Reply-To: <1380210437-4391-1-git-send-email-bartosz.markowski@tieto.com>
References: <1380210437-4391-1-git-send-email-bartosz.markowski@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

10.X firmware can request a memory pool from host to offload
it's own resources. This is a feature designed especially
for AP mode where the target has to deal with large number
of peers.

So we allocate and map a consistent DMA memory which FW can
use to store e.g. peer rate contol maps.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h |   12 +++
 drivers/net/wireless/ath/ath10k/wmi.c  |  126 ++++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/wmi.h  |    3 +
 3 files changed, 133 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index acfee7c..e2a2658 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -102,12 +102,24 @@ struct ath10k_bmi {
 	bool done_sent;
 };
 
+#define ATH10K_MAX_MEM_REQS 16
+
+struct ath10k_mem_chunk {
+	void *vaddr;
+	dma_addr_t paddr;
+	u32 len;
+	u32 req_id;
+};
+
 struct ath10k_wmi {
 	enum ath10k_htc_ep_id eid;
 	struct completion service_ready;
 	struct completion unified_ready;
 	wait_queue_head_t tx_credits_wq;
 	struct wmi_cmd_map *cmd;
+
+	u32 num_mem_chunks;
+	struct ath10k_mem_chunk mem_chunks[ATH10K_MAX_MEM_REQS];
 };
 
 struct ath10k_peer_stat {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index ed79d32..97ba23e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1230,6 +1230,37 @@ static void ath10k_wmi_event_vdev_resume_req(struct ath10k *ar,
 	ath10k_dbg(ATH10K_DBG_WMI, "WMI_VDEV_RESUME_REQ_EVENTID\n");
 }
 
+static int ath10k_wmi_alloc_host_mem(struct ath10k *ar, u32 req_id,
+				      u32 num_units, u32 unit_len)
+{
+	dma_addr_t paddr;
+	u32 pool_size;
+	int idx = ar->wmi.num_mem_chunks;
+
+	pool_size = num_units * round_up(unit_len, 4);
+
+	if (!pool_size)
+		return -EINVAL;
+
+	ar->wmi.mem_chunks[idx].vaddr = dma_alloc_coherent(ar->dev,
+							   pool_size,
+							   &paddr,
+							   GFP_ATOMIC);
+	if (!ar->wmi.mem_chunks[idx].vaddr) {
+		ath10k_warn("failed to allocate memory chunk\n");
+		return -ENOMEM;
+	}
+
+	memset(ar->wmi.mem_chunks[idx].vaddr, 0, pool_size);
+
+	ar->wmi.mem_chunks[idx].paddr = paddr;
+	ar->wmi.mem_chunks[idx].len = pool_size;
+	ar->wmi.mem_chunks[idx].req_id = req_id;
+	ar->wmi.num_mem_chunks++;
+
+	return 0;
+}
+
 static void ath10k_wmi_service_ready_event_rx(struct ath10k *ar,
 					      struct sk_buff *skb)
 {
@@ -1304,6 +1335,8 @@ static void ath10k_wmi_service_ready_event_rx(struct ath10k *ar,
 static void ath10k_wmi_10x_service_ready_event_rx(struct ath10k *ar,
 						  struct sk_buff *skb)
 {
+	u32 num_units, req_id, unit_size, num_mem_reqs, num_unit_info, i;
+	int ret;
 	struct wmi_service_ready_event_10x *ev = (void *)skb->data;
 
 	if (skb->len < sizeof(*ev)) {
@@ -1342,13 +1375,50 @@ static void ath10k_wmi_10x_service_ready_event_rx(struct ath10k *ar,
 			 ar->fw_version_minor);
 	}
 
-	/* FIXME: it probably should be better to support this.
-	   TODO: Next patch introduce memory chunks. It's a must for 10.x FW */
-	if (__le32_to_cpu(ev->num_mem_reqs) > 0) {
-		ath10k_warn("target requested %d memory chunks; ignoring\n",
-			    __le32_to_cpu(ev->num_mem_reqs));
+	num_mem_reqs = __le32_to_cpu(ev->num_mem_reqs);
+
+	if (num_mem_reqs > ATH10K_MAX_MEM_REQS) {
+		ath10k_warn("requested memory chunks number (%d) exceeds the limit\n",
+			    num_mem_reqs);
+		return;
 	}
 
+	if (!num_mem_reqs)
+		goto exit;
+
+	ath10k_dbg(ATH10K_DBG_WMI, "firmware has requested %d memory chunks\n",
+		   num_mem_reqs);
+
+	for (i = 0; i < num_mem_reqs; ++i) {
+		req_id = __le32_to_cpu(ev->mem_reqs[i].req_id);
+		num_units = __le32_to_cpu(ev->mem_reqs[i].num_units);
+		unit_size = __le32_to_cpu(ev->mem_reqs[i].unit_size);
+		num_unit_info = __le32_to_cpu(ev->mem_reqs[i].num_unit_info);
+
+		if (num_unit_info & NUM_UNITS_IS_NUM_PEERS)
+			/* number of units to allocate is number of
+			 * peers, 1 extra for self peer on target */
+			/* this needs to be tied, host and target
+			 * can get out of sync */
+			num_units = TARGET_NUM_PEERS + 1;
+		else if (num_unit_info & NUM_UNITS_IS_NUM_VDEVS)
+			num_units = TARGET_NUM_VDEVS + 1;
+
+		ath10k_dbg(ATH10K_DBG_WMI,
+			   "wmi mem_req_id %d num_units %d num_unit_info %d unit size %d actual units %d\n",
+			   req_id,
+			   __le32_to_cpu(ev->mem_reqs[i].num_units),
+			   num_unit_info,
+			   unit_size,
+			   num_units);
+
+		ret = ath10k_wmi_alloc_host_mem(ar, req_id, num_units,
+						unit_size);
+		if (ret)
+			return;
+	}
+
+exit:
 	ath10k_dbg(ATH10K_DBG_WMI,
 		   "wmi event service ready sw_ver 0x%08x abi_ver %u phy_cap 0x%08x ht_cap 0x%08x vht_cap 0x%08x vht_supp_msc 0x%08x sys_cap_info 0x%08x mem_reqs %u num_rf_chains %u\n",
 		   __le32_to_cpu(ev->sw_version),
@@ -1645,6 +1715,17 @@ int ath10k_wmi_attach(struct ath10k *ar)
 
 void ath10k_wmi_detach(struct ath10k *ar)
 {
+	int i;
+
+	/* free the host memory chunks requested by firmware */
+	for (i = 0; i < ar->wmi.num_mem_chunks; i++) {
+		dma_free_coherent(ar->dev,
+				  ar->wmi.mem_chunks[i].len,
+				  ar->wmi.mem_chunks[i].vaddr,
+				  ar->wmi.mem_chunks[i].paddr);
+	}
+
+	ar->wmi.num_mem_chunks = 0;
 }
 
 int ath10k_wmi_connect_htc_service(struct ath10k *ar)
@@ -1781,7 +1862,8 @@ int ath10k_wmi_cmd_init(struct ath10k *ar)
 	struct wmi_init_cmd *cmd;
 	struct sk_buff *buf;
 	struct wmi_resource_config config = {};
-	u32 val;
+	u32 len, val;
+	int i;
 
 	config.num_vdevs = __cpu_to_le32(TARGET_NUM_VDEVS);
 	config.num_peers = __cpu_to_le32(TARGET_NUM_PEERS + TARGET_NUM_VDEVS);
@@ -1834,12 +1916,40 @@ int ath10k_wmi_cmd_init(struct ath10k *ar)
 	config.num_msdu_desc = __cpu_to_le32(TARGET_NUM_MSDU_DESC);
 	config.max_frag_entries = __cpu_to_le32(TARGET_MAX_FRAG_ENTRIES);
 
-	buf = ath10k_wmi_alloc_skb(sizeof(*cmd));
+	len = sizeof(*cmd) +
+	      (sizeof(struct host_memory_chunk) * ar->wmi.num_mem_chunks);
+
+	buf = ath10k_wmi_alloc_skb(len);
 	if (!buf)
 		return -ENOMEM;
 
 	cmd = (struct wmi_init_cmd *)buf->data;
-	cmd->num_host_mem_chunks = 0;
+
+	if (ar->wmi.num_mem_chunks == 0) {
+		cmd->num_host_mem_chunks = 0;
+		goto out;
+	}
+
+	ath10k_dbg(ATH10K_DBG_WMI, "wmi sending %d memory chunks info.\n",
+		   __cpu_to_le32(ar->wmi.num_mem_chunks));
+
+	cmd->num_host_mem_chunks = __cpu_to_le32(ar->wmi.num_mem_chunks);
+
+	for (i = 0; i < ar->wmi.num_mem_chunks; i++) {
+		cmd->host_mem_chunks[i].ptr =
+			__cpu_to_le32(ar->wmi.mem_chunks[i].paddr);
+		cmd->host_mem_chunks[i].size =
+			__cpu_to_le32(ar->wmi.mem_chunks[i].len);
+		cmd->host_mem_chunks[i].req_id =
+			__cpu_to_le32(ar->wmi.mem_chunks[i].req_id);
+
+		ath10k_dbg(ATH10K_DBG_WMI,
+			   "wmi chunk %d len %d requested, addr 0x%x\n",
+			   i,
+			   cmd->host_mem_chunks[i].size,
+			   cmd->host_mem_chunks[i].ptr);
+	}
+out:
 	memcpy(&cmd->resource_config, &config, sizeof(config));
 
 	ath10k_dbg(ATH10K_DBG_WMI, "wmi init\n");
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index a0cfdfd..56339d2 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -1377,6 +1377,9 @@ struct wmi_resource_config {
 	__le32 max_frag_entries;
 } __packed;
 
+#define NUM_UNITS_IS_NUM_VDEVS   0x1
+#define NUM_UNITS_IS_NUM_PEERS   0x2
+
 /* strucutre describing host memory chunk. */
 struct host_memory_chunk {
 	/* id of the request that is passed up in service ready */
-- 
1.7.10

