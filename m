Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:25275 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbbBAIzd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Feb 2015 03:55:33 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 1/6] wil6210: remove old Tx work-around
Date: Sun,  1 Feb 2015 10:55:11 +0200
Message-Id: <1422780916-8577-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150201_095546_284153_6534344B)
In-Reply-To: <1422780916-8577-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1422780916-8577-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the Tx, work around used to force destination index 0
to be used. This is no more necessary, as firmware supports
multiple destinations

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 0499ebc..24c4b9a 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -873,9 +873,6 @@ static int wil_tx_desc_map(struct vring_tx_desc *d, dma_addr_t pa, u32 len,
 	d->mac.d[1] = 0;
 	d->mac.d[2] = 0;
 	d->mac.ucode_cmd = 0;
-	/* use dst index 0 */
-	d->mac.d[1] |= BIT(MAC_CFG_DESC_TX_1_DST_INDEX_EN_POS) |
-		       (0 << MAC_CFG_DESC_TX_1_DST_INDEX_POS);
 	/* translation type:  0 - bypass; 1 - 802.3; 2 - native wifi */
 	d->mac.d[2] = BIT(MAC_CFG_DESC_TX_2_SNAP_HDR_INSERTION_EN_POS) |
 		      (1 << MAC_CFG_DESC_TX_2_L2_TRANSLATION_TYPE_POS);
-- 
2.1.0

