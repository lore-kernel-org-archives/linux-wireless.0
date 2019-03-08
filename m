Return-Path: <SRS0=wltO=RL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C751C43381
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 10:09:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CA0920854
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 10:09:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbfCHKJF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Mar 2019 05:09:05 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:41412 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726348AbfCHKJD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Mar 2019 05:09:03 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h2CR4-0006tZ-5x; Fri, 08 Mar 2019 12:09:02 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  8 Mar 2019 12:08:45 +0200
Message-Id: <20190308100848.13188-5-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308100848.13188-1-luca@coelho.fi>
References: <20190308100848.13188-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 4/7] iwlwifi: dbg_ini: fix bad dump size calculation
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

The driver initiates the size value with the size of the struct and then
adds the size of the data and checks if the size is zero so size can not
be equal to zero.

Solve this by getting the data size, check that it is not equal to zero
and only then add the struct size.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Fixes: 7a14c23dcdee ("iwlwifi: dbg: dump data according to the new ini TLVs")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index da5d9d79c372..b99d38b37014 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1809,12 +1809,12 @@ _iwl_fw_error_ini_dump(struct iwl_fw_runtime *fwrt,
 
 	trigger = fwrt->dump.active_trigs[id].trig;
 
-	size = sizeof(*dump_file);
-	size += iwl_fw_ini_get_trigger_len(fwrt, trigger);
-
+	size = iwl_fw_ini_get_trigger_len(fwrt, trigger);
 	if (!size)
 		return NULL;
 
+	size += sizeof(*dump_file);
+
 	dump_file = vzalloc(size);
 	if (!dump_file)
 		return NULL;
-- 
2.20.1

