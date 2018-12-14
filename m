Return-Path: <SRS0=OWo+=OX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6945C43387
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 20:30:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B97D2080F
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 20:30:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730893AbeLNUaA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Dec 2018 15:30:00 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:41994 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730885AbeLNU36 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Dec 2018 15:29:58 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=localhost.localdomain)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gXu5s-0002RG-N4; Fri, 14 Dec 2018 22:29:57 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Golan Ben Ami <golan.ben.ami@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 14 Dec 2018 22:29:35 +0200
Message-Id: <20181214202945.32375-9-luca@coelho.fi>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181214202945.32375-1-luca@coelho.fi>
References: <20181214202945.32375-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 08/18] iwlwifi: mvm: handle RX no data notification
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shaul Triebitz <shaul.triebitz@intel.com>

Handle RX no data notification, which is used for advertising NDP to
radiotap.

Signed-off-by: Golan Ben Ami <golan.ben.ami@intel.com>
Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../wireless/intel/iwlwifi/fw/api/datapath.h  |   5 +
 .../net/wireless/intel/iwlwifi/fw/api/rx.h    |  49 +++++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 126 +++++++++++++++++-
 5 files changed, 183 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h b/drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h
index eff3249af48a..fdc54a5dc9de 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h
@@ -104,6 +104,11 @@ enum iwl_data_path_subcmd_ids {
 	 */
 	HE_AIR_SNIFFER_CONFIG_CMD = 0x13,
 
+	/**
+	 * @RX_NO_DATA_NOTIF: &struct iwl_rx_no_data
+	 */
+	RX_NO_DATA_NOTIF = 0xF5,
+
 	/**
 	 * @TLC_MNG_UPDATE_NOTIF: &struct iwl_tlc_update_notif
 	 */
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h b/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
index 8961227ff44d..0791a854fc8f 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
@@ -697,6 +697,55 @@ struct iwl_rx_mpdu_desc {
 #define IWL_CD_STTS_WIFI_STATUS_POS	4
 #define IWL_CD_STTS_WIFI_STATUS_MSK	0xF0
 
+#define RX_NO_DATA_CHAIN_A_POS		0
+#define RX_NO_DATA_CHAIN_A_MSK		(0xff << RX_NO_DATA_CHAIN_A_POS)
+#define RX_NO_DATA_CHAIN_B_POS		8
+#define RX_NO_DATA_CHAIN_B_MSK		(0xff << RX_NO_DATA_CHAIN_B_POS)
+#define RX_NO_DATA_CHANNEL_POS		16
+#define RX_NO_DATA_CHANNEL_MSK		(0xff << RX_NO_DATA_CHANNEL_POS)
+
+#define RX_NO_DATA_INFO_TYPE_POS	0
+#define RX_NO_DATA_INFO_TYPE_MSK	(0xff << RX_NO_DATA_INFO_TYPE_POS)
+#define RX_NO_DATA_INFO_TYPE_NONE	0
+#define RX_NO_DATA_INFO_TYPE_RX_ERR	1
+#define RX_NO_DATA_INFO_TYPE_NDP	2
+#define RX_NO_DATA_INFO_TYPE_MU_UNMATCHED	3
+#define RX_NO_DATA_INFO_TYPE_HE_TB_UNMATCHED	4
+
+#define RX_NO_DATA_INFO_ERR_POS		8
+#define RX_NO_DATA_INFO_ERR_MSK		(0xff << RX_NO_DATA_INFO_ERR_POS)
+#define RX_NO_DATA_INFO_ERR_NONE	0
+#define RX_NO_DATA_INFO_ERR_BAD_PLCP	1
+#define RX_NO_DATA_INFO_ERR_UNSUPPORTED_RATE	2
+#define RX_NO_DATA_INFO_ERR_NO_DELIM		3
+#define RX_NO_DATA_INFO_ERR_BAD_MAC_HDR	4
+
+#define RX_NO_DATA_FRAME_TIME_POS	0
+#define RX_NO_DATA_FRAME_TIME_MSK	(0xfffff << RX_NO_DATA_FRAME_TIME_POS)
+
+/**
+ * struct iwl_rx_no_data - RX no data descriptor
+ * @info: 7:0 frame type, 15:8 RX error type
+ * @rssi: 7:0 energy chain-A,
+ *	15:8 chain-B, measured at FINA time (FINA_ENERGY), 16:23 channel
+ * @on_air_rise_time: GP2 during on air rise
+ * @fr_time: frame time
+ * @rate: rate/mcs of frame
+ * @phy_info: &enum iwl_rx_phy_data0 and &enum iwl_rx_phy_info_type
+ * @rx_vec: DW-12:9 raw RX vectors from DSP according to modulation type.
+ *	for VHT: OFDM_RX_VECTOR_SIGA1_OUT, OFDM_RX_VECTOR_SIGA2_OUT
+ *	for HE: OFDM_RX_VECTOR_HE_SIGA1_OUT, OFDM_RX_VECTOR_HE_SIGA2_OUT
+ */
+struct iwl_rx_no_data {
+	__le32 info;
+	__le32 rssi;
+	__le32 on_air_rise_time;
+	__le32 fr_time;
+	__le32 rate;
+	__le32 phy_info[2];
+	__le32 rx_vec[3];
+} __packed; /* RX_NO_DATA_NTFY_API_S_VER_1 */
+
 /**
  * enum iwl_completion_desc_transfer_status -  transfer status (bits 1-3)
  * @IWL_CD_STTS_UNUSED: unused
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 707bc7d1f37f..1aa690e081ff 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1556,6 +1556,8 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 			struct iwl_rx_cmd_buffer *rxb);
 void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 			struct iwl_rx_cmd_buffer *rxb, int queue);
+void iwl_mvm_rx_monitor_ndp(struct iwl_mvm *mvm, struct napi_struct *napi,
+			    struct iwl_rx_cmd_buffer *rxb, int queue);
 void iwl_mvm_rx_frame_release(struct iwl_mvm *mvm, struct napi_struct *napi,
 			      struct iwl_rx_cmd_buffer *rxb, int queue);
 int iwl_mvm_notify_rx_queue(struct iwl_mvm *mvm, u32 rxq_mask,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index a31dc99b63f7..30c5127034a0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1073,6 +1073,8 @@ static void iwl_mvm_rx_mq(struct iwl_op_mode *op_mode,
 		iwl_mvm_rx_queue_notif(mvm, rxb, 0);
 	else if (cmd == WIDE_ID(LEGACY_GROUP, FRAME_RELEASE))
 		iwl_mvm_rx_frame_release(mvm, napi, rxb, 0);
+	else if (cmd == WIDE_ID(DATA_PATH_GROUP, RX_NO_DATA_NOTIF))
+		iwl_mvm_rx_monitor_ndp(mvm, napi, rxb, 0);
 	else
 		iwl_mvm_rx_common(mvm, rxb, pkt);
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 8b014456e6d8..7bd8676508f5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -200,7 +200,8 @@ static void iwl_mvm_pass_packet_to_mac80211(struct iwl_mvm *mvm,
 {
 	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
 
-	if (iwl_mvm_check_pn(mvm, skb, queue, sta)) {
+	if (!(rx_status->flag & RX_FLAG_NO_PSDU) &&
+	    iwl_mvm_check_pn(mvm, skb, queue, sta)) {
 		kfree_skb(skb);
 	} else {
 		unsigned int radiotap_len = 0;
@@ -1606,6 +1607,129 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 	rcu_read_unlock();
 }
 
+void iwl_mvm_rx_monitor_ndp(struct iwl_mvm *mvm, struct napi_struct *napi,
+			    struct iwl_rx_cmd_buffer *rxb, int queue)
+{
+	struct ieee80211_rx_status *rx_status;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_rx_no_data *desc = (void *)pkt->data;
+	u32 rate_n_flags = le32_to_cpu(desc->rate);
+	u32 gp2_on_air_rise = le32_to_cpu(desc->on_air_rise_time);
+	u32 rssi = le32_to_cpu(desc->rssi);
+	u32 info_type = le32_to_cpu(desc->info) & RX_NO_DATA_INFO_TYPE_MSK;
+	u16 phy_info = IWL_RX_MPDU_PHY_TSF_OVERLOAD;
+	struct ieee80211_sta *sta = NULL;
+	struct sk_buff *skb;
+	u8 channel, energy_a, energy_b;
+	struct iwl_mvm_rx_phy_data phy_data = {
+		.d0 = desc->phy_info[0],
+		.info_type = IWL_RX_PHY_INFO_TYPE_NONE,
+	};
+
+	if (unlikely(test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)))
+		return;
+
+	/* Currently only NDP type is supported */
+	if (info_type != RX_NO_DATA_INFO_TYPE_NDP)
+		return;
+
+	energy_a = (rssi & RX_NO_DATA_CHAIN_A_MSK) >> RX_NO_DATA_CHAIN_A_POS;
+	energy_b = (rssi & RX_NO_DATA_CHAIN_B_MSK) >> RX_NO_DATA_CHAIN_B_POS;
+	channel = (rssi & RX_NO_DATA_CHANNEL_MSK) >> RX_NO_DATA_CHANNEL_POS;
+
+	phy_data.info_type =
+		le32_get_bits(desc->phy_info[1],
+			      IWL_RX_PHY_DATA1_INFO_TYPE_MASK);
+
+	/* Dont use dev_alloc_skb(), we'll have enough headroom once
+	 * ieee80211_hdr pulled.
+	 */
+	skb = alloc_skb(128, GFP_ATOMIC);
+	if (!skb) {
+		IWL_ERR(mvm, "alloc_skb failed\n");
+		return;
+	}
+
+	rx_status = IEEE80211_SKB_RXCB(skb);
+
+	/* 0-length PSDU */
+	rx_status->flag |= RX_FLAG_NO_PSDU;
+	/* currently this is the only type for which we get this notif */
+	rx_status->zero_length_psdu_type =
+		IEEE80211_RADIOTAP_ZERO_LEN_PSDU_SOUNDING;
+
+	/* This may be overridden by iwl_mvm_rx_he() to HE_RU */
+	switch (rate_n_flags & RATE_MCS_CHAN_WIDTH_MSK) {
+	case RATE_MCS_CHAN_WIDTH_20:
+		break;
+	case RATE_MCS_CHAN_WIDTH_40:
+		rx_status->bw = RATE_INFO_BW_40;
+		break;
+	case RATE_MCS_CHAN_WIDTH_80:
+		rx_status->bw = RATE_INFO_BW_80;
+		break;
+	case RATE_MCS_CHAN_WIDTH_160:
+		rx_status->bw = RATE_INFO_BW_160;
+		break;
+	}
+
+	if (rate_n_flags & RATE_MCS_HE_MSK)
+		iwl_mvm_rx_he(mvm, skb, &phy_data, rate_n_flags,
+			      phy_info, queue);
+
+	iwl_mvm_decode_lsig(skb, &phy_data);
+
+	rx_status->device_timestamp = gp2_on_air_rise;
+	rx_status->band = channel > 14 ? NL80211_BAND_5GHZ :
+		NL80211_BAND_2GHZ;
+	rx_status->freq = ieee80211_channel_to_frequency(channel,
+							 rx_status->band);
+	iwl_mvm_get_signal_strength(mvm, rx_status, rate_n_flags, energy_a,
+				    energy_b);
+
+	rcu_read_lock();
+
+	if (!(rate_n_flags & RATE_MCS_CCK_MSK) &&
+	    rate_n_flags & RATE_MCS_SGI_MSK)
+		rx_status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
+	if (rate_n_flags & RATE_HT_MCS_GF_MSK)
+		rx_status->enc_flags |= RX_ENC_FLAG_HT_GF;
+	if (rate_n_flags & RATE_MCS_LDPC_MSK)
+		rx_status->enc_flags |= RX_ENC_FLAG_LDPC;
+	if (rate_n_flags & RATE_MCS_HT_MSK) {
+		u8 stbc = (rate_n_flags & RATE_MCS_STBC_MSK) >>
+				RATE_MCS_STBC_POS;
+		rx_status->encoding = RX_ENC_HT;
+		rx_status->rate_idx = rate_n_flags & RATE_HT_MCS_INDEX_MSK;
+		rx_status->enc_flags |= stbc << RX_ENC_FLAG_STBC_SHIFT;
+	} else if (rate_n_flags & RATE_MCS_VHT_MSK) {
+		u8 stbc = (rate_n_flags & RATE_MCS_STBC_MSK) >>
+				RATE_MCS_STBC_POS;
+		rx_status->nss =
+			((rate_n_flags & RATE_VHT_MCS_NSS_MSK) >>
+						RATE_VHT_MCS_NSS_POS) + 1;
+		rx_status->rate_idx = rate_n_flags & RATE_VHT_MCS_RATE_CODE_MSK;
+		rx_status->encoding = RX_ENC_VHT;
+		rx_status->enc_flags |= stbc << RX_ENC_FLAG_STBC_SHIFT;
+		if (rate_n_flags & RATE_MCS_BF_MSK)
+			rx_status->enc_flags |= RX_ENC_FLAG_BF;
+	} else if (!(rate_n_flags & RATE_MCS_HE_MSK)) {
+		int rate = iwl_mvm_legacy_rate_to_mac80211_idx(rate_n_flags,
+							       rx_status->band);
+
+		if (WARN(rate < 0 || rate > 0xFF,
+			 "Invalid rate flags 0x%x, band %d,\n",
+			 rate_n_flags, rx_status->band)) {
+			kfree_skb(skb);
+			goto out;
+		}
+		rx_status->rate_idx = rate;
+	}
+
+	iwl_mvm_pass_packet_to_mac80211(mvm, napi, skb, queue, sta);
+out:
+	rcu_read_unlock();
+}
 void iwl_mvm_rx_frame_release(struct iwl_mvm *mvm, struct napi_struct *napi,
 			      struct iwl_rx_cmd_buffer *rxb, int queue)
 {
-- 
2.19.2

