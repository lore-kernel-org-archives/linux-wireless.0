Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:62856 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaFYKSY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 06:18:24 -0400
Received: by mail-pb0-f54.google.com with SMTP id un15so1531922pbc.27
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 03:18:24 -0700 (PDT)
Received: from localhost.localdomain ([115.248.87.14])
        by mx.google.com with ESMTPSA id be7sm15959605pad.9.2014.06.25.03.18.22
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Wed, 25 Jun 2014 03:18:23 -0700 (PDT)
From: Jahnavi Meher <jahnavi.meher@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] rsi: Fixed warnings reported by static code analyzers.
Date: Wed, 25 Jun 2014 15:48:15 +0530
Message-Id: <1403691495-5001-1-git-send-email-jahnavi.meher@gmail.com> (sfid-20140625_121827_598907_DA0DB929)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixed a warning related to incorrect return type and removed an
unnecessary semi colon.

Signed-off-by: Jahnavi Meher <jahnavi.meher@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_core.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index 1cd0914..f3d3995 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -92,6 +92,7 @@ static u32 rsi_get_num_pkts_dequeue(struct rsi_common *common, u8 q_num)
 	struct sk_buff *skb;
 	u32 pkt_cnt = 0;
 	s16 txop = common->tx_qinfo[q_num].txop * 32;
+	__le16 r_txop;
 	struct ieee80211_rate rate;
 
 	rate.bitrate = RSI_RATE_MCS0 * 5 * 10; /* Convert to Kbps */
@@ -104,10 +105,11 @@ static u32 rsi_get_num_pkts_dequeue(struct rsi_common *common, u8 q_num)
 		return 0;
 
 	do {
-		txop -= ieee80211_generic_frame_duration(adapter->hw,
-							 adapter->vifs[0],
-							 common->band,
-							 skb->len, &rate);
+		r_txop = ieee80211_generic_frame_duration(adapter->hw,
+							  adapter->vifs[0],
+							  common->band,
+							  skb->len, &rate);
+		txop -= le16_to_cpu(r_txop);
 		pkt_cnt += 1;
 		/*checking if pkts are still there*/
 		if (skb_queue_len(&common->tx_queue[q_num]) - pkt_cnt)
@@ -191,7 +193,7 @@ get_queue_num:
 	if (q_num == VO_Q || q_num == VI_Q) {
 		common->pkt_cnt = rsi_get_num_pkts_dequeue(common, q_num);
 		common->pkt_cnt -= 1;
-	};
+	}
 
 	return q_num;
 }
-- 
1.7.1

