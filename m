Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20243 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbbEKQK4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2015 12:10:56 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v2] wil6210: fix format specifier for dma_addr_t
Date: Mon, 11 May 2015 19:10:48 +0300
Message-Id: <1431360648-4854-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150511_181102_345423_DC9DB9A2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix format specifier used for dma_addr_t, namely use %pad
Debug print virtual address for the same buffer as well.

It can be applied as:
fixup! wil6210: Add pmc debug mechanism memory management

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/pmc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/pmc.c b/drivers/net/wireless/ath/wil6210/pmc.c
index 3cb4f35..8a8cdc6 100644
--- a/drivers/net/wireless/ath/wil6210/pmc.c
+++ b/drivers/net/wireless/ath/wil6210/pmc.c
@@ -92,9 +92,9 @@ void wil_pmc_alloc(struct wil6210_priv *wil,
 			GFP_KERNEL);
 
 	wil_dbg_misc(wil,
-		     "%s: allocated pring %p. %zd x %d = total %zd bytes\n",
+		     "%s: allocated pring %p => %pad. %zd x %d = total %zd bytes\n",
 		     __func__,
-		     (void *)pmc->pring_pa,
+		     pmc->pring_va, &pmc->pring_pa,
 		     sizeof(struct vring_tx_desc),
 		     num_descriptors,
 		     sizeof(struct vring_tx_desc) * num_descriptors);
-- 
2.1.0

