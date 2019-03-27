Return-Path: <SRS0=A7Z7=R6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F2F7C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 19:22:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2086A206C0
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 19:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553714549;
	bh=1s7RgBUl01/7/jLP5KHqoctGZubsKT0vnWmhrEcD3UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=olsGNZTy3GOscYypziOMZ8P6DsFoSiL/9iBJcmatZnuQoSvLlxJW6h3d+8uSzT+5/
	 BiBMoG6T+HiNdsWrB8kM6zgog510mRnHhGaWII56CYbLhYnQV27m20RCZxgEAoGdy4
	 4QABHEoPSNEbwJ/RMxy+b7H0kqlMcaY/ArQjY+5g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387958AbfC0SGe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:06:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733208AbfC0SGa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Mar 2019 14:06:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCBFB2063F;
        Wed, 27 Mar 2019 18:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553709989;
        bh=1s7RgBUl01/7/jLP5KHqoctGZubsKT0vnWmhrEcD3UA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B3ynSZJYbQJnzO68cIbJ4UjQqODjCtt8QHEtbNE5pAYnpSoPoV4B8MjGm+tvDjX8O
         c6y2xPzWeWsip/mKx0iTs9OuYuRfaEsM4xuoCnp2SH9/Hgdgl7hbLFYB4/Uw3zcLmP
         RI8YkivKC+WTvAK8H7BwBft8QihgjOVVzYxB/0mI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 145/262] iwlwifi: pcie: fix emergency path
Date:   Wed, 27 Mar 2019 14:00:00 -0400
Message-Id: <20190327180158.10245-145-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327180158.10245-1-sashal@kernel.org>
References: <20190327180158.10245-1-sashal@kernel.org>
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
index 9e850c25877b..c596c7b13504 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -499,7 +499,7 @@ static void iwl_pcie_rx_allocator(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rb_allocator *rba = &trans_pcie->rba;
 	struct list_head local_empty;
-	int pending = atomic_xchg(&rba->req_pending, 0);
+	int pending = atomic_read(&rba->req_pending);
 
 	IWL_DEBUG_RX(trans, "Pending allocation requests = %d\n", pending);
 
@@ -554,11 +554,13 @@ static void iwl_pcie_rx_allocator(struct iwl_trans *trans)
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
 
@@ -570,12 +572,15 @@ static void iwl_pcie_rx_allocator(struct iwl_trans *trans)
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

