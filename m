Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64374 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbbB1KSb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Feb 2015 05:18:31 -0500
From: SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>
Subject: [PATCH] ath10k: Enable encrytion of ADDBA request in PMF configuration
Date: Sat, 28 Feb 2015 15:48:09 +0530
Message-ID: <1425118689-32553-1-git-send-email-sjegadee@qti.qualcomm.com> (sfid-20150228_111836_996655_9FBDE5AE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In HT mode, firmware is not encrypting ADDBA request as PMF
configuration is not set in peer flags during association.

Set peer flags for MFP enabled station in ath10k driver.

Implemented abstraction layer for peer flags.

This change depends on mac80211 patch "[PATCH] mac80211: send
station PMF configuration to driver".

Signed-off-by: SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 7cba781..22c4c43 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -145,6 +145,7 @@ struct ath10k_wmi {
 	struct wmi_vdev_param_map *vdev_param;
 	struct wmi_pdev_param_map *pdev_param;
 	const struct wmi_ops *ops;
+	struct wmi_peer_flags_map *peer_flags;

 	u32 num_mem_chunks;
 	struct ath10k_mem_chunk mem_chunks[WMI_MAX_MEM_REQS];
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 0f39af7..996ef64 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1369,7 +1369,7 @@ static void ath10k_peer_assoc_h_basic(struct ath10k *ar,
 	ether_addr_copy(arg->addr, sta->addr);
 	arg->vdev_id = arvif->vdev_id;
 	arg->peer_aid = sta->aid;
-	arg->peer_flags |= WMI_PEER_AUTH;
+	arg->peer_flags |= arvif->ar->wmi.peer_flags->wmi_peer_auth;
 	arg->peer_listen_intval = ath10k_peer_assoc_h_listen_intval(ar, vif);
 	arg->peer_num_spatial_streams = 1;
 	arg->peer_caps = vif->bss_conf.assoc_capability;
@@ -1407,12 +1407,14 @@ static void ath10k_peer_assoc_h_crypto(struct ath10k *ar,
 	/* FIXME: base on RSN IE/WPA IE is a correct idea? */
 	if (rsnie || wpaie) {
 		ath10k_dbg(ar, ATH10K_DBG_WMI, "%s: rsn ie found\n", __func__);
-		arg->peer_flags |= WMI_PEER_NEED_PTK_4_WAY;
+		arg->peer_flags |=
+				ar->wmi.peer_flags->wmi_peer_need_ptk_4_way;
 	}

 	if (wpaie) {
 		ath10k_dbg(ar, ATH10K_DBG_WMI, "%s: wpa ie found\n", __func__);
-		arg->peer_flags |= WMI_PEER_NEED_GTK_2_WAY;
+		arg->peer_flags |=
+				ar->wmi.peer_flags->wmi_peer_need_gtk_2_way;
 	}
 }

@@ -1456,7 +1458,7 @@ static void ath10k_peer_assoc_h_ht(struct ath10k *ar,
 	if (!ht_cap->ht_supported)
 		return;

-	arg->peer_flags |= WMI_PEER_HT;
+	arg->peer_flags |= ar->wmi.peer_flags->wmi_peer_ht;
 	arg->peer_max_mpdu = (1 << (IEEE80211_HT_MAX_AMPDU_FACTOR +
 				    ht_cap->ampdu_factor)) - 1;

@@ -1467,10 +1469,10 @@ static void ath10k_peer_assoc_h_ht(struct ath10k *ar,
 	arg->peer_rate_caps |= WMI_RC_HT_FLAG;

 	if (ht_cap->cap & IEEE80211_HT_CAP_LDPC_CODING)
-		arg->peer_flags |= WMI_PEER_LDPC;
+		arg->peer_flags |= ar->wmi.peer_flags->wmi_peer_ldbc;

 	if (sta->bandwidth >= IEEE80211_STA_RX_BW_40) {
-		arg->peer_flags |= WMI_PEER_40MHZ;
+		arg->peer_flags |= ar->wmi.peer_flags->wmi_peer_40MHZ;
 		arg->peer_rate_caps |= WMI_RC_CW40_FLAG;
 	}

@@ -1482,7 +1484,7 @@ static void ath10k_peer_assoc_h_ht(struct ath10k *ar,

 	if (ht_cap->cap & IEEE80211_HT_CAP_TX_STBC) {
 		arg->peer_rate_caps |= WMI_RC_TX_STBC_FLAG;
-		arg->peer_flags |= WMI_PEER_STBC;
+		arg->peer_flags |= ar->wmi.peer_flags->wmi_peer_stbc;
 	}

 	if (ht_cap->cap & IEEE80211_HT_CAP_RX_STBC) {
@@ -1490,7 +1492,7 @@ static void ath10k_peer_assoc_h_ht(struct ath10k *ar,
 		stbc = stbc >> IEEE80211_HT_CAP_RX_STBC_SHIFT;
 		stbc = stbc << WMI_RC_RX_STBC_FLAG_S;
 		arg->peer_rate_caps |= stbc;
-		arg->peer_flags |= WMI_PEER_STBC;
+		arg->peer_flags |= ar->wmi.peer_flags->wmi_peer_stbc;
 	}

 	if (ht_cap->mcs.rx_mask[1] && ht_cap->mcs.rx_mask[2])
@@ -1603,10 +1605,10 @@ static void ath10k_peer_assoc_h_vht(struct ath10k *ar,
 	if (!vht_cap->vht_supported)
 		return;

-	arg->peer_flags |= WMI_PEER_VHT;
+	arg->peer_flags |= ar->wmi.peer_flags->wmi_peer_vht;

 	if (ar->hw->conf.chandef.chan->band == IEEE80211_BAND_2GHZ)
-		arg->peer_flags |= WMI_PEER_VHT_2G;
+		arg->peer_flags |= ar->wmi.peer_flags->wmi_peer_vht_2g;

 	arg->peer_vht_caps = vht_cap->cap;

@@ -1623,7 +1625,7 @@ static void ath10k_peer_assoc_h_vht(struct ath10k *ar,
 					ampdu_factor)) - 1);

 	if (sta->bandwidth == IEEE80211_STA_RX_BW_80)
-		arg->peer_flags |= WMI_PEER_80MHZ;
+		arg->peer_flags |= ar->wmi.peer_flags->wmi_peer_80MHZ;

 	arg->peer_vht_rates.rx_max_rate =
 		__le16_to_cpu(vht_cap->vht_mcs.rx_highest);
@@ -1648,27 +1650,32 @@ static void ath10k_peer_assoc_h_qos(struct ath10k *ar,
 	switch (arvif->vdev_type) {
 	case WMI_VDEV_TYPE_AP:
 		if (sta->wme)
-			arg->peer_flags |= WMI_PEER_QOS;
+			arg->peer_flags |=
+				arvif->ar->wmi.peer_flags->wmi_peer_qos;

 		if (sta->wme && sta->uapsd_queues) {
-			arg->peer_flags |= WMI_PEER_APSD;
+			arg->peer_flags |=
+				arvif->ar->wmi.peer_flags->wmi_peer_apsd;
 			arg->peer_rate_caps |= WMI_RC_UAPSD_FLAG;
 		}
 		break;
 	case WMI_VDEV_TYPE_STA:
 		if (vif->bss_conf.qos)
-			arg->peer_flags |= WMI_PEER_QOS;
+			arg->peer_flags |=
+				arvif->ar->wmi.peer_flags->wmi_peer_qos;
 		break;
 	case WMI_VDEV_TYPE_IBSS:
 		if (sta->wme)
-			arg->peer_flags |= WMI_PEER_QOS;
+			arg->peer_flags |=
+				arvif->ar->wmi.peer_flags->wmi_peer_qos;
 		break;
 	default:
 		break;
 	}

 	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac peer %pM qos %d\n",
-		   sta->addr, !!(arg->peer_flags & WMI_PEER_QOS));
+		   sta->addr, !!(arg->peer_flags &
+				arvif->ar->wmi.peer_flags->wmi_peer_qos));
 }

 static bool ath10k_mac_sta_has_11g_rates(struct ieee80211_sta *sta)
@@ -1752,6 +1759,11 @@ static int ath10k_peer_assoc_prepare(struct ath10k *ar,
 	ath10k_peer_assoc_h_qos(ar, vif, sta, arg);
 	ath10k_peer_assoc_h_phymode(ar, vif, sta, arg);

+	if (sta->mfp) {
+		if (ar->wmi.op_version == ATH10K_FW_WMI_OP_VERSION_10_2_4)
+			arg->peer_flags |= ar->wmi.peer_flags->wmi_peer_pmf;
+	}
+
 	return 0;
 }

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index f34baa0..2dfc13b 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -2788,6 +2788,25 @@ static const struct wmi_ops wmi_tlv_ops = {
 	.gen_sta_keepalive = ath10k_wmi_tlv_op_gen_sta_keepalive,
 };

+static struct wmi_peer_flags_map wmi_tlv_peer_flags_map = {
+        .wmi_peer_auth = WMI_TLV_PEER_AUTH,
+        .wmi_peer_qos = WMI_TLV_PEER_QOS,
+        .wmi_peer_need_ptk_4_way = WMI_TLV_PEER_NEED_PTK_4_WAY,
+        .wmi_peer_need_gtk_2_way = WMI_TLV_PEER_NEED_GTK_2_WAY,
+        .wmi_peer_apsd = WMI_TLV_PEER_APSD,
+        .wmi_peer_ht = WMI_TLV_PEER_HT,
+        .wmi_peer_40MHZ = WMI_TLV_PEER_40MHZ,
+        .wmi_peer_stbc = WMI_TLV_PEER_STBC,
+        .wmi_peer_ldbc = WMI_TLV_PEER_LDPC,
+        .wmi_peer_dyn_mimops = WMI_TLV_PEER_DYN_MIMOPS,
+        .wmi_peer_static_mimops = WMI_TLV_PEER_STATIC_MIMOPS,
+        .wmi_peer_spatial_mux = WMI_TLV_PEER_SPATIAL_MUX,
+        .wmi_peer_vht = WMI_TLV_PEER_VHT,
+        .wmi_peer_80MHZ = WMI_TLV_PEER_80MHZ,
+        .wmi_peer_pmf = WMI_TLV_PEER_PMF,
+};
+
+
 /************/
 /* TLV init */
 /************/
@@ -2798,4 +2817,5 @@ void ath10k_wmi_tlv_attach(struct ath10k *ar)
 	ar->wmi.vdev_param = &wmi_tlv_vdev_param_map;
 	ar->wmi.pdev_param = &wmi_tlv_pdev_param_map;
 	ar->wmi.ops = &wmi_tlv_ops;
+	ar->wmi.peer_flags = &wmi_tlv_peer_flags_map;
 }
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index d7a31e1..7159b69 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -527,6 +527,25 @@ enum wmi_tlv_vdev_param {
 	WMI_TLV_VDEV_PARAM_IBSS_PS_1RX_CHAIN_IN_ATIM_WINDOW_ENABLE,
 };

+enum wmi_tlv_peer_flags {
+
+        WMI_TLV_PEER_AUTH = 0x00000001,
+        WMI_TLV_PEER_QOS = 0x00000002,
+        WMI_TLV_PEER_NEED_PTK_4_WAY = 0x00000004,
+        WMI_TLV_PEER_NEED_GTK_2_WAY = 0x00000010,
+        WMI_TLV_PEER_APSD = 0x00000800,
+        WMI_TLV_PEER_HT = 0x00001000,
+        WMI_TLV_PEER_40MHZ = 0x00002000,
+        WMI_TLV_PEER_STBC = 0x00008000,
+        WMI_TLV_PEER_LDPC = 0x00010000,
+        WMI_TLV_PEER_DYN_MIMOPS = 0x00020000,
+        WMI_TLV_PEER_STATIC_MIMOPS = 0x00040000,
+        WMI_TLV_PEER_SPATIAL_MUX = 0x00200000,
+        WMI_TLV_PEER_VHT = 0x02000000,
+        WMI_TLV_PEER_80MHZ = 0x04000000,
+        WMI_TLV_PEER_PMF = 0x08000000,
+};
+
 enum wmi_tlv_tag {
 	WMI_TLV_TAG_LAST_RESERVED = 15,

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index c7ea77e..ad4dc82 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -849,6 +849,62 @@ static struct wmi_cmd_map wmi_10_2_cmd_map = {
 	.pdev_get_temperature_cmdid = WMI_CMD_UNSUPPORTED,
 };

+static struct wmi_peer_flags_map wmi_peer_flags_map = {
+	.wmi_peer_auth = WMI_PEER_AUTH,
+	.wmi_peer_qos = WMI_PEER_QOS,
+	.wmi_peer_need_ptk_4_way = WMI_PEER_NEED_PTK_4_WAY,
+	.wmi_peer_need_gtk_2_way = WMI_PEER_NEED_GTK_2_WAY,
+	.wmi_peer_apsd = WMI_PEER_APSD,
+	.wmi_peer_ht = WMI_PEER_HT,
+	.wmi_peer_40MHZ = WMI_PEER_40MHZ,
+	.wmi_peer_stbc = WMI_PEER_STBC,
+	.wmi_peer_ldbc = WMI_PEER_LDPC,
+	.wmi_peer_dyn_mimops = WMI_PEER_DYN_MIMOPS,
+	.wmi_peer_static_mimops = WMI_PEER_STATIC_MIMOPS,
+	.wmi_peer_spatial_mux = WMI_PEER_SPATIAL_MUX,
+	.wmi_peer_vht = WMI_PEER_VHT,
+	.wmi_peer_80MHZ = WMI_PEER_80MHZ,
+	.wmi_peer_vht_2g = WMI_PEER_VHT_2G,
+	.wmi_peer_pmf = WMI_PEER_PMF,
+};
+
+static struct wmi_peer_flags_map wmi_10x_peer_flags_map = {
+        .wmi_peer_auth = WMI_10X_PEER_AUTH,
+        .wmi_peer_qos = WMI_10X_PEER_QOS,
+        .wmi_peer_need_ptk_4_way = WMI_10X_PEER_NEED_PTK_4_WAY,
+        .wmi_peer_need_gtk_2_way = WMI_10X_PEER_NEED_GTK_2_WAY,
+        .wmi_peer_apsd = WMI_10X_PEER_APSD,
+        .wmi_peer_ht = WMI_10X_PEER_HT,
+        .wmi_peer_40MHZ = WMI_10X_PEER_40MHZ,
+        .wmi_peer_stbc = WMI_10X_PEER_STBC,
+        .wmi_peer_ldbc = WMI_10X_PEER_LDPC,
+        .wmi_peer_dyn_mimops = WMI_10X_PEER_DYN_MIMOPS,
+        .wmi_peer_static_mimops = WMI_10X_PEER_STATIC_MIMOPS,
+        .wmi_peer_spatial_mux = WMI_10X_PEER_SPATIAL_MUX,
+        .wmi_peer_vht = WMI_10X_PEER_VHT,
+        .wmi_peer_80MHZ = WMI_10X_PEER_80MHZ,
+};
+
+static struct wmi_peer_flags_map wmi_10_2_peer_flags_map = {
+        .wmi_peer_auth = WMI_10_2_PEER_AUTH,
+        .wmi_peer_qos = WMI_10_2_PEER_QOS,
+        .wmi_peer_need_ptk_4_way = WMI_10_2_PEER_NEED_PTK_4_WAY,
+        .wmi_peer_need_gtk_2_way = WMI_10_2_PEER_NEED_GTK_2_WAY,
+        .wmi_peer_apsd = WMI_10_2_PEER_APSD,
+        .wmi_peer_ht = WMI_10_2_PEER_HT,
+        .wmi_peer_40MHZ = WMI_10_2_PEER_40MHZ,
+        .wmi_peer_stbc = WMI_10_2_PEER_STBC,
+        .wmi_peer_ldbc = WMI_10_2_PEER_LDPC,
+        .wmi_peer_dyn_mimops = WMI_10_2_PEER_DYN_MIMOPS,
+        .wmi_peer_static_mimops = WMI_10_2_PEER_STATIC_MIMOPS,
+        .wmi_peer_spatial_mux = WMI_10_2_PEER_SPATIAL_MUX,
+        .wmi_peer_vht = WMI_10_2_PEER_VHT,
+        .wmi_peer_80MHZ = WMI_10_2_PEER_80MHZ,
+        .wmi_peer_vht_2g = WMI_10_2_PEER_VHT_2G,
+        .wmi_peer_pmf = WMI_10_2_PEER_PMF,
+};
+
+
 void ath10k_wmi_put_wmi_channel(struct wmi_channel *ch,
 				const struct wmi_channel_arg *arg)
 {
@@ -5462,24 +5518,28 @@ int ath10k_wmi_attach(struct ath10k *ar)
 		ar->wmi.ops = &wmi_10_2_4_ops;
 		ar->wmi.vdev_param = &wmi_10_2_4_vdev_param_map;
 		ar->wmi.pdev_param = &wmi_10_2_4_pdev_param_map;
+		ar->wmi.peer_flags = &wmi_10_2_peer_flags_map;
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_10_2:
 		ar->wmi.cmd = &wmi_10_2_cmd_map;
 		ar->wmi.ops = &wmi_10_2_ops;
 		ar->wmi.vdev_param = &wmi_10x_vdev_param_map;
 		ar->wmi.pdev_param = &wmi_10x_pdev_param_map;
+		ar->wmi.peer_flags = &wmi_10_2_peer_flags_map;
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_10_1:
 		ar->wmi.cmd = &wmi_10x_cmd_map;
 		ar->wmi.ops = &wmi_10_1_ops;
 		ar->wmi.vdev_param = &wmi_10x_vdev_param_map;
 		ar->wmi.pdev_param = &wmi_10x_pdev_param_map;
+		ar->wmi.peer_flags = &wmi_10x_peer_flags_map;
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_MAIN:
 		ar->wmi.cmd = &wmi_cmd_map;
 		ar->wmi.ops = &wmi_ops;
 		ar->wmi.vdev_param = &wmi_vdev_param_map;
 		ar->wmi.pdev_param = &wmi_pdev_param_map;
+		ar->wmi.peer_flags = &wmi_peer_flags_map;
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_TLV:
 		ath10k_wmi_tlv_attach(ar);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 28c1822..d464be2 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4509,21 +4509,82 @@ struct wmi_peer_set_q_empty_callback_cmd {
 	__le32 callback_enable;
 } __packed;

-#define WMI_PEER_AUTH           0x00000001
-#define WMI_PEER_QOS            0x00000002
-#define WMI_PEER_NEED_PTK_4_WAY 0x00000004
-#define WMI_PEER_NEED_GTK_2_WAY 0x00000010
-#define WMI_PEER_APSD           0x00000800
-#define WMI_PEER_HT             0x00001000
-#define WMI_PEER_40MHZ          0x00002000
-#define WMI_PEER_STBC           0x00008000
-#define WMI_PEER_LDPC           0x00010000
-#define WMI_PEER_DYN_MIMOPS     0x00020000
-#define WMI_PEER_STATIC_MIMOPS  0x00040000
-#define WMI_PEER_SPATIAL_MUX    0x00200000
-#define WMI_PEER_VHT            0x02000000
-#define WMI_PEER_80MHZ          0x04000000
-#define WMI_PEER_VHT_2G         0x08000000
+struct wmi_peer_flags_map {
+	u32 wmi_peer_auth;
+	u32 wmi_peer_qos;
+	u32 wmi_peer_need_ptk_4_way;
+	u32 wmi_peer_need_gtk_2_way;
+	u32 wmi_peer_apsd;
+	u32 wmi_peer_ht;
+	u32 wmi_peer_40MHZ;
+	u32 wmi_peer_stbc;
+	u32 wmi_peer_ldbc;
+	u32 wmi_peer_dyn_mimops;
+	u32 wmi_peer_static_mimops;
+	u32 wmi_peer_spatial_mux;
+	u32 wmi_peer_vht;
+	u32 wmi_peer_80MHZ;
+	u32 wmi_peer_vht_2g;
+	u32 wmi_peer_pmf;
+};
+
+enum wmi_peer_flags {
+
+	WMI_PEER_AUTH = 0x00000001,
+	WMI_PEER_QOS = 0x00000002,
+	WMI_PEER_NEED_PTK_4_WAY = 0x00000004,
+	WMI_PEER_NEED_GTK_2_WAY = 0x00000010,
+	WMI_PEER_APSD = 0x00000800,
+	WMI_PEER_HT = 0x00001000,
+	WMI_PEER_40MHZ = 0x00002000,
+	WMI_PEER_STBC = 0x00008000,
+	WMI_PEER_LDPC = 0x00010000,
+	WMI_PEER_DYN_MIMOPS = 0x00020000,
+	WMI_PEER_STATIC_MIMOPS = 0x00040000,
+	WMI_PEER_SPATIAL_MUX = 0x00200000,
+	WMI_PEER_VHT = 0x02000000,
+	WMI_PEER_80MHZ = 0x04000000,
+	WMI_PEER_VHT_2G = 0x08000000,
+	WMI_PEER_PMF = 0x10000000,
+};
+
+enum wmi_10x_peer_flags {
+
+	WMI_10X_PEER_AUTH = 0x00000001,
+        WMI_10X_PEER_QOS = 0x00000002,
+        WMI_10X_PEER_NEED_PTK_4_WAY = 0x00000004,
+        WMI_10X_PEER_NEED_GTK_2_WAY = 0x00000010,
+        WMI_10X_PEER_APSD = 0x00000800,
+        WMI_10X_PEER_HT = 0x00001000,
+        WMI_10X_PEER_40MHZ = 0x00002000,
+        WMI_10X_PEER_STBC = 0x00008000,
+        WMI_10X_PEER_LDPC = 0x00010000,
+        WMI_10X_PEER_DYN_MIMOPS = 0x00020000,
+        WMI_10X_PEER_STATIC_MIMOPS = 0x00040000,
+        WMI_10X_PEER_SPATIAL_MUX = 0x00200000,
+        WMI_10X_PEER_VHT = 0x02000000,
+        WMI_10X_PEER_80MHZ = 0x04000000,
+};
+
+enum wmi_10_2_peer_flags {
+
+        WMI_10_2_PEER_AUTH = 0x00000001,
+        WMI_10_2_PEER_QOS = 0x00000002,
+        WMI_10_2_PEER_NEED_PTK_4_WAY = 0x00000004,
+        WMI_10_2_PEER_NEED_GTK_2_WAY = 0x00000010,
+        WMI_10_2_PEER_APSD = 0x00000800,
+        WMI_10_2_PEER_HT = 0x00001000,
+        WMI_10_2_PEER_40MHZ = 0x00002000,
+        WMI_10_2_PEER_STBC = 0x00008000,
+        WMI_10_2_PEER_LDPC = 0x00010000,
+        WMI_10_2_PEER_DYN_MIMOPS = 0x00020000,
+        WMI_10_2_PEER_STATIC_MIMOPS = 0x00040000,
+        WMI_10_2_PEER_SPATIAL_MUX = 0x00200000,
+        WMI_10_2_PEER_VHT = 0x02000000,
+        WMI_10_2_PEER_80MHZ = 0x04000000,
+        WMI_10_2_PEER_VHT_2G = 0x08000000,
+        WMI_10_2_PEER_PMF = 0x10000000,
+};

 /*
  * Peer rate capabilities.
--
1.9.1

