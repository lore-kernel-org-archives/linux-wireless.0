Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41552 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab2ATPz1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 10:55:27 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 5/6] ath6kl: Fix bug in using tid given by addba/delba req events
Date: Fri, 20 Jan 2012 21:22:01 +0530
Message-ID: <1327074722-3492-5-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120120_165531_432428_3609DFEB)
In-Reply-To: <1327074722-3492-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1327074722-3492-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The tid which is given in addba/delba req event is not
just tid but also muxed with the assoc id (MSB 4 bits)
which can be used to determine the corresponding connected
station in softap mode. The actual tid is LSB 4 bits. Using
the tid as it is with rx_tid[] would result in OOB or invalid
memory access in AP mode.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/txrx.c |   25 +++++++++++++++++++++++--
 1 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 35ddae3..eeb3a10 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -17,6 +17,17 @@
 #include "core.h"
 #include "debug.h"
 
+/*
+ * tid - tid_mux0..tid_mux3
+ * aid - tid_mux4..tid_mux7
+ */
+#define ATH6KL_TID_MASK 0xf
+
+static inline u8 ath6kl_get_tid(u8 tid_mux)
+{
+	return tid_mux & ATH6KL_TID_MASK;
+}
+
 static u8 ath6kl_ibss_map_epid(struct sk_buff *skb, struct net_device *dev,
 			       u32 *map_no)
 {
@@ -1602,7 +1613,7 @@ static void aggr_delete_tid_state(struct aggr_info_conn *aggr_conn, u8 tid)
 	memset(stats, 0, sizeof(struct rxtid_stats));
 }
 
-void aggr_recv_addba_req_evt(struct ath6kl_vif *vif, u8 tid, u16 seq_no,
+void aggr_recv_addba_req_evt(struct ath6kl_vif *vif, u8 tid_mux, u16 seq_no,
 			     u8 win_sz)
 {
 	struct aggr_info *p_aggr = vif->aggr_cntxt;
@@ -1610,12 +1621,17 @@ void aggr_recv_addba_req_evt(struct ath6kl_vif *vif, u8 tid, u16 seq_no,
 	struct rxtid *rxtid;
 	struct rxtid_stats *stats;
 	u16 hold_q_size;
+	u8 tid;
 
 	if (!p_aggr || !p_aggr->aggr_conn)
 		return;
 
 	aggr_conn = p_aggr->aggr_conn;
 
+	tid = ath6kl_get_tid(tid_mux);
+	if (tid >= NUM_OF_TIDS)
+		return;
+
 	rxtid = &aggr_conn->rx_tid[tid];
 	stats = &aggr_conn->stat[tid];
 
@@ -1691,15 +1707,20 @@ struct aggr_info *aggr_init(struct ath6kl_vif *vif)
 	return p_aggr;
 }
 
-void aggr_recv_delba_req_evt(struct ath6kl_vif *vif, u8 tid)
+void aggr_recv_delba_req_evt(struct ath6kl_vif *vif, u8 tid_mux)
 {
 	struct aggr_info *p_aggr = vif->aggr_cntxt;
 	struct rxtid *rxtid;
 	struct aggr_info_conn *aggr_conn;
+	u8 tid;
 
 	if (!p_aggr || !p_aggr->aggr_conn)
 		return;
 
+	tid = ath6kl_get_tid(tid_mux);
+	if (tid >= NUM_OF_TIDS)
+		return;
+
 	aggr_conn = p_aggr->aggr_conn;
 	rxtid = &aggr_conn->rx_tid[tid];
 
-- 
1.7.0.4

