Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36961 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab1BXNmJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Feb 2011 08:42:09 -0500
Subject: [PATCH] mac80211: make tx() operation return void
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Feb 2011 14:42:06 +0100
Message-ID: <1298554926.4775.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The return value of the tx operation is commonly
misused by drivers, leading to errors. All drivers
will drop frames if they fail to TX the frame, and
they must also properly manage the queues (if they
didn't, mac80211 would already warn).

Removing the ability for drivers to return a BUSY
value also allows significant cleanups of the TX
TX handling code in mac80211.

Note that this also fixes a bug in ath9k_htc, the
old "return -1" there was wrong.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Tested-by: Sedat Dilek <sedat.dilek@googlemail.com> [ath5k]
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com> [rt2x00]
Acked-by: Larry Finger <Larry.Finger@lwfinger.net> [b43, rtl8187, rtlwifi]
Acked-by: Luciano Coelho <coelho@ti.com> [wl12xx]
---
I've fixed, but not even compiled, the staging drivers.

 drivers/net/wireless/adm8211.c                |    4 
 drivers/net/wireless/at76c50x-usb.c           |    7 -
 drivers/net/wireless/ath/ar9170/ar9170.h      |    2 
 drivers/net/wireless/ath/ar9170/main.c        |    5 
 drivers/net/wireless/ath/ath5k/ath5k.h        |    4 
 drivers/net/wireless/ath/ath5k/base.c         |    5 
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |    6 
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    7 -
 drivers/net/wireless/ath/ath9k/main.c         |    6 
 drivers/net/wireless/ath/carl9170/carl9170.h  |    2 
 drivers/net/wireless/ath/carl9170/tx.c        |    5 
 drivers/net/wireless/b43/main.c               |    6 
 drivers/net/wireless/b43legacy/main.c         |    5 
 drivers/net/wireless/iwlegacy/iwl-4965.h      |    2 
 drivers/net/wireless/iwlegacy/iwl3945-base.c  |    3 
 drivers/net/wireless/iwlegacy/iwl4965-base.c  |    3 
 drivers/net/wireless/iwlwifi/iwl-agn.c        |    3 
 drivers/net/wireless/iwlwifi/iwl-agn.h        |    2 
 drivers/net/wireless/libertas_tf/main.c       |    3 
 drivers/net/wireless/mac80211_hwsim.c         |    5 
 drivers/net/wireless/mwl8k.c                  |   15 --
 drivers/net/wireless/p54/lmac.h               |    2 
 drivers/net/wireless/p54/main.c               |    2 
 drivers/net/wireless/p54/txrx.c               |   11 -
 drivers/net/wireless/rt2x00/rt2x00.h          |    2 
 drivers/net/wireless/rt2x00/rt2x00mac.c       |    5 
 drivers/net/wireless/rtl818x/rtl8180/dev.c    |    8 -
 drivers/net/wireless/rtl818x/rtl8187/dev.c    |    6 
 drivers/net/wireless/rtlwifi/core.c           |    5 
 drivers/net/wireless/wl1251/main.c            |    4 
 drivers/net/wireless/wl12xx/main.c            |    4 
 drivers/net/wireless/zd1211rw/zd_mac.c        |    5 
 drivers/staging/brcm80211/sys/wl_mac80211.c   |   28 ----
 drivers/staging/winbond/wbusb.c               |    7 -
 include/net/mac80211.h                        |    2 
 net/mac80211/driver-ops.h                     |    4 
 net/mac80211/tx.c                             |  164 ++++++++------------------
 37 files changed, 122 insertions(+), 237 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2011-02-24 14:28:33.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2011-02-24 14:29:35.000000000 +0100
@@ -1801,7 +1801,7 @@ enum ieee80211_ampdu_mlme_action {
  *	aborted before it expires. This callback may sleep.
  */
 struct ieee80211_ops {
-	int (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
+	void (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
 	int (*start)(struct ieee80211_hw *hw);
 	void (*stop)(struct ieee80211_hw *hw);
 	int (*add_interface)(struct ieee80211_hw *hw,
--- wireless-testing.orig/net/mac80211/driver-ops.h	2011-02-24 14:28:33.000000000 +0100
+++ wireless-testing/net/mac80211/driver-ops.h	2011-02-24 14:29:35.000000000 +0100
@@ -5,9 +5,9 @@
 #include "ieee80211_i.h"
 #include "driver-trace.h"
 
-static inline int drv_tx(struct ieee80211_local *local, struct sk_buff *skb)
+static inline void drv_tx(struct ieee80211_local *local, struct sk_buff *skb)
 {
-	return local->ops->tx(&local->hw, skb);
+	local->ops->tx(&local->hw, skb);
 }
 
 static inline int drv_start(struct ieee80211_local *local)
--- wireless-testing.orig/net/mac80211/tx.c	2011-02-24 14:28:33.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2011-02-24 14:29:35.000000000 +0100
@@ -33,10 +33,6 @@
 #include "wme.h"
 #include "rate.h"
 
-#define IEEE80211_TX_OK		0
-#define IEEE80211_TX_AGAIN	1
-#define IEEE80211_TX_PENDING	2
-
 /* misc utils */
 
 static __le16 ieee80211_duration(struct ieee80211_tx_data *tx, int group_addr,
@@ -1285,16 +1281,17 @@ ieee80211_tx_prepare(struct ieee80211_su
 	return TX_CONTINUE;
 }
 
-static int __ieee80211_tx(struct ieee80211_local *local,
-			  struct sk_buff **skbp,
-			  struct sta_info *sta,
-			  bool txpending)
+/*
+ * Returns false if the frame couldn't be transmitted but was queued instead.
+ */
+static bool __ieee80211_tx(struct ieee80211_local *local, struct sk_buff **skbp,
+			   struct sta_info *sta, bool txpending)
 {
 	struct sk_buff *skb = *skbp, *next;
 	struct ieee80211_tx_info *info;
 	struct ieee80211_sub_if_data *sdata;
 	unsigned long flags;
-	int ret, len;
+	int len;
 	bool fragm = false;
 
 	while (skb) {
@@ -1302,13 +1299,37 @@ static int __ieee80211_tx(struct ieee802
 		__le16 fc;
 
 		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
-		ret = IEEE80211_TX_OK;
 		if (local->queue_stop_reasons[q] ||
-		    (!txpending && !skb_queue_empty(&local->pending[q])))
-			ret = IEEE80211_TX_PENDING;
+		    (!txpending && !skb_queue_empty(&local->pending[q]))) {
+			/*
+			 * Since queue is stopped, queue up frames for later
+			 * transmission from the tx-pending tasklet when the
+			 * queue is woken again.
+			 */
+
+			do {
+				next = skb->next;
+				skb->next = NULL;
+				/*
+				 * NB: If txpending is true, next must already
+				 * be NULL since we must've gone through this
+				 * loop before already; therefore we can just
+				 * queue the frame to the head without worrying
+				 * about reordering of fragments.
+				 */
+				if (unlikely(txpending))
+					__skb_queue_head(&local->pending[q],
+							 skb);
+				else
+					__skb_queue_tail(&local->pending[q],
+							 skb);
+			} while ((skb = next));
+
+			spin_unlock_irqrestore(&local->queue_stop_reason_lock,
+					       flags);
+			return false;
+		}
 		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
-		if (ret != IEEE80211_TX_OK)
-			return ret;
 
 		info = IEEE80211_SKB_CB(skb);
 
@@ -1343,15 +1364,7 @@ static int __ieee80211_tx(struct ieee802
 			info->control.sta = NULL;
 
 		fc = ((struct ieee80211_hdr *)skb->data)->frame_control;
-		ret = drv_tx(local, skb);
-		if (WARN_ON(ret != NETDEV_TX_OK && skb->len != len)) {
-			dev_kfree_skb(skb);
-			ret = NETDEV_TX_OK;
-		}
-		if (ret != NETDEV_TX_OK) {
-			info->control.vif = &sdata->vif;
-			return IEEE80211_TX_AGAIN;
-		}
+		drv_tx(local, skb);
 
 		ieee80211_tpt_led_trig_tx(local, fc, len);
 		*skbp = skb = next;
@@ -1359,7 +1372,7 @@ static int __ieee80211_tx(struct ieee802
 		fragm = true;
 	}
 
-	return IEEE80211_TX_OK;
+	return true;
 }
 
 /*
@@ -1419,23 +1432,24 @@ static int invoke_tx_handlers(struct iee
 	return 0;
 }
 
-static void ieee80211_tx(struct ieee80211_sub_if_data *sdata,
+/*
+ * Returns false if the frame couldn't be transmitted but was queued instead.
+ */
+static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
 			 struct sk_buff *skb, bool txpending)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_data tx;
 	ieee80211_tx_result res_prepare;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct sk_buff *next;
-	unsigned long flags;
-	int ret, retries;
 	u16 queue;
+	bool result = true;
 
 	queue = skb_get_queue_mapping(skb);
 
 	if (unlikely(skb->len < 10)) {
 		dev_kfree_skb(skb);
-		return;
+		return true;
 	}
 
 	rcu_read_lock();
@@ -1445,85 +1459,19 @@ static void ieee80211_tx(struct ieee8021
 
 	if (unlikely(res_prepare == TX_DROP)) {
 		dev_kfree_skb(skb);
-		rcu_read_unlock();
-		return;
+		goto out;
 	} else if (unlikely(res_prepare == TX_QUEUED)) {
-		rcu_read_unlock();
-		return;
+		goto out;
 	}
 
 	tx.channel = local->hw.conf.channel;
 	info->band = tx.channel->band;
 
-	if (invoke_tx_handlers(&tx))
-		goto out;
-
-	retries = 0;
- retry:
-	ret = __ieee80211_tx(local, &tx.skb, tx.sta, txpending);
-	switch (ret) {
-	case IEEE80211_TX_OK:
-		break;
-	case IEEE80211_TX_AGAIN:
-		/*
-		 * Since there are no fragmented frames on A-MPDU
-		 * queues, there's no reason for a driver to reject
-		 * a frame there, warn and drop it.
-		 */
-		if (WARN_ON(info->flags & IEEE80211_TX_CTL_AMPDU))
-			goto drop;
-		/* fall through */
-	case IEEE80211_TX_PENDING:
-		skb = tx.skb;
-
-		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
-
-		if (local->queue_stop_reasons[queue] ||
-		    !skb_queue_empty(&local->pending[queue])) {
-			/*
-			 * if queue is stopped, queue up frames for later
-			 * transmission from the tasklet
-			 */
-			do {
-				next = skb->next;
-				skb->next = NULL;
-				if (unlikely(txpending))
-					__skb_queue_head(&local->pending[queue],
-							 skb);
-				else
-					__skb_queue_tail(&local->pending[queue],
-							 skb);
-			} while ((skb = next));
-
-			spin_unlock_irqrestore(&local->queue_stop_reason_lock,
-					       flags);
-		} else {
-			/*
-			 * otherwise retry, but this is a race condition or
-			 * a driver bug (which we warn about if it persists)
-			 */
-			spin_unlock_irqrestore(&local->queue_stop_reason_lock,
-					       flags);
-
-			retries++;
-			if (WARN(retries > 10, "tx refused but queue active\n"))
-				goto drop;
-			goto retry;
-		}
-	}
+	if (!invoke_tx_handlers(&tx))
+		result = __ieee80211_tx(local, &tx.skb, tx.sta, txpending);
  out:
 	rcu_read_unlock();
-	return;
-
- drop:
-	rcu_read_unlock();
-
-	skb = tx.skb;
-	while (skb) {
-		next = skb->next;
-		dev_kfree_skb(skb);
-		skb = next;
-	}
+	return result;
 }
 
 /* device xmit handlers */
@@ -2070,6 +2018,11 @@ void ieee80211_clear_tx_pending(struct i
 		skb_queue_purge(&local->pending[i]);
 }
 
+/*
+ * Returns false if the frame couldn't be transmitted but was queued instead,
+ * which in this case means re-queued -- take as an indication to stop sending
+ * more pending frames.
+ */
 static bool ieee80211_tx_pending_skb(struct ieee80211_local *local,
 				     struct sk_buff *skb)
 {
@@ -2077,20 +2030,17 @@ static bool ieee80211_tx_pending_skb(str
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
 	struct ieee80211_hdr *hdr;
-	int ret;
-	bool result = true;
+	bool result;
 
 	sdata = vif_to_sdata(info->control.vif);
 
 	if (info->flags & IEEE80211_TX_INTFL_NEED_TXPROCESSING) {
-		ieee80211_tx(sdata, skb, true);
+		result = ieee80211_tx(sdata, skb, true);
 	} else {
 		hdr = (struct ieee80211_hdr *)skb->data;
 		sta = sta_info_get(sdata, hdr->addr1);
 
-		ret = __ieee80211_tx(local, &skb, sta, true);
-		if (ret != IEEE80211_TX_OK)
-			result = false;
+		result = __ieee80211_tx(local, &skb, sta, true);
 	}
 
 	return result;
@@ -2132,8 +2082,6 @@ void ieee80211_tx_pending(unsigned long
 						flags);
 
 			txok = ieee80211_tx_pending_skb(local, skb);
-			if (!txok)
-				__skb_queue_head(&local->pending[i], skb);
 			spin_lock_irqsave(&local->queue_stop_reason_lock,
 					  flags);
 			if (!txok)
--- wireless-testing.orig/drivers/net/wireless/adm8211.c	2011-02-24 14:28:34.000000000 +0100
+++ wireless-testing/drivers/net/wireless/adm8211.c	2011-02-24 14:29:35.000000000 +0100
@@ -1658,7 +1658,7 @@ static void adm8211_tx_raw(struct ieee80
 }
 
 /* Put adm8211_tx_hdr on skb and transmit */
-static int adm8211_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
+static void adm8211_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct adm8211_tx_hdr *txhdr;
 	size_t payload_len, hdrlen;
@@ -1707,8 +1707,6 @@ static int adm8211_tx(struct ieee80211_h
 	txhdr->retry_limit = info->control.rates[0].count;
 
 	adm8211_tx_raw(dev, skb, plcp_signal, hdrlen);
-
-	return NETDEV_TX_OK;
 }
 
 static int adm8211_alloc_rings(struct ieee80211_hw *dev)
--- wireless-testing.orig/drivers/net/wireless/ath/ar9170/main.c	2011-02-24 14:28:34.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/ar9170/main.c	2011-02-24 14:29:35.000000000 +0100
@@ -1475,7 +1475,7 @@ static void ar9170_tx(struct ar9170 *ar)
 				     msecs_to_jiffies(AR9170_JANITOR_DELAY));
 }
 
-int ar9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+void ar9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct ar9170 *ar = hw->priv;
 	struct ieee80211_tx_info *info;
@@ -1493,11 +1493,10 @@ int ar9170_op_tx(struct ieee80211_hw *hw
 	skb_queue_tail(&ar->tx_pending[queue], skb);
 
 	ar9170_tx(ar);
-	return NETDEV_TX_OK;
+	return;
 
 err_free:
 	dev_kfree_skb_any(skb);
-	return NETDEV_TX_OK;
 }
 
 static int ar9170_op_add_interface(struct ieee80211_hw *hw,
--- wireless-testing.orig/drivers/net/wireless/ath/ath5k/base.c	2011-02-24 14:28:34.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/ath5k/base.c	2011-02-24 14:29:35.000000000 +0100
@@ -1518,7 +1518,7 @@ unlock:
 * TX Handling *
 \*************/
 
-int
+void
 ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
 	       struct ath5k_txq *txq)
 {
@@ -1567,11 +1567,10 @@ ath5k_tx_queue(struct ieee80211_hw *hw,
 		spin_unlock_irqrestore(&sc->txbuflock, flags);
 		goto drop_packet;
 	}
-	return NETDEV_TX_OK;
+	return;
 
 drop_packet:
 	dev_kfree_skb_any(skb);
-	return NETDEV_TX_OK;
 }
 
 static void
--- wireless-testing.orig/drivers/net/wireless/ath/ath5k/mac80211-ops.c	2011-02-24 14:28:34.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/ath5k/mac80211-ops.c	2011-02-24 14:29:35.000000000 +0100
@@ -52,7 +52,7 @@ extern int ath5k_modparam_nohwcrypt;
 * Mac80211 functions *
 \********************/
 
-static int
+static void
 ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct ath5k_softc *sc = hw->priv;
@@ -60,10 +60,10 @@ ath5k_tx(struct ieee80211_hw *hw, struct
 
 	if (WARN_ON(qnum >= sc->ah->ah_capabilities.cap_queues.q_tx_num)) {
 		dev_kfree_skb_any(skb);
-		return 0;
+		return;
 	}
 
-	return ath5k_tx_queue(hw, skb, &sc->txqs[qnum]);
+	ath5k_tx_queue(hw, skb, &sc->txqs[qnum]);
 }
 
 
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/htc_drv_main.c	2011-02-24 14:28:34.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/ath9k/htc_drv_main.c	2011-02-24 14:29:35.000000000 +0100
@@ -1036,7 +1036,7 @@ set_timer:
 /* mac80211 Callbacks */
 /**********************/
 
-static int ath9k_htc_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static void ath9k_htc_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr;
 	struct ath9k_htc_priv *priv = hw->priv;
@@ -1049,7 +1049,7 @@ static int ath9k_htc_tx(struct ieee80211
 	padsize = padpos & 3;
 	if (padsize && skb->len > padpos) {
 		if (skb_headroom(skb) < padsize)
-			return -1;
+			goto fail_tx;
 		skb_push(skb, padsize);
 		memmove(skb->data, skb->data + padsize, padpos);
 	}
@@ -1070,11 +1070,10 @@ static int ath9k_htc_tx(struct ieee80211
 		goto fail_tx;
 	}
 
-	return 0;
+	return;
 
 fail_tx:
 	dev_kfree_skb_any(skb);
-	return 0;
 }
 
 static int ath9k_htc_start(struct ieee80211_hw *hw)
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/main.c	2011-02-24 14:28:34.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/ath9k/main.c	2011-02-24 14:29:35.000000000 +0100
@@ -1142,8 +1142,7 @@ mutex_unlock:
 	return r;
 }
 
-static int ath9k_tx(struct ieee80211_hw *hw,
-		    struct sk_buff *skb)
+static void ath9k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
@@ -1200,10 +1199,9 @@ static int ath9k_tx(struct ieee80211_hw
 		goto exit;
 	}
 
-	return 0;
+	return;
 exit:
 	dev_kfree_skb_any(skb);
-	return 0;
 }
 
 static void ath9k_stop(struct ieee80211_hw *hw)
--- wireless-testing.orig/drivers/net/wireless/ath/carl9170/carl9170.h	2011-02-24 14:28:34.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/carl9170/carl9170.h	2011-02-24 14:29:35.000000000 +0100
@@ -534,7 +534,7 @@ void carl9170_rx(struct ar9170 *ar, void
 void carl9170_handle_command_response(struct ar9170 *ar, void *buf, u32 len);
 
 /* TX */
-int carl9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
+void carl9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
 void carl9170_tx_janitor(struct work_struct *work);
 void carl9170_tx_process_status(struct ar9170 *ar,
 				const struct carl9170_rsp *cmd);
--- wireless-testing.orig/drivers/net/wireless/ath/carl9170/tx.c	2011-02-24 14:28:34.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/carl9170/tx.c	2011-02-24 14:29:35.000000000 +0100
@@ -1339,7 +1339,7 @@ err_unlock_rcu:
 	return false;
 }
 
-int carl9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+void carl9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct ar9170 *ar = hw->priv;
 	struct ieee80211_tx_info *info;
@@ -1373,12 +1373,11 @@ int carl9170_op_tx(struct ieee80211_hw *
 	}
 
 	carl9170_tx(ar);
-	return NETDEV_TX_OK;
+	return;
 
 err_free:
 	ar->tx_dropped++;
 	dev_kfree_skb_any(skb);
-	return NETDEV_TX_OK;
 }
 
 void carl9170_tx_scheduler(struct ar9170 *ar)
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2011-02-24 14:28:33.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/main.c	2011-02-24 14:29:35.000000000 +0100
@@ -3203,7 +3203,7 @@ static void b43_tx_work(struct work_stru
 	mutex_unlock(&wl->mutex);
 }
 
-static int b43_op_tx(struct ieee80211_hw *hw,
+static void b43_op_tx(struct ieee80211_hw *hw,
 		     struct sk_buff *skb)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
@@ -3211,14 +3211,12 @@ static int b43_op_tx(struct ieee80211_hw
 	if (unlikely(skb->len < 2 + 2 + 6)) {
 		/* Too short, this can't be a valid frame. */
 		dev_kfree_skb_any(skb);
-		return NETDEV_TX_OK;
+		return;
 	}
 	B43_WARN_ON(skb_shinfo(skb)->nr_frags);
 
 	skb_queue_tail(&wl->tx_queue, skb);
 	ieee80211_queue_work(wl->hw, &wl->tx_work);
-
-	return NETDEV_TX_OK;
 }
 
 static void b43_qos_params_upload(struct b43_wldev *dev,
--- wireless-testing.orig/drivers/net/wireless/b43legacy/main.c	2011-02-24 14:28:34.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43legacy/main.c	2011-02-24 14:29:35.000000000 +0100
@@ -2442,8 +2442,8 @@ static int b43legacy_rng_init(struct b43
 	return err;
 }
 
-static int b43legacy_op_tx(struct ieee80211_hw *hw,
-			   struct sk_buff *skb)
+static void b43legacy_op_tx(struct ieee80211_hw *hw,
+			    struct sk_buff *skb)
 {
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
 	struct b43legacy_wldev *dev = wl->current_dev;
@@ -2466,7 +2466,6 @@ out:
 		/* Drop the packet. */
 		dev_kfree_skb_any(skb);
 	}
-	return NETDEV_TX_OK;
 }
 
 static int b43legacy_op_conf_tx(struct ieee80211_hw *hw, u16 queue,
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-agn.c	2011-02-24 14:29:17.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-agn.c	2011-02-24 14:29:35.000000000 +0100
@@ -3330,7 +3330,7 @@ void iwlagn_mac_stop(struct ieee80211_hw
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
-int iwlagn_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+void iwlagn_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct iwl_priv *priv = hw->priv;
 
@@ -3343,7 +3343,6 @@ int iwlagn_mac_tx(struct ieee80211_hw *h
 		dev_kfree_skb_any(skb);
 
 	IWL_DEBUG_MACDUMP(priv, "leave\n");
-	return NETDEV_TX_OK;
 }
 
 void iwlagn_mac_update_tkip_key(struct ieee80211_hw *hw,
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-agn.h	2011-02-24 14:28:33.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-agn.h	2011-02-24 14:29:35.000000000 +0100
@@ -356,7 +356,7 @@ iwlagn_remove_notification(struct iwl_pr
 			   struct iwl_notification_wait *wait_entry);
 
 /* mac80211 handlers (for 4965) */
-int iwlagn_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
+void iwlagn_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
 int iwlagn_mac_start(struct ieee80211_hw *hw);
 void iwlagn_mac_stop(struct ieee80211_hw *hw);
 void iwlagn_configure_filter(struct ieee80211_hw *hw,
--- wireless-testing.orig/drivers/net/wireless/libertas_tf/main.c	2011-02-24 14:29:03.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas_tf/main.c	2011-02-24 14:29:35.000000000 +0100
@@ -225,7 +225,7 @@ static void lbtf_free_adapter(struct lbt
 	lbtf_deb_leave(LBTF_DEB_MAIN);
 }
 
-static int lbtf_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static void lbtf_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct lbtf_private *priv = hw->priv;
 
@@ -236,7 +236,6 @@ static int lbtf_op_tx(struct ieee80211_h
 	 * there are no buffered multicast frames to send
 	 */
 	ieee80211_stop_queues(priv->hw);
-	return NETDEV_TX_OK;
 }
 
 static void lbtf_tx_work(struct work_struct *work)
--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2011-02-24 14:28:33.000000000 +0100
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2011-02-24 14:29:35.000000000 +0100
@@ -541,7 +541,7 @@ static bool mac80211_hwsim_tx_frame(stru
 }
 
 
-static int mac80211_hwsim_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static void mac80211_hwsim_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	bool ack;
 	struct ieee80211_tx_info *txi;
@@ -551,7 +551,7 @@ static int mac80211_hwsim_tx(struct ieee
 	if (skb->len < 10) {
 		/* Should not happen; just a sanity check for addr1 use */
 		dev_kfree_skb(skb);
-		return NETDEV_TX_OK;
+		return;
 	}
 
 	ack = mac80211_hwsim_tx_frame(hw, skb);
@@ -571,7 +571,6 @@ static int mac80211_hwsim_tx(struct ieee
 	if (!(txi->flags & IEEE80211_TX_CTL_NO_ACK) && ack)
 		txi->flags |= IEEE80211_TX_STAT_ACK;
 	ieee80211_tx_status_irqsafe(hw, skb);
-	return NETDEV_TX_OK;
 }
 
 
--- wireless-testing.orig/drivers/net/wireless/mwl8k.c	2011-02-24 14:28:34.000000000 +0100
+++ wireless-testing/drivers/net/wireless/mwl8k.c	2011-02-24 14:29:35.000000000 +0100
@@ -1573,7 +1573,7 @@ static void mwl8k_txq_deinit(struct ieee
 	txq->txd = NULL;
 }
 
-static int
+static void
 mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 {
 	struct mwl8k_priv *priv = hw->priv;
@@ -1635,7 +1635,7 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw,
 		wiphy_debug(hw->wiphy,
 			    "failed to dma map skb, dropping TX frame.\n");
 		dev_kfree_skb(skb);
-		return NETDEV_TX_OK;
+		return;
 	}
 
 	spin_lock_bh(&priv->tx_lock);
@@ -1672,8 +1672,6 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw,
 	mwl8k_tx_start(priv);
 
 	spin_unlock_bh(&priv->tx_lock);
-
-	return NETDEV_TX_OK;
 }
 
 
@@ -3742,22 +3740,19 @@ static void mwl8k_rx_poll(unsigned long
 /*
  * Core driver operations.
  */
-static int mwl8k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static void mwl8k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct mwl8k_priv *priv = hw->priv;
 	int index = skb_get_queue_mapping(skb);
-	int rc;
 
 	if (!priv->radio_on) {
 		wiphy_debug(hw->wiphy,
 			    "dropped TX frame since radio disabled\n");
 		dev_kfree_skb(skb);
-		return NETDEV_TX_OK;
+		return;
 	}
 
-	rc = mwl8k_txq_xmit(hw, index, skb);
-
-	return rc;
+	mwl8k_txq_xmit(hw, index, skb);
 }
 
 static int mwl8k_start(struct ieee80211_hw *hw)
--- wireless-testing.orig/drivers/net/wireless/p54/lmac.h	2011-02-24 14:28:35.000000000 +0100
+++ wireless-testing/drivers/net/wireless/p54/lmac.h	2011-02-24 14:29:35.000000000 +0100
@@ -526,7 +526,7 @@ int p54_init_leds(struct p54_common *pri
 void p54_unregister_leds(struct p54_common *priv);
 
 /* xmit functions */
-int p54_tx_80211(struct ieee80211_hw *dev, struct sk_buff *skb);
+void p54_tx_80211(struct ieee80211_hw *dev, struct sk_buff *skb);
 int p54_tx_cancel(struct p54_common *priv, __le32 req_id);
 void p54_tx(struct p54_common *priv, struct sk_buff *skb);
 
--- wireless-testing.orig/drivers/net/wireless/p54/main.c	2011-02-24 14:28:34.000000000 +0100
+++ wireless-testing/drivers/net/wireless/p54/main.c	2011-02-24 14:29:35.000000000 +0100
@@ -157,7 +157,7 @@ static int p54_beacon_update(struct p54_
 	 * to cancel the old beacon template by hand, instead the firmware
 	 * will release the previous one through the feedback mechanism.
 	 */
-	WARN_ON(p54_tx_80211(priv->hw, beacon));
+	p54_tx_80211(priv->hw, beacon);
 	priv->tsf_high32 = 0;
 	priv->tsf_low32 = 0;
 
--- wireless-testing.orig/drivers/net/wireless/p54/txrx.c	2011-02-24 14:28:34.000000000 +0100
+++ wireless-testing/drivers/net/wireless/p54/txrx.c	2011-02-24 14:29:35.000000000 +0100
@@ -696,7 +696,7 @@ static u8 p54_convert_algo(u32 cipher)
 	}
 }
 
-int p54_tx_80211(struct ieee80211_hw *dev, struct sk_buff *skb)
+void p54_tx_80211(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct p54_common *priv = dev->priv;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -717,12 +717,8 @@ int p54_tx_80211(struct ieee80211_hw *de
 			    &hdr_flags, &aid, &burst_allowed);
 
 	if (p54_tx_qos_accounting_alloc(priv, skb, queue)) {
-		if (!IS_QOS_QUEUE(queue)) {
-			dev_kfree_skb_any(skb);
-			return NETDEV_TX_OK;
-		} else {
-			return NETDEV_TX_BUSY;
-		}
+		dev_kfree_skb_any(skb);
+		return;
 	}
 
 	padding = (unsigned long)(skb->data - (sizeof(*hdr) + sizeof(*txhdr))) & 3;
@@ -865,5 +861,4 @@ int p54_tx_80211(struct ieee80211_hw *de
 	p54info->extra_len = extra_len;
 
 	p54_tx(priv, skb);
-	return NETDEV_TX_OK;
 }
--- wireless-testing.orig/drivers/net/wireless/rt2x00/rt2x00.h	2011-02-24 14:28:33.000000000 +0100
+++ wireless-testing/drivers/net/wireless/rt2x00/rt2x00.h	2011-02-24 14:29:35.000000000 +0100
@@ -1185,7 +1185,7 @@ void rt2x00lib_rxdone(struct queue_entry
 /*
  * mac80211 handlers.
  */
-int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
+void rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
 int rt2x00mac_start(struct ieee80211_hw *hw);
 void rt2x00mac_stop(struct ieee80211_hw *hw);
 int rt2x00mac_add_interface(struct ieee80211_hw *hw,
--- wireless-testing.orig/drivers/net/wireless/rt2x00/rt2x00mac.c	2011-02-24 14:28:33.000000000 +0100
+++ wireless-testing/drivers/net/wireless/rt2x00/rt2x00mac.c	2011-02-24 14:29:35.000000000 +0100
@@ -99,7 +99,7 @@ static int rt2x00mac_tx_rts_cts(struct r
 	return retval;
 }
 
-int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+void rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
@@ -155,12 +155,11 @@ int rt2x00mac_tx(struct ieee80211_hw *hw
 	if (rt2x00queue_threshold(queue))
 		rt2x00queue_pause_queue(queue);
 
-	return NETDEV_TX_OK;
+	return;
 
  exit_fail:
 	ieee80211_stop_queue(rt2x00dev->hw, qid);
 	dev_kfree_skb_any(skb);
-	return NETDEV_TX_OK;
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_tx);
 
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187/dev.c	2011-02-24 14:28:34.000000000 +0100
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187/dev.c	2011-02-24 14:29:35.000000000 +0100
@@ -227,7 +227,7 @@ static void rtl8187_tx_cb(struct urb *ur
 	}
 }
 
-static int rtl8187_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
+static void rtl8187_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct rtl8187_priv *priv = dev->priv;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -241,7 +241,7 @@ static int rtl8187_tx(struct ieee80211_h
 	urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!urb) {
 		kfree_skb(skb);
-		return NETDEV_TX_OK;
+		return;
 	}
 
 	flags = skb->len;
@@ -309,8 +309,6 @@ static int rtl8187_tx(struct ieee80211_h
 		kfree_skb(skb);
 	}
 	usb_free_urb(urb);
-
-	return NETDEV_TX_OK;
 }
 
 static void rtl8187_rx_cb(struct urb *urb)
--- wireless-testing.orig/drivers/net/wireless/wl1251/main.c	2011-02-24 14:28:34.000000000 +0100
+++ wireless-testing/drivers/net/wireless/wl1251/main.c	2011-02-24 14:29:35.000000000 +0100
@@ -375,7 +375,7 @@ out:
 	mutex_unlock(&wl->mutex);
 }
 
-static int wl1251_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static void wl1251_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct wl1251 *wl = hw->priv;
 	unsigned long flags;
@@ -401,8 +401,6 @@ static int wl1251_op_tx(struct ieee80211
 		wl->tx_queue_stopped = true;
 		spin_unlock_irqrestore(&wl->wl_lock, flags);
 	}
-
-	return NETDEV_TX_OK;
 }
 
 static int wl1251_op_start(struct ieee80211_hw *hw)
--- wireless-testing.orig/drivers/net/wireless/zd1211rw/zd_mac.c	2011-02-24 14:28:33.000000000 +0100
+++ wireless-testing/drivers/net/wireless/zd1211rw/zd_mac.c	2011-02-24 14:29:35.000000000 +0100
@@ -850,7 +850,7 @@ static int fill_ctrlset(struct zd_mac *m
  * control block of the skbuff will be initialized. If necessary the incoming
  * mac80211 queues will be stopped.
  */
-static int zd_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static void zd_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -865,11 +865,10 @@ static int zd_op_tx(struct ieee80211_hw
 	r = zd_usb_tx(&mac->chip.usb, skb);
 	if (r)
 		goto fail;
-	return 0;
+	return;
 
 fail:
 	dev_kfree_skb(skb);
-	return 0;
 }
 
 /**
--- wireless-testing.orig/drivers/net/wireless/ath/ar9170/ar9170.h	2011-02-24 14:28:34.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/ar9170/ar9170.h	2011-02-24 14:29:35.000000000 +0100
@@ -224,7 +224,7 @@ void ar9170_handle_command_response(stru
 int ar9170_nag_limiter(struct ar9170 *ar);
 
 /* MAC */
-int ar9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
+void ar9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
 int ar9170_init_mac(struct ar9170 *ar);
 int ar9170_set_qos(struct ar9170 *ar);
 int ar9170_update_multicast(struct ar9170 *ar, const u64 mc_hast);
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8180/dev.c	2011-02-24 14:28:34.000000000 +0100
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8180/dev.c	2011-02-24 14:29:35.000000000 +0100
@@ -240,7 +240,7 @@ static irqreturn_t rtl8180_interrupt(int
 	return IRQ_HANDLED;
 }
 
-static int rtl8180_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
+static void rtl8180_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
@@ -321,8 +321,6 @@ static int rtl8180_tx(struct ieee80211_h
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	rtl818x_iowrite8(priv, &priv->map->TX_DMA_POLLING, (1 << (prio + 4)));
-
-	return 0;
 }
 
 void rtl8180_set_anaparam(struct rtl8180_priv *priv, u32 anaparam)
@@ -687,7 +685,6 @@ static void rtl8180_beacon_work(struct w
 	struct ieee80211_hw *dev = vif_priv->dev;
 	struct ieee80211_mgmt *mgmt;
 	struct sk_buff *skb;
-	int err = 0;
 
 	/* don't overflow the tx ring */
 	if (ieee80211_queue_stopped(dev, 0))
@@ -708,8 +705,7 @@ static void rtl8180_beacon_work(struct w
 	/* TODO: use actual beacon queue */
 	skb_set_queue_mapping(skb, 0);
 
-	err = rtl8180_tx(dev, skb);
-	WARN_ON(err);
+	rtl8180_tx(dev, skb);
 
 resched:
 	/*
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/core.c	2011-02-24 14:28:34.000000000 +0100
+++ wireless-testing/drivers/net/wireless/rtlwifi/core.c	2011-02-24 14:29:35.000000000 +0100
@@ -82,7 +82,7 @@ static void rtl_op_stop(struct ieee80211
 	mutex_unlock(&rtlpriv->locks.conf_mutex);
 }
 
-static int rtl_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static void rtl_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
@@ -97,11 +97,10 @@ static int rtl_op_tx(struct ieee80211_hw
 
 	rtlpriv->intf_ops->adapter_tx(hw, skb);
 
-	return NETDEV_TX_OK;
+	return;
 
 err_free:
 	dev_kfree_skb_any(skb);
-	return NETDEV_TX_OK;
 }
 
 static int rtl_op_add_interface(struct ieee80211_hw *hw,
--- wireless-testing.orig/drivers/net/wireless/wl12xx/main.c	2011-02-24 14:28:34.000000000 +0100
+++ wireless-testing/drivers/net/wireless/wl12xx/main.c	2011-02-24 14:29:35.000000000 +0100
@@ -1034,7 +1034,7 @@ int wl1271_plt_stop(struct wl1271 *wl)
 	return ret;
 }
 
-static int wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static void wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct wl1271 *wl = hw->priv;
 	unsigned long flags;
@@ -1073,8 +1073,6 @@ static int wl1271_op_tx(struct ieee80211
 
 	if (!test_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags))
 		ieee80211_queue_work(wl->hw, &wl->tx_work);
-
-	return NETDEV_TX_OK;
 }
 
 static struct notifier_block wl1271_dev_notifier = {
--- wireless-testing.orig/drivers/net/wireless/at76c50x-usb.c	2011-02-24 14:28:35.000000000 +0100
+++ wireless-testing/drivers/net/wireless/at76c50x-usb.c	2011-02-24 14:29:35.000000000 +0100
@@ -1728,7 +1728,7 @@ static void at76_mac80211_tx_callback(st
 	ieee80211_wake_queues(priv->hw);
 }
 
-static int at76_mac80211_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static void at76_mac80211_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct at76_priv *priv = hw->priv;
 	struct at76_tx_buffer *tx_buffer = priv->bulk_out_buffer;
@@ -1741,7 +1741,8 @@ static int at76_mac80211_tx(struct ieee8
 	if (priv->tx_urb->status == -EINPROGRESS) {
 		wiphy_err(priv->hw->wiphy,
 			  "%s called while tx urb is pending\n", __func__);
-		return NETDEV_TX_BUSY;
+		dev_kfree_skb_any(skb);
+		return;
 	}
 
 	/* The following code lines are important when the device is going to
@@ -1795,8 +1796,6 @@ static int at76_mac80211_tx(struct ieee8
 				  priv->tx_urb,
 				  priv->tx_urb->hcpriv, priv->tx_urb->complete);
 	}
-
-	return 0;
 }
 
 static int at76_mac80211_start(struct ieee80211_hw *hw)
--- wireless-testing.orig/drivers/net/wireless/iwlegacy/iwl-4965.h	2011-02-24 14:28:34.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlegacy/iwl-4965.h	2011-02-24 14:29:35.000000000 +0100
@@ -253,7 +253,7 @@ void iwl4965_eeprom_release_semaphore(st
 int  iwl4965_eeprom_check_version(struct iwl_priv *priv);
 
 /* mac80211 handlers (for 4965) */
-int iwl4965_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
+void iwl4965_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
 int iwl4965_mac_start(struct ieee80211_hw *hw);
 void iwl4965_mac_stop(struct ieee80211_hw *hw);
 void iwl4965_configure_filter(struct ieee80211_hw *hw,
--- wireless-testing.orig/drivers/net/wireless/iwlegacy/iwl3945-base.c	2011-02-24 14:28:34.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlegacy/iwl3945-base.c	2011-02-24 14:29:35.000000000 +0100
@@ -3170,7 +3170,7 @@ static void iwl3945_mac_stop(struct ieee
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
-static int iwl3945_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static void iwl3945_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct iwl_priv *priv = hw->priv;
 
@@ -3183,7 +3183,6 @@ static int iwl3945_mac_tx(struct ieee802
 		dev_kfree_skb_any(skb);
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
-	return NETDEV_TX_OK;
 }
 
 void iwl3945_config_ap(struct iwl_priv *priv)
--- wireless-testing.orig/drivers/net/wireless/iwlegacy/iwl4965-base.c	2011-02-24 14:28:34.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlegacy/iwl4965-base.c	2011-02-24 14:29:35.000000000 +0100
@@ -2631,7 +2631,7 @@ void iwl4965_mac_stop(struct ieee80211_h
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
-int iwl4965_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+void iwl4965_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct iwl_priv *priv = hw->priv;
 
@@ -2644,7 +2644,6 @@ int iwl4965_mac_tx(struct ieee80211_hw *
 		dev_kfree_skb_any(skb);
 
 	IWL_DEBUG_MACDUMP(priv, "leave\n");
-	return NETDEV_TX_OK;
 }
 
 void iwl4965_mac_update_tkip_key(struct ieee80211_hw *hw,
--- wireless-testing.orig/drivers/net/wireless/ath/ath5k/ath5k.h	2011-02-24 14:28:34.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/ath5k/ath5k.h	2011-02-24 14:29:35.000000000 +0100
@@ -1164,8 +1164,8 @@ struct ath5k_txq;
 
 void set_beacon_filter(struct ieee80211_hw *hw, bool enable);
 bool ath_any_vif_assoc(struct ath5k_softc *sc);
-int ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
-		   struct ath5k_txq *txq);
+void ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
+		    struct ath5k_txq *txq);
 int ath5k_init_hw(struct ath5k_softc *sc);
 int ath5k_stop_hw(struct ath5k_softc *sc);
 void ath5k_mode_setup(struct ath5k_softc *sc, struct ieee80211_vif *vif);
--- wireless-testing.orig/drivers/staging/winbond/wbusb.c	2011-02-24 14:30:58.000000000 +0100
+++ wireless-testing/drivers/staging/winbond/wbusb.c	2011-02-24 14:37:36.000000000 +0100
@@ -118,13 +118,14 @@ static void wbsoft_configure_filter(stru
 	*total_flags = new_flags;
 }
 
-static int wbsoft_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
+static void wbsoft_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct wbsoft_priv *priv = dev->priv;
 
 	if (priv->sMlmeFrame.IsInUsed != PACKET_FREE_TO_USE) {
 		priv->sMlmeFrame.wNumTxMMPDUDiscarded++;
-		return NETDEV_TX_BUSY;
+		kfree_skb(skb);
+		return;
 	}
 
 	priv->sMlmeFrame.IsInUsed = PACKET_COME_FROM_MLME;
@@ -140,8 +141,6 @@ static int wbsoft_tx(struct ieee80211_hw
 	 */
 
 	Mds_Tx(priv);
-
-	return NETDEV_TX_OK;
 }
 
 static int wbsoft_start(struct ieee80211_hw *dev)
--- wireless-testing.orig/drivers/staging/brcm80211/sys/wl_mac80211.c	2011-02-24 14:32:51.000000000 +0100
+++ wireless-testing/drivers/staging/brcm80211/sys/wl_mac80211.c	2011-02-24 14:38:47.000000000 +0100
@@ -104,9 +104,6 @@ static int wl_request_fw(struct wl_info
 static void wl_release_fw(struct wl_info *wl);
 
 /* local prototypes */
-static int wl_start(struct sk_buff *skb, struct wl_info *wl);
-static int wl_start_int(struct wl_info *wl, struct ieee80211_hw *hw,
-			struct sk_buff *skb);
 static void wl_dpc(unsigned long data);
 
 MODULE_AUTHOR("Broadcom Corporation");
@@ -135,7 +132,6 @@ module_param(phymsglevel, int, 0);
 
 #define HW_TO_WL(hw)	 (hw->priv)
 #define WL_TO_HW(wl)	  (wl->pub->ieee_hw)
-static int wl_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
 static int wl_ops_start(struct ieee80211_hw *hw);
 static void wl_ops_stop(struct ieee80211_hw *hw);
 static int wl_ops_add_interface(struct ieee80211_hw *hw,
@@ -173,20 +169,18 @@ static int wl_ampdu_action(struct ieee80
 			   enum ieee80211_ampdu_mlme_action action,
 			   struct ieee80211_sta *sta, u16 tid, u16 *ssn);
 
-static int wl_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static void wl_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
-	int status;
 	struct wl_info *wl = hw->priv;
 	WL_LOCK(wl);
 	if (!wl->pub->up) {
 		WL_ERROR("ops->tx called while down\n");
-		status = -ENETDOWN;
+		kfree_skb(skb);
 		goto done;
 	}
-	status = wl_start(skb, wl);
+	wlc_sendpkt_mac80211(wl->wlc, skb, hw);
  done:
 	WL_UNLOCK(wl);
-	return status;
 }
 
 static int wl_ops_start(struct ieee80211_hw *hw)
@@ -1325,22 +1319,6 @@ void wl_free(struct wl_info *wl)
 	osl_detach(osh);
 }
 
-/* transmit a packet */
-static int BCMFASTPATH wl_start(struct sk_buff *skb, struct wl_info *wl)
-{
-	if (!wl)
-		return -ENETDOWN;
-
-	return wl_start_int(wl, WL_TO_HW(wl), skb);
-}
-
-static int BCMFASTPATH
-wl_start_int(struct wl_info *wl, struct ieee80211_hw *hw, struct sk_buff *skb)
-{
-	wlc_sendpkt_mac80211(wl->wlc, skb, hw);
-	return NETDEV_TX_OK;
-}
-
 void wl_txflowcontrol(struct wl_info *wl, struct wl_if *wlif, bool state,
 		      int prio)
 {


