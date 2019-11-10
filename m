Return-Path: <SRS0=Jrqb=ZC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C88C6C43331
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Nov 2019 03:08:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9414421848
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Nov 2019 03:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573355319;
	bh=anNXDwU1QQ1P75e5uA1Vk4W6iUlx6TtteWrqSceTEdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=0b9BZg3wAtArKvkQ3+p3rk3aIOUKNv4fWXUz5skmSQT12n1k0FVTyUrG06Zh7Oa+q
	 yFMTBz4Sal4Y1UUS4YJ3ePKO2ZvT9yjGfItm2xNCtIkdGTmKnjw5DPJ7vAuFWENn3M
	 6GfxzrJPCDR0+6/ASXIK3nGg+yvljfp5zqheWS9A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728835AbfKJDIf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Nov 2019 22:08:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:45380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728696AbfKJCo4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Nov 2019 21:44:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A84021848;
        Sun, 10 Nov 2019 02:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353896;
        bh=anNXDwU1QQ1P75e5uA1Vk4W6iUlx6TtteWrqSceTEdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IvglQsbZYz2CMiOvT2sCYeK2APhcjYm8Et9fOUwK+jjk/MiE5IWLzoSbcJSh80u7j
         LVZtWD52rPLHAXGW6DcPN1S1wdxPi7htcN9UAd9TgE0jKBTX2maX9wqAOg687H1j04
         P2lNhRqqFmBEQVU77xAlOuPjjx5HTmh2u2Yr6W+U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Golan Ben Ami <golan.ben.ami@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 165/191] iwlwifi: pcie: fit reclaim msg to MAX_MSG_LEN
Date:   Sat,  9 Nov 2019 21:39:47 -0500
Message-Id: <20191110024013.29782-165-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Golan Ben Ami <golan.ben.ami@intel.com>

[ Upstream commit 81f0c66187e1ebb7b63529d82faf7ff1e0ef428a ]

Today, the length of a debug message in iwl_trans_pcie_reclaim
may pass the MAX_MSG_LEN, which is 110.
An example for this kind of message is:

'iwl_trans_pcie_reclaim: Read index for DMA queue txq id (2),
last_to_free 65535 is out of range [0-65536] 2 2.'

Cut the message a bit so it will fit the allowed MAX_MSG_LEN.

Signed-off-by: Golan Ben Ami <golan.ben.ami@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 42fdb7970cfdc..2fec394a988c1 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1103,7 +1103,7 @@ void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 
 	if (!iwl_queue_used(txq, last_to_free)) {
 		IWL_ERR(trans,
-			"%s: Read index for DMA queue txq id (%d), last_to_free %d is out of range [0-%d] %d %d.\n",
+			"%s: Read index for txq id (%d), last_to_free %d is out of range [0-%d] %d %d.\n",
 			__func__, txq_id, last_to_free,
 			trans->cfg->base_params->max_tfd_queue_size,
 			txq->write_ptr, txq->read_ptr);
-- 
2.20.1

