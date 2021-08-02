Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB2AC4338F
	for <linux-wireless@archiver.kernel.org>; Mon,  2 Aug 2021 14:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B68D460555
	for <linux-wireless@archiver.kernel.org>; Mon,  2 Aug 2021 14:18:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234506AbhHBOSv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 2 Aug 2021 10:18:51 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:50856 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S234806AbhHBOSb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Aug 2021 10:18:31 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=kveik.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <luca@coelho.fi>)
        id 1mAYdX-001xoA-Ub; Mon, 02 Aug 2021 17:09:49 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     luca@coelho.fi, linux-wireless@vger.kernel.org
Date:   Mon,  2 Aug 2021 17:09:36 +0300
Message-Id: <iwlwifi.20210802170640.43a7351ae6bd.I164d48ce4379accf76ea0637983fd946d52dc6f5@changeid>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802140944.90143-1-luca@coelho.fi>
References: <20210802140944.90143-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 04/12] iwlwifi: mvm: avoid FW restart while shutting down
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

If the firmware crashes while we're already shutting down
the system, there isn't much we can do since the shutdown
process is continuing and we wanted to do that. Don't do
a FW restart, with the implied debug collection, in this
case.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 20e8d343a950..1f43079f02af 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1466,6 +1466,14 @@ static void iwl_mvm_nic_error(struct iwl_op_mode *op_mode)
 	if (!test_bit(STATUS_TRANS_DEAD, &mvm->trans->status))
 		iwl_mvm_dump_nic_error_log(mvm);
 
+	/*
+	 * If the firmware crashes while we're already considering it
+	 * to be dead then don't ask for a restart, that cannot do
+	 * anything useful anyway.
+	 */
+	if (!test_bit(IWL_MVM_STATUS_FIRMWARE_RUNNING, &mvm->status))
+		return;
+
 	iwl_mvm_nic_restart(mvm, true);
 }
 
-- 
2.32.0

