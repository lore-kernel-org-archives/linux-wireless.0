Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1305 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab2BIKRl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 05:17:41 -0500
From: Chilam Ng <chilamng@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <ath6kl-devel@qualcomm.com>
Subject: [PATCH] ath6kl: assign Tx packet drop threshold per endpoint based on AC priority
Date: Thu, 9 Feb 2012 02:17:01 -0800
Message-ID: <1328782621-5251-1-git-send-email-chilamng@qca.qualcomm.com> (sfid-20120209_111745_421314_C5108745)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tx packets will begin to drop when there are multiple traffic priorities
and the current traffic is not the highest priority and the remaining
cookies drop below a certain number, which is fixed for all AC. It is
possilbe that lower priority AC have more traffic which will consume
more cookies and lock out higher priority AC from having any. Assign
each endpoint (AC) with a different Tx-packet-drop threshold so lower
priority AC is more likely to drop packets and the cookies become more
available to higher priority AC.

Signed-off-by: Chilam Ng <chilamng@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc.c  |    9 +++++++++
 drivers/net/wireless/ath/ath6kl/htc.h  |    1 +
 drivers/net/wireless/ath/ath6kl/txrx.c |    3 ++-
 3 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index 7d4e835..93e819d 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -2482,6 +2482,15 @@ int ath6kl_htc_conn_service(struct htc_target *target,
 	endpoint->cred_dist.endpoint = assigned_ep;
 	endpoint->cred_dist.cred_sz = target->tgt_cred_sz;
 
+	switch (endpoint->svc_id) {
+	case WMI_DATA_BK_SVC:
+		endpoint->tx_drop_packet_threshold = MAX_DEF_COOKIE_NUM / 3;
+		break;
+	default:
+		endpoint->tx_drop_packet_threshold = MAX_HI_COOKIE_NUM;
+		break;
+	}
+
 	if (conn_req->max_rxmsg_sz) {
 		/*
 		 * Override cred_per_msg calculation, this optimizes
diff --git a/drivers/net/wireless/ath/ath6kl/htc.h b/drivers/net/wireless/ath/ath6kl/htc.h
index b85716e..1d90fe6 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.h
+++ b/drivers/net/wireless/ath/ath6kl/htc.h
@@ -500,6 +500,7 @@ struct htc_endpoint {
 	u8 seqno;
 	u32 conn_flags;
 	struct htc_endpoint_stats ep_st;
+	u16 tx_drop_packet_threshold;
 };
 
 struct htc_control_buffer {
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index dd63371..294e269 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -576,7 +576,8 @@ enum htc_send_full_action ath6kl_tx_queue_full(struct htc_target *target,
 	 */
 	if (ar->ac_stream_pri_map[ar->ep2ac_map[endpoint]] <
 	    ar->hiac_stream_active_pri &&
-	    ar->cookie_count <= MAX_HI_COOKIE_NUM)
+	    ar->cookie_count <=
+			target->endpoint[endpoint].tx_drop_packet_threshold)
 		/*
 		 * Give preference to the highest priority stream by
 		 * dropping the packets which overflowed.
-- 
1.7.7.2

