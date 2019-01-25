Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1AB0C282C0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 20:13:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80DA7218B0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 20:13:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728732AbfAYUNR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 15:13:17 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:50790 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726895AbfAYUNQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 15:13:16 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gn7ql-00010a-0C; Fri, 25 Jan 2019 22:13:15 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 25 Jan 2019 22:12:53 +0200
Message-Id: <20190125201305.5616-6-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190125201305.5616-1-luca@coelho.fi>
References: <20190125201305.5616-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 05/17] iwlwifi: mvm: fix %16 to %016 print format
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

With just %16, it means 16 characters padding, but we really
don't want to print "0x         1F4547B", but instead want to
have this filled with zeroes, so we need the 0.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 11714eb8da5e..b1d6dea7672e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1345,7 +1345,7 @@ void iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
 	agg_status = iwl_mvm_get_agg_status(mvm, beacon_notify_hdr);
 	status = le16_to_cpu(agg_status->status) & TX_STATUS_MSK;
 	IWL_DEBUG_RX(mvm,
-		     "beacon status %#x retries:%d tsf:0x%16llX gp2:0x%X rate:%d\n",
+		     "beacon status %#x retries:%d tsf:0x%016llX gp2:0x%X rate:%d\n",
 		     status, beacon_notify_hdr->failure_frame,
 		     le64_to_cpu(beacon->tsf),
 		     mvm->ap_last_beacon_gp2,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index e8659bf50890..5dbbd35ee630 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -248,7 +248,7 @@ void iwl_mvm_rx_fw_error(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 	IWL_ERR(mvm, "FW Error notification: seq 0x%04X service 0x%08X\n",
 		le16_to_cpu(err_resp->bad_cmd_seq_num),
 		le32_to_cpu(err_resp->error_service));
-	IWL_ERR(mvm, "FW Error notification: timestamp 0x%16llX\n",
+	IWL_ERR(mvm, "FW Error notification: timestamp 0x%016llX\n",
 		le64_to_cpu(err_resp->timestamp));
 }
 
-- 
2.20.1

