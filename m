Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5917C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 12:11:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 967BA2084C
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 12:11:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 967BA2084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729354AbeJASsm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 14:48:42 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:54450 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729111AbeJASsm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 14:48:42 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g6x1w-0006wq-De; Mon, 01 Oct 2018 15:10:28 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon,  1 Oct 2018 15:10:06 +0300
Message-Id: <20181001121010.29684-13-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181001121010.29684-1-luca@coelho.fi>
References: <20181001121010.29684-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 12/16] iwlwifi: mvm: show more HE radiotap data for TB PPDUs
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

For trigger-based PPDUs, most values aren't part of the HE-SIG-A
because they're preconfigured by the trigger frame. However, we
still have this information since we used the trigger frame to
configure the hardware, so we can (and do) read it back out and
can thus show it in radiotap.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 67 +++++++++----------
 1 file changed, 31 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index a63a073e8562..26ac9402568d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -1005,16 +1005,41 @@ static void iwl_mvm_decode_he_phy_data(struct iwl_mvm *mvm,
 {
 	u32 he_type = rate_n_flags & RATE_MCS_HE_TYPE_MSK;
 	bool sigb_data;
-
-	he->data1 |= cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_BSS_COLOR_KNOWN);
+	u16 d1known = IEEE80211_RADIOTAP_HE_DATA1_LDPC_XSYMSEG_KNOWN |
+		      IEEE80211_RADIOTAP_HE_DATA1_UL_DL_KNOWN |
+		      IEEE80211_RADIOTAP_HE_DATA1_SPTL_REUSE_KNOWN |
+		      IEEE80211_RADIOTAP_HE_DATA1_DOPPLER_KNOWN |
+		      IEEE80211_RADIOTAP_HE_DATA1_BSS_COLOR_KNOWN;
+	u16 d2known = IEEE80211_RADIOTAP_HE_DATA2_PRE_FEC_PAD_KNOWN |
+		      IEEE80211_RADIOTAP_HE_DATA2_PE_DISAMBIG_KNOWN |
+		      IEEE80211_RADIOTAP_HE_DATA2_TXOP_KNOWN;
+
+	he->data1 |= cpu_to_le16(d1known);
+	he->data2 |= cpu_to_le16(d2known);
 	he->data3 |= le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_BSS_COLOR_MASK,
 						he_phy_data),
 				      IEEE80211_RADIOTAP_HE_DATA3_BSS_COLOR);
-
-	he->data2 |= cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA2_TXOP_KNOWN);
+	he->data3 |= le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_UPLINK,
+						he_phy_data),
+				      IEEE80211_RADIOTAP_HE_DATA3_UL_DL);
+	he->data3 |= le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_LDPC_EXT_SYM,
+						he_phy_data),
+				      IEEE80211_RADIOTAP_HE_DATA3_LDPC_XSYMSEG);
+	he->data4 |= le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_SPATIAL_REUSE_MASK,
+						he_phy_data),
+				      IEEE80211_RADIOTAP_HE_DATA4_SU_MU_SPTL_REUSE);
+	he->data5 |= le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_PRE_FEC_PAD_MASK,
+						he_phy_data),
+				      IEEE80211_RADIOTAP_HE_DATA5_PRE_FEC_PAD);
+	he->data5 |= le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_PE_DISAMBIG,
+						he_phy_data),
+				      IEEE80211_RADIOTAP_HE_DATA5_PE_DISAMBIG);
 	he->data6 |= le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_TXOP_DUR_MASK,
 						he_phy_data),
 				      IEEE80211_RADIOTAP_HE_DATA6_TXOP);
+	he->data6 |= le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_DOPPLER,
+						he_phy_data),
+				      IEEE80211_RADIOTAP_HE_DATA6_DOPPLER);
 
 	switch (he_type) {
 	case RATE_MCS_HE_TYPE_MU:
@@ -1044,7 +1069,8 @@ static void iwl_mvm_decode_he_phy_data(struct iwl_mvm *mvm,
 				IWL_RX_HE_PHY_INFO_TYPE_MU_EXT_INFO;
 		if (sigb_data)
 			iwl_mvm_decode_he_sigb(mvm, desc, rate_n_flags, he_mu);
-
+		/* fall through */
+	case RATE_MCS_HE_TYPE_TRIG:
 		he->data2 |=
 			cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA2_NUM_LTF_SYMS_KNOWN);
 		he->data5 |=
@@ -1063,37 +1089,6 @@ static void iwl_mvm_decode_he_phy_data(struct iwl_mvm *mvm,
 		break;
 	}
 
-	if (he_type != RATE_MCS_HE_TYPE_TRIG) {
-		u16 d1known = IEEE80211_RADIOTAP_HE_DATA1_LDPC_XSYMSEG_KNOWN |
-			      IEEE80211_RADIOTAP_HE_DATA1_UL_DL_KNOWN |
-			      IEEE80211_RADIOTAP_HE_DATA1_SPTL_REUSE_KNOWN |
-			      IEEE80211_RADIOTAP_HE_DATA1_DOPPLER_KNOWN;
-		u16 d2known = IEEE80211_RADIOTAP_HE_DATA2_PRE_FEC_PAD_KNOWN |
-			      IEEE80211_RADIOTAP_HE_DATA2_PE_DISAMBIG_KNOWN;
-
-		he->data1 |= cpu_to_le16(d1known);
-		he->data2 |= cpu_to_le16(d2known);
-
-		he->data3 |= le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_UPLINK,
-							he_phy_data),
-					      IEEE80211_RADIOTAP_HE_DATA3_UL_DL);
-		he->data3 |= le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_LDPC_EXT_SYM,
-							he_phy_data),
-					      IEEE80211_RADIOTAP_HE_DATA3_LDPC_XSYMSEG);
-		he->data4 |= le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_SPATIAL_REUSE_MASK,
-							he_phy_data),
-					      IEEE80211_RADIOTAP_HE_DATA4_SU_MU_SPTL_REUSE);
-		he->data5 |= le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_PRE_FEC_PAD_MASK,
-							he_phy_data),
-					      IEEE80211_RADIOTAP_HE_DATA5_PRE_FEC_PAD);
-		he->data5 |= le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_PE_DISAMBIG,
-							he_phy_data),
-					      IEEE80211_RADIOTAP_HE_DATA5_PE_DISAMBIG);
-		he->data6 |= le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_DOPPLER,
-							he_phy_data),
-					      IEEE80211_RADIOTAP_HE_DATA6_DOPPLER);
-	}
-
 	switch (FIELD_GET(IWL_RX_HE_PHY_INFO_TYPE_MASK, he_phy_data)) {
 	case IWL_RX_HE_PHY_INFO_TYPE_MU:
 	case IWL_RX_HE_PHY_INFO_TYPE_MU_EXT_INFO:
-- 
2.19.0

