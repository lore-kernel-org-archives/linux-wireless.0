Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:58077 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab1CKAWp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 19:22:45 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/4] mwifiex: remove ieee.h
Date: Thu, 10 Mar 2011 16:25:48 -0800
Message-Id: <1299803149-25996-3-git-send-email-bzhao@marvell.com>
In-Reply-To: <1299803149-25996-1-git-send-email-bzhao@marvell.com>
References: <1299803149-25996-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

Some of the macros and structure definitions have been
removed already in previous patches. This patch moves
the remaining macros and structure definitions from
ieee.h to other files where they are used.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c           |    1 -
 drivers/net/wireless/mwifiex/11n_aggr.c      |    1 -
 drivers/net/wireless/mwifiex/11n_rxreorder.c |    1 -
 drivers/net/wireless/mwifiex/cfp.c           |    1 -
 drivers/net/wireless/mwifiex/cmdevt.c        |    1 -
 drivers/net/wireless/mwifiex/fw.h            |   95 +++++++++++++++++++++++++-
 drivers/net/wireless/mwifiex/init.c          |    1 -
 drivers/net/wireless/mwifiex/join.c          |    3 +-
 drivers/net/wireless/mwifiex/main.h          |   87 +++++++++++++++++++++++-
 drivers/net/wireless/mwifiex/scan.c          |    1 -
 drivers/net/wireless/mwifiex/sdio.c          |    1 -
 drivers/net/wireless/mwifiex/sta_cmd.c       |    1 -
 drivers/net/wireless/mwifiex/sta_cmdresp.c   |    1 -
 drivers/net/wireless/mwifiex/sta_event.c     |    1 -
 drivers/net/wireless/mwifiex/sta_ioctl.c     |    1 -
 drivers/net/wireless/mwifiex/sta_rx.c        |    1 -
 drivers/net/wireless/mwifiex/sta_tx.c        |    1 -
 drivers/net/wireless/mwifiex/txrx.c          |    1 -
 drivers/net/wireless/mwifiex/util.c          |    1 -
 drivers/net/wireless/mwifiex/wmm.c           |    1 -
 drivers/net/wireless/mwifiex/wmm.h           |   11 +++
 21 files changed, 193 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 1fa3f8e..e50ac75 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -19,7 +19,6 @@
 
 #include "decl.h"
 #include "ioctl.h"
-#include "ieee.h"
 #include "util.h"
 #include "fw.h"
 #include "main.h"
diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index 09343cc..9613b35 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -19,7 +19,6 @@
 
 #include "decl.h"
 #include "ioctl.h"
-#include "ieee.h"
 #include "util.h"
 #include "fw.h"
 #include "main.h"
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 91b0c5b..c821018 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -19,7 +19,6 @@
 
 #include "decl.h"
 #include "ioctl.h"
-#include "ieee.h"
 #include "util.h"
 #include "fw.h"
 #include "main.h"
diff --git a/drivers/net/wireless/mwifiex/cfp.c b/drivers/net/wireless/mwifiex/cfp.c
index 64b3c1c..a937eb9 100644
--- a/drivers/net/wireless/mwifiex/cfp.c
+++ b/drivers/net/wireless/mwifiex/cfp.c
@@ -19,7 +19,6 @@
 
 #include "decl.h"
 #include "ioctl.h"
-#include "ieee.h"
 #include "util.h"
 #include "fw.h"
 #include "main.h"
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index cd82cc5..44219a7 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -19,7 +19,6 @@
 
 #include "decl.h"
 #include "ioctl.h"
-#include "ieee.h"
 #include "util.h"
 #include "fw.h"
 #include "main.h"
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 14796b0..a1183bd 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -475,7 +475,6 @@ struct mwifiex_802_11_fixed_ies {
 	__le16 capabilities;
 };
 
-
 struct mwifiex_ie_types_header {
 	__le16 type;
 	__le16 len;
@@ -793,10 +792,57 @@ struct host_cmd_ds_802_11_associate {
 	u8 dtim_period;
 } __packed;
 
+struct ieee_types_assoc_rsp {
+	__le16 cap_info_bitmap;
+	__le16 status_code;
+	__le16 a_id;
+	u8 ie_buffer[1];
+} __packed;
+
 struct host_cmd_ds_802_11_associate_rsp {
 	struct ieee_types_assoc_rsp assoc_rsp;
 } __packed;
 
+struct ieee_types_cf_param_set {
+	u8 element_id;
+	u8 len;
+	u8 cfp_cnt;
+	u8 cfp_period;
+	u16 cfp_max_duration;
+	u16 cfp_duration_remaining;
+} __packed;
+
+struct ieee_types_ibss_param_set {
+	u8 element_id;
+	u8 len;
+	__le16 atim_window;
+} __packed;
+
+union ieee_types_ss_param_set {
+	struct ieee_types_cf_param_set cf_param_set;
+	struct ieee_types_ibss_param_set ibss_param_set;
+} __packed;
+
+struct ieee_types_fh_param_set {
+	u8 element_id;
+	u8 len;
+	__le16 dwell_time;
+	u8 hop_set;
+	u8 hop_pattern;
+	u8 hop_index;
+} __packed;
+
+struct ieee_types_ds_param_set {
+	u8 element_id;
+	u8 len;
+	u8 current_chan;
+} __packed;
+
+union ieee_types_phy_param_set {
+	struct ieee_types_fh_param_set fh_param_set;
+	struct ieee_types_ds_param_set ds_param_set;
+} __packed;
+
 struct host_cmd_ds_802_11_ad_hoc_start {
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	u8 bss_mode;
@@ -1138,6 +1184,53 @@ struct mwifiex_ie_types_wmm_queue_status {
 	u32 reserved;
 };
 
+struct ieee_types_vendor_header {
+	u8 element_id;
+	u8 len;
+	u8 oui[3];
+	u8 oui_type;
+	u8 oui_subtype;
+	u8 version;
+} __packed;
+
+struct ieee_types_wmm_ac_parameters {
+	u8 aci_aifsn_bitmap;
+	u8 ecw_bitmap;
+	__le16 tx_op_limit;
+} __packed;
+
+struct ieee_types_wmm_parameter {
+	/*
+	 * WMM Parameter IE - Vendor Specific Header:
+	 *   element_id  [221/0xdd]
+	 *   Len         [24]
+	 *   Oui         [00:50:f2]
+	 *   OuiType     [2]
+	 *   OuiSubType  [1]
+	 *   Version     [1]
+	 */
+	struct ieee_types_vendor_header vend_hdr;
+	u8 qos_info_bitmap;
+	u8 reserved;
+	struct ieee_types_wmm_ac_parameters ac_params[IEEE80211_MAX_QUEUES];
+} __packed;
+
+struct ieee_types_wmm_info {
+
+	/*
+	 * WMM Info IE - Vendor Specific Header:
+	 *   element_id  [221/0xdd]
+	 *   Len         [7]
+	 *   Oui         [00:50:f2]
+	 *   OuiType     [2]
+	 *   OuiSubType  [0]
+	 *   Version     [1]
+	 */
+	struct ieee_types_vendor_header vend_hdr;
+
+	u8 qos_info_bitmap;
+} __packed;
+
 struct host_cmd_ds_wmm_get_status {
 	u8 queue_status_tlv[sizeof(struct mwifiex_ie_types_wmm_queue_status) *
 			      IEEE80211_MAX_QUEUES];
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index e96ca48..675db9b 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -19,7 +19,6 @@
 
 #include "decl.h"
 #include "ioctl.h"
-#include "ieee.h"
 #include "util.h"
 #include "fw.h"
 #include "main.h"
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 48d2971..f591ef7 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -19,13 +19,14 @@
 
 #include "decl.h"
 #include "ioctl.h"
-#include "ieee.h"
 #include "util.h"
 #include "fw.h"
 #include "main.h"
 #include "wmm.h"
 #include "11n.h"
 
+#define CAPINFO_MASK    (~(BIT(15) | BIT(14) | BIT(12) | BIT(11) | BIT(9)))
+
 /*
  * Append a generic IE as a pass through TLV to a TLV buffer.
  *
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index df28e76..f85f2ea 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -35,7 +35,6 @@
 
 #include "decl.h"
 #include "ioctl.h"
-#include "ieee.h"
 #include "util.h"
 #include "fw.h"
 
@@ -245,6 +244,90 @@ struct mwifiex_802_11_security {
 	u32 encryption_mode;
 };
 
+struct ieee_types_header {
+	u8 element_id;
+	u8 len;
+} __packed;
+
+struct ieee_obss_scan_param {
+	u16 obss_scan_passive_dwell;
+	u16 obss_scan_active_dwell;
+	u16 bss_chan_width_trigger_scan_int;
+	u16 obss_scan_passive_total;
+	u16 obss_scan_active_total;
+	u16 bss_width_chan_trans_delay;
+	u16 obss_scan_active_threshold;
+} __packed;
+
+struct ieee_types_obss_scan_param {
+	struct ieee_types_header ieee_hdr;
+	struct ieee_obss_scan_param obss_scan;
+} __packed;
+
+#define MWIFIEX_SUPPORTED_RATES                 14
+
+#define MWIFIEX_SUPPORTED_RATES_EXT             32
+
+#define IEEE_MAX_IE_SIZE			256
+
+struct ieee_types_vendor_specific {
+	struct ieee_types_vendor_header vend_hdr;
+	u8 data[IEEE_MAX_IE_SIZE - sizeof(struct ieee_types_vendor_header)];
+} __packed;
+
+struct ieee_types_generic {
+	struct ieee_types_header ieee_hdr;
+	u8 data[IEEE_MAX_IE_SIZE - sizeof(struct ieee_types_header)];
+} __packed;
+
+struct mwifiex_bssdescriptor {
+	u8 mac_address[ETH_ALEN];
+	struct mwifiex_802_11_ssid ssid;
+	u32 privacy;
+	s32 rssi;
+	u32 channel;
+	u32 freq;
+	u16 beacon_period;
+	u32 atim_window;
+	u8 erp_flags;
+	u32 bss_mode;
+	u8 supported_rates[MWIFIEX_SUPPORTED_RATES];
+	u8 data_rates[MWIFIEX_SUPPORTED_RATES];
+	/* Network band.
+	 * BAND_B(0x01): 'b' band
+	 * BAND_G(0x02): 'g' band
+	 * BAND_A(0X04): 'a' band
+	 */
+	u16 bss_band;
+	long long network_tsf;
+	u8 time_stamp[8];
+	union ieee_types_phy_param_set phy_param_set;
+	union ieee_types_ss_param_set ss_param_set;
+	u16 cap_info_bitmap;
+	struct ieee_types_wmm_parameter wmm_ie;
+	u8  disable_11n;
+	struct ieee80211_ht_cap *bcn_ht_cap;
+	u16 ht_cap_offset;
+	struct ieee80211_ht_info *bcn_ht_info;
+	u16 ht_info_offset;
+	u8 *bcn_bss_co_2040;
+	u16 bss_co_2040_offset;
+	u8 *bcn_ext_cap;
+	u16 ext_cap_offset;
+	struct ieee_types_obss_scan_param *bcn_obss_scan;
+	u16 overlap_bss_offset;
+	struct ieee_types_vendor_specific *bcn_wpa_ie;
+	u16 wpa_offset;
+	struct ieee_types_generic *bcn_rsn_ie;
+	u16 rsn_offset;
+	struct ieee_types_generic *bcn_wapi_ie;
+	u16 wapi_offset;
+	u8 *beacon_buf;
+	u32 beacon_buf_size;
+	u32 beacon_buf_size_max;
+
+};
+
 struct mwifiex_current_bss_params {
 	struct mwifiex_bssdescriptor bss_descriptor;
 	u8 wmm_enabled;
@@ -289,6 +372,8 @@ enum state_11d_t {
 	ENABLE_11D = 1,
 };
 
+#define MWIFIEX_MAX_TRIPLET_802_11D		83
+
 struct mwifiex_802_11d_domain_reg {
 	u8 country_code[IEEE80211_COUNTRY_STRING_LEN];
 	u8 no_of_triplet;
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 42bf9e0..56233f5 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -19,7 +19,6 @@
 
 #include "decl.h"
 #include "ioctl.h"
-#include "ieee.h"
 #include "util.h"
 #include "fw.h"
 #include "main.h"
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index a358713..f56f4f5 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -21,7 +21,6 @@
 
 #include "decl.h"
 #include "ioctl.h"
-#include "ieee.h"
 #include "util.h"
 #include "fw.h"
 #include "main.h"
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 9827651..bc8d451 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -19,7 +19,6 @@
 
 #include "decl.h"
 #include "ioctl.h"
-#include "ieee.h"
 #include "util.h"
 #include "fw.h"
 #include "main.h"
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 8e2c5bc..a2f2462 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -19,7 +19,6 @@
 
 #include "decl.h"
 #include "ioctl.h"
-#include "ieee.h"
 #include "util.h"
 #include "fw.h"
 #include "main.h"
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index c3e6dd0..761bc5f 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -19,7 +19,6 @@
 
 #include "decl.h"
 #include "ioctl.h"
-#include "ieee.h"
 #include "util.h"
 #include "fw.h"
 #include "main.h"
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index a570e8a..f9c9a42 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -19,7 +19,6 @@
 
 #include "decl.h"
 #include "ioctl.h"
-#include "ieee.h"
 #include "util.h"
 #include "fw.h"
 #include "main.h"
diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index 253e057..6d8459f 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -19,7 +19,6 @@
 
 #include "decl.h"
 #include "ioctl.h"
-#include "ieee.h"
 #include "util.h"
 #include "fw.h"
 #include "main.h"
diff --git a/drivers/net/wireless/mwifiex/sta_tx.c b/drivers/net/wireless/mwifiex/sta_tx.c
index 08710bb..666b8ed 100644
--- a/drivers/net/wireless/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/mwifiex/sta_tx.c
@@ -19,7 +19,6 @@
 
 #include "decl.h"
 #include "ioctl.h"
-#include "ieee.h"
 #include "util.h"
 #include "fw.h"
 #include "main.h"
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index a7835ff..db62761 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -19,7 +19,6 @@
 
 #include "decl.h"
 #include "ioctl.h"
-#include "ieee.h"
 #include "util.h"
 #include "fw.h"
 #include "main.h"
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 892c21c..8da8a0b 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -19,7 +19,6 @@
 
 #include "decl.h"
 #include "ioctl.h"
-#include "ieee.h"
 #include "util.h"
 #include "fw.h"
 #include "main.h"
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 744e1bc..1135425 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -19,7 +19,6 @@
 
 #include "decl.h"
 #include "ioctl.h"
-#include "ieee.h"
 #include "util.h"
 #include "fw.h"
 #include "main.h"
diff --git a/drivers/net/wireless/mwifiex/wmm.h b/drivers/net/wireless/mwifiex/wmm.h
index 4de4e80..b9bc050 100644
--- a/drivers/net/wireless/mwifiex/wmm.h
+++ b/drivers/net/wireless/mwifiex/wmm.h
@@ -20,6 +20,17 @@
 #ifndef _MWIFIEX_WMM_H_
 #define _MWIFIEX_WMM_H_
 
+enum ieee_types_wmm_aciaifsn_bitmasks {
+	MWIFIEX_AIFSN = (BIT(0) | BIT(1) | BIT(2) | BIT(3)),
+	MWIFIEX_ACM = BIT(4),
+	MWIFIEX_ACI = (BIT(5) | BIT(6)),
+};
+
+enum ieee_types_wmm_ecw_bitmasks {
+	MWIFIEX_ECW_MIN = (BIT(0) | BIT(1) | BIT(2) | BIT(3)),
+	MWIFIEX_ECW_MAX = (BIT(4) | BIT(5) | BIT(6) | BIT(7)),
+};
+
 /*
  * This function retrieves the TID of the given RA list.
  */
-- 
1.7.0.2

