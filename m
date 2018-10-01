Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A923CC43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 12:11:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BB4F2084C
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 12:11:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7BB4F2084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729342AbeJASsb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 14:48:31 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:54426 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729111AbeJASsb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 14:48:31 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g6x1v-0006wq-JI; Mon, 01 Oct 2018 15:10:28 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon,  1 Oct 2018 15:10:05 +0300
Message-Id: <20181001121010.29684-12-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181001121010.29684-1-luca@coelho.fi>
References: <20181001121010.29684-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 11/16] iwlwifi: mvm: decode HE information for MU (without ext info)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

When the info type is MU, we still have the data from the TSF
overload words, so should decode that. When it's MU_EXT_INFO
we additionally have the SIG-B common 0/1/2 fields.

Also document the validity depending on the info type and fix
the name of the regular TB PPDU info type accordingly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h | 8 ++++----
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c  | 3 ++-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h b/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
index 415b8842b426..0537496b6eb1 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
@@ -368,10 +368,10 @@ enum iwl_rx_he_phy {
 	/* trigger encoded */
 	IWL_RX_HE_PHY_RU_ALLOC_MASK		= 0xfe0000000000ULL,
 	IWL_RX_HE_PHY_INFO_TYPE_MASK		= 0xf000000000000000ULL,
-	IWL_RX_HE_PHY_INFO_TYPE_SU		= 0x0,
-	IWL_RX_HE_PHY_INFO_TYPE_MU		= 0x1,
-	IWL_RX_HE_PHY_INFO_TYPE_MU_EXT_INFO	= 0x2,
-	IWL_RX_HE_PHY_INFO_TYPE_TB_EXT_INFO	= 0x3,
+	IWL_RX_HE_PHY_INFO_TYPE_SU		= 0x0, /* TSF low valid (first DW) */
+	IWL_RX_HE_PHY_INFO_TYPE_MU		= 0x1, /* TSF low/high valid (both DWs) */
+	IWL_RX_HE_PHY_INFO_TYPE_MU_EXT_INFO	= 0x2, /* same + SIGB-common0/1/2 valid */
+	IWL_RX_HE_PHY_INFO_TYPE_TB		= 0x3, /* TSF low/high valid (both DWs) */
 
 	/* second dword - MU data */
 	IWL_RX_HE_PHY_MU_SIGB_COMPRESSION		= BIT_ULL(32 + 0),
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 61916f39bac2..a63a073e8562 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -1095,8 +1095,9 @@ static void iwl_mvm_decode_he_phy_data(struct iwl_mvm *mvm,
 	}
 
 	switch (FIELD_GET(IWL_RX_HE_PHY_INFO_TYPE_MASK, he_phy_data)) {
+	case IWL_RX_HE_PHY_INFO_TYPE_MU:
 	case IWL_RX_HE_PHY_INFO_TYPE_MU_EXT_INFO:
-	case IWL_RX_HE_PHY_INFO_TYPE_TB_EXT_INFO:
+	case IWL_RX_HE_PHY_INFO_TYPE_TB:
 		iwl_mvm_decode_he_phy_ru_alloc(he_phy_data, rate_n_flags,
 					       he, he_mu, rx_status);
 		break;
-- 
2.19.0

