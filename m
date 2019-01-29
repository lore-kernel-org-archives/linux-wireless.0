Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A124C282CD
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 03:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19C832084C
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 03:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727583AbfA2DXK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 22:23:10 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:3229 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727142AbfA2DXJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 22:23:09 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0149E344966DDAFECB4B;
        Tue, 29 Jan 2019 11:23:08 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.408.0; Tue, 29 Jan 2019
 11:22:58 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <johannes.berg@intel.com>, <emmanuel.grumbach@intel.com>,
        <luciano.coelho@intel.com>, <linuxwifi@intel.com>,
        <kvalo@codeaurora.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH v2 2/2] iwlwifi: Use struct_size() in kzalloc
Date:   Tue, 29 Jan 2019 11:21:44 +0800
Message-ID: <20190129032144.18120-3-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
In-Reply-To: <20190129032144.18120-1-yuehaibing@huawei.com>
References: <20190129032144.18120-1-yuehaibing@huawei.com>
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
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 569cc50..2b87c7c 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -1093,7 +1093,6 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
 	const u8 *nvm_chan = cfg->nvm_type == IWL_NVM_EXT ?
 			     iwl_ext_nvm_channels : iwl_nvm_channels;
 	struct ieee80211_regdomain *regd, *copy_rd;
-	int size_of_regd, regd_to_copy;
 	struct ieee80211_reg_rule *rule;
 	struct regdb_ptrs *regdb_ptrs;
 	enum nl80211_band band;
@@ -1113,11 +1112,7 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
 		      num_of_ch);
 
 	/* build a regdomain rule for every valid channel */
-	size_of_regd =
-		sizeof(struct ieee80211_regdomain) +
-		num_of_ch * sizeof(struct ieee80211_reg_rule);
-
-	regd = kzalloc(size_of_regd, GFP_KERNEL);
+	regd = kzalloc(struct_size(regd, reg_rules, num_of_ch), GFP_KERNEL);
 	if (!regd)
 		return ERR_PTR(-ENOMEM);
 
@@ -1193,10 +1188,8 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
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


