Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19212 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbcA1V5O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 16:57:14 -0500
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 4/4] ath10k: add abstraction layer for vdev subtype
Date: Thu, 28 Jan 2016 13:54:10 -0800
Message-ID: <059c6e483dd566a43c0d8a018731e967e66d237f.1454015989.git.poh@qca.qualcomm.com> (sfid-20160128_225720_275788_40FA69C9)
In-Reply-To: <cover.1454015989.git.poh@qca.qualcomm.com>
References: <cover.1454015989.git.poh@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Abstraction layer for vdev subtype is added to solve
subtype mismatch and to give flexible compatibility
among different firmware revisions.

For instance, 10.2 and 10.4 firmware has different
definition of their vdev subtypes for Mesh.
10.4 defined subtype 6 for 802.11s Mesh while 10.2 uses 5.
Hence use the abstraction API to get right subtype to use.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c     | 15 ++++---
 drivers/net/wireless/ath/ath10k/wmi-ops.h | 11 +++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  1 +
 drivers/net/wireless/ath/ath10k/wmi.c     | 70 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     | 42 ++++++++++++++++---
 5 files changed, 128 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index addf3cb..96e2f8a 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4359,25 +4359,29 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 		   bit, ar->free_vdev_map);
 
 	arvif->vdev_id = bit;
-	arvif->vdev_subtype = WMI_VDEV_SUBTYPE_NONE;
+	arvif->vdev_subtype =
+		ath10k_wmi_get_vdev_subtype(ar, WMI_VDEV_SUBTYPE_NONE);
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_P2P_DEVICE:
 		arvif->vdev_type = WMI_VDEV_TYPE_STA;
-		arvif->vdev_subtype = WMI_VDEV_SUBTYPE_P2P_DEVICE;
+		arvif->vdev_subtype = ath10k_wmi_get_vdev_subtype
+					(ar, WMI_VDEV_SUBTYPE_P2P_DEVICE);
 		break;
 	case NL80211_IFTYPE_UNSPECIFIED:
 	case NL80211_IFTYPE_STATION:
 		arvif->vdev_type = WMI_VDEV_TYPE_STA;
 		if (vif->p2p)
-			arvif->vdev_subtype = WMI_VDEV_SUBTYPE_P2P_CLIENT;
+			arvif->vdev_subtype = ath10k_wmi_get_vdev_subtype
+					(ar, WMI_VDEV_SUBTYPE_P2P_CLIENT);
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		arvif->vdev_type = WMI_VDEV_TYPE_IBSS;
 		break;
 	case NL80211_IFTYPE_MESH_POINT:
 		if (test_bit(WMI_SERVICE_MESH_11S, ar->wmi.svc_map)) {
-			arvif->vdev_subtype = WMI_VDEV_SUBTYPE_MESH_11S;
+			arvif->vdev_subtype = ath10k_wmi_get_vdev_subtype
+						(ar, WMI_VDEV_SUBTYPE_MESH_11S);
 		} else if (!test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags)) {
 			ret = -EINVAL;
 			ath10k_warn(ar, "must load driver with rawmode=1 to add mesh interfaces\n");
@@ -4389,7 +4393,8 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 		arvif->vdev_type = WMI_VDEV_TYPE_AP;
 
 		if (vif->p2p)
-			arvif->vdev_subtype = WMI_VDEV_SUBTYPE_P2P_GO;
+			arvif->vdev_subtype = ath10k_wmi_get_vdev_subtype
+						(ar, WMI_VDEV_SUBTYPE_P2P_GO);
 		break;
 	case NL80211_IFTYPE_MONITOR:
 		arvif->vdev_type = WMI_VDEV_TYPE_MONITOR;
diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 8f4f6a8..32ab34e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -186,6 +186,8 @@ struct wmi_ops {
 							u8 enable,
 							u32 detect_level,
 							u32 detect_margin);
+	int (*get_vdev_subtype)(struct ath10k *ar,
+				enum wmi_vdev_subtype subtype);
 };
 
 int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
@@ -1327,4 +1329,13 @@ ath10k_wmi_pdev_enable_adaptive_cca(struct ath10k *ar, u8 enable,
 				   ar->wmi.cmd->pdev_enable_adaptive_cca_cmdid);
 }
 
+static inline int
+ath10k_wmi_get_vdev_subtype(struct ath10k *ar, enum wmi_vdev_subtype subtype)
+{
+	if (!ar->wmi.ops->get_vdev_subtype)
+		return -EOPNOTSUPP;
+
+	return ar->wmi.ops->get_vdev_subtype(ar, subtype);
+}
+
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 3b3a27b..1085932 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -3483,6 +3483,7 @@ static const struct wmi_ops wmi_tlv_ops = {
 	.gen_tdls_peer_update = ath10k_wmi_tlv_op_gen_tdls_peer_update,
 	.gen_adaptive_qcs = ath10k_wmi_tlv_op_gen_adaptive_qcs,
 	.fw_stats_fill = ath10k_wmi_main_op_fw_stats_fill,
+	.get_vdev_subtype = ath10k_wmi_op_get_vdev_subtype,
 };
 
 static const struct wmi_peer_flags_map wmi_tlv_peer_flags_map = {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 5158716..04799c7 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -7413,6 +7413,71 @@ unlock:
 		buf[len] = 0;
 }
 
+int ath10k_wmi_op_get_vdev_subtype(struct ath10k *ar,
+				   enum wmi_vdev_subtype subtype)
+{
+	switch (subtype) {
+	case WMI_VDEV_SUBTYPE_NONE:
+		return WMI_VDEV_SUBTYPE_LEGACY_NONE;
+	case WMI_VDEV_SUBTYPE_P2P_DEVICE:
+		return WMI_VDEV_SUBTYPE_LEGACY_P2P_DEV;
+	case WMI_VDEV_SUBTYPE_P2P_CLIENT:
+		return WMI_VDEV_SUBTYPE_LEGACY_P2P_CLI;
+	case WMI_VDEV_SUBTYPE_P2P_GO:
+		return WMI_VDEV_SUBTYPE_LEGACY_P2P_GO;
+	case WMI_VDEV_SUBTYPE_PROXY_STA:
+		return WMI_VDEV_SUBTYPE_LEGACY_PROXY_STA;
+	case WMI_VDEV_SUBTYPE_MESH_11S:
+	case WMI_VDEV_SUBTYPE_MESH_NON_11S:
+		return -ENOTSUPP;
+	}
+	return -ENOTSUPP;
+}
+
+static int ath10k_wmi_10_2_4_op_get_vdev_subtype(struct ath10k *ar,
+						 enum wmi_vdev_subtype subtype)
+{
+	switch (subtype) {
+	case WMI_VDEV_SUBTYPE_NONE:
+		return WMI_VDEV_SUBTYPE_10_2_4_NONE;
+	case WMI_VDEV_SUBTYPE_P2P_DEVICE:
+		return WMI_VDEV_SUBTYPE_10_2_4_P2P_DEV;
+	case WMI_VDEV_SUBTYPE_P2P_CLIENT:
+		return WMI_VDEV_SUBTYPE_10_2_4_P2P_CLI;
+	case WMI_VDEV_SUBTYPE_P2P_GO:
+		return WMI_VDEV_SUBTYPE_10_2_4_P2P_GO;
+	case WMI_VDEV_SUBTYPE_PROXY_STA:
+		return WMI_VDEV_SUBTYPE_10_2_4_PROXY_STA;
+	case WMI_VDEV_SUBTYPE_MESH_11S:
+		return WMI_VDEV_SUBTYPE_10_2_4_MESH_11S;
+	case WMI_VDEV_SUBTYPE_MESH_NON_11S:
+		return -ENOTSUPP;
+	}
+	return -ENOTSUPP;
+}
+
+static int ath10k_wmi_10_4_op_get_vdev_subtype(struct ath10k *ar,
+					       enum wmi_vdev_subtype subtype)
+{
+	switch (subtype) {
+	case WMI_VDEV_SUBTYPE_NONE:
+		return WMI_VDEV_SUBTYPE_10_4_NONE;
+	case WMI_VDEV_SUBTYPE_P2P_DEVICE:
+		return WMI_VDEV_SUBTYPE_10_4_P2P_DEV;
+	case WMI_VDEV_SUBTYPE_P2P_CLIENT:
+		return WMI_VDEV_SUBTYPE_10_4_P2P_CLI;
+	case WMI_VDEV_SUBTYPE_P2P_GO:
+		return WMI_VDEV_SUBTYPE_10_4_P2P_GO;
+	case WMI_VDEV_SUBTYPE_PROXY_STA:
+		return WMI_VDEV_SUBTYPE_10_4_PROXY_STA;
+	case WMI_VDEV_SUBTYPE_MESH_11S:
+		return WMI_VDEV_SUBTYPE_10_4_MESH_11S;
+	case WMI_VDEV_SUBTYPE_MESH_NON_11S:
+		return WMI_VDEV_SUBTYPE_10_4_MESH_NON_11S;
+	}
+	return -ENOTSUPP;
+}
+
 static const struct wmi_ops wmi_ops = {
 	.rx = ath10k_wmi_op_rx,
 	.map_svc = wmi_main_svc_map,
@@ -7472,6 +7537,7 @@ static const struct wmi_ops wmi_ops = {
 	.gen_addba_set_resp = ath10k_wmi_op_gen_addba_set_resp,
 	.gen_delba_send = ath10k_wmi_op_gen_delba_send,
 	.fw_stats_fill = ath10k_wmi_main_op_fw_stats_fill,
+	.get_vdev_subtype = ath10k_wmi_op_get_vdev_subtype,
 	/* .gen_bcn_tmpl not implemented */
 	/* .gen_prb_tmpl not implemented */
 	/* .gen_p2p_go_bcn_ie not implemented */
@@ -7539,6 +7605,7 @@ static const struct wmi_ops wmi_10_1_ops = {
 	.gen_addba_set_resp = ath10k_wmi_op_gen_addba_set_resp,
 	.gen_delba_send = ath10k_wmi_op_gen_delba_send,
 	.fw_stats_fill = ath10k_wmi_10x_op_fw_stats_fill,
+	.get_vdev_subtype = ath10k_wmi_op_get_vdev_subtype,
 	/* .gen_bcn_tmpl not implemented */
 	/* .gen_prb_tmpl not implemented */
 	/* .gen_p2p_go_bcn_ie not implemented */
@@ -7607,6 +7674,7 @@ static const struct wmi_ops wmi_10_2_ops = {
 	.gen_addba_set_resp = ath10k_wmi_op_gen_addba_set_resp,
 	.gen_delba_send = ath10k_wmi_op_gen_delba_send,
 	.fw_stats_fill = ath10k_wmi_10x_op_fw_stats_fill,
+	.get_vdev_subtype = ath10k_wmi_op_get_vdev_subtype,
 	/* .gen_pdev_enable_adaptive_cca not implemented */
 };
 
@@ -7673,6 +7741,7 @@ static const struct wmi_ops wmi_10_2_4_ops = {
 	.fw_stats_fill = ath10k_wmi_10x_op_fw_stats_fill,
 	.gen_pdev_enable_adaptive_cca =
 		ath10k_wmi_op_gen_pdev_enable_adaptive_cca,
+	.get_vdev_subtype = ath10k_wmi_10_2_4_op_get_vdev_subtype,
 	/* .gen_bcn_tmpl not implemented */
 	/* .gen_prb_tmpl not implemented */
 	/* .gen_p2p_go_bcn_ie not implemented */
@@ -7739,6 +7808,7 @@ static const struct wmi_ops wmi_10_4_ops = {
 	/* shared with 10.2 */
 	.gen_request_stats = ath10k_wmi_op_gen_request_stats,
 	.gen_pdev_get_temperature = ath10k_wmi_10_2_op_gen_pdev_get_temperature,
+	.get_vdev_subtype = ath10k_wmi_10_4_op_get_vdev_subtype,
 };
 
 int ath10k_wmi_attach(struct ath10k *ar)
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 031018a..049c618 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4295,12 +4295,40 @@ enum wmi_vdev_type {
 };
 
 enum wmi_vdev_subtype {
-	WMI_VDEV_SUBTYPE_NONE       = 0,
-	WMI_VDEV_SUBTYPE_P2P_DEVICE = 1,
-	WMI_VDEV_SUBTYPE_P2P_CLIENT = 2,
-	WMI_VDEV_SUBTYPE_P2P_GO     = 3,
-	WMI_VDEV_SUBTYPE_PROXY_STA	= 4,
-	WMI_VDEV_SUBTYPE_MESH_11S   = 5,
+	WMI_VDEV_SUBTYPE_NONE,
+	WMI_VDEV_SUBTYPE_P2P_DEVICE,
+	WMI_VDEV_SUBTYPE_P2P_CLIENT,
+	WMI_VDEV_SUBTYPE_P2P_GO,
+	WMI_VDEV_SUBTYPE_PROXY_STA,
+	WMI_VDEV_SUBTYPE_MESH_11S,
+	WMI_VDEV_SUBTYPE_MESH_NON_11S,
+};
+
+enum wmi_vdev_subtype_legacy {
+	WMI_VDEV_SUBTYPE_LEGACY_NONE      = 0,
+	WMI_VDEV_SUBTYPE_LEGACY_P2P_DEV   = 1,
+	WMI_VDEV_SUBTYPE_LEGACY_P2P_CLI   = 2,
+	WMI_VDEV_SUBTYPE_LEGACY_P2P_GO    = 3,
+	WMI_VDEV_SUBTYPE_LEGACY_PROXY_STA = 4,
+};
+
+enum wmi_vdev_subtype_10_2_4 {
+	WMI_VDEV_SUBTYPE_10_2_4_NONE      = 0,
+	WMI_VDEV_SUBTYPE_10_2_4_P2P_DEV   = 1,
+	WMI_VDEV_SUBTYPE_10_2_4_P2P_CLI   = 2,
+	WMI_VDEV_SUBTYPE_10_2_4_P2P_GO    = 3,
+	WMI_VDEV_SUBTYPE_10_2_4_PROXY_STA = 4,
+	WMI_VDEV_SUBTYPE_10_2_4_MESH_11S  = 5,
+};
+
+enum wmi_vdev_subtype_10_4 {
+	WMI_VDEV_SUBTYPE_10_4_NONE         = 0,
+	WMI_VDEV_SUBTYPE_10_4_P2P_DEV      = 1,
+	WMI_VDEV_SUBTYPE_10_4_P2P_CLI      = 2,
+	WMI_VDEV_SUBTYPE_10_4_P2P_GO       = 3,
+	WMI_VDEV_SUBTYPE_10_4_PROXY_STA    = 4,
+	WMI_VDEV_SUBTYPE_10_4_MESH_NON_11S = 5,
+	WMI_VDEV_SUBTYPE_10_4_MESH_11S     = 6,
 };
 
 /* values for vdev_subtype */
@@ -6471,5 +6499,7 @@ size_t ath10k_wmi_fw_stats_num_vdevs(struct list_head *head);
 void ath10k_wmi_10_4_op_fw_stats_fill(struct ath10k *ar,
 				      struct ath10k_fw_stats *fw_stats,
 				      char *buf);
+int ath10k_wmi_op_get_vdev_subtype(struct ath10k *ar,
+				   enum wmi_vdev_subtype subtype);
 
 #endif /* _WMI_H_ */
-- 
1.9.1

