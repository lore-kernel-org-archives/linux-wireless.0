Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24C5AC282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 06:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB87D2148E
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 06:50:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbfA1GuP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 01:50:15 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:2785 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726750AbfA1GuO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 01:50:14 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 9DA7BCAA8EE3B1E2EDCA;
        Mon, 28 Jan 2019 14:50:11 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.408.0; Mon, 28 Jan 2019
 14:50:02 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <johannes.berg@intel.com>, <emmanuel.grumbach@intel.com>,
        <luciano.coelho@intel.com>, <linuxwifi@intel.com>,
        <kvalo@codeaurora.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH 2/2] iwlwifi: Use struct_size() in kzalloc
Date:   Mon, 28 Jan 2019 14:44:32 +0800
Message-ID: <20190128064432.17576-3-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
In-Reply-To: <20190128064432.17576-1-yuehaibing@huawei.com>
References: <20190128064432.17576-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use struct_size() in kzalloc instead of the 'regd_to_copy'

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 569cc50..cb9e722 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -1093,7 +1093,7 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
 	const u8 *nvm_chan = cfg->nvm_type == IWL_NVM_EXT ?
 			     iwl_ext_nvm_channels : iwl_nvm_channels;
 	struct ieee80211_regdomain *regd, *copy_rd;
-	int size_of_regd, regd_to_copy;
+	int size_of_regd;
 	struct ieee80211_reg_rule *rule;
 	struct regdb_ptrs *regdb_ptrs;
 	enum nl80211_band band;
@@ -1193,10 +1193,8 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
 	 * Narrow down regdom for unused regulatory rules to prevent hole
 	 * between reg rules to wmm rules.
 	 */
-	regd_to_copy = sizeof(struct ieee80211_regdomain) +
-		valid_rules * sizeof(struct ieee80211_reg_rule);
-
-	copy_rd = kmemdup(regd, regd_to_copy, GFP_KERNEL);
+	copy_rd = kmemdup(regd, struct_size(regd, reg_rules, valid_rules),
+			  GFP_KERNEL);
 	if (!copy_rd)
 		copy_rd = ERR_PTR(-ENOMEM);
 
-- 
2.7.4


