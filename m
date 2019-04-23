Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19224C282DD
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 08:50:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E47F420685
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 08:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbfDWIuW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 04:50:22 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:42842 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726033AbfDWIuV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 04:50:21 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hIr87-0000YC-Ja; Tue, 23 Apr 2019 11:50:19 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 2/8] iwlwifi: pcie: remove stray character in iwl_pcie_rx_alloc_page()
Date:   Tue, 23 Apr 2019 11:50:08 +0300
Message-Id: <20190423085014.15390-3-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190423085014.15390-1-luca@coelho.fi>
References: <20190423085014.15390-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

We have a solitary and inconspicous ` in the middle of a comment in
this function, which should not be there.  Remove it.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 413937824764..31b3591f71d1 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -434,7 +434,7 @@ static struct page *iwl_pcie_rx_alloc_page(struct iwl_trans *trans,
 		/*
 		 * Issue an error if we don't have enough pre-allocated
 		  * buffers.
-`		 */
+		 */
 		if (!(gfp_mask & __GFP_NOWARN) && net_ratelimit())
 			IWL_CRIT(trans,
 				 "Failed to alloc_pages\n");
-- 
2.20.1

