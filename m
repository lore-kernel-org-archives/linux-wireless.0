Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:64722 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbbCOOAn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 10:00:43 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 1/3] wil6210: NAPI completion refactor
Date: Sun, 15 Mar 2015 16:00:15 +0200
Message-Id: <1426428024-4538-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150315_150053_247752_E731A282)
In-Reply-To: <1426428024-4538-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1426428024-4538-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is expected that driver completes NAPI when less than
full budget is consumed.

Fulfill this requirement.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/netdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index ace30c1..f2f7ea2 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -82,7 +82,7 @@ static int wil6210_netdev_poll_rx(struct napi_struct *napi, int budget)
 	wil_rx_handle(wil, &quota);
 	done = budget - quota;
 
-	if (done <= 1) { /* burst ends - only one packet processed */
+	if (done < budget) {
 		napi_complete(napi);
 		wil6210_unmask_irq_rx(wil);
 		wil_dbg_txrx(wil, "NAPI RX complete\n");
@@ -110,7 +110,7 @@ static int wil6210_netdev_poll_tx(struct napi_struct *napi, int budget)
 		tx_done += wil_tx_complete(wil, i);
 	}
 
-	if (tx_done <= 1) { /* burst ends - only one packet processed */
+	if (tx_done < budget) {
 		napi_complete(napi);
 		wil6210_unmask_irq_tx(wil);
 		wil_dbg_txrx(wil, "NAPI TX complete\n");
-- 
2.1.0

