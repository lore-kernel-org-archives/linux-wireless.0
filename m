Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F500C282C0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 20:13:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D26D218B0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 20:13:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbfAYUNO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 15:13:14 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:50766 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726179AbfAYUNO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 15:13:14 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gn7qi-00010a-T8; Fri, 25 Jan 2019 22:13:13 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 25 Jan 2019 22:12:50 +0200
Message-Id: <20190125201305.5616-3-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190125201305.5616-1-luca@coelho.fi>
References: <20190125201305.5616-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 02/17] iwlwifi: iwlmvm: ignore HE PPDU type regarding EOF
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shaul Triebitz <shaul.triebitz@intel.com>

When setting the EOF bit in Rx flags (propagated
to radiotap) do not depend it on the PPDU type (SU/MU/TB)
since it doesn't.

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 7bd8676508f5..786e93f6b502 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -1158,14 +1158,12 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 	/* temporarily hide the radiotap data */
 	__skb_pull(skb, radiotap_len);
 
-	if (phy_data->info_type == IWL_RX_PHY_INFO_TYPE_HE_SU) {
-		/* report the AMPDU-EOF bit on single frames */
-		if (!queue && !(phy_info & IWL_RX_MPDU_PHY_AMPDU)) {
-			rx_status->flag |= RX_FLAG_AMPDU_DETAILS;
-			rx_status->flag |= RX_FLAG_AMPDU_EOF_BIT_KNOWN;
-			if (phy_data->d0 & cpu_to_le32(IWL_RX_PHY_DATA0_HE_DELIM_EOF))
-				rx_status->flag |= RX_FLAG_AMPDU_EOF_BIT;
-		}
+	/* report the AMPDU-EOF bit on single frames */
+	if (!queue && !(phy_info & IWL_RX_MPDU_PHY_AMPDU)) {
+		rx_status->flag |= RX_FLAG_AMPDU_DETAILS;
+		rx_status->flag |= RX_FLAG_AMPDU_EOF_BIT_KNOWN;
+		if (phy_data->d0 & cpu_to_le32(IWL_RX_PHY_DATA0_HE_DELIM_EOF))
+			rx_status->flag |= RX_FLAG_AMPDU_EOF_BIT;
 	}
 
 	if (phy_info & IWL_RX_MPDU_PHY_TSF_OVERLOAD)
@@ -1178,9 +1176,7 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 		bool toggle_bit = phy_info & IWL_RX_MPDU_PHY_AMPDU_TOGGLE;
 
 		/* toggle is switched whenever new aggregation starts */
-		if (toggle_bit != mvm->ampdu_toggle &&
-		    (he_type == RATE_MCS_HE_TYPE_MU ||
-		     he_type == RATE_MCS_HE_TYPE_SU)) {
+		if (toggle_bit != mvm->ampdu_toggle) {
 			rx_status->flag |= RX_FLAG_AMPDU_EOF_BIT_KNOWN;
 			if (phy_data->d0 & cpu_to_le32(IWL_RX_PHY_DATA0_HE_DELIM_EOF))
 				rx_status->flag |= RX_FLAG_AMPDU_EOF_BIT;
-- 
2.20.1

