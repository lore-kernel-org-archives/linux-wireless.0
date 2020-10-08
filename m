Return-Path: <SRS0=Edxh=DP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05DA5C4363C
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Oct 2020 15:10:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B575C20782
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Oct 2020 15:10:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730906AbgJHPKC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Oct 2020 11:10:02 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:54486 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730831AbgJHPKA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Oct 2020 11:10:00 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1kQXYM-002Qut-69; Thu, 08 Oct 2020 18:09:58 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Thu,  8 Oct 2020 18:09:43 +0300
Message-Id: <iwlwifi.20201008180656.c35eeb3299f8.I08f79a6ebe150a7d180b7005b24504bfdba6d8b5@changeid>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201008150949.331882-1-luca@coelho.fi>
References: <20201008150949.331882-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 07/13] iwlwifi: mvm: don't send RFH_QUEUE_CONFIG_CMD with no queues
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

If we have only a single RX queue, such as when MSI-X is not
available, we should not send the RFH_QUEUEU_CONFIG_CMD, because our
only queue is the same as the command queue and will be configured as
part of the context info.  Our code was actually trying to send the
command with 0 queues, which caused UMAC assert 0x1D04.

Fix that by not sending the command when we have a single queue.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index a8a10f84f45d..e665596a4d83 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -133,7 +133,14 @@ static int iwl_configure_rxq(struct iwl_mvm *mvm)
 		.dataflags[0] = IWL_HCMD_DFL_NOCOPY,
 	};
 
-	/* Do not configure default queue, it is configured via context info */
+	/*
+	 * The default queue is configured via context info, so if we
+	 * have a single queue, there's nothing to do here.
+	 */
+	if (mvm->trans->num_rx_queues == 1)
+		return 0;
+
+	/* skip the default queue */
 	num_queues = mvm->trans->num_rx_queues - 1;
 
 	size = struct_size(cmd, data, num_queues);
-- 
2.28.0

