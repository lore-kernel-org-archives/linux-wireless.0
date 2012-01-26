Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44456 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab2AZHr1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 02:47:27 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH V2] ath6kl: Fix kernel panic during rx aggregation
Date: Thu, 26 Jan 2012 13:17:18 +0530
Message-ID: <1327564038-2455-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120126_084742_653086_E555A7BE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"ath6kl: Define a structure for connection specific aggregation information"
introduces this. In aggr_conn_init(), vif->aggr_cntxt is assigned to
aggr_conn->aggr_info, but vif->aggr_cntxt is not initialized at this
point, this would end up accessing an invalid pointer in aggregation
receive path. Fix this by passing the correct aggr_info to aggr_conn_init().
The panic trace would look like.

[<ffffffff8159e02e>] panic+0xa1/0x1c6
[<ffffffff8103773d>] ? kmsg_dump+0xfd/0x160
[<ffffffff815a2f6a>] oops_end+0xea/0xf0
[<ffffffff8102b95d>] no_context+0x11d/0x2d0
[<ffffffff8102bc5d>] __bad_area_nosemaphore+0x14d/0x230
[<ffffffff815a5c4d>] ? do_page_fault+0x30d/0x520
[<ffffffff8102bd53>] bad_area_nosemaphore+0x13/0x20
[<ffffffff815a5cfd>] do_page_fault+0x3bd/0x520
[<ffffffff8108bd60>] ? __lock_acquire+0x320/0x1680
[<ffffffff812e3a9d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[<ffffffff815a2385>] page_fault+0x25/0x30
[<ffffffffa0487a5f>] ? aggr_slice_amsdu+0xdf/0x170 [ath6kl_core]
[<ffffffffa0487bac>] aggr_deque_frms+0xbc/0x190 [ath6kl_core]
[<ffffffffa0488404>] ath6kl_rx+0x3e4/0xae0 [ath6kl_core]
[<ffffffffa047ae77>] ath6kl_htc_rxmsg_pending_handler+0x8b7/0xf10 [ath6kl_core]
[<ffffffffa00c82f0>] ? mmc_do_release_host+0x70/0x90 [mmc_core]
[<ffffffffa00c833a>] ? mmc_release_host+0x2a/0x50 [mmc_core]
[<ffffffffa04865c0>] ? ath6kl_alloc_amsdu_rxbuf+0x140/0x140 [ath6kl_core]
[<ffffffffa0477772>] ath6kl_hif_intr_bh_handler+0x362/0x510 [ath6kl_core]
[<ffffffffa01f1000>] ath6kl_sdio_irq_handler+0x60/0xb0 [ath6kl_sdio]
[<ffffffffa00d30bc>] sdio_irq_thread+0xec/0x320 [mmc_core]
[<ffffffffa00d2fd0>] ? sdio_claim_irq+0x220/0x220 [mmc_core]
[<ffffffffa00d2fd0>] ? sdio_claim_irq+0x220/0x220 [mmc_core]
[<ffffffff8105b21e>] kthread+0xbe/0xd0
[<ffffffff815ab574>] kernel_thread_helper+0x4/0x10
[<ffffffff815a2174>] ? retint_restore_args+0x13/0x13
[<ffffffff8105b160>] ? __init_kthread_worker+0x70/0x70
[<ffffffff815ab570>] ? gs_change+0x13/0x13

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
V2 - Remove unnecessary reference to AP mode in commit log

 drivers/net/wireless/ath/ath6kl/core.h |    3 ++-
 drivers/net/wireless/ath/ath6kl/main.c |    2 +-
 drivers/net/wireless/ath/ath6kl/txrx.c |    7 ++++---
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index ed9fcc1..9c6aec6 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -714,7 +714,8 @@ void ath6kl_free_cookie(struct ath6kl *ar, struct ath6kl_cookie *cookie);
 int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev);
 
 struct aggr_info *aggr_init(struct ath6kl_vif *vif);
-void aggr_conn_init(struct ath6kl_vif *vif, struct aggr_info_conn *aggr_conn);
+void aggr_conn_init(struct ath6kl_vif *vif, struct aggr_info *aggr_info,
+		    struct aggr_info_conn *aggr_conn);
 void ath6kl_rx_refill(struct htc_target *target,
 		      enum htc_endpoint_id endpoint);
 void ath6kl_refill_amsdu_rxbufs(struct ath6kl *ar, int count);
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 39da1f9..b96d01a 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -74,7 +74,7 @@ static void ath6kl_add_new_sta(struct ath6kl_vif *vif, u8 *mac, u16 aid,
 
 	ar->sta_list_index = ar->sta_list_index | (1 << free_slot);
 	ar->ap_stats.sta[free_slot].aid = cpu_to_le32(aid);
-	aggr_conn_init(vif, sta->aggr_conn);
+	aggr_conn_init(vif, vif->aggr_cntxt, sta->aggr_conn);
 }
 
 static void ath6kl_sta_cleanup(struct ath6kl *ar, u8 i)
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 62c1210..a3dc694 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -1674,7 +1674,8 @@ void aggr_recv_addba_req_evt(struct ath6kl_vif *vif, u8 tid_mux, u16 seq_no,
 	rxtid->aggr = true;
 }
 
-void aggr_conn_init(struct ath6kl_vif *vif, struct aggr_info_conn *aggr_conn)
+void aggr_conn_init(struct ath6kl_vif *vif, struct aggr_info *aggr_info,
+		    struct aggr_info_conn *aggr_conn)
 {
 	struct rxtid *rxtid;
 	u8 i;
@@ -1684,7 +1685,7 @@ void aggr_conn_init(struct ath6kl_vif *vif, struct aggr_info_conn *aggr_conn)
 	init_timer(&aggr_conn->timer);
 	aggr_conn->timer.function = aggr_timeout;
 	aggr_conn->timer.data = (unsigned long) aggr_conn;
-	aggr_conn->aggr_info = vif->aggr_cntxt;
+	aggr_conn->aggr_info = aggr_info;
 
 	aggr_conn->timer_scheduled = false;
 
@@ -1716,7 +1717,7 @@ struct aggr_info *aggr_init(struct ath6kl_vif *vif)
 		return NULL;
 	}
 
-	aggr_conn_init(vif, p_aggr->aggr_conn);
+	aggr_conn_init(vif, p_aggr, p_aggr->aggr_conn);
 
 	skb_queue_head_init(&p_aggr->rx_amsdu_freeq);
 	ath6kl_alloc_netbufs(&p_aggr->rx_amsdu_freeq, AGGR_NUM_OF_FREE_NETBUFS);
-- 
1.7.0.4

