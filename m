Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49B48C49EA2
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jun 2021 07:09:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B54E61369
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jun 2021 07:09:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhFQHLO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jun 2021 03:11:14 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:47912 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230217AbhFQHLL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jun 2021 03:11:11 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=kveik.lan)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <luca@coelho.fi>)
        id 1ltm96-001XeC-Pk; Thu, 17 Jun 2021 10:09:02 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     luca@coelho.fi, linux-wireless@vger.kernel.org
Date:   Thu, 17 Jun 2021 10:08:48 +0300
Message-Id: <iwlwifi.20210617100544.0c00dd724f5c.I8283b95c26f4226deaea42e7be35aa9d41eb7580@changeid>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210617070852.496985-1-luca@coelho.fi>
References: <20210617070852.496985-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 08/12] iwlwifi: mvm: support LMR feedback
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Avraham Stern <avraham.stern@intel.com>

If the LMR feedback is set in the ranging request, set the
corresponding flag in the fw command.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
index a24e6c0490e9..59cef0d89a6d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
@@ -430,6 +430,10 @@ iwl_mvm_ftm_put_target_common(struct iwl_mvm *mvm,
 		FTM_PUT_FLAG(TB);
 	else if (peer->ftm.non_trigger_based)
 		FTM_PUT_FLAG(NON_TB);
+
+	if ((peer->ftm.trigger_based || peer->ftm.non_trigger_based) &&
+	    peer->ftm.lmr_feedback)
+		FTM_PUT_FLAG(LMR_FEEDBACK);
 }
 
 static int
-- 
2.32.0

