Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11758 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932362Ab1JYKO6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 06:14:58 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <nataraja@qca.qualcomm.com>,
	<athiruve@qca.qualcomm.com>
Subject: [PATCH 24/34] ath6kl: Introduce spinlock to protect vif specific information
Date: Tue, 25 Oct 2011 15:40:20 +0530
Message-ID: <1319537430-12459-25-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_122049_730589_DFEE0447)
In-Reply-To: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use this spinlock to protect the vif's data instead of
one from ath6kl.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    1 +
 drivers/net/wireless/ath/ath6kl/core.h     |    2 ++
 drivers/net/wireless/ath/ath6kl/main.c     |   13 ++++---------
 drivers/net/wireless/ath/ath6kl/txrx.c     |    8 ++++----
 4 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 067d2d2..722deb5 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2077,6 +2077,7 @@ static int ath6kl_init_if_data(struct ath6kl *ar, struct net_device *ndev)
 	setup_timer(&vif->disconnect_timer, disconnect_timer_handler,
 		    (unsigned long) ndev);
 	set_bit(WMM_ENABLED, &vif->flags);
+	spin_lock_init(&vif->if_lock);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index de4af5c..1668ac5 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -400,6 +400,8 @@ struct ath6kl_vif {
 	struct wireless_dev wdev;
 	struct net_device *ndev;
 	struct ath6kl *ar;
+	/* Lock to protect vif specific net_stats and flags */
+	spinlock_t if_lock;
 	u8 fw_vif_idx;
 	unsigned long flags;
 	int ssid_len;
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index dd3cfeb..6a555ee 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -708,11 +708,11 @@ void ath6kl_connect_event(struct ath6kl_vif *vif, u16 channel, u8 *bssid,
 	netif_wake_queue(vif->ndev);
 
 	/* Update connect & link status atomically */
-	spin_lock_bh(&ar->lock);
+	spin_lock_bh(&vif->if_lock);
 	set_bit(CONNECTED, &vif->flags);
 	clear_bit(CONNECT_PEND, &vif->flags);
 	netif_carrier_on(vif->ndev);
-	spin_unlock_bh(&ar->lock);
+	spin_unlock_bh(&vif->if_lock);
 
 	aggr_reset_state(vif->aggr_cntxt);
 	vif->reconnect_flag = 0;
@@ -1063,10 +1063,10 @@ void ath6kl_disconnect_event(struct ath6kl_vif *vif, u8 reason, u8 *bssid,
 	}
 
 	/* update connect & link status atomically */
-	spin_lock_bh(&ar->lock);
+	spin_lock_bh(&vif->if_lock);
 	clear_bit(CONNECTED, &vif->flags);
 	netif_carrier_off(vif->ndev);
-	spin_unlock_bh(&ar->lock);
+	spin_unlock_bh(&vif->if_lock);
 
 	if ((reason != CSERV_DISCONNECT) || (vif->reconnect_flag != 1))
 		vif->reconnect_flag = 0;
@@ -1083,11 +1083,8 @@ void ath6kl_disconnect_event(struct ath6kl_vif *vif, u8 reason, u8 *bssid,
 
 static int ath6kl_open(struct net_device *dev)
 {
-	struct ath6kl *ar = ath6kl_priv(dev);
 	struct ath6kl_vif *vif = netdev_priv(dev);
 
-	spin_lock_bh(&ar->lock);
-
 	set_bit(WLAN_ENABLED, &vif->flags);
 
 	if (test_bit(CONNECTED, &vif->flags)) {
@@ -1096,8 +1093,6 @@ static int ath6kl_open(struct net_device *dev)
 	} else
 		netif_carrier_off(dev);
 
-	spin_unlock_bh(&ar->lock);
-
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index e4a6d8f..ff288da 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -475,9 +475,9 @@ enum htc_send_full_action ath6kl_tx_queue_full(struct htc_target *target,
 		return HTC_SEND_FULL_DROP;
 
 stop_net_queues:
-	spin_lock_bh(&ar->lock);
+	spin_lock_bh(&vif->if_lock);
 	set_bit(NETQ_STOPPED, &vif->flags);
-	spin_unlock_bh(&ar->lock);
+	spin_unlock_bh(&vif->if_lock);
 	netif_stop_queue(vif->ndev);
 
 	return HTC_SEND_FULL_KEEP;
@@ -1103,12 +1103,12 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 	 * Take lock to protect buffer counts and adaptive power throughput
 	 * state.
 	 */
-	spin_lock_bh(&ar->lock);
+	spin_lock_bh(&vif->if_lock);
 
 	vif->net_stats.rx_packets++;
 	vif->net_stats.rx_bytes += packet->act_len;
 
-	spin_unlock_bh(&ar->lock);
+	spin_unlock_bh(&vif->if_lock);
 
 
 	ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, __func__, "rx ",
-- 
1.7.0.4

