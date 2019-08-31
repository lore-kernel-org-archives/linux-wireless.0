Return-Path: <SRS0=rkzg=W3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60DD8C3A59F
	for <linux-wireless@archiver.kernel.org>; Sat, 31 Aug 2019 09:49:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 418EB22CE9
	for <linux-wireless@archiver.kernel.org>; Sat, 31 Aug 2019 09:49:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbfHaJtH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 31 Aug 2019 05:49:07 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:39628 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726354AbfHaJtH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 31 Aug 2019 05:49:07 -0400
Received: from [91.156.6.193] (helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1i400H-0002OQ-CN; Sat, 31 Aug 2019 12:49:05 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Sat, 31 Aug 2019 12:48:41 +0300
Message-Id: <20190831094859.6391-2-luca@coelho.fi>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190831094859.6391-1-luca@coelho.fi>
References: <20190831094859.6391-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 01/19] iwlwifi: stop passing bogus gfp flags arguments to dma_alloc_coherent
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

dma_alloc_coherent is not just the page allocator.  The only valid
arguments to pass are either GFP_ATOMIC or GFP_ATOMIC with possible
modifiers of __GFP_NORETRY or __GFP_NOWARN.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c     | 3 +--
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 1aa880936121..f52427ec60e9 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -2485,8 +2485,7 @@ iwl_fw_dbg_buffer_allocation(struct iwl_fw_runtime *fwrt, u32 size)
 
 	virtual_addr =
 		dma_alloc_coherent(fwrt->trans->dev, size, &phys_addr,
-				   GFP_KERNEL | __GFP_NOWARN | __GFP_ZERO |
-				   __GFP_COMP);
+				   GFP_KERNEL | __GFP_NOWARN);
 
 	/* TODO: alloc fragments if needed */
 	if (!virtual_addr)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 0972ef064514..48a209708852 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -215,8 +215,7 @@ static void iwl_pcie_alloc_fw_monitor_block(struct iwl_trans *trans,
 	for (power = max_power; power >= min_power; power--) {
 		size = BIT(power);
 		cpu_addr = dma_alloc_coherent(trans->dev, size, &phys,
-					      GFP_KERNEL | __GFP_NOWARN |
-					      __GFP_ZERO | __GFP_COMP);
+					      GFP_KERNEL | __GFP_NOWARN);
 		if (!cpu_addr)
 			continue;
 
-- 
2.23.0.rc1

