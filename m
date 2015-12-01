Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:62122 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756083AbbLAKAK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 05:00:10 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 39/41] iwlwifi: mvm: add 9000-series RX API
Date: Tue,  1 Dec 2015 11:59:05 +0200
Message-Id: <1448963947-24302-39-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_112251_791807_E02B6503)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Define the RX API that's used by the 9000 series hardware.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h | 113 +++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h    |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   1 +
 3 files changed, 115 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
index d790322..9a8a37f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
@@ -68,6 +68,8 @@
 #ifndef __fw_api_rx_h__
 #define __fw_api_rx_h__
 
+/* API for pre-9000 hardware */
+
 #define IWL_RX_INFO_PHY_CNT 8
 #define IWL_RX_INFO_ENERGY_ANT_ABC_IDX 1
 #define IWL_RX_INFO_ENERGY_ANT_A_MSK 0x000000ff
@@ -236,4 +238,115 @@ enum iwl_mvm_rx_status {
 	RX_MPDU_RES_STATUS2_FILTERING_MSK		= (0xc0000000),
 };
 
+/* 9000 series API */
+enum iwl_rx_mpdu_mac_flags1 {
+	IWL_RX_MDPU_MFLG1_ADDRTYPE_MASK		= 0x03,
+	IWL_RX_MPDU_MFLG1_MIC_CRC_LEN_MASK	= 0xf0,
+	/* shift should be 4, but the length is measured in 2-byte
+	 * words, so shifting only by 3 gives a byte result
+	 */
+	IWL_RX_MPDU_MFLG1_MIC_CRC_LEN_SHIFT	= 3,
+};
+
+enum iwl_rx_mpdu_mac_flags2 {
+	/* in 2-byte words */
+	IWL_RX_MPDU_MFLG2_HDR_LEN_MASK		= 0x1f,
+	IWL_RX_MPDU_MFLG2_PAD			= 0x20,
+	IWL_RX_MPDU_MFLG2_AMSDU			= 0x40,
+};
+
+enum iwl_rx_mpdu_amsdu_info {
+	IWL_RX_MPDU_AMSDU_SUBFRAME_IDX_MASK	= 0x3f,
+	IWL_RX_MPDU_AMSDU_LAST_SUBFRAME		= 0x40,
+	/* 0x80 bit reserved for now */
+};
+
+enum iwl_rx_l3l4_flags {
+	IWL_RX_L3L4_IP_HDR_CSUM_OK		= BIT(0),
+	IWL_RX_L3L4_TCP_UDP_CSUM_OK		= BIT(1),
+	IWL_RX_L3L4_TCP_FIN_SYN_RST_PSH		= BIT(2),
+	IWL_RX_L3L4_TCP_ACK			= BIT(3),
+	IWL_RX_L3L4_L3_PROTO_MASK		= 0xf << 4,
+	IWL_RX_L3L4_L4_PROTO_MASK		= 0xf << 8,
+	IWL_RX_L3L4_RSS_HASH_MASK		= 0xf << 12,
+};
+
+enum iwl_rx_mpdu_status {
+	IWL_RX_MPDU_STATUS_CRC_OK		= BIT(0),
+	IWL_RX_MPDU_STATUS_OVERRUN_OK		= BIT(1),
+	IWL_RX_MPDU_STATUS_SRC_STA_FOUND	= BIT(2),
+	IWL_RX_MPDU_STATUS_KEY_VALID		= BIT(3),
+	IWL_RX_MPDU_STATUS_KEY_ERROR		= BIT(4),
+	IWL_RX_MPDU_STATUS_ICV_OK		= BIT(5),
+	IWL_RX_MPDU_STATUS_MIC_OK		= BIT(6),
+	IWL_RX_MPDU_STATUS_SEC_MASK		= 0x7 << 8,
+	IWL_RX_MPDU_STATUS_SEC_NONE		= 0x0 << 8,
+	IWL_RX_MPDU_STATUS_SEC_WEP		= 0x1 << 8,
+	IWL_RX_MPDU_STATUS_SEC_CCM		= 0x2 << 8,
+	IWL_RX_MPDU_STATUS_SEC_TKIP		= 0x3 << 8,
+	IWL_RX_MPDU_STATUS_DECRYPTED		= BIT(11),
+	IWL_RX_MPDU_STATUS_WEP_MATCH		= BIT(12),
+	IWL_RX_MPDU_STATUS_EXT_IV_MATCH		= BIT(13),
+	IWL_RX_MPDU_STATUS_KEY_ID_MATCH		= BIT(14),
+	IWL_RX_MPDU_STATUS_KEY_COLOR		= BIT(15),
+};
+
+enum iwl_rx_mpdu_hash_filter {
+	IWL_RX_MPDU_HF_A1_HASH_MASK		= 0x3f,
+	IWL_RX_MPDU_HF_FILTER_STATUS_MASK	= 0xc0,
+};
+
+enum iwl_rx_mpdu_sta_id_flags {
+	IWL_RX_MPDU_SIF_STA_ID_MASK		= 0x1f,
+	IWL_RX_MPDU_SIF_RRF_ABORT		= 0x20,
+	IWL_RX_MPDU_SIF_FILTER_STATUS_MASK	= 0xc0,
+};
+
+enum iwl_rx_mpdu_reorder_data {
+	IWL_RX_MPDU_REORDER_NSSN_MASK		= 0x00000fff,
+	IWL_RX_MPDU_REORDER_SN_MASK		= 0x00fff000,
+	IWL_RX_MPDU_REORDER_SN_SHIFT		= 12,
+	IWL_RX_MPDU_REORDER_BAID_MASK		= 0x7f000000,
+	IWL_RX_MPDU_REORDER_BAID_SHIFT		= 24,
+	IWL_RX_MPDU_REORDER_BA_OLD_SN		= 0x80000000,
+};
+
+struct iwl_rx_mpdu_desc {
+	/* DW2 */
+	__le16 mpdu_len;
+	u8 mac_flags1;
+	u8 mac_flags2;
+	/* DW3 */
+	u8 amsdu_info;
+	__le16 reserved_for_software;
+	u8 mac_phy_idx;
+	/* DW4 */
+	__le16 raw_csum; /* alledgedly unreliable */
+	__le16 l3l4_flags;
+	/* DW5 */
+	__le16 status;
+	u8 hash_filter;
+	u8 sta_id_flags;
+	/* DW6 */
+	__le32 reorder_data;
+	/* DW7 */
+	__le32 rss_hash;
+	/* DW8 */
+	__le32 filter_match;
+	/* DW9 */
+	__le32 gp2_on_air_rise;
+	/* DW10 */
+	__le32 rate_n_flags;
+	/* DW11 */
+	u8 energy_a, energy_b, energy_c, channel;
+	/* DW12 & DW13 */
+	__le64 tsf_on_air_rise;
+} __packed;
+
+struct iwl_frame_release {
+	u8 baid;
+	u8 reserved;
+	__le16 nssn;
+};
+
 #endif /* __fw_api_rx_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index 68dfa28..9436798 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -213,6 +213,7 @@ enum {
 
 	REPLY_RX_PHY_CMD = 0xc0,
 	REPLY_RX_MPDU_CMD = 0xc1,
+	FRAME_RELEASE = 0xc3,
 	BA_NOTIF = 0xc5,
 
 	/* Location Aware Regulatory */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index fa849a2..3b0d597f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -310,6 +310,7 @@ static const char *const iwl_mvm_cmd_strings[REPLY_MAX + 1] = {
 	CMD(WEP_KEY),
 	CMD(REPLY_RX_PHY_CMD),
 	CMD(REPLY_RX_MPDU_CMD),
+	CMD(FRAME_RELEASE),
 	CMD(BEACON_NOTIFICATION),
 	CMD(BEACON_TEMPLATE_CMD),
 	CMD(STATISTICS_CMD),
-- 
2.5.0

