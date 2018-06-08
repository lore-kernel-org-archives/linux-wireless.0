Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48078 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751246AbeFHPgk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Jun 2018 11:36:40 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, arend.vanspriel@broadcom.com,
        Luca Coelho <luciano.coelho@intel.com>,
        Liad Kaufman <liad.kaufman@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Ilan Peer <ilan.peer@intel.com>,
        Ido Yariv <idox.yariv@intel.com>
Date: Fri,  8 Jun 2018 18:36:24 +0300
Message-Id: <20180608153624.15211-1-luca@coelho.fi> (sfid-20180608_173648_323275_16CBD5C2)
In-Reply-To: <20180608071203.20708-4-luca@coelho.fi>
References: <20180608071203.20708-4-luca@coelho.fi>
Subject: [PATCH v2 3/3] mac80211: add support for HE
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Add support for HE in mac80211 conforming with P802.11ax_D1.4.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Ido Yariv <idox.yariv@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/realtek/rtlwifi/base.c |   2 +-
 include/net/mac80211.h                      |  64 ++++-
 net/mac80211/Makefile                       |   1 +
 net/mac80211/agg-rx.c                       |   8 +-
 net/mac80211/agg-tx.c                       |  19 +-
 net/mac80211/cfg.c                          |   5 +
 net/mac80211/he.c                           |  55 ++++
 net/mac80211/ieee80211_i.h                  |  16 ++
 net/mac80211/main.c                         |  19 +-
 net/mac80211/mlme.c                         | 288 ++++++++++++++++++--
 net/mac80211/rx.c                           | 127 ++++++++-
 net/mac80211/sta_info.c                     |  15 +-
 net/mac80211/sta_info.h                     |  20 +-
 net/mac80211/trace.h                        |   2 +-
 net/mac80211/util.c                         | 120 +++++++-
 net/wireless/core.c                         |   6 +-
 16 files changed, 718 insertions(+), 49 deletions(-)
 create mode 100644 net/mac80211/he.c

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 39c817eddd78..31bd6f714052 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -1904,7 +1904,7 @@ void rtl_rx_ampdu_apply(struct rtl_priv *rtlpriv)
 		 reject_agg, ctrl_agg_size, agg_size);
 
 	rtlpriv->hw->max_rx_aggregation_subframes =
-		(ctrl_agg_size ? agg_size : IEEE80211_MAX_AMPDU_BUF);
+		(ctrl_agg_size ? agg_size : IEEE80211_MAX_AMPDU_BUF_HT);
 }
 EXPORT_SYMBOL(rtl_rx_ampdu_apply);
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 851a5e19ae32..5790f55c241d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -23,6 +23,7 @@
 #include <linux/ieee80211.h>
 #include <net/cfg80211.h>
 #include <net/codel.h>
+#include <net/ieee80211_radiotap.h>
 #include <asm/unaligned.h>
 
 /**
@@ -162,6 +163,8 @@ enum ieee80211_ac_numbers {
  * @txop: maximum burst time in units of 32 usecs, 0 meaning disabled
  * @acm: is mandatory admission control required for the access category
  * @uapsd: is U-APSD mode enabled for the queue
+ * @mu_edca: is the MU EDCA configured
+ * @mu_edca_param_rec: MU EDCA Parameter Record for HE
  */
 struct ieee80211_tx_queue_params {
 	u16 txop;
@@ -170,6 +173,8 @@ struct ieee80211_tx_queue_params {
 	u8 aifs;
 	bool acm;
 	bool uapsd;
+	bool mu_edca;
+	struct ieee80211_he_mu_edca_param_ac_rec mu_edca_param_rec;
 };
 
 struct ieee80211_low_level_stats {
@@ -463,6 +468,15 @@ struct ieee80211_mu_group_data {
  * This structure keeps information about a BSS (and an association
  * to that BSS) that can change during the lifetime of the BSS.
  *
+ * @bss_color: 6-bit value to mark inter-BSS frame, if BSS supports HE
+ * @htc_trig_based_pkt_ext: default PE in 4us units, if BSS supports HE
+ * @multi_sta_back_32bit: supports BA bitmap of 32-bits in Multi-STA BACK
+ * @uora_exists: is the UORA element advertised by AP
+ * @ack_enabled: indicates support to receive a multi-TID that solicits either
+ *	ACK, BACK or both
+ * @uora_ocw_range: UORA element's OCW Range field
+ * @frame_time_rts_th: HE duration RTS threshold, in units of 32us
+ * @he_support: does this BSS support HE
  * @assoc: association status
  * @ibss_joined: indicates whether this station is part of an IBSS
  *	or not
@@ -550,6 +564,14 @@ struct ieee80211_mu_group_data {
  */
 struct ieee80211_bss_conf {
 	const u8 *bssid;
+	u8 bss_color;
+	u8 htc_trig_based_pkt_ext;
+	bool multi_sta_back_32bit;
+	bool uora_exists;
+	bool ack_enabled;
+	u8 uora_ocw_range;
+	u16 frame_time_rts_th;
+	bool he_support;
 	/* association related data */
 	bool assoc, ibss_joined;
 	bool ibss_creator;
@@ -1106,6 +1128,18 @@ ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
  * @RX_FLAG_AMPDU_EOF_BIT: Value of the EOF bit in the A-MPDU delimiter for this
  *	frame
  * @RX_FLAG_AMPDU_EOF_BIT_KNOWN: The EOF value is known
+ * @RX_FLAG_RADIOTAP_HE: HE radiotap data is present
+ *	(&struct ieee80211_radiotap_he, mac80211 will fill in
+ *	 - DATA3_DATA_MCS
+ *	 - DATA3_DATA_DCM
+ *	 - DATA3_CODING
+ *	 - DATA5_GI
+ *	 - DATA5_DATA_BW_RU_ALLOC
+ *	 - DATA6_NSTS
+ *	 - DATA3_STBC
+ *	from the RX info data, so leave those zeroed when building this data)
+ * @RX_FLAG_RADIOTAP_HE_MU: HE MU radiotap data is present
+ *	(&struct ieee80211_radiotap_he_mu)
  */
 enum mac80211_rx_flags {
 	RX_FLAG_MMIC_ERROR		= BIT(0),
@@ -1134,6 +1168,8 @@ enum mac80211_rx_flags {
 	RX_FLAG_ICV_STRIPPED		= BIT(23),
 	RX_FLAG_AMPDU_EOF_BIT		= BIT(24),
 	RX_FLAG_AMPDU_EOF_BIT_KNOWN	= BIT(25),
+	RX_FLAG_RADIOTAP_HE		= BIT(26),
+	RX_FLAG_RADIOTAP_HE_MU		= BIT(27),
 };
 
 /**
@@ -1164,6 +1200,7 @@ enum mac80211_rx_encoding {
 	RX_ENC_LEGACY = 0,
 	RX_ENC_HT,
 	RX_ENC_VHT,
+	RX_ENC_HE,
 };
 
 /**
@@ -1198,6 +1235,9 @@ enum mac80211_rx_encoding {
  * @encoding: &enum mac80211_rx_encoding
  * @bw: &enum rate_info_bw
  * @enc_flags: uses bits from &enum mac80211_rx_encoding_flags
+ * @he_ru: HE RU, from &enum nl80211_he_ru_alloc
+ * @he_gi: HE GI, from &enum nl80211_he_gi
+ * @he_dcm: HE DCM value
  * @rx_flags: internal RX flags for mac80211
  * @ampdu_reference: A-MPDU reference number, must be a different value for
  *	each A-MPDU but the same for each subframe within one A-MPDU
@@ -1211,7 +1251,8 @@ struct ieee80211_rx_status {
 	u32 flag;
 	u16 freq;
 	u8 enc_flags;
-	u8 encoding:2, bw:3;
+	u8 encoding:2, bw:3, he_ru:3;
+	u8 he_gi:2, he_dcm:1;
 	u8 rate_idx;
 	u8 nss;
 	u8 rx_flags;
@@ -1770,6 +1811,7 @@ struct ieee80211_sta_rates {
  * @supp_rates: Bitmap of supported rates (per band)
  * @ht_cap: HT capabilities of this STA; restricted to our own capabilities
  * @vht_cap: VHT capabilities of this STA; restricted to our own capabilities
+ * @he_cap: HE capabilities of this STA
  * @max_rx_aggregation_subframes: maximal amount of frames in a single AMPDU
  *	that this station is allowed to transmit to us.
  *	Can be modified by driver.
@@ -1805,7 +1847,8 @@ struct ieee80211_sta {
 	u16 aid;
 	struct ieee80211_sta_ht_cap ht_cap;
 	struct ieee80211_sta_vht_cap vht_cap;
-	u8 max_rx_aggregation_subframes;
+	struct ieee80211_sta_he_cap he_cap;
+	u16 max_rx_aggregation_subframes;
 	bool wme;
 	u8 uapsd_queues;
 	u8 max_sp;
@@ -2196,10 +2239,11 @@ enum ieee80211_hw_flags {
  *	it shouldn't be set.
  *
  * @max_tx_aggregation_subframes: maximum number of subframes in an
- *	aggregate an HT driver will transmit. Though ADDBA will advertise
- *	a constant value of 64 as some older APs can crash if the window
- *	size is smaller (an example is LinkSys WRT120N with FW v1.0.07
- *	build 002 Jun 18 2012).
+ *	aggregate an HT/HE device will transmit. In HT AddBA we'll
+ *	advertise a constant value of 64 as some older APs crash if
+ *	the window size is smaller (an example is LinkSys WRT120N
+ *	with FW v1.0.07 build 002 Jun 18 2012).
+ *	For AddBA to HE capable peers this value will be used.
  *
  * @max_tx_fragments: maximum number of tx buffers per (A)-MSDU, sum
  *	of 1 + skb_shinfo(skb)->nr_frags for each skb in the frag_list.
@@ -2216,6 +2260,8 @@ enum ieee80211_hw_flags {
  *	the default is _GI | _BANDWIDTH.
  *	Use the %IEEE80211_RADIOTAP_VHT_KNOWN_\* values.
  *
+ * @radiotap_he: HE radiotap validity flags
+ *
  * @radiotap_timestamp: Information for the radiotap timestamp field; if the
  *	'units_pos' member is set to a non-negative value it must be set to
  *	a combination of a IEEE80211_RADIOTAP_TIMESTAMP_UNIT_* and a
@@ -2263,8 +2309,8 @@ struct ieee80211_hw {
 	u8 max_rates;
 	u8 max_report_rates;
 	u8 max_rate_tries;
-	u8 max_rx_aggregation_subframes;
-	u8 max_tx_aggregation_subframes;
+	u16 max_rx_aggregation_subframes;
+	u16 max_tx_aggregation_subframes;
 	u8 max_tx_fragments;
 	u8 offchannel_tx_hw_queue;
 	u8 radiotap_mcs_details;
@@ -2904,7 +2950,7 @@ struct ieee80211_ampdu_params {
 	struct ieee80211_sta *sta;
 	u16 tid;
 	u16 ssn;
-	u8 buf_size;
+	u16 buf_size;
 	bool amsdu;
 	u16 timeout;
 };
diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index e3589ade62e0..bb707789ef2b 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -12,6 +12,7 @@ mac80211-y := \
 	scan.o offchannel.o \
 	ht.o agg-tx.o agg-rx.o \
 	vht.o \
+	he.o \
 	ibss.o \
 	iface.o \
 	rate.o \
diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index e83c19d4c292..530cfd2a400c 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -282,8 +282,12 @@ void ___ieee80211_start_rx_ba_session(struct sta_info *sta,
 		goto end;
 	}
 	/* determine default buffer size */
-	if (buf_size == 0)
-		buf_size = IEEE80211_MAX_AMPDU_BUF;
+	if (buf_size == 0) {
+		if (sta->sta.he_cap.has_he)
+			buf_size = IEEE80211_MAX_AMPDU_BUF;
+		else
+			buf_size = IEEE80211_MAX_AMPDU_BUF_HT;
+	}
 
 	/* make sure the size doesn't exceed the maximum supported by the hw */
 	if (buf_size > sta->sta.max_rx_aggregation_subframes)
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index ac4295296514..69e831bc317b 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -463,6 +463,7 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 		.timeout = 0,
 	};
 	int ret;
+	u16 buf_size;
 
 	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
 
@@ -511,11 +512,22 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 	sta->ampdu_mlme.addba_req_num[tid]++;
 	spin_unlock_bh(&sta->lock);
 
+	if (sta->sta.he_cap.has_he) {
+		buf_size = local->hw.max_tx_aggregation_subframes;
+	} else {
+		/*
+		 * We really should use what the driver told us it will
+		 * transmit as the maximum, but certain APs (e.g. the
+		 * LinkSys WRT120N with FW v1.0.07 build 002 Jun 18 2012)
+		 * will crash when we use a lower number.
+		 */
+		buf_size = IEEE80211_MAX_AMPDU_BUF_HT;
+	}
+
 	/* send AddBA request */
 	ieee80211_send_addba_request(sdata, sta->sta.addr, tid,
 				     tid_tx->dialog_token, params.ssn,
-				     IEEE80211_MAX_AMPDU_BUF,
-				     tid_tx->timeout);
+				     buf_size, tid_tx->timeout);
 }
 
 /*
@@ -905,8 +917,7 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
 {
 	struct tid_ampdu_tx *tid_tx;
 	struct ieee80211_txq *txq;
-	u16 capab, tid;
-	u8 buf_size;
+	u16 capab, tid, buf_size;
 	bool amsdu;
 
 	capab = le16_to_cpu(mgmt->u.action.u.addba_resp.capab);
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index bdf6fa78d0d2..fed27225beb9 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1412,6 +1412,11 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 		ieee80211_vht_cap_ie_to_sta_vht_cap(sdata, sband,
 						    params->vht_capa, sta);
 
+	if (params->he_capa)
+		ieee80211_he_cap_ie_to_sta_he_cap(sdata, sband,
+						  (void *)params->he_capa,
+						  params->he_capa_len, sta);
+
 	if (params->opmode_notif_used) {
 		/* returned value is only needed for rc update, but the
 		 * rc isn't initialized here yet, so ignore it
diff --git a/net/mac80211/he.c b/net/mac80211/he.c
new file mode 100644
index 000000000000..769078ed5a12
--- /dev/null
+++ b/net/mac80211/he.c
@@ -0,0 +1,55 @@
+/*
+ * HE handling
+ *
+ * Copyright(c) 2017 Intel Deutschland GmbH
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "ieee80211_i.h"
+
+void
+ieee80211_he_cap_ie_to_sta_he_cap(struct ieee80211_sub_if_data *sdata,
+				  struct ieee80211_supported_band *sband,
+				  const u8 *he_cap_ie, u8 he_cap_len,
+				  struct sta_info *sta)
+{
+	struct ieee80211_sta_he_cap *he_cap = &sta->sta.he_cap;
+	struct ieee80211_he_cap_elem *he_cap_ie_elem = (void *)he_cap_ie;
+	u8 he_ppe_size;
+	u8 mcs_nss_size;
+	u8 he_total_size;
+
+	memset(he_cap, 0, sizeof(*he_cap));
+
+	if (!he_cap_ie || !ieee80211_get_he_sta_cap(sband))
+		return;
+
+	/* Make sure size is OK */
+	mcs_nss_size = ieee80211_he_mcs_nss_size(he_cap_ie_elem);
+	he_ppe_size =
+		ieee80211_he_ppe_size(he_cap_ie[sizeof(he_cap->he_cap_elem) +
+						mcs_nss_size],
+				      he_cap_ie_elem->phy_cap_info);
+	he_total_size = sizeof(he_cap->he_cap_elem) + mcs_nss_size +
+			he_ppe_size;
+	if (he_cap_len < he_total_size)
+		return;
+
+	memcpy(&he_cap->he_cap_elem, he_cap_ie, sizeof(he_cap->he_cap_elem));
+
+	/* HE Tx/Rx HE MCS NSS Support Field */
+	memcpy(&he_cap->he_mcs_nss_supp,
+	       &he_cap_ie[sizeof(he_cap->he_cap_elem)], mcs_nss_size);
+
+	/* Check if there are (optional) PPE Thresholds */
+	if (he_cap->he_cap_elem.phy_cap_info[6] &
+	    IEEE80211_HE_PHY_CAP6_PPE_THRESHOLD_PRESENT)
+		memcpy(he_cap->ppe_thres,
+		       &he_cap_ie[sizeof(he_cap->he_cap_elem) + mcs_nss_size],
+		       he_ppe_size);
+
+	he_cap->has_he = true;
+}
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d1978aa1c15d..27e5e2e8f633 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -364,6 +364,7 @@ enum ieee80211_sta_flags {
 	IEEE80211_STA_DISABLE_160MHZ	= BIT(13),
 	IEEE80211_STA_DISABLE_WMM	= BIT(14),
 	IEEE80211_STA_ENABLE_RRM	= BIT(15),
+	IEEE80211_STA_DISABLE_HE	= BIT(16),
 };
 
 struct ieee80211_mgd_auth_data {
@@ -1453,6 +1454,10 @@ struct ieee802_11_elems {
 	const struct ieee80211_vht_cap *vht_cap_elem;
 	const struct ieee80211_vht_operation *vht_operation;
 	const struct ieee80211_meshconf_ie *mesh_config;
+	const u8 *he_cap;
+	const struct ieee80211_he_operation *he_operation;
+	const struct ieee80211_mu_edca_param_set *mu_edca_param_set;
+	const u8 *uora_element;
 	const u8 *mesh_id;
 	const u8 *peering;
 	const __le16 *awake_window;
@@ -1482,6 +1487,7 @@ struct ieee802_11_elems {
 	u8 ext_supp_rates_len;
 	u8 wmm_info_len;
 	u8 wmm_param_len;
+	u8 he_cap_len;
 	u8 mesh_id_len;
 	u8 peering_len;
 	u8 preq_len;
@@ -1824,6 +1830,13 @@ void ieee80211_get_vht_mask_from_cap(__le16 vht_cap,
 enum nl80211_chan_width
 ieee80211_sta_rx_bw_to_chan_width(struct sta_info *sta);
 
+/* HE */
+void
+ieee80211_he_cap_ie_to_sta_he_cap(struct ieee80211_sub_if_data *sdata,
+				  struct ieee80211_supported_band *sband,
+				  const u8 *he_cap_ie, u8 he_cap_len,
+				  struct sta_info *sta);
+
 /* Spectrum management */
 void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
 				       struct ieee80211_mgmt *mgmt,
@@ -2073,6 +2086,9 @@ u8 *ieee80211_ie_build_vht_cap(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
 			       u32 cap);
 u8 *ieee80211_ie_build_vht_oper(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
 				const struct cfg80211_chan_def *chandef);
+u8 *ieee80211_ie_build_he_cap(u8 *pos,
+			      const struct ieee80211_sta_he_cap *he_cap,
+			      u8 *end);
 int ieee80211_parse_bitrates(struct cfg80211_chan_def *chandef,
 			     const struct ieee80211_supported_band *sband,
 			     const u8 *srates, int srates_len, u32 *rates);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 4d2e797e3f16..1fa3c9ccf44e 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -3,6 +3,7 @@
  * Copyright 2005-2006, Devicescape Software, Inc.
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
+ * Copyright (C) 2017     Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -816,7 +817,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	int result, i;
 	enum nl80211_band band;
 	int channels, max_bitrates;
-	bool supp_ht, supp_vht;
+	bool supp_ht, supp_vht, supp_he;
 	netdev_features_t feature_whitelist;
 	struct cfg80211_chan_def dflt_chandef = {};
 
@@ -896,6 +897,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	max_bitrates = 0;
 	supp_ht = false;
 	supp_vht = false;
+	supp_he = false;
 	for (band = 0; band < NUM_NL80211_BANDS; band++) {
 		struct ieee80211_supported_band *sband;
 
@@ -922,6 +924,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		supp_ht = supp_ht || sband->ht_cap.ht_supported;
 		supp_vht = supp_vht || sband->vht_cap.vht_supported;
 
+		if (!supp_he)
+			supp_he = !!ieee80211_get_he_sta_cap(sband);
+
 		if (!sband->ht_cap.ht_supported)
 			continue;
 
@@ -1011,6 +1016,18 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		local->scan_ies_len +=
 			2 + sizeof(struct ieee80211_vht_cap);
 
+	/* HE cap element is variable in size - set len to allow max size */
+	/*
+	 * TODO: 1 is added at the end of the calculation to accommodate for
+	 *	the temporary placing of the HE capabilities IE under EXT.
+	 *	Remove it once it is placed in the final place.
+	 */
+	if (supp_he)
+		local->scan_ies_len +=
+			2 + sizeof(struct ieee80211_he_cap_elem) +
+			sizeof(struct ieee80211_he_mcs_nss_supp) +
+			IEEE80211_HE_PPE_THRES_MAX_LEN + 1;
+
 	if (!local->ops->hw_scan) {
 		/* For hw_scan, driver needs to set these up. */
 		local->hw.wiphy->max_scan_ssids = 4;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index a59187c016e0..b28fa9ffdd13 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -149,6 +149,7 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 			     struct ieee80211_channel *channel,
 			     const struct ieee80211_ht_operation *ht_oper,
 			     const struct ieee80211_vht_operation *vht_oper,
+			     const struct ieee80211_he_operation *he_oper,
 			     struct cfg80211_chan_def *chandef, bool tracking)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
@@ -207,7 +208,27 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 	}
 
 	vht_chandef = *chandef;
-	if (!ieee80211_chandef_vht_oper(vht_oper, &vht_chandef)) {
+	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_HE) && he_oper &&
+	    (le32_to_cpu(he_oper->he_oper_params) &
+	     IEEE80211_HE_OPERATION_VHT_OPER_INFO)) {
+		struct ieee80211_vht_operation he_oper_vht_cap;
+
+		/*
+		 * Set only first 3 bytes (other 2 aren't used in
+		 * ieee80211_chandef_vht_oper() anyway)
+		 */
+		memcpy(&he_oper_vht_cap, he_oper->optional, 3);
+		he_oper_vht_cap.basic_mcs_set = cpu_to_le16(0);
+
+		if (!ieee80211_chandef_vht_oper(&he_oper_vht_cap,
+						&vht_chandef)) {
+			if (!(ifmgd->flags & IEEE80211_STA_DISABLE_HE))
+				sdata_info(sdata,
+					   "HE AP VHT information is invalid, disable HE\n");
+			ret = IEEE80211_STA_DISABLE_HE;
+			goto out;
+		}
+	} else if (!ieee80211_chandef_vht_oper(vht_oper, &vht_chandef)) {
 		if (!(ifmgd->flags & IEEE80211_STA_DISABLE_VHT))
 			sdata_info(sdata,
 				   "AP VHT information is invalid, disable VHT\n");
@@ -300,12 +321,14 @@ static int ieee80211_config_bw(struct ieee80211_sub_if_data *sdata,
 			       const struct ieee80211_ht_cap *ht_cap,
 			       const struct ieee80211_ht_operation *ht_oper,
 			       const struct ieee80211_vht_operation *vht_oper,
+			       const struct ieee80211_he_operation *he_oper,
 			       const u8 *bssid, u32 *changed)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	struct ieee80211_supported_band *sband;
-	struct ieee80211_channel *chan;
+	struct ieee80211_channel *chan = sdata->vif.bss_conf.chandef.chan;
+	struct ieee80211_supported_band *sband =
+		local->hw.wiphy->bands[chan->band];
 	struct cfg80211_chan_def chandef;
 	u16 ht_opmode;
 	u32 flags;
@@ -320,6 +343,11 @@ static int ieee80211_config_bw(struct ieee80211_sub_if_data *sdata,
 	if (ifmgd->flags & IEEE80211_STA_DISABLE_VHT)
 		vht_oper = NULL;
 
+	/* don't check HE if we associated as non-HE station */
+	if (ifmgd->flags & IEEE80211_STA_DISABLE_HE ||
+	    !ieee80211_get_he_sta_cap(sband))
+		he_oper = NULL;
+
 	if (WARN_ON_ONCE(!sta))
 		return -EINVAL;
 
@@ -333,12 +361,9 @@ static int ieee80211_config_bw(struct ieee80211_sub_if_data *sdata,
 		sdata->vif.bss_conf.ht_operation_mode = ht_opmode;
 	}
 
-	chan = sdata->vif.bss_conf.chandef.chan;
-	sband = local->hw.wiphy->bands[chan->band];
-
-	/* calculate new channel (type) based on HT/VHT operation IEs */
+	/* calculate new channel (type) based on HT/VHT/HE operation IEs */
 	flags = ieee80211_determine_chantype(sdata, sband, chan,
-					     ht_oper, vht_oper,
+					     ht_oper, vht_oper, he_oper,
 					     &chandef, true);
 
 	/*
@@ -582,6 +607,34 @@ static void ieee80211_add_vht_ie(struct ieee80211_sub_if_data *sdata,
 	ieee80211_ie_build_vht_cap(pos, &vht_cap, cap);
 }
 
+/* This function determines HE capability flags for the association
+ * and builds the IE.
+ */
+static void ieee80211_add_he_ie(struct ieee80211_sub_if_data *sdata,
+				struct sk_buff *skb,
+				struct ieee80211_supported_band *sband)
+{
+	u8 *pos;
+	const struct ieee80211_sta_he_cap *he_cap = NULL;
+	u8 he_cap_size;
+
+	he_cap = ieee80211_get_he_sta_cap(sband);
+	if (!he_cap)
+		return;
+
+	/*
+	 * TODO: the 1 added is because this temporarily is under the EXTENSION
+	 * IE. Get rid of it when it moves.
+	 */
+	he_cap_size =
+		2 + 1 + sizeof(he_cap->he_cap_elem) +
+		ieee80211_he_mcs_nss_size(&he_cap->he_cap_elem) +
+		ieee80211_he_ppe_size(he_cap->ppe_thres[0],
+				      he_cap->he_cap_elem.phy_cap_info);
+	pos = skb_put(skb, he_cap_size);
+	ieee80211_ie_build_he_cap(pos, he_cap, pos + he_cap_size);
+}
+
 static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
@@ -643,6 +696,9 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 			2 + 2 * sband->n_channels + /* supported channels */
 			2 + sizeof(struct ieee80211_ht_cap) + /* HT */
 			2 + sizeof(struct ieee80211_vht_cap) + /* VHT */
+			2 + 1 + sizeof(struct ieee80211_he_cap_elem) + /* HE */
+				sizeof(struct ieee80211_he_mcs_nss_supp) +
+				IEEE80211_HE_PPE_THRES_MAX_LEN +
 			assoc_data->ie_len + /* extra IEs */
 			(assoc_data->fils_kek_len ? 16 /* AES-SIV */ : 0) +
 			9, /* WMM */
@@ -827,11 +883,41 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 		offset = noffset;
 	}
 
+	/* if present, add any custom IEs that go before HE */
+	if (assoc_data->ie_len) {
+		static const u8 before_he[] = {
+			/*
+			 * no need to list the ones split off before VHT
+			 * or generated here
+			 */
+			WLAN_EID_OPMODE_NOTIF,
+			WLAN_EID_EXTENSION, WLAN_EID_EXT_FUTURE_CHAN_GUIDANCE,
+			/* 11ai elements */
+			WLAN_EID_EXTENSION, WLAN_EID_EXT_FILS_SESSION,
+			WLAN_EID_EXTENSION, WLAN_EID_EXT_FILS_PUBLIC_KEY,
+			WLAN_EID_EXTENSION, WLAN_EID_EXT_FILS_KEY_CONFIRM,
+			WLAN_EID_EXTENSION, WLAN_EID_EXT_FILS_HLP_CONTAINER,
+			WLAN_EID_EXTENSION, WLAN_EID_EXT_FILS_IP_ADDR_ASSIGN,
+			/* TODO: add 11ah/11aj/11ak elements */
+		};
+
+		/* RIC already taken above, so no need to handle here anymore */
+		noffset = ieee80211_ie_split(assoc_data->ie, assoc_data->ie_len,
+					     before_he, ARRAY_SIZE(before_he),
+					     offset);
+		pos = skb_put(skb, noffset - offset);
+		memcpy(pos, assoc_data->ie + offset, noffset - offset);
+		offset = noffset;
+	}
+
 	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_VHT))
 		ieee80211_add_vht_ie(sdata, skb, sband,
 				     &assoc_data->ap_vht_cap);
 
-	/* if present, add any custom non-vendor IEs that go after HT */
+	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_HE))
+		ieee80211_add_he_ie(sdata, skb, sband);
+
+	/* if present, add any custom non-vendor IEs that go after HE */
 	if (assoc_data->ie_len) {
 		noffset = ieee80211_ie_split_vendor(assoc_data->ie,
 						    assoc_data->ie_len,
@@ -898,6 +984,11 @@ void ieee80211_send_nullfunc(struct ieee80211_local *local,
 	struct ieee80211_hdr_3addr *nullfunc;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
+	/* Don't send NDPs when STA is connected HE */
+	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
+	    !(ifmgd->flags & IEEE80211_STA_DISABLE_HE))
+		return;
+
 	skb = ieee80211_nullfunc_get(&local->hw, &sdata->vif,
 		!ieee80211_hw_check(&local->hw, DOESNT_SUPPORT_QOS_NDP));
 	if (!skb)
@@ -929,6 +1020,10 @@ static void ieee80211_send_4addr_nullfunc(struct ieee80211_local *local,
 	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_STATION))
 		return;
 
+	/* Don't send NDPs when connected HE */
+	if (!(sdata->u.mgd.flags & IEEE80211_STA_DISABLE_HE))
+		return;
+
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom + 30);
 	if (!skb)
 		return;
@@ -1700,9 +1795,11 @@ static void ieee80211_sta_handle_tspec_ac_params_wk(struct work_struct *work)
 }
 
 /* MLME */
-static bool ieee80211_sta_wmm_params(struct ieee80211_local *local,
-				     struct ieee80211_sub_if_data *sdata,
-				     const u8 *wmm_param, size_t wmm_param_len)
+static bool
+ieee80211_sta_wmm_params(struct ieee80211_local *local,
+			 struct ieee80211_sub_if_data *sdata,
+			 const u8 *wmm_param, size_t wmm_param_len,
+			 const struct ieee80211_mu_edca_param_set *mu_edca)
 {
 	struct ieee80211_tx_queue_params params[IEEE80211_NUM_ACS];
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
@@ -1749,6 +1846,9 @@ static bool ieee80211_sta_wmm_params(struct ieee80211_local *local,
 				sdata->wmm_acm |= BIT(1) | BIT(2); /* BK/- */
 			if (uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_BK)
 				uapsd = true;
+			params[ac].mu_edca = !!mu_edca;
+			if (mu_edca)
+				params[ac].mu_edca_param_rec = mu_edca->ac_bk;
 			break;
 		case 2: /* AC_VI */
 			ac = IEEE80211_AC_VI;
@@ -1756,6 +1856,9 @@ static bool ieee80211_sta_wmm_params(struct ieee80211_local *local,
 				sdata->wmm_acm |= BIT(4) | BIT(5); /* CL/VI */
 			if (uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_VI)
 				uapsd = true;
+			params[ac].mu_edca = !!mu_edca;
+			if (mu_edca)
+				params[ac].mu_edca_param_rec = mu_edca->ac_vi;
 			break;
 		case 3: /* AC_VO */
 			ac = IEEE80211_AC_VO;
@@ -1763,6 +1866,9 @@ static bool ieee80211_sta_wmm_params(struct ieee80211_local *local,
 				sdata->wmm_acm |= BIT(6) | BIT(7); /* VO/NC */
 			if (uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_VO)
 				uapsd = true;
+			params[ac].mu_edca = !!mu_edca;
+			if (mu_edca)
+				params[ac].mu_edca_param_rec = mu_edca->ac_vo;
 			break;
 		case 0: /* AC_BE */
 		default:
@@ -1771,6 +1877,9 @@ static bool ieee80211_sta_wmm_params(struct ieee80211_local *local,
 				sdata->wmm_acm |= BIT(0) | BIT(3); /* BE/EE */
 			if (uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_BE)
 				uapsd = true;
+			params[ac].mu_edca = !!mu_edca;
+			if (mu_edca)
+				params[ac].mu_edca_param_rec = mu_edca->ac_be;
 			break;
 		}
 
@@ -3008,6 +3117,25 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 		goto out;
 	}
 
+	/*
+	 * If AP doesn't support HT, or it doesn't have HE mandatory IEs, mark
+	 * HE as disabled. If on the 5GHz band, make sure it supports VHT.
+	 */
+	if (ifmgd->flags & IEEE80211_STA_DISABLE_HT ||
+	    (sband->band == NL80211_BAND_5GHZ &&
+	     ifmgd->flags & IEEE80211_STA_DISABLE_VHT) ||
+	    (!elems.he_cap && !elems.he_operation))
+		ifmgd->flags |= IEEE80211_STA_DISABLE_HE;
+
+	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_HE) &&
+	    (!elems.he_cap || !elems.he_operation)) {
+		mutex_unlock(&sdata->local->sta_mtx);
+		sdata_info(sdata,
+			   "HE AP is missing HE capability/operation\n");
+		ret = false;
+		goto out;
+	}
+
 	/* Set up internal HT/VHT capabilities */
 	if (elems.ht_cap_elem && !(ifmgd->flags & IEEE80211_STA_DISABLE_HT))
 		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
@@ -3017,6 +3145,48 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 		ieee80211_vht_cap_ie_to_sta_vht_cap(sdata, sband,
 						    elems.vht_cap_elem, sta);
 
+	if (elems.he_operation && !(ifmgd->flags & IEEE80211_STA_DISABLE_HE) &&
+	    elems.he_cap) {
+		ieee80211_he_cap_ie_to_sta_he_cap(sdata, sband,
+						  elems.he_cap,
+						  elems.he_cap_len,
+						  sta);
+
+		bss_conf->he_support = sta->sta.he_cap.has_he;
+	} else {
+		bss_conf->he_support = false;
+	}
+
+	if (bss_conf->he_support) {
+		u32 he_oper_params =
+			le32_to_cpu(elems.he_operation->he_oper_params);
+
+		bss_conf->bss_color = he_oper_params &
+				      IEEE80211_HE_OPERATION_BSS_COLOR_MASK;
+		bss_conf->htc_trig_based_pkt_ext =
+			(he_oper_params &
+			 IEEE80211_HE_OPERATION_DFLT_PE_DURATION_MASK) <<
+			IEEE80211_HE_OPERATION_DFLT_PE_DURATION_OFFSET;
+		bss_conf->frame_time_rts_th =
+			(he_oper_params &
+			 IEEE80211_HE_OPERATION_RTS_THRESHOLD_MASK) <<
+			IEEE80211_HE_OPERATION_RTS_THRESHOLD_OFFSET;
+
+		bss_conf->multi_sta_back_32bit =
+			sta->sta.he_cap.he_cap_elem.mac_cap_info[2] &
+			IEEE80211_HE_MAC_CAP2_32BIT_BA_BITMAP;
+
+		bss_conf->ack_enabled =
+			sta->sta.he_cap.he_cap_elem.mac_cap_info[2] &
+			IEEE80211_HE_MAC_CAP2_ACK_EN;
+
+		bss_conf->uora_exists = !!elems.uora_element;
+		if (elems.uora_element)
+			bss_conf->uora_ocw_range = elems.uora_element[0];
+
+		/* TODO: OPEN: what happens if BSS color disable is set? */
+	}
+
 	/*
 	 * Some APs, e.g. Netgear WNDR3700, report invalid HT operation data
 	 * in their association response, so ignore that data for our own
@@ -3076,7 +3246,8 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 	if (ifmgd->flags & IEEE80211_STA_DISABLE_WMM) {
 		ieee80211_set_wmm_default(sdata, false, false);
 	} else if (!ieee80211_sta_wmm_params(local, sdata, elems.wmm_param,
-					     elems.wmm_param_len)) {
+					     elems.wmm_param_len,
+					     elems.mu_edca_param_set)) {
 		/* still enable QoS since we might have HT/VHT */
 		ieee80211_set_wmm_default(sdata, false, true);
 		/* set the disable-WMM flag in this case to disable
@@ -3590,7 +3761,8 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 
 	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_WMM) &&
 	    ieee80211_sta_wmm_params(local, sdata, elems.wmm_param,
-				     elems.wmm_param_len))
+				     elems.wmm_param_len,
+				     elems.mu_edca_param_set))
 		changed |= BSS_CHANGED_QOS;
 
 	/*
@@ -3629,7 +3801,8 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 
 	if (ieee80211_config_bw(sdata, sta,
 				elems.ht_cap_elem, elems.ht_operation,
-				elems.vht_operation, bssid, &changed)) {
+				elems.vht_operation, elems.he_operation,
+				bssid, &changed)) {
 		mutex_unlock(&local->sta_mtx);
 		sdata_info(sdata,
 			   "failed to follow AP %pM bandwidth change, disconnect\n",
@@ -4266,6 +4439,66 @@ static u8 ieee80211_ht_vht_rx_chains(struct ieee80211_sub_if_data *sdata,
 	return chains;
 }
 
+static bool
+ieee80211_verify_sta_he_mcs_support(struct ieee80211_supported_band *sband,
+				    const struct ieee80211_he_operation *he_op)
+{
+	const struct ieee80211_sta_he_cap *sta_he_cap =
+		ieee80211_get_he_sta_cap(sband);
+	u16 ap_min_req_set = le16_to_cpu(he_op->he_mcs_nss_set);
+	int i;
+
+	if (!sta_he_cap || !he_op)
+		return false;
+
+	/* Need to go over for 80MHz, 160MHz and for 80+80 */
+	for (i = 0; i < 3; i++) {
+		const struct ieee80211_he_mcs_nss_supp *sta_mcs_nss_supp =
+			&sta_he_cap->he_mcs_nss_supp;
+		u16 sta_mcs_map_rx =
+			le16_to_cpu(((__le16 *)sta_mcs_nss_supp)[2 * i]);
+		u16 sta_mcs_map_tx =
+			le16_to_cpu(((__le16 *)sta_mcs_nss_supp)[2 * i + 1]);
+		u8 nss;
+		bool verified = true;
+
+		/*
+		 * For each band there is a maximum of 8 spatial streams
+		 * possible. Each of the sta_mcs_map_* is a 16-bit struct built
+		 * of 2 bits per NSS (1-8), with the values defined in enum
+		 * ieee80211_he_mcs_support. Need to make sure STA TX and RX
+		 * capabilities aren't less than the AP's minimum requirements
+		 * for this HE BSS per SS.
+		 * It is enough to find one such band that meets the reqs.
+		 */
+		for (nss = 8; nss > 0; nss--) {
+			u8 sta_rx_val = (sta_mcs_map_rx >> (2 * (nss - 1))) & 3;
+			u8 sta_tx_val = (sta_mcs_map_tx >> (2 * (nss - 1))) & 3;
+			u8 ap_val = (ap_min_req_set >> (2 * (nss - 1))) & 3;
+
+			if (ap_val == IEEE80211_HE_MCS_NOT_SUPPORTED)
+				continue;
+
+			/*
+			 * Make sure the HE AP doesn't require MCSs that aren't
+			 * supported by the client
+			 */
+			if (sta_rx_val == IEEE80211_HE_MCS_NOT_SUPPORTED ||
+			    sta_tx_val == IEEE80211_HE_MCS_NOT_SUPPORTED ||
+			    (ap_val > sta_rx_val) || (ap_val > sta_tx_val)) {
+				verified = false;
+				break;
+			}
+		}
+
+		if (verified)
+			return true;
+	}
+
+	/* If here, STA doesn't meet AP's HE min requirements */
+	return false;
+}
+
 static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 				  struct cfg80211_bss *cbss)
 {
@@ -4274,6 +4507,7 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 	const struct ieee80211_ht_cap *ht_cap = NULL;
 	const struct ieee80211_ht_operation *ht_oper = NULL;
 	const struct ieee80211_vht_operation *vht_oper = NULL;
+	const struct ieee80211_he_operation *he_oper = NULL;
 	struct ieee80211_supported_band *sband;
 	struct cfg80211_chan_def chandef;
 	int ret;
@@ -4329,6 +4563,25 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
+	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_HE) &&
+	    ieee80211_get_he_sta_cap(sband)) {
+		const struct cfg80211_bss_ies *ies;
+		const u8 *he_oper_ie;
+
+		ies = rcu_dereference(cbss->ies);
+		he_oper_ie = cfg80211_find_ext_ie(WLAN_EID_EXT_HE_OPERATION,
+						  ies->data, ies->len);
+		if (he_oper_ie &&
+		    he_oper_ie[1] == ieee80211_he_oper_size(&he_oper_ie[3]))
+			he_oper = (void *)(he_oper_ie + 3);
+		else
+			he_oper = NULL;
+
+		if (!he_oper ||
+		    !ieee80211_verify_sta_he_mcs_support(sband, he_oper))
+			ifmgd->flags |= IEEE80211_STA_DISABLE_HE;
+	}
+
 	/* Allow VHT if at least one channel on the sband supports 80 MHz */
 	have_80mhz = false;
 	for (i = 0; i < sband->n_channels; i++) {
@@ -4345,7 +4598,7 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 
 	ifmgd->flags |= ieee80211_determine_chantype(sdata, sband,
 						     cbss->channel,
-						     ht_oper, vht_oper,
+						     ht_oper, vht_oper, he_oper,
 						     &chandef, false);
 
 	sdata->needed_rx_chains = min(ieee80211_ht_vht_rx_chains(sdata, cbss),
@@ -4751,8 +5004,9 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 		    req->crypto.ciphers_pairwise[i] == WLAN_CIPHER_SUITE_WEP104) {
 			ifmgd->flags |= IEEE80211_STA_DISABLE_HT;
 			ifmgd->flags |= IEEE80211_STA_DISABLE_VHT;
+			ifmgd->flags |= IEEE80211_STA_DISABLE_HE;
 			netdev_info(sdata->dev,
-				    "disabling HT/VHT due to WEP/TKIP use\n");
+				    "disabling HE/HT/VHT due to WEP/TKIP use\n");
 		}
 	}
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 0a38cc1cbebc..7b173fb66530 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -175,6 +175,20 @@ ieee80211_rx_radiotap_hdrlen(struct ieee80211_local *local,
 		len += 12;
 	}
 
+	if (status->encoding == RX_ENC_HE &&
+	    status->flag & RX_FLAG_RADIOTAP_HE) {
+		len = ALIGN(len, 2);
+		len += 12;
+		BUILD_BUG_ON(sizeof(struct ieee80211_radiotap_he) != 12);
+	}
+
+	if (status->encoding == RX_ENC_HE &&
+	    status->flag & RX_FLAG_RADIOTAP_HE_MU) {
+		len = ALIGN(len, 2);
+		len += 12;
+		BUILD_BUG_ON(sizeof(struct ieee80211_radiotap_he_mu) != 12);
+	}
+
 	if (status->chains) {
 		/* antenna and antenna signal fields */
 		len += 2 * hweight8(status->chains);
@@ -263,6 +277,19 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	int mpdulen, chain;
 	unsigned long chains = status->chains;
 	struct ieee80211_vendor_radiotap rtap = {};
+	struct ieee80211_radiotap_he he = {};
+	struct ieee80211_radiotap_he_mu he_mu = {};
+
+	if (status->flag & RX_FLAG_RADIOTAP_HE) {
+		he = *(struct ieee80211_radiotap_he *)skb->data;
+		skb_pull(skb, sizeof(he));
+		WARN_ON_ONCE(status->encoding != RX_ENC_HE);
+	}
+
+	if (status->flag & RX_FLAG_RADIOTAP_HE_MU) {
+		he_mu = *(struct ieee80211_radiotap_he_mu *)skb->data;
+		skb_pull(skb, sizeof(he_mu));
+	}
 
 	if (status->flag & RX_FLAG_RADIOTAP_VENDOR_DATA) {
 		rtap = *(struct ieee80211_vendor_radiotap *)skb->data;
@@ -520,6 +547,89 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		*pos++ = flags;
 	}
 
+	if (status->encoding == RX_ENC_HE &&
+	    status->flag & RX_FLAG_RADIOTAP_HE) {
+#define HE_PREP(f, val)	cpu_to_le16(FIELD_PREP(IEEE80211_RADIOTAP_HE_##f, val))
+
+		if (status->enc_flags & RX_ENC_FLAG_STBC_MASK) {
+			he.data6 |= HE_PREP(DATA6_NSTS,
+					    FIELD_GET(RX_ENC_FLAG_STBC_MASK,
+						      status->enc_flags));
+			he.data3 |= HE_PREP(DATA3_STBC, 1);
+		} else {
+			he.data6 |= HE_PREP(DATA6_NSTS, status->nss);
+		}
+
+#define CHECK_GI(s) \
+	BUILD_BUG_ON(IEEE80211_RADIOTAP_HE_DATA5_GI_##s != \
+		     (int)NL80211_RATE_INFO_HE_GI_##s)
+
+		CHECK_GI(0_8);
+		CHECK_GI(1_6);
+		CHECK_GI(3_2);
+
+		he.data3 |= HE_PREP(DATA3_DATA_MCS, status->rate_idx);
+		he.data3 |= HE_PREP(DATA3_DATA_DCM, status->he_dcm);
+		he.data3 |= HE_PREP(DATA3_CODING,
+				    !!(status->enc_flags & RX_ENC_FLAG_LDPC));
+
+		he.data5 |= HE_PREP(DATA5_GI, status->he_gi);
+
+		switch (status->bw) {
+		case RATE_INFO_BW_20:
+			he.data5 |= HE_PREP(DATA5_DATA_BW_RU_ALLOC,
+					    IEEE80211_RADIOTAP_HE_DATA5_DATA_BW_RU_ALLOC_20MHZ);
+			break;
+		case RATE_INFO_BW_40:
+			he.data5 |= HE_PREP(DATA5_DATA_BW_RU_ALLOC,
+					    IEEE80211_RADIOTAP_HE_DATA5_DATA_BW_RU_ALLOC_40MHZ);
+			break;
+		case RATE_INFO_BW_80:
+			he.data5 |= HE_PREP(DATA5_DATA_BW_RU_ALLOC,
+					    IEEE80211_RADIOTAP_HE_DATA5_DATA_BW_RU_ALLOC_80MHZ);
+			break;
+		case RATE_INFO_BW_160:
+			he.data5 |= HE_PREP(DATA5_DATA_BW_RU_ALLOC,
+					    IEEE80211_RADIOTAP_HE_DATA5_DATA_BW_RU_ALLOC_160MHZ);
+			break;
+		case RATE_INFO_BW_HE_RU:
+#define CHECK_RU_ALLOC(s) \
+	BUILD_BUG_ON(IEEE80211_RADIOTAP_HE_DATA5_DATA_BW_RU_ALLOC_##s##T != \
+		     NL80211_RATE_INFO_HE_RU_ALLOC_##s + 4)
+
+			CHECK_RU_ALLOC(26);
+			CHECK_RU_ALLOC(52);
+			CHECK_RU_ALLOC(106);
+			CHECK_RU_ALLOC(242);
+			CHECK_RU_ALLOC(484);
+			CHECK_RU_ALLOC(996);
+			CHECK_RU_ALLOC(2x996);
+
+			he.data5 |= HE_PREP(DATA5_DATA_BW_RU_ALLOC,
+					    status->he_ru + 4);
+			break;
+		default:
+			WARN_ONCE(1, "Invalid SU BW %d\n", status->bw);
+		}
+
+		/* ensure 2 byte alignment */
+		while ((pos - (u8 *)rthdr) & 1)
+			pos++;
+		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_HE);
+		memcpy(pos, &he, sizeof(he));
+		pos += sizeof(he);
+	}
+
+	if (status->encoding == RX_ENC_HE &&
+	    status->flag & RX_FLAG_RADIOTAP_HE_MU) {
+		/* ensure 2 byte alignment */
+		while ((pos - (u8 *)rthdr) & 1)
+			pos++;
+		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_HE_MU);
+		memcpy(pos, &he_mu, sizeof(he_mu));
+		pos += sizeof(he_mu);
+	}
+
 	for_each_set_bit(chain, &chains, IEEE80211_MAX_CHAINS) {
 		*pos++ = status->chain_signal[chain];
 		*pos++ = chain;
@@ -613,6 +723,12 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 		rcu_dereference(local->monitor_sdata);
 	bool only_monitor = false;
 
+	if (status->flag & RX_FLAG_RADIOTAP_HE)
+		rtap_space += sizeof(struct ieee80211_radiotap_he);
+
+	if (status->flag & RX_FLAG_RADIOTAP_HE_MU)
+		rtap_space += sizeof(struct ieee80211_radiotap_he_mu);
+
 	if (unlikely(status->flag & RX_FLAG_RADIOTAP_VENDOR_DATA)) {
 		struct ieee80211_vendor_radiotap *rtap = (void *)origskb->data;
 
@@ -3386,8 +3502,7 @@ static void ieee80211_rx_handlers_result(struct ieee80211_rx_data *rx,
 		status = IEEE80211_SKB_RXCB((rx->skb));
 
 		sband = rx->local->hw.wiphy->bands[status->band];
-		if (!(status->encoding == RX_ENC_HT) &&
-		    !(status->encoding == RX_ENC_VHT))
+		if (status->encoding == RX_ENC_LEGACY)
 			rate = &sband->bitrates[status->rate_idx];
 
 		ieee80211_rx_cooked_monitor(rx, rate);
@@ -4386,6 +4501,14 @@ void ieee80211_rx_napi(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
 				      status->rate_idx, status->nss))
 				goto drop;
 			break;
+		case RX_ENC_HE:
+			if (WARN_ONCE(status->rate_idx > 11 ||
+				      !status->nss ||
+				      status->nss > 8,
+				      "Rate marked as an HE rate but data is invalid: MCS: %d, NSS: %d\n",
+				      status->rate_idx, status->nss))
+				goto drop;
+			break;
 		default:
 			WARN_ON_ONCE(1);
 			/* fall through */
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 6428f1ac37b6..ec6168db30be 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1323,6 +1323,11 @@ static void ieee80211_send_null_response(struct sta_info *sta, int tid,
 	struct ieee80211_tx_info *info;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 
+	/* Don't send NDPs when STA is connected HE */
+	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
+	    !(sdata->u.mgd.flags & IEEE80211_STA_DISABLE_HE))
+		return;
+
 	if (qos) {
 		fc = cpu_to_le16(IEEE80211_FTYPE_DATA |
 				 IEEE80211_STYPE_QOS_NULLFUNC |
@@ -1968,7 +1973,7 @@ sta_get_last_rx_stats(struct sta_info *sta)
 	return stats;
 }
 
-static void sta_stats_decode_rate(struct ieee80211_local *local, u16 rate,
+static void sta_stats_decode_rate(struct ieee80211_local *local, u32 rate,
 				  struct rate_info *rinfo)
 {
 	rinfo->bw = STA_STATS_GET(BW, rate);
@@ -2005,6 +2010,14 @@ static void sta_stats_decode_rate(struct ieee80211_local *local, u16 rate,
 		rinfo->legacy = DIV_ROUND_UP(brate, 1 << shift);
 		break;
 		}
+	case STA_STATS_RATE_TYPE_HE:
+		rinfo->flags = RATE_INFO_FLAGS_HE_MCS;
+		rinfo->mcs = STA_STATS_GET(HE_MCS, rate);
+		rinfo->nss = STA_STATS_GET(HE_NSS, rate);
+		rinfo->he_gi = STA_STATS_GET(HE_GI, rate);
+		rinfo->he_ru_alloc = STA_STATS_GET(HE_RU, rate);
+		rinfo->he_dcm = STA_STATS_GET(HE_DCM, rate);
+		break;
 	}
 }
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 81b35f623792..9a04327d71d1 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -170,7 +170,7 @@ struct tid_ampdu_tx {
 	u8 dialog_token;
 	u8 stop_initiator;
 	bool tx_stop;
-	u8 buf_size;
+	u16 buf_size;
 
 	u16 failed_bar_ssn;
 	bool bar_pending;
@@ -405,7 +405,7 @@ struct ieee80211_sta_rx_stats {
 	int last_signal;
 	u8 chains;
 	s8 chain_signal_last[IEEE80211_MAX_CHAINS];
-	u16 last_rate;
+	u32 last_rate;
 	struct u64_stats_sync syncp;
 	u64 bytes;
 	u64 msdu[IEEE80211_NUM_TIDS + 1];
@@ -764,6 +764,7 @@ enum sta_stats_type {
 	STA_STATS_RATE_TYPE_LEGACY,
 	STA_STATS_RATE_TYPE_HT,
 	STA_STATS_RATE_TYPE_VHT,
+	STA_STATS_RATE_TYPE_HE,
 };
 
 #define STA_STATS_FIELD_HT_MCS		GENMASK( 7,  0)
@@ -771,9 +772,14 @@ enum sta_stats_type {
 #define STA_STATS_FIELD_LEGACY_BAND	GENMASK( 7,  4)
 #define STA_STATS_FIELD_VHT_MCS		GENMASK( 3,  0)
 #define STA_STATS_FIELD_VHT_NSS		GENMASK( 7,  4)
+#define STA_STATS_FIELD_HE_MCS		GENMASK( 3,  0)
+#define STA_STATS_FIELD_HE_NSS		GENMASK( 7,  4)
 #define STA_STATS_FIELD_BW		GENMASK(11,  8)
 #define STA_STATS_FIELD_SGI		GENMASK(12, 12)
 #define STA_STATS_FIELD_TYPE		GENMASK(15, 13)
+#define STA_STATS_FIELD_HE_RU		GENMASK(18, 16)
+#define STA_STATS_FIELD_HE_GI		GENMASK(20, 19)
+#define STA_STATS_FIELD_HE_DCM		GENMASK(21, 21)
 
 #define STA_STATS_FIELD(_n, _v)		FIELD_PREP(STA_STATS_FIELD_ ## _n, _v)
 #define STA_STATS_GET(_n, _v)		FIELD_GET(STA_STATS_FIELD_ ## _n, _v)
@@ -782,7 +788,7 @@ enum sta_stats_type {
 
 static inline u32 sta_stats_encode_rate(struct ieee80211_rx_status *s)
 {
-	u16 r;
+	u32 r;
 
 	r = STA_STATS_FIELD(BW, s->bw);
 
@@ -804,6 +810,14 @@ static inline u32 sta_stats_encode_rate(struct ieee80211_rx_status *s)
 		r |= STA_STATS_FIELD(LEGACY_BAND, s->band);
 		r |= STA_STATS_FIELD(LEGACY_IDX, s->rate_idx);
 		break;
+	case RX_ENC_HE:
+		r |= STA_STATS_FIELD(TYPE, STA_STATS_RATE_TYPE_HE);
+		r |= STA_STATS_FIELD(HE_NSS, s->nss);
+		r |= STA_STATS_FIELD(HE_MCS, s->rate_idx);
+		r |= STA_STATS_FIELD(HE_GI, s->he_gi);
+		r |= STA_STATS_FIELD(HE_RU, s->he_ru);
+		r |= STA_STATS_FIELD(HE_DCM, s->he_dcm);
+		break;
 	default:
 		WARN_ON(1);
 		return STA_STATS_RATE_INVALID;
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 80a7edf8d314..0ab69a1964f8 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -92,7 +92,7 @@
 				STA_ENTRY						\
 				__field(u16, tid)					\
 				__field(u16, ssn)					\
-				__field(u8, buf_size)					\
+				__field(u16, buf_size)					\
 				__field(bool, amsdu)					\
 				__field(u16, timeout)					\
 				__field(u16, action)
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 2d82c88efd0b..76b419364b04 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1095,6 +1095,21 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 			if (elen >= sizeof(*elems->max_idle_period_ie))
 				elems->max_idle_period_ie = (void *)pos;
 			break;
+		case WLAN_EID_EXTENSION:
+			if (pos[0] == WLAN_EID_EXT_HE_MU_EDCA &&
+			    elen >= (sizeof(*elems->mu_edca_param_set) + 1)) {
+				elems->mu_edca_param_set = (void *)&pos[1];
+			} else if (pos[0] == WLAN_EID_EXT_HE_CAPABILITY) {
+				elems->he_cap = (void *)&pos[1];
+				elems->he_cap_len = elen - 1;
+			} else if (pos[0] == WLAN_EID_EXT_HE_OPERATION &&
+				   elen >= sizeof(*elems->he_operation) &&
+				   elen >= ieee80211_he_oper_size(&pos[1])) {
+				elems->he_operation = (void *)&pos[1];
+			} else if (pos[0] == WLAN_EID_EXT_UORA && elen >= 1) {
+				elems->uora_element = (void *)&pos[1];
+			}
+			break;
 		default:
 			break;
 		}
@@ -1356,6 +1371,7 @@ static int ieee80211_build_preq_ies_band(struct ieee80211_local *local,
 					 size_t *offset)
 {
 	struct ieee80211_supported_band *sband;
+	const struct ieee80211_sta_he_cap *he_cap;
 	u8 *pos = buffer, *end = buffer + buffer_len;
 	size_t noffset;
 	int supp_rates_len, i;
@@ -1460,11 +1476,6 @@ static int ieee80211_build_preq_ies_band(struct ieee80211_local *local,
 						sband->ht_cap.cap);
 	}
 
-	/*
-	 * If adding more here, adjust code in main.c
-	 * that calculates local->scan_ies_len.
-	 */
-
 	/* insert custom IEs that go before VHT */
 	if (ie && ie_len) {
 		static const u8 before_vht[] = {
@@ -1507,6 +1518,39 @@ static int ieee80211_build_preq_ies_band(struct ieee80211_local *local,
 						 sband->vht_cap.cap);
 	}
 
+	/* insert custom IEs that go before HE */
+	if (ie && ie_len) {
+		static const u8 before_he[] = {
+			/*
+			 * no need to list the ones split off before VHT
+			 * or generated here
+			 */
+			WLAN_EID_EXTENSION, WLAN_EID_EXT_FILS_REQ_PARAMS,
+			WLAN_EID_AP_CSN,
+			/* TODO: add 11ah/11aj/11ak elements */
+		};
+		noffset = ieee80211_ie_split(ie, ie_len,
+					     before_he, ARRAY_SIZE(before_he),
+					     *offset);
+		if (end - pos < noffset - *offset)
+			goto out_err;
+		memcpy(pos, ie + *offset, noffset - *offset);
+		pos += noffset - *offset;
+		*offset = noffset;
+	}
+
+	he_cap = ieee80211_get_he_sta_cap(sband);
+	if (he_cap) {
+		pos = ieee80211_ie_build_he_cap(pos, he_cap, end);
+		if (!pos)
+			goto out_err;
+	}
+
+	/*
+	 * If adding more here, adjust code in main.c
+	 * that calculates local->scan_ies_len.
+	 */
+
 	return pos - buffer;
  out_err:
 	WARN_ONCE(1, "not enough space for preq IEs\n");
@@ -2411,6 +2455,72 @@ u8 *ieee80211_ie_build_vht_cap(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
 	return pos;
 }
 
+u8 *ieee80211_ie_build_he_cap(u8 *pos,
+			      const struct ieee80211_sta_he_cap *he_cap,
+			      u8 *end)
+{
+	u8 n;
+	u8 ie_len;
+	u8 *orig_pos = pos;
+
+	/* Make sure we have place for the IE */
+	/*
+	 * TODO: the 1 added is because this temporarily is under the EXTENSION
+	 * IE. Get rid of it when it moves.
+	 */
+	if (!he_cap)
+		return orig_pos;
+
+	n = ieee80211_he_mcs_nss_size(&he_cap->he_cap_elem);
+	ie_len = 2 + 1 +
+		 sizeof(he_cap->he_cap_elem) + n +
+		 ieee80211_he_ppe_size(he_cap->ppe_thres[0],
+				       he_cap->he_cap_elem.phy_cap_info);
+
+	if ((end - pos) < ie_len)
+		return orig_pos;
+
+	*pos++ = WLAN_EID_EXTENSION;
+	pos++; /* We'll set the size later below */
+	*pos++ = WLAN_EID_EXT_HE_CAPABILITY;
+
+	/* Fixed data */
+	memcpy(pos, &he_cap->he_cap_elem, sizeof(he_cap->he_cap_elem));
+	pos += sizeof(he_cap->he_cap_elem);
+
+	memcpy(pos, &he_cap->he_mcs_nss_supp, n);
+	pos += n;
+
+	/* Check if PPE Threshold should be present */
+	if ((he_cap->he_cap_elem.phy_cap_info[6] &
+	     IEEE80211_HE_PHY_CAP6_PPE_THRESHOLD_PRESENT) == 0)
+		goto end;
+
+	/*
+	 * Calculate how many PPET16/PPET8 pairs are to come. Algorithm:
+	 * (NSS_M1 + 1) x (num of 1 bits in RU_INDEX_BITMASK)
+	 */
+	n = hweight8(he_cap->ppe_thres[0] &
+		     IEEE80211_PPE_THRES_RU_INDEX_BITMASK_MASK);
+	n *= (1 + ((he_cap->ppe_thres[0] & IEEE80211_PPE_THRES_NSS_MASK) >>
+		   IEEE80211_PPE_THRES_NSS_POS));
+
+	/*
+	 * Each pair is 6 bits, and we need to add the 7 "header" bits to the
+	 * total size.
+	 */
+	n = (n * IEEE80211_PPE_THRES_INFO_PPET_SIZE * 2) + 7;
+	n = DIV_ROUND_UP(n, 8);
+
+	/* Copy PPE Thresholds */
+	memcpy(pos, &he_cap->ppe_thres, n);
+	pos += n;
+
+end:
+	orig_pos[1] = (pos - orig_pos) - 2;
+	return pos;
+}
+
 u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 			       const struct cfg80211_chan_def *chandef,
 			       u16 prot_mode, bool rifs_mode)
diff --git a/net/wireless/core.c b/net/wireless/core.c
index e3e3acb52278..c4d882cb1b51 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -795,16 +795,16 @@ int wiphy_register(struct wiphy *wiphy)
 
 			iftd = &sband->iftype_data[i];
 
-			if (WARN_ON(!iftd->types))
+			if (WARN_ON(!iftd->types_mask))
 				return -EINVAL;
-			if (WARN_ON(types & iftd->types))
+			if (WARN_ON(types & iftd->types_mask))
 				return -EINVAL;
 
 			/* at least one piece of information must be present */
 			if (WARN_ON(!iftd->he_cap.has_he))
 				return -EINVAL;
 
-			types |= iftd->types;
+			types |= iftd->types_mask;
 		}
 
 		have_band = true;
-- 
2.17.1
