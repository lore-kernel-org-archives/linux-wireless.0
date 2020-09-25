Return-Path: <SRS0=Pl1w=DC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 561F4C4741F
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Sep 2020 21:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 333E121D42
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Sep 2020 21:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbgIYVbl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Sep 2020 17:31:41 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:52402 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729008AbgIYVbl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Sep 2020 17:31:41 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1kLvJ5-002J1P-1a; Sat, 26 Sep 2020 00:31:07 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Sat, 26 Sep 2020 00:30:52 +0300
Message-Id: <iwlwifi.20200926002540.1833ae348c7f.I3271f9d2f7e484779a6319a1514cd0b7221fe326@changeid>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925213053.454459-1-luca@coelho.fi>
References: <20200925213053.454459-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 14/15] iwlwifi: acpi: remove dummy definition of iwl_sar_set_profile()
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

This function is only called from acpi.c, which is only included in
the makefile if CONFIG_ACPI is set.  So it doesn't make sense to
declare a dummy version of it when CONFIG_ACPI is not defined.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.h b/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
index 56f3399fe99e..eafc23c6f55f 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
@@ -241,13 +241,6 @@ static inline int iwl_acpi_get_eckv(struct device *dev, u32 *extl_clk)
 	return -ENOENT;
 }
 
-static inline int iwl_sar_set_profile(union acpi_object *table,
-				      struct iwl_sar_profile *profile,
-				      bool enabled)
-{
-	return -ENOENT;
-}
-
 static inline int iwl_sar_select_profile(struct iwl_fw_runtime *fwrt,
 			   __le16 per_chain_restriction[][IWL_NUM_SUB_BANDS],
 			   int prof_a, int prof_b)
-- 
2.28.0

