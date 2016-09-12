Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:35978 "EHLO
        mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756419AbcILJnB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 05:43:01 -0400
Received: by mail-pa0-f66.google.com with SMTP id p2so1325688pap.3
        for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2016 02:43:00 -0700 (PDT)
From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
To: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        johannes.berg@intel.com, hofrat@osadl.org
Cc: prameela.j04cs@gmail.com, prameela.garnepudi@redpinesignals.com
Subject: [PATCH 1/9] rsi: cleanup and added debug prints in file rsi_91x_core.c
Date: Mon, 12 Sep 2016 15:08:16 +0530
Message-Id: <846d9f40c344b684a8ca6dd904495690aaaae724.1473669618.git.prameela.j04cs@gmail.com> (sfid-20160912_114304_788054_3878C51C)
In-Reply-To: <cover.1473669618.git.prameela.j04cs@gmail.com>
References: <cover.1473669618.git.prameela.j04cs@gmail.com>
In-Reply-To: <cover.1473669618.git.prameela.j04cs@gmail.com>
References: <cover.1473669618.git.prameela.j04cs@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_core.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index f3d3995..b989ec5 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -142,8 +142,10 @@ static u8 rsi_core_determine_hal_queue(struct rsi_common *common)
 		return q_num;
 	}
 
-	if (common->hw_data_qs_blocked)
+	if (common->hw_data_qs_blocked) {
+		rsi_dbg(INFO_ZONE, "%s: data queue blocked\n", __func__);
 		return q_num;
+	}
 
 	if (common->pkt_cnt != 0) {
 		--common->pkt_cnt;
@@ -210,6 +212,7 @@ static void rsi_core_queue_pkt(struct rsi_common *common,
 			       struct sk_buff *skb)
 {
 	u8 q_num = skb->priority;
+
 	if (q_num >= NUM_SOFT_QUEUES) {
 		rsi_dbg(ERR_ZONE, "%s: Invalid Queue Number: q_num = %d\n",
 			__func__, q_num);
@@ -285,7 +288,7 @@ void rsi_core_qos_processor(struct rsi_common *common)
 		}
 
 		skb = rsi_core_dequeue_pkt(common, q_num);
-		if (skb == NULL) {
+		if (!skb) {
 			rsi_dbg(ERR_ZONE, "skb null\n");
 			mutex_unlock(&common->tx_rxlock);
 			break;
@@ -331,21 +334,32 @@ void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb)
 			__func__);
 		goto xmit_fail;
 	}
-	info = IEEE80211_SKB_CB(skb);
-	tx_params = (struct skb_info *)info->driver_data;
-	tmp_hdr = (struct ieee80211_hdr *)&skb->data[0];
 
 	if (common->fsm_state != FSM_MAC_INIT_DONE) {
 		rsi_dbg(ERR_ZONE, "%s: FSM state not open\n", __func__);
 		goto xmit_fail;
 	}
 
+	info = IEEE80211_SKB_CB(skb);
+	tx_params = (struct skb_info *)info->driver_data;
+	tmp_hdr = (struct ieee80211_hdr *)&skb->data[0];
+
 	if ((ieee80211_is_mgmt(tmp_hdr->frame_control)) ||
 	    (ieee80211_is_ctl(tmp_hdr->frame_control)) ||
 	    (ieee80211_is_qos_nullfunc(tmp_hdr->frame_control))) {
 		q_num = MGMT_SOFT_Q;
 		skb->priority = q_num;
+		if (ieee80211_is_probe_req(tmp_hdr->frame_control))
+			rsi_dbg(MGMT_TX_ZONE, "%s: Probe Request\n", __func__);
+		else if (ieee80211_is_auth(tmp_hdr->frame_control))
+			rsi_dbg(MGMT_TX_ZONE, "%s: Auth Request\n", __func__);
+		else if (ieee80211_is_assoc_req(tmp_hdr->frame_control))
+			rsi_dbg(MGMT_TX_ZONE, "%s: Assoc Request\n", __func__);
+		else
+			rsi_dbg(MGMT_TX_ZONE, "%s: pkt_type=%04x\n",
+				__func__, tmp_hdr->frame_control);
 	} else {
+		rsi_dbg(DATA_TX_ZONE, "%s: Data Packet\n", __func__);
 		if (ieee80211_is_data_qos(tmp_hdr->frame_control)) {
 			tid = (skb->data[24] & IEEE80211_QOS_TID);
 			skb->priority = TID_TO_WME_AC(tid);
-- 
2.4.11
