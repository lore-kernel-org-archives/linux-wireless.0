Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:61108 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaFEFt5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 01:49:57 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH v2 10/13] ath9k: Fetch appropriate operating channel context
Date: Thu, 5 Jun 2014 11:20:37 +0530
Message-ID: <1401947437-31302-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140605_075001_985900_A41A26DD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Retrieve appropriate operating channel context while switching
between operating and off channels.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  2 +-
 drivers/net/wireless/ath/ath9k/channel.c |  9 +++++++--
 drivers/net/wireless/ath/ath9k/main.c    | 11 +++++++----
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 3c7ec1c..7634960 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -382,7 +382,7 @@ void ath_offchannel_timer(unsigned long data);
 void ath_offchannel_channel_change(struct ath_softc *sc);
 void ath_chanctx_offchan_switch(struct ath_softc *sc,
 				struct ieee80211_channel *chan);
-u8 ath_chanctx_get_oper_chan(struct ath_softc *sc);
+u8 ath_chanctx_get_oper_chan(struct ath_softc *sc, bool active);
 
 int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan);
 int ath_startrecv(struct ath_softc *sc);
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 099e673..f7842ee 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -275,12 +275,17 @@ void ath_chanctx_switch(struct ath_softc *sc, u8 next_chanctx_idx)
 	ieee80211_queue_work(sc->hw, &sc->chanctx_work);
 }
 
-u8 ath_chanctx_get_oper_chan(struct ath_softc *sc)
+u8 ath_chanctx_get_oper_chan(struct ath_softc *sc, bool active)
 {
+	struct ath_chanctx *ctx;
 	u8 i;
 
 	for (i = 0; i < ARRAY_SIZE(sc->chanctx); i++) {
-		if (!list_empty(&sc->chanctx[i].vifs))
+		ctx = &sc->chanctx[i];
+		if (!ctx->assigned || list_empty(&ctx->vifs))
+			continue;
+
+		if (active && ctx->active)
 			return i;
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 7326eca..2d619b7 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2168,7 +2168,7 @@ ath_scan_next_channel(struct ath_softc *sc)
 
 	if (sc->offchannel.scan_idx >= req->n_channels) {
 		sc->offchannel.state = ATH_OFFCHANNEL_IDLE;
-		ath_chanctx_switch(sc, ath_chanctx_get_oper_chan(sc));
+		ath_chanctx_switch(sc, ath_chanctx_get_oper_chan(sc, false));
 		return;
 	}
 
@@ -2191,7 +2191,7 @@ static void ath_offchannel_next(struct ath_softc *sc)
 		sc->offchannel.state = ATH_OFFCHANNEL_ROC_START;
 		ath_chanctx_offchan_switch(sc, sc->offchannel.roc_chan);
 	} else {
-		ath_chanctx_switch(sc, ath_chanctx_get_oper_chan(sc));
+		ath_chanctx_switch(sc, ath_chanctx_get_oper_chan(sc, false));
 		sc->offchannel.state = ATH_OFFCHANNEL_IDLE;
 		if (sc->ps_idle)
 			ath_cancel_work(sc);
@@ -2212,7 +2212,7 @@ static void ath_scan_complete(struct ath_softc *sc, bool abort)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 
-	ath_chanctx_switch(sc, ath_chanctx_get_oper_chan(sc));
+	ath_chanctx_switch(sc, ath_chanctx_get_oper_chan(sc, false));
 	sc->offchannel.scan_req = NULL;
 	sc->offchannel.scan_vif = NULL;
 	sc->offchannel.state = ATH_OFFCHANNEL_IDLE;
@@ -2325,7 +2325,7 @@ void ath_offchannel_channel_change(struct ath_softc *sc)
 void ath_offchannel_timer(unsigned long data)
 {
 	struct ath_softc *sc = (struct ath_softc *)data;
-	u8 idx = ath_chanctx_get_oper_chan(sc);
+	u8 idx = ath_chanctx_get_oper_chan(sc, false);
 	struct ath_chanctx *ctx = &sc->chanctx[idx];
 
 	if (!sc->offchannel.scan_req)
@@ -2336,6 +2336,9 @@ void ath_offchannel_timer(unsigned long data)
 		if (!sc->offchannel.scan_req)
 			return;
 
+		/* get first active channel context */
+		idx = ath_chanctx_get_oper_chan(sc, true);
+		ctx = &sc->chanctx[idx];
 		if (ctx->active) {
 			sc->offchannel.state = ATH_OFFCHANNEL_SUSPEND;
 			ath_chanctx_switch(sc, idx);
-- 
2.0.0

