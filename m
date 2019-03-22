Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B976EC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 13:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85DFA218A5
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 13:59:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbfCVN7S (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 09:59:18 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:46062 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727487AbfCVN7P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 09:59:15 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h7KhV-0000bK-Nu; Fri, 22 Mar 2019 15:59:14 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 22 Mar 2019 15:58:41 +0200
Message-Id: <20190322135903.10631-3-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190322135903.10631-1-luca@coelho.fi>
References: <20190322135903.10631-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 02/24] iwlwifi: dbg_ini: enforce always on domain checking
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Enforce domain checking before sending host commands and collecting
memory regions. Currently the driver supports always on domain only.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 65252481a306..caf860b7afff 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1711,6 +1711,10 @@ static void iwl_fw_ini_dump_trigger(struct iwl_fw_runtime *fwrt,
 		if (!reg)
 			continue;
 
+		/* currently the driver supports always on domain only */
+		if (le32_to_cpu(reg->domain) != IWL_FW_INI_DBG_DOMAIN_ALWAYS_ON)
+			continue;
+
 		type = le32_to_cpu(reg->region_type);
 		switch (type) {
 		case IWL_FW_INI_REGION_DEVICE_MEMORY:
@@ -2320,6 +2324,10 @@ static void iwl_fw_dbg_send_hcmd(struct iwl_fw_runtime *fwrt,
 		.data = { data->data, },
 	};
 
+	/* currently the driver supports always on domain only */
+	if (le32_to_cpu(hcmd_tlv->domain) != IWL_FW_INI_DBG_DOMAIN_ALWAYS_ON)
+		return;
+
 	iwl_trans_send_cmd(fwrt->trans, &hcmd);
 }
 
-- 
2.20.1

