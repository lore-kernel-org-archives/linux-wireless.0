Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:46994 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S964955AbdAKQL7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 11:11:59 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v0BG0CjP011152
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jan 2017 08:11:58 -0800
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 27wpbh0mud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jan 2017 08:11:58 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: remove redundant dma padding in AMSDU
Date: Wed, 11 Jan 2017 21:41:24 +0530
Message-ID: <1484151084-7241-1-git-send-email-akarwar@marvell.com> (sfid-20170111_171203_186321_3E66B1E7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

We already ensure 64 bytes alignment and add padding if required
during skb_aggr allocation.

Alignment and padding in mwifiex_11n_form_amsdu_txpd() is redundant.
We may end up accessing more data than allocated size with this.

This patch fixes following issue by removing redundant padding.

[  370.241338] skbuff: skb_over_panic: text:ffffffffc046946a len:3550
put:72 head:ffff880000110000 data:ffff8800001100e4 tail:0xec2 end:0xec0 dev:<NULL>
[  370.241374] ------------[ cut here ]------------
[  370.241382] kernel BUG at net/core/skbuff.c:104!
  370.244032] Call Trace:
[  370.244041]  [<ffffffff8c3df5ec>] skb_put+0x44/0x45
[  370.244055]  [<ffffffffc046946a>]
mwifiex_11n_aggregate_pkt+0x1e9/0xa50 [mwifiex]
[  370.244067]  [<ffffffffc0467c16>] mwifiex_wmm_process_tx+0x44a/0x6b7
[mwifiex]
[  370.244074]  [<ffffffffc0411eb8>] ? 0xffffffffc0411eb8
[  370.244084]  [<ffffffffc046116b>] mwifiex_main_process+0x476/0x5a5
[mwifiex]
[  370.244098]  [<ffffffffc0461298>] mwifiex_main_process+0x5a3/0x5a5
[mwifiex]
[  370.244113]  [<ffffffff8be7e9ff>] process_one_work+0x1a4/0x309
[  370.244123]  [<ffffffff8be7f4ca>] worker_thread+0x20c/0x2ee
[  370.244130]  [<ffffffff8be7f2be>] ? rescuer_thread+0x383/0x383
[  370.244136]  [<ffffffff8be7f2be>] ? rescuer_thread+0x383/0x383
[  370.244143]  [<ffffffff8be83742>] kthread+0x11c/0x124
[  370.244150]  [<ffffffff8be83626>] ? kthread_parkme+0x24/0x24
[  370.244157]  [<ffffffff8c4da1ef>] ret_from_fork+0x3f/0x70
[  370.244168]  [<ffffffff8be83626>] ? kthread_parkme+0x24/0x24

Fixes: 84b313b35f8158d ("mwifiex: make tx packet 64 byte DMA aligned")
Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/11n_aggr.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n_aggr.c b/drivers/net/wireless/marvell/mwifiex/11n_aggr.c
index c47d636..a75013a 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n_aggr.c
@@ -101,13 +101,6 @@
 {
 	struct txpd *local_tx_pd;
 	struct mwifiex_txinfo *tx_info = MWIFIEX_SKB_TXCB(skb);
-	unsigned int pad;
-	int headroom = (priv->adapter->iface_type ==
-			MWIFIEX_USB) ? 0 : INTF_HEADER_LEN;
-
-	pad = ((void *)skb->data - sizeof(*local_tx_pd) -
-		headroom - NULL) & (MWIFIEX_DMA_ALIGN_SZ - 1);
-	skb_push(skb, pad);
 
 	skb_push(skb, sizeof(*local_tx_pd));
 
@@ -121,12 +114,10 @@
 	local_tx_pd->bss_num = priv->bss_num;
 	local_tx_pd->bss_type = priv->bss_type;
 	/* Always zero as the data is followed by struct txpd */
-	local_tx_pd->tx_pkt_offset = cpu_to_le16(sizeof(struct txpd) +
-						 pad);
+	local_tx_pd->tx_pkt_offset = cpu_to_le16(sizeof(struct txpd));
 	local_tx_pd->tx_pkt_type = cpu_to_le16(PKT_TYPE_AMSDU);
 	local_tx_pd->tx_pkt_length = cpu_to_le16(skb->len -
-						 sizeof(*local_tx_pd) -
-						 pad);
+						 sizeof(*local_tx_pd));
 
 	if (tx_info->flags & MWIFIEX_BUF_FLAG_TDLS_PKT)
 		local_tx_pd->flags |= MWIFIEX_TXPD_FLAGS_TDLS_PACKET;
@@ -190,7 +181,11 @@
 				       ra_list_flags);
 		return -1;
 	}
-	skb_reserve(skb_aggr, MWIFIEX_MIN_DATA_HEADER_LEN);
+
+	/* skb_aggr->data already 64 byte align, just reserve bus interface
+	 * header and txpd.
+	 */
+	skb_reserve(skb_aggr, headroom + sizeof(struct txpd));
 	tx_info_aggr =  MWIFIEX_SKB_TXCB(skb_aggr);
 
 	memset(tx_info_aggr, 0, sizeof(*tx_info_aggr));
-- 
1.9.1
