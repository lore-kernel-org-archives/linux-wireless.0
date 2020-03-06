Return-Path: <SRS0=+GjY=4X=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7018DC10F26
	for <linux-wireless@archiver.kernel.org>; Fri,  6 Mar 2020 13:16:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47E7E21739
	for <linux-wireless@archiver.kernel.org>; Fri,  6 Mar 2020 13:16:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbgCFNQr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 6 Mar 2020 08:16:47 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:60928 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726579AbgCFNQq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Mar 2020 08:16:46 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <luca@coelho.fi>)
        id 1jACqK-0005yR-QI; Fri, 06 Mar 2020 15:16:45 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Fri,  6 Mar 2020 15:16:23 +0200
Message-Id: <iwlwifi.20200306151128.06e00e6e980f.I9a890ce83493b79892a5f690d12016525317fa7e@changeid>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200306131627.503176-1-luca@coelho.fi>
References: <20200306131627.503176-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH v5.6 3/7] iwlwifi: check allocated pointer when allocating conf_tlvs
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

We were erroneously checking the length of the tlv instead of checking
the pointer returned by kmemdup() when allocating dbg_conf_tlv[].
This was probably a typo.  Fix it by checking the returned pointer
instead of the length.

Reported-by: Markus Elfring <Markus.Elfring@web.de>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 2d1cb4647c3b..0481796f75bc 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1467,7 +1467,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 				kmemdup(pieces->dbg_conf_tlv[i],
 					pieces->dbg_conf_tlv_len[i],
 					GFP_KERNEL);
-			if (!pieces->dbg_conf_tlv_len[i])
+			if (!pieces->dbg_conf_tlv[i])
 				goto out_free_fw;
 		}
 	}
-- 
2.25.1

