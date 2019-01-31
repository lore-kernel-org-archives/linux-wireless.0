Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5457C282D9
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:22:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1349218AF
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:22:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbfAaUWY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 15:22:24 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:53594 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727789AbfAaUWX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 15:22:23 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gpIqr-0004pL-6M; Thu, 31 Jan 2019 22:22:21 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Thu, 31 Jan 2019 22:21:53 +0200
Message-Id: <20190131202206.15903-9-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190131202206.15903-1-luca@coelho.fi>
References: <20190131202206.15903-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 08/21] iwlwifi: move config structs to C file
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Even if they're static const, there's no need to duplicate
the structs every time they're included and used. Move them
to an appropriate C file instead.

Also remove useless parentheses along the way.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/iwl-config.h   | 31 ++----------------
 drivers/net/wireless/intel/iwlwifi/iwl-io.c   | 32 +++++++++++++++++++
 2 files changed, 34 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index ff942532fac3..f1e493380713 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -445,35 +445,8 @@ struct iwl_cfg {
 	u32 d3_debug_data_length;
 };
 
-static const struct iwl_csr_params iwl_csr_v1 = {
-	.flag_mac_clock_ready = 0,
-	.flag_val_mac_access_en = 0,
-	.flag_init_done = 2,
-	.flag_mac_access_req = 3,
-	.flag_sw_reset = 7,
-	.flag_master_dis = 8,
-	.flag_stop_master = 9,
-	.addr_sw_reset = (CSR_BASE + 0x020),
-	.mac_addr0_otp = 0x380,
-	.mac_addr1_otp = 0x384,
-	.mac_addr0_strap = 0x388,
-	.mac_addr1_strap = 0x38C
-};
-
-static const struct iwl_csr_params iwl_csr_v2 = {
-	.flag_init_done = 6,
-	.flag_mac_clock_ready = 20,
-	.flag_val_mac_access_en = 20,
-	.flag_mac_access_req = 21,
-	.flag_master_dis = 28,
-	.flag_stop_master = 29,
-	.flag_sw_reset = 31,
-	.addr_sw_reset = (CSR_BASE + 0x024),
-	.mac_addr0_otp = 0x30,
-	.mac_addr1_otp = 0x34,
-	.mac_addr0_strap = 0x38,
-	.mac_addr1_strap = 0x3C
-};
+extern const struct iwl_csr_params iwl_csr_v1;
+extern const struct iwl_csr_params iwl_csr_v2;
 
 /*
  * This list declares the config structures for all devices.
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.c b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
index ffd1e649bfa0..d62eb2d9389a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
@@ -7,6 +7,7 @@
  *
  * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
@@ -28,6 +29,7 @@
  *
  * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -68,6 +70,36 @@
 #include "iwl-prph.h"
 #include "iwl-fh.h"
 
+const struct iwl_csr_params iwl_csr_v1 = {
+	.flag_mac_clock_ready = 0,
+	.flag_val_mac_access_en = 0,
+	.flag_init_done = 2,
+	.flag_mac_access_req = 3,
+	.flag_sw_reset = 7,
+	.flag_master_dis = 8,
+	.flag_stop_master = 9,
+	.addr_sw_reset = CSR_BASE + 0x020,
+	.mac_addr0_otp = 0x380,
+	.mac_addr1_otp = 0x384,
+	.mac_addr0_strap = 0x388,
+	.mac_addr1_strap = 0x38C
+};
+
+const struct iwl_csr_params iwl_csr_v2 = {
+	.flag_init_done = 6,
+	.flag_mac_clock_ready = 20,
+	.flag_val_mac_access_en = 20,
+	.flag_mac_access_req = 21,
+	.flag_master_dis = 28,
+	.flag_stop_master = 29,
+	.flag_sw_reset = 31,
+	.addr_sw_reset = CSR_BASE + 0x024,
+	.mac_addr0_otp = 0x30,
+	.mac_addr1_otp = 0x34,
+	.mac_addr0_strap = 0x38,
+	.mac_addr1_strap = 0x3C
+};
+
 void iwl_write8(struct iwl_trans *trans, u32 ofs, u8 val)
 {
 	trace_iwlwifi_dev_iowrite8(trans->dev, ofs, val);
-- 
2.20.1

