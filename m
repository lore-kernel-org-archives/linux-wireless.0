Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3992EC433E0
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Feb 2021 15:24:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE03064E9A
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Feb 2021 15:24:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbhBJPY6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Feb 2021 10:24:58 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:45354 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231362AbhBJPYs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Feb 2021 10:24:48 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1l9rLS-0049nr-SV; Wed, 10 Feb 2021 17:23:59 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Wed, 10 Feb 2021 17:23:51 +0200
Message-Id: <iwlwifi.20210210172142.f71c99f461ff.If32fe0afed277ec99ba0d7e2615c27a8a80a0d29@changeid>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210210152355.419776-1-luca@coelho.fi>
References: <20210210152355.419776-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 4/8] iwlwifi: pcie: define FW_RESET_TIMEOUT for clarity
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Matti Gottlieb <matti.gottlieb@intel.com>

Move fw reset timeout to a FW_RESET_TIMEOUT macro
for better readability.

Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
index 0e55aacd6175..497ef3405da3 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -10,6 +10,8 @@
 #include "internal.h"
 #include "fw/dbg.h"
 
+#define FW_RESET_TIMEOUT (HZ / 5)
+
 /*
  * Start up NIC's basic functionality after it has been reset
  * (e.g. after platform boot, or shutdown via iwl_pcie_apm_stop())
@@ -104,7 +106,7 @@ static void iwl_trans_pcie_fw_reset_handshake(struct iwl_trans *trans)
 
 	/* wait 200ms */
 	ret = wait_event_timeout(trans_pcie->fw_reset_waitq,
-				 trans_pcie->fw_reset_done, HZ / 5);
+				 trans_pcie->fw_reset_done, FW_RESET_TIMEOUT);
 	if (!ret)
 		IWL_ERR(trans,
 			"firmware didn't ACK the reset - continue anyway\n");
-- 
2.30.0

