Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4095 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757662Ab3BBNhq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Feb 2013 08:37:46 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>,
	"Jonathan Nieder" <jrnieder@gmail.com>,
	"Stanislaw Gruszka" <sgruszka@redhat.com>,
	=?UTF-8?q?Camale=C3=B3n?= <noelamac@gmail.com>,
	"Milan Bouchet-Valat" <nalimilan@club-internet.fr>,
	"Seth Forshee" <seth.forshee@canonical.com>
Subject: [PATCH for 3.8] brcmsmac: rework of mac80211 .flush() callback
 operation
Date: Sat, 2 Feb 2013 14:36:50 +0100
Message-ID: <1359812210-31658-1-git-send-email-arend@broadcom.com> (sfid-20130202_143811_885212_A5C76DD9)
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch addresses a long standing issue of the driver with the
mac80211 .flush() callback. Since implementing the .flush() callback
a number of issues have been fixed, but a WARN_ON_ONCE() was still
triggered because the timeout on the flush could still occur.

This patch changes the awkward design using msleep() into one using
a waitqueue. The waiting flush() context will kick the transmit dma
when it is idle and the timeout used waiting for the event is set
to 500 ms. Worst case there can be 64 frames outstanding for transmit
in the driver. At a rate of 1Mbps that would take 1.5 seconds assuming
MTU is 1500 bytes and ignoring retries. The WARN_ON_ONCE() is also
removed as this was put in to indicate the flush timeout as a reason
for the driver to stall. That was not happening since fixing endless
AMPDU retries with following upstream commit:

commit 85091fc0a75653e239dc8379658515e577544927
Author: Arend van Spriel <arend@broadcom.com>
Date:   Thu Feb 23 18:38:22 2012 +0100

    brcm80211: smac: fix endless retry of A-MPDU transmissions

bugzilla: 42840 <https://bugzilla.kernel.org/show_bug.cgi?id=42840>
bugzilla@redhat: <https://bugzilla.redhat.com/show_bug.cgi?id=799168>
bugzilla@redhat: <https://bugzilla.redhat.com/show_bug.cgi?id=787649>

Cc: Jonathan Nieder <jrnieder@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Camaleón <noelamac@gmail.com>
Cc: Milan Bouchet-Valat <nalimilan@club-internet.fr>
Cc: Seth Forshee <seth.forshee@canonical.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Hi John,

Hope this one can still ride the 3.8 train. Spent a long time in the
last few weeks on the dreaded flush timeout warning. This patch was
submitted before but it has been reworked to fit with Seth's brcmsmac
changes. Also increased the timeout value to a more reasonable value
as theoretical limit is higher as indicated in the commit message.

Gr. AvS
---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   35 ++++++++++++--------
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.h  |    3 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   15 ++-------
 drivers/net/wireless/brcm80211/brcmsmac/pub.h      |    3 +-
 4 files changed, 27 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 0f71d1d..e5fd209 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -36,6 +36,7 @@
 #include "debug.h"
 
 #define N_TX_QUEUES	4 /* #tx queues on mac80211<->driver interface */
+#define BRCMS_FLUSH_TIMEOUT	500 /* msec */
 
 /* Flags we support */
 #define MAC_FILTERS (FIF_PROMISC_IN_BSS | \
@@ -708,16 +709,29 @@ static void brcms_ops_rfkill_poll(struct ieee80211_hw *hw)
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
+	ret = wait_event_timeout(wl->tx_flush_wq,
+				 brcms_tx_flush_completed(wl),
+				 msecs_to_jiffies(BRCMS_FLUSH_TIMEOUT));
+
+	brcms_dbg_mac80211(wl->wlc->hw->d11core,
+			   "ret=%d\n", jiffies_to_msecs(ret));
 }
 
 static const struct ieee80211_ops brcms_ops = {
@@ -772,6 +786,7 @@ void brcms_dpc(unsigned long data)
 
  done:
 	spin_unlock_bh(&wl->lock);
+	wake_up(&wl->tx_flush_wq);
 }
 
 /*
@@ -1020,6 +1035,8 @@ static struct brcms_info *brcms_attach(struct bcma_device *pdev)
 
 	atomic_set(&wl->callbacks, 0);
 
+	init_waitqueue_head(&wl->tx_flush_wq);
+
 	/* setup the bottom half handler */
 	tasklet_init(&wl->tasklet, brcms_dpc, (unsigned long) wl);
 
@@ -1609,13 +1626,3 @@ bool brcms_rfkill_set_hw_state(struct brcms_info *wl)
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
index 9f3d7e9..8b58390 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -7511,25 +7511,16 @@ int brcms_c_get_curband(struct brcms_c_info *wlc)
 	return wlc->band->bandunit;
 }
 
-void brcms_c_wait_for_tx_completion(struct brcms_c_info *wlc, bool drop)
+bool brcms_c_tx_flush_completed(struct brcms_c_info *wlc)
 {
-	int timeout = 20;
 	int i;
 
 	/* Kick DMA to send any pending AMPDU */
 	for (i = 0; i < ARRAY_SIZE(wlc->hw->di); i++)
 		if (wlc->hw->di[i])
-			dma_txflush(wlc->hw->di[i]);
+			dma_kick_tx(wlc->hw->di[i]);
 
-	/* wait for queue and DMA fifos to run dry */
-	while (brcms_txpktpendtot(wlc) > 0) {
-		brcms_msleep(wlc->wl, 1);
-
-		if (--timeout == 0)
-			break;
-	}
-
-	WARN_ON_ONCE(timeout == 0);
+	return !brcms_txpktpendtot(wlc);
 }
 
 void brcms_c_set_beacon_listen_interval(struct brcms_c_info *wlc, u8 interval)
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pub.h b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
index 4fb2834..b0f14b7 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pub.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
@@ -314,8 +314,6 @@ extern void brcms_c_associate_upd(struct brcms_c_info *wlc, bool state);
 extern void brcms_c_scan_start(struct brcms_c_info *wlc);
 extern void brcms_c_scan_stop(struct brcms_c_info *wlc);
 extern int brcms_c_get_curband(struct brcms_c_info *wlc);
-extern void brcms_c_wait_for_tx_completion(struct brcms_c_info *wlc,
-					   bool drop);
 extern int brcms_c_set_channel(struct brcms_c_info *wlc, u16 channel);
 extern int brcms_c_set_rate_limit(struct brcms_c_info *wlc, u16 srl, u16 lrl);
 extern void brcms_c_get_current_rateset(struct brcms_c_info *wlc,
@@ -332,5 +330,6 @@ extern int brcms_c_set_tx_power(struct brcms_c_info *wlc, int txpwr);
 extern int brcms_c_get_tx_power(struct brcms_c_info *wlc);
 extern bool brcms_c_check_radio_disabled(struct brcms_c_info *wlc);
 extern void brcms_c_mute(struct brcms_c_info *wlc, bool on);
+extern bool brcms_c_tx_flush_completed(struct brcms_c_info *wlc);
 
 #endif				/* _BRCM_PUB_H_ */
-- 
1.7.10.4


