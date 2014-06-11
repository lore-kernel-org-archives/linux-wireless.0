Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11813 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbaFKKui (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 06:50:38 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@openwrt.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 26/28] ath9k: Add recovery mechanism for hw TSF timer
Date: Wed, 11 Jun 2014 16:18:14 +0530
Message-ID: <1402483696-2498-27-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140611_130501_076786_52810A55)
In-Reply-To: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Configure the TSF based hardware timer for a channel switch.
Also set up backup software timer, in case the gen timer fails.
This could be caused by a hardware reset.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  4 ++++
 drivers/net/wireless/ath/ath9k/channel.c | 32 +++++++++++++++++++++++++-------
 drivers/net/wireless/ath/ath9k/init.c    |  1 +
 drivers/net/wireless/ath/ath9k/main.c    |  1 +
 4 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index ee00ddb..757dd60 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -374,6 +374,9 @@ struct ath_chanctx_sched {
 	u32 switch_start_time;
 	unsigned int offchannel_duration;
 	unsigned int channel_switch_time;
+
+	/* backup, in case the hardware timer fails */
+	struct timer_list timer;
 };
 
 enum ath_offchannel_state {
@@ -426,6 +429,7 @@ struct ath_chanctx *ath_chanctx_get_oper_chan(struct ath_softc *sc,
 					      bool active);
 void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		       enum ath_chanctx_event ev);
+void ath_chanctx_timer(unsigned long data);
 
 int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan);
 int ath_startrecv(struct ath_softc *sc);
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 0a38eea..ba214eb 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -469,6 +469,27 @@ static void ath_chanctx_adjust_tbtt_delta(struct ath_softc *sc)
 	prev->tsf_val += offset;
 }
 
+void ath_chanctx_timer(unsigned long data)
+{
+	struct ath_softc *sc = (struct ath_softc *) data;
+
+	ath_chanctx_event(sc, NULL, ATH_CHANCTX_EVENT_TSF_TIMER);
+}
+
+/* Configure the TSF based hardware timer for a channel switch.
+ * Also set up backup software timer, in case the gen timer fails.
+ * This could be caused by a hardware reset.
+ */
+static void ath_chanctx_setup_timer(struct ath_softc *sc, u32 tsf_time)
+{
+	struct ath_hw *ah = sc->sc_ah;
+
+	ath9k_hw_gen_timer_start(ah, sc->p2p_ps_timer, tsf_time, 1000000);
+	tsf_time -= ath9k_hw_gettsf32(ah);
+	tsf_time = msecs_to_jiffies(tsf_time / 1000) + 1;
+	mod_timer(&sc->sched.timer, tsf_time);
+}
+
 void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		       enum ath_chanctx_event ev)
 {
@@ -566,9 +587,7 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 			break;
 
 		sc->sched.state = ATH_CHANCTX_STATE_WAIT_FOR_TIMER;
-		ath9k_hw_gen_timer_start(ah, sc->p2p_ps_timer,
-					 sc->sched.switch_start_time,
-					 1000000);
+		ath_chanctx_setup_timer(sc, sc->sched.switch_start_time);
 		break;
 	case ATH_CHANCTX_EVENT_TSF_TIMER:
 		if (sc->sched.state != ATH_CHANCTX_STATE_WAIT_FOR_TIMER)
@@ -598,8 +617,8 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 			ath9k_hw_get_tsf_offset(&sc->cur_chan->tsf_ts, NULL);
 		tsf_time += ath9k_hw_gettsf32(ah);
 
-		ath9k_hw_gen_timer_start(ah, sc->p2p_ps_timer,
-					 tsf_time, 1000000);
+
+		ath_chanctx_setup_timer(sc, tsf_time);
 		break;
 	case ATH_CHANCTX_EVENT_ASSOC:
 		if (sc->sched.state != ATH_CHANCTX_STATE_FORCE_ACTIVE ||
@@ -633,8 +652,7 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		tsf_time += ath9k_hw_gettsf32(sc->sc_ah);
 		sc->sched.switch_start_time = tsf_time;
 
-		ath9k_hw_gen_timer_start(ah, sc->p2p_ps_timer,
-					 tsf_time, 1000000);
+		ath_chanctx_setup_timer(sc, tsf_time);
 		sc->sched.beacon_pending = true;
 		break;
 	case ATH_CHANCTX_EVENT_ENABLE_MULTICHANNEL:
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 66a9dc3..a4afcb1 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -569,6 +569,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	INIT_DELAYED_WORK(&sc->hw_pll_work, ath_hw_pll_work);
 	setup_timer(&sc->offchannel.timer, ath_offchannel_timer,
 		    (unsigned long)sc);
+	setup_timer(&sc->sched.timer, ath_chanctx_timer, (unsigned long)sc);
 
 	/*
 	 * Cache line size is used to size and align various
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index f7d8dda..b307e6e 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1668,6 +1668,7 @@ void ath9k_p2p_ps_timer(void *priv)
 	struct ath_node *an;
 	u32 tsf;
 
+	del_timer_sync(&sc->sched.timer);
 	ath9k_hw_gen_timer_stop(sc->sc_ah, sc->p2p_ps_timer);
 	ath_chanctx_event(sc, NULL, ATH_CHANCTX_EVENT_TSF_TIMER);
 
-- 
2.0.0

