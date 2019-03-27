Return-Path: <SRS0=A7Z7=R6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 085DDC10F00
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 18:13:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD6E921741
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 18:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553710401;
	bh=MJVzSy+4vdMfW0w03710h4/91SJYYvX1MThx5vyfq/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=M59c9FvBYzOL7WRI9b4iPZRXbRYnEBMUBBQfEZ5n0EzsGr2bWR1FexRmh4q2AP36T
	 ShpMGRSfVTkMMbstxU3F7qMp6cmZ9GAcQwi5hzuYALnbM31CR1mxIfH8M1hLOv2kgh
	 4X8YUf4cd8vVGl71BaaFsqZnQ6aNAjU36G/LgrR8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389398AbfC0SNU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:13:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389387AbfC0SNT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Mar 2019 14:13:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D85E2184C;
        Wed, 27 Mar 2019 18:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553710398;
        bh=MJVzSy+4vdMfW0w03710h4/91SJYYvX1MThx5vyfq/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZWd1ARpl33+to/sjVEymt6FiB/urLOJ04NGQto444KVt8GJ0XlgNtyR+PcSB4MG6U
         wdXicoA4zQFaK1dl8Rg+eqZztJqIs6TeaGgw6ojkSBvNzWfc8th81MC7UnhKZl6dyz
         2jGkQeKpmcBSt92rBQhd+IKp9BrEg8vJosEacW4s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 100/192] iwlwifi: pcie: fix emergency path
Date:   Wed, 27 Mar 2019 14:08:52 -0400
Message-Id: <20190327181025.13507-100-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327181025.13507-1-sashal@kernel.org>
References: <20190327181025.13507-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

[ Upstream commit c6ac9f9fb98851f47b978a9476594fc3c477a34d ]

Allocator swaps the pending requests with 0 when it starts
working. This means that relying on it n RX path to decide if
to move to emergency is not always a good idea, since it may
be zero, but there are still a lot of unallocated RBs in the
system. Change allocator to decrement the pending requests on
real time. It is more expensive since it accesses the atomic
variable more times, but it gives the RX path a better idea
of the system's status.

Reported-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Fixes: 868a1e863f95 ("iwlwifi: pcie: avoid empty free RB queue")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index d4a31e014c82..b2905f01b7df 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -502,7 +502,7 @@ static void iwl_pcie_rx_allocator(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rb_allocator *rba = &trans_pcie->rba;
 	struct list_head local_empty;
-	int pending = atomic_xchg(&rba->req_pending, 0);
+	int pending = atomic_read(&rba->req_pending);
 
 	IWL_DEBUG_RX(trans, "Pending allocation requests = %d\n", pending);
 
@@ -557,11 +557,13 @@ static void iwl_pcie_rx_allocator(struct iwl_trans *trans)
 			i++;
 		}
 
+		atomic_dec(&rba->req_pending);
 		pending--;
+
 		if (!pending) {
-			pending = atomic_xchg(&rba->req_pending, 0);
+			pending = atomic_read(&rba->req_pending);
 			IWL_DEBUG_RX(trans,
-				     "Pending allocation requests = %d\n",
+				     "Got more pending allocation requests = %d\n",
 				     pending);
 		}
 
@@ -573,12 +575,15 @@ static void iwl_pcie_rx_allocator(struct iwl_trans *trans)
 		spin_unlock(&rba->lock);
 
 		atomic_inc(&rba->req_ready);
+
 	}
 
 	spin_lock(&rba->lock);
 	/* return unused rbds to the allocator empty list */
 	list_splice_tail(&local_empty, &rba->rbd_empty);
 	spin_unlock(&rba->lock);
+
+	IWL_DEBUG_RX(trans, "%s, exit.\n", __func__);
 }
 
 /*
-- 
2.19.1

