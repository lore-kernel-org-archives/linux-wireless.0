Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from max.feld.cvut.cz ([147.32.192.36]:54687 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652AbbIQMEB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2015 08:04:01 -0400
From: Jan Kaisrlik <kaisrja1@fel.cvut.cz>
To: kaisrja1@fel.cvut.cz
Cc: linux-wireless@vger.kernel.org, bernd.lehmann@volkswagen.de,
	jan-niklas.meier@volkswagen.de, s.sander@nordsys.de,
	nbd@openwrt.org, Michal Sojka <sojkam1@fel.cvut.cz>
Subject: [PATCH v2] ath9k: Add support for OCB mode
Date: Thu, 17 Sep 2015 14:03:46 +0200
Message-Id: <1442491426-15233-1-git-send-email-kaisrja1@fel.cvut.cz> (sfid-20150917_140406_450057_04A1163D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch adds support for "outside the context of a BSS"(OCB) mode
to ath9k driver and extends debugfs files by OCB ralated information.

This patch was tested on AR9380-AL1A cards.

Signed-off-by: Jan Kaisrlik <kaisrja1@fel.cvut.cz>
Cc: Michal Sojka <sojkam1@fel.cvut.cz>
---
changes:
* OCB mode is treated like AP mode rather than like ad hoc mode.

Btw. I couldn't find any reasonable documentation about AR_STA_ID1_ADHOC
AR_STA_ID1_STA_AP bits. In my tests, OCB communication works in both
modes, but I'd like to understand the difference. Can somebody point me
to some information about these bits?

 drivers/net/wireless/ath/ath9k/ath9k.h        | 1 +
 drivers/net/wireless/ath/ath9k/debug.c        | 4 ++--
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 3 ++-
 drivers/net/wireless/ath/ath9k/hw.c           | 1 +
 drivers/net/wireless/ath/ath9k/init.c         | 3 ++-
 drivers/net/wireless/ath/ath9k/main.c         | 8 +++++++-
 drivers/net/wireless/ath/ath9k/recv.c         | 2 +-
 7 files changed, 16 insertions(+), 6 deletions(-)

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
index 1dd0339..bdfff46 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1241,6 +1241,7 @@ static void ath9k_hw_set_operating_mode(struct ath_hw *ah, int opmode)
 			break;
 		}
 		/* fall through */
+	case NL80211_IFTYPE_OCB:
 	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_AP:
 		set |= AR_STA_ID1_STA_AP;
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
index c27143b..56abb9d 100644
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
@@ -1760,7 +1765,8 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
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
-- 
2.1.4

