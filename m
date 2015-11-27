Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:36105 "EHLO
	mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbbK0Ihj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2015 03:37:39 -0500
Received: by lfs39 with SMTP id 39so118587584lfs.3
        for <linux-wireless@vger.kernel.org>; Fri, 27 Nov 2015 00:37:38 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, nbd@openwrt.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 12/13] ath9k: MCC, print time elapsed between events
Date: Fri, 27 Nov 2015 09:37:17 +0100
Message-Id: <1448613438-5173-12-git-send-email-janusz.dziedzic@tieto.com> (sfid-20151127_095251_759658_A7B00402)
In-Reply-To: <1448613438-5173-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1448613438-5173-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is useful for MCC debugging and bug fixing.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  1 +
 drivers/net/wireless/ath/ath9k/channel.c | 19 +++++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 4616229..952a467 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -983,6 +983,7 @@ struct ath_softc {
 	struct ath_offchannel offchannel;
 	struct ath_chanctx *next_chan;
 	struct completion go_beacon;
+	struct timespec last_event_time;
 #endif
 
 	unsigned long driver_data;
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 8ab856c..65ad7be 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -226,6 +226,20 @@ static const char *chanctx_state_string(enum ath_chanctx_state state)
 	}
 }
 
+static const u32 chanctx_event_delta(struct ath_softc *sc)
+{
+	u64 ms;
+	struct timespec ts, *old;
+
+	getrawmonotonic(&ts);
+	old = &sc->last_event_time;
+	ms = ts.tv_sec * 1000 + ts.tv_nsec / 1000000;
+	ms -= old->tv_sec * 1000 + old->tv_nsec / 1000000;
+	sc->last_event_time = ts;
+
+	return (u32)ms;
+}
+
 void ath_chanctx_check_active(struct ath_softc *sc, struct ath_chanctx *ctx)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
@@ -507,10 +521,11 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 
 	spin_lock_bh(&sc->chan_lock);
 
-	ath_dbg(common, CHAN_CTX, "cur_chan: %d MHz, event: %s, state: %s\n",
+	ath_dbg(common, CHAN_CTX, "cur_chan: %d MHz, event: %s, state: %s, delta: %u ms\n",
 		sc->cur_chan->chandef.center_freq1,
 		chanctx_event_string(ev),
-		chanctx_state_string(sc->sched.state));
+		chanctx_state_string(sc->sched.state),
+		chanctx_event_delta(sc));
 
 	switch (ev) {
 	case ATH_CHANCTX_EVENT_BEACON_PREPARE:
-- 
1.9.1

