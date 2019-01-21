Return-Path: <SRS0=xI28=P5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6462AC282E6
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 07:50:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 319322084A
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 07:50:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbfAUHui (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Jan 2019 02:50:38 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:49042 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728704AbfAUHuh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Jan 2019 02:50:37 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1glULq-0006cr-Mt; Mon, 21 Jan 2019 09:50:35 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon, 21 Jan 2019 09:50:13 +0200
Message-Id: <20190121075026.25059-4-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190121075026.25059-1-luca@coelho.fi>
References: <20190121075026.25059-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 03/16] iwlwifi: use kmemdup in iwl_parse_nvm_mcc_info()
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

Use kmemdup rather than duplicating its implementation in
iwl_parse_nvm_mcc_info().

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 173ade96f119..484ef4556953 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -1195,14 +1195,12 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
 	regd_to_copy = sizeof(struct ieee80211_regdomain) +
 		valid_rules * sizeof(struct ieee80211_reg_rule);
 
-	copy_rd = kzalloc(regd_to_copy, GFP_KERNEL);
+	copy_rd = kmemdup(regd, regd_to_copy, GFP_KERNEL);
 	if (!copy_rd) {
 		copy_rd = ERR_PTR(-ENOMEM);
 		goto out;
 	}
 
-	memcpy(copy_rd, regd, regd_to_copy);
-
 out:
 	kfree(regdb_ptrs);
 	kfree(regd);
-- 
2.20.1

