Return-Path: <SRS0=W7N3=2K=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DCE4C43603
	for <linux-wireless@archiver.kernel.org>; Fri, 20 Dec 2019 11:56:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23ED524679
	for <linux-wireless@archiver.kernel.org>; Fri, 20 Dec 2019 11:56:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbfLTL4v (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 20 Dec 2019 06:56:51 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:53986 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727177AbfLTL4v (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Dec 2019 06:56:51 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <luca@coelho.fi>)
        id 1iiGtl-0007ip-62; Fri, 20 Dec 2019 13:56:49 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 20 Dec 2019 13:56:34 +0200
Message-Id: <20191220115638.1299888-7-luca@coelho.fi>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191220115638.1299888-1-luca@coelho.fi>
References: <20191220115638.1299888-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH v5.5 06/10] iwlwifi: fix TLV fragment allocation loop
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

In the allocation loop, "pages" will never become zero (because of the
DIV_ROUND_UP), so if we can't allocate any size and pages becomes 1,
we will keep trying to allocate 1 page until it succeeds.  And in that
case, as coverity reported, block will never be NULL.

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1487402 ("Control flow issues")
Fixes: 14124b25780d ("iwlwifi: dbg_ini: implement monitor allocation flow")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Fixes: 14124b25780d ("iwlwifi: dbg_ini: implement monitor allocation flow")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index f266647dc08c..ce8f248c33ea 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -480,7 +480,14 @@ static int iwl_dbg_tlv_alloc_fragment(struct iwl_fw_runtime *fwrt,
 	if (!frag || frag->size || !pages)
 		return -EIO;
 
-	while (pages) {
+	/*
+	 * We try to allocate as many pages as we can, starting with
+	 * the requested amount and going down until we can allocate
+	 * something.  Because of DIV_ROUND_UP(), pages will never go
+	 * down to 0 and stop the loop, so stop when pages reaches 1,
+	 * which is too small anyway.
+	 */
+	while (pages > 1) {
 		block = dma_alloc_coherent(fwrt->dev, pages * PAGE_SIZE,
 					   &physical,
 					   GFP_KERNEL | __GFP_NOWARN);
-- 
2.24.0

