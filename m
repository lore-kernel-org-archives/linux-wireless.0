Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21806C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 08:23:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC4582172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 08:23:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC4582172C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729175AbeI1Oqd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 10:46:33 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:53528 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728062AbeI1Oqd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 10:46:33 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g5o2b-0004tY-U5; Fri, 28 Sep 2018 11:22:26 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 28 Sep 2018 11:22:04 +0300
Message-Id: <20180928082210.20762-13-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20180928082210.20762-1-luca@coelho.fi>
References: <20180928082210.20762-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 12/18] iwlwifi: mvm: pull some he_phy_data decoding into a separate function
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Pull some of the decoding of he_phy_data into a separate function so
we don't need to check over and over again if it's valid.

While at it, fix the UL/DL bit reporting to be for all but trigger-
based frames.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 105 ++++++++++--------
 1 file changed, 59 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 1288fdfc9c69..419f9cf5476b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -923,6 +923,60 @@ static void iwl_mvm_decode_he_sigb(struct iwl_mvm *mvm,
 	}
 }
 
+static void iwl_mvm_decode_he_phy_data(struct iwl_mvm *mvm,
+				       struct iwl_rx_mpdu_desc *desc,
+				       struct ieee80211_radiotap_he *he,
+				       struct ieee80211_radiotap_he_mu *he_mu,
+				       u64 he_phy_data, u32 rate_n_flags,
+				       int queue)
+{
+	u32 he_type = rate_n_flags & RATE_MCS_HE_TYPE_MSK;
+
+	he->data1 |= cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_BSS_COLOR_KNOWN);
+	he->data3 |= le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_BSS_COLOR_MASK,
+						he_phy_data),
+				      IEEE80211_RADIOTAP_HE_DATA3_BSS_COLOR);
+
+	if (he_mu) {
+		bool sigb_data;
+
+		he_mu->flags1 |=
+			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_MU_SIGB_DCM,
+						   he_phy_data),
+					 IEEE80211_RADIOTAP_HE_MU_FLAGS1_SIG_B_DCM);
+		he_mu->flags1 |=
+			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_MU_SIGB_MCS_MASK,
+						   he_phy_data),
+					 IEEE80211_RADIOTAP_HE_MU_FLAGS1_SIG_B_MCS);
+		he_mu->flags2 |=
+			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_MU_SIBG_SYM_OR_USER_NUM_MASK,
+						  he_phy_data),
+					IEEE80211_RADIOTAP_HE_MU_FLAGS2_SIG_B_SYMS_USERS);
+		he_mu->flags2 |=
+			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_MU_SIGB_COMPRESSION,
+						   he_phy_data),
+					 IEEE80211_RADIOTAP_HE_MU_FLAGS2_SIG_B_COMP);
+		he_mu->flags2 |=
+			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_MU_PREAMBLE_PUNC_TYPE_MASK,
+						   he_phy_data),
+					 IEEE80211_RADIOTAP_HE_MU_FLAGS2_PUNC_FROM_SIG_A_BW);
+
+		sigb_data = FIELD_GET(IWL_RX_HE_PHY_INFO_TYPE_MASK,
+				      he_phy_data) ==
+				IWL_RX_HE_PHY_INFO_TYPE_MU_EXT_INFO;
+		if (sigb_data)
+			iwl_mvm_decode_he_sigb(mvm, desc, rate_n_flags, he_mu);
+	}
+
+	if (he_type != RATE_MCS_HE_TYPE_TRIG) {
+		he->data1 |=
+			cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_UL_DL_KNOWN);
+		if (FIELD_GET(IWL_RX_HE_PHY_UPLINK, he_phy_data))
+			he->data3 |=
+				cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA3_UL_DL);
+	}
+}
+
 static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 			  struct iwl_rx_mpdu_desc *desc,
 			  u32 rate_n_flags, u16 phy_info, int queue)
@@ -952,7 +1006,6 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 				      IEEE80211_RADIOTAP_HE_MU_FLAGS2_BW_FROM_SIG_A_BW_KNOWN),
 	};
 	unsigned int radiotap_len = 0;
-	bool sigb_data = false;
 
 	he = skb_put_data(skb, &known, sizeof(known));
 	radiotap_len += sizeof(known);
@@ -976,59 +1029,19 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 
 	if (he_phy_data != HE_PHY_DATA_INVAL &&
 	    he_type == RATE_MCS_HE_TYPE_SU) {
-		he->data1 |=
-			cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_UL_DL_KNOWN);
-		if (FIELD_GET(IWL_RX_HE_PHY_UPLINK, he_phy_data))
-			he->data3 |=
-				cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA3_UL_DL);
-
+		/* report the AMPDU-EOF bit on single frames */
 		if (!queue && !(phy_info & IWL_RX_MPDU_PHY_AMPDU)) {
 			rx_status->flag |= RX_FLAG_AMPDU_DETAILS;
 			rx_status->flag |= RX_FLAG_AMPDU_EOF_BIT_KNOWN;
 			if (FIELD_GET(IWL_RX_HE_PHY_DELIM_EOF, he_phy_data))
 				rx_status->flag |= RX_FLAG_AMPDU_EOF_BIT;
 		}
-	} else if (he_phy_data != HE_PHY_DATA_INVAL && he_mu) {
-		he_mu->flags1 |=
-			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_MU_SIGB_DCM,
-						   he_phy_data),
-					 IEEE80211_RADIOTAP_HE_MU_FLAGS1_SIG_B_DCM);
-		he_mu->flags1 |=
-			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_MU_SIGB_MCS_MASK,
-						   he_phy_data),
-					 IEEE80211_RADIOTAP_HE_MU_FLAGS1_SIG_B_MCS);
-		he_mu->flags2 |=
-			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_MU_SIBG_SYM_OR_USER_NUM_MASK,
-						   he_phy_data),
-					 IEEE80211_RADIOTAP_HE_MU_FLAGS2_SIG_B_SYMS_USERS);
-		he_mu->flags2 |=
-			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_MU_SIGB_COMPRESSION,
-						   he_phy_data),
-					 IEEE80211_RADIOTAP_HE_MU_FLAGS2_SIG_B_COMP);
-		he_mu->flags2 |=
-			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_MU_PREAMBLE_PUNC_TYPE_MASK,
-						   he_phy_data),
-					 IEEE80211_RADIOTAP_HE_MU_FLAGS2_PUNC_FROM_SIG_A_BW);
-
-		sigb_data = FIELD_GET(IWL_RX_HE_PHY_INFO_TYPE_MASK,
-				      he_phy_data) ==
-				IWL_RX_HE_PHY_INFO_TYPE_MU_EXT_INFO;
-		if (sigb_data)
-			iwl_mvm_decode_he_sigb(mvm, desc, rate_n_flags, he_mu);
-	}
-	if (he_phy_data != HE_PHY_DATA_INVAL &&
-	    (he_type == RATE_MCS_HE_TYPE_SU ||
-	     he_type == RATE_MCS_HE_TYPE_MU)) {
-		u8 bss_color = FIELD_GET(IWL_RX_HE_PHY_BSS_COLOR_MASK,
-					 he_phy_data);
-
-		if (bss_color) {
-			he->data1 |=
-				cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_BSS_COLOR_KNOWN);
-			he->data3 |= cpu_to_le16(bss_color);
-		}
 	}
 
+	if (he_phy_data != HE_PHY_DATA_INVAL)
+		iwl_mvm_decode_he_phy_data(mvm, desc, he, he_mu, he_phy_data,
+					   rate_n_flags, queue);
+
 	/* update aggregation data for monitor sake on default queue */
 	if (!queue && (phy_info & IWL_RX_MPDU_PHY_AMPDU)) {
 		bool toggle_bit = phy_info & IWL_RX_MPDU_PHY_AMPDU_TOGGLE;
-- 
2.19.0

