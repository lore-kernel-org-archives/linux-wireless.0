Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C2C0C282CC
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 10:47:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3622A21919
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 10:47:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727713AbfBHKr0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 05:47:26 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:56980 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727700AbfBHKrZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 05:47:25 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gs3gp-0002jg-K5; Fri, 08 Feb 2019 12:47:24 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  8 Feb 2019 12:46:58 +0200
Message-Id: <20190208104712.16210-7-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190208104712.16210-1-luca@coelho.fi>
References: <20190208104712.16210-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 06/20] iwlwifi: add force NMI for AX210 devices
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shaul Triebitz <shaul.triebitz@intel.com>

For AX210 devices, the periphry for forcing NMI
has changed.

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-io.c   | 5 ++++-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h | 7 +++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.c b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
index edba08768fac..a704e25af810 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
@@ -307,9 +307,12 @@ void iwl_force_nmi(struct iwl_trans *trans)
 	if (trans->cfg->device_family < IWL_DEVICE_FAMILY_9000)
 		iwl_write_prph(trans, DEVICE_SET_NMI_REG,
 			       DEVICE_SET_NMI_VAL_DRV);
-	else
+	else if (trans->cfg->device_family < IWL_DEVICE_FAMILY_AX210)
 		iwl_write_umac_prph(trans, UREG_NIC_SET_NMI_DRIVER,
 				UREG_NIC_SET_NMI_DRIVER_NMI_FROM_DRIVER_MSK);
+	else
+		iwl_write_umac_prph(trans, UREG_DOORBELL_TO_ISR6,
+				    UREG_DOORBELL_TO_ISR6_NMI_BIT);
 }
 IWL_EXPORT_SYMBOL(iwl_force_nmi);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
index 3aaa5f06461c..1af9f9e1ecd4 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
@@ -8,7 +8,7 @@
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2016        Intel Deutschland GmbH
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,7 +31,7 @@
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2016        Intel Deutschland GmbH
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -433,4 +433,7 @@ enum {
 #define HPM_DEBUG			0xA03440
 #define PERSISTENCE_BIT			BIT(12)
 #define PREG_WFPM_ACCESS		BIT(12)
+
+#define UREG_DOORBELL_TO_ISR6		0xA05C04
+#define UREG_DOORBELL_TO_ISR6_NMI_BIT	BIT(0)
 #endif				/* __iwl_prph_h__ */
-- 
2.20.1

