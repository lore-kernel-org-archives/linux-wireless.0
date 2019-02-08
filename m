Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D9CAC282CC
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 10:47:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA91E21924
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 10:47:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbfBHKra (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 05:47:30 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:57022 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727724AbfBHKr3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 05:47:29 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gs3gt-0002jg-Jz; Fri, 08 Feb 2019 12:47:28 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  8 Feb 2019 12:47:02 +0200
Message-Id: <20190208104712.16210-11-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190208104712.16210-1-luca@coelho.fi>
References: <20190208104712.16210-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 10/20] iwlwifi: mvm: fix HE radiotap data4 for HE-TB PPDUs
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

In HE-TB PPDUs (labeled HE-TRIG in radiotap), we were overwriting
the data4.spatial_reuse_1 field with the spatial reuse data that
the firmware gives us for SU/MU PPDUs. Fix that by moving that,
we are already setting the data4.spatial_reuse_{1,2,3,4} fields
in the TB PPDU case.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Fixes: 69f3ca8ed33d ("iwlwifi: mvm: show more HE radiotap data for TB PPDUs")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 557a0b5a08ac..b0a8d910c5c4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -1093,7 +1093,6 @@ static void iwl_mvm_decode_he_phy_data(struct iwl_mvm *mvm,
 	case IWL_RX_PHY_INFO_TYPE_HE_TB:
 		/* HE common */
 		he->data1 |= cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_LDPC_XSYMSEG_KNOWN |
-					 IEEE80211_RADIOTAP_HE_DATA1_SPTL_REUSE_KNOWN |
 					 IEEE80211_RADIOTAP_HE_DATA1_DOPPLER_KNOWN |
 					 IEEE80211_RADIOTAP_HE_DATA1_BSS_COLOR_KNOWN);
 		he->data2 |= cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA2_PRE_FEC_PAD_KNOWN |
@@ -1113,9 +1112,6 @@ static void iwl_mvm_decode_he_phy_data(struct iwl_mvm *mvm,
 		he->data3 |= le16_encode_bits(le32_get_bits(phy_data->d0,
 							    IWL_RX_PHY_DATA0_HE_LDPC_EXT_SYM),
 					      IEEE80211_RADIOTAP_HE_DATA3_LDPC_XSYMSEG);
-		he->data4 |= le16_encode_bits(le32_get_bits(phy_data->d0,
-							    IWL_RX_PHY_DATA0_HE_SPATIAL_REUSE_MASK),
-					      IEEE80211_RADIOTAP_HE_DATA4_SU_MU_SPTL_REUSE);
 		he->data5 |= le16_encode_bits(le32_get_bits(phy_data->d0,
 							    IWL_RX_PHY_DATA0_HE_PRE_FEC_PAD_MASK),
 					      IEEE80211_RADIOTAP_HE_DATA5_PRE_FEC_PAD);
@@ -1134,6 +1130,20 @@ static void iwl_mvm_decode_he_phy_data(struct iwl_mvm *mvm,
 		break;
 	}
 
+	switch (phy_data->info_type) {
+	case IWL_RX_PHY_INFO_TYPE_HE_MU_EXT:
+	case IWL_RX_PHY_INFO_TYPE_HE_MU:
+	case IWL_RX_PHY_INFO_TYPE_HE_SU:
+		he->data1 |= cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_SPTL_REUSE_KNOWN);
+		he->data4 |= le16_encode_bits(le32_get_bits(phy_data->d0,
+							    IWL_RX_PHY_DATA0_HE_SPATIAL_REUSE_MASK),
+					      IEEE80211_RADIOTAP_HE_DATA4_SU_MU_SPTL_REUSE);
+		break;
+	default:
+		/* nothing here */
+		break;
+	}
+
 	switch (phy_data->info_type) {
 	case IWL_RX_PHY_INFO_TYPE_HE_MU_EXT:
 		he_mu->flags1 |=
-- 
2.20.1

