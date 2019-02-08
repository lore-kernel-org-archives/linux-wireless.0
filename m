Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DB0BC169C4
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 10:47:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 752BE21919
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 10:47:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727744AbfBHKrw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 05:47:52 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:57100 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727723AbfBHKrw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 05:47:52 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gs3gw-0002jg-2m; Fri, 08 Feb 2019 12:47:30 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  8 Feb 2019 12:47:05 +0200
Message-Id: <20190208104712.16210-14-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190208104712.16210-1-luca@coelho.fi>
References: <20190208104712.16210-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 13/20] iwlwifi: properly use delay option in dump trigger flow
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Fix several issues related to dump delay:
1. In legacy dump trigger, use stop_delay field instead of trig_dis_ms.
2. ini delay is messured in usec so align both ini and legacy to usec.
3. schedule_delayed_work receives the delay value in jiffies so
translate the dump delay to jiffies.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Fixes: ea7cb8293874 ("iwlwifi: dbg: make trigger functions type agnostic")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 3b3692473702..8d1416e8a203 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1621,7 +1621,7 @@ int iwl_fw_dbg_collect_desc(struct iwl_fw_runtime *fwrt,
 	fwrt->dump.desc = desc;
 	fwrt->dump.monitor_only = monitor_only;
 
-	schedule_delayed_work(&fwrt->dump.wk, delay);
+	schedule_delayed_work(&fwrt->dump.wk, usecs_to_jiffies(delay));
 
 	return 0;
 }
@@ -1677,8 +1677,10 @@ int _iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
 		}
 
 		trigger->occurrences = cpu_to_le16(occurrences);
-		delay = le16_to_cpu(trigger->trig_dis_ms);
 		monitor_only = trigger->mode & IWL_FW_DBG_TRIGGER_MONITOR_ONLY;
+
+		/* convert msec to usec */
+		delay = le32_to_cpu(trigger->stop_delay) * USEC_PER_MSEC;
 	}
 
 	desc = kzalloc(sizeof(*desc) + len, GFP_ATOMIC);
-- 
2.20.1

