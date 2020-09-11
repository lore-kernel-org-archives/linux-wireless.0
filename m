Return-Path: <SRS0=g1I5=CU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86859C433E2
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Sep 2020 17:54:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55B7E221EB
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Sep 2020 17:54:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725841AbgIKRyt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 11 Sep 2020 13:54:49 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:50260 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726054AbgIKRyq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Sep 2020 13:54:46 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1kGn6N-0028eU-W5; Fri, 11 Sep 2020 20:44:48 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 11 Sep 2020 20:44:36 +0300
Message-Id: <iwlwifi.20200911204056.33b55b3ca440.Ib0202c7011d8d0e09f55fcceceb9d3d5051631c6@changeid>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911174439.163225-1-luca@coelho.fi>
References: <20200911174439.163225-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 08/11] iwlwifi: wowlan: adapt to wowlan status API version 10
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

In version 10 we actually go back to the struct size before 9
so only for version 9 we need the size fixup

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 2a94545d737f..bcdd2b376ce5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1592,7 +1592,8 @@ struct iwl_wowlan_status *iwl_mvm_send_wowlan_get_status(struct iwl_mvm *mvm)
 
 	status_size = sizeof(*status);
 
-	if (notif_ver == IWL_FW_CMD_VER_UNKNOWN || notif_ver < 9)
+	/* only ver 9 has a different size */
+	if (notif_ver == IWL_FW_CMD_VER_UNKNOWN || notif_ver != 9)
 		status_size = sizeof(*v7);
 
 	if (len < status_size) {
-- 
2.28.0

