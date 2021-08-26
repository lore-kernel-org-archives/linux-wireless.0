Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A768C432BE
	for <linux-wireless@archiver.kernel.org>; Thu, 26 Aug 2021 19:47:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C12960F11
	for <linux-wireless@archiver.kernel.org>; Thu, 26 Aug 2021 19:47:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243575AbhHZTso (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 26 Aug 2021 15:48:44 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:33424 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S243567AbhHZTsn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Aug 2021 15:48:43 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=kveik.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <luca@coelho.fi>)
        id 1mJLLs-002XB4-JY; Thu, 26 Aug 2021 22:47:54 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     luca@coelho.fi, linux-wireless@vger.kernel.org
Date:   Thu, 26 Aug 2021 22:47:39 +0300
Message-Id: <iwlwifi.20210826224715.7d2dd18c75a2.I3652584755b9ab44909ddcd09ff4d80c6690a1ad@changeid>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210826194748.826360-1-luca@coelho.fi>
References: <20210826194748.826360-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH v2 03/12] iwlwifi: move get pnvm file name to a separate function
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Dror Moshe <drorx.moshe@intel.com>

Move code that generates the pnvm file name to a separate function,
so that it can be reused.

Signed-off-by: Dror Moshe <drorx.moshe@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c | 13 ++-----------
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.h | 20 ++++++++++++++++++++
 2 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
index 1de30bae7829..bbd8c31cbbec 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
@@ -223,19 +223,10 @@ static int iwl_pnvm_parse(struct iwl_trans *trans, const u8 *data,
 static int iwl_pnvm_get_from_fs(struct iwl_trans *trans, u8 **data, size_t *len)
 {
 	const struct firmware *pnvm;
-	char pnvm_name[64];
+	char pnvm_name[MAX_PNVM_NAME];
 	int ret;
 
-	/*
-	 * The prefix unfortunately includes a hyphen at the end, so
-	 * don't add the dot here...
-	 */
-	snprintf(pnvm_name, sizeof(pnvm_name), "%spnvm",
-		 trans->cfg->fw_name_pre);
-
-	/* ...but replace the hyphen with the dot here. */
-	if (strlen(trans->cfg->fw_name_pre) < sizeof(pnvm_name))
-		pnvm_name[strlen(trans->cfg->fw_name_pre) - 1] = '.';
+	iwl_pnvm_get_fs_name(trans, pnvm_name, sizeof(pnvm_name));
 
 	ret = firmware_request_nowarn(&pnvm, pnvm_name, trans->dev);
 	if (ret) {
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.h b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.h
index 61d3d4e0b7d9..203c367dd4de 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.h
@@ -12,7 +12,27 @@
 
 #define MVM_UCODE_PNVM_TIMEOUT	(HZ / 4)
 
+#define MAX_PNVM_NAME  64
+
 int iwl_pnvm_load(struct iwl_trans *trans,
 		  struct iwl_notif_wait_data *notif_wait);
 
+static inline
+void iwl_pnvm_get_fs_name(struct iwl_trans *trans,
+			  u8 *pnvm_name, size_t max_len)
+{
+	int pre_len;
+
+	/*
+	 * The prefix unfortunately includes a hyphen at the end, so
+	 * don't add the dot here...
+	 */
+	snprintf(pnvm_name, max_len, "%spnvm", trans->cfg->fw_name_pre);
+
+	/* ...but replace the hyphen with the dot here. */
+	pre_len = strlen(trans->cfg->fw_name_pre);
+	if (pre_len < max_len && pre_len > 0)
+		pnvm_name[pre_len - 1] = '.';
+}
+
 #endif /* __IWL_PNVM_H__ */
-- 
2.33.0

