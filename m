Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A4FC282CB
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 10:47:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9C7A21919
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 10:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbfBHKrt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 05:47:49 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:57092 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727739AbfBHKrs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 05:47:48 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gs3gy-0002jg-C2; Fri, 08 Feb 2019 12:47:32 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  8 Feb 2019 12:47:08 +0200
Message-Id: <20190208104712.16210-17-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190208104712.16210-1-luca@coelho.fi>
References: <20190208104712.16210-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 16/20] iwlwifi: dbg: buffer overflow in non_collect_ts_start array
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

The size of the buffer is IWL_FW_TRIGGER_ID_NUM - 1 which is equal to
IWL_FW_TRIGGER_ID_HOST_CHANNEL_SWITCH_COMPLETE so if the driver receives
this trigger, it will cause a buffer overflow.

Solve this by increasing the buffer size by 1.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Fixes: fe1b7d6c2888 ("iwlwifi: add support for triggering ini triggers")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
index 41c4a3e7ad82..6e843998d1c8 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
@@ -138,7 +138,7 @@ struct iwl_fw_runtime {
 		u8 conf;
 
 		/* ts of the beginning of a non-collect fw dbg data period */
-		unsigned long non_collect_ts_start[IWL_FW_TRIGGER_ID_NUM - 1];
+		unsigned long non_collect_ts_start[IWL_FW_TRIGGER_ID_NUM];
 		u32 *d3_debug_data;
 		struct iwl_fw_ini_region_cfg *active_regs[IWL_FW_INI_MAX_REGION_ID];
 		struct iwl_fw_ini_active_triggers active_trigs[IWL_FW_TRIGGER_ID_NUM];
-- 
2.20.1

