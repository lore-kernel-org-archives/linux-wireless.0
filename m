Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D0CFC433B4
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Apr 2021 09:51:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA6A76105A
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Apr 2021 09:51:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235375AbhDKJwK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 11 Apr 2021 05:52:10 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:44482 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229804AbhDKJwJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Apr 2021 05:52:09 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=kveik.lan)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <luca@coelho.fi>)
        id 1lVWfx-000Jkq-4B; Sun, 11 Apr 2021 12:46:42 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     luca@coelho.fi, linux-wireless@vger.kernel.org
Date:   Sun, 11 Apr 2021 12:46:30 +0300
Message-Id: <iwlwifi.20210411124418.550fd1903eb7.I8ddbc2f87044a5ef78d916c9c59be797811a1b7f@changeid>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210411094630.431873-1-luca@coelho.fi>
References: <20210411094630.431873-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 12/12] iwlwifi: rs-fw: don't support stbc for HE 160
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

Our HE doesn't support it so never set HE 160 stbc

Fixes: 3e467b8e4cf4 ("iwlwifi: rs-fw: enable STBC in he correctly")
Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/rs-fw.c    | 20 ++++++++-----------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
index 8772b65c9dab..2d58cb969918 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
  * Copyright (C) 2017 Intel Deutschland GmbH
- * Copyright (C) 2018-2020 Intel Corporation
+ * Copyright (C) 2018-2021 Intel Corporation
  */
 #include "rs.h"
 #include "fw-api.h"
@@ -72,19 +72,15 @@ static u16 rs_fw_get_config_flags(struct iwl_mvm *mvm,
 	bool vht_ena = vht_cap->vht_supported;
 	u16 flags = 0;
 
+	/* get STBC flags */
 	if (mvm->cfg->ht_params->stbc &&
 	    (num_of_ant(iwl_mvm_get_valid_tx_ant(mvm)) > 1)) {
-		if (he_cap->has_he) {
-			if (he_cap->he_cap_elem.phy_cap_info[2] &
-			    IEEE80211_HE_PHY_CAP2_STBC_RX_UNDER_80MHZ)
-				flags |= IWL_TLC_MNG_CFG_FLAGS_STBC_MSK;
-
-			if (he_cap->he_cap_elem.phy_cap_info[7] &
-			    IEEE80211_HE_PHY_CAP7_STBC_RX_ABOVE_80MHZ)
-				flags |= IWL_TLC_MNG_CFG_FLAGS_HE_STBC_160MHZ_MSK;
-		} else if ((ht_cap->cap & IEEE80211_HT_CAP_RX_STBC) ||
-			   (vht_ena &&
-			    (vht_cap->cap & IEEE80211_VHT_CAP_RXSTBC_MASK)))
+		if (he_cap->has_he && he_cap->he_cap_elem.phy_cap_info[2] &
+				      IEEE80211_HE_PHY_CAP2_STBC_RX_UNDER_80MHZ)
+			flags |= IWL_TLC_MNG_CFG_FLAGS_STBC_MSK;
+		else if (vht_cap->cap & IEEE80211_VHT_CAP_RXSTBC_MASK)
+			flags |= IWL_TLC_MNG_CFG_FLAGS_STBC_MSK;
+		else if (ht_cap->cap & IEEE80211_HT_CAP_RX_STBC)
 			flags |= IWL_TLC_MNG_CFG_FLAGS_STBC_MSK;
 	}
 
-- 
2.31.0

