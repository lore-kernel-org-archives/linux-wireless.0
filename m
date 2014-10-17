Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:58784 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbaJQCKm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2014 22:10:42 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 17/23] ath9k: Use a helper function to set NoA
Date: Fri, 17 Oct 2014 07:40:24 +0530
Message-Id: <1413511830-5536-18-git-send-email-sujith@msujith.org> (sfid-20141017_041321_675648_7184922D)
In-Reply-To: <1413511830-5536-1-git-send-email-sujith@msujith.org>
References: <1413511830-5536-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 61 +++++++++++++++++++-------------
 1 file changed, 36 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index c6e130d..7d6f76b 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -392,6 +392,39 @@ static void ath_chanctx_offchannel_noa(struct ath_softc *sc,
 		avp->noa_duration = 0;
 }
 
+static void ath_chanctx_set_periodic_noa(struct ath_softc *sc,
+					 struct ath_vif *avp,
+					 struct ath_beacon_config *cur_conf,
+					 u32 tsf_time,
+					 u32 beacon_int)
+{
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+
+	avp->noa_index++;
+	avp->noa_start = tsf_time;
+
+	if (sc->sched.extend_absence)
+		avp->noa_duration = (3 * beacon_int / 2) +
+			sc->sched.channel_switch_time;
+	else
+		avp->noa_duration =
+			TU_TO_USEC(cur_conf->beacon_interval) / 2 +
+			sc->sched.channel_switch_time;
+
+	if (test_bit(ATH_OP_SCANNING, &common->op_flags) ||
+	    sc->sched.extend_absence)
+		avp->periodic_noa = false;
+	else
+		avp->periodic_noa = true;
+
+	ath_dbg(common, CHAN_CTX,
+		"noa_duration: %d, noa_start: %d, noa_index: %d, periodic: %d\n",
+		avp->noa_duration,
+		avp->noa_start,
+		avp->noa_index,
+		avp->periodic_noa);
+}
+
 void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		       enum ath_chanctx_event ev)
 {
@@ -521,31 +554,9 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		 * announcement.
 		 */
 		if (ctx->active &&
-		    (!avp->noa_duration || sc->sched.force_noa_update)) {
-			avp->noa_index++;
-			avp->noa_start = tsf_time;
-
-			if (sc->sched.extend_absence)
-				avp->noa_duration = (3 * beacon_int / 2) +
-					sc->sched.channel_switch_time;
-			else
-				avp->noa_duration =
-					TU_TO_USEC(cur_conf->beacon_interval) / 2 +
-					sc->sched.channel_switch_time;
-
-			if (test_bit(ATH_OP_SCANNING, &common->op_flags) ||
-			    sc->sched.extend_absence)
-				avp->periodic_noa = false;
-			else
-				avp->periodic_noa = true;
-
-			ath_dbg(common, CHAN_CTX,
-				"noa_duration: %d, noa_start: %d, noa_index: %d, periodic: %d\n",
-				avp->noa_duration,
-				avp->noa_start,
-				avp->noa_index,
-				avp->periodic_noa);
-		}
+		    (!avp->noa_duration || sc->sched.force_noa_update))
+			ath_chanctx_set_periodic_noa(sc, avp, cur_conf,
+						     tsf_time, beacon_int);
 
 		if (ctx->active && sc->sched.force_noa_update)
 			sc->sched.force_noa_update = false;
-- 
2.1.2

