Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:49626 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbaBQNXU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 08:23:20 -0500
Received: by mail-ea0-f174.google.com with SMTP id z10so3808103ead.5
        for <linux-wireless@vger.kernel.org>; Mon, 17 Feb 2014 05:23:19 -0800 (PST)
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
	jan-niklas.meier@volkswagen.de, Rostislav Lisovy <lisovy@gmail.com>
Subject: [RFC 4/4] ath9k: Add OCB (IEEE 802.11p) mode
Date: Mon, 17 Feb 2014 14:22:54 +0100
Message-Id: <1392643374-3545-5-git-send-email-lisovy@gmail.com> (sfid-20140217_142325_142828_BE584026)
In-Reply-To: <1392643374-3545-1-git-send-email-lisovy@gmail.com>
References: <1392643374-3545-1-git-send-email-lisovy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rostislav Lisovy <lisovy@gmail.com>
---
 drivers/net/wireless/ath/ath9k/ani.c          | 1 +
 drivers/net/wireless/ath/ath9k/ath9k.h        | 1 +
 drivers/net/wireless/ath/ath9k/debug.c        | 4 ++--
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 3 ++-
 drivers/net/wireless/ath/ath9k/hw.c           | 1 +
 drivers/net/wireless/ath/ath9k/init.c         | 3 ++-
 drivers/net/wireless/ath/ath9k/main.c         | 5 ++++-
 drivers/net/wireless/ath/ath9k/recv.c         | 2 +-
 drivers/net/wireless/ath/regd.c               | 2 +-
 9 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index d28923b..72820fd 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -326,6 +326,7 @@ void ath9k_ani_reset(struct ath_hw *ah, bool is_scanning)
 
 	if (is_scanning ||
 	    (ah->opmode != NL80211_IFTYPE_STATION &&
+	     ah->opmode != NL80211_IFTYPE_OCB &&
 	     ah->opmode != NL80211_IFTYPE_ADHOC)) {
 		/*
 		 * If we're scanning or in AP mode, the defaults (ini)
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 60a5da5..1528661 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -685,6 +685,7 @@ struct ath9k_vif_iter_data {
 	int nstations; /* number of station vifs */
 	int nwds;      /* number of WDS vifs */
 	int nadhocs;   /* number of adhoc vifs */
+	int nocbs;     /* number of OCB vifs */
 };
 
 /* enum spectral_mode:
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 83a2c59..9ef53fe 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -788,9 +788,9 @@ static ssize_t read_file_misc(struct file *file, char __user *user_buf,
 
 	len += scnprintf(buf + len, sizeof(buf) - len,
 			 "VIF-COUNTS: AP: %i STA: %i MESH: %i WDS: %i"
-			 " ADHOC: %i TOTAL: %hi BEACON-VIF: %hi\n",
+			 " ADHOC: %i OCB: %i TOTAL: %hi BEACON-VIF: %hi\n",
 			 iter_data.naps, iter_data.nstations, iter_data.nmeshes,
-			 iter_data.nwds, iter_data.nadhocs,
+			 iter_data.nwds, iter_data.nadhocs, iter_data.nocbs,
 			 sc->nvifs, sc->nbcnvifs);
 
 	if (len > sizeof(buf))
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index c3676bf..6822b60 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -737,7 +737,8 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 		BIT(NL80211_IFTYPE_AP) |
 		BIT(NL80211_IFTYPE_P2P_GO) |
 		BIT(NL80211_IFTYPE_P2P_CLIENT) |
-		BIT(NL80211_IFTYPE_MESH_POINT);
+		BIT(NL80211_IFTYPE_MESH_POINT) |
+		BIT(NL80211_IFTYPE_OCB);
 
 	hw->wiphy->iface_combinations = &if_comb;
 	hw->wiphy->n_iface_combinations = 1;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8918035..3ee2787 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1245,6 +1245,7 @@ static void ath9k_hw_set_operating_mode(struct ath_hw *ah, int opmode)
 	u32 set = AR_STA_ID1_KSRCH_MODE;
 
 	switch (opmode) {
+	case NL80211_IFTYPE_OCB:
 	case NL80211_IFTYPE_ADHOC:
 		set |= AR_STA_ID1_ADHOC;
 		REG_SET_BIT(ah, AR_CFG, AR_CFG_AP_ADHOC_INDICATION);
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 7bad46f..b9f7529 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -938,7 +938,8 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 			BIT(NL80211_IFTYPE_WDS) |
 			BIT(NL80211_IFTYPE_STATION) |
 			BIT(NL80211_IFTYPE_ADHOC) |
-			BIT(NL80211_IFTYPE_MESH_POINT);
+			BIT(NL80211_IFTYPE_MESH_POINT) |
+			BIT(NL80211_IFTYPE_OCB);
 		hw->wiphy->iface_combinations = if_comb;
 		hw->wiphy->n_iface_combinations = ARRAY_SIZE(if_comb);
 	}
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 21aa09e..072764f 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -929,6 +929,7 @@ static void ath9k_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 	case NL80211_IFTYPE_STATION:
 		iter_data->nstations++;
 		break;
+	case NL80211_IFTYPE_OCB:
 	case NL80211_IFTYPE_ADHOC:
 		iter_data->nadhocs++;
 		break;
@@ -1006,6 +1007,8 @@ static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
 
 		if (iter_data.nmeshes)
 			ah->opmode = NL80211_IFTYPE_MESH_POINT;
+		else if (iter_data.nocbs)
+			ah->opmode = NL80211_IFTYPE_OCB;
 		else if (iter_data.nwds)
 			ah->opmode = NL80211_IFTYPE_AP;
 		else if (iter_data.nadhocs)
@@ -1016,7 +1019,7 @@ static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
 
 	ath9k_hw_setopmode(ah);
 
-	if ((iter_data.nstations + iter_data.nadhocs + iter_data.nmeshes) > 0)
+	if ((iter_data.nstations + iter_data.nadhocs + iter_data.nmeshes + iter_data.nocbs) > 0)
 		ah->imask |= ATH9K_INT_TSFOOR;
 	else
 		ah->imask &= ~ATH9K_INT_TSFOOR;
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index ea8d15d..c6c716e 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -403,7 +403,7 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 	    (sc->nvifs <= 1) &&
 	    !(sc->rx.rxfilter & FIF_BCN_PRBRESP_PROMISC))
 		rfilt |= ATH9K_RX_FILTER_MYBEACON;
-	else
+	else if (sc->sc_ah->opmode != NL80211_IFTYPE_OCB)
 		rfilt |= ATH9K_RX_FILTER_BEACON;
 
 	if ((sc->sc_ah->opmode == NL80211_IFTYPE_AP) ||
diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 9a7b934..ae82221 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -612,7 +612,7 @@ ath_regd_init_wiphy(struct ath_regulatory *reg,
 	const struct ieee80211_regdomain *regd;
 
 	wiphy->reg_notifier = reg_notifier;
-	wiphy->flags |= WIPHY_FLAG_STRICT_REGULATORY;
+	/* wiphy->flags |= WIPHY_FLAG_STRICT_REGULATORY; */
 
 	if (ath_is_world_regd(reg)) {
 		/*
-- 
1.8.5.1

