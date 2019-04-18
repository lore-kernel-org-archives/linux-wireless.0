Return-Path: <SRS0=x8ok=SU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58CE3C282DD
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 12:16:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B31D21872
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 12:16:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388923AbfDRMQA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Apr 2019 08:16:00 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:53952 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388864AbfDRMQA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Apr 2019 08:16:00 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1hH5xH-0007X3-NK; Thu, 18 Apr 2019 15:15:53 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laura Abbott <labbott@redhat.com>,
        Gabriel Ramirez <gabriello.ramirez@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        stable <stable@vger.kernel.org>
Date:   Thu, 18 Apr 2019 15:15:43 +0300
Message-Id: <20190418121544.32040-4-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190418121544.32040-1-luca@coelho.fi>
References: <20190418121544.32040-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 3/4] iwlwifi: mvm: properly check debugfs dentry before using it
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

debugfs can now report an error code if something went wrong instead of
just NULL.  So if the return value is to be used as a "real" dentry, it
needs to be checked if it is an error before dereferencing it.

This is now happening because of ff9fb72bc077 ("debugfs: return error
values, not NULL").  If multiple iwlwifi devices are in the system, this
can cause problems when the driver attempts to create the main debugfs
directory again.  Later on in the code we fail horribly by trying to
dereference a pointer that is an error value.

Reported-by: Laura Abbott <labbott@redhat.com>
Reported-by: Gabriel Ramirez <gabriello.ramirez@gmail.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: Intel Linux Wireless <linuxwifi@intel.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: stable <stable@vger.kernel.org> # 5.0
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
index 2453ceabf00d..738eddb2e7ac 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
@@ -774,6 +774,11 @@ void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 		return;
 
 	mvmvif->dbgfs_dir = debugfs_create_dir("iwlmvm", dbgfs_dir);
+	if (IS_ERR_OR_NULL(mvmvif->dbgfs_dir)) {
+		IWL_ERR(mvm, "Failed to create debugfs directory under %pd\n",
+			dbgfs_dir);
+		return;
+	}
 
 	if (!mvmvif->dbgfs_dir) {
 		IWL_ERR(mvm, "Failed to create debugfs directory under %pd\n",
-- 
2.20.1

