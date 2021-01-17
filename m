Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 059B0C433E6
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Jan 2021 14:53:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C28AC21D81
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Jan 2021 14:53:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729195AbhAQOxl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 17 Jan 2021 09:53:41 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:40772 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729093AbhAQOxb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Jan 2021 09:53:31 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1l19Q2-003sgA-Ua; Sun, 17 Jan 2021 16:52:43 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Sun, 17 Jan 2021 16:52:34 +0200
Message-Id: <iwlwifi.20210117164916.ebf6efb380a9.I237be6ec70bee6ec52a2f379ee1f15b1196488d0@changeid>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210117145234.1435324-1-luca@coelho.fi>
References: <20210117145234.1435324-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 9/9] iwlwifi: always allow maximum A-MSDU on newer devices
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

On devices starting from 9000 series, always allow maximum A-MSDU
sizes regardless of the amsdu_size module parameter, which really
hasn't meant that for a long time but just controls the receive
buffer size.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
index c21062777caf..43a04bc50774 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2005-2014, 2018-2019 Intel Corporation
+ * Copyright (C) 2005-2014, 2018-2020 Intel Corporation
  * Copyright (C) 2015 Intel Mobile Communications GmbH
  */
 #include <linux/types.h>
@@ -711,9 +711,8 @@ void iwl_init_ht_hw_capab(struct iwl_trans *trans,
 	if (cfg->ht_params->ldpc)
 		ht_info->cap |= IEEE80211_HT_CAP_LDPC_CODING;
 
-	if ((trans->trans_cfg->mq_rx_supported &&
-	     iwlwifi_mod_params.amsdu_size == IWL_AMSDU_DEF) ||
-	     iwlwifi_mod_params.amsdu_size >= IWL_AMSDU_8K)
+	if (trans->trans_cfg->mq_rx_supported ||
+	    iwlwifi_mod_params.amsdu_size >= IWL_AMSDU_8K)
 		ht_info->cap |= IEEE80211_HT_CAP_MAX_AMSDU;
 
 	ht_info->ampdu_factor = cfg->max_ht_ampdu_exponent;
-- 
2.29.2

