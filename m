Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:40605 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590AbaJNEAC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2014 00:00:02 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 3/9] ath9k: Use a helper function for offchannel NoA
Date: Tue, 14 Oct 2014 09:30:50 +0530
Message-Id: <1413259256-4808-4-git-send-email-sujith@msujith.org> (sfid-20141014_060043_495758_7F12014D)
In-Reply-To: <1413259256-4808-1-git-send-email-sujith@msujith.org>
References: <1413259256-4808-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 45 +++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 45d2c48..c6e130d 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -366,6 +366,32 @@ static void ath_chanctx_setup_timer(struct ath_softc *sc, u32 tsf_time)
 		"Setup chanctx timer with timeout: %d ms\n", jiffies_to_msecs(tsf_time));
 }
 
+static void ath_chanctx_offchannel_noa(struct ath_softc *sc,
+				       struct ath_chanctx *ctx,
+				       struct ath_vif *avp,
+				       u32 tsf_time)
+{
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+
+	avp->noa_index++;
+	avp->offchannel_start = tsf_time;
+	avp->offchannel_duration = sc->sched.offchannel_duration;
+
+	ath_dbg(common, CHAN_CTX,
+		"offchannel noa_duration: %d, noa_start: %d, noa_index: %d\n",
+		avp->offchannel_duration,
+		avp->offchannel_start,
+		avp->noa_index);
+
+	/*
+	 * When multiple contexts are active, the NoA
+	 * has to be recalculated and advertised after
+	 * an offchannel operation.
+	 */
+	if (ctx->active && avp->noa_duration)
+		avp->noa_duration = 0;
+}
+
 void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		       enum ath_chanctx_event ev)
 {
@@ -461,24 +487,7 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		 * values and increment the index.
 		 */
 		if (sc->next_chan == &sc->offchannel.chan) {
-			avp->noa_index++;
-			avp->offchannel_start = tsf_time;
-			avp->offchannel_duration = sc->sched.offchannel_duration;
-
-			ath_dbg(common, CHAN_CTX,
-				"offchannel noa_duration: %d, noa_start: %d, noa_index: %d\n",
-				avp->offchannel_duration,
-				avp->offchannel_start,
-				avp->noa_index);
-
-			/*
-			 * When multiple contexts are active, the NoA
-			 * has to be recalculated and advertised after
-			 * an offchannel operation.
-			 */
-			if (ctx->active && avp->noa_duration)
-				avp->noa_duration = 0;
-
+			ath_chanctx_offchannel_noa(sc, ctx, avp, tsf_time);
 			break;
 		}
 
-- 
2.1.2

