Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14621 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbaFPQi6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 12:38:58 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 25/25] wil6210: track Tx queue state
Date: Mon, 16 Jun 2014 19:37:23 +0300
Message-ID: <1402936643-31819-26-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140616_190457_555505_FF628682)
In-Reply-To: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Provide both event (netif_tx_[stop|wake]) tracking via printk;
and state via debugfs 'info'

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 16 ++++++++++++++++
 drivers/net/wireless/ath/wil6210/main.c    |  2 ++
 drivers/net/wireless/ath/wil6210/txrx.c    |  8 ++++++--
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 94ac69a..7d1ef4e 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -859,6 +859,7 @@ static int wil_info_debugfs_show(struct seq_file *s, void *data)
 	static ulong rxf_old, txf_old;
 	ulong rxf = ndev->stats.rx_packets;
 	ulong txf = ndev->stats.tx_packets;
+	unsigned int i;
 
 	/* >0 : AC; 0 : battery; <0 : error */
 	seq_printf(s, "AC powered : %d\n", is_ac);
@@ -867,6 +868,21 @@ static int wil_info_debugfs_show(struct seq_file *s, void *data)
 	rxf_old = rxf;
 	txf_old = txf;
 
+
+#define CHECK_QSTATE(x) (state & BIT(__QUEUE_STATE_ ## x)) ? \
+	" " __stringify(x) : ""
+
+	for (i = 0; i < ndev->num_tx_queues; i++) {
+		struct netdev_queue *txq = netdev_get_tx_queue(ndev, i);
+		unsigned long state = txq->state;
+
+		seq_printf(s, "Tx queue[%i] state : 0x%lx%s%s%s\n", i, state,
+			   CHECK_QSTATE(DRV_XOFF),
+			   CHECK_QSTATE(STACK_XOFF),
+			   CHECK_QSTATE(FROZEN)
+			  );
+	}
+#undef CHECK_QSTATE
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 6cc4791..53a689e 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -473,6 +473,7 @@ void wil_link_on(struct wil6210_priv *wil)
 	wil_dbg_misc(wil, "%s()\n", __func__);
 
 	netif_carrier_on(ndev);
+	wil_dbg_misc(wil, "netif_tx_wake : link on\n");
 	netif_tx_wake_all_queues(ndev);
 }
 
@@ -483,6 +484,7 @@ void wil_link_off(struct wil6210_priv *wil)
 	wil_dbg_misc(wil, "%s()\n", __func__);
 
 	netif_tx_stop_all_queues(ndev);
+	wil_dbg_misc(wil, "netif_tx_stop : link off\n");
 	netif_carrier_off(ndev);
 }
 
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index c06d74a..af4b93e 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -1038,8 +1038,10 @@ netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	rc = wil_tx_vring(wil, vring, skb);
 
 	/* do we still have enough room in the vring? */
-	if (wil_vring_avail_tx(vring) < wil_vring_wmark_low(vring))
+	if (wil_vring_avail_tx(vring) < wil_vring_wmark_low(vring)) {
 		netif_tx_stop_all_queues(wil_to_ndev(wil));
+		wil_dbg_txrx(wil, "netif_tx_stop : ring full\n");
+	}
 
 	switch (rc) {
 	case 0:
@@ -1153,8 +1155,10 @@ int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 		txdata->last_idle = get_cycles();
 	}
 
-	if (wil_vring_avail_tx(vring) > wil_vring_wmark_high(vring))
+	if (wil_vring_avail_tx(vring) > wil_vring_wmark_high(vring)) {
+		wil_dbg_txrx(wil, "netif_tx_wake : ring not full\n");
 		netif_tx_wake_all_queues(wil_to_ndev(wil));
+	}
 
 	return done;
 }
-- 
1.9.1

