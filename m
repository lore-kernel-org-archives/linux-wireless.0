Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:59887 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaFPOJv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 10:09:51 -0400
Received: by mail-pb0-f50.google.com with SMTP id rp16so4510001pbb.23
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jun 2014 07:09:51 -0700 (PDT)
Received: from localhost.localdomain ([115.248.87.14])
        by mx.google.com with ESMTPSA id eh4sm19008952pbc.79.2014.06.16.07.09.49
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Mon, 16 Jun 2014 07:09:50 -0700 (PDT)
From: Jahnavi Meher <jahnavi.meher@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 01/16] rsi: Mapping the debugfs stats to the correct s/w queues.
Date: Mon, 16 Jun 2014 19:39:40 +0530
Message-Id: <1402927780-3763-1-git-send-email-jahnavi.meher@gmail.com> (sfid-20140616_160954_790605_FBB412E6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changed the queue numbers to macros, and corrected the mappings.

Signed-off-by: Jahnavi Meher <jahnavi.meher@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_debugfs.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_debugfs.c b/drivers/net/wireless/rsi/rsi_91x_debugfs.c
index c466246..828a042 100644
--- a/drivers/net/wireless/rsi/rsi_91x_debugfs.c
+++ b/drivers/net/wireless/rsi/rsi_91x_debugfs.c
@@ -145,7 +145,7 @@ static int rsi_stats_read(struct seq_file *seq, void *data)
 	seq_printf(seq, "total_mgmt_pkt_send : %d\n",
 		   common->tx_stats.total_tx_pkt_send[MGMT_SOFT_Q]);
 	seq_printf(seq, "total_mgmt_pkt_queued : %d\n",
-		   skb_queue_len(&common->tx_queue[4]));
+		   skb_queue_len(&common->tx_queue[MGMT_SOFT_Q]));
 	seq_printf(seq, "total_mgmt_pkt_freed  : %d\n",
 		   common->tx_stats.total_tx_pkt_freed[MGMT_SOFT_Q]);
 
@@ -153,25 +153,25 @@ static int rsi_stats_read(struct seq_file *seq, void *data)
 	seq_printf(seq, "total_data_vo_pkt_send: %8d\t",
 		   common->tx_stats.total_tx_pkt_send[VO_Q]);
 	seq_printf(seq, "total_data_vo_pkt_queued:  %8d\t",
-		   skb_queue_len(&common->tx_queue[0]));
+		   skb_queue_len(&common->tx_queue[VO_Q]));
 	seq_printf(seq, "total_vo_pkt_freed: %8d\n",
 		   common->tx_stats.total_tx_pkt_freed[VO_Q]);
 	seq_printf(seq, "total_data_vi_pkt_send: %8d\t",
 		   common->tx_stats.total_tx_pkt_send[VI_Q]);
 	seq_printf(seq, "total_data_vi_pkt_queued:  %8d\t",
-		   skb_queue_len(&common->tx_queue[1]));
+		   skb_queue_len(&common->tx_queue[VI_Q]));
 	seq_printf(seq, "total_vi_pkt_freed: %8d\n",
 		   common->tx_stats.total_tx_pkt_freed[VI_Q]);
 	seq_printf(seq,  "total_data_be_pkt_send: %8d\t",
 		   common->tx_stats.total_tx_pkt_send[BE_Q]);
 	seq_printf(seq, "total_data_be_pkt_queued:  %8d\t",
-		   skb_queue_len(&common->tx_queue[2]));
+		   skb_queue_len(&common->tx_queue[BE_Q]));
 	seq_printf(seq, "total_be_pkt_freed: %8d\n",
 		   common->tx_stats.total_tx_pkt_freed[BE_Q]);
 	seq_printf(seq, "total_data_bk_pkt_send: %8d\t",
 		   common->tx_stats.total_tx_pkt_send[BK_Q]);
 	seq_printf(seq, "total_data_bk_pkt_queued:  %8d\t",
-		   skb_queue_len(&common->tx_queue[3]));
+		   skb_queue_len(&common->tx_queue[BK_Q]));
 	seq_printf(seq, "total_bk_pkt_freed: %8d\n",
 		   common->tx_stats.total_tx_pkt_freed[BK_Q]);
 
-- 
1.7.1

