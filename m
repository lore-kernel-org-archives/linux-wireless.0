Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B36B8C282CC
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 22:36:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80B962173B
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 22:36:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfBGWgk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 17:36:40 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:56568 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726642AbfBGWgj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 17:36:39 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1grsHd-0002II-QR; Fri, 08 Feb 2019 00:36:38 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  8 Feb 2019 00:36:08 +0200
Message-Id: <20190207223622.9642-4-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190207223622.9642-1-luca@coelho.fi>
References: <20190207223622.9642-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 03/17] iwlwifi: dvm: don't use IWL_DL_FW_ERRORS
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Use IWL_DL_FW instead. This will free a bit for more
needed prints in newer devices.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/main.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/main.c b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
index bd3c3b921d4c..114f0ab022a7 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -1881,7 +1881,7 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 		return pos;
 	}
 
-	if (!(iwl_have_debug_level(IWL_DL_FW_ERRORS)) && !full_log)
+	if (!(iwl_have_debug_level(IWL_DL_FW)) && !full_log)
 		size = (size > DEFAULT_DUMP_EVENT_LOG_ENTRIES)
 			? DEFAULT_DUMP_EVENT_LOG_ENTRIES : size;
 	IWL_ERR(priv, "Start IWL Event Log Dump: display last %u entries\n",
@@ -1897,7 +1897,7 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 		if (!*buf)
 			return -ENOMEM;
 	}
-	if (iwl_have_debug_level(IWL_DL_FW_ERRORS) || full_log) {
+	if (iwl_have_debug_level(IWL_DL_FW) || full_log) {
 		/*
 		 * if uCode has wrapped back to top of log,
 		 * start at the oldest entry,
@@ -1927,7 +1927,7 @@ static void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
 	unsigned int reload_msec;
 	unsigned long reload_jiffies;
 
-	if (iwl_have_debug_level(IWL_DL_FW_ERRORS))
+	if (iwl_have_debug_level(IWL_DL_FW))
 		iwl_print_rx_config_cmd(priv, IWL_RXON_CTX_BSS);
 
 	/* uCode is no longer loaded. */
@@ -1965,12 +1965,12 @@ static void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
 
 	if (!test_bit(STATUS_EXIT_PENDING, &priv->status)) {
 		if (iwlwifi_mod_params.fw_restart) {
-			IWL_DEBUG_FW_ERRORS(priv,
-				  "Restarting adapter due to uCode error.\n");
+			IWL_DEBUG_FW(priv,
+				     "Restarting adapter due to uCode error.\n");
 			queue_work(priv->workqueue, &priv->restart);
 		} else
-			IWL_DEBUG_FW_ERRORS(priv,
-				  "Detected FW error, but not restarting\n");
+			IWL_DEBUG_FW(priv,
+				     "Detected FW error, but not restarting\n");
 	}
 }
 
-- 
2.20.1

