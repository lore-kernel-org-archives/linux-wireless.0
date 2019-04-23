Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA8F6C10F14
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 09:41:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A78E2077C
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 09:41:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbfDWJlW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 05:41:22 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:59064 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726204AbfDWJlW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 05:41:22 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hIrvT-0000Je-QK; Tue, 23 Apr 2019 12:41:19 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 2/2] iwlwifi: fix driver operation for 5350
Date:   Tue, 23 Apr 2019 12:41:12 +0300
Message-Id: <20190423094112.18570-3-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190423094112.18570-1-luca@coelho.fi>
References: <20190423094112.18570-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

We introduced a bug that prevented this old device from
working. The driver would simply not be able to complete
the INIT flow while spewing this warning:

 CSR addresses aren't configured
 WARNING: CPU: 0 PID: 819 at drivers/net/wireless/intel/iwlwifi/pcie/drv.c:917
 iwl_pci_probe+0x160/0x1e0 [iwlwifi]

Cc: stable@vger.kernel.org # v4.18+
Fixes: a8cbb46f831d ("iwlwifi: allow different csr flags for different device families")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Fixes: c8f1b51e506d ("iwlwifi: allow different csr flags for different device families")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/5000.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/5000.c b/drivers/net/wireless/intel/iwlwifi/cfg/5000.c
index 575a7022d045..3846064d51a5 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/5000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/5000.c
@@ -1,7 +1,7 @@
 /******************************************************************************
  *
  * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
@@ -136,6 +136,7 @@ const struct iwl_cfg iwl5350_agn_cfg = {
 	.ht_params = &iwl5000_ht_params,
 	.led_mode = IWL_LED_BLINK,
 	.internal_wimax_coex = true,
+	.csr = &iwl_csr_v1,
 };
 
 #define IWL_DEVICE_5150						\
-- 
2.20.1

