Return-Path: <SRS0=Soq1=NW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67CA9C43441
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 10:26:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 374AC20866
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 10:26:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 374AC20866
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbeKKUOp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 11 Nov 2018 15:14:45 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:35802 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727448AbeKKUOp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Nov 2018 15:14:45 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gLmwr-00007G-NS; Sun, 11 Nov 2018 12:26:34 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, Matt Chen <matt.chen@intel.com>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>
Date:   Sun, 11 Nov 2018 12:26:23 +0200
Message-Id: <20181111102627.18461-2-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181111102627.18461-1-luca@coelho.fi>
References: <20181111102627.18461-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 1/5] iwlwifi: fix wrong WGDS_WIFI_DATA_SIZE
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Matt Chen <matt.chen@intel.com>

From coreboot/BIOS:
Name ("WGDS", Package() {
 Revision,
 Package() {
     DomainType,                         // 0x7:WiFi ==> We miss this one.
     WgdsWiFiSarDeltaGroup1PowerMax1,    // Group 1 FCC 2400 Max
     WgdsWiFiSarDeltaGroup1PowerChainA1, // Group 1 FCC 2400 A Offset
     WgdsWiFiSarDeltaGroup1PowerChainB1, // Group 1 FCC 2400 B Offset
     WgdsWiFiSarDeltaGroup1PowerMax2,    // Group 1 FCC 5200 Max
     WgdsWiFiSarDeltaGroup1PowerChainA2, // Group 1 FCC 5200 A Offset
     WgdsWiFiSarDeltaGroup1PowerChainB2, // Group 1 FCC 5200 B Offset
     WgdsWiFiSarDeltaGroup2PowerMax1,    // Group 2 EC Jap 2400 Max
     WgdsWiFiSarDeltaGroup2PowerChainA1, // Group 2 EC Jap 2400 A Offset
     WgdsWiFiSarDeltaGroup2PowerChainB1, // Group 2 EC Jap 2400 B Offset
     WgdsWiFiSarDeltaGroup2PowerMax2,    // Group 2 EC Jap 5200 Max
     WgdsWiFiSarDeltaGroup2PowerChainA2, // Group 2 EC Jap 5200 A Offset
     WgdsWiFiSarDeltaGroup2PowerChainB2, // Group 2 EC Jap 5200 B Offset
     WgdsWiFiSarDeltaGroup3PowerMax1,    // Group 3 ROW 2400 Max
     WgdsWiFiSarDeltaGroup3PowerChainA1, // Group 3 ROW 2400 A Offset
     WgdsWiFiSarDeltaGroup3PowerChainB1, // Group 3 ROW 2400 B Offset
     WgdsWiFiSarDeltaGroup3PowerMax2,    // Group 3 ROW 5200 Max
     WgdsWiFiSarDeltaGroup3PowerChainA2, // Group 3 ROW 5200 A Offset
     WgdsWiFiSarDeltaGroup3PowerChainB2, // Group 3 ROW 5200 B Offset
 }
})

When read the ACPI data to find out the WGDS, the DATA_SIZE is never
matched.
From the above format, it gives 19 numbers, but our driver is hardcode
as 18.
Fix it to pass then can parse the data into our wgds table.
Then we will see:
iwlwifi 0000:01:00.0: U iwl_mvm_sar_geo_init Sending GEO_TX_POWER_LIMIT
iwlwifi 0000:01:00.0: U iwl_mvm_sar_geo_init SAR geographic profile[0]
Band[0]: chain A = 68 chain B = 69 max_tx_power = 54
iwlwifi 0000:01:00.0: U iwl_mvm_sar_geo_init SAR geographic profile[0]
Band[1]: chain A = 48 chain B = 49 max_tx_power = 70
iwlwifi 0000:01:00.0: U iwl_mvm_sar_geo_init SAR geographic profile[1]
Band[0]: chain A = 51 chain B = 67 max_tx_power = 50
iwlwifi 0000:01:00.0: U iwl_mvm_sar_geo_init SAR geographic profile[1]
Band[1]: chain A = 69 chain B = 70 max_tx_power = 68
iwlwifi 0000:01:00.0: U iwl_mvm_sar_geo_init SAR geographic profile[2]
Band[0]: chain A = 49 chain B = 50 max_tx_power = 48
iwlwifi 0000:01:00.0: U iwl_mvm_sar_geo_init SAR geographic profile[2]
Band[1]: chain A = 52 chain B = 53 max_tx_power = 51

Cc: stable@vger.kernel.org # 4.12+
Fixes: a6bff3cb19b7 ("iwlwifi: mvm: add GEO_TX_POWER_LIMIT cmd for geographic tx power table")
Signed-off-by: Matt Chen <matt.chen@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h | 4 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c  | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.h b/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
index 2439e98431ee..7492dfb6729b 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2017        Intel Deutschland GmbH
+ * Copyright(c) 2018        Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -26,6 +27,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2017        Intel Deutschland GmbH
+ * Copyright(c) 2018        Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -81,7 +83,7 @@
 #define ACPI_WRDS_WIFI_DATA_SIZE	(ACPI_SAR_TABLE_SIZE + 2)
 #define ACPI_EWRD_WIFI_DATA_SIZE	((ACPI_SAR_PROFILE_NUM - 1) * \
 					 ACPI_SAR_TABLE_SIZE + 3)
-#define ACPI_WGDS_WIFI_DATA_SIZE	18
+#define ACPI_WGDS_WIFI_DATA_SIZE	19
 #define ACPI_WRDD_WIFI_DATA_SIZE	2
 #define ACPI_SPLC_WIFI_DATA_SIZE	2
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index dade206d5511..899f4a6432fb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -893,7 +893,7 @@ static int iwl_mvm_sar_geo_init(struct iwl_mvm *mvm)
 	IWL_DEBUG_RADIO(mvm, "Sending GEO_TX_POWER_LIMIT\n");
 
 	BUILD_BUG_ON(ACPI_NUM_GEO_PROFILES * ACPI_WGDS_NUM_BANDS *
-		     ACPI_WGDS_TABLE_SIZE !=  ACPI_WGDS_WIFI_DATA_SIZE);
+		     ACPI_WGDS_TABLE_SIZE + 1 !=  ACPI_WGDS_WIFI_DATA_SIZE);
 
 	BUILD_BUG_ON(ACPI_NUM_GEO_PROFILES > IWL_NUM_GEO_PROFILES);
 
-- 
2.19.1

