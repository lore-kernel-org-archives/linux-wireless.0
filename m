Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DC37C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 08:24:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DED02172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 08:24:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2DED02172C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729179AbeI1Oqk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 10:46:40 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:53544 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728062AbeI1Oqk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 10:46:40 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g5o2b-0004tY-7w; Fri, 28 Sep 2018 11:22:25 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 28 Sep 2018 11:22:03 +0300
Message-Id: <20180928082210.20762-12-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20180928082210.20762-1-luca@coelho.fi>
References: <20180928082210.20762-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 11/18] iwlwifi: mvm: put HE SIG-B symbols/users data correctly
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

As detected by Luca during code review when I move this in the
next patch, the code here is putting the data into the wrong
field (flags1 instead of flags2). Fix that.

Fixes: e5721e3f770f ("iwlwifi: mvm: add radiotap data for HE")
Reported-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 7480df82e53a..1288fdfc9c69 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -989,10 +989,6 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 				rx_status->flag |= RX_FLAG_AMPDU_EOF_BIT;
 		}
 	} else if (he_phy_data != HE_PHY_DATA_INVAL && he_mu) {
-		he_mu->flags1 |=
-			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_MU_SIBG_SYM_OR_USER_NUM_MASK,
-						   he_phy_data),
-					 IEEE80211_RADIOTAP_HE_MU_FLAGS2_SIG_B_SYMS_USERS);
 		he_mu->flags1 |=
 			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_MU_SIGB_DCM,
 						   he_phy_data),
@@ -1001,6 +997,10 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_MU_SIGB_MCS_MASK,
 						   he_phy_data),
 					 IEEE80211_RADIOTAP_HE_MU_FLAGS1_SIG_B_MCS);
+		he_mu->flags2 |=
+			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_MU_SIBG_SYM_OR_USER_NUM_MASK,
+						   he_phy_data),
+					 IEEE80211_RADIOTAP_HE_MU_FLAGS2_SIG_B_SYMS_USERS);
 		he_mu->flags2 |=
 			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_MU_SIGB_COMPRESSION,
 						   he_phy_data),
-- 
2.19.0

