Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DEC3C433E0
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Feb 2021 12:43:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1A9164E78
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Feb 2021 12:43:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbhBHMnT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Feb 2021 07:43:19 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:44346 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232435AbhBHMli (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Feb 2021 07:41:38 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1l95qG-0047MN-Dx; Mon, 08 Feb 2021 14:40:37 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Mon,  8 Feb 2021 14:40:23 +0200
Message-Id: <iwlwifi.20210208143712.c6229cd99749.I0d96fe7b799527c49f1270ddf9acdb152bdd4841@changeid>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208124034.1933780-1-luca@coelho.fi>
References: <20210208124034.1933780-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 01/12] iwlwifi: pcie: add a few missing entries for So with Hr
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Some devices were missing from the So with Hr section.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index f0acf7fe59fe..159ca2e27758 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -596,9 +596,16 @@ static const struct iwl_dev_info iwl_dev_info_table[] = {
 	/* So with HR */
 	IWL_DEV_INFO(0x2725, 0x0090, iwlax211_2ax_cfg_so_gf_a0, NULL),
 	IWL_DEV_INFO(0x2725, 0x0020, iwlax210_2ax_cfg_ty_gf_a0, NULL),
+	IWL_DEV_INFO(0x2725, 0x2020, iwlax210_2ax_cfg_ty_gf_a0, NULL),
+	IWL_DEV_INFO(0x2725, 0x0024, iwlax210_2ax_cfg_ty_gf_a0, NULL),
 	IWL_DEV_INFO(0x2725, 0x0310, iwlax210_2ax_cfg_ty_gf_a0, NULL),
 	IWL_DEV_INFO(0x2725, 0x0510, iwlax210_2ax_cfg_ty_gf_a0, NULL),
 	IWL_DEV_INFO(0x2725, 0x0A10, iwlax210_2ax_cfg_ty_gf_a0, NULL),
+	IWL_DEV_INFO(0x2725, 0xE020, iwlax210_2ax_cfg_ty_gf_a0, NULL),
+	IWL_DEV_INFO(0x2725, 0xE024, iwlax210_2ax_cfg_ty_gf_a0, NULL),
+	IWL_DEV_INFO(0x2725, 0x4020, iwlax210_2ax_cfg_ty_gf_a0, NULL),
+	IWL_DEV_INFO(0x2725, 0x6020, iwlax210_2ax_cfg_ty_gf_a0, NULL),
+	IWL_DEV_INFO(0x2725, 0x6024, iwlax210_2ax_cfg_ty_gf_a0, NULL),
 	IWL_DEV_INFO(0x7A70, 0x0090, iwlax211_2ax_cfg_so_gf_a0_long, NULL),
 	IWL_DEV_INFO(0x7A70, 0x0098, iwlax211_2ax_cfg_so_gf_a0_long, NULL),
 	IWL_DEV_INFO(0x7A70, 0x00B0, iwlax411_2ax_cfg_so_gf4_a0_long, NULL),
@@ -617,6 +624,7 @@ static const struct iwl_dev_info iwl_dev_info_table[] = {
 	IWL_DEV_INFO(0x2726, 0x0090, iwlax211_cfg_snj_gf_a0, NULL),
 	IWL_DEV_INFO(0x2726, 0x0098, iwlax211_cfg_snj_gf_a0, NULL),
 	IWL_DEV_INFO(0x2726, 0x00B0, iwlax411_2ax_cfg_sosnj_gf4_a0, NULL),
+	IWL_DEV_INFO(0x2726, 0x00B4, iwlax411_2ax_cfg_sosnj_gf4_a0, NULL),
 	IWL_DEV_INFO(0x2726, 0x0510, iwlax211_cfg_snj_gf_a0, NULL),
 	IWL_DEV_INFO(0x2726, 0x1651, iwl_cfg_snj_hr_b0, iwl_ax201_killer_1650s_name),
 	IWL_DEV_INFO(0x2726, 0x1652, iwl_cfg_snj_hr_b0, iwl_ax201_killer_1650i_name),
@@ -987,7 +995,6 @@ static const struct iwl_dev_info iwl_dev_info_table[] = {
 		      IWL_CFG_ANY, IWL_CFG_ANY,
 		      iwl_cfg_snj_a0_mr_a0, iwl_ma_name),
 
-
 #endif /* CONFIG_IWLMVM */
 };
 
-- 
2.30.0

