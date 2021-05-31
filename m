Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46FA3C47082
	for <linux-wireless@archiver.kernel.org>; Mon, 31 May 2021 08:22:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22156610A8
	for <linux-wireless@archiver.kernel.org>; Mon, 31 May 2021 08:22:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbhEaIXm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 31 May 2021 04:23:42 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3477 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbhEaIXl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 May 2021 04:23:41 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Ftp9K4j7VzYs0K
        for <linux-wireless@vger.kernel.org>; Mon, 31 May 2021 16:19:17 +0800 (CST)
Received: from dggpeml500023.china.huawei.com (7.185.36.114) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 31 May 2021 16:22:00 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 31 May 2021 16:22:00 +0800
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
To:     <linux-wireless@vger.kernel.org>
CC:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH] iwlwifi: remove the repeated declaration
Date:   Mon, 31 May 2021 16:21:48 +0800
Message-ID: <1622449308-62416-1-git-send-email-zhangshaokun@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Variable 'iwl_ax201_cfg_qu_hr' is declared twice, so remove the
repeated declaration.

Cc: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-config.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index b35ffdfdf14b..2b8a76ff6314 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -586,7 +586,6 @@ extern const struct iwl_cfg iwl_qu_b0_hr_b0;
 extern const struct iwl_cfg iwl_qu_c0_hr_b0;
 extern const struct iwl_cfg iwl_ax200_cfg_cc;
 extern const struct iwl_cfg iwl_ax201_cfg_qu_hr;
-extern const struct iwl_cfg iwl_ax201_cfg_qu_hr;
 extern const struct iwl_cfg iwl_ax201_cfg_qu_c0_hr_b0;
 extern const struct iwl_cfg iwl_ax201_cfg_quz_hr;
 extern const struct iwl_cfg iwl_ax1650i_cfg_quz_hr;
-- 
2.7.4

