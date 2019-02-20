Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05264C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 12:04:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9DD420C01
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 12:04:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbfBTMEJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 07:04:09 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:34496 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726414AbfBTMEI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 07:04:08 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gwQbf-000411-0q; Wed, 20 Feb 2019 14:04:07 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed, 20 Feb 2019 14:03:53 +0200
Message-Id: <20190220120400.8814-2-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190220120400.8814-1-luca@coelho.fi>
References: <20190220120400.8814-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 1/8] iwlwifi: dbg_ini: add print to iwl_dump_ini_mem in case of invalid range
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Add informative print in case the range is not available.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 5e5c4e8c4a69..e4e50d598377 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1300,14 +1300,18 @@ iwl_dump_ini_mem(struct iwl_fw_runtime *fwrt,
 	memcpy(header->name, reg->name, le32_to_cpu(header->name_len));
 
 	range = ops->fill_mem_hdr(fwrt, header);
-	if (!range)
+	if (!range) {
+		IWL_ERR(fwrt, "Failed to fill region header: id=%d, type=%d\n",
+			le32_to_cpu(reg->region_id), type);
 		return;
+	}
 
 	for (i = 0; i < num_of_ranges; i++) {
 		int range_data_size = ops->fill_range(fwrt, range, reg, i);
 
 		if (range_data_size < 0) {
-			IWL_ERR(fwrt, "Failed to dump region type %d\n", type);
+			IWL_ERR(fwrt, "Failed to dump region: id=%d, type=%d\n",
+				le32_to_cpu(reg->region_id), type);
 			return;
 		}
 		range = ((void *)range) + sizeof(*range) + range_data_size;
-- 
2.20.1

