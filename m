Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E0ECC10F14
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 09:11:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C43C206BA
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 09:11:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfDWJL3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 05:11:29 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:59016 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726130AbfDWJL3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 05:11:29 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hIrS5-0000FN-G8; Tue, 23 Apr 2019 12:10:57 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 15/16] iwlwifi: avoid allocating memory for region with disabled domain
Date:   Tue, 23 Apr 2019 12:10:42 +0300
Message-Id: <20190423091043.7156-16-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190423091043.7156-1-luca@coelho.fi>
References: <20190423091043.7156-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

In iwl_fw_ini_get_trigger_len the driver allocates space for memory
regions regardless of their domain and in iwl_fw_ini_dump_trigger the
driver aborts trigger collection of disabled domain. This diff causes
unneeded memory allocation and traling zeros in the dump file.

Solve this behavior by enforcing domain checking in
iwl_fw_ini_get_trigger_len

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 4ef447480aaf..62fd346ccb77 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1751,6 +1751,10 @@ static int iwl_fw_ini_get_trigger_len(struct iwl_fw_runtime *fwrt,
 			continue;
 		}
 
+		/* currently the driver supports always on domain only */
+		if (le32_to_cpu(reg->domain) != IWL_FW_INI_DBG_DOMAIN_ALWAYS_ON)
+			continue;
+
 		switch (le32_to_cpu(reg->region_type)) {
 		case IWL_FW_INI_REGION_DEVICE_MEMORY:
 		case IWL_FW_INI_REGION_PERIPHERY_MAC:
-- 
2.20.1

