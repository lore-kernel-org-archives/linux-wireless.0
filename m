Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:59835 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756990AbcDEH2x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 03:28:53 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Eric Dumaze <edumazet@google.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 4/7] mwifiex: remove redundant GFP_DMA flag
Date: Tue, 5 Apr 2016 00:22:29 -0700
Message-ID: <1459840952-25338-4-git-send-email-akarwar@marvell.com> (sfid-20160405_092859_578263_E895A2DE)
In-Reply-To: <1459840952-25338-1-git-send-email-akarwar@marvell.com>
References: <1459840952-25338-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

skb forwarded to TCP/IP stack doesn't need to allocate in DMA ZONE.
This patch removes GFP_DMA flag in this case to save precious DMA
memory.

Signed-off-by: Eric Dumaze <edumazet@google.com>
Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/sdio.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 901c064..2ea2827 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -1122,8 +1122,8 @@ static void mwifiex_deaggr_sdio_pkt(struct mwifiex_adapter *adapter,
 				    __func__, pkt_len, blk_size);
 			break;
 		}
-		skb_deaggr = mwifiex_alloc_dma_align_buf(pkt_len,
-							 GFP_KERNEL | GFP_DMA);
+
+		skb_deaggr = mwifiex_alloc_dma_align_buf(pkt_len, GFP_KERNEL);
 		if (!skb_deaggr)
 			break;
 		skb_put(skb_deaggr, pkt_len);
@@ -1372,8 +1372,7 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 
 			/* copy pkt to deaggr buf */
 			skb_deaggr = mwifiex_alloc_dma_align_buf(len_arr[pind],
-								 GFP_KERNEL |
-								 GFP_DMA);
+								 GFP_KERNEL);
 			if (!skb_deaggr) {
 				mwifiex_dbg(adapter, ERROR, "skb allocation failure\t"
 					    "drop pkt len=%d type=%d\n",
-- 
1.8.1.4

