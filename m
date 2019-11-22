Return-Path: <SRS0=Y0IC=ZO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A2ECC432C0
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Nov 2019 06:28:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E2BE2070A
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Nov 2019 06:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574404089;
	bh=5S+2wx5oqUm03lHamCIcP+kMhEIrkazAtB5eG8VlA4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Na9aHptUawXYkMnI8Qs+yhGYhJ7/5JXb/B2HlLEL70wiyBJIJlj0cMWlixQeg71DW
	 TV9WeipJfA8uGHgzGZc6+nimKh5QY9HeruSjeL7z27Id9l1jdDak2VeekQuMqwbsRH
	 A6kNs7f1EbHhCiT9rM+hROMf2E5GtLxsu0QqYfHo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbfKVG2E (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Nov 2019 01:28:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:54796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727584AbfKVFuS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Nov 2019 00:50:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7B9520731;
        Fri, 22 Nov 2019 05:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401817;
        bh=5S+2wx5oqUm03lHamCIcP+kMhEIrkazAtB5eG8VlA4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oJ+Njb5zHmJKTJkIRt3KvXk6AXvX7LmSUnEu8urFQJ8qMhY6o0KSFfQAGVSJlxJLc
         9YsJA4USi1IinBOOHQKvaVDbi+48kUCwSvLTdlaoRDYGvvXYJ3L0OF5QBHQ78PlvqU
         fBfYz60Pac/0KEZ+l5ByXRw5ttnPP6VWiP7goIa8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 061/219] iwlwifi: pcie: fix erroneous print
Date:   Fri, 22 Nov 2019 00:46:33 -0500
Message-Id: <20191122054911.1750-54-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

[ Upstream commit 0916224eaa77bff0fbbc747961d550ff8db45457 ]

When removing the driver, the following flow can happen:
1. host command is in progress, for example at index 68.
2. RX interrupt is received with the response.
3. Before it is processed, the remove flow kicks in, and
   calls iwl_pcie_txq_unmap. The function cleans all DMA,
   and promotes the read pointer to 69.
4. RX thread proceeds with the processing, and is calling
   iwl_pcie_cmdq_reclaim, which will print this error:
   iwl_pcie_cmdq_reclaim: Read index for DMA queue txq id (0),
   index 4 is out of range [0-256] 69 69.

Detect this situation, and avoid the print. Change it to
warning while at it, to make such issues more noticeable
in the future.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 42fdb7970cfdc..7cba4c37c66fd 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1247,11 +1247,11 @@ static void iwl_pcie_cmdq_reclaim(struct iwl_trans *trans, int txq_id, int idx)
 
 	if (idx >= trans->cfg->base_params->max_tfd_queue_size ||
 	    (!iwl_queue_used(txq, idx))) {
-		IWL_ERR(trans,
-			"%s: Read index for DMA queue txq id (%d), index %d is out of range [0-%d] %d %d.\n",
-			__func__, txq_id, idx,
-			trans->cfg->base_params->max_tfd_queue_size,
-			txq->write_ptr, txq->read_ptr);
+		WARN_ONCE(test_bit(txq_id, trans_pcie->queue_used),
+			  "%s: Read index for DMA queue txq id (%d), index %d is out of range [0-%d] %d %d.\n",
+			  __func__, txq_id, idx,
+			  trans->cfg->base_params->max_tfd_queue_size,
+			  txq->write_ptr, txq->read_ptr);
 		return;
 	}
 
-- 
2.20.1

