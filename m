Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:36968 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752769AbcI1MuC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2016 08:50:02 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8SCjjS2000483
        for <linux-wireless@vger.kernel.org>; Wed, 28 Sep 2016 05:50:01 -0700
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 25r7ghjfce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Wed, 28 Sep 2016 05:50:01 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 6/8] mwifiex: update tx_pkts_queued for requeued packets
Date: Wed, 28 Sep 2016 18:18:26 +0530
Message-ID: <1475066908-11771-6-git-send-email-akarwar@marvell.com> (sfid-20160928_145005_746554_A74AFF8D)
In-Reply-To: <1475066908-11771-1-git-send-email-akarwar@marvell.com>
References: <1475066908-11771-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

wmm.tx_pkts_queued and ralist's total_pkt_count should be updated in
synchronization. They were not correctly updated in
mwifiex_send_processed_packet().

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/wmm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/wmm.c b/drivers/net/wireless/marvell/mwifiex/wmm.c
index dea2fe6..1ff3a87 100644
--- a/drivers/net/wireless/marvell/mwifiex/wmm.c
+++ b/drivers/net/wireless/marvell/mwifiex/wmm.c
@@ -1334,9 +1334,11 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 	skb = skb_dequeue(&ptr->skb_head);
 
 	if (adapter->data_sent || adapter->tx_lock_flag) {
+		ptr->total_pkt_count--;
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
 		skb_queue_tail(&adapter->tx_data_q, skb);
+		atomic_dec(&priv->wmm.tx_pkts_queued);
 		atomic_inc(&adapter->tx_queued);
 		return;
 	}
@@ -1394,6 +1396,10 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 	if (ret != -EBUSY) {
 		mwifiex_rotate_priolists(priv, ptr, ptr_index);
 		atomic_dec(&priv->wmm.tx_pkts_queued);
+		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
+		ptr->total_pkt_count--;
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+				       ra_list_flags);
 	}
 }
 
-- 
1.9.1
