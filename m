Return-Path: <SRS0=80NG=P2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C2B1C07EBF
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 19:00:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01ACE2086D
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 19:00:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729205AbfARTAW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Jan 2019 14:00:22 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:48356 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729192AbfARTAU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Jan 2019 14:00:20 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gkZNK-0004cj-F1; Fri, 18 Jan 2019 21:00:18 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 18 Jan 2019 20:59:55 +0200
Message-Id: <20190118190004.22270-8-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190118190004.22270-1-luca@coelho.fi>
References: <20190118190004.22270-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 07/16] iwlwifi: mvm: fix wrong DCM TLC config
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shaul Triebitz <shaul.triebitz@intel.com>

When configuring TLC DCM flag:
1. check the peer's RX DCM capabilities (since we TX)
2. do not set DCM_NSS_2 since we do not support it

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Fixes: 423584dd8060 ("iwlwifi: rs-fw: support dcm")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
index dabbc04853ac..a0ea0c160fd6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
@@ -149,14 +149,9 @@ static u16 rs_fw_set_config_flags(struct iwl_mvm *mvm,
 
 	if (he_cap && he_cap->has_he &&
 	    (he_cap->he_cap_elem.phy_cap_info[3] &
-	     IEEE80211_HE_PHY_CAP3_DCM_MAX_CONST_TX_MASK)) {
+	     IEEE80211_HE_PHY_CAP3_DCM_MAX_CONST_RX_MASK))
 		flags |= IWL_TLC_MNG_CFG_FLAGS_HE_DCM_NSS_1_MSK;
 
-		if (he_cap->he_cap_elem.phy_cap_info[3] &
-		    IEEE80211_HE_PHY_CAP3_DCM_MAX_TX_NSS_2)
-			flags |= IWL_TLC_MNG_CFG_FLAGS_HE_DCM_NSS_2_MSK;
-	}
-
 	return flags;
 }
 
-- 
2.20.1

