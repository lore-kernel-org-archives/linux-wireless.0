Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21D05C49EA7
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jun 2021 19:18:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05B4D613D3
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jun 2021 19:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbhFXTU6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Jun 2021 15:20:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47904 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232370AbhFXTU5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Jun 2021 15:20:57 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1lwUrx-0001gb-T8; Thu, 24 Jun 2021 19:18:34 +0000
From:   Colin King <colin.king@canonical.com>
To:     Luca Coelho <luciano.coelho@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] iwlwifi: Fix error return on failed kmalloc
Date:   Thu, 24 Jun 2021 20:18:33 +0100
Message-Id: <20210624191833.170036-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the failing kmalloc sets package to the -ENOMEM error
return value however the error is returned by variable data. Fix this
by setting data to the error code instead.

Addresses-Coverity: ("Unused value")
Fixes: 9dad325f9d57 ("iwlwifi: support loading the reduced power table from UEFI")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
index a7c79d814aa4..c2c8078278f7 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
@@ -229,7 +229,7 @@ void *iwl_uefi_get_reduced_power(struct iwl_trans *trans, size_t *len)
 
 	package = kmalloc(package_size, GFP_KERNEL);
 	if (!package) {
-		package = ERR_PTR(-ENOMEM);
+		data = ERR_PTR(-ENOMEM);
 		goto out;
 	}
 
-- 
2.31.1

