Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:4183 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584AbaFPQiX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 12:38:23 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 07/25] wil6210: Tx performance monitoring
Date: Mon, 16 Jun 2014 19:37:05 +0300
Message-ID: <1402936643-31819-8-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140616_183830_612184_089FC0EE)
In-Reply-To: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For performance monitoring, trace time intervals when Tx vring
is idle/not idle. Use CPU cycle counter for this, because jiffies is
too rough, and other precise time measurement methods involve
overhead while get_cycles() should be fast.
This used to provide some estimation for percentage when Tx vring
was idle, i.e. when hardware is under-utilized.
Estimation is not precise because of many reasons - CPU frequency scaling,
grt_cycles() may be per core etc. But still, it is good estimation

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 16 ++++++++++++++--
 drivers/net/wireless/ath/wil6210/txrx.c    |  8 +++++++-
 drivers/net/wireless/ath/wil6210/wil6210.h |  3 ++-
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index d90aa28..9c11023 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -69,6 +69,8 @@ static int wil_vring_debugfs_show(struct seq_file *s, void *data)
 
 	for (i = 0; i < ARRAY_SIZE(wil->vring_tx); i++) {
 		struct vring *vring = &(wil->vring_tx[i]);
+		struct vring_tx_data *txdata = &wil->vring_tx_data[i];
+
 		if (vring->va) {
 			int cid = wil->vring2cid_tid[i][0];
 			int tid = wil->vring2cid_tid[i][1];
@@ -78,10 +80,20 @@ static int wil_vring_debugfs_show(struct seq_file *s, void *data)
 				   % vring->size;
 			int avail = vring->size - used - 1;
 			char name[10];
+			/* performance monitoring */
+			cycles_t now = get_cycles();
+			cycles_t idle = txdata->idle;
+			cycles_t total = now - txdata->begin;
+
+			txdata->begin = now;
+			txdata->idle = 0ULL;
+
 			snprintf(name, sizeof(name), "tx_%2d", i);
 
-			seq_printf(s, "\n%pM CID %d TID %d [%3d|%3d]\n",
-				   wil->sta[cid].addr, cid, tid, used, avail);
+			seq_printf(s, "\n%pM CID %d TID %d [%3d|%3d] idle %3d%%\n",
+				   wil->sta[cid].addr, cid, tid, used, avail,
+				   (int)((idle*100)/total));
+
 			wil_print_vring(s, wil, name, vring, '_', 'H');
 		}
 	}
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index c08d041..0318cd2 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -881,6 +881,7 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	int nr_frags = skb_shinfo(skb)->nr_frags;
 	uint f = 0;
 	int vring_index = vring - wil->vring_tx;
+	struct vring_tx_data *txdata = &wil->vring_tx_data[vring_index];
 	uint i = swhead;
 	dma_addr_t pa;
 
@@ -953,6 +954,9 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	wil_hex_dump_txrx("Tx ", DUMP_PREFIX_NONE, 32, 4,
 			  (const void *)d, sizeof(*d), false);
 
+	if (wil_vring_is_empty(vring)) /* performance monitoring */
+		txdata->idle += get_cycles() - txdata->last_idle;
+
 	/* advance swhead */
 	wil_vring_advance_head(vring, nr_frags + 1);
 	wil_dbg_txrx(wil, "Tx swhead %d -> %d\n", swhead, vring->swhead);
@@ -1133,8 +1137,10 @@ int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 		}
 	}
 
-	if (wil_vring_is_empty(vring))
+	if (wil_vring_is_empty(vring)) { /* performance monitoring */
 		wil_dbg_txrx(wil, "Ring[%2d] empty\n", ringid);
+		txdata->last_idle = get_cycles();
+	}
 
 	if (wil_vring_avail_tx(vring) > wil_vring_wmark_high(vring))
 		netif_tx_wake_all_queues(wil_to_ndev(wil));
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 793675e..ede4c9f 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -20,6 +20,7 @@
 #include <linux/netdevice.h>
 #include <linux/wireless.h>
 #include <net/cfg80211.h>
+#include <linux/timex.h>
 
 #define WIL_NAME "wil6210"
 
@@ -251,7 +252,7 @@ struct vring {
  */
 struct vring_tx_data {
 	int enabled;
-
+	cycles_t idle, last_idle, begin;
 };
 
 enum { /* for wil6210_priv.status */
-- 
1.9.1

