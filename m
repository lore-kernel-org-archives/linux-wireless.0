Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AC2FC282E3
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 09:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 756FE206BA
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 09:10:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbfDWJKz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 05:10:55 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:58962 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726150AbfDWJKx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 05:10:53 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hIrRy-0000FN-RU; Tue, 23 Apr 2019 12:10:51 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 01/16] iwlwifi: Use correct channel_profile iniwl_get_nvm
Date:   Tue, 23 Apr 2019 12:10:28 +0300
Message-Id: <20190423091043.7156-2-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190423091043.7156-1-luca@coelho.fi>
References: <20190423091043.7156-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

commit 2785ce008e3b ("iwlwifi: support new NVM response API")
seems forgot use correct channel_profile in iwl_get_nvm when call
iwl_init_sbands().

Fixes: 2785ce008e3b ("iwlwifi: support new NVM response API")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 40985dc552b8..d87a6bb3e456 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -1496,7 +1496,7 @@ struct iwl_nvm_data *iwl_get_nvm(struct iwl_trans *trans,
 			  (void *)rsp_v3->regulatory.channel_profile;
 
 	iwl_init_sbands(trans->dev, trans->cfg, nvm,
-			rsp->regulatory.channel_profile,
+			channel_profile,
 			nvm->valid_tx_ant & fw->valid_tx_ant,
 			nvm->valid_rx_ant & fw->valid_rx_ant,
 			sbands_flags, v4);
-- 
2.20.1

