Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5090C46470
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 08:22:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9432D2173D
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 08:22:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9432D2173D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbeI1OpC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 10:45:02 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:53436 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729143AbeI1OpA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 10:45:00 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g5o2Z-0004tY-Qk; Fri, 28 Sep 2018 11:22:24 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 28 Sep 2018 11:22:01 +0300
Message-Id: <20180928082210.20762-10-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20180928082210.20762-1-luca@coelho.fi>
References: <20180928082210.20762-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 09/18] iwlwifi: mvm: remove unnecessary overload variable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

This is equivalent to checking he_phy_data != HE_PHY_DATA_INVAL,
which is already done in a number of places, so remove the extra
'overload' variable entirely.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 5f79133029da..7722aac88e85 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -953,7 +953,6 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 				      IEEE80211_RADIOTAP_HE_MU_FLAGS2_BW_FROM_SIG_A_BW_KNOWN),
 	};
 	unsigned int radiotap_len = 0;
-	bool overload = phy_info & IWL_RX_MPDU_PHY_TSF_OVERLOAD;
 	bool sigb_data = false;
 
 	he = skb_put_data(skb, &known, sizeof(known));
@@ -980,7 +979,8 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 	/* temporarily hide the radiotap data */
 	__skb_pull(skb, radiotap_len);
 
-	if (overload && he_type == RATE_MCS_HE_TYPE_SU) {
+	if (he_phy_data != HE_PHY_DATA_INVAL &&
+	    he_type == RATE_MCS_HE_TYPE_SU) {
 		he->data1 |=
 			cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_UL_DL_KNOWN);
 		if (FIELD_GET(IWL_RX_HE_PHY_UPLINK, he_phy_data))
@@ -993,7 +993,7 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 			if (FIELD_GET(IWL_RX_HE_PHY_DELIM_EOF, he_phy_data))
 				rx_status->flag |= RX_FLAG_AMPDU_EOF_BIT;
 		}
-	} else if (overload && he_mu && he_phy_data != HE_PHY_DATA_INVAL) {
+	} else if (he_phy_data != HE_PHY_DATA_INVAL && he_mu) {
 		he_mu->flags1 |=
 			le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_MU_SIBG_SYM_OR_USER_NUM_MASK,
 						   he_phy_data),
-- 
2.19.0

