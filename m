Return-Path: <SRS0=xI28=P5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F172C282E6
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 07:50:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CFCA2084A
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 07:50:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728836AbfAUHun (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Jan 2019 02:50:43 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:49102 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728829AbfAUHul (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Jan 2019 02:50:41 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1glULv-0006cr-7d; Mon, 21 Jan 2019 09:50:39 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon, 21 Jan 2019 09:50:19 +0200
Message-Id: <20190121075026.25059-10-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190121075026.25059-1-luca@coelho.fi>
References: <20190121075026.25059-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 09/16] iwlwifi: update hcmds documentation
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Liad Kaufman <liad.kaufman@intel.com>

A few commands refer to a struct that no longer exists
in the mentioned name. Our trace-cmd parsing scripts
rely on these mentioned names and can't find them,
resulting in these commands not being parsed nicely.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/commands.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h b/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h
index 8b4922bbe139..89c0cfddcc3f 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h
@@ -415,7 +415,11 @@ enum iwl_legacy_cmds {
 	TX_ANT_CONFIGURATION_CMD = 0x98,
 
 	/**
-	 * @STATISTICS_CMD: &struct iwl_statistics_cmd
+	 * @STATISTICS_CMD:
+	 * one of &struct iwl_statistics_cmd,
+	 * &struct iwl_notif_statistics_v11,
+	 * &struct iwl_notif_statistics_v10,
+	 * &struct iwl_notif_statistics
 	 */
 	STATISTICS_CMD = 0x9c,
 
@@ -423,7 +427,7 @@ enum iwl_legacy_cmds {
 	 * @STATISTICS_NOTIFICATION:
 	 * one of &struct iwl_notif_statistics_v10,
 	 * &struct iwl_notif_statistics_v11,
-	 * &struct iwl_notif_statistics_cdb
+	 * &struct iwl_notif_statistics
 	 */
 	STATISTICS_NOTIFICATION = 0x9d,
 
-- 
2.20.1

