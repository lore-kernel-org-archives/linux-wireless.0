Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-6.exch022.serverdata.net ([206.225.164.189]:38338
	"EHLO HUB022-nj-6.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757076Ab2IUIp6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2012 04:45:58 -0400
From: Mahesh Palivela <maheshp@posedge.com>
To: "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: Peer STA VHT cap
Date: Fri, 21 Sep 2012 08:45:56 +0000
Message-ID: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCF4FFB@mbx022-e1-nj-10.exch022.domain.local> (sfid-20120921_104606_911603_5F8D744A)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mahesh Palivela <maheshp@posedge.com>

To save peer STA VHT capabilities in mac80211.

Signed-off-by: Mahesh Palivela <maheshp@posedge.com>
---
 include/linux/ieee80211.h  |   40 ++++++++++++++++++++++++++--------------
 include/net/cfg80211.h     |    2 ++
 include/net/mac80211.h     |    2 ++
 net/mac80211/Makefile      |    1 +
 net/mac80211/cfg.c         |    5 +++++
 net/mac80211/ieee80211_i.h |    7 +++++++
 net/mac80211/main.c        |    2 +-
 net/mac80211/mlme.c        |    9 +++++++--
 net/mac80211/util.c        |   16 ++++++++++++++--
 net/mac80211/vht.c         |   42 ++++++++++++++++++++++++++++++++++++++++++
 10 files changed, 107 insertions(+), 19 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 2385119..1577e21 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1107,20 +1107,6 @@ struct ieee80211_ht_operation {
 #define WLAN_HT_SMPS_CONTROL_STATIC	1
 #define WLAN_HT_SMPS_CONTROL_DYNAMIC	3
 
-#define VHT_MCS_SUPPORTED_SET_SIZE      8
-
-struct ieee80211_vht_capabilities {
-	__le32 vht_capabilities_info;
-	u8 vht_supported_mcs_set[VHT_MCS_SUPPORTED_SET_SIZE];
-} __packed;
-
-struct ieee80211_vht_operation {
-	u8 vht_op_info_chwidth;
-	u8 vht_op_info_chan_center_freq_seg1_idx;
-	u8 vht_op_info_chan_center_freq_seg2_idx;
-	__le16 vht_basic_mcs_set;
-} __packed;
-
 /**
  * struct ieee80211_vht_mcs_info - VHT MCS information
  * @rx_mcs_map: RX MCS map 2 bits for each stream, total 8 streams
@@ -1141,6 +1127,32 @@ struct ieee80211_vht_mcs_info {
 	__le16 tx_highest;
 } __packed;
 
+/**
+ * struct ieee80211_vht_cap - VHT capabilities
+ *
+ * This structure is the "VHT capabilities element" as
+ * described in 802.11ac D3.0 8.4.2.160
+ */
+struct ieee80211_vht_cap {
+	__le32 vht_cap_info;
+	struct ieee80211_vht_mcs_info supp_mcs;
+} __packed;
+
+
+/**
+ * struct ieee80211_vht_operation - VHT operation IE
+ *
+ * This structure is the "VHT operation element" as
+ * described in 802.11ac D3.0 8.4.2.161
+ */
+struct ieee80211_vht_operation {
+	u8 chan_width;
+	u8 center_freq_seg1_idx;
+	u8 center_freq_seg2_idx;
+	__le16 vht_basic_mcs_set;
+} __packed;
+
+
 #define IEEE80211_VHT_MCS_ZERO_TO_SEVEN_SUPPORT 0
 #define IEEE80211_VHT_MCS_ZERO_TO_EIGHT_SUPPORT 1
 #define IEEE80211_VHT_MCS_ZERO_TO_NINE_SUPPORT  2
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ab78b53..9cf6327 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -498,6 +498,7 @@ enum station_parameters_apply_mask {
  * @plink_action: plink action to take
  * @plink_state: set the peer link state for a station
  * @ht_capa: HT capabilities of station
+ * @vht_capa: VHT capabilities of station
  * @uapsd_queues: bitmap of queues configured for uapsd. same format
  *	as the AC bitmap in the QoS info field
  * @max_sp: max Service Period. same format as the MAX_SP in the
@@ -517,6 +518,7 @@ struct station_parameters {
 	u8 plink_action;
 	u8 plink_state;
 	struct ieee80211_ht_cap *ht_capa;
+	struct ieee80211_vht_cap *vht_capa;
 	u8 uapsd_queues;
 	u8 max_sp;
 };
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 82558c8..b0369f7 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1076,6 +1076,7 @@ enum ieee80211_sta_state {
  * @aid: AID we assigned to the station if we're an AP
  * @supp_rates: Bitmap of supported rates (per band)
  * @ht_cap: HT capabilities of this STA; restricted to our own TX capabilities
+ * @vht_cap: VHT capabilities of this STA
  * @wme: indicates whether the STA supports WME. Only valid during AP-mode.
  * @drv_priv: data area for driver use, will always be aligned to
  *	sizeof(void *), size is determined in hw information.
@@ -1088,6 +1089,7 @@ struct ieee80211_sta {
 	u8 addr[ETH_ALEN];
 	u16 aid;
 	struct ieee80211_sta_ht_cap ht_cap;
+	struct ieee80211_sta_vht_cap vht_cap;
 	bool wme;
 	u8 uapsd_queues;
 	u8 max_sp;
diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index a7dd110..4911202 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -8,6 +8,7 @@ mac80211-y := \
 	wpa.o \
 	scan.o offchannel.o \
 	ht.o agg-tx.o agg-rx.o \
+	vht.o \
 	ibss.o \
 	iface.o \
 	rate.o \
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 05f3a31..cf63a9e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1144,6 +1144,11 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 						  params->ht_capa,
 						  &sta->sta.ht_cap);
 
+	if (params->vht_capa)
+		ieee80211_vht_cap_ie_to_sta_vht_cap(sdata, sband,
+						    params->vht_capa,
+						    &sta->sta.vht_cap);
+
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CONFIG_MAC80211_MESH
 		if (sdata->u.mesh.security & IEEE80211_MESH_SEC_SECURED)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 8c80455..62037e2 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1133,6 +1133,8 @@ struct ieee802_11_elems {
 	u8 *wmm_param;
 	struct ieee80211_ht_cap *ht_cap_elem;
 	struct ieee80211_ht_operation *ht_operation;
+	struct ieee80211_vht_cap *vht_cap_elem;
+	struct ieee80211_vht_operation *vht_operation;
 	struct ieee80211_meshconf_ie *mesh_config;
 	u8 *mesh_id;
 	u8 *peering;
@@ -1359,6 +1361,11 @@ void ieee80211_ba_session_work(struct work_struct *work);
 void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid);
 void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid);
 
+/* VHT */
+void ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
+					 struct ieee80211_supported_band *sband,
+					 struct ieee80211_vht_cap *vht_cap_ie,
+					 struct ieee80211_sta_vht_cap *vht_cap);
 /* Spectrum management */
 void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
 				       struct ieee80211_mgmt *mgmt,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index c80c449..0ec170f 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -832,7 +832,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 	if (supp_vht)
 		local->scan_ies_len +=
-			2 + sizeof(struct ieee80211_vht_capabilities);
+			2 + sizeof(struct ieee80211_vht_cap);
 
 	if (!local->ops->hw_scan) {
 		/* For hw_scan, driver needs to set these up. */
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 2dbd9e1..79b1123 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -343,7 +343,7 @@ static void ieee80211_add_vht_ie(struct ieee80211_sub_if_data *sdata,
 	cap = vht_cap.cap;
 
 	/* reserve and fill IE */
-	pos = skb_put(skb, sizeof(struct ieee80211_vht_capabilities) + 2);
+	pos = skb_put(skb, sizeof(struct ieee80211_vht_cap) + 2);
 	ieee80211_ie_build_vht_cap(pos, &vht_cap, cap);
 }
 
@@ -392,7 +392,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 			4 + /* power capability */
 			2 + 2 * sband->n_channels + /* supported channels */
 			2 + sizeof(struct ieee80211_ht_cap) + /* HT */
-			2 + sizeof(struct ieee80211_vht_capabilities) + /* VHT */
+			2 + sizeof(struct ieee80211_vht_cap) + /* VHT */
 			assoc_data->ie_len + /* extra IEs */
 			9, /* WMM */
 			GFP_KERNEL);
@@ -2100,6 +2100,11 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 	sta->supports_40mhz =
 		sta->sta.ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 
+	if (elems.vht_cap_elem && !(ifmgd->flags & IEEE80211_STA_DISABLE_VHT))
+		ieee80211_vht_cap_ie_to_sta_vht_cap(sdata, sband,
+						    elems.vht_cap_elem,
+						    &sta->sta.vht_cap);
+
 	rate_control_rate_init(sta);
 
 	if (ifmgd->flags & IEEE80211_STA_MFP_ENABLED)
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 22ca350..c808906 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -741,6 +741,18 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			else
 				elem_parse_failed = true;
 			break;
+		case WLAN_EID_VHT_CAPABILITY:
+			if (elen >= sizeof(struct ieee80211_vht_cap))
+				elems->vht_cap_elem = (void *)pos;
+			else
+				elem_parse_failed = true;
+			break;
+		case WLAN_EID_VHT_OPERATION:
+			if (elen >= sizeof(struct ieee80211_vht_operation))
+				elems->vht_operation = (void *)pos;
+			else
+				elem_parse_failed = true;
+			break;
 		case WLAN_EID_MESH_ID:
 			elems->mesh_id = pos;
 			elems->mesh_id_len = elen;
@@ -1788,8 +1800,8 @@ u8 *ieee80211_ie_build_vht_cap(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
 	__le32 tmp;
 
 	*pos++ = WLAN_EID_VHT_CAPABILITY;
-	*pos++ = sizeof(struct ieee80211_vht_capabilities);
-	memset(pos, 0, sizeof(struct ieee80211_vht_capabilities));
+	*pos++ = sizeof(struct ieee80211_vht_cap);
+	memset(pos, 0, sizeof(struct ieee80211_vht_cap));
 
 	/* capability flags */
 	tmp = cpu_to_le32(cap);
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
new file mode 100644
index 0000000..b98fc5a
--- /dev/null
+++ b/net/mac80211/vht.c
@@ -0,0 +1,42 @@
+/*
+ * VHT handling
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/ieee80211.h>
+#include <linux/export.h>
+#include <net/mac80211.h>
+#include "ieee80211_i.h"
+
+
+void ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
+					 struct ieee80211_supported_band *sband,
+					 struct ieee80211_vht_cap *vht_cap_ie,
+					 struct ieee80211_sta_vht_cap *vht_cap)
+{
+	BUG_ON(!vht_cap);
+
+	memset(vht_cap, 0, sizeof(*vht_cap));
+
+	if (!vht_cap_ie || !sband->vht_cap.vht_supported)
+		return;
+
+	vht_cap->vht_supported = true;
+
+	/*
+	 * The bits listed in this expression should be
+	 * the same for the peer and us, if the station
+	 * advertises more then we can't use those thus
+	 * we mask them out.
+	 */
+	vht_cap->cap = le16_to_cpu(vht_cap_ie->vht_cap_info) & 
+		       sband->vht_cap.cap;
+
+	/* Copy peer MCS info, the driver might need them. */
+	memcpy((u8 *)&vht_cap->vht_mcs,
+	       (u8 *)&vht_cap_ie->supp_mcs,
+	       sizeof(struct ieee80211_vht_mcs_info));
+}