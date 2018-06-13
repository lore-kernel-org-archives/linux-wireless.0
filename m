Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40202 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754398AbeFMGsM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Jun 2018 02:48:12 -0400
From: Govind Singh <govinds@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH] ath10k: Handle resource init failure case
Date: Wed, 13 Jun 2018 12:18:06 +0530
Message-Id: <20180613064806.32286-1-govinds@codeaurora.org> (sfid-20180613_084816_176550_402A346D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Return type of resource init method is not assigned.
Handle resource init failures for graceful exit.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index aa8a9b36250e..a0504b8e003c 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -1500,13 +1500,13 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
 	ar_snoc->ce.bus_ops = &ath10k_snoc_bus_ops;
 	ar->ce_priv = &ar_snoc->ce;
 
-	ath10k_snoc_resource_init(ar);
+	ret = ath10k_snoc_resource_init(ar);
 	if (ret) {
 		ath10k_warn(ar, "failed to initialize resource: %d\n", ret);
 		goto err_core_destroy;
 	}
 
-	ath10k_snoc_setup_resource(ar);
+	ret = ath10k_snoc_setup_resource(ar);
 	if (ret) {
 		ath10k_warn(ar, "failed to setup resource: %d\n", ret);
 		goto err_core_destroy;
-- 
2.17.0
