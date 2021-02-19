Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FAE8C433E9
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Feb 2021 12:36:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD5D464E77
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Feb 2021 12:36:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbhBSMgF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 19 Feb 2021 07:36:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbhBSMf5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Feb 2021 07:35:57 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F60CC061786
        for <linux-wireless@vger.kernel.org>; Fri, 19 Feb 2021 04:35:15 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lD504-005NkP-9k; Fri, 19 Feb 2021 13:35:12 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Andy Lavr <andy.lavr@gmail.com>
Subject: [PATCH] iwlwifi: avoid crash on unsupported debug collection
Date:   Fri, 19 Feb 2021 13:35:07 +0100
Message-Id: <20210219133506.ecabe285bc7d.I73d230d555c595fa2d9bf284f80078729fe18aa4@changeid>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

If the opmode doesn't support debug collection (DVM) then don't
crash, but just skip the callback.

Fixes: d01293154c0a ("iwlwifi: dbg: add op_mode callback for collecting debug data.")
Reported-by: Andy Lavr <andy.lavr@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h
index 868da7e79a45..e6d2e0994317 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h
@@ -205,6 +205,8 @@ static inline void iwl_op_mode_time_point(struct iwl_op_mode *op_mode,
 					  enum iwl_fw_ini_time_point tp_id,
 					  union iwl_dbg_tlv_tp_data *tp_data)
 {
+	if (!op_mode || !op_mode->ops || !op_mode->ops->time_point)
+		return;
 	op_mode->ops->time_point(op_mode, tp_id, tp_data);
 }
 
-- 
2.26.2

