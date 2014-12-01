Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:57979 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673AbaLANhK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 08:37:10 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 9/9] wil6210: remove TODO wrt buffer alignment
Date: Mon, 1 Dec 2014 15:36:53 +0200
Message-ID: <1417441013-27409-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141201_143719_573713_F0B7794E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hardware doesn't place any restrictions on the buffer alignment,
consider this TODO resolved.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 405ede6..e3f8bdc 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -210,8 +210,6 @@ static int wil_vring_alloc_skb(struct wil6210_priv *wil, struct vring *vring,
 	struct vring_rx_desc dd, *d = &dd;
 	volatile struct vring_rx_desc *_d = &vring->va[i].rx;
 	dma_addr_t pa;
-
-	/* TODO align */
 	struct sk_buff *skb = dev_alloc_skb(sz + headroom);
 
 	if (unlikely(!skb))
-- 
2.1.0

