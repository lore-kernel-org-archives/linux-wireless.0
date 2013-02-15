Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:55682 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443Ab3BOLk7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 06:40:59 -0500
Received: by mail-bk0-f49.google.com with SMTP id w11so1512349bku.36
        for <linux-wireless@vger.kernel.org>; Fri, 15 Feb 2013 03:40:58 -0800 (PST)
From: Marco Porsch <marco@cozybit.com>
To: johannes@sipsolutions.net, mcgrof@qca.qualcomm.com,
	jouni@qca.qualcomm.com, vthiagar@qca.qualcomm.com,
	senthilb@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	ath9k-devel@lists.ath9k.org, Marco Porsch <marco@cozybit.com>
Subject: [PATCH 3/3] ath9k: mesh powersave support
Date: Fri, 15 Feb 2013 12:40:46 +0100
Message-Id: <1360928446-543-3-git-send-email-marco@cozybit.com> (sfid-20130215_124106_335850_480B4DF4)
In-Reply-To: <1360928446-543-1-git-send-email-marco@cozybit.com>
References: <1360928446-543-1-git-send-email-marco@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Register mesh PS ops on interface add and de-register on
removal.

React to doze/wakeup calls issued by mac80211.
Add a PS status flag PS_MAC80211_CTL to store last mesh PS
command from mac80211.

Initialize HW beacon wakeup registers.
On doze call configure the HW to wakeup on the given TSF value.

Signed-off-by: Marco Porsch <marco@cozybit.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |    1 +
 drivers/net/wireless/ath/ath9k/beacon.c |   21 ++++++++++-
 drivers/net/wireless/ath/ath9k/hw.c     |   17 +++++++--
 drivers/net/wireless/ath/ath9k/main.c   |   63 ++++++++++++++++++++++++++++++-
 4 files changed, 95 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 97c90b2..b82727b 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -652,6 +652,7 @@ enum sc_op_flags {
 #define PS_WAIT_FOR_TX_ACK        BIT(3)
 #define PS_BEACON_SYNC            BIT(4)
 #define PS_WAIT_FOR_ANI           BIT(5)
+#define PS_MAC80211_CTL           BIT(6)
 
 struct ath_rate_table;
 
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index dd37719..7ef698b 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -599,6 +599,23 @@ static void ath9k_beacon_config_adhoc(struct ath_softc *sc,
 	ath9k_beacon_init(sc, nexttbtt, intval);
 }
 
+static void ath9k_beacon_config_mesh(struct ath_softc *sc,
+				     struct ath_beacon_config *conf)
+{
+	struct ath9k_beacon_state bs;
+
+	/*
+	 * when PS is enabled, ath9k_hw_setrxabort is set.
+	 * to wake up again to receive peers' beacons, we set an
+	 * arbitrary initial value for sleepduration here
+	 */
+	memset(&bs, 0, sizeof(bs));
+	bs.bs_sleepduration = IEEE80211_MS_TO_TU(100);
+	ath9k_hw_set_sta_beacon_timers(sc->sc_ah, &bs);
+
+	ath9k_beacon_config_adhoc(sc, conf);
+}
+
 bool ath9k_allow_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
@@ -707,9 +724,11 @@ void ath9k_set_beacon(struct ath_softc *sc)
 		ath9k_beacon_config_ap(sc, cur_conf);
 		break;
 	case NL80211_IFTYPE_ADHOC:
-	case NL80211_IFTYPE_MESH_POINT:
 		ath9k_beacon_config_adhoc(sc, cur_conf);
 		break;
+	case NL80211_IFTYPE_MESH_POINT:
+		ath9k_beacon_config_mesh(sc, cur_conf);
+		break;
 	case NL80211_IFTYPE_STATION:
 		ath9k_beacon_config_sta(sc, cur_conf);
 		break;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 42cf3c7..0e0fe03 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2254,16 +2254,24 @@ void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period)
 }
 EXPORT_SYMBOL(ath9k_hw_beaconinit);
 
+/**
+ * ath9k_hw_set_sta_beacon_timers
+ *
+ * in mesh mode overwriting AR_NEXT_TBTT_TIMER and setting AR_TBTT_TIMER_EN
+ * would shift the own TBTT
+ */
 void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 				    const struct ath9k_beacon_state *bs)
 {
 	u32 nextTbtt, beaconintval, dtimperiod, beacontimeout;
+	u32 ar_timer_mode = AR_DTIM_TIMER_EN | AR_TIM_TIMER_EN;
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	struct ath_common *common = ath9k_hw_common(ah);
 
 	ENABLE_REGWRITE_BUFFER(ah);
 
-	REG_WRITE(ah, AR_NEXT_TBTT_TIMER, TU_TO_USEC(bs->bs_nexttbtt));
+	if (ah->opmode != NL80211_IFTYPE_MESH_POINT)
+		REG_WRITE(ah, AR_NEXT_TBTT_TIMER, TU_TO_USEC(bs->bs_nexttbtt));
 
 	REG_WRITE(ah, AR_BEACON_PERIOD,
 		  TU_TO_USEC(bs->bs_intval));
@@ -2317,9 +2325,10 @@ void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 
 	REGWRITE_BUFFER_FLUSH(ah);
 
-	REG_SET_BIT(ah, AR_TIMER_MODE,
-		    AR_TBTT_TIMER_EN | AR_TIM_TIMER_EN |
-		    AR_DTIM_TIMER_EN);
+	if (ah->opmode != NL80211_IFTYPE_MESH_POINT)
+		ar_timer_mode |= AR_TBTT_TIMER_EN;
+
+	REG_SET_BIT(ah, AR_TIMER_MODE, ar_timer_mode);
 
 	/* TSF Out of Range Threshold */
 	REG_WRITE(ah, AR_TSFOOR_THRESHOLD, bs->bs_tsfoor_threshold);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 5432f12..93c66cb 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -132,7 +132,8 @@ void ath9k_ps_restore(struct ath_softc *sc)
 				     PS_WAIT_FOR_CAB |
 				     PS_WAIT_FOR_PSPOLL_DATA |
 				     PS_WAIT_FOR_TX_ACK |
-				     PS_WAIT_FOR_ANI))) {
+				     PS_WAIT_FOR_ANI |
+				     PS_MAC80211_CTL))) {
 		mode = ATH9K_PM_NETWORK_SLEEP;
 		if (ath9k_hw_btcoex_is_enabled(sc->sc_ah))
 			ath9k_btcoex_stop_gen_timer(sc);
@@ -150,6 +151,59 @@ void ath9k_ps_restore(struct ath_softc *sc)
 	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
 }
 
+static void ath9k_mesh_wakeup_set(struct ath_softc *sc, u64 nexttbtt)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath9k_beacon_state bs;
+	u32 nexttbtttu = TSF_TO_TU(nexttbtt >> 32, nexttbtt);
+
+	memset(&bs, 0, sizeof(bs));
+	bs.bs_nexttbtt = nexttbtttu;
+	bs.bs_nextdtim = nexttbtttu;
+	/* arbitrary high values to avoid frequent wakeups */
+	bs.bs_intval = 1000;
+	bs.bs_dtimperiod = 4000;
+	bs.bs_sleepduration = 1000;
+
+	ath9k_hw_set_sta_beacon_timers(ah, &bs);
+}
+
+static void ath9k_mesh_doze(struct ieee80211_hw *hw, u64 nexttbtt)
+{
+	struct ath_softc *sc = hw->priv;
+	unsigned long flags;
+
+	ath9k_ps_wakeup(sc);
+	spin_lock_irqsave(&sc->sc_pm_lock, flags);
+	/* in mesh mode mac80211 checks beacons and CAB */
+	sc->ps_flags &= ~(PS_WAIT_FOR_BEACON |
+			  PS_WAIT_FOR_CAB |
+			  PS_MAC80211_CTL);
+	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
+
+	if (nexttbtt)
+		ath9k_mesh_wakeup_set(sc, nexttbtt);
+
+	ath9k_ps_restore(sc);
+}
+
+static void ath9k_mesh_wakeup(struct ieee80211_hw *hw)
+{
+	struct ath_softc *sc = hw->priv;
+	unsigned long flags;
+
+	ath9k_ps_wakeup(sc);
+	spin_lock_irqsave(&sc->sc_pm_lock, flags);
+	sc->ps_flags |= PS_MAC80211_CTL;
+	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
+	ath9k_ps_restore(sc);
+}
+
+static const struct ieee80211_mps_ops ath9k_mesh_ps_ops = {
+	.hw_doze = ath9k_mesh_doze,
+	.hw_wakeup = ath9k_mesh_wakeup,
+};
+
 static void __ath_cancel_work(struct ath_softc *sc)
 {
 	cancel_work_sync(&sc->paprd_work);
@@ -931,6 +985,11 @@ static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
 			ah->opmode = NL80211_IFTYPE_ADHOC;
 		else
 			ah->opmode = NL80211_IFTYPE_STATION;
+
+		if (ah->opmode == NL80211_IFTYPE_MESH_POINT)
+			ieee80211_mps_init(hw, &ath9k_mesh_ps_ops);
+		else if (old_opmode == NL80211_IFTYPE_MESH_POINT)
+			ieee80211_mps_init(hw, NULL);
 	}
 
 	ath9k_hw_setopmode(ah);
@@ -1164,7 +1223,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	 * We just prepare to enable PS. We have to wait until our AP has
 	 * ACK'd our null data frame to disable RX otherwise we'll ignore
 	 * those ACKs and end up retransmitting the same null data frames.
-	 * IEEE80211_CONF_CHANGE_PS is only passed by mac80211 for STA mode.
+	 * IEEE80211_CONF_CHANGE_PS is passed by mac80211 for STA or mesh mode.
 	 */
 	if (changed & IEEE80211_CONF_CHANGE_PS) {
 		unsigned long flags;
-- 
1.7.9.5

