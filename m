Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80364C282D9
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:22:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C43A218AF
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:22:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbfAaUWW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 15:22:22 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:53584 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728005AbfAaUWV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 15:22:21 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gpIqq-0004pL-6i; Thu, 31 Jan 2019 22:22:20 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Thu, 31 Jan 2019 22:21:52 +0200
Message-Id: <20190131202206.15903-8-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190131202206.15903-1-luca@coelho.fi>
References: <20190131202206.15903-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 07/21] iwlwifi: mvm: add HE TB PPDU SIG-A BW to radiotap
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Expose the trigger-based PPDU SIG-A bandwidth to radiotap in
the newly defined bits thereof.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 21 +++++++++++++------
 include/net/ieee80211_radiotap.h              |  6 ++++++
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index b5ff3325c1d3..d2728fe6a041 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -960,6 +960,7 @@ iwl_mvm_decode_he_phy_ru_alloc(struct iwl_mvm_rx_phy_data *phy_data,
 	 * the TSF/timers are not be transmitted in HE-MU.
 	 */
 	u8 ru = le32_get_bits(phy_data->d1, IWL_RX_PHY_DATA1_HE_RU_ALLOC_MASK);
+	u32 he_type = rate_n_flags & RATE_MCS_HE_TYPE_MSK;
 	u8 offs = 0;
 
 	rx_status->bw = RATE_INFO_BW_HE_RU;
@@ -1002,19 +1003,27 @@ iwl_mvm_decode_he_phy_ru_alloc(struct iwl_mvm_rx_phy_data *phy_data,
 		he->data2 |=
 			cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA2_PRISEC_80_SEC);
 
-	if (he_mu) {
 #define CHECK_BW(bw) \
 	BUILD_BUG_ON(IEEE80211_RADIOTAP_HE_MU_FLAGS2_BW_FROM_SIG_A_BW_ ## bw ## MHZ != \
+		     RATE_MCS_CHAN_WIDTH_##bw >> RATE_MCS_CHAN_WIDTH_POS); \
+	BUILD_BUG_ON(IEEE80211_RADIOTAP_HE_DATA6_TB_PPDU_BW_ ## bw ## MHZ != \
 		     RATE_MCS_CHAN_WIDTH_##bw >> RATE_MCS_CHAN_WIDTH_POS)
-		CHECK_BW(20);
-		CHECK_BW(40);
-		CHECK_BW(80);
-		CHECK_BW(160);
+	CHECK_BW(20);
+	CHECK_BW(40);
+	CHECK_BW(80);
+	CHECK_BW(160);
+
+	if (he_mu)
 		he_mu->flags2 |=
 			le16_encode_bits(FIELD_GET(RATE_MCS_CHAN_WIDTH_MSK,
 						   rate_n_flags),
 					 IEEE80211_RADIOTAP_HE_MU_FLAGS2_BW_FROM_SIG_A_BW);
-	}
+	else if (he_type == RATE_MCS_HE_TYPE_TRIG)
+		he->data6 |=
+			cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA6_TB_PPDU_BW_KNOWN) |
+			le16_encode_bits(FIELD_GET(RATE_MCS_CHAN_WIDTH_MSK,
+						   rate_n_flags),
+					 IEEE80211_RADIOTAP_HE_DATA6_TB_PPDU_BW);
 }
 
 static void iwl_mvm_decode_he_phy_data(struct iwl_mvm *mvm,
diff --git a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radiotap.h
index 8014153bdd49..38c48bb80439 100644
--- a/include/net/ieee80211_radiotap.h
+++ b/include/net/ieee80211_radiotap.h
@@ -291,6 +291,12 @@ enum ieee80211_radiotap_he_bits {
 
 	IEEE80211_RADIOTAP_HE_DATA6_NSTS		= 0x000f,
 	IEEE80211_RADIOTAP_HE_DATA6_DOPPLER		= 0x0010,
+	IEEE80211_RADIOTAP_HE_DATA6_TB_PPDU_BW_KNOWN	= 0x0020,
+	IEEE80211_RADIOTAP_HE_DATA6_TB_PPDU_BW		= 0x00c0,
+		IEEE80211_RADIOTAP_HE_DATA6_TB_PPDU_BW_20MHZ	= 0,
+		IEEE80211_RADIOTAP_HE_DATA6_TB_PPDU_BW_40MHZ	= 1,
+		IEEE80211_RADIOTAP_HE_DATA6_TB_PPDU_BW_80MHZ	= 2,
+		IEEE80211_RADIOTAP_HE_DATA6_TB_PPDU_BW_160MHZ	= 3,
 	IEEE80211_RADIOTAP_HE_DATA6_TXOP		= 0x7f00,
 	IEEE80211_RADIOTAP_HE_DATA6_MIDAMBLE_PDCTY	= 0x8000,
 };
-- 
2.20.1

