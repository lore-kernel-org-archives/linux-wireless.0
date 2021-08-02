Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABBF6C4338F
	for <linux-wireless@archiver.kernel.org>; Mon,  2 Aug 2021 14:20:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9328F60F41
	for <linux-wireless@archiver.kernel.org>; Mon,  2 Aug 2021 14:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235862AbhHBOUe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 2 Aug 2021 10:20:34 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:50880 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S234025AbhHBOUV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Aug 2021 10:20:21 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=kveik.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <luca@coelho.fi>)
        id 1mAYde-001xoA-U4; Mon, 02 Aug 2021 17:09:56 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     luca@coelho.fi, linux-wireless@vger.kernel.org
Date:   Mon,  2 Aug 2021 17:09:44 +0300
Message-Id: <iwlwifi.20210802170640.98980f8bd17f.Ifcedf415a545a87cb341a4142085b5723d8cac4d@changeid>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802140944.90143-1-luca@coelho.fi>
References: <20210802140944.90143-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 12/12] iwlwifi: iwl-dbg-tlv: add info about loading external dbg bin
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

This helps understand why and what debug capabilities are running.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index cc78fd23c922..c89db7b9585a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -435,13 +435,16 @@ static int iwl_dbg_tlv_parse_bin(struct iwl_trans *trans, const u8 *data,
 void iwl_dbg_tlv_load_bin(struct device *dev, struct iwl_trans *trans)
 {
 	const struct firmware *fw;
+	const char *yoyo_bin = "iwl-debug-yoyo.bin";
 	int res;
 
 	if (!iwlwifi_mod_params.enable_ini ||
 	    trans->trans_cfg->device_family <= IWL_DEVICE_FAMILY_9000)
 		return;
 
-	res = firmware_request_nowarn(&fw, "iwl-debug-yoyo.bin", dev);
+	res = firmware_request_nowarn(&fw, yoyo_bin, dev);
+	IWL_DEBUG_FW(trans, "%s %s\n", res ? "didn't load" : "loaded", yoyo_bin);
+
 	if (res)
 		return;
 
-- 
2.32.0

