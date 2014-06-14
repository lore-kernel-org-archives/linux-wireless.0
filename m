Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:61407 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784AbaFNNyb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jun 2014 09:54:31 -0400
Received: by mail-pa0-f42.google.com with SMTP id lj1so3069788pab.29
        for <linux-wireless@vger.kernel.org>; Sat, 14 Jun 2014 06:54:31 -0700 (PDT)
Received: from localhost.localdomain ([115.248.87.14])
        by mx.google.com with ESMTPSA id pr8sm9008256pbc.74.2014.06.14.06.54.29
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Sat, 14 Jun 2014 06:54:30 -0700 (PDT)
From: Jahnavi Meher <jahnavi.meher@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 12/16] rsi: Added debug messages.
Date: Sat, 14 Jun 2014 19:24:22 +0530
Message-Id: <1402754062-14196-1-git-send-email-jahnavi.meher@gmail.com> (sfid-20140614_155434_929701_62013755)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added some debug messages.

Signed-off-by: Jahnavi Meher <jahnavi.meher@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index 264e8fa..6f6a4d0 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -284,6 +284,7 @@ void rsi_core_qos_processor(struct rsi_common *common)
 
 		skb = rsi_core_dequeue_pkt(common, q_num);
 		if (skb == NULL) {
+			rsi_dbg(ERR_ZONE, "skb null\n");
 			mutex_unlock(&common->tx_rxlock);
 			break;
 		}
@@ -357,6 +358,7 @@ void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb)
 	if ((q_num != MGMT_SOFT_Q) &&
 	    ((skb_queue_len(&common->tx_queue[q_num]) + 1) >=
 	     DATA_QUEUE_WATER_MARK)) {
+		rsi_dbg(ERR_ZONE, "%s: sw queue full\n", __func__);
 		if (!ieee80211_queue_stopped(adapter->hw, WME_AC(q_num)))
 			ieee80211_stop_queue(adapter->hw, WME_AC(q_num));
 		rsi_set_event(&common->tx_thread.event);
-- 
1.7.1

