Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:63245 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757998AbbAITSV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2015 14:18:21 -0500
Received: by mail-oi0-f45.google.com with SMTP id x69so13263713oia.4
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2015 11:18:21 -0800 (PST)
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 4/8] wcn36xx: don't process 'valid' descriptors
Date: Fri,  9 Jan 2015 14:15:48 -0500
Message-Id: <1420830952-9624-5-git-send-email-me@bobcopeland.com> (sfid-20150109_201852_927936_8B10FF35)
In-Reply-To: <1420830952-9624-1-git-send-email-me@bobcopeland.com>
References: <1420830952-9624-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The DMA engine will reset the valid bit after a descriptor is
complete; any with the valid bit still set may still be in
use by the hardware, so check that before freeing the descriptor.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/wcn36xx/dxe.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index 73f12f1..3d6bc9b 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -354,6 +354,8 @@ static void reap_tx_dxes(struct wcn36xx *wcn, struct wcn36xx_dxe_ch *ch)
 	 * and while-do will not make any cycles.
 	 */
 	do {
+		if (ctl->desc->ctrl & WCN36XX_DXE_CTRL_VALID_MASK)
+			break;
 		if (ctl->skb) {
 			dma_unmap_single(NULL, ctl->desc->src_addr_l,
 					 ctl->skb->len, DMA_TO_DEVICE);
-- 
1.7.10.4

