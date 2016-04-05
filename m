Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:53792 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755088AbcDEILE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 04:11:04 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u3586cAt013897
	for <linux-wireless@vger.kernel.org>; Tue, 5 Apr 2016 01:11:03 -0700
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0b-0016f401.pphosted.com with ESMTP id 222dkfh9gx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 05 Apr 2016 01:11:03 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH RESEND 4/7] mwifiex: remove redundant GFP_DMA flag
Date: Tue, 5 Apr 2016 01:04:37 -0700
Message-ID: <1459843480-25956-4-git-send-email-akarwar@marvell.com> (sfid-20160405_101115_686661_9175EA78)
In-Reply-To: <1459843480-25956-1-git-send-email-akarwar@marvell.com>
References: <1459843480-25956-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

skb forwarded to TCP/IP stack doesn't need to allocate in DMA ZONE.
This patch removes GFP_DMA flag in this case to save precious DMA
memory.

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

