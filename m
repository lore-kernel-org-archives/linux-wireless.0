Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55323C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 08:23:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16F902172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 08:23:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 16F902172C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729150AbeI1OqW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 10:46:22 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:53504 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728062AbeI1OqW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 10:46:22 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g5o2c-0004tY-MY; Fri, 28 Sep 2018 11:22:27 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 28 Sep 2018 11:22:05 +0300
Message-Id: <20180928082210.20762-14-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20180928082210.20762-1-luca@coelho.fi>
References: <20180928082210.20762-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 13/18] iwlwifi: mvm: clean up HE radiotap RU allocation parsing
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Split the code out into a separate routine, and move that to be
called inside the previously introduced iwl_mvm_decode_he_phy_data()
function.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 166 ++++++++++--------
 1 file changed, 89 insertions(+), 77 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 419f9cf5476b..757ff6b9efe0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -923,10 +923,83 @@ static void iwl_mvm_decode_he_sigb(struct iwl_mvm *mvm,
 	}
 }
 
+static void
+iwl_mvm_decode_he_phy_ru_alloc(u64 he_phy_data, u32 rate_n_flags,
+			       struct ieee80211_radiotap_he *he,
+			       struct ieee80211_radiotap_he_mu *he_mu,
+			       struct ieee80211_rx_status *rx_status)
+{
+	/*
+	 * Unfortunately, we have to leave the mac80211 data
+	 * incorrect for the case that we receive an HE-MU
+	 * transmission and *don't* have the HE phy data (due
+	 * to the bits being used for TSF). This shouldn't
+	 * happen though as management frames where we need
+	 * the TSF/timers are not be transmitted in HE-MU.
+	 */
+	u8 ru = FIELD_GET(IWL_RX_HE_PHY_RU_ALLOC_MASK, he_phy_data);
+	u8 offs = 0;
+
+	rx_status->bw = RATE_INFO_BW_HE_RU;
+
+	he->data1 |= cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_BW_RU_ALLOC_KNOWN);
+
+	switch (ru) {
+	case 0 ... 36:
+		rx_status->he_ru = NL80211_RATE_INFO_HE_RU_ALLOC_26;
+		offs = ru;
+		break;
+	case 37 ... 52:
+		rx_status->he_ru = NL80211_RATE_INFO_HE_RU_ALLOC_52;
+		offs = ru - 37;
+		break;
+	case 53 ... 60:
+		rx_status->he_ru = NL80211_RATE_INFO_HE_RU_ALLOC_106;
+		offs = ru - 53;
+		break;
+	case 61 ... 64:
+		rx_status->he_ru = NL80211_RATE_INFO_HE_RU_ALLOC_242;
+		offs = ru - 61;
+		break;
+	case 65 ... 66:
+		rx_status->he_ru = NL80211_RATE_INFO_HE_RU_ALLOC_484;
+		offs = ru - 65;
+		break;
+	case 67:
+		rx_status->he_ru = NL80211_RATE_INFO_HE_RU_ALLOC_996;
+		break;
+	case 68:
+		rx_status->he_ru = NL80211_RATE_INFO_HE_RU_ALLOC_2x996;
+		break;
+	}
+	he->data2 |= le16_encode_bits(offs,
+				      IEEE80211_RADIOTAP_HE_DATA2_RU_OFFSET);
+	he->data2 |= cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA2_PRISEC_80_KNOWN |
+				 IEEE80211_RADIOTAP_HE_DATA2_RU_OFFSET_KNOWN);
+	if (he_phy_data & IWL_RX_HE_PHY_RU_ALLOC_SEC80)
+		he->data2 |=
+			cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA2_PRISEC_80_SEC);
+
+	if (he_mu) {
+#define CHECK_BW(bw) \
+	BUILD_BUG_ON(IEEE80211_RADIOTAP_HE_MU_FLAGS2_BW_FROM_SIG_A_BW_ ## bw ## MHZ != \
+		     RATE_MCS_CHAN_WIDTH_##bw >> RATE_MCS_CHAN_WIDTH_POS)
+		CHECK_BW(20);
+		CHECK_BW(40);
+		CHECK_BW(80);
+		CHECK_BW(160);
+		he_mu->flags2 |=
+			le16_encode_bits(FIELD_GET(RATE_MCS_CHAN_WIDTH_MSK,
+						   rate_n_flags),
+					 IEEE80211_RADIOTAP_HE_MU_FLAGS2_BW_FROM_SIG_A_BW);
+	}
+}
+
 static void iwl_mvm_decode_he_phy_data(struct iwl_mvm *mvm,
 				       struct iwl_rx_mpdu_desc *desc,
 				       struct ieee80211_radiotap_he *he,
 				       struct ieee80211_radiotap_he_mu *he_mu,
+				       struct ieee80211_rx_status *rx_status,
 				       u64 he_phy_data, u32 rate_n_flags,
 				       int queue)
 {
@@ -975,6 +1048,17 @@ static void iwl_mvm_decode_he_phy_data(struct iwl_mvm *mvm,
 			he->data3 |=
 				cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA3_UL_DL);
 	}
+
+	switch (FIELD_GET(IWL_RX_HE_PHY_INFO_TYPE_MASK, he_phy_data)) {
+	case IWL_RX_HE_PHY_INFO_TYPE_MU_EXT_INFO:
+	case IWL_RX_HE_PHY_INFO_TYPE_TB_EXT_INFO:
+		iwl_mvm_decode_he_phy_ru_alloc(he_phy_data, rate_n_flags,
+					       he, he_mu, rx_status);
+		break;
+	default:
+		/* nothing */
+		break;
+	}
 }
 
 static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
@@ -1039,8 +1123,8 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 	}
 
 	if (he_phy_data != HE_PHY_DATA_INVAL)
-		iwl_mvm_decode_he_phy_data(mvm, desc, he, he_mu, he_phy_data,
-					   rate_n_flags, queue);
+		iwl_mvm_decode_he_phy_data(mvm, desc, he, he_mu, rx_status,
+					   he_phy_data, rate_n_flags, queue);
 
 	/* update aggregation data for monitor sake on default queue */
 	if (!queue && (phy_info & IWL_RX_MPDU_PHY_AMPDU)) {
@@ -1064,84 +1148,12 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 		rx_status->he_ru = NL80211_RATE_INFO_HE_RU_ALLOC_106;
 	}
 
-	if (he_phy_data != HE_PHY_DATA_INVAL &&
-	    (FIELD_GET(IWL_RX_HE_PHY_INFO_TYPE_MASK, he_phy_data) ==
-			IWL_RX_HE_PHY_INFO_TYPE_MU_EXT_INFO ||
-	     FIELD_GET(IWL_RX_HE_PHY_INFO_TYPE_MASK, he_phy_data) ==
-			IWL_RX_HE_PHY_INFO_TYPE_TB_EXT_INFO)) {
-		/*
-		 * Unfortunately, we have to leave the mac80211 data
-		 * incorrect for the case that we receive an HE-MU
-		 * transmission and *don't* have the HE phy data (due
-		 * to the bits being used for TSF). This shouldn't
-		 * happen though as management frames where we need
-		 * the TSF/timers are not be transmitted in HE-MU.
-		 */
-		u8 ru = FIELD_GET(IWL_RX_HE_PHY_RU_ALLOC_MASK, he_phy_data);
-		u8 offs = 0;
-
-		rx_status->bw = RATE_INFO_BW_HE_RU;
-
+	/* actually data is filled in mac80211 */
+	if (he_type == RATE_MCS_HE_TYPE_SU ||
+	    he_type == RATE_MCS_HE_TYPE_EXT_SU)
 		he->data1 |=
 			cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_BW_RU_ALLOC_KNOWN);
 
-		switch (ru) {
-		case 0 ... 36:
-			rx_status->he_ru = NL80211_RATE_INFO_HE_RU_ALLOC_26;
-			offs = ru;
-			break;
-		case 37 ... 52:
-			rx_status->he_ru = NL80211_RATE_INFO_HE_RU_ALLOC_52;
-			offs = ru - 37;
-			break;
-		case 53 ... 60:
-			rx_status->he_ru = NL80211_RATE_INFO_HE_RU_ALLOC_106;
-			offs = ru - 53;
-			break;
-		case 61 ... 64:
-			rx_status->he_ru = NL80211_RATE_INFO_HE_RU_ALLOC_242;
-			offs = ru - 61;
-			break;
-		case 65 ... 66:
-			rx_status->he_ru = NL80211_RATE_INFO_HE_RU_ALLOC_484;
-			offs = ru - 65;
-			break;
-		case 67:
-			rx_status->he_ru = NL80211_RATE_INFO_HE_RU_ALLOC_996;
-			break;
-		case 68:
-			rx_status->he_ru = NL80211_RATE_INFO_HE_RU_ALLOC_2x996;
-			break;
-		}
-		he->data2 |=
-			le16_encode_bits(offs,
-					 IEEE80211_RADIOTAP_HE_DATA2_RU_OFFSET);
-		he->data2 |=
-			cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA2_PRISEC_80_KNOWN |
-				    IEEE80211_RADIOTAP_HE_DATA2_RU_OFFSET_KNOWN);
-		if (he_phy_data & IWL_RX_HE_PHY_RU_ALLOC_SEC80)
-			he->data2 |=
-				cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA2_PRISEC_80_SEC);
-
-		if (he_mu) {
-#define CHECK_BW(bw) \
-	BUILD_BUG_ON(IEEE80211_RADIOTAP_HE_MU_FLAGS2_BW_FROM_SIG_A_BW_ ## bw ## MHZ != \
-		     RATE_MCS_CHAN_WIDTH_##bw >> RATE_MCS_CHAN_WIDTH_POS)
-			CHECK_BW(20);
-			CHECK_BW(40);
-			CHECK_BW(80);
-			CHECK_BW(160);
-			he->data2 |=
-				le16_encode_bits(FIELD_GET(RATE_MCS_CHAN_WIDTH_MSK,
-							   rate_n_flags),
-						 IEEE80211_RADIOTAP_HE_MU_FLAGS2_BW_FROM_SIG_A_BW);
-		}
-	} else if (he_type == RATE_MCS_HE_TYPE_SU ||
-		   he_type == RATE_MCS_HE_TYPE_EXT_SU) {
-		he->data1 |=
-			cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_BW_RU_ALLOC_KNOWN);
-	}
-
 	stbc = (rate_n_flags & RATE_MCS_STBC_MSK) >> RATE_MCS_STBC_POS;
 	rx_status->nss =
 		((rate_n_flags & RATE_VHT_MCS_NSS_MSK) >>
-- 
2.19.0

