Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1254 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932315Ab1JYKO5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 06:14:57 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <nataraja@qca.qualcomm.com>,
	<athiruve@qca.qualcomm.com>
Subject: [PATCH 12/34] ath6kl: Move aggregation information to vif structure
Date: Tue, 25 Oct 2011 15:40:08 +0530
Message-ID: <1319537430-12459-13-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_122050_008785_CBA15A34)
In-Reply-To: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    8 ++++----
 drivers/net/wireless/ath/ath6kl/core.h     |    2 +-
 drivers/net/wireless/ath/ath6kl/main.c     |    4 ++--
 drivers/net/wireless/ath/ath6kl/txrx.c     |   10 +++++++---
 4 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 092b731..1e33e79 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2063,8 +2063,8 @@ static int ath6kl_init_if_data(struct ath6kl *ar, struct net_device *ndev)
 {
 	struct ath6kl_vif *vif = netdev_priv(ndev);
 
-	ar->aggr_cntxt = aggr_init(ndev);
-	if (!ar->aggr_cntxt) {
+	vif->aggr_cntxt = aggr_init(ndev);
+	if (!vif->aggr_cntxt) {
 		ath6kl_err("failed to initialize aggr\n");
 		return -ENOMEM;
 	}
@@ -2080,9 +2080,9 @@ void ath6kl_deinit_if_data(struct ath6kl *ar, struct net_device *ndev)
 {
 	struct ath6kl_vif *vif = netdev_priv(ndev);
 
-	aggr_module_destroy(ar->aggr_cntxt);
+	aggr_module_destroy(vif->aggr_cntxt);
 
-	ar->aggr_cntxt = NULL;
+	vif->aggr_cntxt = NULL;
 
 	if (test_bit(NETDEV_REGISTERED, &vif->flags)) {
 		unregister_netdev(ndev);
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index d461813..cef4251 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -415,6 +415,7 @@ struct ath6kl_vif {
 	u16 bss_ch;
 	struct ath6kl_wep_key wep_key_list[WMI_MAX_KEY_INDEX + 1];
 	struct ath6kl_key keys[WMI_MAX_KEY_INDEX + 1];
+	struct aggr_info *aggr_cntxt;
 };
 
 /* Flag info */
@@ -473,7 +474,6 @@ struct ath6kl {
 	struct sk_buff_head mcastpsq;
 	spinlock_t mcastpsq_lock;
 	u8 intra_bss;
-	struct aggr_info *aggr_cntxt;
 	struct wmi_ap_mode_stat ap_stats;
 	u8 ap_country_code[3];
 	struct list_head amsdu_rx_buffer_queue;
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 0b70e08..48a7e57 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -792,7 +792,7 @@ void ath6kl_connect_event(struct ath6kl *ar, u16 channel, u8 *bssid,
 	netif_carrier_on(ar->net_dev);
 	spin_unlock_bh(&ar->lock);
 
-	aggr_reset_state(ar->aggr_cntxt);
+	aggr_reset_state(vif->aggr_cntxt);
 	ar->reconnect_flag = 0;
 
 	if ((vif->nw_type == ADHOC_NETWORK) && ar->ibss_ps_enable) {
@@ -1113,7 +1113,7 @@ void ath6kl_disconnect_event(struct ath6kl *ar, u8 reason, u8 *bssid,
 				       assoc_resp_len, assoc_info,
 				       prot_reason_status);
 
-	aggr_reset_state(ar->aggr_cntxt);
+	aggr_reset_state(vif->aggr_cntxt);
 
 	del_timer(&ar->disconnect_timer);
 
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 6b1795c..ba1678e 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -1268,7 +1268,7 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 	datap = (struct ethhdr *) skb->data;
 
 	if (is_unicast_ether_addr(datap->h_dest) &&
-	    aggr_process_recv_frm(ar->aggr_cntxt, tid, seq_no,
+	    aggr_process_recv_frm(vif->aggr_cntxt, tid, seq_no,
 				  is_amsdu, skb))
 		/* aggregation code will handle the skb */
 		return;
@@ -1353,7 +1353,9 @@ static void aggr_delete_tid_state(struct aggr_info *p_aggr, u8 tid)
 
 void aggr_recv_addba_req_evt(struct ath6kl *ar, u8 tid, u16 seq_no, u8 win_sz)
 {
-	struct aggr_info *p_aggr = ar->aggr_cntxt;
+	/* TODO: Findout vif */
+	struct ath6kl_vif *vif = ar->vif;
+	struct aggr_info *p_aggr = vif->aggr_cntxt;
 	struct rxtid *rxtid;
 	struct rxtid_stats *stats;
 	u16 hold_q_size;
@@ -1422,7 +1424,9 @@ struct aggr_info *aggr_init(struct net_device *dev)
 
 void aggr_recv_delba_req_evt(struct ath6kl *ar, u8 tid)
 {
-	struct aggr_info *p_aggr = ar->aggr_cntxt;
+	/* TODO: Findout vif */
+	struct ath6kl_vif *vif = ar->vif;
+	struct aggr_info *p_aggr = vif->aggr_cntxt;
 	struct rxtid *rxtid;
 
 	if (!p_aggr)
-- 
1.7.0.4

