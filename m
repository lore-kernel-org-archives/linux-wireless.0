Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:20886 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602Ab3GUIft (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Jul 2013 04:35:49 -0400
Cc: Kirshenbaum Erez <erezk@wilocity.com>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	<wil6210@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/2] wil6210: fix error path in wil_tx_vring
Date: Sun, 21 Jul 2013 11:34:36 +0300
Message-ID: <1374395677-16751-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130721_103556_864479_F8633F40)
In-Reply-To: <1374395677-16751-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1374395677-16751-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Release fragments in the order of allocation; including one for skb head

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 2a9d56a..e563af1 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -730,12 +730,13 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	return 0;
  dma_error:
 	/* unmap what we have mapped */
-	/* Note: increment @f to operate with positive index */
-	for (f++; f > 0; f--) {
+	nr_frags = f + 1; /* frags mapped + one for skb head */
+	for (f = 0; f < nr_frags; f++) {
 		u16 dmalen;
-		struct wil_ctx *ctx = &vring->ctx[i];
+		struct wil_ctx *ctx;
 
 		i = (swhead + f) % vring->size;
+		ctx = &vring->ctx[i];
 		_d = &(vring->va[i].tx);
 		*d = *_d;
 		_d->dma.status = TX_DMA_STATUS_DU;
-- 
1.8.1.2

