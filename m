Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CC8EC4360F
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:49:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46CCF21929
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:49:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436514AbfBOLtf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 06:49:35 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:60384 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727457AbfBOLte (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 06:49:34 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gubzn-0008TN-RE; Fri, 15 Feb 2019 13:49:32 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 15 Feb 2019 13:49:07 +0200
Message-Id: <20190215114924.2545-4-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190215114924.2545-1-luca@coelho.fi>
References: <20190215114924.2545-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 03/20] iwlwifi: fix false-positive maybe-uninitialized warning
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

With CONFIG_NO_AUTO_INLINE, we run into a silly warning when
gcc fails to remember that n_profiles is constant across
the function call to iwl_mvm_sar_set_profile:

drivers/net/wireless/intel/iwlwifi/mvm/fw.c: In function 'iwl_mvm_sar_get_ewrd_table':
drivers/net/wireless/intel/iwlwifi/mvm/fw.c:746:9: error: 'ret' may be used uninitialized in this function [-Werror=maybe-uninitialized]

Marking that function 'inline' avoids the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 1bc51e3260eb..00a47f6f1d81 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -646,10 +646,10 @@ static int iwl_mvm_config_ltr(struct iwl_mvm *mvm)
 }
 
 #ifdef CONFIG_ACPI
-static int iwl_mvm_sar_set_profile(struct iwl_mvm *mvm,
-				   union acpi_object *table,
-				   struct iwl_mvm_sar_profile *profile,
-				   bool enabled)
+static inline int iwl_mvm_sar_set_profile(struct iwl_mvm *mvm,
+					  union acpi_object *table,
+					  struct iwl_mvm_sar_profile *profile,
+					  bool enabled)
 {
 	int i;
 
-- 
2.20.1

