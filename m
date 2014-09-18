Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:39685 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552AbaIRNcO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2014 09:32:14 -0400
Received: by mail-wi0-f176.google.com with SMTP id ex7so3118227wid.3
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2014 06:32:13 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 6/9] ath10k: deduplicate wmi service ready logic
Date: Thu, 18 Sep 2014 15:21:24 +0200
Message-Id: <1411046487-19544-7-git-send-email-michal.kazior@tieto.com> (sfid-20140918_153221_142728_C0A526E5)
In-Reply-To: <1411046487-19544-1-git-send-email-michal.kazior@tieto.com>
References: <1411046487-19544-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The logic responsible for processing the event is
no different across different firmware binaries.
The difference that needs to be dealt with is the
ABI of data structures.

The intermediate structure uses __le32 to avoid
extra memory allocations to byteswap
variable-length substructures (i.e. host mem
chunks).

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h  |   4 +-
 drivers/net/wireless/ath/ath10k/debug.c |   2 +-
 drivers/net/wireless/ath/ath10k/debug.h |   4 +-
 drivers/net/wireless/ath/ath10k/wmi.c   | 237 ++++++++++++++++----------------
 drivers/net/wireless/ath/ath10k/wmi.h   |  24 +++-
 5 files changed, 142 insertions(+), 129 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index fe531ea..a4ef3c6 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -96,8 +96,6 @@ struct ath10k_bmi {
 	bool done_sent;
 };
 
-#define ATH10K_MAX_MEM_REQS 16
-
 struct ath10k_mem_chunk {
 	void *vaddr;
 	dma_addr_t paddr;
@@ -115,7 +113,7 @@ struct ath10k_wmi {
 	struct wmi_pdev_param_map *pdev_param;
 
 	u32 num_mem_chunks;
-	struct ath10k_mem_chunk mem_chunks[ATH10K_MAX_MEM_REQS];
+	struct ath10k_mem_chunk mem_chunks[WMI_MAX_MEM_REQS];
 };
 
 struct ath10k_peer_stat {
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 3756feb..101c6f9 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -182,7 +182,7 @@ EXPORT_SYMBOL(ath10k_warn);
 #ifdef CONFIG_ATH10K_DEBUGFS
 
 void ath10k_debug_read_service_map(struct ath10k *ar,
-				   void *service_map,
+				   const void *service_map,
 				   size_t map_size)
 {
 	memcpy(ar->debug.wmi_service_bitmap, service_map, map_size);
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index b3774f7..d6276fe 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -53,7 +53,7 @@ void ath10k_debug_destroy(struct ath10k *ar);
 int ath10k_debug_register(struct ath10k *ar);
 void ath10k_debug_unregister(struct ath10k *ar);
 void ath10k_debug_read_service_map(struct ath10k *ar,
-				   void *service_map,
+				   const void *service_map,
 				   size_t map_size);
 void ath10k_debug_read_target_stats(struct ath10k *ar,
 				    struct wmi_stats_event *ev);
@@ -93,7 +93,7 @@ static inline void ath10k_debug_unregister(struct ath10k *ar)
 }
 
 static inline void ath10k_debug_read_service_map(struct ath10k *ar,
-						 void *service_map,
+						 const void *service_map,
 						 size_t map_size)
 {
 }
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 029a127..eab6b70 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2197,30 +2197,113 @@ static int ath10k_wmi_alloc_host_mem(struct ath10k *ar, u32 req_id,
 	return 0;
 }
 
+static int ath10k_wmi_pull_svc_rdy_ev(struct sk_buff *skb,
+				      struct wmi_svc_rdy_ev_arg *arg)
+{
+	struct wmi_service_ready_event *ev;
+	size_t i, n;
+
+	if (skb->len < sizeof(*ev))
+		return -EPROTO;
+
+	ev = (void *)skb->data;
+	skb_pull(skb, sizeof(*ev));
+	arg->min_tx_power = ev->hw_min_tx_power;
+	arg->max_tx_power = ev->hw_max_tx_power;
+	arg->ht_cap = ev->ht_cap_info;
+	arg->vht_cap = ev->vht_cap_info;
+	arg->sw_ver0 = ev->sw_version;
+	arg->sw_ver1 = ev->sw_version_1;
+	arg->phy_capab = ev->phy_capability;
+	arg->num_rf_chains = ev->num_rf_chains;
+	arg->eeprom_rd = ev->hal_reg_capabilities.eeprom_rd;
+	arg->num_mem_reqs = ev->num_mem_reqs;
+	arg->service_map = ev->wmi_service_bitmap;
+
+	n = min_t(size_t, __le32_to_cpu(arg->num_mem_reqs),
+		  ARRAY_SIZE(arg->mem_reqs));
+	for (i = 0; i < n; i++)
+		arg->mem_reqs[i] = &ev->mem_reqs[i];
+
+	if (skb->len <
+	    __le32_to_cpu(arg->num_mem_reqs) * sizeof(arg->mem_reqs[0]))
+		return -EPROTO;
+
+	return 0;
+}
+
+static int ath10k_wmi_10x_pull_svc_rdy_ev(struct sk_buff *skb,
+					  struct wmi_svc_rdy_ev_arg *arg)
+{
+	struct wmi_10x_service_ready_event *ev;
+	int i, n;
+
+	if (skb->len < sizeof(*ev))
+		return -EPROTO;
+
+	ev = (void *)skb->data;
+	skb_pull(skb, sizeof(*ev));
+	arg->min_tx_power = ev->hw_min_tx_power;
+	arg->max_tx_power = ev->hw_max_tx_power;
+	arg->ht_cap = ev->ht_cap_info;
+	arg->vht_cap = ev->vht_cap_info;
+	arg->sw_ver0 = ev->sw_version;
+	arg->phy_capab = ev->phy_capability;
+	arg->num_rf_chains = ev->num_rf_chains;
+	arg->eeprom_rd = ev->hal_reg_capabilities.eeprom_rd;
+	arg->num_mem_reqs = ev->num_mem_reqs;
+	arg->service_map = ev->wmi_service_bitmap;
+
+	n = min_t(size_t, __le32_to_cpu(arg->num_mem_reqs),
+		  ARRAY_SIZE(arg->mem_reqs));
+	for (i = 0; i < n; i++)
+		arg->mem_reqs[i] = &ev->mem_reqs[i];
+
+	if (skb->len <
+	    __le32_to_cpu(arg->num_mem_reqs) * sizeof(arg->mem_reqs[0]))
+		return -EPROTO;
+
+	return 0;
+}
+
 static void ath10k_wmi_service_ready_event_rx(struct ath10k *ar,
 					      struct sk_buff *skb)
 {
-	struct wmi_service_ready_event *ev = (void *)skb->data;
+	struct wmi_svc_rdy_ev_arg arg = {};
+	u32 num_units, req_id, unit_size, num_mem_reqs, num_unit_info, i;
 	DECLARE_BITMAP(svc_bmap, WMI_SERVICE_MAX) = {};
+	int ret;
 
-	if (skb->len < sizeof(*ev)) {
-		ath10k_warn(ar, "Service ready event was %d B but expected %zu B. Wrong firmware version?\n",
-			    skb->len, sizeof(*ev));
+	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
+		ret = ath10k_wmi_10x_pull_svc_rdy_ev(skb, &arg);
+		wmi_10x_svc_map(arg.service_map, svc_bmap);
+	} else {
+		ret = ath10k_wmi_pull_svc_rdy_ev(skb, &arg);
+		wmi_main_svc_map(arg.service_map, svc_bmap);
+	}
+
+	if (ret) {
+		ath10k_warn(ar, "failed to parse service ready: %d\n", ret);
 		return;
 	}
 
-	ar->hw_min_tx_power = __le32_to_cpu(ev->hw_min_tx_power);
-	ar->hw_max_tx_power = __le32_to_cpu(ev->hw_max_tx_power);
-	ar->ht_cap_info = __le32_to_cpu(ev->ht_cap_info);
-	ar->vht_cap_info = __le32_to_cpu(ev->vht_cap_info);
+	ar->hw_min_tx_power = __le32_to_cpu(arg.min_tx_power);
+	ar->hw_max_tx_power = __le32_to_cpu(arg.max_tx_power);
+	ar->ht_cap_info = __le32_to_cpu(arg.ht_cap);
+	ar->vht_cap_info = __le32_to_cpu(arg.vht_cap);
 	ar->fw_version_major =
-		(__le32_to_cpu(ev->sw_version) & 0xff000000) >> 24;
-	ar->fw_version_minor = (__le32_to_cpu(ev->sw_version) & 0x00ffffff);
+		(__le32_to_cpu(arg.sw_ver0) & 0xff000000) >> 24;
+	ar->fw_version_minor = (__le32_to_cpu(arg.sw_ver0) & 0x00ffffff);
 	ar->fw_version_release =
-		(__le32_to_cpu(ev->sw_version_1) & 0xffff0000) >> 16;
-	ar->fw_version_build = (__le32_to_cpu(ev->sw_version_1) & 0x0000ffff);
-	ar->phy_capability = __le32_to_cpu(ev->phy_capability);
-	ar->num_rf_chains = __le32_to_cpu(ev->num_rf_chains);
+		(__le32_to_cpu(arg.sw_ver1) & 0xffff0000) >> 16;
+	ar->fw_version_build = (__le32_to_cpu(arg.sw_ver1) & 0x0000ffff);
+	ar->phy_capability = __le32_to_cpu(arg.phy_capab);
+	ar->num_rf_chains = __le32_to_cpu(arg.num_rf_chains);
+	ar->ath_common.regulatory.current_rd = __le32_to_cpu(arg.eeprom_rd);
+
+	ath10k_debug_read_service_map(ar, svc_bmap, sizeof(svc_bmap));
+	ath10k_dbg_dump(ar, ATH10K_DBG_WMI, NULL, "wmi svc: ",
+			arg.service_map, sizeof(arg.service_map));
 
 	/* only manually set fw features when not using FW IE format */
 	if (ar->fw_api == 1 && ar->fw_version_build > 636)
@@ -2235,14 +2318,6 @@ static void ath10k_wmi_service_ready_event_rx(struct ath10k *ar,
 	ar->supp_tx_chainmask = (1 << ar->num_rf_chains) - 1;
 	ar->supp_rx_chainmask = (1 << ar->num_rf_chains) - 1;
 
-	ar->ath_common.regulatory.current_rd =
-		__le32_to_cpu(ev->hal_reg_capabilities.eeprom_rd);
-
-	wmi_main_svc_map(ev->wmi_service_bitmap, svc_bmap);
-	ath10k_debug_read_service_map(ar, svc_bmap, sizeof(svc_bmap));
-	ath10k_dbg_dump(ar, ATH10K_DBG_WMI, NULL, "wmi svc: ",
-			ev->wmi_service_bitmap, sizeof(ev->wmi_service_bitmap));
-
 	if (strlen(ar->hw->wiphy->fw_version) == 0) {
 		snprintf(ar->hw->wiphy->fw_version,
 			 sizeof(ar->hw->wiphy->fw_version),
@@ -2253,96 +2328,18 @@ static void ath10k_wmi_service_ready_event_rx(struct ath10k *ar,
 			 ar->fw_version_build);
 	}
 
-	/* FIXME: it probably should be better to support this */
-	if (__le32_to_cpu(ev->num_mem_reqs) > 0) {
-		ath10k_warn(ar, "target requested %d memory chunks; ignoring\n",
-			    __le32_to_cpu(ev->num_mem_reqs));
-	}
-
-	ath10k_dbg(ar, ATH10K_DBG_WMI,
-		   "wmi event service ready sw_ver 0x%08x sw_ver1 0x%08x abi_ver %u phy_cap 0x%08x ht_cap 0x%08x vht_cap 0x%08x vht_supp_msc 0x%08x sys_cap_info 0x%08x mem_reqs %u num_rf_chains %u\n",
-		   __le32_to_cpu(ev->sw_version),
-		   __le32_to_cpu(ev->sw_version_1),
-		   __le32_to_cpu(ev->abi_version),
-		   __le32_to_cpu(ev->phy_capability),
-		   __le32_to_cpu(ev->ht_cap_info),
-		   __le32_to_cpu(ev->vht_cap_info),
-		   __le32_to_cpu(ev->vht_supp_mcs),
-		   __le32_to_cpu(ev->sys_cap_info),
-		   __le32_to_cpu(ev->num_mem_reqs),
-		   __le32_to_cpu(ev->num_rf_chains));
-
-	complete(&ar->wmi.service_ready);
-}
-
-static void ath10k_wmi_10x_service_ready_event_rx(struct ath10k *ar,
-						  struct sk_buff *skb)
-{
-	u32 num_units, req_id, unit_size, num_mem_reqs, num_unit_info, i;
-	int ret;
-	struct wmi_service_ready_event_10x *ev = (void *)skb->data;
-	DECLARE_BITMAP(svc_bmap, WMI_SERVICE_MAX) = {};
-
-	if (skb->len < sizeof(*ev)) {
-		ath10k_warn(ar, "Service ready event was %d B but expected %zu B. Wrong firmware version?\n",
-			    skb->len, sizeof(*ev));
-		return;
-	}
-
-	ar->hw_min_tx_power = __le32_to_cpu(ev->hw_min_tx_power);
-	ar->hw_max_tx_power = __le32_to_cpu(ev->hw_max_tx_power);
-	ar->ht_cap_info = __le32_to_cpu(ev->ht_cap_info);
-	ar->vht_cap_info = __le32_to_cpu(ev->vht_cap_info);
-	ar->fw_version_major =
-		(__le32_to_cpu(ev->sw_version) & 0xff000000) >> 24;
-	ar->fw_version_minor = (__le32_to_cpu(ev->sw_version) & 0x00ffffff);
-	ar->phy_capability = __le32_to_cpu(ev->phy_capability);
-	ar->num_rf_chains = __le32_to_cpu(ev->num_rf_chains);
-
-	if (ar->num_rf_chains > WMI_MAX_SPATIAL_STREAM) {
-		ath10k_warn(ar, "hardware advertises support for more spatial streams than it should (%d > %d)\n",
-			    ar->num_rf_chains, WMI_MAX_SPATIAL_STREAM);
-		ar->num_rf_chains = WMI_MAX_SPATIAL_STREAM;
-	}
-
-	ar->supp_tx_chainmask = (1 << ar->num_rf_chains) - 1;
-	ar->supp_rx_chainmask = (1 << ar->num_rf_chains) - 1;
-
-	ar->ath_common.regulatory.current_rd =
-		__le32_to_cpu(ev->hal_reg_capabilities.eeprom_rd);
-
-	wmi_10x_svc_map(ev->wmi_service_bitmap, svc_bmap);
-	ath10k_debug_read_service_map(ar, svc_bmap, sizeof(svc_bmap));
-	ath10k_dbg_dump(ar, ATH10K_DBG_WMI, NULL, "wmi svc: ",
-			ev->wmi_service_bitmap, sizeof(ev->wmi_service_bitmap));
-
-	if (strlen(ar->hw->wiphy->fw_version) == 0) {
-		snprintf(ar->hw->wiphy->fw_version,
-			 sizeof(ar->hw->wiphy->fw_version),
-			 "%u.%u",
-			 ar->fw_version_major,
-			 ar->fw_version_minor);
-	}
-
-	num_mem_reqs = __le32_to_cpu(ev->num_mem_reqs);
-
-	if (num_mem_reqs > ATH10K_MAX_MEM_REQS) {
+	num_mem_reqs = __le32_to_cpu(arg.num_mem_reqs);
+	if (num_mem_reqs > WMI_MAX_MEM_REQS) {
 		ath10k_warn(ar, "requested memory chunks number (%d) exceeds the limit\n",
 			    num_mem_reqs);
 		return;
 	}
 
-	if (!num_mem_reqs)
-		goto exit;
-
-	ath10k_dbg(ar, ATH10K_DBG_WMI, "firmware has requested %d memory chunks\n",
-		   num_mem_reqs);
-
 	for (i = 0; i < num_mem_reqs; ++i) {
-		req_id = __le32_to_cpu(ev->mem_reqs[i].req_id);
-		num_units = __le32_to_cpu(ev->mem_reqs[i].num_units);
-		unit_size = __le32_to_cpu(ev->mem_reqs[i].unit_size);
-		num_unit_info = __le32_to_cpu(ev->mem_reqs[i].num_unit_info);
+		req_id = __le32_to_cpu(arg.mem_reqs[i]->req_id);
+		num_units = __le32_to_cpu(arg.mem_reqs[i]->num_units);
+		unit_size = __le32_to_cpu(arg.mem_reqs[i]->unit_size);
+		num_unit_info = __le32_to_cpu(arg.mem_reqs[i]->num_unit_info);
 
 		if (num_unit_info & NUM_UNITS_IS_NUM_PEERS)
 			/* number of units to allocate is number of
@@ -2356,7 +2353,7 @@ static void ath10k_wmi_10x_service_ready_event_rx(struct ath10k *ar,
 		ath10k_dbg(ar, ATH10K_DBG_WMI,
 			   "wmi mem_req_id %d num_units %d num_unit_info %d unit size %d actual units %d\n",
 			   req_id,
-			   __le32_to_cpu(ev->mem_reqs[i].num_units),
+			   __le32_to_cpu(arg.mem_reqs[i]->num_units),
 			   num_unit_info,
 			   unit_size,
 			   num_units);
@@ -2367,18 +2364,18 @@ static void ath10k_wmi_10x_service_ready_event_rx(struct ath10k *ar,
 			return;
 	}
 
-exit:
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
-		   "wmi event service ready sw_ver 0x%08x abi_ver %u phy_cap 0x%08x ht_cap 0x%08x vht_cap 0x%08x vht_supp_msc 0x%08x sys_cap_info 0x%08x mem_reqs %u num_rf_chains %u\n",
-		   __le32_to_cpu(ev->sw_version),
-		   __le32_to_cpu(ev->abi_version),
-		   __le32_to_cpu(ev->phy_capability),
-		   __le32_to_cpu(ev->ht_cap_info),
-		   __le32_to_cpu(ev->vht_cap_info),
-		   __le32_to_cpu(ev->vht_supp_mcs),
-		   __le32_to_cpu(ev->sys_cap_info),
-		   __le32_to_cpu(ev->num_mem_reqs),
-		   __le32_to_cpu(ev->num_rf_chains));
+		   "wmi event service ready min_tx_power 0x%08x max_tx_power 0x%08x ht_cap 0x%08x vht_cap 0x%08x sw_ver0 0x%08x sw_ver1 0x%08x phy_capab 0x%08x num_rf_chains 0x%08x eeprom_rd 0x%08x num_mem_reqs 0x%08x\n",
+		   __le32_to_cpu(arg.min_tx_power),
+		   __le32_to_cpu(arg.max_tx_power),
+		   __le32_to_cpu(arg.ht_cap),
+		   __le32_to_cpu(arg.vht_cap),
+		   __le32_to_cpu(arg.sw_ver0),
+		   __le32_to_cpu(arg.sw_ver1),
+		   __le32_to_cpu(arg.phy_capab),
+		   __le32_to_cpu(arg.num_rf_chains),
+		   __le32_to_cpu(arg.eeprom_rd),
+		   __le32_to_cpu(arg.num_mem_reqs));
 
 	complete(&ar->wmi.service_ready);
 }
@@ -2626,7 +2623,7 @@ static void ath10k_wmi_10x_process_rx(struct ath10k *ar, struct sk_buff *skb)
 		ath10k_wmi_event_vdev_resume_req(ar, skb);
 		break;
 	case WMI_10X_SERVICE_READY_EVENTID:
-		ath10k_wmi_10x_service_ready_event_rx(ar, skb);
+		ath10k_wmi_service_ready_event_rx(ar, skb);
 		break;
 	case WMI_10X_READY_EVENTID:
 		ath10k_wmi_ready_event_rx(ar, skb);
@@ -2737,7 +2734,7 @@ static void ath10k_wmi_10_2_process_rx(struct ath10k *ar, struct sk_buff *skb)
 		ath10k_wmi_event_vdev_resume_req(ar, skb);
 		break;
 	case WMI_10_2_SERVICE_READY_EVENTID:
-		ath10k_wmi_10x_service_ready_event_rx(ar, skb);
+		ath10k_wmi_service_ready_event_rx(ar, skb);
 		break;
 	case WMI_10_2_READY_EVENTID:
 		ath10k_wmi_ready_event_rx(ar, skb);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index fc8bc9d..ebdf154 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -1394,6 +1394,7 @@ struct wlan_host_mem_req {
  * wmi_service_ready_event,e.g., 11ac pass some of the
  * device capability to the host.
  */
+
 struct wmi_service_ready_event {
 	__le32 sw_version;
 	__le32 sw_version_1;
@@ -1428,11 +1429,11 @@ struct wmi_service_ready_event {
 	 * where FW can access this memory directly (or) by DMA.
 	 */
 	__le32 num_mem_reqs;
-	struct wlan_host_mem_req mem_reqs[1];
+	struct wlan_host_mem_req mem_reqs[0];
 } __packed;
 
 /* This is the definition from 10.X firmware branch */
-struct wmi_service_ready_event_10x {
+struct wmi_10x_service_ready_event {
 	__le32 sw_version;
 	__le32 abi_version;
 
@@ -1467,7 +1468,7 @@ struct wmi_service_ready_event_10x {
 	 */
 	__le32 num_mem_reqs;
 
-	struct wlan_host_mem_req mem_reqs[1];
+	struct wlan_host_mem_req mem_reqs[0];
 } __packed;
 
 #define WMI_SERVICE_READY_TIMEOUT_HZ (5*HZ)
@@ -4702,6 +4703,23 @@ struct wmi_dbglog_cfg_cmd {
 /* By default disable power save for IBSS */
 #define ATH10K_DEFAULT_ATIM 0
 
+#define WMI_MAX_MEM_REQS 16
+
+struct wmi_svc_rdy_ev_arg {
+	__le32 min_tx_power;
+	__le32 max_tx_power;
+	__le32 ht_cap;
+	__le32 vht_cap;
+	__le32 sw_ver0;
+	__le32 sw_ver1;
+	__le32 phy_capab;
+	__le32 num_rf_chains;
+	__le32 eeprom_rd;
+	__le32 num_mem_reqs;
+	const __le32 *service_map;
+	const struct wlan_host_mem_req *mem_reqs[WMI_MAX_MEM_REQS];
+};
+
 struct ath10k;
 struct ath10k_vif;
 
-- 
1.8.5.3

