Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD6AC282D7
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 10:47:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7505421919
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 10:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbfBHKr2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 05:47:28 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:57004 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727702AbfBHKr1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 05:47:27 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gs3gr-0002jg-DE; Fri, 08 Feb 2019 12:47:25 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  8 Feb 2019 12:47:00 +0200
Message-Id: <20190208104712.16210-9-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190208104712.16210-1-luca@coelho.fi>
References: <20190208104712.16210-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 08/20] iwiwifi: mvm: Fix FW scan concurrency support assumptions
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

- The FW supports up to 4 concurrent scans, so adjust the definitions
  accordingly.
- Only a single periodic scan is supported, so enforce it in the code.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h | 6 +++---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c    | 9 +++++++--
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h b/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
index 18741889ec30..890a939c463d 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
@@ -8,7 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018        Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,7 +31,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018        Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -434,7 +434,7 @@ struct iwl_periodic_scan_complete {
 /* The maximum of either of these cannot exceed 8, because we use an
  * 8-bit mask (see IWL_MVM_SCAN_MASK in mvm.h).
  */
-#define IWL_MVM_MAX_UMAC_SCANS 8
+#define IWL_MVM_MAX_UMAC_SCANS 4
 #define IWL_MVM_MAX_LMAC_SCANS 1
 
 enum scan_config_flags {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 853bf679dc26..78694bc38e76 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -8,7 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,7 +31,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -1580,6 +1580,11 @@ static int iwl_mvm_check_running_scans(struct iwl_mvm *mvm, int type)
 	 * scheduled scan before starting a normal scan.
 	 */
 
+	/* FW supports only a single periodic scan */
+	if ((type == IWL_MVM_SCAN_SCHED || type == IWL_MVM_SCAN_NETDETECT) &&
+	    mvm->scan_status & (IWL_MVM_SCAN_SCHED | IWL_MVM_SCAN_NETDETECT))
+		return -EBUSY;
+
 	if (iwl_mvm_num_scans(mvm) < mvm->max_scans)
 		return 0;
 
-- 
2.20.1

