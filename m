Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:45015 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaJNEAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2014 00:00:08 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 7/9] ath9k: Send oneshot NoA
Date: Tue, 14 Oct 2014 09:30:54 +0530
Message-Id: <1413259256-4808-8-git-send-email-sujith@msujith.org> (sfid-20141014_060037_633258_43029E3D)
In-Reply-To: <1413259256-4808-1-git-send-email-sujith@msujith.org>
References: <1413259256-4808-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This patch makes sure that a GO interface
sends out a new NoA schedule with 200ms duration
when mgd_prepare_tx() is called.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  1 +
 drivers/net/wireless/ath/ath9k/channel.c | 41 ++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index b7abb4f..7ac1b06 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -620,6 +620,7 @@ struct ath_vif {
 	u32 noa_start;
 	u32 noa_duration;
 	bool periodic_noa;
+	bool oneshot_noa;
 };
 
 struct ath9k_vif_iter_data {
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 447b397..366a4d9 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -450,6 +450,27 @@ static void ath_chanctx_set_periodic_noa(struct ath_softc *sc,
 		avp->periodic_noa);
 }
 
+static void ath_chanctx_set_oneshot_noa(struct ath_softc *sc,
+					struct ath_vif *avp,
+					u32 tsf_time,
+					u32 duration)
+{
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+
+	avp->noa_index++;
+	avp->noa_start = tsf_time;
+	avp->periodic_noa = false;
+	avp->oneshot_noa = true;
+	avp->noa_duration = duration + sc->sched.channel_switch_time;
+
+	ath_dbg(common, CHAN_CTX,
+		"oneshot noa_duration: %d, noa_start: %d, noa_index: %d, periodic: %d\n",
+		avp->noa_duration,
+		avp->noa_start,
+		avp->noa_index,
+		avp->periodic_noa);
+}
+
 void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		       enum ath_chanctx_event ev)
 {
@@ -476,6 +497,14 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		if (avp->offchannel_duration)
 			avp->offchannel_duration = 0;
 
+		if (avp->oneshot_noa) {
+			avp->noa_duration = 0;
+			avp->oneshot_noa = false;
+
+			ath_dbg(common, CHAN_CTX,
+				"Clearing oneshot NoA\n");
+		}
+
 		if (avp->chanctx != sc->cur_chan) {
 			ath_dbg(common, CHAN_CTX,
 				"Contexts differ, not preparing beacon\n");
@@ -551,6 +580,18 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 
 		ath_chanctx_handle_bmiss(sc, ctx, avp);
 
+		/*
+		 * If a mgd_prepare_tx() has been called by mac80211,
+		 * a one-shot NoA needs to be sent. This can happen
+		 * with one or more active channel contexts - in both
+		 * cases, a new NoA schedule has to be advertised.
+		 */
+		if (sc->sched.mgd_prepare_tx) {
+			ath_chanctx_set_oneshot_noa(sc, avp, tsf_time,
+						    jiffies_to_usecs(HZ / 5));
+			break;
+		}
+
 		/* Prevent wrap-around issues */
 		if (avp->noa_duration && tsf_time - avp->noa_start > BIT(30))
 			avp->noa_duration = 0;
-- 
2.1.2

