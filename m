Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68677C3DA7A
	for <linux-wireless@archiver.kernel.org>; Thu,  5 Jan 2023 07:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbjAEHgO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 5 Jan 2023 02:36:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbjAEHgM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jan 2023 02:36:12 -0500
Received: from out20-110.mail.aliyun.com (out20-110.mail.aliyun.com [115.124.20.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15FF4BC9C
        for <linux-wireless@vger.kernel.org>; Wed,  4 Jan 2023 23:36:08 -0800 (PST)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.2982091|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_alarm|0.0780417-0.000864095-0.921094;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047193;MF=aiden.leong@aibsd.com;NM=1;PH=DS;RN=8;RT=8;SR=0;TI=SMTPD_---.Qkv9wW3_1672904165;
Received: from localhost.localdomain(mailfrom:aiden.leong@aibsd.com fp:SMTPD_---.Qkv9wW3_1672904165)
          by smtp.aliyun-inc.com;
          Thu, 05 Jan 2023 15:36:05 +0800
From:   Aiden Leong <aiden.leong@aibsd.com>
To:     linux-wireless@vger.kernel.org
Cc:     gregory.greenman@intel.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        Aiden Leong <aiden.leong@aibsd.com>
Subject: [PATCH v2] wifi: iwlwifi: pcie: fix an indent error reported by checkpatch.pl
Date:   Thu,  5 Jan 2023 15:35:41 +0800
Message-Id: <20230105073540.8119-1-aiden.leong@aibsd.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

ERROR: switch and case should be at the same indent
+	switch (REG_CRF_ID_TYPE(val)) {
[...]
+		case REG_CRF_ID_TYPE_FM:

We should use Git post-commit hooks to avoid such errors.

Signed-off-by: Aiden Leong <aiden.leong@aibsd.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 99768d6a6032..eabbab488e1f 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1416,9 +1416,9 @@ static int map_crf_id(struct iwl_trans *iwl_trans)
 	case REG_CRF_ID_TYPE_MR:
 		iwl_trans->hw_rf_id = (IWL_CFG_RF_TYPE_MR << 12);
 		break;
-		case REG_CRF_ID_TYPE_FM:
-			iwl_trans->hw_rf_id = (IWL_CFG_RF_TYPE_FM << 12);
-			break;
+	case REG_CRF_ID_TYPE_FM:
+		iwl_trans->hw_rf_id = (IWL_CFG_RF_TYPE_FM << 12);
+		break;
 	default:
 		ret = -EIO;
 		IWL_ERR(iwl_trans,
-- 
2.39.0

