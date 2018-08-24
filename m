Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:58114 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726513AbeHXOuR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 10:50:17 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 15/17] mt76: unify sta structure part 2
Date: Fri, 24 Aug 2018 13:15:19 +0200
Message-Id: <1535109321-17126-16-git-send-email-sgruszka@redhat.com> (sfid-20180824_131618_741986_E8BA81D0)
In-Reply-To: <1535109321-17126-1-git-send-email-sgruszka@redhat.com>
References: <1535109321-17126-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Second part of unifying mt76xx_sta structure between mt76x0 and mt76x2.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2.h          | 20 +++-----------------
 drivers/net/wireless/mediatek/mt76/mt76x2_common.c   | 12 ++++++------
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c     |  2 +-
 .../net/wireless/mediatek/mt76/mt76x2_init_common.c  |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c      |  4 ++--
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.h      | 11 -----------
 .../net/wireless/mediatek/mt76/mt76x2_mac_common.c   | 18 +++++++++---------
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c     |  2 +-
 .../net/wireless/mediatek/mt76/mt76x2_phy_common.c   |  4 ++--
 drivers/net/wireless/mediatek/mt76/mt76x2_trace.h    |  2 +-
 .../net/wireless/mediatek/mt76/mt76x2_tx_common.c    |  4 ++--
 drivers/net/wireless/mediatek/mt76/mt76x2u_core.c    |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76xx_mac.h      |  7 +++++++
 13 files changed, 36 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index 5d27d399bd16..d8f5b74d9225 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -27,7 +27,6 @@
 #include <linux/mutex.h>
 #include <linux/bitops.h>
 #include <linux/kfifo.h>
-#include <linux/average.h>
 
 #define MT7662_FIRMWARE		"mt7662.bin"
 #define MT7662_ROM_PATCH	"mt7662_rom_patch.bin"
@@ -51,8 +50,6 @@
 #include "mt76x2_mac.h"
 #include "mt76x2_dfs.h"
 
-DECLARE_EWMA(signal, 10, 8)
-
 struct mt76x2_mcu {
 	struct mutex mutex;
 
@@ -104,7 +101,7 @@ struct mt76x2_dev {
 	int txpower_cur;
 
 	u8 txdone_seq;
-	DECLARE_KFIFO_PTR(txstatus_fifo, struct mt76x2_tx_status);
+	DECLARE_KFIFO_PTR(txstatus_fifo, struct mt76xx_tx_status);
 
 	struct mt76x2_mcu mcu;
 	struct sk_buff *rx_head;
@@ -144,17 +141,6 @@ struct mt76x2_dev {
 	struct mt76x2_dfs_pattern_detector dfs_pd;
 };
 
-struct mt76x2_sta {
-	struct mt76_wcid wcid; /* must be first */
-
-	struct mt76xx_vif *vif;
-	struct mt76x2_tx_status status;
-	int n_frames;
-
-	struct ewma_signal rssi;
-	int inactive_count;
-};
-
 static inline bool is_mt7612(struct mt76x2_dev *dev)
 {
 	return mt76_chip(&dev->mt76) == 0x7612;
@@ -264,9 +250,9 @@ s8 mt76x2_tx_get_max_txpwr_adj(struct mt76x2_dev *dev,
 int mt76x2_insert_hdr_pad(struct sk_buff *skb);
 
 bool mt76x2_mac_load_tx_status(struct mt76x2_dev *dev,
-			       struct mt76x2_tx_status *stat);
+			       struct mt76xx_tx_status *stat);
 void mt76x2_send_tx_status(struct mt76x2_dev *dev,
-			   struct mt76x2_tx_status *stat, u8 *update);
+			   struct mt76xx_tx_status *stat, u8 *update);
 void mt76x2_reset_wlan(struct mt76x2_dev *dev, bool enable);
 void mt76x2_init_txpower(struct mt76x2_dev *dev,
 			 struct ieee80211_supported_band *sband);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
index 0b9a1f5103b5..3ccab59db30f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
@@ -24,7 +24,7 @@ int mt76x2_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	enum ieee80211_ampdu_mlme_action action = params->action;
 	struct ieee80211_sta *sta = params->sta;
 	struct mt76x2_dev *dev = hw->priv;
-	struct mt76x2_sta *msta = (struct mt76x2_sta *) sta->drv_priv;
+	struct mt76xx_sta *msta = (struct mt76xx_sta *) sta->drv_priv;
 	struct ieee80211_txq *txq = sta->txq[params->tid];
 	u16 tid = params->tid;
 	u16 *ssn = &params->ssn;
@@ -73,7 +73,7 @@ int mt76x2_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		   struct ieee80211_sta *sta)
 {
 	struct mt76x2_dev *dev = hw->priv;
-	struct mt76x2_sta *msta = (struct mt76x2_sta *) sta->drv_priv;
+	struct mt76xx_sta *msta = (struct mt76xx_sta *) sta->drv_priv;
 	struct mt76xx_vif *mvif = (struct mt76xx_vif *) vif->drv_priv;
 	int ret = 0;
 	int idx = 0;
@@ -114,7 +114,7 @@ int mt76x2_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		      struct ieee80211_sta *sta)
 {
 	struct mt76x2_dev *dev = hw->priv;
-	struct mt76x2_sta *msta = (struct mt76x2_sta *) sta->drv_priv;
+	struct mt76xx_sta *msta = (struct mt76xx_sta *) sta->drv_priv;
 	int idx = msta->wcid.idx;
 	int i;
 
@@ -146,7 +146,7 @@ int mt76x2_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 {
 	struct mt76x2_dev *dev = hw->priv;
 	struct mt76xx_vif *mvif = (struct mt76xx_vif *) vif->drv_priv;
-	struct mt76x2_sta *msta;
+	struct mt76xx_sta *msta;
 	struct mt76_wcid *wcid;
 	int idx = key->keyidx;
 	int ret;
@@ -173,7 +173,7 @@ int mt76x2_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	    !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
 		return -EOPNOTSUPP;
 
-	msta = sta ? (struct mt76x2_sta *) sta->drv_priv : NULL;
+	msta = sta ? (struct mt76xx_sta *) sta->drv_priv : NULL;
 	wcid = msta ? &msta->wcid : &mvif->group_wcid;
 
 	if (cmd == SET_KEY) {
@@ -256,7 +256,7 @@ void mt76x2_sta_rate_tbl_update(struct ieee80211_hw *hw,
 				struct ieee80211_sta *sta)
 {
 	struct mt76x2_dev *dev = hw->priv;
-	struct mt76x2_sta *msta = (struct mt76x2_sta *) sta->drv_priv;
+	struct mt76xx_sta *msta = (struct mt76xx_sta *) sta->drv_priv;
 	struct ieee80211_sta_rates *rates = rcu_dereference(sta->rates);
 	struct ieee80211_tx_rate rate = {};
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index de7f0fb64de9..b8dae71b5341 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -533,7 +533,7 @@ int mt76x2_register_device(struct mt76x2_dev *dev)
 	int fifo_size;
 	int i, ret;
 
-	fifo_size = roundup_pow_of_two(32 * sizeof(struct mt76x2_tx_status));
+	fifo_size = roundup_pow_of_two(32 * sizeof(struct mt76xx_tx_status));
 	status_fifo = devm_kzalloc(dev->mt76.dev, fifo_size, GFP_KERNEL);
 	if (!status_fifo)
 		return -ENOMEM;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
index 2a1ff7248d6b..953effec8c1a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
@@ -208,7 +208,7 @@ void mt76x2_init_device(struct mt76x2_dev *dev)
 	hw->max_rate_tries = 1;
 	hw->extra_tx_headroom = 2;
 
-	hw->sta_data_size = sizeof(struct mt76x2_sta);
+	hw->sta_data_size = sizeof(struct mt76xx_sta);
 	hw->vif_data_size = sizeof(struct mt76xx_vif);
 
 	ieee80211_hw_set(hw, SUPPORTS_HT_CCK_RATES);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
index 23cf437d14f9..3799ee47f7ed 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
@@ -30,7 +30,7 @@ void mt76x2_mac_set_bssid(struct mt76x2_dev *dev, u8 idx, const u8 *addr)
 
 void mt76x2_mac_poll_tx_status(struct mt76x2_dev *dev, bool irq)
 {
-	struct mt76x2_tx_status stat = {};
+	struct mt76xx_tx_status stat = {};
 	unsigned long flags;
 	u8 update = 1;
 	bool ret;
@@ -78,7 +78,7 @@ void mt76x2_mac_poll_tx_status(struct mt76x2_dev *dev, bool irq)
 
 void mt76x2_mac_process_tx_status_fifo(struct mt76x2_dev *dev)
 {
-	struct mt76x2_tx_status stat;
+	struct mt76xx_tx_status stat;
 	u8 update = 1;
 
 	while (kfifo_get(&dev->txstatus_fifo, &stat))
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
index bd85792e0717..c94d2bbe7072 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
@@ -25,17 +25,6 @@
 struct mt76xx_vif;
 struct mt76x2_txwi;
 
-struct mt76x2_tx_status {
-	u8 valid:1;
-	u8 success:1;
-	u8 aggr:1;
-	u8 ack_req:1;
-	u8 wcid;
-	u8 pktid;
-	u8 retry;
-	u16 rate;
-} __packed __aligned(2);
-
 struct mt76x2_tx_info {
 	unsigned long jiffies;
 	u8 tries;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
index f4ae0f157aaa..30745c2a35ef 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
@@ -54,7 +54,7 @@ void mt76x2_mac_stop(struct mt76x2_dev *dev, bool force)
 EXPORT_SYMBOL_GPL(mt76x2_mac_stop);
 
 bool mt76x2_mac_load_tx_status(struct mt76x2_dev *dev,
-			       struct mt76x2_tx_status *stat)
+			       struct mt76xx_tx_status *stat)
 {
 	u32 stat1, stat2;
 
@@ -138,7 +138,7 @@ bool mt76x2_mac_load_tx_status(struct mt76x2_dev *dev,
 static void
 mt76x2_mac_fill_tx_status(struct mt76x2_dev *dev,
 			  struct ieee80211_tx_info *info,
-			  struct mt76x2_tx_status *st, int n_frames)
+			  struct mt76xx_tx_status *st, int n_frames)
 {
 	struct ieee80211_tx_rate *rate = info->status.rates;
 	int cur_idx, last_rate;
@@ -178,12 +178,12 @@ bool mt76x2_mac_load_tx_status(struct mt76x2_dev *dev,
 }
 
 void mt76x2_send_tx_status(struct mt76x2_dev *dev,
-			   struct mt76x2_tx_status *stat, u8 *update)
+			   struct mt76xx_tx_status *stat, u8 *update)
 {
 	struct ieee80211_tx_info info = {};
 	struct ieee80211_sta *sta = NULL;
 	struct mt76_wcid *wcid = NULL;
-	struct mt76x2_sta *msta = NULL;
+	struct mt76xx_sta *msta = NULL;
 
 	rcu_read_lock();
 	if (stat->wcid < ARRAY_SIZE(dev->wcid))
@@ -192,7 +192,7 @@ void mt76x2_send_tx_status(struct mt76x2_dev *dev,
 	if (wcid) {
 		void *priv;
 
-		priv = msta = container_of(wcid, struct mt76x2_sta, wcid);
+		priv = msta = container_of(wcid, struct mt76xx_sta, wcid);
 		sta = container_of(priv, struct ieee80211_sta,
 				   drv_priv);
 	}
@@ -472,7 +472,7 @@ int mt76x2_mac_get_rssi(struct mt76x2_dev *dev, s8 rssi, int chain)
 	return rssi;
 }
 
-static struct mt76x2_sta *
+static struct mt76xx_sta *
 mt76x2_rx_get_sta(struct mt76x2_dev *dev, u8 idx)
 {
 	struct mt76_wcid *wcid;
@@ -484,11 +484,11 @@ int mt76x2_mac_get_rssi(struct mt76x2_dev *dev, s8 rssi, int chain)
 	if (!wcid)
 		return NULL;
 
-	return container_of(wcid, struct mt76x2_sta, wcid);
+	return container_of(wcid, struct mt76xx_sta, wcid);
 }
 
 static struct mt76_wcid *
-mt76x2_rx_get_sta_wcid(struct mt76x2_dev *dev, struct mt76x2_sta *sta,
+mt76x2_rx_get_sta_wcid(struct mt76x2_dev *dev, struct mt76xx_sta *sta,
 		       bool unicast)
 {
 	if (!sta)
@@ -505,7 +505,7 @@ int mt76x2_mac_process_rx(struct mt76x2_dev *dev, struct sk_buff *skb,
 {
 	struct mt76_rx_status *status = (struct mt76_rx_status *) skb->cb;
 	struct mt76x2_rxwi *rxwi = rxi;
-	struct mt76x2_sta *sta;
+	struct mt76xx_sta *sta;
 	u32 rxinfo = le32_to_cpu(rxwi->rxinfo);
 	u32 ctl = le32_to_cpu(rxwi->ctl);
 	u16 rate = le16_to_cpu(rxwi->rate);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index 2ed8279faf47..297f077b5945 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -202,7 +202,7 @@
 void
 mt76x2_sta_ps(struct mt76_dev *mdev, struct ieee80211_sta *sta, bool ps)
 {
-	struct mt76x2_sta *msta = (struct mt76x2_sta *) sta->drv_priv;
+	struct mt76xx_sta *msta = (struct mt76xx_sta *) sta->drv_priv;
 	struct mt76x2_dev *dev = container_of(mdev, struct mt76x2_dev, mt76);
 	int idx = msta->wcid.idx;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c
index 9fd6ab4cbb94..eb20f95fce9e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c
@@ -303,7 +303,7 @@ void mt76x2_phy_set_band(struct mt76x2_dev *dev, int band, bool primary_upper)
 
 int mt76x2_phy_get_min_avg_rssi(struct mt76x2_dev *dev)
 {
-	struct mt76x2_sta *sta;
+	struct mt76xx_sta *sta;
 	struct mt76_wcid *wcid;
 	int i, j, min_rssi = 0;
 	s8 cur_rssi;
@@ -325,7 +325,7 @@ int mt76x2_phy_get_min_avg_rssi(struct mt76x2_dev *dev)
 			if (!wcid)
 				continue;
 
-			sta = container_of(wcid, struct mt76x2_sta, wcid);
+			sta = container_of(wcid, struct mt76xx_sta, wcid);
 			spin_lock(&dev->mt76.rx_lock);
 			if (sta->inactive_count++ < 5)
 				cur_rssi = ewma_signal_read(&sta->rssi);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_trace.h b/drivers/net/wireless/mediatek/mt76/mt76x2_trace.h
index 4cd424148d4b..638aaa5cdf4a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_trace.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_trace.h
@@ -75,7 +75,7 @@
 
 TRACE_EVENT(mac_txstat_fetch,
 	TP_PROTO(struct mt76x2_dev *dev,
-		 struct mt76x2_tx_status *stat),
+		 struct mt76xx_tx_status *stat),
 
 	TP_ARGS(dev, stat),
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
index fb716f182d78..d57f729a77dc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
@@ -27,9 +27,9 @@ void mt76x2_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 	struct mt76_wcid *wcid = &dev->global_wcid;
 
 	if (control->sta) {
-		struct mt76x2_sta *msta;
+		struct mt76xx_sta *msta;
 
-		msta = (struct mt76x2_sta *)control->sta->drv_priv;
+		msta = (struct mt76xx_sta *)control->sta->drv_priv;
 		wcid = &msta->wcid;
 		/* sw encrypted frames */
 		if (!info->control.hw_key && wcid->hw_key_idx != 0xff)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
index 1ca5dd05b265..e99dc69c7469 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
@@ -66,7 +66,7 @@ static void mt76x2u_remove_dma_hdr(struct sk_buff *skb)
 bool mt76x2u_tx_status_data(struct mt76_dev *mdev, u8 *update)
 {
 	struct mt76x2_dev *dev = container_of(mdev, struct mt76x2_dev, mt76);
-	struct mt76x2_tx_status stat;
+	struct mt76xx_tx_status stat;
 
 	if (!mt76x2_mac_load_tx_status(dev, &stat))
 		return false;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76xx_mac.h b/drivers/net/wireless/mediatek/mt76/mt76xx_mac.h
index 8fa177f35b08..fea61b5b8310 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76xx_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76xx_mac.h
@@ -18,6 +18,8 @@
 #ifndef __MT76XX_MAC_H
 #define __MT76XX_MAC_H
 
+#include <linux/average.h>
+
 struct mt76xx_tx_status {
 	u8 valid:1;
 	u8 success:1;
@@ -35,12 +37,17 @@ struct mt76xx_vif {
 	struct mt76_wcid group_wcid;
 };
 
+DECLARE_EWMA(signal, 10, 8);
+
 struct mt76xx_sta {
 	struct mt76_wcid wcid; /* must be first */
 
 	struct mt76xx_vif *vif;
 	struct mt76xx_tx_status status;
 	int n_frames;
+
+	struct ewma_signal rssi;
+	int inactive_count;
 };
 
 static inline bool mt76xx_wait_for_mac(struct mt76_dev *dev)
-- 
1.9.3
