Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46C0EC282DD
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 09:11:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F321206BA
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 09:11:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbfDWJLo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 05:11:44 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:59040 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726130AbfDWJLo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 05:11:44 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hIrS6-0000FN-1b; Tue, 23 Apr 2019 12:10:58 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 16/16] iwlwifi: dbg_ini: check for valid region type during regions parsing
Date:   Tue, 23 Apr 2019 12:10:43 +0300
Message-Id: <20190423091043.7156-17-luca@coelho.fi>
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

Add region type checking during regions parsing to avoid attempts to
parse unsupported or illegal region types.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 62fd346ccb77..5f52e40a2903 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -2469,15 +2469,20 @@ static void iwl_fw_dbg_update_regions(struct iwl_fw_runtime *fwrt,
 {
 	void *iter = (void *)tlv->region_config;
 	int i, size = le32_to_cpu(tlv->num_regions);
+	const char *err_st =
+		"WRT: ext=%d. Invalid region %s %d for apply point %d\n";
 
 	for (i = 0; i < size; i++) {
 		struct iwl_fw_ini_region_cfg *reg = iter, **active;
 		int id = le32_to_cpu(reg->region_id);
 		u32 type = le32_to_cpu(reg->region_type);
 
-		if (WARN(id >= ARRAY_SIZE(fwrt->dump.active_regs),
-			 "WRT: ext=%d. Invalid region id %d for apply point %d\n",
-			 ext, id, pnt))
+		if (WARN(id >= ARRAY_SIZE(fwrt->dump.active_regs), err_st, ext,
+			 "id", id, pnt))
+			break;
+
+		if (WARN(type == 0 || type >= IWL_FW_INI_REGION_NUM, err_st,
+			 ext, "type", type, pnt))
 			break;
 
 		active = &fwrt->dump.active_regs[id];
-- 
2.20.1

