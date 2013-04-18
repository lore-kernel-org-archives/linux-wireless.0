Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:33910 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965622Ab3DRLeR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Apr 2013 07:34:17 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 3/4] wil6210: Use cached copy of Tx descriptor
Date: Thu, 18 Apr 2013 14:33:52 +0300
Message-ID: <1366284834-540-4-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130418_133422_242876_EA204B6F)
In-Reply-To: <1366284834-540-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1366284834-540-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Original Tx descriptor stored is in non-cached area for DMA;
copy it to the cached memory to speed-up access

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 3d9afc5..91454a4 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -789,9 +789,14 @@ void wil_tx_complete(struct wil6210_priv *wil, int ringid)
 	wil_dbg_txrx(wil, "%s(%d)\n", __func__, ringid);
 
 	while (!wil_vring_is_empty(vring)) {
-		volatile struct vring_tx_desc *d = &vring->va[vring->swtail].tx;
+		volatile struct vring_tx_desc *d1 =
+					      &vring->va[vring->swtail].tx;
+		struct vring_tx_desc dd, *d = &dd;
 		dma_addr_t pa;
 		struct sk_buff *skb;
+
+		dd = *d1;
+
 		if (!(d->dma.status & TX_DMA_STATUS_DU))
 			break;
 
-- 
1.7.10.4

