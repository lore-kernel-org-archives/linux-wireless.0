Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:37994 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbaHWH7V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2014 03:59:21 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 01/18] ath9k: Add a routine for initializing channel contexts
Date: Sat, 23 Aug 2014 13:29:06 +0530
Message-Id: <1408780763-27974-2-git-send-email-sujith@msujith.org> (sfid-20140823_095936_814377_7D6D24CF)
In-Reply-To: <1408780763-27974-1-git-send-email-sujith@msujith.org>
References: <1408780763-27974-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Setup the offchannel/sched timers and the chanctx work
inside the new function.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  6 ++++--
 drivers/net/wireless/ath/ath9k/channel.c | 28 +++++++++++++++++++---------
 drivers/net/wireless/ath/ath9k/init.c    |  6 ++----
 3 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 035f6f9..eb3572f 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -422,7 +422,6 @@ void ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
 void ath_chanctx_switch(struct ath_softc *sc, struct ath_chanctx *ctx,
 			struct cfg80211_chan_def *chandef);
 void ath_chanctx_check_active(struct ath_softc *sc, struct ath_chanctx *ctx);
-void ath_offchannel_timer(unsigned long data);
 void ath_offchannel_channel_change(struct ath_softc *sc);
 void ath_chanctx_offchan_switch(struct ath_softc *sc,
 				struct ieee80211_channel *chan);
@@ -430,7 +429,6 @@ struct ath_chanctx *ath_chanctx_get_oper_chan(struct ath_softc *sc,
 					      bool active);
 void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		       enum ath_chanctx_event ev);
-void ath_chanctx_timer(unsigned long data);
 void ath_offchannel_next(struct ath_softc *sc);
 void ath_scan_complete(struct ath_softc *sc, bool abort);
 void ath_roc_complete(struct ath_softc *sc, bool abort);
@@ -438,6 +436,7 @@ void ath_roc_complete(struct ath_softc *sc, bool abort);
 #ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
 bool ath9k_is_chanctx_enabled(void);
 void ath9k_fill_chanctx_ops(void);
+void ath9k_init_channel_context(struct ath_softc *sc);
 int ath9k_init_p2p(struct ath_softc *sc);
 void ath9k_deinit_p2p(struct ath_softc *sc);
 void ath9k_p2p_remove_vif(struct ath_softc *sc,
@@ -454,6 +453,9 @@ static inline bool ath9k_is_chanctx_enabled(void)
 static inline void ath9k_fill_chanctx_ops(void)
 {
 }
+static inline void ath9k_init_channel_context(struct ath_softc *sc)
+{
+}
 static inline int ath9k_init_p2p(struct ath_softc *sc)
 {
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 36d73c0..a4366c1 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -499,13 +499,6 @@ static void ath_chanctx_adjust_tbtt_delta(struct ath_softc *sc)
 	prev->tsf_val += offset;
 }
 
-void ath_chanctx_timer(unsigned long data)
-{
-	struct ath_softc *sc = (struct ath_softc *) data;
-
-	ath_chanctx_event(sc, NULL, ATH_CHANCTX_EVENT_TSF_TIMER);
-}
-
 /* Configure the TSF based hardware timer for a channel switch.
  * Also set up backup software timer, in case the gen timer fails.
  * This could be caused by a hardware reset.
@@ -907,7 +900,16 @@ void ath_offchannel_channel_change(struct ath_softc *sc)
 	}
 }
 
-void ath_offchannel_timer(unsigned long data)
+#ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
+
+static void ath_chanctx_timer(unsigned long data)
+{
+	struct ath_softc *sc = (struct ath_softc *) data;
+
+	ath_chanctx_event(sc, NULL, ATH_CHANCTX_EVENT_TSF_TIMER);
+}
+
+static void ath_offchannel_timer(unsigned long data)
 {
 	struct ath_softc *sc = (struct ath_softc *)data;
 	struct ath_chanctx *ctx;
@@ -947,7 +949,15 @@ void ath_offchannel_timer(unsigned long data)
 	}
 }
 
-#ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
+void ath9k_init_channel_context(struct ath_softc *sc)
+{
+	INIT_WORK(&sc->chanctx_work, ath_chanctx_work);
+
+	setup_timer(&sc->offchannel.timer, ath_offchannel_timer,
+		    (unsigned long)sc);
+	setup_timer(&sc->sched.timer, ath_chanctx_timer,
+		    (unsigned long)sc);
+}
 
 bool ath9k_is_chanctx_enabled(void)
 {
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index cfd475b..fe0311a 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -571,11 +571,9 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	setup_timer(&sc->sleep_timer, ath_ps_full_sleep, (unsigned long)sc);
 	INIT_WORK(&sc->hw_reset_work, ath_reset_work);
 	INIT_WORK(&sc->paprd_work, ath_paprd_calibrate);
-	INIT_WORK(&sc->chanctx_work, ath_chanctx_work);
 	INIT_DELAYED_WORK(&sc->hw_pll_work, ath_hw_pll_work);
-	setup_timer(&sc->offchannel.timer, ath_offchannel_timer,
-		    (unsigned long)sc);
-	setup_timer(&sc->sched.timer, ath_chanctx_timer, (unsigned long)sc);
+
+	ath9k_init_channel_context(sc);
 
 	/*
 	 * Cache line size is used to size and align various
-- 
2.0.4

