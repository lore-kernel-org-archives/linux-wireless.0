Return-Path: <SRS0=iPli=OC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F9E0C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 11:27:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17427206B2
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 11:27:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 17427206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405218AbeKWWKv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 23 Nov 2018 17:10:51 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:38338 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2394365AbeKWWKv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Nov 2018 17:10:51 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gQ9bi-0008GU-Tu; Fri, 23 Nov 2018 13:26:47 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 23 Nov 2018 13:26:28 +0200
Message-Id: <20181123112631.29360-13-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181123112631.29360-1-luca@coelho.fi>
References: <20181123112631.29360-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 12/15] iwlwifi: mvm: add L-SIG length to radiotap
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shaul Triebitz <shaul.triebitz@intel.com>

We may have the L-SIG length depending on the phy_data info type;
add it to radiotap when we do.

Move getting the phy_data out one layer up and the info type into
it so we can use this data more generically. We need to call the
iwl_mvm_rx_he() function for other reasons as well, so can't just
combine all of that into something like iwl_mvm_parse_phy_data().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 96 ++++++++++++-------
 1 file changed, 60 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index d7f6b7aec981..87c245c85d9c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -864,6 +864,7 @@ static void iwl_mvm_flip_address(u8 *addr)
 }
 
 struct iwl_mvm_rx_phy_data {
+	enum iwl_rx_phy_info_type info_type;
 	__le32 d0, d1, d2, d3;
 	__le16 d4;
 };
@@ -999,19 +1000,13 @@ static void iwl_mvm_decode_he_phy_data(struct iwl_mvm *mvm,
 				       struct ieee80211_rx_status *rx_status,
 				       u32 rate_n_flags, int queue)
 {
-	enum iwl_rx_phy_info_type info_type;
-
-	info_type = le32_get_bits(phy_data->d1, IWL_RX_PHY_DATA1_INFO_TYPE_MASK);
-
-	switch (info_type) {
+	switch (phy_data->info_type) {
 	case IWL_RX_PHY_INFO_TYPE_NONE:
 	case IWL_RX_PHY_INFO_TYPE_CCK:
 	case IWL_RX_PHY_INFO_TYPE_OFDM_LGCY:
-		return;
 	case IWL_RX_PHY_INFO_TYPE_HT:
 	case IWL_RX_PHY_INFO_TYPE_VHT_SU:
 	case IWL_RX_PHY_INFO_TYPE_VHT_MU:
-		/* TODO: we have LSIG-LEN, where do we put it? */
 		return;
 	case IWL_RX_PHY_INFO_TYPE_HE_TB_EXT:
 		he->data1 |= cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_SPTL_REUSE_KNOWN |
@@ -1075,7 +1070,7 @@ static void iwl_mvm_decode_he_phy_data(struct iwl_mvm *mvm,
 		break;
 	}
 
-	switch (info_type) {
+	switch (phy_data->info_type) {
 	case IWL_RX_PHY_INFO_TYPE_HE_MU_EXT:
 		he_mu->flags1 |=
 			le16_encode_bits(le16_get_bits(phy_data->d4,
@@ -1119,7 +1114,7 @@ static void iwl_mvm_decode_he_phy_data(struct iwl_mvm *mvm,
 }
 
 static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
-			  struct iwl_rx_mpdu_desc *desc,
+			  struct iwl_mvm_rx_phy_data *phy_data,
 			  u32 rate_n_flags, u16 phy_info, int queue)
 {
 	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
@@ -1144,33 +1139,13 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 				      IEEE80211_RADIOTAP_HE_MU_FLAGS2_BW_FROM_SIG_A_BW_KNOWN),
 	};
 	unsigned int radiotap_len = 0;
-	struct iwl_mvm_rx_phy_data phy_data = {
-		.d4 = desc->phy_data4,
-	};
-	enum iwl_rx_phy_info_type info_type = IWL_RX_PHY_INFO_TYPE_NONE;
-
-	if (mvm->trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560) {
-		phy_data.d0 = desc->v3.phy_data0;
-		phy_data.d1 = desc->v3.phy_data1;
-		phy_data.d2 = desc->v3.phy_data2;
-		phy_data.d3 = desc->v3.phy_data3;
-	} else {
-		phy_data.d0 = desc->v1.phy_data0;
-		phy_data.d1 = desc->v1.phy_data1;
-		phy_data.d2 = desc->v1.phy_data2;
-		phy_data.d3 = desc->v1.phy_data3;
-	}
-
-	if (phy_info & IWL_RX_MPDU_PHY_TSF_OVERLOAD)
-		info_type = le32_get_bits(phy_data.d1,
-					  IWL_RX_PHY_DATA1_INFO_TYPE_MASK);
 
 	he = skb_put_data(skb, &known, sizeof(known));
 	radiotap_len += sizeof(known);
 	rx_status->flag |= RX_FLAG_RADIOTAP_HE;
 
-	if (info_type == IWL_RX_PHY_INFO_TYPE_HE_MU ||
-	    info_type == IWL_RX_PHY_INFO_TYPE_HE_MU_EXT) {
+	if (phy_data->info_type == IWL_RX_PHY_INFO_TYPE_HE_MU ||
+	    phy_data->info_type == IWL_RX_PHY_INFO_TYPE_HE_MU_EXT) {
 		he_mu = skb_put_data(skb, &mu_known, sizeof(mu_known));
 		radiotap_len += sizeof(mu_known);
 		rx_status->flag |= RX_FLAG_RADIOTAP_HE_MU;
@@ -1179,18 +1154,18 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 	/* temporarily hide the radiotap data */
 	__skb_pull(skb, radiotap_len);
 
-	if (info_type == IWL_RX_PHY_INFO_TYPE_HE_SU) {
+	if (phy_data->info_type == IWL_RX_PHY_INFO_TYPE_HE_SU) {
 		/* report the AMPDU-EOF bit on single frames */
 		if (!queue && !(phy_info & IWL_RX_MPDU_PHY_AMPDU)) {
 			rx_status->flag |= RX_FLAG_AMPDU_DETAILS;
 			rx_status->flag |= RX_FLAG_AMPDU_EOF_BIT_KNOWN;
-			if (phy_data.d0 & cpu_to_le32(IWL_RX_PHY_DATA0_HE_DELIM_EOF))
+			if (phy_data->d0 & cpu_to_le32(IWL_RX_PHY_DATA0_HE_DELIM_EOF))
 				rx_status->flag |= RX_FLAG_AMPDU_EOF_BIT;
 		}
 	}
 
 	if (phy_info & IWL_RX_MPDU_PHY_TSF_OVERLOAD)
-		iwl_mvm_decode_he_phy_data(mvm, &phy_data, he, he_mu, rx_status,
+		iwl_mvm_decode_he_phy_data(mvm, phy_data, he, he_mu, rx_status,
 					   rate_n_flags, queue);
 
 	/* update aggregation data for monitor sake on default queue */
@@ -1203,7 +1178,7 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 		    (he_type == RATE_MCS_HE_TYPE_MU ||
 		     he_type == RATE_MCS_HE_TYPE_SU)) {
 			rx_status->flag |= RX_FLAG_AMPDU_EOF_BIT_KNOWN;
-			if (phy_data.d0 & cpu_to_le32(IWL_RX_PHY_DATA0_HE_DELIM_EOF))
+			if (phy_data->d0 & cpu_to_le32(IWL_RX_PHY_DATA0_HE_DELIM_EOF))
 				rx_status->flag |= RX_FLAG_AMPDU_EOF_BIT;
 		}
 	}
@@ -1290,6 +1265,33 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 				      IEEE80211_RADIOTAP_HE_DATA5_LTF_SIZE);
 }
 
+static void iwl_mvm_decode_lsig(struct sk_buff *skb,
+				struct iwl_mvm_rx_phy_data *phy_data)
+{
+	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
+	struct ieee80211_radiotap_lsig *lsig;
+
+	switch (phy_data->info_type) {
+	case IWL_RX_PHY_INFO_TYPE_HT:
+	case IWL_RX_PHY_INFO_TYPE_VHT_SU:
+	case IWL_RX_PHY_INFO_TYPE_VHT_MU:
+	case IWL_RX_PHY_INFO_TYPE_HE_TB_EXT:
+	case IWL_RX_PHY_INFO_TYPE_HE_SU:
+	case IWL_RX_PHY_INFO_TYPE_HE_MU:
+	case IWL_RX_PHY_INFO_TYPE_HE_MU_EXT:
+	case IWL_RX_PHY_INFO_TYPE_HE_TB:
+		lsig = skb_put(skb, sizeof(*lsig));
+		lsig->data1 = cpu_to_le16(IEEE80211_RADIOTAP_LSIG_DATA1_LENGTH_KNOWN);
+		lsig->data2 = le16_encode_bits(le32_get_bits(phy_data->d1,
+							     IWL_RX_PHY_DATA1_LSIG_LEN_MASK),
+					       IEEE80211_RADIOTAP_LSIG_DATA2_LENGTH);
+		rx_status->flag |= RX_FLAG_RADIOTAP_LSIG;
+		break;
+	default:
+		break;
+	}
+}
+
 void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 			struct iwl_rx_cmd_buffer *rxb, int queue)
 {
@@ -1304,6 +1306,10 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 	struct sk_buff *skb;
 	u8 crypt_len = 0, channel, energy_a, energy_b;
 	size_t desc_size;
+	struct iwl_mvm_rx_phy_data phy_data = {
+		.d4 = desc->phy_data4,
+		.info_type = IWL_RX_PHY_INFO_TYPE_NONE,
+	};
 
 	if (unlikely(test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)))
 		return;
@@ -1315,6 +1321,11 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 		energy_a = desc->v3.energy_a;
 		energy_b = desc->v3.energy_b;
 		desc_size = sizeof(*desc);
+
+		phy_data.d0 = desc->v3.phy_data0;
+		phy_data.d1 = desc->v3.phy_data1;
+		phy_data.d2 = desc->v3.phy_data2;
+		phy_data.d3 = desc->v3.phy_data3;
 	} else {
 		rate_n_flags = le32_to_cpu(desc->v1.rate_n_flags);
 		channel = desc->v1.channel;
@@ -1322,8 +1333,18 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 		energy_a = desc->v1.energy_a;
 		energy_b = desc->v1.energy_b;
 		desc_size = IWL_RX_DESC_SIZE_V1;
+
+		phy_data.d0 = desc->v1.phy_data0;
+		phy_data.d1 = desc->v1.phy_data1;
+		phy_data.d2 = desc->v1.phy_data2;
+		phy_data.d3 = desc->v1.phy_data3;
 	}
 
+	if (phy_info & IWL_RX_MPDU_PHY_TSF_OVERLOAD)
+		phy_data.info_type =
+			le32_get_bits(phy_data.d1,
+				      IWL_RX_PHY_DATA1_INFO_TYPE_MASK);
+
 	hdr = (void *)(pkt->data + desc_size);
 	/* Dont use dev_alloc_skb(), we'll have enough headroom once
 	 * ieee80211_hdr pulled.
@@ -1362,7 +1383,10 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 	}
 
 	if (rate_n_flags & RATE_MCS_HE_MSK)
-		iwl_mvm_rx_he(mvm, skb, desc, rate_n_flags, phy_info, queue);
+		iwl_mvm_rx_he(mvm, skb, &phy_data, rate_n_flags,
+			      phy_info, queue);
+
+	iwl_mvm_decode_lsig(skb, &phy_data);
 
 	rx_status = IEEE80211_SKB_RXCB(skb);
 
-- 
2.19.1

