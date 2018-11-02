Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 682FCC32789
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 11:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 380A320657
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 11:08:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 380A320657
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbeKBUP3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Nov 2018 16:15:29 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:34102 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726026AbeKBUP3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Nov 2018 16:15:29 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gIXJG-0007MW-FJ; Fri, 02 Nov 2018 13:08:14 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Naftali Goldstein <naftali.goldstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  2 Nov 2018 13:07:55 +0200
Message-Id: <20181102110800.29817-11-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181102110800.29817-1-luca@coelho.fi>
References: <20181102110800.29817-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 10/15] iwlwifi: mvm: add description to a few generic assert numbers
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Naftali Goldstein <naftali.goldstein@intel.com>

FW asserts 0x70, 0x71, and 0x73 all just mean that the real error
happened in another MAC, and to look there for the problem. Add their
descriptions to the assert number lookup table so users get a nicer
error message in the logs.
Also, since the 4 most-significant bits of the assert number are
dynamic, and depend on which MAC the assert occurred on, ignore those
bits when looking up the assert name.

Signed-off-by: Naftali Goldstein <naftali.goldstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 3fd673128d51..3761fbfff292 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -285,6 +285,7 @@ u8 iwl_mvm_next_antenna(struct iwl_mvm *mvm, u8 valid, u8 last_idx)
 	return last_idx;
 }
 
+#define FW_SYSASSERT_CPU_MASK 0xf0000000
 static const struct {
 	const char *name;
 	u8 num;
@@ -301,6 +302,9 @@ static const struct {
 	{ "NMI_INTERRUPT_WDG_RXF_FULL", 0x5C },
 	{ "NMI_INTERRUPT_WDG_NO_RBD_RXF_FULL", 0x64 },
 	{ "NMI_INTERRUPT_HOST", 0x66 },
+	{ "NMI_INTERRUPT_LMAC_FATAL", 0x70 },
+	{ "NMI_INTERRUPT_UMAC_FATAL", 0x71 },
+	{ "NMI_INTERRUPT_OTHER_LMAC_FATAL", 0x73 },
 	{ "NMI_INTERRUPT_ACTION_PT", 0x7C },
 	{ "NMI_INTERRUPT_UNKNOWN", 0x84 },
 	{ "NMI_INTERRUPT_INST_ACTION_PT", 0x86 },
@@ -312,7 +316,7 @@ static const char *desc_lookup(u32 num)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(advanced_lookup) - 1; i++)
-		if (advanced_lookup[i].num == num)
+		if (advanced_lookup[i].num == (num & ~FW_SYSASSERT_CPU_MASK))
 			return advanced_lookup[i].name;
 
 	/* No entry matches 'num', so it is the last: ADVANCED_SYSASSERT */
-- 
2.19.1

