Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B633C433E0
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Feb 2021 14:33:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14BDE64F16
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Feb 2021 14:33:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbhBYOdZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Feb 2021 09:33:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:56182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231248AbhBYOdX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Feb 2021 09:33:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3605F64EC3;
        Thu, 25 Feb 2021 14:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614263563;
        bh=TF7d3kZU11RlL3LhvGBRVe0/IJ+uPtdyR01vC/FT4Yg=;
        h=From:To:Cc:Subject:Date:From;
        b=KtBrUgSQUgZ9+zFzuHDlo3UHDZmV/rN8FadNXWDIO+eYlzXbRQqgbu+KFui3yY474
         wrXr/3tUOoJZJVxpxouz9P4cZRjii26iJPqahoUxMfzrySTxknbIeFkGB80uJNF4wf
         8NCfZkOxKBeOcURlHmgnG1Z5cUSfJTY/cRQguGGz7kk97Y/DoFddKhAKKeWtpdme0q
         n0dU9PQAElNgHPcrT2H+iaGtT2I6/9c3DI+7IL4+Nt1cMQhZTaq1dq6O6ByjJmZS+W
         6UpQPJdQYyh+TZQSqZoUi+9cVHZJoMGDN92Kk8qps9LFcAI+brgjxHxKfF6fitFNfl
         LnJWxlYZvHLxw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Ihab Zhaika <ihab.zhaika@intel.com>,
        Matti Gottlieb <matti.gottlieb@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: fix link error without CONFIG_IWLMVM
Date:   Thu, 25 Feb 2021 15:30:37 +0100
Message-Id: <20210225143236.3543360-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

A runtime check that was introduced recently failed to
check for the matching Kconfig symbol:

ld.lld: error: undefined symbol: iwl_so_trans_cfg
>>> referenced by drv.c
>>>               net/wireless/intel/iwlwifi/pcie/drv.o:(iwl_pci_probe)

Fixes: 930be4e76f26 ("iwlwifi: add support for SnJ with Jf devices")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 314fec4a89ad..a2f5c4fc2324 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1113,7 +1113,8 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * here.  But if we detect that the MAC type is actually SnJ,
 	 * we should switch to it here to avoid problems later.
 	 */
-	if (CSR_HW_REV_TYPE(iwl_trans->hw_rev) == IWL_CFG_MAC_TYPE_SNJ)
+	if (IS_ENABLED(CONFIG_IWLMVM) &&
+	    CSR_HW_REV_TYPE(iwl_trans->hw_rev) == IWL_CFG_MAC_TYPE_SNJ)
 		iwl_trans->trans_cfg = &iwl_so_trans_cfg;
 
 #if IS_ENABLED(CONFIG_IWLMVM)
-- 
2.29.2

