Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:62155 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464Ab3IRJri (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Sep 2013 05:47:38 -0400
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH] ath10k: implement host memory chunks feature
Date: Wed, 18 Sep 2013 11:47:31 +0200
Message-ID: <1379497651-29933-1-git-send-email-bartosz.markowski@tieto.com> (sfid-20130918_114751_041867_9825CCE1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware can request a memory pool from host to offload
it's own resources. This is a feature designed especially
for AP mode where the target has to deal with large number
of peers.

So we allocate and map a consistent DMA memory which FW can
use to store e.g. peer rate contol maps.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h |   12 +++
 drivers/net/wireless/ath/ath10k/hif.h  |   23 ++++++
 drivers/net/wireless/ath/ath10k/pci.c  |   45 +++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c  |  129 ++++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/wmi.h  |   12 ++-
 5 files changed, 209 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index fcf94ee..c194f61 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -278,6 +278,15 @@ enum ath10k_fw_features {
 	ATH10K_FW_FEATURE_COUNT,
 };
 
+#define MAX_MEM_CHUNKS 32
+
+struct ath10k_mem_chunk {
+	void *vaddr;
+	dma_addr_t paddr;
+	u32 len;
+	u32 req_id;
+};
+
 struct ath10k {
 	struct ath_common ath_common;
 	struct ieee80211_hw *hw;
@@ -297,6 +306,9 @@ struct ath10k {
 	u32 vht_cap_info;
 	u32 num_rf_chains;
 
+	u32 num_mem_chunks;
+	struct ath10k_mem_chunk mem_chunks[MAX_MEM_CHUNKS];
+
 	DECLARE_BITMAP(fw_features, ATH10K_FW_FEATURE_COUNT);
 
 	struct targetdef *targetdef;
diff --git a/drivers/net/wireless/ath/ath10k/hif.h b/drivers/net/wireless/ath/ath10k/hif.h
index dcdea68..4af6a66 100644
--- a/drivers/net/wireless/ath/ath10k/hif.h
+++ b/drivers/net/wireless/ath/ath10k/hif.h
@@ -83,6 +83,12 @@ struct ath10k_hif_ops {
 
 	int (*suspend)(struct ath10k *ar);
 	int (*resume)(struct ath10k *ar);
+
+	/* Allocate/Free the host memory for firmware use */
+	int (*chunk_alloc)(struct ath10k *ar, u32 req_id, u32 index,
+			   u32 num_units, u32 unit_len);
+
+	void (*chunk_free)(struct ath10k *ar, int idx);
 };
 
 
@@ -173,4 +179,21 @@ static inline int ath10k_hif_resume(struct ath10k *ar)
 	return ar->hif.ops->resume(ar);
 }
 
+static inline int ath10k_hif_chunk_alloc(struct ath10k *ar,
+					 u32 req_id,
+					 u32 idx,
+					 u32 num_units,
+					 u32 unit_len)
+{
+	if (!ar->hif.ops->chunk_alloc)
+		return -EOPNOTSUPP;
+
+	return ar->hif.ops->chunk_alloc(ar, req_id, idx, num_units, unit_len);
+}
+
+static inline void ath10k_hif_chunk_free(struct ath10k *ar, int idx)
+{
+	ar->hif.ops->chunk_free(ar, idx);
+}
+
 #endif /* _HIF_H_ */
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index f1faf46..547d67d 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1966,6 +1966,49 @@ static int ath10k_pci_hif_resume(struct ath10k *ar)
 }
 #endif
 
+static int ath10k_pci_hif_chunk_alloc(struct ath10k *ar,
+				      u32 req_id,
+				      u32 idx,
+				      u32 num_units,
+				      u32 unit_len)
+{
+	dma_addr_t paddr;
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+
+	if (!num_units  || !unit_len)
+		return 0;
+
+	/*
+	 * TODO: allocate a chunk of memory at the index indicated and
+	 * if allocation fail allocate smallest size possible and
+	 * return number of units allocated.
+	 */
+	ar->mem_chunks[idx].vaddr = pci_alloc_consistent(ar_pci->pdev,
+							 num_units * unit_len,
+							 &paddr);
+	if(!ar->mem_chunks[idx].vaddr)
+		return 0;
+
+	memset(ar->mem_chunks[idx].vaddr, 0, num_units * unit_len);
+
+	ar->mem_chunks[idx].paddr = paddr;
+	ar->mem_chunks[idx].len = num_units * unit_len;
+	ar->mem_chunks[idx].req_id = req_id;
+
+	return num_units;
+
+}
+
+static void ath10k_pci_hif_chunk_free(struct ath10k *ar, int idx)
+{
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+
+	pci_free_consistent(ar_pci->pdev,
+			    ar->mem_chunks[idx].len,
+			    ar->mem_chunks[idx].vaddr,
+			    ar->mem_chunks[idx].paddr);
+}
+
 static const struct ath10k_hif_ops ath10k_pci_hif_ops = {
 	.send_head		= ath10k_pci_hif_send_head,
 	.exchange_bmi_msg	= ath10k_pci_hif_exchange_bmi_msg,
@@ -1982,6 +2025,8 @@ static const struct ath10k_hif_ops ath10k_pci_hif_ops = {
 	.suspend		= ath10k_pci_hif_suspend,
 	.resume			= ath10k_pci_hif_resume,
 #endif
+	.chunk_alloc		= ath10k_pci_hif_chunk_alloc,
+	.chunk_free		= ath10k_pci_hif_chunk_free,
 };
 
 static void ath10k_pci_ce_tasklet(unsigned long ptr)
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 6803ead..89de893 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -22,6 +22,7 @@
 #include "debug.h"
 #include "wmi.h"
 #include "mac.h"
+#include "hif.h"
 
 int ath10k_wmi_wait_for_service_ready(struct ath10k *ar)
 {
@@ -964,6 +965,46 @@ static void ath10k_wmi_event_vdev_install_key_complete(struct ath10k *ar,
 	ath10k_dbg(ATH10K_DBG_WMI, "WMI_VDEV_INSTALL_KEY_COMPLETE_EVENTID\n");
 }
 
+#define HOST_MEM_SIZE_UNIT 4
+
+static void ath10k_wmi_alloc_host_mem(struct ath10k *ar, u32 req_id,
+				      u32 num_units, u32 unit_len)
+{
+	u32 remaining_units, allocated_units, idx;
+
+	/* adjust the length to nearest multiple of unit size */
+	unit_len = (unit_len + (HOST_MEM_SIZE_UNIT - 1)) &
+		   (~(HOST_MEM_SIZE_UNIT - 1));
+
+	idx = ar->num_mem_chunks;
+	remaining_units = num_units;
+	while (remaining_units) {
+		allocated_units = ath10k_hif_chunk_alloc(ar, req_id, idx,
+							 remaining_units,
+							 unit_len);
+		if (allocated_units == 0) {
+			ath10k_warn("Memory allocation has failed (unit len %d units requested %d units allocated %d)\n",
+				    unit_len, num_units,
+				    (num_units - remaining_units));
+			ar->num_mem_chunks = idx;
+			break;
+		}
+
+		remaining_units -= allocated_units;
+		++idx;
+		if (idx == MAX_MEM_CHUNKS ) {
+			ath10k_warn("Maximum chunk limit has been reached (for memory units %d unit len %d requested by FW, allocated only %d\n",
+				    num_units,unit_len,
+				    (num_units - remaining_units));
+			ar->num_mem_chunks = idx;
+			break;
+		}
+	}
+	ar->num_mem_chunks = idx;
+
+}
+
+
 static void ath10k_wmi_service_ready_event_rx(struct ath10k *ar,
 					      struct sk_buff *skb)
 {
@@ -1013,12 +1054,44 @@ static void ath10k_wmi_service_ready_event_rx(struct ath10k *ar,
 			 ar->fw_version_build);
 	}
 
-	/* FIXME: it probably should be better to support this */
-	if (__le32_to_cpu(ev->num_mem_reqs) > 0) {
-		ath10k_warn("target requested %d memory chunks; ignoring\n",
+	WARN_ON(__le32_to_cpu(ev->num_mem_reqs) > WMI_MAX_MEM_REQS);
+
+	if (__le32_to_cpu(ev->num_mem_reqs)) {
+		u32 num_units, i;
+
+		ath10k_warn("target requested %d memory chunks\n",
 			    __le32_to_cpu(ev->num_mem_reqs));
+
+		for (i = 0; i < __le32_to_cpu(ev->num_mem_reqs); ++i) {
+			num_units = __le32_to_cpu(ev->mem_reqs[i].num_units);
+			if (__le32_to_cpu(ev->mem_reqs[i].n_unit_info)) {
+				if (__le32_to_cpu(ev->mem_reqs[i].n_unit_info)
+				    & NUM_UNITS_IS_NUM_PEERS) {
+					/* number of units to allocate is
+					 * number of peers, 1 extra for self
+					 * peer on target
+					 * this needs to be tied, host and
+					 * target can get out of sync */
+					num_units = TARGET_NUM_PEERS + 1;
+				}
+			}
+
+			ath10k_dbg(ATH10K_DBG_WMI, "i %d req %d  num_units %d n_unit_info %d unit size %d actual units %d \n",
+				   i,
+				   __le32_to_cpu(ev->mem_reqs[i].req_id),
+				   __le32_to_cpu(ev->mem_reqs[i].num_units),
+				   __le32_to_cpu(ev->mem_reqs[i].n_unit_info),
+				   __le32_to_cpu(ev->mem_reqs[i].unit_size),
+				   num_units);
+
+			ath10k_wmi_alloc_host_mem(ar,
+				__le32_to_cpu(ev->mem_reqs[i].req_id),
+				num_units,
+				__le32_to_cpu(ev->mem_reqs[i].unit_size));
+		}
 	}
 
+
 	ath10k_dbg(ATH10K_DBG_WMI,
 		   "wmi event service ready sw_ver 0x%08x sw_ver1 0x%08x abi_ver %u phy_cap 0x%08x ht_cap 0x%08x vht_cap 0x%08x vht_supp_msc 0x%08x sys_cap_info 0x%08x mem_reqs %u num_rf_chains %u\n",
 		   __le32_to_cpu(ev->sw_version),
@@ -1186,6 +1259,18 @@ int ath10k_wmi_attach(struct ath10k *ar)
 
 void ath10k_wmi_detach(struct ath10k *ar)
 {
+	int i;
+
+	for (i = 0;  i < ar->num_mem_chunks; i++) {
+		ath10k_dbg(ATH10K_DBG_WMI, "free chunk %d len %d vaddr 0x%p paddr 0x%08llx\n",
+			   ar->num_mem_chunks,
+			   ar->mem_chunks[i].len,
+			   ar->mem_chunks[i].vaddr,
+			   ar->mem_chunks[i].paddr);
+
+		ar->hif.ops->chunk_free(ar, i);
+	}
+	ar->num_mem_chunks = 0;
 }
 
 int ath10k_wmi_connect_htc_service(struct ath10k *ar)
@@ -1373,12 +1458,40 @@ int ath10k_wmi_cmd_init(struct ath10k *ar)
 	config.num_msdu_desc = __cpu_to_le32(TARGET_NUM_MSDU_DESC);
 	config.max_frag_entries = __cpu_to_le32(TARGET_MAX_FRAG_ENTRIES);
 
-	buf = ath10k_wmi_alloc_skb(sizeof(*cmd));
-	if (!buf)
-		return -ENOMEM;
+	if (ar->num_mem_chunks) {
+		int i;
+
+		buf = ath10k_wmi_alloc_skb(sizeof(*cmd) +
+			(sizeof(struct host_memory_chunk) * MAX_MEM_CHUNKS));
+		if (!buf)
+			return -ENOMEM;
+
+		cmd = (struct wmi_init_cmd *)buf->data;
+
+		ath10k_dbg(ATH10K_DBG_WMI, "Sending memory chunks info.\n");
+		cmd->num_host_mem_chunks = __cpu_to_le32(ar->num_mem_chunks);
+
+		for (i = 0; i < ar->num_mem_chunks; i++) {
+			cmd->host_mem_chunks[i].ptr =
+				__cpu_to_le32(ar->mem_chunks[i].paddr);
+			cmd->host_mem_chunks[i].size =
+				__cpu_to_le32(ar->mem_chunks[i].len);
+			cmd->host_mem_chunks[i].req_id =
+				__cpu_to_le32(ar->mem_chunks[i].req_id);
+
+			ath10k_dbg(ATH10K_DBG_WMI, "chunk %d len %d requested, addr 0x%x\n",
+				   i,
+				   cmd->host_mem_chunks[i].size,
+				   cmd->host_mem_chunks[i].ptr);
+		}
+	} else {
+		buf = ath10k_wmi_alloc_skb(sizeof(*cmd));
+		if (!buf)
+			return -ENOMEM;
+		cmd = (struct wmi_init_cmd *)buf->data;
+		cmd->num_host_mem_chunks = 0;
+	}
 
-	cmd = (struct wmi_init_cmd *)buf->data;
-	cmd->num_host_mem_chunks = 0;
 	memcpy(&cmd->resource_config, &config, sizeof(config));
 
 	ath10k_dbg(ATH10K_DBG_WMI, "wmi init\n");
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 2c52c23..f586fb6 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -744,13 +744,12 @@ struct wlan_host_mem_req {
 	__le32 req_id;
 	/* size of the  of each unit */
 	__le32 unit_size;
-	/* flags to  indicate that
-	 * the number units is dependent
+	/* flags to  indicate that the number units is dependent
 	 * on number of resources(num vdevs num peers .. etc)
 	 */
-	__le32 num_unit_info;
+	__le32 n_unit_info;
 	/*
-	 * actual number of units to allocate . if flags in the num_unit_info
+	 * actual number of units to allocate . if flags in the n_unit_info
 	 * indicate that number of units is tied to number of a particular
 	 * resource to allocate then  num_units filed is set to 0 and host
 	 * will derive the number units from number of the resources it is
@@ -1012,6 +1011,11 @@ struct wmi_resource_config {
 	__le32 max_frag_entries;
 } __packed;
 
+#define WMI_MAX_MEM_REQS 16
+
+#define NUM_UNITS_IS_NUM_VDEVS   0x1
+#define NUM_UNITS_IS_NUM_PEERS   0x2
+
 /* strucutre describing host memory chunk. */
 struct host_memory_chunk {
 	/* id of the request that is passed up in service ready */
-- 
1.7.10

