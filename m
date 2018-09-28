Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A43C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 08:23:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5788B2172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 08:23:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5788B2172C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729119AbeI1OqS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 10:46:18 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:53496 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728062AbeI1OqS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 10:46:18 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g5o2a-0004tY-Fz; Fri, 28 Sep 2018 11:22:24 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 28 Sep 2018 11:22:02 +0300
Message-Id: <20180928082210.20762-11-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20180928082210.20762-1-luca@coelho.fi>
References: <20180928082210.20762-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 10/18] iwlwifi: mvm: minor cleanups to HE radiotap code
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Remove a stray empty line, unbreak some lines that aren't
really that long, and move on variable setting into the
initializer to avoid initializing it twice.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 7722aac88e85..7480df82e53a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -933,9 +933,8 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 	u64 he_phy_data = HE_PHY_DATA_INVAL;
 	struct ieee80211_radiotap_he *he = NULL;
 	struct ieee80211_radiotap_he_mu *he_mu = NULL;
-	u32 he_type = 0xffffffff;
+	u32 he_type = rate_n_flags & RATE_MCS_HE_TYPE_MSK;
 	u8 stbc, ltf;
-
 	static const struct ieee80211_radiotap_he known = {
 		.data1 = cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_DATA_MCS_KNOWN |
 				     IEEE80211_RADIOTAP_HE_DATA1_DATA_DCM_KNOWN |
@@ -959,18 +958,14 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 	radiotap_len += sizeof(known);
 	rx_status->flag |= RX_FLAG_RADIOTAP_HE;
 
-	he_type = rate_n_flags & RATE_MCS_HE_TYPE_MSK;
-
 	if (phy_info & IWL_RX_MPDU_PHY_TSF_OVERLOAD) {
-		if (mvm->trans->cfg->device_family >=
-				IWL_DEVICE_FAMILY_22560)
+		if (mvm->trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560)
 			he_phy_data = le64_to_cpu(desc->v3.he_phy_data);
 		else
 			he_phy_data = le64_to_cpu(desc->v1.he_phy_data);
 
 		if (he_type == RATE_MCS_HE_TYPE_MU) {
-			he_mu = skb_put_data(skb, &mu_known,
-					     sizeof(mu_known));
+			he_mu = skb_put_data(skb, &mu_known, sizeof(mu_known));
 			radiotap_len += sizeof(mu_known);
 			rx_status->flag |= RX_FLAG_RADIOTAP_HE_MU;
 		}
-- 
2.19.0

