Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6261C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 16:37:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86EE42077B
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 16:37:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729601AbfCOQhY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 12:37:24 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:44360 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729541AbfCOQhX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 12:37:23 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h4ppF-0004qp-09; Fri, 15 Mar 2019 18:36:53 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 15 Mar 2019 18:36:32 +0200
Message-Id: <20190315163634.17315-15-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190315163634.17315-1-luca@coelho.fi>
References: <20190315163634.17315-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 14/16] iwlwifi: Use struct_size() in kzalloc
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

Use struct_size() in kzalloc instead of the 'regd_to_copy'

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 1408c89242a7..2d11fc0e351f 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -1086,7 +1086,6 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
 	u32 reg_rule_flags, prev_reg_rule_flags = 0;
 	const u16 *nvm_chan;
 	struct ieee80211_regdomain *regd, *copy_rd;
-	int size_of_regd, regd_to_copy;
 	struct ieee80211_reg_rule *rule;
 	struct regdb_ptrs *regdb_ptrs;
 	enum nl80211_band band;
@@ -1116,11 +1115,7 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
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
 
@@ -1196,10 +1191,8 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
 	 * Narrow down regdom for unused regulatory rules to prevent hole
 	 * between reg rules to wmm rules.
 	 */
-	regd_to_copy = sizeof(struct ieee80211_regdomain) +
-		valid_rules * sizeof(struct ieee80211_reg_rule);
-
-	copy_rd = kmemdup(regd, regd_to_copy, GFP_KERNEL);
+	copy_rd = kmemdup(regd, struct_size(regd, reg_rules, valid_rules),
+			  GFP_KERNEL);
 	if (!copy_rd) {
 		copy_rd = ERR_PTR(-ENOMEM);
 		goto out;
-- 
2.20.1

