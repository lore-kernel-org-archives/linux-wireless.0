Return-Path: <SRS0=iPli=OC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CF86C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 11:27:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6C1C206B2
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 11:27:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E6C1C206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409646AbeKWWKy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 23 Nov 2018 17:10:54 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:38346 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2409641AbeKWWKy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Nov 2018 17:10:54 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gQ9bj-0008GU-PX; Fri, 23 Nov 2018 13:26:48 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 23 Nov 2018 13:26:29 +0200
Message-Id: <20181123112631.29360-14-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181123112631.29360-1-luca@coelho.fi>
References: <20181123112631.29360-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 13/15] iwlwifi: mvm: radiotap: remove UL_DL bit in HE TRIG_BASED
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shaul Triebitz <shaul.triebitz@intel.com>

UL_DL is irrelevant to HE TRIG_BASED PPDU.

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 87c245c85d9c..8b014456e6d8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -1032,7 +1032,6 @@ static void iwl_mvm_decode_he_phy_data(struct iwl_mvm *mvm,
 	case IWL_RX_PHY_INFO_TYPE_HE_TB:
 		/* HE common */
 		he->data1 |= cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_LDPC_XSYMSEG_KNOWN |
-					 IEEE80211_RADIOTAP_HE_DATA1_UL_DL_KNOWN |
 					 IEEE80211_RADIOTAP_HE_DATA1_SPTL_REUSE_KNOWN |
 					 IEEE80211_RADIOTAP_HE_DATA1_DOPPLER_KNOWN |
 					 IEEE80211_RADIOTAP_HE_DATA1_BSS_COLOR_KNOWN);
@@ -1043,9 +1042,13 @@ static void iwl_mvm_decode_he_phy_data(struct iwl_mvm *mvm,
 		he->data3 |= le16_encode_bits(le32_get_bits(phy_data->d0,
 							    IWL_RX_PHY_DATA0_HE_BSS_COLOR_MASK),
 					      IEEE80211_RADIOTAP_HE_DATA3_BSS_COLOR);
-		he->data3 |= le16_encode_bits(le32_get_bits(phy_data->d0,
+		if (phy_data->info_type != IWL_RX_PHY_INFO_TYPE_HE_TB &&
+		    phy_data->info_type != IWL_RX_PHY_INFO_TYPE_HE_TB_EXT) {
+			he->data1 |= cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_UL_DL_KNOWN);
+			he->data3 |= le16_encode_bits(le32_get_bits(phy_data->d0,
 							    IWL_RX_PHY_DATA0_HE_UPLINK),
-					      IEEE80211_RADIOTAP_HE_DATA3_UL_DL);
+						      IEEE80211_RADIOTAP_HE_DATA3_UL_DL);
+		}
 		he->data3 |= le16_encode_bits(le32_get_bits(phy_data->d0,
 							    IWL_RX_PHY_DATA0_HE_LDPC_EXT_SYM),
 					      IEEE80211_RADIOTAP_HE_DATA3_LDPC_XSYMSEG);
-- 
2.19.1

