Return-Path: <SRS0=ZuNb=DF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66E19C4727F
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Sep 2020 09:23:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A791221E8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Sep 2020 09:23:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgI1JXe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Sep 2020 05:23:34 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:52776 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726604AbgI1JXc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Sep 2020 05:23:32 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1kMpNa-002KgD-Bb; Mon, 28 Sep 2020 12:23:30 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Mon, 28 Sep 2020 12:23:17 +0300
Message-Id: <iwlwifi.20200928121852.3de51c557566.I67a0eedddbd56e51eb5150c65756eb5724b65e69@changeid>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200928092321.649185-1-luca@coelho.fi>
References: <20200928092321.649185-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 08/12] iwlwifi: acpi: in non acpi compilations remove iwl_sar_geo_init
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

In non acpi compilations iwl_sar_geo_init isn't called which results with
compilation warning so just remove the declaration.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.h b/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
index 9d08d74e6939..71ef8647d7b5 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
@@ -269,12 +269,6 @@ static inline bool iwl_sar_geo_support(struct iwl_fw_runtime *fwrt)
 	return false;
 }
 
-static int iwl_sar_geo_init(struct iwl_fw_runtime *fwrt,
-			    struct iwl_per_chain_offset *table, u32 n_bands)
-{
-	return -ENOENT;
-}
-
 static inline int iwl_acpi_get_tas(struct iwl_fw_runtime *fwrt,
 				   __le32 *black_list_array,
 				   int *black_list_size)
-- 
2.28.0

