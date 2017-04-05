Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5508 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933036AbdDEL6h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 07:58:37 -0400
Cc: Dedy Lansky <qca_dlansky@qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 10/11] wil6210: fix array out of bounds access in pmc
Date: Wed,  5 Apr 2017 14:58:13 +0300
Message-Id: <1491393494-11816-11-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170405_140157_616631_1DAEF99F)
In-Reply-To: <1491393494-11816-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1491393494-11816-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dedy Lansky <qca_dlansky@qca.qualcomm.com>

Array index 'i' is used before limits check.
Fix this by doing limits check first.

Signed-off-by: Dedy Lansky <qca_dlansky@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/pmc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/pmc.c b/drivers/net/wireless/ath/wil6210/pmc.c
index b067fdf..2e301b6 100644
--- a/drivers/net/wireless/ath/wil6210/pmc.c
+++ b/drivers/net/wireless/ath/wil6210/pmc.c
@@ -200,7 +200,7 @@ void wil_pmc_alloc(struct wil6210_priv *wil,
 
 release_pmc_skbs:
 	wil_err(wil, "exit on error: Releasing skbs...\n");
-	for (i = 0; pmc->descriptors[i].va && i < num_descriptors; i++) {
+	for (i = 0; i < num_descriptors && pmc->descriptors[i].va; i++) {
 		dma_free_coherent(dev,
 				  descriptor_size,
 				  pmc->descriptors[i].va,
@@ -283,7 +283,7 @@ void wil_pmc_free(struct wil6210_priv *wil, int send_pmc_cmd)
 		int i;
 
 		for (i = 0;
-		     pmc->descriptors[i].va && i < pmc->num_descriptors; i++) {
+		     i < pmc->num_descriptors && pmc->descriptors[i].va; i++) {
 			dma_free_coherent(dev,
 					  pmc->descriptor_size,
 					  pmc->descriptors[i].va,
-- 
1.9.1
