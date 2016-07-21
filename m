Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:14789 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751641AbcGULBA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2016 07:01:00 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u6LAxRqx019541
	for <linux-wireless@vger.kernel.org>; Thu, 21 Jul 2016 04:00:58 -0700
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0a-0016f401.pphosted.com with ESMTP id 24a2c3feeq-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 21 Jul 2016 04:00:57 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: fix large amsdu packets causing firmware hang
Date: Thu, 21 Jul 2016 16:30:24 +0530
Message-ID: <1469098824-8031-1-git-send-email-akarwar@marvell.com> (sfid-20160721_130121_154292_EED42E60)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Cathy Luo <cluo@marvell.com>

Sometimes host prepares and downloads a large amsdu packet to firmware
which leads to a memory corruption in firmware.
The reason is __dev_alloc_skb() may allocate larger buffer than required
size. This patch solves the problem by checking "adapter->tx_buf_size"
instead of relying on skb_tailroom().

Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/11n_aggr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n_aggr.c b/drivers/net/wireless/marvell/mwifiex/11n_aggr.c
index dc49c3d..c47d636 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n_aggr.c
@@ -205,7 +205,8 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 
 	do {
 		/* Check if AMSDU can accommodate this MSDU */
-		if (skb_tailroom(skb_aggr) < (skb_src->len + LLC_SNAP_LEN))
+		if ((skb_aggr->len + skb_src->len + LLC_SNAP_LEN) >
+		    adapter->tx_buf_size)
 			break;
 
 		skb_src = skb_dequeue(&pra_list->skb_head);
-- 
1.9.1

