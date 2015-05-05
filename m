Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36778 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993436AbbEEPmY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2015 11:42:24 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH] wil6210: fix format specifier for dma_addr_t
Date: Tue,  5 May 2015 18:42:08 +0300
Message-Id: <1430840528-14998-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150505_194345_229943_0A532205)
In-Reply-To: <87fv7bvb9f.fsf@kamboji.qca.qualcomm.com>
References: <87fv7bvb9f.fsf@kamboji.qca.qualcomm.com>
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
index 3cb4f35..d34b084 100644
--- a/drivers/net/wireless/ath/wil6210/pmc.c
+++ b/drivers/net/wireless/ath/wil6210/pmc.c
@@ -92,9 +92,9 @@ void wil_pmc_alloc(struct wil6210_priv *wil,
 			GFP_KERNEL);
 
 	wil_dbg_misc(wil,
-		     "%s: allocated pring %p. %zd x %d = total %zd bytes\n",
+		     "%s: allocated pring %p => %pad. %zd x %d = total %zd bytes\n",
 		     __func__,
-		     (void *)pmc->pring_pa,
+		     pmc->pring_va, pmc->pring_pa,
 		     sizeof(struct vring_tx_desc),
 		     num_descriptors,
 		     sizeof(struct vring_tx_desc) * num_descriptors);
-- 
2.1.0

