Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:56919 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbaFPOP4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 10:15:56 -0400
Received: by mail-pa0-f45.google.com with SMTP id rd3so3928769pab.18
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jun 2014 07:15:55 -0700 (PDT)
Received: from localhost.localdomain ([115.248.87.14])
        by mx.google.com with ESMTPSA id vc5sm69569177pac.19.2014.06.16.07.15.53
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Mon, 16 Jun 2014 07:15:55 -0700 (PDT)
From: Jahnavi Meher <jahnavi.meher@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 12/16] rsi: Added debug messages.
Date: Mon, 16 Jun 2014 19:45:45 +0530
Message-Id: <1402928145-4115-1-git-send-email-jahnavi.meher@gmail.com> (sfid-20140616_161558_786135_FC0452CC)
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

