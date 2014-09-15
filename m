Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:59192 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaIOFze (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:55:34 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 3/5] ath9k: Set offchannel state properly
Date: Mon, 15 Sep 2014 11:25:52 +0530
Message-Id: <1410760554-11844-4-git-send-email-sujith@msujith.org> (sfid-20140915_075538_228426_F9F9FCC8)
In-Reply-To: <1410760554-11844-1-git-send-email-sujith@msujith.org>
References: <1410760554-11844-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

When switching offchannel, BSS related information
in the HW has to be reset to default values. Add a routine
to do this.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 57 ++++++++++++++++++++++++++---------
 1 file changed, 42 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 1bc2369..aa541fd 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -953,21 +953,6 @@ void ath9k_calculate_iter_data(struct ath_softc *sc,
 
 	list_for_each_entry(avp, &ctx->vifs, list)
 		ath9k_vif_iter(iter_data, avp->vif->addr, avp->vif);
-
-#ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
-	if (ctx == &sc->offchannel.chan) {
-		struct ieee80211_vif *vif;
-
-		if (sc->offchannel.state < ATH_OFFCHANNEL_ROC_START)
-			vif = sc->offchannel.scan_vif;
-		else
-			vif = sc->offchannel.roc_vif;
-
-		if (vif)
-			ath9k_vif_iter(iter_data, vif->addr, vif);
-		iter_data->beacons = false;
-	}
-#endif
 }
 
 static void ath9k_set_assoc_state(struct ath_softc *sc,
@@ -1007,6 +992,43 @@ static void ath9k_set_assoc_state(struct ath_softc *sc,
 		vif->addr, common->curbssid);
 }
 
+#ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
+static void ath9k_set_offchannel_state(struct ath_softc *sc)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ieee80211_vif *vif = NULL;
+
+	ath9k_ps_wakeup(sc);
+
+	if (sc->offchannel.state < ATH_OFFCHANNEL_ROC_START)
+		vif = sc->offchannel.scan_vif;
+	else
+		vif = sc->offchannel.roc_vif;
+
+	if (WARN_ON(!vif))
+		goto exit;
+
+	eth_zero_addr(common->curbssid);
+	eth_broadcast_addr(common->bssidmask);
+	ether_addr_copy(common->macaddr, vif->addr);
+	common->curaid = 0;
+	ah->opmode = vif->type;
+	ah->imask &= ~ATH9K_INT_SWBA;
+	ah->imask &= ~ATH9K_INT_TSFOOR;
+	ah->slottime = ATH9K_SLOT_TIME_9;
+
+	ath_hw_setbssidmask(common);
+	ath9k_hw_setopmode(ah);
+	ath9k_hw_write_associd(sc->sc_ah);
+	ath9k_hw_set_interrupts(ah);
+	ath9k_hw_init_global_settings(ah);
+
+exit:
+	ath9k_ps_restore(sc);
+}
+#endif
+
 /* Called with sc->mutex held. */
 void ath9k_calculate_summary_state(struct ath_softc *sc,
 				   struct ath_chanctx *ctx)
@@ -1021,6 +1043,11 @@ void ath9k_calculate_summary_state(struct ath_softc *sc,
 	if (ctx != sc->cur_chan)
 		return;
 
+#ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
+	if (ctx == &sc->offchannel.chan)
+		return ath9k_set_offchannel_state(sc);
+#endif
+
 	ath9k_ps_wakeup(sc);
 	ath9k_calculate_iter_data(sc, ctx, &iter_data);
 
-- 
2.1.0

