Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CC54C49361
	for <linux-wireless@archiver.kernel.org>; Sat, 12 Jun 2021 11:32:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18E1361376
	for <linux-wireless@archiver.kernel.org>; Sat, 12 Jun 2021 11:32:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhFLLeu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 12 Jun 2021 07:34:50 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:47554 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231196AbhFLLet (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 12 Jun 2021 07:34:49 -0400
Received: from [192.130.48.226] (helo=kveik.superpark.guest)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <luca@coelho.fi>)
        id 1ls1sd-001V8i-Tt; Sat, 12 Jun 2021 14:32:49 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     luca@coelho.fi, linux-wireless@vger.kernel.org
Date:   Sat, 12 Jun 2021 14:32:36 +0300
Message-Id: <iwlwifi.20210612142637.12f3b9fea57e.I42a7556d43de78ec6387e3a699eca10482b0485d@changeid>
X-Mailer: git-send-email 2.32.0.rc2
In-Reply-To: <20210612113245.691117-1-luca@coelho.fi>
References: <20210612113245.691117-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 03/12] iwlwifi: mvm: fix indentation in some scan functions
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Two functions had indentation mistakes which were causing sparse
warnings.  Fix them.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 5a0696c44f6d..0368b7101222 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2012-2014, 2018-2020 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2021 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -2327,9 +2327,9 @@ static int iwl_mvm_scan_umac_v12(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 					     &scan_p->general_params,
 					     gen_flags);
 
-	 ret = iwl_mvm_fill_scan_sched_params(params,
-					      scan_p->periodic_params.schedule,
-					      &scan_p->periodic_params.delay);
+	ret = iwl_mvm_fill_scan_sched_params(params,
+					     scan_p->periodic_params.schedule,
+					     &scan_p->periodic_params.delay);
 	if (ret)
 		return ret;
 
@@ -2362,9 +2362,9 @@ static int iwl_mvm_scan_umac_v14(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 					     &scan_p->general_params,
 					     gen_flags);
 
-	 ret = iwl_mvm_fill_scan_sched_params(params,
-					      scan_p->periodic_params.schedule,
-					      &scan_p->periodic_params.delay);
+	ret = iwl_mvm_fill_scan_sched_params(params,
+					     scan_p->periodic_params.schedule,
+					     &scan_p->periodic_params.delay);
 	if (ret)
 		return ret;
 
-- 
2.32.0.rc2

