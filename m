Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E28D5C282D7
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 12:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B593520882
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 12:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbfA3MiV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 07:38:21 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:52890 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725768AbfA3MiU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 07:38:20 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gop8E-00042N-Ki; Wed, 30 Jan 2019 14:38:19 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed, 30 Jan 2019 14:38:11 +0200
Message-Id: <20190130123811.26839-1-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <57b89f3bd6db01fa84f59c1e07f919853af636fe.camel@coelho.fi>
References: <57b89f3bd6db01fa84f59c1e07f919853af636fe.camel@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH] iwlwifi: mvm: fix merge damage in iwl_mvm_rx_mpdu_mq()
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

A call to iwl_mvm_add_rtap_sniffer_config() was missing due to a merge
damage when I submitted the patch mentioned below.  And this causes
the following compilation warning:

drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c:195:13: warning: 'iwl_mvm_add_rtap_sniffer_config' defined but not used [-Wunused-function]
 static void iwl_mvm_add_rtap_sniffer_config(struct iwl_mvm *mvm,
             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fix it by adding the if block that calls this function.

Fixes: 9bf13bee2d74 ("iwlwifi: mvm: include configured sniffer AID in radiotap")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 995847e1cd7d..b5ff3325c1d3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -1476,6 +1476,9 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 		rx_status->ampdu_reference = mvm->ampdu_ref;
 	}
 
+	if (unlikely(mvm->monitor_on))
+		iwl_mvm_add_rtap_sniffer_config(mvm, skb);
+
 	rcu_read_lock();
 
 	if (desc->status & cpu_to_le16(IWL_RX_MPDU_STATUS_SRC_STA_FOUND)) {
-- 
2.20.1

