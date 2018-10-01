Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DED2EC0044B
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 12:10:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD8AE208AE
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 12:10:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD8AE208AE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729339AbeJASsL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 14:48:11 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:54408 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729264AbeJASsL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 14:48:11 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g6x1y-0006wq-0M; Mon, 01 Oct 2018 15:10:30 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Yisheng Xie <xieyisheng1@huawei.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon,  1 Oct 2018 15:10:08 +0300
Message-Id: <20181001121010.29684-15-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181001121010.29684-1-luca@coelho.fi>
References: <20181001121010.29684-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 14/16] iwlwifi: mvm: use match_string() helper
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Yisheng Xie <xieyisheng1@huawei.com>

match_string() returns the index of an array for a matching string,
which can be used intead of open coded variant.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index de40752aa67e..3b6b3d8fb961 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -666,16 +666,11 @@ iwl_dbgfs_bt_force_ant_write(struct iwl_mvm *mvm, char *buf,
 	};
 	int ret, bt_force_ant_mode;
 
-	for (bt_force_ant_mode = 0;
-	     bt_force_ant_mode < ARRAY_SIZE(modes_str);
-	     bt_force_ant_mode++) {
-		if (!strcmp(buf, modes_str[bt_force_ant_mode]))
-			break;
-	}
-
-	if (bt_force_ant_mode >= ARRAY_SIZE(modes_str))
-		return -EINVAL;
+	ret = match_string(modes_str, ARRAY_SIZE(modes_str), buf);
+	if (ret < 0)
+		return ret;
 
+	bt_force_ant_mode = ret;
 	ret = 0;
 	mutex_lock(&mvm->mutex);
 	if (mvm->bt_force_ant_mode == bt_force_ant_mode)
-- 
2.19.0

