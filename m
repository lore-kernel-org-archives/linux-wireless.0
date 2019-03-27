Return-Path: <SRS0=A7Z7=R6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8344DC10F00
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 19:19:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 510CA2147C
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 19:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553714359;
	bh=KmERyaP2SScHkgC+FfJ/EX4B148TZzpTex/i/vYfU+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=CX/U7dgSTqpCNAKXFkVo5LkhModEXFBdcmoyisNfWgweL2/e78J1a3X6WKLRKMk2X
	 vSIkzUQVI+8gdL6PYe0e8nVJ9bVAZsJfikc1VKKXOP5YonUkZLY4u/Uiyuhx4Z2JLx
	 c87Wr+fZEQgkI9tWIYSKZblXF7TtE0df7zvGnBOA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388256AbfC0SHu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:07:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:49704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388247AbfC0SHt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Mar 2019 14:07:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A308A2063F;
        Wed, 27 Mar 2019 18:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553710068;
        bh=KmERyaP2SScHkgC+FfJ/EX4B148TZzpTex/i/vYfU+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gFUzrEP3MZx8/WaK27N2zs46MDMbLggk3yrXRwnqp3icrTOCjFdbmEa7rFj8BR7Ub
         98eODEraGHUZ9kMxae5wtM52lAvU5njqX/uZ4/a9vfIWNBMLR6WxF9gIA8PyQC3uNL
         NIVGVsJk5fGUIRpFMW+aQ7kjJ8rinnqMTc+/eWps=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 182/262] iwlwifi: mvm: fix RFH config command with >=10 CPUs
Date:   Wed, 27 Mar 2019 14:00:37 -0400
Message-Id: <20190327180158.10245-182-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327180158.10245-1-sashal@kernel.org>
References: <20190327180158.10245-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit dbf592f3d14fb7d532cb7c820b1065cf33e02aaa ]

If we have >=10 (logical) CPUs, our command size exceeds the
internal buffer size and the command fails; fix that by using
IWL_HCMD_DFL_NOCOPY for the command that's allocated anyway.

While at it, also fix the leak of cmd, and use struct_size()
to calculate its size.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Fixes: 8edbfaa19835 ("iwlwifi: mvm: configure multi RX queue")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 0d6c313b6669..19ec55cef802 100644
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
2.19.1

