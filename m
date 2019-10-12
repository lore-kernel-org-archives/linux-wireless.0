Return-Path: <SRS0=gYjh=YF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 823D4C4360C
	for <linux-wireless@archiver.kernel.org>; Sat, 12 Oct 2019 16:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66FD12087E
	for <linux-wireless@archiver.kernel.org>; Sat, 12 Oct 2019 16:29:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729435AbfJLQ3f (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 12 Oct 2019 12:29:35 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:48762 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728338AbfJLQ3f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 12 Oct 2019 12:29:35 -0400
Received: from [91.156.6.193] (helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1iJKGr-00062r-7f; Sat, 12 Oct 2019 19:29:33 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Sat, 12 Oct 2019 19:29:16 +0300
Message-Id: <20191012192536.797f1ede5077.Ice818674f107105ae05a6f561263c0896d49de2c@changeid>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191012162924.19848-1-luca@coelho.fi>
References: <20191012162924.19848-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 05/13] iwlwifi: dbg: prefer struct copy to memcpy()
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

ifxes=Ic930239af4832ecb04afbf92840c99dfd726eebe

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index cc4627d27602..ce77ed17ede0 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -2379,8 +2379,7 @@ int iwl_fw_dbg_ini_collect(struct iwl_fw_runtime *fwrt,
 	    test_and_set_bit(fwrt->dump.wks[idx].idx, &fwrt->dump.active_wks))
 		return -EBUSY;
 
-	memcpy(&fwrt->dump.wks[idx].dump_data, dump_data,
-	       sizeof(fwrt->dump.wks[idx].dump_data));
+	fwrt->dump.wks[idx].dump_data = *dump_data;
 
 	IWL_WARN(fwrt, "WRT: Collecting data: ini trigger %d fired.\n", tp_id);
 
-- 
2.23.0

