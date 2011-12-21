Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from numidia.opendz.org ([98.142.220.152]:51040 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab1LUA2j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 19:28:39 -0500
Date: Wed, 21 Dec 2011 01:21:47 +0100
From: Djalal Harouni <tixxdz@opendz.org>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] drivers/iwlwifi: use dma_zalloc_coherent() for DMA allocation
Message-ID: <20111221002147.GA4996@dztty> (sfid-20111221_012842_903118_46281E74)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace dma_alloc_coherent()+memset() with the new dma_zalloc_coherent()

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index ce91898..4363da7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -88,18 +88,16 @@ static int iwl_trans_rx_alloc(struct iwl_trans *trans)
 		return -EINVAL;
 
 	/* Allocate the circular buffer of Read Buffer Descriptors (RBDs) */
-	rxq->bd = dma_alloc_coherent(dev, sizeof(__le32) * RX_QUEUE_SIZE,
-				     &rxq->bd_dma, GFP_KERNEL);
+	rxq->bd = dma_zalloc_coherent(dev, sizeof(__le32) * RX_QUEUE_SIZE,
+				      &rxq->bd_dma, GFP_KERNEL);
 	if (!rxq->bd)
 		goto err_bd;
-	memset(rxq->bd, 0, sizeof(__le32) * RX_QUEUE_SIZE);
 
 	/*Allocate the driver's pointer to receive buffer status */
-	rxq->rb_stts = dma_alloc_coherent(dev, sizeof(*rxq->rb_stts),
-					  &rxq->rb_stts_dma, GFP_KERNEL);
+	rxq->rb_stts = dma_zalloc_coherent(dev, sizeof(*rxq->rb_stts),
+					   &rxq->rb_stts_dma, GFP_KERNEL);
 	if (!rxq->rb_stts)
 		goto err_rb_stts;
-	memset(rxq->rb_stts, 0, sizeof(*rxq->rb_stts));
 
 	return 0;
 
-- 
1.7.1
