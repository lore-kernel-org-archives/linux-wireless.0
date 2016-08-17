Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27159 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbcHQPdN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2016 11:33:13 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
	"Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>
Subject: [PATCH] ath10k: improve wake_tx_queue ops performance
Date: Wed, 17 Aug 2016 21:02:53 +0530
Message-ID: <20160817153253.6615-1-rmanohar@qti.qualcomm.com> (sfid-20160817_173328_485262_DC1EF39C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

txqs_lock is interfering with wake_tx_queue submitting more frames.
so queues don't get filled in and don't keep firmware/hardware busy
enough. This change helps to reduce the txqs_lock contention and
wake_tx_queue() blockage to being possible in txrx_unref().

To reduce turn around time of wake_tx_queue ops and to maintain fairness
among all txqs, the callback is updated to push first txq alone from
pending list for every wake_tx_queue call. Remaining txqs will be
processed later upon tx completion.

Below improvements are observed in push-only mode and validated on
IPQ4019 platform. With this change, in AP mode ~10Mbps increase is
observed in downlink (AP -> STA) traffic and approx. 5-10% of CPU
usage is reduced.

Major improvement is observed in 1-hop Mesh mode topology in 11ACVHT80.
Compared to Infra mode, CPU overhead is higher in Mesh mode due to path
lookup and no fast-xmit support. So reducing spin lock contention is
helping in Mesh.

             TOT       +change
           --------    --------
TCP DL     545 Mbps    595 Mbps
TCP UL     555 Mbps    585 Mbps

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index c7c7ceb9be73..93465ffec2eb 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4106,13 +4106,29 @@ static void ath10k_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
 {
 	struct ath10k *ar = hw->priv;
 	struct ath10k_txq *artxq = (void *)txq->drv_priv;
+	struct ieee80211_txq *f_txq;
+	struct ath10k_txq *f_artxq;
+	int ret = 0;
+	int max = 16;
 
 	spin_lock_bh(&ar->txqs_lock);
 	if (list_empty(&artxq->list))
 		list_add_tail(&artxq->list, &ar->txqs);
+
+	f_artxq = list_first_entry(&ar->txqs, struct ath10k_txq, list);
+	f_txq = container_of((void *)f_artxq, struct ieee80211_txq, drv_priv);
+	list_del_init(&f_artxq->list);
+
+	while (ath10k_mac_tx_can_push(hw, f_txq) && max--) {
+		ret = ath10k_mac_tx_push_txq(hw, f_txq);
+		if (ret)
+			break;
+	}
+	if (ret != -ENOENT)
+		list_add_tail(&f_artxq->list, &ar->txqs);
 	spin_unlock_bh(&ar->txqs_lock);
 
-	ath10k_mac_tx_push_pending(ar);
+	ath10k_htt_tx_txq_update(hw, f_txq);
 	ath10k_htt_tx_txq_update(hw, txq);
 }
 
-- 
2.9.2
