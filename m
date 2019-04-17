Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A97D4C10F14
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 03:25:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A0D420643
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 03:25:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730019AbfDQDZd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 23:25:33 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:6754 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728083AbfDQDZd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 23:25:33 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id AE64A5FD58C2F666939A;
        Wed, 17 Apr 2019 11:25:30 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.408.0; Wed, 17 Apr 2019
 11:25:20 +0800
From:   Yue Haibing <yuehaibing@huawei.com>
To:     <johannes.berg@intel.com>, <emmanuel.grumbach@intel.com>,
        <luciano.coelho@intel.com>, <linuxwifi@intel.com>,
        <kvalo@codeaurora.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <davem@davemloft.net>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] iwlwifi: Use correct channel_profile iniwl_get_nvm
Date:   Wed, 17 Apr 2019 11:24:09 +0800
Message-ID: <20190417032409.23924-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
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
---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 40985dc..d87a6bb 100644
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
2.7.0


