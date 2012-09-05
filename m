Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2258 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493Ab2IEJtl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 05:49:41 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>,
	stable <stable@vger.kernel.org>,
	"Jonathan Nieder" <jrnieder@gmail.com>,
	"Stanislaw Gruszka" <sgruszka@redhat.com>,
	=?UTF-8?q?Camale=C3=B3n?= <noelamac@gmail.com>,
	"Milan Bouchet-Valat" <nalimilan@club-internet.fr>
Subject: [PATCH 2/2] brcmsmac: rework of mac80211 .flush() callback
 operation
Date: Wed, 5 Sep 2012 11:49:22 +0200
Message-ID: <1346838562-4818-3-git-send-email-arend@broadcom.com> (sfid-20120905_114949_603678_B361D5FE)
In-Reply-To: <1346838562-4818-1-git-send-email-arend@broadcom.com>
References: <1346838562-4818-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch addresses a long standing issue of the driver with the
mac80211 .flush() callback. Since implementing the .flush() callback
a number of issues have been fixed, but a WARN_ON_ONCE() was still
triggered because the flush takes too much time. The flush now
makes use of a waitqueue and still has a timeout on which a warning
is given.

bugzilla: 42840 <https://bugzilla.kernel.org/show_bug.cgi?id=42840>
bugzilla@redhat: <https://bugzilla.redhat.com/show_bug.cgi?id=799168>
bugzilla@redhat: <https://bugzilla.redhat.com/show_bug.cgi?id=787649>

Cc: stable <stable@vger.kernel.org>
Cc: Jonathan Nieder <jrnieder@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Camaleón <noelamac@gmail.com>
Cc: Milan Bouchet-Valat <nalimilan@club-internet.fr>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   41 +++++++++++++-------
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.h  |    3 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   21 +++-------
 drivers/net/wireless/brcm80211/brcmsmac/pub.h      |    4 +-
 4 files changed, 37 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index a5edebe..56c419b 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -35,6 +35,7 @@
 #include "main.h"
 
 #define N_TX_QUEUES	4 /* #tx queues on mac80211<->driver interface */
+#define BRCMS_FLUSH_TIMEOUT	100 /* msec */
 
 /* Flags we support */
 #define MAC_FILTERS (FIF_PROMISC_IN_BSS | \
@@ -693,16 +694,35 @@ static void brcms_ops_rfkill_poll(struct ieee80211_hw *hw)
 	wiphy_rfkill_set_hw_state(wl->pub->ieee_hw->wiphy, blocked);
 }
 
+static bool brcms_tx_flush_completed(struct brcms_info *wl)
+{
+	bool result;
+
+	spin_lock_bh(&wl->lock);
+	result = brcms_c_tx_flush_completed(wl->wlc);
+	spin_unlock_bh(&wl->lock);
+	return result;
+}
+
 static void brcms_ops_flush(struct ieee80211_hw *hw, bool drop)
 {
 	struct brcms_info *wl = hw->priv;
+	int ret;
 
 	no_printk("%s: drop = %s\n", __func__, drop ? "true" : "false");
 
-	/* wait for packet queue and dma fifos to run empty */
-	spin_lock_bh(&wl->lock);
-	brcms_c_wait_for_tx_completion(wl->wlc, drop);
-	spin_unlock_bh(&wl->lock);
+	ieee80211_stop_queues(hw);
+	if (drop) {
+		spin_lock_bh(&wl->lock);
+		brcms_c_pktq_flush(wl->wlc);
+		spin_unlock_bh(&wl->lock);
+	}
+	ret = wait_event_timeout(wl->tx_flush_wq,
+				 brcms_tx_flush_completed(wl),
+				 msecs_to_jiffies(BRCMS_FLUSH_TIMEOUT));
+
+	ieee80211_wake_queues(hw);
+	WARN_ON(!ret);
 }
 
 static const struct ieee80211_ops brcms_ops = {
@@ -757,6 +777,7 @@ void brcms_dpc(unsigned long data)
 
  done:
 	spin_unlock_bh(&wl->lock);
+	wake_up(&wl->tx_flush_wq);
 }
 
 /*
@@ -1008,6 +1029,8 @@ static struct brcms_info *brcms_attach(struct bcma_device *pdev)
 
 	atomic_set(&wl->callbacks, 0);
 
+	init_waitqueue_head(&wl->tx_flush_wq);
+
 	/* setup the bottom half handler */
 	tasklet_init(&wl->tasklet, brcms_dpc, (unsigned long) wl);
 
@@ -1594,13 +1617,3 @@ bool brcms_rfkill_set_hw_state(struct brcms_info *wl)
 	spin_lock_bh(&wl->lock);
 	return blocked;
 }
-
-/*
- * precondition: perimeter lock has been acquired
- */
-void brcms_msleep(struct brcms_info *wl, uint ms)
-{
-	spin_unlock_bh(&wl->lock);
-	msleep(ms);
-	spin_lock_bh(&wl->lock);
-}
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.h b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.h
index 9358bd5..947ccac 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.h
@@ -68,6 +68,8 @@ struct brcms_info {
 	spinlock_t lock;	/* per-device perimeter lock */
 	spinlock_t isr_lock;	/* per-device ISR synchronization lock */
 
+	/* tx flush */
+	wait_queue_head_t tx_flush_wq;
 
 	/* timer related fields */
 	atomic_t callbacks;	/* # outstanding callback functions */
@@ -100,7 +102,6 @@ extern struct brcms_timer *brcms_init_timer(struct brcms_info *wl,
 extern void brcms_free_timer(struct brcms_timer *timer);
 extern void brcms_add_timer(struct brcms_timer *timer, uint ms, int periodic);
 extern bool brcms_del_timer(struct brcms_timer *timer);
-extern void brcms_msleep(struct brcms_info *wl, uint ms);
 extern void brcms_dpc(unsigned long data);
 extern void brcms_timer(struct brcms_timer *t);
 extern void brcms_fatal_error(struct brcms_info *wl);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 03ca653..ee44126 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -7979,23 +7979,14 @@ int brcms_c_get_curband(struct brcms_c_info *wlc)
 	return wlc->band->bandunit;
 }
 
-void brcms_c_wait_for_tx_completion(struct brcms_c_info *wlc, bool drop)
+void brcms_c_pktq_flush(struct brcms_c_info *wlc)
 {
-	int timeout = 20;
-
-	/* flush packet queue when requested */
-	if (drop)
-		brcmu_pktq_flush(&wlc->pkt_queue->q, false, NULL, NULL);
-
-	/* wait for queue and DMA fifos to run dry */
-	while (!pktq_empty(&wlc->pkt_queue->q) || brcms_txpktpendtot(wlc) > 0) {
-		brcms_msleep(wlc->wl, 1);
-
-		if (--timeout == 0)
-			break;
-	}
+	brcmu_pktq_flush(&wlc->pkt_queue->q, false, NULL, NULL);
+}
 
-	WARN_ON_ONCE(timeout == 0);
+bool brcms_c_tx_flush_completed(struct brcms_c_info *wlc)
+{
+	return pktq_empty(&wlc->pkt_queue->q) && !brcms_txpktpendtot(wlc);
 }
 
 void brcms_c_set_beacon_listen_interval(struct brcms_c_info *wlc, u8 interval)
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pub.h b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
index 5855f4f..59caa1c 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pub.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
@@ -350,8 +350,6 @@ extern void brcms_c_associate_upd(struct brcms_c_info *wlc, bool state);
 extern void brcms_c_scan_start(struct brcms_c_info *wlc);
 extern void brcms_c_scan_stop(struct brcms_c_info *wlc);
 extern int brcms_c_get_curband(struct brcms_c_info *wlc);
-extern void brcms_c_wait_for_tx_completion(struct brcms_c_info *wlc,
-					   bool drop);
 extern int brcms_c_set_channel(struct brcms_c_info *wlc, u16 channel);
 extern int brcms_c_set_rate_limit(struct brcms_c_info *wlc, u16 srl, u16 lrl);
 extern void brcms_c_get_current_rateset(struct brcms_c_info *wlc,
@@ -368,5 +366,7 @@ extern int brcms_c_set_tx_power(struct brcms_c_info *wlc, int txpwr);
 extern int brcms_c_get_tx_power(struct brcms_c_info *wlc);
 extern bool brcms_c_check_radio_disabled(struct brcms_c_info *wlc);
 extern void brcms_c_mute(struct brcms_c_info *wlc, bool on);
+extern void brcms_c_pktq_flush(struct brcms_c_info *wlc);
+extern bool brcms_c_tx_flush_completed(struct brcms_c_info *wlc);
 
 #endif				/* _BRCM_PUB_H_ */
-- 
1.7.9.5


