Return-Path: <SRS0=IsUp=WP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29400C3A5A0
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Aug 2019 14:35:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0594C20651
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Aug 2019 14:35:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbfHSOfv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 19 Aug 2019 10:35:51 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:36882 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726627AbfHSOfv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Aug 2019 10:35:51 -0400
Received: from [91.156.6.193] (helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hziko-0007sP-Cz; Mon, 19 Aug 2019 17:35:26 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Mon, 19 Aug 2019 17:34:55 +0300
Message-Id: <20190819143507.6989-11-luca@coelho.fi>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190819143507.6989-1-luca@coelho.fi>
References: <20190819143507.6989-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH v2 10/22] iwlwifi: mvm: fix scan config command size
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Beker Ayala <ayala.beker@intel.com>

Use the actual length of channels array and not the max capable length.

Signed-off-by: Beker Ayala <ayala.beker@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index c284e6975b1b..5999b4ebd699 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1205,7 +1205,7 @@ int iwl_mvm_config_scan(struct iwl_mvm *mvm)
 		cmd_size = sizeof(struct iwl_scan_config);
 	else
 		cmd_size = sizeof(struct iwl_scan_config_v1);
-	cmd_size += mvm->fw->ucode_capa.n_scan_channels;
+	cmd_size += num_channels;
 
 	cfg = kzalloc(cmd_size, GFP_KERNEL);
 	if (!cfg)
-- 
2.23.0.rc1

