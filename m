Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:39903 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189AbaKPAjz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Nov 2014 19:39:55 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 10/11] ath9k: Adjust tbtt delta properly
Date: Sun, 16 Nov 2014 06:11:09 +0530
Message-Id: <1416098470-14122-11-git-send-email-sujith@msujith.org> (sfid-20141116_013959_705859_9DAB71EF)
In-Reply-To: <1416098470-14122-1-git-send-email-sujith@msujith.org>
References: <1416098470-14122-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

In a GO/STA setup, when we switch to the STA context,
the channel context timer is scheduled with a period of
half the beacon interval. If a beacon is received in
this duration, the timer is adjusted to accommodate
TSF sync done by the HW.

But, if the actual channel switch is delayed for some
reason, we end up rearming the timer every time a new
beacon is received. Avoid this by doing the adjustment
only once.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   | 1 +
 drivers/net/wireless/ath/ath9k/channel.c | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 0f6db12..abe8bd6 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -381,6 +381,7 @@ enum ath_chanctx_state {
 
 struct ath_chanctx_sched {
 	bool beacon_pending;
+	bool beacon_adjust;
 	bool offchannel_pending;
 	bool wait_switch;
 	bool force_noa_update;
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index ee76682..99425fe 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -659,6 +659,7 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		sc->sched.beacon_miss = 0;
 
 		if (sc->sched.state == ATH_CHANCTX_STATE_FORCE_ACTIVE ||
+		    !sc->sched.beacon_adjust ||
 		    !sc->cur_chan->tsf_val)
 			break;
 
@@ -672,7 +673,7 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 			ath9k_hw_get_tsf_offset(&sc->cur_chan->tsf_ts, NULL);
 		tsf_time += ath9k_hw_gettsf32(ah);
 
-
+		sc->sched.beacon_adjust = false;
 		ath_chanctx_setup_timer(sc, tsf_time);
 		break;
 	case ATH_CHANCTX_EVENT_AUTHORIZED:
@@ -717,6 +718,7 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 
 		ath_chanctx_setup_timer(sc, tsf_time);
 		sc->sched.beacon_pending = true;
+		sc->sched.beacon_adjust = true;
 		break;
 	case ATH_CHANCTX_EVENT_ENABLE_MULTICHANNEL:
 		if (sc->cur_chan == &sc->offchannel.chan ||
-- 
2.1.3

