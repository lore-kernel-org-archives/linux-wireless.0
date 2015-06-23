Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:33037 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbbFWIyv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2015 04:54:51 -0400
Received: by laka10 with SMTP id a10so2233941lak.0
        for <linux-wireless@vger.kernel.org>; Tue, 23 Jun 2015 01:54:49 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, nbd@openwrt.org, sujith@msujith.org,
	chaitanya.mgit@gmail.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 1/3 v2] ath9k: handle RoC cancel correctly
Date: Tue, 23 Jun 2015 10:54:22 +0200
Message-Id: <1435049662-20477-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150623_105456_774306_2C93A0EF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case we will get ROC cancel from mac80211 we
should not call ieee80211_remain_on_channel_expired().

In other case I hit such warning on MIPS and
p2p negotiation failed (tested with use_chanctx=1).

ath: phy0: Starting RoC period
ath: phy0: Channel definition created: 2412 MHz
ath: phy0: Assigned next_chan to 2412 MHz
ath: phy0: Offchannel duration for chan 2412 MHz : 506632
ath: phy0: ath_chanctx_set_next: current: 2412 MHz, next: 2412 MHz
ath: phy0: Stopping current chanctx: 2412
ath: phy0: Flush timeout: 200
ath: phy0: ath_chanctx_set_next: Set channel 2412 MHz
ath: phy0: Set channel: 2412 MHz width: 0
ath: phy0: Reset to 2412 MHz, HT40: 0 fastcc: 0
ath: phy0: cur_chan: 2412 MHz, event: ATH_CHANCTX_EVENT_TSF_TIMER, state: ATH_CHANCTX_STATE_IDLE
ath: phy0: ath_offchannel_channel_change: offchannel state: ATH_OFFCHANNEL_ROC_START
ath: phy0: cur_chan: 2412 MHz, event: ATH_CHANCTX_EVENT_SWITCH, state: ATH_CHANCTX_STATE_IDLE
ath: phy0: Cancel RoC
ath: phy0: RoC aborted
ath: phy0: RoC request on vif: 00:03:7f:4e:a0:cd, type: 1 duration: 500
ath: phy0: Starting RoC period
ath: phy0: Channel definition created: 2412 MHz
ath: phy0: Assigned next_chan to 2412 MHz
ath: phy0: Offchannel duration for chan 2412 MHz : 506705
ath: phy0: ath_chanctx_set_next: current: 2412 MHz, next: 2412 MHz
ath: phy0: ath_offchannel_channel_change: offchannel state: ATH_OFFCHANNEL_ROC_START
ath: phy0: cur_chan: 2412 MHz, event: ATH_CHANCTX_EVENT_SWITCH, state: ATH_CHANCTX_STATE_IDLE
------------[ cut here ]------------
WARNING: CPU: 0 PID: 3312 at drivers/net/wireless/ath/ath9k/main.c:2319
Modules linked in: ath9k ath9k_common ath9k_hw ath mac80211 cfg80211

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  8 +++++++-
 drivers/net/wireless/ath/ath9k/channel.c | 23 ++++++++++++++++-------
 drivers/net/wireless/ath/ath9k/main.c    |  4 ++--
 3 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 030fd0f..7d41c8f 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -409,6 +409,12 @@ enum ath_offchannel_state {
 	ATH_OFFCHANNEL_ROC_DONE,
 };
 
+enum ath_roc_complete_reason {
+	ATH_ROC_COMPLETE_EXPIRE,
+	ATH_ROC_COMPLETE_ABORT,
+	ATH_ROC_COMPLETE_CANCEL,
+};
+
 struct ath_offchannel {
 	struct ath_chanctx chan;
 	struct timer_list timer;
@@ -470,7 +476,7 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 void ath_chanctx_set_next(struct ath_softc *sc, bool force);
 void ath_offchannel_next(struct ath_softc *sc);
 void ath_scan_complete(struct ath_softc *sc, bool abort);
-void ath_roc_complete(struct ath_softc *sc, bool abort);
+void ath_roc_complete(struct ath_softc *sc, enum ath_roc_complete_reason reason);
 struct ath_chanctx* ath_is_go_chanctx_present(struct ath_softc *sc);
 
 #else
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 2066650..35cfcd0 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -915,18 +915,27 @@ void ath_offchannel_next(struct ath_softc *sc)
 	}
 }
 
-void ath_roc_complete(struct ath_softc *sc, bool abort)
+void ath_roc_complete(struct ath_softc *sc, enum ath_roc_complete_reason reason)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 
-	if (abort)
+	sc->offchannel.roc_vif = NULL;
+	sc->offchannel.roc_chan = NULL;
+
+	switch(reason) {
+	case ATH_ROC_COMPLETE_ABORT:
 		ath_dbg(common, CHAN_CTX, "RoC aborted\n");
-	else
+		ieee80211_remain_on_channel_expired(sc->hw);
+		break;
+	case ATH_ROC_COMPLETE_EXPIRE:
 		ath_dbg(common, CHAN_CTX, "RoC expired\n");
+		ieee80211_remain_on_channel_expired(sc->hw);
+		break;
+	case ATH_ROC_COMPLETE_CANCEL:
+		ath_dbg(common, CHAN_CTX, "RoC canceled\n");
+		break;
+	}
 
-	sc->offchannel.roc_vif = NULL;
-	sc->offchannel.roc_chan = NULL;
-	ieee80211_remain_on_channel_expired(sc->hw);
 	ath_offchannel_next(sc);
 	ath9k_ps_restore(sc);
 }
@@ -1058,7 +1067,7 @@ static void ath_offchannel_timer(unsigned long data)
 	case ATH_OFFCHANNEL_ROC_START:
 	case ATH_OFFCHANNEL_ROC_WAIT:
 		sc->offchannel.state = ATH_OFFCHANNEL_ROC_DONE;
-		ath_roc_complete(sc, false);
+		ath_roc_complete(sc, ATH_ROC_COMPLETE_EXPIRE);
 		break;
 	default:
 		break;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 945f002..2277e09 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2244,7 +2244,7 @@ static void ath9k_cancel_pending_offchannel(struct ath_softc *sc)
 
 		del_timer_sync(&sc->offchannel.timer);
 		if (sc->offchannel.state >= ATH_OFFCHANNEL_ROC_START)
-			ath_roc_complete(sc, true);
+			ath_roc_complete(sc, ATH_ROC_COMPLETE_ABORT);
 	}
 
 	if (test_bit(ATH_OP_SCANNING, &common->op_flags)) {
@@ -2353,7 +2353,7 @@ static int ath9k_cancel_remain_on_channel(struct ieee80211_hw *hw)
 
 	if (sc->offchannel.roc_vif) {
 		if (sc->offchannel.state >= ATH_OFFCHANNEL_ROC_START)
-			ath_roc_complete(sc, true);
+			ath_roc_complete(sc, ATH_ROC_COMPLETE_CANCEL);
 	}
 
 	mutex_unlock(&sc->mutex);
-- 
1.9.1

