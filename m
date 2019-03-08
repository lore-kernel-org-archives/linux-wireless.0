Return-Path: <SRS0=wltO=RL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8CFCC4360F
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 10:09:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 799F420854
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 10:09:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbfCHKJF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Mar 2019 05:09:05 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:41402 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726249AbfCHKJD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Mar 2019 05:09:03 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h2CR3-0006tZ-Cz; Fri, 08 Mar 2019 12:09:01 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  8 Mar 2019 12:08:44 +0200
Message-Id: <20190308100848.13188-4-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308100848.13188-1-luca@coelho.fi>
References: <20190308100848.13188-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 3/7] iwlwifi: dbg_ini: in case of region dump failure set memory to 0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

In case the driver fails to dump a memory region, and this is the last
region, then partial region would be extracted.

Solve this by setting the data to zero in case of failure.
This will cause dump to be a list of consecutive successful memory
regions and trailing zeros with no partial memories extracted.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index f119c49cd39c..da5d9d79c372 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1614,6 +1614,7 @@ iwl_dump_ini_mem(struct iwl_fw_runtime *fwrt,
 	if (!range) {
 		IWL_ERR(fwrt, "Failed to fill region header: id=%d, type=%d\n",
 			le32_to_cpu(reg->region_id), type);
+		memset(*data, 0, le32_to_cpu((*data)->len));
 		return;
 	}
 
@@ -1623,6 +1624,7 @@ iwl_dump_ini_mem(struct iwl_fw_runtime *fwrt,
 		if (range_size < 0) {
 			IWL_ERR(fwrt, "Failed to dump region: id=%d, type=%d\n",
 				le32_to_cpu(reg->region_id), type);
+			memset(*data, 0, le32_to_cpu((*data)->len));
 			return;
 		}
 		range = range + range_size;
-- 
2.20.1

