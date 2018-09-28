Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 010A3C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 08:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB7222172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 08:23:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AB7222172C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728920AbeI1OqL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 10:46:11 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:53480 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728062AbeI1OqL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 10:46:11 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g5o2f-0004tY-Ii; Fri, 28 Sep 2018 11:22:29 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 28 Sep 2018 11:22:09 +0300
Message-Id: <20180928082210.20762-18-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20180928082210.20762-1-luca@coelho.fi>
References: <20180928082210.20762-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 17/18] iwlwifi: mvm: add more information to HE radiotap
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

For SU/SU-ER/MU PPDUs we have spatial reuse.

For those where it's relevant we also know the pre-FEC
padding factor, PE disambiguity bit, beam change bit
and doppler bit.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 35 ++++++++++++++++---
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index b6f7fae0d757..61916f39bac2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -1004,6 +1004,7 @@ static void iwl_mvm_decode_he_phy_data(struct iwl_mvm *mvm,
 				       int queue)
 {
 	u32 he_type = rate_n_flags & RATE_MCS_HE_TYPE_MSK;
+	bool sigb_data;
 
 	he->data1 |= cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_BSS_COLOR_KNOWN);
 	he->data3 |= le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_BSS_COLOR_MASK,
@@ -1015,9 +1016,8 @@ static void iwl_mvm_decode_he_phy_data(struct iwl_mvm *mvm,
 						he_phy_data),
 				      IEEE80211_RADIOTAP_HE_DATA6_TXOP);
 
-	if (he_mu) {
-		bool sigb_data;
-
+	switch (he_type) {
+	case RATE_MCS_HE_TYPE_MU:
 		he_mu->flags1 |=
 			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_MU_SIGB_DCM,
 						   he_phy_data),
@@ -1051,13 +1051,28 @@ static void iwl_mvm_decode_he_phy_data(struct iwl_mvm *mvm,
 			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_HE_LTF_NUM_MASK,
 						   he_phy_data),
 					 IEEE80211_RADIOTAP_HE_DATA5_NUM_LTF_SYMS);
+		break;
+	case RATE_MCS_HE_TYPE_SU:
+	case RATE_MCS_HE_TYPE_EXT_SU:
+		he->data1 |=
+			cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_BEAM_CHANGE_KNOWN);
+		he->data3 |=
+			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_BEAM_CHNG,
+						   he_phy_data),
+					 IEEE80211_RADIOTAP_HE_DATA3_BEAM_CHANGE);
+		break;
 	}
 
 	if (he_type != RATE_MCS_HE_TYPE_TRIG) {
 		u16 d1known = IEEE80211_RADIOTAP_HE_DATA1_LDPC_XSYMSEG_KNOWN |
-			      IEEE80211_RADIOTAP_HE_DATA1_UL_DL_KNOWN;
+			      IEEE80211_RADIOTAP_HE_DATA1_UL_DL_KNOWN |
+			      IEEE80211_RADIOTAP_HE_DATA1_SPTL_REUSE_KNOWN |
+			      IEEE80211_RADIOTAP_HE_DATA1_DOPPLER_KNOWN;
+		u16 d2known = IEEE80211_RADIOTAP_HE_DATA2_PRE_FEC_PAD_KNOWN |
+			      IEEE80211_RADIOTAP_HE_DATA2_PE_DISAMBIG_KNOWN;
 
 		he->data1 |= cpu_to_le16(d1known);
+		he->data2 |= cpu_to_le16(d2known);
 
 		he->data3 |= le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_UPLINK,
 							he_phy_data),
@@ -1065,6 +1080,18 @@ static void iwl_mvm_decode_he_phy_data(struct iwl_mvm *mvm,
 		he->data3 |= le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_LDPC_EXT_SYM,
 							he_phy_data),
 					      IEEE80211_RADIOTAP_HE_DATA3_LDPC_XSYMSEG);
+		he->data4 |= le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_SPATIAL_REUSE_MASK,
+							he_phy_data),
+					      IEEE80211_RADIOTAP_HE_DATA4_SU_MU_SPTL_REUSE);
+		he->data5 |= le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_PRE_FEC_PAD_MASK,
+							he_phy_data),
+					      IEEE80211_RADIOTAP_HE_DATA5_PRE_FEC_PAD);
+		he->data5 |= le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_PE_DISAMBIG,
+							he_phy_data),
+					      IEEE80211_RADIOTAP_HE_DATA5_PE_DISAMBIG);
+		he->data6 |= le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_DOPPLER,
+							he_phy_data),
+					      IEEE80211_RADIOTAP_HE_DATA6_DOPPLER);
 	}
 
 	switch (FIELD_GET(IWL_RX_HE_PHY_INFO_TYPE_MASK, he_phy_data)) {
-- 
2.19.0

