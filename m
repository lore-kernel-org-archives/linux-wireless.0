Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.9]:12427 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbbGaNFA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 09:05:00 -0400
From: Jakub Kicinski <moorray3@wp.pl>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jakub Kicinski <kubakici@wp.pl>
Subject: [PATCH -next 4/4] mt7601u: lock out rx path and tx status reporting
Date: Fri, 31 Jul 2015 15:04:49 +0200
Message-Id: <1438347889-14669-4-git-send-email-moorray3@wp.pl> (sfid-20150731_150518_362021_9308D9FE)
In-Reply-To: <1438347889-14669-1-git-send-email-moorray3@wp.pl>
References: <1438347889-14669-1-git-send-email-moorray3@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jakub Kicinski <kubakici@wp.pl>

mac80211 requires that rx path does not run concurrently with
tx status reporting.  Add a spinlock which will ensure that.

Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
---
 drivers/net/wireless/mediatek/mt7601u/dma.c     | 2 ++
 drivers/net/wireless/mediatek/mt7601u/init.c    | 1 +
 drivers/net/wireless/mediatek/mt7601u/mac.c     | 4 ++--
 drivers/net/wireless/mediatek/mt7601u/mt7601u.h | 4 +++-
 drivers/net/wireless/mediatek/mt7601u/tx.c      | 3 +++
 5 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/dma.c b/drivers/net/wireless/mediatek/mt7601u/dma.c
index 63c485443a38..57a80cfa39b1 100644
--- a/drivers/net/wireless/mediatek/mt7601u/dma.c
+++ b/drivers/net/wireless/mediatek/mt7601u/dma.c
@@ -112,7 +112,9 @@ static void mt7601u_rx_process_seg(struct mt7601u_dev *dev, u8 *data,
 	if (!skb)
 		return;
 
+	spin_lock(&dev->mac_lock);
 	ieee80211_rx(dev->hw, skb);
+	spin_unlock(&dev->mac_lock);
 }
 
 static u16 mt7601u_rx_next_seg_len(u8 *data, u32 data_len)
diff --git a/drivers/net/wireless/mediatek/mt7601u/init.c b/drivers/net/wireless/mediatek/mt7601u/init.c
index 38eb20ba6e58..26190fd33407 100644
--- a/drivers/net/wireless/mediatek/mt7601u/init.c
+++ b/drivers/net/wireless/mediatek/mt7601u/init.c
@@ -454,6 +454,7 @@ struct mt7601u_dev *mt7601u_alloc_device(struct device *pdev)
 	spin_lock_init(&dev->tx_lock);
 	spin_lock_init(&dev->rx_lock);
 	spin_lock_init(&dev->lock);
+	spin_lock_init(&dev->mac_lock);
 	spin_lock_init(&dev->con_mon_lock);
 	atomic_set(&dev->avg_ampdu_len, 1);
 	skb_queue_head_init(&dev->tx_skb_done);
diff --git a/drivers/net/wireless/mediatek/mt7601u/mac.c b/drivers/net/wireless/mediatek/mt7601u/mac.c
index e3928cfa3d63..e21c53ed09fb 100644
--- a/drivers/net/wireless/mediatek/mt7601u/mac.c
+++ b/drivers/net/wireless/mediatek/mt7601u/mac.c
@@ -182,9 +182,9 @@ void mt76_send_tx_status(struct mt7601u_dev *dev, struct mt76_tx_status *stat)
 
 	mt76_mac_fill_tx_status(dev, &info, stat);
 
-	local_bh_disable();
+	spin_lock_bh(&dev->mac_lock);
 	ieee80211_tx_status_noskb(dev->hw, sta, &info);
-	local_bh_enable();
+	spin_unlock_bh(&dev->mac_lock);
 
 	rcu_read_unlock();
 }
diff --git a/drivers/net/wireless/mediatek/mt7601u/mt7601u.h b/drivers/net/wireless/mediatek/mt7601u/mt7601u.h
index bc5e294feb8c..428bd2f10b7b 100644
--- a/drivers/net/wireless/mediatek/mt7601u/mt7601u.h
+++ b/drivers/net/wireless/mediatek/mt7601u/mt7601u.h
@@ -141,8 +141,9 @@ enum {
 /**
  * struct mt7601u_dev - adapter structure
  * @lock:		protects @wcid->tx_rate.
+ * @mac_lock:		locks out mac80211's tx status and rx paths.
  * @tx_lock:		protects @tx_q and changes of MT7601U_STATE_*_STATS
-			flags in @state.
+ *			flags in @state.
  * @rx_lock:		protects @rx_q.
  * @con_mon_lock:	protects @ap_bssid, @bcn_*, @avg_rssi.
  * @mutex:		ensures exclusive access from mac80211 callbacks.
@@ -177,6 +178,7 @@ struct mt7601u_dev {
 	struct mt76_wcid __rcu *wcid[N_WCIDS];
 
 	spinlock_t lock;
+	spinlock_t mac_lock;
 
 	const u16 *beacon_offsets;
 
diff --git a/drivers/net/wireless/mediatek/mt7601u/tx.c b/drivers/net/wireless/mediatek/mt7601u/tx.c
index 0be2080ceab3..a0a33dc8f6bc 100644
--- a/drivers/net/wireless/mediatek/mt7601u/tx.c
+++ b/drivers/net/wireless/mediatek/mt7601u/tx.c
@@ -116,7 +116,10 @@ void mt7601u_tx_status(struct mt7601u_dev *dev, struct sk_buff *skb)
 	ieee80211_tx_info_clear_status(info);
 	info->status.rates[0].idx = -1;
 	info->flags |= IEEE80211_TX_STAT_ACK;
+
+	spin_lock(&dev->mac_lock);
 	ieee80211_tx_status(dev->hw, skb);
+	spin_unlock(&dev->mac_lock);
 }
 
 static int mt7601u_skb_rooms(struct mt7601u_dev *dev, struct sk_buff *skb)
-- 
2.1.0

