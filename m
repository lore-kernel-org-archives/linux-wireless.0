Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B93C3C282CB
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 10:47:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9299921919
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 10:47:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbfBHKrl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 05:47:41 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:57076 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727649AbfBHKrl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 05:47:41 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gs3gx-0002jg-Jy; Fri, 08 Feb 2019 12:47:32 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  8 Feb 2019 12:47:07 +0200
Message-Id: <20190208104712.16210-16-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190208104712.16210-1-luca@coelho.fi>
References: <20190208104712.16210-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 15/20] iwlwifi: mvm: fix the spatial reuse parsing for HE_TRIG PPDUs
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The spatial reuse 4 words fields are fetched from the HE-SIGA
by the firmware and propagated to the driver through the
Rx info. This is useful to populate the radiotap header.

We were looking at the wrong place in the firmware data and
got bogus values. Fix that.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Fixes: bdf180c8d375 ("iwlwifi: mvm: change PHY data RX for HE radiotap")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index b0a8d910c5c4..1e03acf30762 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -1074,16 +1074,16 @@ static void iwl_mvm_decode_he_phy_data(struct iwl_mvm *mvm,
 					 IEEE80211_RADIOTAP_HE_DATA1_SPTL_REUSE2_KNOWN |
 					 IEEE80211_RADIOTAP_HE_DATA1_SPTL_REUSE3_KNOWN |
 					 IEEE80211_RADIOTAP_HE_DATA1_SPTL_REUSE4_KNOWN);
-		he->data4 |= le16_encode_bits(le32_get_bits(phy_data->d0,
+		he->data4 |= le16_encode_bits(le32_get_bits(phy_data->d2,
 							    IWL_RX_PHY_DATA2_HE_TB_EXT_SPTL_REUSE1),
 					      IEEE80211_RADIOTAP_HE_DATA4_TB_SPTL_REUSE1);
-		he->data4 |= le16_encode_bits(le32_get_bits(phy_data->d0,
+		he->data4 |= le16_encode_bits(le32_get_bits(phy_data->d2,
 							    IWL_RX_PHY_DATA2_HE_TB_EXT_SPTL_REUSE2),
 					      IEEE80211_RADIOTAP_HE_DATA4_TB_SPTL_REUSE2);
-		he->data4 |= le16_encode_bits(le32_get_bits(phy_data->d0,
+		he->data4 |= le16_encode_bits(le32_get_bits(phy_data->d2,
 							    IWL_RX_PHY_DATA2_HE_TB_EXT_SPTL_REUSE3),
 					      IEEE80211_RADIOTAP_HE_DATA4_TB_SPTL_REUSE3);
-		he->data4 |= le16_encode_bits(le32_get_bits(phy_data->d0,
+		he->data4 |= le16_encode_bits(le32_get_bits(phy_data->d2,
 							    IWL_RX_PHY_DATA2_HE_TB_EXT_SPTL_REUSE4),
 					      IEEE80211_RADIOTAP_HE_DATA4_TB_SPTL_REUSE4);
 		/* fall through */
-- 
2.20.1

