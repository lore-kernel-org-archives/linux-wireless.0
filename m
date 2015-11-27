Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:35499 "EHLO
	mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169AbbK0Ihj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2015 03:37:39 -0500
Received: by lfdl133 with SMTP id l133so120692710lfd.2
        for <linux-wireless@vger.kernel.org>; Fri, 27 Nov 2015 00:37:37 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, nbd@openwrt.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 11/13] ath9k: MCC add sta_ap_ratio module param
Date: Fri, 27 Nov 2015 09:37:16 +0100
Message-Id: <1448613438-5173-11-git-send-email-janusz.dziedzic@tieto.com> (sfid-20151127_095251_907873_95A0AFB1)
In-Reply-To: <1448613438-5173-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1448613438-5173-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of MCC we can setup STA/AP(GO) ratio.
Eg. setting sta_ap_ratio=80
STA will get 80% of time, while AP(GO) 20%.
Setup correct ctwindow.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  2 +
 drivers/net/wireless/ath/ath9k/channel.c | 69 +++++++++++++++++++++-----------
 drivers/net/wireless/ath/ath9k/hw.h      |  1 +
 drivers/net/wireless/ath/ath9k/init.c    |  3 ++
 4 files changed, 51 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index b42f4a9..4616229 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -37,6 +37,7 @@ extern int ath9k_modparam_nohwcrypt;
 extern int ath9k_led_blink;
 extern bool is_ath9k_unloaded;
 extern int ath9k_use_chanctx;
+extern int ath9k_sta_ap_ratio;
 
 /*************************/
 /* Descriptor Management */
@@ -335,6 +336,7 @@ struct ath_chanctx {
 	struct timespec tsf_ts;
 	u64 tsf_val;
 	u32 last_beacon;
+	u32 ctwindow;
 
 	int flush_timeout;
 	u16 txpower;
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index c94d7d9..8ab856c 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -313,11 +313,21 @@ ath_chanctx_get_next(struct ath_softc *sc, struct ath_chanctx *ctx)
 	return &sc->chanctx[!idx];
 }
 
+static u32 get_ratio(u32 beacon_int)
+{
+	if (ath9k_sta_ap_ratio < 20 ||
+	    ath9k_sta_ap_ratio > 80)
+		return beacon_int / 2;
+
+	return (beacon_int * ath9k_sta_ap_ratio) / 100;
+}
+
 static void ath_chanctx_adjust_tbtt_delta(struct ath_softc *sc)
 {
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_chanctx *prev, *cur;
 	struct timespec ts;
-	u32 cur_tsf, prev_tsf, beacon_int;
+	u32 cur_tsf, prev_tsf, beacon_int, diff;
 	s32 offset;
 
 	beacon_int = TU_TO_USEC(sc->cur_chan->beacon.beacon_interval);
@@ -344,7 +354,14 @@ static void ath_chanctx_adjust_tbtt_delta(struct ath_softc *sc)
 	if (offset < 0 || offset > 3 * beacon_int)
 		return;
 
-	offset = beacon_int / 2 - (offset % beacon_int);
+	diff = 2 * prev->ctwindow;
+	diff += sc->sched.channel_switch_time;
+	if (diff > beacon_int / 2)
+		diff = beacon_int / 2;
+
+	ath_dbg(common, CHAN_CTX, "Setup beacon interval offset %u ms\n",
+		diff / 1000);
+	offset = diff - (offset % beacon_int);
 	prev->tsf_val += offset;
 }
 
@@ -435,7 +452,7 @@ static void ath_chanctx_set_periodic_noa(struct ath_softc *sc,
 			sc->sched.channel_switch_time;
 	else
 		avp->noa_duration =
-			TU_TO_USEC(cur_conf->beacon_interval) / 2 +
+			TU_TO_USEC(get_ratio(cur_conf->beacon_interval)) +
 			sc->sched.channel_switch_time;
 
 	if (test_bit(ATH_OP_SCANNING, &common->op_flags) ||
@@ -481,7 +498,8 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 	struct ath_beacon_config *cur_conf;
 	struct ath_vif *avp = NULL;
 	struct ath_chanctx *ctx;
-	u32 tsf_time;
+	u32 tsf_time, defer_time;
+	u32 beacon_resp_time = ah->config.sw_beacon_response_time;
 	u32 beacon_int;
 
 	if (vif)
@@ -565,10 +583,26 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		cur_conf = &sc->cur_chan->beacon;
 		beacon_int = TU_TO_USEC(cur_conf->beacon_interval);
 
-		/* defer channel switch by a quarter beacon interval */
-		tsf_time = sc->sched.next_tbtt + beacon_int / 4;
+		/* defer channel switch */
+		defer_time = beacon_int - get_ratio(beacon_int);
+		defer_time -= sc->sched.channel_switch_time;
+		defer_time /= 2;
+
+		if (defer_time < TU_TO_USEC(2 + beacon_resp_time)) {
+			defer_time *= 2;
+			if (defer_time > TU_TO_USEC(3 + beacon_resp_time))
+				defer_time -= TU_TO_USEC(3 + beacon_resp_time);
+			else
+				defer_time = 1000;
+		}
+
+		ath_dbg(common, CHAN_CTX, "Setup defer_time %u (%u ms)\n",
+			defer_time, defer_time / 1000);
+
+		tsf_time = sc->sched.next_tbtt + defer_time;
 		sc->sched.switch_start_time = tsf_time;
 		sc->cur_chan->last_beacon = sc->sched.next_tbtt;
+		sc->cur_chan->ctwindow = defer_time;
 
 		/*
 		 * If an offchannel switch is scheduled to happen after
@@ -707,7 +741,7 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		sc->sched.state = ATH_CHANCTX_STATE_WAIT_FOR_TIMER;
 		sc->sched.wait_switch = false;
 
-		tsf_time = TU_TO_USEC(cur_conf->beacon_interval) / 2;
+		tsf_time = TU_TO_USEC(get_ratio(cur_conf->beacon_interval));
 
 		if (sc->sched.extend_absence) {
 			sc->sched.beacon_miss = 0;
@@ -1454,26 +1488,13 @@ static void ath9k_update_p2p_ps(struct ath_softc *sc, struct ieee80211_vif *vif)
 
 static u8 ath9k_get_ctwin(struct ath_softc *sc, struct ath_vif *avp)
 {
-	struct ath_beacon_config *cur_conf = &sc->cur_chan->beacon;
-	u8 switch_time, ctwin;
-
 	/*
 	 * Channel switch in multi-channel mode is deferred
-	 * by a quarter beacon interval when handling
-	 * ATH_CHANCTX_EVENT_BEACON_PREPARE, so the P2P-GO
-	 * interface is guaranteed to be discoverable
-	 * for that duration after a TBTT.
+	 * when handling ATH_CHANCTX_EVENT_BEACON_PREPARE,
+	 * so the P2P-GO interface is guaranteed to be
+	 * discoverable for that duration after a TBTT.
 	 */
-	switch_time = cur_conf->beacon_interval / 4;
-
-	ctwin = avp->vif->bss_conf.p2p_noa_attr.oppps_ctwindow;
-	if (ctwin && (ctwin < switch_time))
-		return ctwin;
-
-	if (switch_time < P2P_DEFAULT_CTWIN)
-		return 0;
-
-	return P2P_DEFAULT_CTWIN;
+	return USEC_TO_TU(sc->cur_chan->ctwindow);
 }
 
 void ath9k_beacon_add_noa(struct ath_softc *sc, struct ath_vif *avp,
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 4f0a3f6..7528f00 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -193,6 +193,7 @@
 #define INIT_BCON_CNTRL_REG         0x00000000
 
 #define TU_TO_USEC(_tu)             ((_tu) << 10)
+#define USEC_TO_TU(_us)             ((_us) >> 10)
 
 #define ATH9K_HW_RX_HP_QDEPTH	16
 #define ATH9K_HW_RX_LP_QDEPTH	128
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 2e2b92b..6729a5f 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -67,6 +67,9 @@ int ath9k_use_chanctx;
 module_param_named(use_chanctx, ath9k_use_chanctx, int, 0444);
 MODULE_PARM_DESC(use_chanctx, "Enable channel context for concurrency");
 
+int ath9k_sta_ap_ratio;
+module_param_named(sta_ap_ratio, ath9k_sta_ap_ratio, int, 0444);
+MODULE_PARM_DESC(sta_ap_ratio, "sta/ap ratio 20-80");
 #endif /* CONFIG_ATH9K_CHANNEL_CONTEXT */
 
 bool is_ath9k_unloaded;
-- 
1.9.1

