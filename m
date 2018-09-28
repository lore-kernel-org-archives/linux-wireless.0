Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E069C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 08:23:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55FA32172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 08:23:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 55FA32172C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbeI1OqZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 10:46:25 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:53512 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728062AbeI1OqZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 10:46:25 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g5o2e-0004tY-Rn; Fri, 28 Sep 2018 11:22:29 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 28 Sep 2018 11:22:08 +0300
Message-Id: <20180928082210.20762-17-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20180928082210.20762-1-luca@coelho.fi>
References: <20180928082210.20762-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 16/18] iwlwifi: mvm: add LDPC-XSYM to HE radiotap data
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Add information about the LDCP extra symbol segment to the HE
data when applicable (not for trigger-based PPDUs).

While at it, clean up the code for UL/DL a bit.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 52709130cb0b..b6f7fae0d757 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -1054,11 +1054,17 @@ static void iwl_mvm_decode_he_phy_data(struct iwl_mvm *mvm,
 	}
 
 	if (he_type != RATE_MCS_HE_TYPE_TRIG) {
-		he->data1 |=
-			cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_UL_DL_KNOWN);
-		if (FIELD_GET(IWL_RX_HE_PHY_UPLINK, he_phy_data))
-			he->data3 |=
-				cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA3_UL_DL);
+		u16 d1known = IEEE80211_RADIOTAP_HE_DATA1_LDPC_XSYMSEG_KNOWN |
+			      IEEE80211_RADIOTAP_HE_DATA1_UL_DL_KNOWN;
+
+		he->data1 |= cpu_to_le16(d1known);
+
+		he->data3 |= le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_UPLINK,
+							he_phy_data),
+					      IEEE80211_RADIOTAP_HE_DATA3_UL_DL);
+		he->data3 |= le16_encode_bits(FIELD_GET(IWL_RX_HE_PHY_LDPC_EXT_SYM,
+							he_phy_data),
+					      IEEE80211_RADIOTAP_HE_DATA3_LDPC_XSYMSEG);
 	}
 
 	switch (FIELD_GET(IWL_RX_HE_PHY_INFO_TYPE_MASK, he_phy_data)) {
-- 
2.19.0

