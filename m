Return-Path: <SRS0=A7Z7=R6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD566C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 18:50:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F3422082F
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 18:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553712613;
	bh=tcgg087K+KUeatzzQL5K3aqOm5Xz5dRyyCTzx66BCtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=1VvJ6UmbusPQVuTYbizkIplL3GElNzb068R87C1ScUGIcbuVoQKu95dj5XPpVElOy
	 ZwyuoCakE7wSHLZvVwx3jYP80T2wyelgFmFSJqYsJ3BgQCzIIrR/9i+Apv8F2sEfKh
	 3bUmM17AZZoddoP0oFUprgtyDNzLy04xXXrDhG/w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390629AbfC0SuB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:50:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:35380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389379AbfC0SS1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Mar 2019 14:18:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01DF420449;
        Wed, 27 Mar 2019 18:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553710706;
        bh=tcgg087K+KUeatzzQL5K3aqOm5Xz5dRyyCTzx66BCtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vZKl1tDhX95IsVkskXrlQnCPrXnBvP8Fhha38Tbv6WuhnViiOGKmffqalIJqNgkAC
         nINW+eFNzAtHG1wY97IvKBL6MEeUkq4Md8dm1eDVAXczvRxKQBLTWfIKxgzGf+/b7t
         rAGzJ9o9QOIUXsJWKWJI45XRO6Ud5XMBooHbckWE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 066/123] iwlwifi: pcie: fix emergency path
Date:   Wed, 27 Mar 2019 14:15:30 -0400
Message-Id: <20190327181628.15899-66-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327181628.15899-1-sashal@kernel.org>
References: <20190327181628.15899-1-sashal@kernel.org>
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
index 5a15362ef671..a40ad4675e19 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -475,7 +475,7 @@ static void iwl_pcie_rx_allocator(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rb_allocator *rba = &trans_pcie->rba;
 	struct list_head local_empty;
-	int pending = atomic_xchg(&rba->req_pending, 0);
+	int pending = atomic_read(&rba->req_pending);
 
 	IWL_DEBUG_RX(trans, "Pending allocation requests = %d\n", pending);
 
@@ -530,11 +530,13 @@ static void iwl_pcie_rx_allocator(struct iwl_trans *trans)
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
 
@@ -546,12 +548,15 @@ static void iwl_pcie_rx_allocator(struct iwl_trans *trans)
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

