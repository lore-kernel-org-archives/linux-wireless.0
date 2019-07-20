Return-Path: <SRS0=56nJ=VR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E577DC76195
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Jul 2019 10:26:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4CBE2084D
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Jul 2019 10:26:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbfGTK0O (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 20 Jul 2019 06:26:14 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:59496 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727830AbfGTK0N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 Jul 2019 06:26:13 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1homZ9-0000Hj-It; Sat, 20 Jul 2019 13:26:12 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sat, 20 Jul 2019 13:25:37 +0300
Message-Id: <20190720102545.5952-9-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190720102545.5952-1-luca@coelho.fi>
References: <20190720102545.5952-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 08/16] iwlwifi: dbg_ini: move iwl_dbg_tlv_free outside of debugfs ifdef
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

The driver should call iwl_dbg_tlv_free even if debugfs is not defined
since ini mode does not depend on debugfs ifdef.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Fixes: 68f6f492c4fa ("iwlwifi: trans: support loading ini TLVs from external file")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index d91686b9a540..38672dd5aae9 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1662,8 +1662,8 @@ struct iwl_drv *iwl_drv_start(struct iwl_trans *trans)
 err_fw:
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	debugfs_remove_recursive(drv->dbgfs_drv);
-	iwl_fw_dbg_free(drv->trans);
 #endif
+	iwl_fw_dbg_free(drv->trans);
 	kfree(drv);
 err:
 	return ERR_PTR(ret);
-- 
2.20.1

