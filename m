Return-Path: <SRS0=QcoQ=US=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0419CC31E5D
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Jun 2019 17:42:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D241520645
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Jun 2019 17:42:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730468AbfFSRmO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Jun 2019 13:42:14 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:54534 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728845AbfFSRmL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Jun 2019 13:42:11 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hdeb3-0002zq-Ns; Wed, 19 Jun 2019 20:42:09 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 5/6] iwlwifi: don't WARN when calling iwl_get_shared_mem_conf with RF-Kill
Date:   Wed, 19 Jun 2019 20:41:58 +0300
Message-Id: <20190619174159.13927-6-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190619174159.13927-1-luca@coelho.fi>
References: <20190619174159.13927-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

iwl_mvm_send_cmd returns 0 when the command won't be sent
because RF-Kill is asserted. Do the same when we call
iwl_get_shared_mem_conf since it is not sent through
iwl_mvm_send_cmd but directly calls the transport layer.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/smem.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/smem.c b/drivers/net/wireless/intel/iwlwifi/fw/smem.c
index ff85d69c2a8c..557ee47bffd8 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/smem.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/smem.c
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
@@ -134,6 +134,7 @@ void iwl_get_shared_mem_conf(struct iwl_fw_runtime *fwrt)
 		.len = { 0, },
 	};
 	struct iwl_rx_packet *pkt;
+	int ret;
 
 	if (fw_has_capa(&fwrt->fw->ucode_capa,
 			IWL_UCODE_TLV_CAPA_EXTEND_SHARED_MEM_CFG))
@@ -141,8 +142,13 @@ void iwl_get_shared_mem_conf(struct iwl_fw_runtime *fwrt)
 	else
 		cmd.id = SHARED_MEM_CFG;
 
-	if (WARN_ON(iwl_trans_send_cmd(fwrt->trans, &cmd)))
+	ret = iwl_trans_send_cmd(fwrt->trans, &cmd);
+
+	if (ret) {
+		WARN(ret != -ERFKILL,
+		     "Could not send the SMEM command: %d\n", ret);
 		return;
+	}
 
 	pkt = cmd.resp_pkt;
 	if (fwrt->trans->cfg->device_family >= IWL_DEVICE_FAMILY_22000)
-- 
2.20.1

