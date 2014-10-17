Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:37531 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbaJQCKq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2014 22:10:46 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 18/23] ath9k: Use a helper function for bmiss
Date: Fri, 17 Oct 2014 07:40:25 +0530
Message-Id: <1413511830-5536-19-git-send-email-sujith@msujith.org> (sfid-20141017_041325_410408_3B5A5077)
In-Reply-To: <1413511830-5536-1-git-send-email-sujith@msujith.org>
References: <1413511830-5536-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 45 ++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 7d6f76b..7fe35a5 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -366,6 +366,31 @@ static void ath_chanctx_setup_timer(struct ath_softc *sc, u32 tsf_time)
 		"Setup chanctx timer with timeout: %d ms\n", jiffies_to_msecs(tsf_time));
 }
 
+static void ath_chanctx_handle_bmiss(struct ath_softc *sc,
+				     struct ath_chanctx *ctx,
+				     struct ath_vif *avp)
+{
+	/*
+	 * Clear the extend_absence flag if it had been
+	 * set during the previous beacon transmission,
+	 * since we need to revert to the normal NoA
+	 * schedule.
+	 */
+	if (ctx->active && sc->sched.extend_absence) {
+		avp->noa_duration = 0;
+		sc->sched.extend_absence = false;
+	}
+
+	/* If at least two consecutive beacons were missed on the STA
+	 * chanctx, stay on the STA channel for one extra beacon period,
+	 * to resync the timer properly.
+	 */
+	if (ctx->active && sc->sched.beacon_miss >= 2) {
+		avp->noa_duration = 0;
+		sc->sched.extend_absence = true;
+	}
+}
+
 static void ath_chanctx_offchannel_noa(struct ath_softc *sc,
 				       struct ath_chanctx *ctx,
 				       struct ath_vif *avp,
@@ -524,25 +549,7 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 			break;
 		}
 
-		/*
-		 * Clear the extend_absence flag if it had been
-		 * set during the previous beacon transmission,
-		 * since we need to revert to the normal NoA
-		 * schedule.
-		 */
-		if (ctx->active && sc->sched.extend_absence) {
-			avp->noa_duration = 0;
-			sc->sched.extend_absence = false;
-		}
-
-		/* If at least two consecutive beacons were missed on the STA
-		 * chanctx, stay on the STA channel for one extra beacon period,
-		 * to resync the timer properly.
-		 */
-		if (ctx->active && sc->sched.beacon_miss >= 2) {
-			avp->noa_duration = 0;
-			sc->sched.extend_absence = true;
-		}
+		ath_chanctx_handle_bmiss(sc, ctx, avp);
 
 		/* Prevent wrap-around issues */
 		if (avp->noa_duration && tsf_time - avp->noa_start > BIT(30))
-- 
2.1.2

