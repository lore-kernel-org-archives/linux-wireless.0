Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AA53C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 08:24:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54C3F2172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 08:24:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 54C3F2172C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729177AbeI1Oqg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 10:46:36 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:53536 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728062AbeI1Oqg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 10:46:36 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g5o2d-0004tY-Fh; Fri, 28 Sep 2018 11:22:27 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 28 Sep 2018 11:22:06 +0300
Message-Id: <20180928082210.20762-15-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20180928082210.20762-1-luca@coelho.fi>
References: <20180928082210.20762-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 14/18] iwlwifi: mvm: move HE-MU LTF_NUM parsing to he_phy_data parsing
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

This code gets shorter if it doesn't have to check all the
conditions, so move it to an appropriate place that has all
of them validated already.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 35 ++++++-------------
 1 file changed, 10 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 757ff6b9efe0..647fa905ebba 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -1039,6 +1039,13 @@ static void iwl_mvm_decode_he_phy_data(struct iwl_mvm *mvm,
 				IWL_RX_HE_PHY_INFO_TYPE_MU_EXT_INFO;
 		if (sigb_data)
 			iwl_mvm_decode_he_sigb(mvm, desc, rate_n_flags, he_mu);
+
+		he->data2 |=
+			cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA2_NUM_LTF_SYMS_KNOWN);
+		he->data5 |=
+			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_HE_LTF_NUM_MASK,
+						   he_phy_data),
+					 IEEE80211_RADIOTAP_HE_DATA5_NUM_LTF_SYMS);
 	}
 
 	if (he_type != RATE_MCS_HE_TYPE_TRIG) {
@@ -1222,9 +1229,8 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 
 	he->data5 |= le16_encode_bits(ltf, IEEE80211_RADIOTAP_HE_DATA5_LTF_SIZE);
 
-	switch (he_type) {
-	case RATE_MCS_HE_TYPE_SU:
-	case RATE_MCS_HE_TYPE_EXT_SU: {
+	if (he_type == RATE_MCS_HE_TYPE_SU ||
+	    he_type == RATE_MCS_HE_TYPE_EXT_SU) {
 		u16 val;
 
 		/* LTF syms correspond to streams */
@@ -1254,31 +1260,10 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 				  rx_status->nss);
 			val = 0;
 		}
+
 		he->data5 |=
 			le16_encode_bits(val,
 					 IEEE80211_RADIOTAP_HE_DATA5_NUM_LTF_SYMS);
-		}
-		break;
-	case RATE_MCS_HE_TYPE_MU: {
-		u16 val;
-
-		if (he_phy_data == HE_PHY_DATA_INVAL)
-			break;
-
-		val = FIELD_GET(IWL_RX_HE_PHY_HE_LTF_NUM_MASK,
-				he_phy_data);
-
-		he->data2 |=
-			cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA2_NUM_LTF_SYMS_KNOWN);
-		he->data5 |=
-			cpu_to_le16(FIELD_PREP(
-				IEEE80211_RADIOTAP_HE_DATA5_NUM_LTF_SYMS,
-				val));
-		}
-		break;
-	case RATE_MCS_HE_TYPE_TRIG:
-		/* not supported */
-		break;
 	}
 }
 
-- 
2.19.0

