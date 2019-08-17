Return-Path: <SRS0=m094=WN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1977EC3A59F
	for <linux-wireless@archiver.kernel.org>; Sat, 17 Aug 2019 06:52:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3B7021019
	for <linux-wireless@archiver.kernel.org>; Sat, 17 Aug 2019 06:52:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbfHQGwP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 17 Aug 2019 02:52:15 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:36268 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725988AbfHQGwP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Aug 2019 02:52:15 -0400
Received: from [91.156.6.193] (helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hysZR-0006XT-7a; Sat, 17 Aug 2019 09:52:13 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Sat, 17 Aug 2019 09:51:40 +0300
Message-Id: <20190817065200.9701-3-luca@coelho.fi>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190817065200.9701-1-luca@coelho.fi>
References: <20190817065200.9701-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 02/22] iwlwifi: Send DQA enable command only if TVL is on
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ilia Lin <ilia.lin@intel.com>

The newer targets don't support the DQA enablement command
and will return error status, while older targets need it.
The feature is defined by the corresponding TLV.
Send the command only if the TLV is enabled.

Signed-off-by: Ilia Lin <ilia.lin@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 5de54d1559dd..a57fc6198a72 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1246,9 +1246,11 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	/* reset quota debouncing buffer - 0xff will yield invalid data */
 	memset(&mvm->last_quota_cmd, 0xff, sizeof(mvm->last_quota_cmd));
 
-	ret = iwl_mvm_send_dqa_cmd(mvm);
-	if (ret)
-		goto error;
+	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_DQA_SUPPORT)) {
+		ret = iwl_mvm_send_dqa_cmd(mvm);
+		if (ret)
+			goto error;
+	}
 
 	/* Add auxiliary station for scanning */
 	ret = iwl_mvm_add_aux_sta(mvm);
-- 
2.23.0.rc1

