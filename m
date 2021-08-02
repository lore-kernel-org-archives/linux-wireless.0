Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6E64C4320E
	for <linux-wireless@archiver.kernel.org>; Mon,  2 Aug 2021 14:28:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 851DA60EC0
	for <linux-wireless@archiver.kernel.org>; Mon,  2 Aug 2021 14:28:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbhHBO2s (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 2 Aug 2021 10:28:48 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:50942 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S234177AbhHBO2s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Aug 2021 10:28:48 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=kveik.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <luca@coelho.fi>)
        id 1mAYvk-001xts-Eu; Mon, 02 Aug 2021 17:28:37 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     luca@coelho.fi, linux-wireless@vger.kernel.org
Date:   Mon,  2 Aug 2021 17:28:24 +0300
Message-Id: <iwlwifi.20210802172232.d16206ca60fc.I9984a9b442c84814c307cee3213044e24d26f38a@changeid>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802142829.109448-1-luca@coelho.fi>
References: <20210802142829.109448-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 07/12] iwlwifi: mvm: fix a memory leak in iwl_mvm_mac_ctxt_beacon_changed
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

If beacon_inject_active is true, we will return without freeing
beacon.  Fid that by freeing it before returning.

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
[reworded the commit message]
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 76a658cb5493..2fbc1a3bbdca 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1008,8 +1008,10 @@ int iwl_mvm_mac_ctxt_beacon_changed(struct iwl_mvm *mvm,
 		return -ENOMEM;
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-	if (mvm->beacon_inject_active)
+	if (mvm->beacon_inject_active) {
+		dev_kfree_skb(beacon);
 		return -EBUSY;
+	}
 #endif
 
 	ret = iwl_mvm_mac_ctxt_send_beacon(mvm, vif, beacon);
-- 
2.32.0

