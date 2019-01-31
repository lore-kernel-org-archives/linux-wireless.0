Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3580C169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:23:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAE18218AF
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:23:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbfAaUXB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 15:23:01 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:53694 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727435AbfAaUXA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 15:23:00 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gpIr1-0004pL-6v; Thu, 31 Jan 2019 22:22:31 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Thu, 31 Jan 2019 22:22:05 +0200
Message-Id: <20190131202206.15903-21-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190131202206.15903-1-luca@coelho.fi>
References: <20190131202206.15903-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 20/21] iwlwifi: mvm: fix RFH config command with >=10 CPUs
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

If we have >=10 (logical) CPUs, our command size exceeds the
internal buffer size and the command fails; fix that by using
IWL_HCMD_DFL_NOCOPY for the command that's allocated anyway.

While at it, also fix the leak of cmd, and use struct_size()
to calculate its size.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Fixes: 8edbfaa19835 ("iwlwifi: mvm: configure multi RX queue")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 134dab2d774a..8140b193cc05 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -127,13 +127,17 @@ static int iwl_send_rss_cfg_cmd(struct iwl_mvm *mvm)
 
 static int iwl_configure_rxq(struct iwl_mvm *mvm)
 {
-	int i, num_queues, size;
+	int i, num_queues, size, ret;
 	struct iwl_rfh_queue_config *cmd;
+	struct iwl_host_cmd hcmd = {
+		.id = WIDE_ID(DATA_PATH_GROUP, RFH_QUEUE_CONFIG_CMD),
+		.dataflags[0] = IWL_HCMD_DFL_NOCOPY,
+	};
 
 	/* Do not configure default queue, it is configured via context info */
 	num_queues = mvm->trans->num_rx_queues - 1;
 
-	size = sizeof(*cmd) + num_queues * sizeof(struct iwl_rfh_queue_data);
+	size = struct_size(cmd, data, num_queues);
 
 	cmd = kzalloc(size, GFP_KERNEL);
 	if (!cmd)
@@ -154,10 +158,14 @@ static int iwl_configure_rxq(struct iwl_mvm *mvm)
 		cmd->data[i].fr_bd_wid = cpu_to_le32(data.fr_bd_wid);
 	}
 
-	return iwl_mvm_send_cmd_pdu(mvm,
-				    WIDE_ID(DATA_PATH_GROUP,
-					    RFH_QUEUE_CONFIG_CMD),
-				    0, size, cmd);
+	hcmd.data[0] = cmd;
+	hcmd.len[0] = size;
+
+	ret = iwl_mvm_send_cmd(mvm, &hcmd);
+
+	kfree(cmd);
+
+	return ret;
 }
 
 static int iwl_mvm_send_dqa_cmd(struct iwl_mvm *mvm)
-- 
2.20.1

