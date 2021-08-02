Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF312C432BE
	for <linux-wireless@archiver.kernel.org>; Mon,  2 Aug 2021 14:28:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B978460EC0
	for <linux-wireless@archiver.kernel.org>; Mon,  2 Aug 2021 14:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234225AbhHBO2v (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 2 Aug 2021 10:28:51 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:50954 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S234182AbhHBO2u (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Aug 2021 10:28:50 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=kveik.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <luca@coelho.fi>)
        id 1mAYvl-001xts-U4; Mon, 02 Aug 2021 17:28:39 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     luca@coelho.fi, linux-wireless@vger.kernel.org
Date:   Mon,  2 Aug 2021 17:28:26 +0300
Message-Id: <iwlwifi.20210802172232.2a583d006739.Ia782c08525397b6430b1c877a870d688a7f3f494@changeid>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802142829.109448-1-luca@coelho.fi>
References: <20210802142829.109448-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 09/12] iwlwifi: use DEFINE_MUTEX() for mutex lock
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>

mutex lock can be initialized automatically with DEFINE_MUTEX()
rather than explicitly calling mutex_init().

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 977dce686bdb..77124b8b235e 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -78,7 +78,7 @@ enum {
 };
 
 /* Protects the table contents, i.e. the ops pointer & drv list */
-static struct mutex iwlwifi_opmode_table_mtx;
+static DEFINE_MUTEX(iwlwifi_opmode_table_mtx);
 static struct iwlwifi_opmode_table {
 	const char *name;			/* name: iwldvm, iwlmvm, etc */
 	const struct iwl_op_mode_ops *ops;	/* pointer to op_mode ops */
@@ -1754,8 +1754,6 @@ static int __init iwl_drv_init(void)
 {
 	int i, err;
 
-	mutex_init(&iwlwifi_opmode_table_mtx);
-
 	for (i = 0; i < ARRAY_SIZE(iwlwifi_opmode_table); i++)
 		INIT_LIST_HEAD(&iwlwifi_opmode_table[i].drv);
 
-- 
2.32.0

