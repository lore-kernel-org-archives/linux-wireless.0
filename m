Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E91A3C4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 09:22:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7DA120830
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 09:22:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbfDCJWk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 05:22:40 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:49748 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726536AbfDCJWk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 05:22:40 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1hBc6P-0007aR-QV; Wed, 03 Apr 2019 12:22:38 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed,  3 Apr 2019 12:22:19 +0300
Message-Id: <20190403092224.815-9-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190403092224.815-1-luca@coelho.fi>
References: <20190403092224.815-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 08/13] iwlwifi: dbg: add periphery memory dumping support to ax210 device family
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Allows to dump periphery memory on ax210 devices.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index ba01e8f5e2e0..18e8ace5f72d 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -557,6 +557,11 @@ static const struct iwl_prph_range iwl_prph_dump_addr_22000[] = {
 	{ .start = 0x00a0c1b0, .end = 0x00a0c1b8 },
 };
 
+static const struct iwl_prph_range iwl_prph_dump_addr_ax210[] = {
+	{ .start = 0x00d03c00, .end = 0x00d03c64 },
+	{ .start = 0x00d0c000, .end = 0x00d0c174 },
+};
+
 static void iwl_read_prph_block(struct iwl_trans *trans, u32 start,
 				u32 len_bytes, __le32 *data)
 {
@@ -675,7 +680,8 @@ static void iwl_fw_prph_handler(struct iwl_fw_runtime *fwrt, void *ptr,
 	u32 range_len;
 
 	if (fwrt->trans->cfg->device_family >= IWL_DEVICE_FAMILY_AX210) {
-		/* TODO */
+		range_len = ARRAY_SIZE(iwl_prph_dump_addr_ax210);
+		handler(fwrt, iwl_prph_dump_addr_ax210, range_len, ptr);
 	} else if (fwrt->trans->cfg->device_family >= IWL_DEVICE_FAMILY_22000) {
 		range_len = ARRAY_SIZE(iwl_prph_dump_addr_22000);
 		handler(fwrt, iwl_prph_dump_addr_22000, range_len, ptr);
-- 
2.20.1

