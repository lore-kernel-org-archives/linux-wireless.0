Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F89FC32789
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 11:08:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4443420657
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 11:08:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4443420657
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbeKBUO5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Nov 2018 16:14:57 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:33988 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726049AbeKBUO5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Nov 2018 16:14:57 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gIXJA-0007MW-Po; Fri, 02 Nov 2018 13:08:09 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  2 Nov 2018 13:07:48 +0200
Message-Id: <20181102110800.29817-4-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181102110800.29817-1-luca@coelho.fi>
References: <20181102110800.29817-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 03/15] iwlwifi: trans: Clear persistence bit when starting the FW
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

In D3 suspend flow in 9260 gen2 HW, the NIC receives two PERST signals.
The first PERST is expected and indicates the device on coming resume flow.
The second PERST causes FW restart FW restart.
In order to avoid this issue, the FW set the persistence bit on.
Once this bit is set, the FW ignores reset attempts.
The problem is when the FW gets assert during D3 and then the persistence
bit is set and causes the FW to ignore reset.
To handle this issue, the FW opens the preg bit which allows access
to the persistence bit, so that the driver clear the persistence bit
and reset the NIC.

The flow is as follows:
the driver checks if the persistence bit is set.
If the bit is set, the driver checks if he can clear the bit.
If the driver can not clear the bit then there is no point to continue
configuring the NIC since it will fail.

The fix was added is in start HW flow instead of the resume flow since in
general, if the persistence bit is set, the driver can not start the FW.
So it is good to check it when we start configuring the NIC.

The driver does not need to close the preg bit since the FW close it
during the start flow.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h   |  7 +++++++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 12 ++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
index 0f51c7bea8d0..2084c63dc670 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
@@ -8,6 +8,7 @@
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2016        Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,6 +31,7 @@
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2016        Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -394,6 +396,7 @@ enum aux_misc_master1_en {
 #define AUX_MISC_MASTER1_SMPHR_STATUS	0xA20800
 #define RSA_ENABLE			0xA24B08
 #define PREG_AUX_BUS_WPROT_0		0xA04CC0
+#define PREG_PRPH_WPROT_0		0xA04CE0
 #define SB_CPU_1_STATUS			0xA01E30
 #define SB_CPU_2_STATUS			0xA01E34
 #define UMAG_SB_CPU_1_STATUS		0xA038C0
@@ -420,4 +423,8 @@ enum {
 #define UREG_CHICK		(0xA05C00)
 #define UREG_CHICK_MSI_ENABLE	BIT(24)
 #define UREG_CHICK_MSIX_ENABLE	BIT(25)
+
+#define HPM_DEBUG			0xA03440
+#define PERSISTENCE_BIT			BIT(12)
+#define PREG_WFPM_ACCESS		BIT(12)
 #endif				/* __iwl_prph_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 5bafb3f46eb8..890b51b223a1 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1729,6 +1729,7 @@ static int iwl_pcie_init_msix_handler(struct pci_dev *pdev,
 static int _iwl_trans_pcie_start_hw(struct iwl_trans *trans, bool low_power)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	u32 hpm;
 	int err;
 
 	lockdep_assert_held(&trans_pcie->mutex);
@@ -1739,6 +1740,17 @@ static int _iwl_trans_pcie_start_hw(struct iwl_trans *trans, bool low_power)
 		return err;
 	}
 
+	hpm = iwl_trans_read_prph(trans, HPM_DEBUG);
+	if (hpm != 0xa5a5a5a0 && (hpm & PERSISTENCE_BIT)) {
+		if (iwl_trans_read_prph(trans, PREG_PRPH_WPROT_0) &
+		    PREG_WFPM_ACCESS) {
+			IWL_ERR(trans,
+				"Error, can not clear persistence bit\n");
+			return -EPERM;
+		}
+		iwl_trans_write_prph(trans, HPM_DEBUG, hpm & ~PERSISTENCE_BIT);
+	}
+
 	iwl_trans_pcie_sw_reset(trans);
 
 	err = iwl_pcie_apm_init(trans);
-- 
2.19.1

