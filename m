Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:54951 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbaJQCJt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2014 22:09:49 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 04/23] ath9k: Unify reset API
Date: Fri, 17 Oct 2014 07:40:11 +0530
Message-Id: <1413511830-5536-5-git-send-email-sujith@msujith.org> (sfid-20141017_040958_396323_811B4845)
In-Reply-To: <1413511830-5536-1-git-send-email-sujith@msujith.org>
References: <1413511830-5536-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Instead of having ath_reset_internal() and ath_reset()
as two separate calls to perform a HW reset, have
one function. This makes sure that the behavior will
be the same at all callsites.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  3 +--
 drivers/net/wireless/ath/ath9k/channel.c |  2 +-
 drivers/net/wireless/ath/ath9k/main.c    | 12 +++++++-----
 drivers/net/wireless/ath/ath9k/tx99.c    |  4 ++--
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index aff5e4c..bc90fab 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -540,7 +540,6 @@ static inline void ath_chanctx_check_active(struct ath_softc *sc,
 
 #endif /* CONFIG_ATH9K_CHANNEL_CONTEXT */
 
-int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan);
 void ath_startrecv(struct ath_softc *sc);
 bool ath_stoprecv(struct ath_softc *sc);
 u32 ath_calcrxfilter(struct ath_softc *sc);
@@ -1069,7 +1068,7 @@ void ath9k_tasklet(unsigned long data);
 int ath_cabq_update(struct ath_softc *);
 u8 ath9k_parse_mpdudensity(u8 mpdudensity);
 irqreturn_t ath_isr(int irq, void *dev);
-int ath_reset(struct ath_softc *sc);
+int ath_reset(struct ath_softc *sc, struct ath9k_channel *hchan);
 void ath_cancel_work(struct ath_softc *sc);
 void ath_restart_work(struct ath_softc *sc);
 int ath9k_init_device(u16 devid, struct ath_softc *sc,
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 135f74c..709facc 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -66,7 +66,7 @@ static int ath_set_channel(struct ath_softc *sc)
 	}
 
 	hchan = &sc->sc_ah->channels[pos];
-	r = ath_reset_internal(sc, hchan);
+	r = ath_reset(sc, hchan);
 	if (r)
 		return r;
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 446bc46..eb6ba9f 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -270,7 +270,7 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 	return true;
 }
 
-int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan)
+static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -598,12 +598,12 @@ chip_reset:
 #undef SCHED_INTR
 }
 
-int ath_reset(struct ath_softc *sc)
+int ath_reset(struct ath_softc *sc, struct ath9k_channel *hchan)
 {
 	int r;
 
 	ath9k_ps_wakeup(sc);
-	r = ath_reset_internal(sc, NULL);
+	r = ath_reset_internal(sc, hchan);
 	ath9k_ps_restore(sc);
 
 	return r;
@@ -623,7 +623,9 @@ void ath_reset_work(struct work_struct *work)
 {
 	struct ath_softc *sc = container_of(work, struct ath_softc, hw_reset_work);
 
-	ath_reset(sc);
+	ath9k_ps_wakeup(sc);
+	ath_reset_internal(sc, NULL);
+	ath9k_ps_restore(sc);
 }
 
 /**********************/
@@ -2044,7 +2046,7 @@ void __ath9k_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 		spin_unlock_bh(&sc->sc_pcu_lock);
 
 		if (!drain_txq)
-			ath_reset(sc);
+			ath_reset(sc, NULL);
 
 		ath9k_ps_restore(sc);
 	}
diff --git a/drivers/net/wireless/ath/ath9k/tx99.c b/drivers/net/wireless/ath/ath9k/tx99.c
index 40ab65e..ac4781f 100644
--- a/drivers/net/wireless/ath/ath9k/tx99.c
+++ b/drivers/net/wireless/ath/ath9k/tx99.c
@@ -99,7 +99,7 @@ static struct sk_buff *ath9k_build_tx99_skb(struct ath_softc *sc)
 
 static void ath9k_tx99_deinit(struct ath_softc *sc)
 {
-	ath_reset(sc);
+	ath_reset(sc, NULL);
 
 	ath9k_ps_wakeup(sc);
 	ath9k_tx99_stop(sc);
@@ -127,7 +127,7 @@ static int ath9k_tx99_init(struct ath_softc *sc)
 	memset(&txctl, 0, sizeof(txctl));
 	txctl.txq = sc->tx.txq_map[IEEE80211_AC_VO];
 
-	ath_reset(sc);
+	ath_reset(sc, NULL);
 
 	ath9k_ps_wakeup(sc);
 
-- 
2.1.2

