Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from max.feld.cvut.cz ([147.32.192.36]:45203 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbbIINBR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2015 09:01:17 -0400
From: Jan Kaisrlik <kaisrja1@fel.cvut.cz>
To: kaisrja1@fel.cvut.cz
Cc: sojkam1@fel.cvut.cz, linux-wireless@vger.kernel.org,
	bernd.lehmann@volkswagen.de, jan-niklas.meier@volkswagen.de,
	s.sander@nordsys.de
Subject: [PATCH] ath9k: Add support for OCB mode
Date: Wed,  9 Sep 2015 14:55:24 +0200
Message-Id: <1441803324-4503-1-git-send-email-kaisrja1@fel.cvut.cz> (sfid-20150909_150122_786493_47B3A551)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch adds support for "outside the context of a BSS"(OCB) mode
to ath9k driver and extends debugfs files by OCB ralated information.

This patch was tested on AR9380-AL1A cards.

Signed-off-by: Jan Kaisrlik <kaisrja1@fel.cvut.cz>
Cc: Michal Sojka <sojkam1@fel.cvut.cz>
---
 drivers/net/wireless/ath/ath9k/ani.c          |  1 +
 drivers/net/wireless/ath/ath9k/ath9k.h        |  1 +
 drivers/net/wireless/ath/ath9k/debug.c        |  4 ++--
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |  3 ++-
 drivers/net/wireless/ath/ath9k/hw.c           |  1 +
 drivers/net/wireless/ath/ath9k/init.c         |  3 ++-
 drivers/net/wireless/ath/ath9k/main.c         | 11 +++++++++--
 drivers/net/wireless/ath/ath9k/recv.c         |  2 +-
 drivers/net/wireless/ath/debug.c              |  2 ++
 9 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 25e45e4..0ec2c0b 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -342,6 +342,7 @@ void ath9k_ani_reset(struct ath_hw *ah, bool is_scanning)
 
 	if (is_scanning ||
 	    (ah->opmode != NL80211_IFTYPE_STATION &&
+	     ah->opmode != NL80211_IFTYPE_OCB &&
 	     ah->opmode != NL80211_IFTYPE_ADHOC)) {
 		/*
 		 * If we're scanning or in AP mode, the defaults (ini)
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index c85c479..b42f4a9 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -635,6 +635,7 @@ struct ath9k_vif_iter_data {
 	int nstations; /* number of station vifs */
 	int nwds;      /* number of WDS vifs */
 	int nadhocs;   /* number of adhoc vifs */
+	int nocbs;     /* number of OCB vifs */
 	struct ieee80211_vif *primary_sta;
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index da32c8f..6de64cf 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -741,8 +741,8 @@ static int read_file_misc(struct seq_file *file, void *data)
 			   i++, (int)(ctx->assigned), iter_data.naps,
 			   iter_data.nstations,
 			   iter_data.nmeshes, iter_data.nwds);
-		seq_printf(file, " ADHOC: %i TOTAL: %hi BEACON-VIF: %hi\n",
-			   iter_data.nadhocs, sc->cur_chan->nvifs,
+		seq_printf(file, " ADHOC: %i OCB: %i TOTAL: %hi BEACON-VIF: %hi\n",
+			   iter_data.nadhocs, iter_data.nocbs, sc->cur_chan->nvifs,
 			   sc->nbcnvifs);
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 1e84882..5e53040 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -736,7 +736,8 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 		BIT(NL80211_IFTYPE_AP) |
 		BIT(NL80211_IFTYPE_P2P_GO) |
 		BIT(NL80211_IFTYPE_P2P_CLIENT) |
-		BIT(NL80211_IFTYPE_MESH_POINT);
+		BIT(NL80211_IFTYPE_MESH_POINT) |
+		BIT(NL80211_IFTYPE_OCB);
 
 	hw->wiphy->iface_combinations = &if_comb;
 	hw->wiphy->n_iface_combinations = 1;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 1dd0339..2144362 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1234,6 +1234,7 @@ static void ath9k_hw_set_operating_mode(struct ath_hw *ah, int opmode)
 
 	ENABLE_REG_RMW_BUFFER(ah);
 	switch (opmode) {
+	case NL80211_IFTYPE_OCB:
 	case NL80211_IFTYPE_ADHOC:
 		if (!AR_SREV_9340_13(ah)) {
 			set |= AR_STA_ID1_ADHOC;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 57f95f2..5d532c7 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -855,7 +855,8 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 			BIT(NL80211_IFTYPE_STATION) |
 			BIT(NL80211_IFTYPE_ADHOC) |
 			BIT(NL80211_IFTYPE_MESH_POINT) |
-			BIT(NL80211_IFTYPE_WDS);
+			BIT(NL80211_IFTYPE_WDS) |
+			BIT(NL80211_IFTYPE_OCB);
 
 		if (ath9k_is_chanctx_enabled())
 			hw->wiphy->interface_modes |=
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c27143b..f121ec0 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -938,6 +938,9 @@ static void ath9k_vif_iter(struct ath9k_vif_iter_data *iter_data,
 		if (avp->assoc && !iter_data->primary_sta)
 			iter_data->primary_sta = vif;
 		break;
+	case NL80211_IFTYPE_OCB:
+		iter_data->nocbs++;
+		break;
 	case NL80211_IFTYPE_ADHOC:
 		iter_data->nadhocs++;
 		if (vif->bss_conf.enable_beacon)
@@ -1111,6 +1114,8 @@ void ath9k_calculate_summary_state(struct ath_softc *sc,
 
 		if (iter_data.nmeshes)
 			ah->opmode = NL80211_IFTYPE_MESH_POINT;
+		else if (iter_data.nocbs)
+			ah->opmode = NL80211_IFTYPE_OCB;
 		else if (iter_data.nwds)
 			ah->opmode = NL80211_IFTYPE_AP;
 		else if (iter_data.nadhocs)
@@ -1122,7 +1127,8 @@ void ath9k_calculate_summary_state(struct ath_softc *sc,
 	ath9k_hw_setopmode(ah);
 
 	ctx->switch_after_beacon = false;
-	if ((iter_data.nstations + iter_data.nadhocs + iter_data.nmeshes) > 0)
+	if ((iter_data.nstations + iter_data.nadhocs +
+	     iter_data.nmeshes + iter_data.nocbs) > 0)
 		ah->imask |= ATH9K_INT_TSFOOR;
 	else {
 		ah->imask &= ~ATH9K_INT_TSFOOR;
@@ -1760,7 +1766,8 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 		ath9k_calculate_summary_state(sc, avp->chanctx);
 	}
 
-	if (changed & BSS_CHANGED_IBSS) {
+	if ((changed & BSS_CHANGED_IBSS) ||
+	      (changed & BSS_CHANGED_OCB)) {
 		memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
 		common->curaid = bss_conf->aid;
 		ath9k_hw_write_associd(sc->sc_ah);
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index d3189da..994daf6 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -403,7 +403,7 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 	    (sc->cur_chan->nvifs <= 1) &&
 	    !(sc->cur_chan->rxfilter & FIF_BCN_PRBRESP_PROMISC))
 		rfilt |= ATH9K_RX_FILTER_MYBEACON;
-	else
+	else if (sc->sc_ah->opmode != NL80211_IFTYPE_OCB)
 		rfilt |= ATH9K_RX_FILTER_BEACON;
 
 	if ((sc->sc_ah->opmode == NL80211_IFTYPE_AP) ||
diff --git a/drivers/net/wireless/ath/debug.c b/drivers/net/wireless/ath/debug.c
index d59d83e..ae3a80c 100644
--- a/drivers/net/wireless/ath/debug.c
+++ b/drivers/net/wireless/ath/debug.c
@@ -22,6 +22,8 @@ const char *ath_opmode_to_string(enum nl80211_iftype opmode)
 	switch (opmode) {
 	case NL80211_IFTYPE_UNSPECIFIED:
 		return "UNSPEC";
+	case NL80211_IFTYPE_OCB:
+		return "OCB";
 	case NL80211_IFTYPE_ADHOC:
 		return "ADHOC";
 	case NL80211_IFTYPE_STATION:
-- 
2.1.4

