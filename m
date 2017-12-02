Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:35460 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751684AbdLBLba (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Dec 2017 06:31:30 -0500
From: Rakesh Pillai <pillair@qti.qualcomm.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@qti.qualcomm.com>,
        Govind Singh <govinds@qti.qualcomm.com>
Subject: [PATCH v2 1/4] ath10k: WMI: modify svc bitmap parsing for wcn3990
Date: Sat,  2 Dec 2017 17:00:45 +0530
Message-Id: <1512214248-17127-2-git-send-email-pillair@qti.qualcomm.com> (sfid-20171202_123137_376834_B14AE23F)
In-Reply-To: <1512214248-17127-1-git-send-email-pillair@qti.qualcomm.com>
References: <1512214248-17127-1-git-send-email-pillair@qti.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Due to the limitation of wmi tlv parsing logic, if there are
two parameters in a wmi event with same tlv tag, we can get only
the last value, as it overwrites the prev value of the same tlv tag.

The service ready event in wcn3990 contains two parameters of the
same tag UINT32, due to which the svc bitmap is overwritten with the
DBS support parameter.

Refactor the service ready event parsing to allow parsing two tlv
of the same tag UINT32 for wcn3990.

Signed-off-by: Rakesh Pillai <pillair@qti.qualcomm.com>
Signed-off-by: Govind Singh <govinds@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c     |  4 ++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 58 ++++++++++++++++++++++++-------
 drivers/net/wireless/ath/ath10k/wmi-tlv.h | 46 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     |  1 +
 4 files changed, 96 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 0a947ee..b86b9c8 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3574,7 +3574,9 @@ static int ath10k_mac_tx_wmi_mgmt(struct ath10k *ar, struct sk_buff *skb)
 		return ATH10K_MAC_TX_HTT;
 	case ATH10K_HW_TXRX_MGMT:
 		if (test_bit(ATH10K_FW_FEATURE_HAS_WMI_MGMT_TX,
-			     ar->running_fw->fw_file.fw_features))
+			     ar->running_fw->fw_file.fw_features) ||
+			     test_bit(WMI_SERVICE_MGMT_TX_WMI,
+				      ar->wmi.svc_map))
 			return ATH10K_MAC_TX_WMI_MGMT;
 		else if (ar->htt.target_version_major >= 3)
 			return ATH10K_MAC_TX_HTT;
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 7616c1c..35bcae4 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -917,31 +917,68 @@ static int ath10k_wmi_tlv_op_pull_phyerr_ev_hdr(struct ath10k *ar,
 	return -ENOMEM;
 }
 
+struct wmi_tlv_svc_rdy_parse {
+	const struct hal_reg_capabilities *reg;
+	const struct wmi_tlv_svc_rdy_ev *ev;
+	const __le32 *svc_bmap;
+	const struct wlan_host_mem_req *mem_reqs;
+	bool svc_bmap_done;
+	bool dbs_hw_mode_done;
+};
+
+static int ath10k_wmi_tlv_svc_rdy_parse(struct ath10k *ar, u16 tag, u16 len,
+					const void *ptr, void *data)
+{
+	struct wmi_tlv_svc_rdy_parse *svc_rdy = data;
+
+	switch (tag) {
+	case WMI_TLV_TAG_STRUCT_SERVICE_READY_EVENT:
+		svc_rdy->ev = ptr;
+		break;
+	case WMI_TLV_TAG_STRUCT_HAL_REG_CAPABILITIES:
+		svc_rdy->reg = ptr;
+		break;
+	case WMI_TLV_TAG_ARRAY_STRUCT:
+		svc_rdy->mem_reqs = ptr;
+		break;
+	case WMI_TLV_TAG_ARRAY_UINT32:
+		if (!svc_rdy->svc_bmap_done) {
+			svc_rdy->svc_bmap_done = true;
+			svc_rdy->svc_bmap = ptr;
+		} else if (!svc_rdy->dbs_hw_mode_done) {
+			svc_rdy->dbs_hw_mode_done = true;
+		}
+		break;
+	default:
+		break;
+	}
+	return 0;
+}
+
 static int ath10k_wmi_tlv_op_pull_svc_rdy_ev(struct ath10k *ar,
 					     struct sk_buff *skb,
 					     struct wmi_svc_rdy_ev_arg *arg)
 {
-	const void **tb;
 	const struct hal_reg_capabilities *reg;
 	const struct wmi_tlv_svc_rdy_ev *ev;
 	const __le32 *svc_bmap;
 	const struct wlan_host_mem_req *mem_reqs;
+	struct wmi_tlv_svc_rdy_parse svc_rdy = { };
 	int ret;
 
-	tb = ath10k_wmi_tlv_parse_alloc(ar, skb->data, skb->len, GFP_ATOMIC);
-	if (IS_ERR(tb)) {
-		ret = PTR_ERR(tb);
+	ret = ath10k_wmi_tlv_iter(ar, skb->data, skb->len,
+				  ath10k_wmi_tlv_svc_rdy_parse, &svc_rdy);
+	if (ret) {
 		ath10k_warn(ar, "failed to parse tlv: %d\n", ret);
 		return ret;
 	}
 
-	ev = tb[WMI_TLV_TAG_STRUCT_SERVICE_READY_EVENT];
-	reg = tb[WMI_TLV_TAG_STRUCT_HAL_REG_CAPABILITIES];
-	svc_bmap = tb[WMI_TLV_TAG_ARRAY_UINT32];
-	mem_reqs = tb[WMI_TLV_TAG_ARRAY_STRUCT];
+	ev = svc_rdy.ev;
+	reg = svc_rdy.reg;
+	svc_bmap = svc_rdy.svc_bmap;
+	mem_reqs = svc_rdy.mem_reqs;
 
 	if (!ev || !reg || !svc_bmap || !mem_reqs) {
-		kfree(tb);
 		return -EPROTO;
 	}
 
@@ -961,7 +998,6 @@ static int ath10k_wmi_tlv_op_pull_svc_rdy_ev(struct ath10k *ar,
 	    __le32_to_cpu(ev->abi.abi_ver_ns1) != WMI_TLV_ABI_VER_NS1 ||
 	    __le32_to_cpu(ev->abi.abi_ver_ns2) != WMI_TLV_ABI_VER_NS2 ||
 	    __le32_to_cpu(ev->abi.abi_ver_ns3) != WMI_TLV_ABI_VER_NS3) {
-		kfree(tb);
 		return -ENOTSUPP;
 	}
 
@@ -982,12 +1018,10 @@ static int ath10k_wmi_tlv_op_pull_svc_rdy_ev(struct ath10k *ar,
 	ret = ath10k_wmi_tlv_iter(ar, mem_reqs, ath10k_wmi_tlv_len(mem_reqs),
 				  ath10k_wmi_tlv_parse_mem_reqs, arg);
 	if (ret) {
-		kfree(tb);
 		ath10k_warn(ar, "failed to parse mem_reqs tlv: %d\n", ret);
 		return ret;
 	}
 
-	kfree(tb);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index 22cf011..77327a2 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -965,6 +965,50 @@ enum wmi_tlv_service {
 	WMI_TLV_SERVICE_STA_RX_IPA_OFFLOAD_SUPPORT,
 	WMI_TLV_SERVICE_MDNS_OFFLOAD,
 	WMI_TLV_SERVICE_SAP_AUTH_OFFLOAD,
+	WMI_TLV_SERVICE_DUAL_BAND_SIMULTANEOUS_SUPPORT,
+	WMI_TLV_SERVICE_OCB,
+	WMI_TLV_SERVICE_AP_ARPNS_OFFLOAD,
+	WMI_TLV_SERVICE_PER_BAND_CHAINMASK_SUPPORT,
+	WMI_TLV_SERVICE_PACKET_FILTER_OFFLOAD,
+	WMI_TLV_SERVICE_MGMT_TX_HTT,
+	WMI_TLV_SERVICE_MGMT_TX_WMI,
+	WMI_TLV_SERVICE_EXT_MSG,
+	WMI_TLV_SERVICE_MAWC,
+	WMI_TLV_SERVICE_PEER_ASSOC_CONF,
+	WMI_TLV_SERVICE_EGAP,
+	WMI_TLV_SERVICE_STA_PMF_OFFLOAD,
+	WMI_TLV_SERVICE_UNIFIED_WOW_CAPABILITY,
+	WMI_TLV_SERVICE_ENHANCED_PROXY_STA,
+	WMI_TLV_SERVICE_ATF,
+	WMI_TLV_SERVICE_COEX_GPIO,
+	WMI_TLV_SERVICE_AUX_SPECTRAL_INTF,
+	WMI_TLV_SERVICE_AUX_CHAN_LOAD_INTF,
+	WMI_TLV_SERVICE_BSS_CHANNEL_INFO_64,
+	WMI_TLV_SERVICE_ENTERPRISE_MESH,
+	WMI_TLV_SERVICE_RESTRT_CHNL_SUPPORT,
+	WMI_TLV_SERVICE_BPF_OFFLOAD,
+	WMI_TLV_SERVICE_SYNC_DELETE_CMDS,
+	WMI_TLV_SERVICE_SMART_ANTENNA_SW_SUPPORT,
+	WMI_TLV_SERVICE_SMART_ANTENNA_HW_SUPPORT,
+	WMI_TLV_SERVICE_RATECTRL_LIMIT_MAX_MIN_RATES,
+	WMI_TLV_SERVICE_NAN_DATA,
+	WMI_TLV_SERVICE_NAN_RTT,
+	WMI_TLV_SERVICE_11AX,
+	WMI_TLV_SERVICE_DEPRECATED_REPLACE,
+	WMI_TLV_SERVICE_TDLS_CONN_TRACKER_IN_HOST_MODE,
+	WMI_TLV_SERVICE_ENHANCED_MCAST_FILTER,
+	WMI_TLV_SERVICE_PERIODIC_CHAN_STAT_SUPPORT,
+	WMI_TLV_SERVICE_MESH_11S,
+	WMI_TLV_SERVICE_HALF_RATE_QUARTER_RATE_SUPPORT,
+	WMI_TLV_SERVICE_VDEV_RX_FILTER,
+	WMI_TLV_SERVICE_P2P_LISTEN_OFFLOAD_SUPPORT,
+	WMI_TLV_SERVICE_MARK_FIRST_WAKEUP_PACKET,
+	WMI_TLV_SERVICE_MULTIPLE_MCAST_FILTER_SET,
+	WMI_TLV_SERVICE_HOST_MANAGED_RX_REORDER,
+	WMI_TLV_SERVICE_FLASH_RDWR_SUPPORT,
+	WMI_TLV_SERVICE_WLAN_STATS_REPORT,
+	WMI_TLV_SERVICE_TX_MSDU_ID_NEW_PARTITION_SUPPORT,
+	WMI_TLV_SERVICE_DFS_PHYERR_OFFLOAD,
 };
 
 #define WMI_SERVICE_IS_ENABLED(wmi_svc_bmap, svc_id, len) \
@@ -1121,6 +1165,8 @@ enum wmi_tlv_service {
 	       WMI_SERVICE_MDNS_OFFLOAD, len);
 	SVCMAP(WMI_TLV_SERVICE_SAP_AUTH_OFFLOAD,
 	       WMI_SERVICE_SAP_AUTH_OFFLOAD, len);
+	SVCMAP(WMI_TLV_SERVICE_MGMT_TX_WMI,
+	       WMI_SERVICE_MGMT_TX_WMI, len);
 }
 
 #undef SVCMAP
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index c02b21c..6c11b36 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -195,6 +195,7 @@ enum wmi_service {
 	WMI_SERVICE_SMART_LOGGING_SUPPORT,
 	WMI_SERVICE_TDLS_CONN_TRACKER_IN_HOST_MODE,
 	WMI_SERVICE_TDLS_EXPLICIT_MODE_ONLY,
+	WMI_SERVICE_MGMT_TX_WMI,
 
 	/* keep last */
 	WMI_SERVICE_MAX,
-- 
1.9.1
