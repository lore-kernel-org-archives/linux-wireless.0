Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3B7BC10F03
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 07:14:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA6D120685
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 07:14:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730033AbfDYHOe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 03:14:34 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:49288 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726474AbfDYHOe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 03:14:34 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hJYaW-0000HK-QS; Thu, 25 Apr 2019 10:14:32 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH v5.1] iwlwifi: mvm: fix merge damage in iwl_mvm_vif_dbgfs_register()
Date:   Thu, 25 Apr 2019 10:14:28 +0300
Message-Id: <20190425071428.29918-1-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

When I rebased Greg's patch, I accidentally left the old if block that
was already there.  Remove it.

Fixes: 154d4899e411 ("iwlwifi: mvm: properly check debugfs dentry before using it")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---

I am going to include this patch when I send my next pull request for
v5.1.  This is not so important, but it's simple and clear and will
prevent further merge conflicts later.


drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
index 738eddb2e7ac..6925527d8457 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
@@ -780,12 +780,6 @@ void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 		return;
 	}
 
-	if (!mvmvif->dbgfs_dir) {
-		IWL_ERR(mvm, "Failed to create debugfs directory under %pd\n",
-			dbgfs_dir);
-		return;
-	}
-
 	if (iwlmvm_mod_params.power_scheme != IWL_POWER_SCHEME_CAM &&
 	    ((vif->type == NL80211_IFTYPE_STATION && !vif->p2p) ||
 	     (vif->type == NL80211_IFTYPE_STATION && vif->p2p)))
-- 
2.20.1

