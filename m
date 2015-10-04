Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24814 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbbJDHXu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 03:23:50 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Shulman <QCA_shulmanv@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 04/10] wil6210: pmc logger bug fix
Date: Sun,  4 Oct 2015 10:23:21 +0300
Message-Id: <1443943407-6663-5-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20151004_092355_041541_57EB171C)
In-Reply-To: <1443943407-6663-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1443943407-6663-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vladimir Shulman <QCA_shulmanv@QCA.qualcomm.com>

When allocating pmc descriptor, the structure is
initially created on stack and later copied to
the physical ring (device) memory. The descriptor
structure must be initialized to zero to avoid
garbage configuration, which may result in pmc
mechanism malfunctioning.

Signed-off-by: Vladimir Shulman <QCA_shulmanv@QCA.qualcomm.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/pmc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/pmc.c b/drivers/net/wireless/ath/wil6210/pmc.c
index 8a8cdc6..5ca0307 100644
--- a/drivers/net/wireless/ath/wil6210/pmc.c
+++ b/drivers/net/wireless/ath/wil6210/pmc.c
@@ -110,7 +110,7 @@ void wil_pmc_alloc(struct wil6210_priv *wil,
 	 */
 	for (i = 0; i < num_descriptors; i++) {
 		struct vring_tx_desc *_d = &pmc->pring_va[i];
-		struct vring_tx_desc dd, *d = &dd;
+		struct vring_tx_desc dd = {}, *d = &dd;
 		int j = 0;
 
 		pmc->descriptors[i].va = dma_alloc_coherent(dev,
-- 
2.1.4

