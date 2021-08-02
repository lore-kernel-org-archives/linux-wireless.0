Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A5EDC4338F
	for <linux-wireless@archiver.kernel.org>; Mon,  2 Aug 2021 18:59:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EAC7610FC
	for <linux-wireless@archiver.kernel.org>; Mon,  2 Aug 2021 18:59:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbhHBS7V (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 2 Aug 2021 14:59:21 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:51042 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230420AbhHBS7S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Aug 2021 14:59:18 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=kveik.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <luca@coelho.fi>)
        id 1mAd9V-001ySl-AT; Mon, 02 Aug 2021 21:59:06 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     luca@coelho.fi, linux-wireless@vger.kernel.org
Date:   Mon,  2 Aug 2021 21:58:54 +0300
Message-Id: <iwlwifi.20210802215208.04146f24794f.I90726440ddff75013e9fecbe9fa1a05c69e3f17b@changeid>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802185856.175567-1-luca@coelho.fi>
References: <20210802185856.175567-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 08/10] iwlwifi: mvm: Fix umac scan request probe parameters
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

Both 'iwl_scan_probe_params_v3' and 'iwl_scan_probe_params_v4'
wrongly addressed the 'bssid_array' field which should supposed
to be any array of BSSIDs each of size ETH_ALEN and not the
opposite. Fix it.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h b/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
index b2605aefc290..8b200379f7c2 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2012-2014, 2018-2020 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2021 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -874,7 +874,7 @@ struct iwl_scan_probe_params_v3 {
 	u8 reserved;
 	struct iwl_ssid_ie direct_scan[PROBE_OPTION_MAX];
 	__le32 short_ssid[SCAN_SHORT_SSID_MAX_SIZE];
-	u8 bssid_array[ETH_ALEN][SCAN_BSSID_MAX_SIZE];
+	u8 bssid_array[SCAN_BSSID_MAX_SIZE][ETH_ALEN];
 } __packed; /* SCAN_PROBE_PARAMS_API_S_VER_3 */
 
 /**
@@ -894,7 +894,7 @@ struct iwl_scan_probe_params_v4 {
 	__le16 reserved;
 	struct iwl_ssid_ie direct_scan[PROBE_OPTION_MAX];
 	__le32 short_ssid[SCAN_SHORT_SSID_MAX_SIZE];
-	u8 bssid_array[ETH_ALEN][SCAN_BSSID_MAX_SIZE];
+	u8 bssid_array[SCAN_BSSID_MAX_SIZE][ETH_ALEN];
 } __packed; /* SCAN_PROBE_PARAMS_API_S_VER_4 */
 
 #define SCAN_MAX_NUM_CHANS_V3 67
-- 
2.32.0

