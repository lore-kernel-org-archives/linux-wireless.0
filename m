Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14790 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbbJGFOY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2015 01:14:24 -0400
From: <c_traja@qti.qualcomm.com>
To: <johannes@sipsolutions.net>, <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Tamizh chelvam <c_traja@qti.qualcomm.com>,
	SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>
Subject: [PATCH 1/2] ath10k: Add abstraction layer for peer flags
Date: Wed, 7 Oct 2015 10:44:05 +0530
Message-ID: <1444194845-12702-1-git-send-email-c_traja@qti.qualcomm.com> (sfid-20151007_071433_606790_66E0183B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <c_traja@qti.qualcomm.com>

Abstraction layer for peer flags is added to fix ABI breakage.

Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
Signed-off-by: SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h    |    1 +
 drivers/net/wireless/ath/ath10k/mac.c     |   33 +++++------
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |   19 +++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |   18 ++++++
 drivers/net/wireless/ath/ath10k/wmi.c     |   60 ++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     |   88 ++++++++++++++++++++++++-----
 6 files changed, 188 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 04e040a..3e4668e 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -151,6 +151,7 @@ struct ath10k_wmi {
 	struct wmi_vdev_param_map *vdev_param;
 	struct wmi_pdev_param_map *pdev_param;
 	const struct wmi_ops *ops;
+	const struct wmi_peer_flags_map *peer_flags;
 
 	u32 num_mem_chunks;
 	u32 rx_decap_mode;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 79490ad..dc80d0b 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1960,7 +1960,7 @@ static void ath10k_peer_assoc_h_basic(struct ath10k *ar,
 	ether_addr_copy(arg->addr, sta->addr);
 	arg->vdev_id = arvif->vdev_id;
 	arg->peer_aid = aid;
-	arg->peer_flags |= WMI_PEER_AUTH;
+	arg->peer_flags |= arvif->ar->wmi.peer_flags->auth;
 	arg->peer_listen_intval = ath10k_peer_assoc_h_listen_intval(ar, vif);
 	arg->peer_num_spatial_streams = 1;
 	arg->peer_caps = vif->bss_conf.assoc_capability;
@@ -2002,12 +2002,12 @@ static void ath10k_peer_assoc_h_crypto(struct ath10k *ar,
 	/* FIXME: base on RSN IE/WPA IE is a correct idea? */
 	if (rsnie || wpaie) {
 		ath10k_dbg(ar, ATH10K_DBG_WMI, "%s: rsn ie found\n", __func__);
-		arg->peer_flags |= WMI_PEER_NEED_PTK_4_WAY;
+		arg->peer_flags |= ar->wmi.peer_flags->need_ptk_4_way;
 	}
 
 	if (wpaie) {
 		ath10k_dbg(ar, ATH10K_DBG_WMI, "%s: wpa ie found\n", __func__);
-		arg->peer_flags |= WMI_PEER_NEED_GTK_2_WAY;
+		arg->peer_flags |= ar->wmi.peer_flags->need_gtk_2_way;
 	}
 }
 
@@ -2103,7 +2103,7 @@ static void ath10k_peer_assoc_h_ht(struct ath10k *ar,
 	    ath10k_peer_assoc_h_vht_masked(vht_mcs_mask))
 		return;
 
-	arg->peer_flags |= WMI_PEER_HT;
+	arg->peer_flags |= ar->wmi.peer_flags->ht;
 	arg->peer_max_mpdu = (1 << (IEEE80211_HT_MAX_AMPDU_FACTOR +
 				    ht_cap->ampdu_factor)) - 1;
 
@@ -2114,10 +2114,10 @@ static void ath10k_peer_assoc_h_ht(struct ath10k *ar,
 	arg->peer_rate_caps |= WMI_RC_HT_FLAG;
 
 	if (ht_cap->cap & IEEE80211_HT_CAP_LDPC_CODING)
-		arg->peer_flags |= WMI_PEER_LDPC;
+		arg->peer_flags |= ar->wmi.peer_flags->ldbc;
 
 	if (sta->bandwidth >= IEEE80211_STA_RX_BW_40) {
-		arg->peer_flags |= WMI_PEER_40MHZ;
+		arg->peer_flags |= ar->wmi.peer_flags->bw40;
 		arg->peer_rate_caps |= WMI_RC_CW40_FLAG;
 	}
 
@@ -2131,7 +2131,7 @@ static void ath10k_peer_assoc_h_ht(struct ath10k *ar,
 
 	if (ht_cap->cap & IEEE80211_HT_CAP_TX_STBC) {
 		arg->peer_rate_caps |= WMI_RC_TX_STBC_FLAG;
-		arg->peer_flags |= WMI_PEER_STBC;
+		arg->peer_flags |= ar->wmi.peer_flags->stbc;
 	}
 
 	if (ht_cap->cap & IEEE80211_HT_CAP_RX_STBC) {
@@ -2139,7 +2139,7 @@ static void ath10k_peer_assoc_h_ht(struct ath10k *ar,
 		stbc = stbc >> IEEE80211_HT_CAP_RX_STBC_SHIFT;
 		stbc = stbc << WMI_RC_RX_STBC_FLAG_S;
 		arg->peer_rate_caps |= stbc;
-		arg->peer_flags |= WMI_PEER_STBC;
+		arg->peer_flags |= ar->wmi.peer_flags->stbc;
 	}
 
 	if (ht_cap->mcs.rx_mask[1] && ht_cap->mcs.rx_mask[2])
@@ -2320,10 +2320,10 @@ static void ath10k_peer_assoc_h_vht(struct ath10k *ar,
 	if (ath10k_peer_assoc_h_vht_masked(vht_mcs_mask))
 		return;
 
-	arg->peer_flags |= WMI_PEER_VHT;
+	arg->peer_flags |= ar->wmi.peer_flags->vht;
 
 	if (def.chan->band == IEEE80211_BAND_2GHZ)
-		arg->peer_flags |= WMI_PEER_VHT_2G;
+		arg->peer_flags |= ar->wmi.peer_flags->vht_2g;
 
 	arg->peer_vht_caps = vht_cap->cap;
 
@@ -2340,7 +2340,7 @@ static void ath10k_peer_assoc_h_vht(struct ath10k *ar,
 					ampdu_factor)) - 1);
 
 	if (sta->bandwidth == IEEE80211_STA_RX_BW_80)
-		arg->peer_flags |= WMI_PEER_80MHZ;
+		arg->peer_flags |= ar->wmi.peer_flags->bw80;
 
 	arg->peer_vht_rates.rx_max_rate =
 		__le16_to_cpu(vht_cap->vht_mcs.rx_highest);
@@ -2365,27 +2365,28 @@ static void ath10k_peer_assoc_h_qos(struct ath10k *ar,
 	switch (arvif->vdev_type) {
 	case WMI_VDEV_TYPE_AP:
 		if (sta->wme)
-			arg->peer_flags |= WMI_PEER_QOS;
+			arg->peer_flags |= arvif->ar->wmi.peer_flags->qos;
 
 		if (sta->wme && sta->uapsd_queues) {
-			arg->peer_flags |= WMI_PEER_APSD;
+			arg->peer_flags |= arvif->ar->wmi.peer_flags->apsd;
 			arg->peer_rate_caps |= WMI_RC_UAPSD_FLAG;
 		}
 		break;
 	case WMI_VDEV_TYPE_STA:
 		if (vif->bss_conf.qos)
-			arg->peer_flags |= WMI_PEER_QOS;
+			arg->peer_flags |= arvif->ar->wmi.peer_flags->qos;
 		break;
 	case WMI_VDEV_TYPE_IBSS:
 		if (sta->wme)
-			arg->peer_flags |= WMI_PEER_QOS;
+			arg->peer_flags |= arvif->ar->wmi.peer_flags->qos;
 		break;
 	default:
 		break;
 	}
 
 	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac peer %pM qos %d\n",
-		   sta->addr, !!(arg->peer_flags & WMI_PEER_QOS));
+		   sta->addr, !!(arg->peer_flags &
+		   arvif->ar->wmi.peer_flags->qos));
 }
 
 static bool ath10k_mac_sta_has_ofdm_only(struct ieee80211_sta *sta)
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index b5849b3..0d5fa4d 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -3470,6 +3470,24 @@ static const struct wmi_ops wmi_tlv_ops = {
 	.gen_adaptive_qcs = ath10k_wmi_tlv_op_gen_adaptive_qcs,
 };
 
+static const struct wmi_peer_flags_map wmi_tlv_peer_flags_map = {
+	.auth = WMI_TLV_PEER_AUTH,
+	.qos = WMI_TLV_PEER_QOS,
+	.need_ptk_4_way = WMI_TLV_PEER_NEED_PTK_4_WAY,
+	.need_gtk_2_way = WMI_TLV_PEER_NEED_GTK_2_WAY,
+	.apsd = WMI_TLV_PEER_APSD,
+	.ht = WMI_TLV_PEER_HT,
+	.bw40 = WMI_TLV_PEER_40MHZ,
+	.stbc = WMI_TLV_PEER_STBC,
+	.ldbc = WMI_TLV_PEER_LDPC,
+	.dyn_mimops = WMI_TLV_PEER_DYN_MIMOPS,
+	.static_mimops = WMI_TLV_PEER_STATIC_MIMOPS,
+	.spatial_mux = WMI_TLV_PEER_SPATIAL_MUX,
+	.vht = WMI_TLV_PEER_VHT,
+	.bw80 = WMI_TLV_PEER_80MHZ,
+	.pmf = WMI_TLV_PEER_PMF,
+};
+
 /************/
 /* TLV init */
 /************/
@@ -3480,4 +3498,5 @@ void ath10k_wmi_tlv_attach(struct ath10k *ar)
 	ar->wmi.vdev_param = &wmi_tlv_vdev_param_map;
 	ar->wmi.pdev_param = &wmi_tlv_pdev_param_map;
 	ar->wmi.ops = &wmi_tlv_ops;
+	ar->wmi.peer_flags = &wmi_tlv_peer_flags_map;
 }
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index ad655c4..dd67859 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -527,6 +527,24 @@ enum wmi_tlv_vdev_param {
 	WMI_TLV_VDEV_PARAM_IBSS_PS_1RX_CHAIN_IN_ATIM_WINDOW_ENABLE,
 };
 
+enum wmi_tlv_peer_flags {
+	WMI_TLV_PEER_AUTH = 0x00000001,
+	WMI_TLV_PEER_QOS = 0x00000002,
+	WMI_TLV_PEER_NEED_PTK_4_WAY = 0x00000004,
+	WMI_TLV_PEER_NEED_GTK_2_WAY = 0x00000010,
+	WMI_TLV_PEER_APSD = 0x00000800,
+	WMI_TLV_PEER_HT = 0x00001000,
+	WMI_TLV_PEER_40MHZ = 0x00002000,
+	WMI_TLV_PEER_STBC = 0x00008000,
+	WMI_TLV_PEER_LDPC = 0x00010000,
+	WMI_TLV_PEER_DYN_MIMOPS = 0x00020000,
+	WMI_TLV_PEER_STATIC_MIMOPS = 0x00040000,
+	WMI_TLV_PEER_SPATIAL_MUX = 0x00200000,
+	WMI_TLV_PEER_VHT = 0x02000000,
+	WMI_TLV_PEER_80MHZ = 0x04000000,
+	WMI_TLV_PEER_PMF = 0x08000000,
+};
+
 enum wmi_tlv_tag {
 	WMI_TLV_TAG_LAST_RESERVED = 15,
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 87d9de2..1430c3e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1542,6 +1542,61 @@ static struct wmi_pdev_param_map wmi_10_4_pdev_param_map = {
 	.arp_dstaddr = WMI_10_4_PDEV_PARAM_ARP_DSTADDR,
 };
 
+static const struct wmi_peer_flags_map wmi_peer_flags_map = {
+	.auth = WMI_PEER_AUTH,
+	.qos = WMI_PEER_QOS,
+	.need_ptk_4_way = WMI_PEER_NEED_PTK_4_WAY,
+	.need_gtk_2_way = WMI_PEER_NEED_GTK_2_WAY,
+	.apsd = WMI_PEER_APSD,
+	.ht = WMI_PEER_HT,
+	.bw40 = WMI_PEER_40MHZ,
+	.stbc = WMI_PEER_STBC,
+	.ldbc = WMI_PEER_LDPC,
+	.dyn_mimops = WMI_PEER_DYN_MIMOPS,
+	.static_mimops = WMI_PEER_STATIC_MIMOPS,
+	.spatial_mux = WMI_PEER_SPATIAL_MUX,
+	.vht = WMI_PEER_VHT,
+	.bw80 = WMI_PEER_80MHZ,
+	.vht_2g = WMI_PEER_VHT_2G,
+	.pmf = WMI_PEER_PMF,
+};
+
+static const struct wmi_peer_flags_map wmi_10x_peer_flags_map = {
+	.auth = WMI_10X_PEER_AUTH,
+	.qos = WMI_10X_PEER_QOS,
+	.need_ptk_4_way = WMI_10X_PEER_NEED_PTK_4_WAY,
+	.need_gtk_2_way = WMI_10X_PEER_NEED_GTK_2_WAY,
+	.apsd = WMI_10X_PEER_APSD,
+	.ht = WMI_10X_PEER_HT,
+	.bw40 = WMI_10X_PEER_40MHZ,
+	.stbc = WMI_10X_PEER_STBC,
+	.ldbc = WMI_10X_PEER_LDPC,
+	.dyn_mimops = WMI_10X_PEER_DYN_MIMOPS,
+	.static_mimops = WMI_10X_PEER_STATIC_MIMOPS,
+	.spatial_mux = WMI_10X_PEER_SPATIAL_MUX,
+	.vht = WMI_10X_PEER_VHT,
+	.bw80 = WMI_10X_PEER_80MHZ,
+};
+
+static const struct wmi_peer_flags_map wmi_10_2_peer_flags_map = {
+	.auth = WMI_10_2_PEER_AUTH,
+	.qos = WMI_10_2_PEER_QOS,
+	.need_ptk_4_way = WMI_10_2_PEER_NEED_PTK_4_WAY,
+	.need_gtk_2_way = WMI_10_2_PEER_NEED_GTK_2_WAY,
+	.apsd = WMI_10_2_PEER_APSD,
+	.ht = WMI_10_2_PEER_HT,
+	.bw40 = WMI_10_2_PEER_40MHZ,
+	.stbc = WMI_10_2_PEER_STBC,
+	.ldbc = WMI_10_2_PEER_LDPC,
+	.dyn_mimops = WMI_10_2_PEER_DYN_MIMOPS,
+	.static_mimops = WMI_10_2_PEER_STATIC_MIMOPS,
+	.spatial_mux = WMI_10_2_PEER_SPATIAL_MUX,
+	.vht = WMI_10_2_PEER_VHT,
+	.bw80 = WMI_10_2_PEER_80MHZ,
+	.vht_2g = WMI_10_2_PEER_VHT_2G,
+	.pmf = WMI_10_2_PEER_PMF,
+};
+
 void ath10k_wmi_put_wmi_channel(struct wmi_channel *ch,
 				const struct wmi_channel_arg *arg)
 {
@@ -6678,30 +6733,35 @@ int ath10k_wmi_attach(struct ath10k *ar)
 		ar->wmi.cmd = &wmi_10_4_cmd_map;
 		ar->wmi.vdev_param = &wmi_10_4_vdev_param_map;
 		ar->wmi.pdev_param = &wmi_10_4_pdev_param_map;
+		ar->wmi.peer_flags = &wmi_10_2_peer_flags_map;
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_10_2_4:
 		ar->wmi.cmd = &wmi_10_2_4_cmd_map;
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
index 3e5a159..84ada77 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -5471,21 +5471,79 @@ struct wmi_peer_set_q_empty_callback_cmd {
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
+	u32 auth;
+	u32 qos;
+	u32 need_ptk_4_way;
+	u32 need_gtk_2_way;
+	u32 apsd;
+	u32 ht;
+	u32 bw40;
+	u32 stbc;
+	u32 ldbc;
+	u32 dyn_mimops;
+	u32 static_mimops;
+	u32 spatial_mux;
+	u32 vht;
+	u32 bw80;
+	u32 vht_2g;
+	u32 pmf;
+};
+
+enum wmi_peer_flags {
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
+	WMI_10X_PEER_AUTH = 0x00000001,
+	WMI_10X_PEER_QOS = 0x00000002,
+	WMI_10X_PEER_NEED_PTK_4_WAY = 0x00000004,
+	WMI_10X_PEER_NEED_GTK_2_WAY = 0x00000010,
+	WMI_10X_PEER_APSD = 0x00000800,
+	WMI_10X_PEER_HT = 0x00001000,
+	WMI_10X_PEER_40MHZ = 0x00002000,
+	WMI_10X_PEER_STBC = 0x00008000,
+	WMI_10X_PEER_LDPC = 0x00010000,
+	WMI_10X_PEER_DYN_MIMOPS = 0x00020000,
+	WMI_10X_PEER_STATIC_MIMOPS = 0x00040000,
+	WMI_10X_PEER_SPATIAL_MUX = 0x00200000,
+	WMI_10X_PEER_VHT = 0x02000000,
+	WMI_10X_PEER_80MHZ = 0x04000000,
+};
+
+enum wmi_10_2_peer_flags {
+	WMI_10_2_PEER_AUTH = 0x00000001,
+	WMI_10_2_PEER_QOS = 0x00000002,
+	WMI_10_2_PEER_NEED_PTK_4_WAY = 0x00000004,
+	WMI_10_2_PEER_NEED_GTK_2_WAY = 0x00000010,
+	WMI_10_2_PEER_APSD = 0x00000800,
+	WMI_10_2_PEER_HT = 0x00001000,
+	WMI_10_2_PEER_40MHZ = 0x00002000,
+	WMI_10_2_PEER_STBC = 0x00008000,
+	WMI_10_2_PEER_LDPC = 0x00010000,
+	WMI_10_2_PEER_DYN_MIMOPS = 0x00020000,
+	WMI_10_2_PEER_STATIC_MIMOPS = 0x00040000,
+	WMI_10_2_PEER_SPATIAL_MUX = 0x00200000,
+	WMI_10_2_PEER_VHT = 0x02000000,
+	WMI_10_2_PEER_80MHZ = 0x04000000,
+	WMI_10_2_PEER_VHT_2G = 0x08000000,
+	WMI_10_2_PEER_PMF = 0x10000000,
+};
 
 /*
  * Peer rate capabilities.
-- 
1.7.9.5

