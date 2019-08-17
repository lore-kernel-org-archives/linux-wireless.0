Return-Path: <SRS0=m094=WN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44BE4C3A59E
	for <linux-wireless@archiver.kernel.org>; Sat, 17 Aug 2019 06:52:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A4842173B
	for <linux-wireless@archiver.kernel.org>; Sat, 17 Aug 2019 06:52:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbfHQGwQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 17 Aug 2019 02:52:16 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:36274 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726075AbfHQGwP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Aug 2019 02:52:15 -0400
Received: from [91.156.6.193] (helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hysZR-0006XT-Uv; Sat, 17 Aug 2019 09:52:14 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Sat, 17 Aug 2019 09:51:41 +0300
Message-Id: <20190817065200.9701-4-luca@coelho.fi>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190817065200.9701-1-luca@coelho.fi>
References: <20190817065200.9701-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 03/22] iwlwifi: mvm: remove redundant condition in iwl_mvm_set_hw_rfkill_state
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

If mvm->fwrt.cur_fw_img != IWL_UCODE_INIT, then
rfkill_safe_init_done must be true since
rfkill_safe_init_done is set to true before we start to load
the runtime image.
Remove the redundant condition.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 4888054dc3d8..722e427d534c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1234,8 +1234,7 @@ static bool iwl_mvm_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state)
 	 * Stop the device if we run OPERATIONAL firmware or if we are in the
 	 * middle of the calibrations.
 	 */
-	return state && (mvm->fwrt.cur_fw_img != IWL_UCODE_INIT ||
-			 rfkill_safe_init_done);
+	return state && rfkill_safe_init_done;
 }
 
 static void iwl_mvm_free_skb(struct iwl_op_mode *op_mode, struct sk_buff *skb)
-- 
2.23.0.rc1

