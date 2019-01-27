Return-Path: <SRS0=DVo7=QD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D598C282C0
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 10:20:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EBF82146E
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 10:20:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfA0KUA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 27 Jan 2019 05:20:00 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:51422 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726487AbfA0KUA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 Jan 2019 05:20:00 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gnhXL-0001vC-S0; Sun, 27 Jan 2019 12:19:36 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sun, 27 Jan 2019 12:19:04 +0200
Message-Id: <20190127101908.6428-18-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190127101908.6428-1-luca@coelho.fi>
References: <20190127101908.6428-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 17/21] iwlwifi: dbg_ini: allocate dram buffer with proper flags
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Use the same flags we use in the legacy buffer allocation.
Missing __GFP_NOWARN will cause an unwanted warning incase
we fail to allocate.
Missing __GFP_ZERO will give a buffer initially filled with
garbage which can make debug difficult in case our wrap count is zero.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Fixes: d47902f9f71d ("iwlwifi: dbg: add apply point logic")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 917aafe1a9db..947f282c05a9 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1697,8 +1697,10 @@ iwl_fw_dbg_buffer_allocation(struct iwl_fw_runtime *fwrt,
 	    IWL_FW_INI_LOCATION_DRAM_PATH)
 		return;
 
-	virtual_addr = dma_alloc_coherent(fwrt->trans->dev, size,
-					  &phys_addr, GFP_KERNEL);
+	virtual_addr =
+		dma_alloc_coherent(fwrt->trans->dev, size, &phys_addr,
+				   GFP_KERNEL | __GFP_NOWARN | __GFP_ZERO |
+				   __GFP_COMP);
 
 	/* TODO: alloc fragments if needed */
 	if (!virtual_addr)
-- 
2.20.1

