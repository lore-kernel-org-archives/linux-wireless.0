Return-Path: <SRS0=wsxy=YN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38224CA9EB2
	for <linux-wireless@archiver.kernel.org>; Sun, 20 Oct 2019 08:56:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 192412067B
	for <linux-wireless@archiver.kernel.org>; Sun, 20 Oct 2019 08:56:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbfJTI4B (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 20 Oct 2019 04:56:01 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:50802 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726292AbfJTI4B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 20 Oct 2019 04:56:01 -0400
Received: from [91.156.6.193] (helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1iM70J-0003LY-KE; Sun, 20 Oct 2019 11:56:00 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Sun, 20 Oct 2019 11:55:41 +0300
Message-Id: <20191020085545.16407-7-luca@coelho.fi>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191020085545.16407-1-luca@coelho.fi>
References: <20191020085545.16407-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 08/12] iwlwifi: mvm: start CTDP budget from 2400mA
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

The current budget of 2000mA is preventing us from reaching maximum
throughput.  According to our system engineers, we can increase the
maximum budget to 2400mA to solve this problem.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c | 43 +++++++++++----------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
index f0c539b37ea7..b5a16f00bada 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
@@ -8,6 +8,7 @@
  * Copyright(c) 2013 - 2014, 2019 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
+ * Copyright(c) 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,6 +31,7 @@
  * Copyright(c) 2012 - 2014, 2019 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
+ * Copyright(c) 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -482,26 +484,27 @@ static const struct iwl_tt_params iwl_mvm_default_tt_params = {
 
 /* budget in mWatt */
 static const u32 iwl_mvm_cdev_budgets[] = {
-	2000,	/* cooling state 0 */
-	1800,	/* cooling state 1 */
-	1600,	/* cooling state 2 */
-	1400,	/* cooling state 3 */
-	1200,	/* cooling state 4 */
-	1000,	/* cooling state 5 */
-	900,	/* cooling state 6 */
-	800,	/* cooling state 7 */
-	700,	/* cooling state 8 */
-	650,	/* cooling state 9 */
-	600,	/* cooling state 10 */
-	550,	/* cooling state 11 */
-	500,	/* cooling state 12 */
-	450,	/* cooling state 13 */
-	400,	/* cooling state 14 */
-	350,	/* cooling state 15 */
-	300,	/* cooling state 16 */
-	250,	/* cooling state 17 */
-	200,	/* cooling state 18 */
-	150,	/* cooling state 19 */
+	2400,	/* cooling state 0 */
+	2000,	/* cooling state 1 */
+	1800,	/* cooling state 2 */
+	1600,	/* cooling state 3 */
+	1400,	/* cooling state 4 */
+	1200,	/* cooling state 5 */
+	1000,	/* cooling state 6 */
+	900,	/* cooling state 7 */
+	800,	/* cooling state 8 */
+	700,	/* cooling state 9 */
+	650,	/* cooling state 10 */
+	600,	/* cooling state 11 */
+	550,	/* cooling state 12 */
+	500,	/* cooling state 13 */
+	450,	/* cooling state 14 */
+	400,	/* cooling state 15 */
+	350,	/* cooling state 16 */
+	300,	/* cooling state 17 */
+	250,	/* cooling state 18 */
+	200,	/* cooling state 19 */
+	150,	/* cooling state 20 */
 };
 
 int iwl_mvm_ctdp_command(struct iwl_mvm *mvm, u32 op, u32 state)
-- 
2.23.0

