Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38476 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503AbZIJTaY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 15:30:24 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 01/10] ath9k: make ath9k_hw_setbssidmask() and ath9k_hw_write_associd() use ath_hw
Date: Thu, 10 Sep 2009 15:30:18 -0400
Message-Id: <1252611027-5285-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252611027-5285-1-git-send-email-lrodriguez@atheros.com>
References: <1252611027-5285-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c      |   14 +++++++-------
 drivers/net/wireless/ath/ath9k/hw.h      |    4 ++--
 drivers/net/wireless/ath/ath9k/main.c    |   11 ++++++-----
 drivers/net/wireless/ath/ath9k/recv.c    |    2 +-
 drivers/net/wireless/ath/ath9k/virtual.c |    2 +-
 5 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index eeaf77a..f7aaaa1 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -3984,17 +3984,17 @@ void ath9k_hw_setmcastfilter(struct ath_hw *ah, u32 filter0, u32 filter1)
 	REG_WRITE(ah, AR_MCAST_FIL1, filter1);
 }
 
-void ath9k_hw_setbssidmask(struct ath_softc *sc)
+void ath9k_hw_setbssidmask(struct ath_hw *ah)
 {
-	REG_WRITE(sc->sc_ah, AR_BSSMSKL, get_unaligned_le32(sc->bssidmask));
-	REG_WRITE(sc->sc_ah, AR_BSSMSKU, get_unaligned_le16(sc->bssidmask + 4));
+	REG_WRITE(ah, AR_BSSMSKL, get_unaligned_le32(ah->ah_sc->bssidmask));
+	REG_WRITE(ah, AR_BSSMSKU, get_unaligned_le16(ah->ah_sc->bssidmask + 4));
 }
 
-void ath9k_hw_write_associd(struct ath_softc *sc)
+void ath9k_hw_write_associd(struct ath_hw *ah)
 {
-	REG_WRITE(sc->sc_ah, AR_BSS_ID0, get_unaligned_le32(sc->curbssid));
-	REG_WRITE(sc->sc_ah, AR_BSS_ID1, get_unaligned_le16(sc->curbssid + 4) |
-		  ((sc->curaid & 0x3fff) << AR_BSS_ID1_AID_S));
+	REG_WRITE(ah, AR_BSS_ID0, get_unaligned_le32(ah->ah_sc->curbssid));
+	REG_WRITE(ah, AR_BSS_ID1, get_unaligned_le16(ah->ah_sc->curbssid + 4) |
+		  ((ah->ah_sc->curaid & 0x3fff) << AR_BSS_ID1_AID_S));
 }
 
 u64 ath9k_hw_gettsf64(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 421d2ba..d7b2a35 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -641,8 +641,8 @@ void ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit);
 void ath9k_hw_setmac(struct ath_hw *ah, const u8 *mac);
 void ath9k_hw_setopmode(struct ath_hw *ah);
 void ath9k_hw_setmcastfilter(struct ath_hw *ah, u32 filter0, u32 filter1);
-void ath9k_hw_setbssidmask(struct ath_softc *sc);
-void ath9k_hw_write_associd(struct ath_softc *sc);
+void ath9k_hw_setbssidmask(struct ath_hw *ah);
+void ath9k_hw_write_associd(struct ath_hw *ah);
 u64 ath9k_hw_gettsf64(struct ath_hw *ah);
 void ath9k_hw_settsf64(struct ath_hw *ah, u64 tsf64);
 void ath9k_hw_reset_tsf(struct ath_hw *ah);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 94ef651..0eeb514 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -975,14 +975,15 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 				 struct ieee80211_vif *vif,
 				 struct ieee80211_bss_conf *bss_conf)
 {
+	struct ath_hw *ah = sc->sc_ah;
 
 	if (bss_conf->assoc) {
-		DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "Bss Info ASSOC %d, bssid: %pM\n",
+		DPRINTF(ah, ATH_DBG_CONFIG, "Bss Info ASSOC %d, bssid: %pM\n",
 			bss_conf->aid, sc->curbssid);
 
 		/* New association, store aid */
 		sc->curaid = bss_conf->aid;
-		ath9k_hw_write_associd(sc);
+		ath9k_hw_write_associd(ah);
 
 		/*
 		 * Request a re-configuration of Beacon related timers
@@ -999,7 +1000,7 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 
 		ath_start_ani(sc);
 	} else {
-		DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "Bss Info DISASSOC\n");
+		DPRINTF(ah, ATH_DBG_CONFIG, "Bss Info DISASSOC\n");
 		sc->curaid = 0;
 		/* Stop ANI */
 		del_timer_sync(&sc->ani.timer);
@@ -2807,7 +2808,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 		ath9k_hw_setopmode(ah);
 		memcpy(sc->curbssid, sc->sc_ah->macaddr, ETH_ALEN);
 		sc->curaid = 0;
-		ath9k_hw_write_associd(sc);
+		ath9k_hw_write_associd(ah);
 		/* Request full reset to get hw opmode changed properly */
 		sc->sc_flags |= SC_OP_FULL_RESET;
 	}
@@ -2822,7 +2823,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 			memcpy(sc->curbssid, bss_conf->bssid, ETH_ALEN);
 			memcpy(avp->bssid, bss_conf->bssid, ETH_ALEN);
 			sc->curaid = 0;
-			ath9k_hw_write_associd(sc);
+			ath9k_hw_write_associd(ah);
 
 			/* Set aggregation protection mode parameters */
 			sc->config.ath_aggr_prot = 0;
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index ee1e8b4..529cab6 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -280,7 +280,7 @@ static void ath_opmode_init(struct ath_softc *sc)
 
 	/* configure bssid mask */
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK)
-		ath9k_hw_setbssidmask(sc);
+		ath9k_hw_setbssidmask(ah);
 
 	/* configure operational mode */
 	ath9k_hw_setopmode(ah);
diff --git a/drivers/net/wireless/ath/ath9k/virtual.c b/drivers/net/wireless/ath/ath9k/virtual.c
index 19b88f8..52becd3 100644
--- a/drivers/net/wireless/ath/ath9k/virtual.c
+++ b/drivers/net/wireless/ath/ath9k/virtual.c
@@ -93,7 +93,7 @@ void ath9k_set_bssid_mask(struct ieee80211_hw *hw)
 	sc->bssidmask[4] = ~mask[4];
 	sc->bssidmask[5] = ~mask[5];
 
-	ath9k_hw_setbssidmask(sc);
+	ath9k_hw_setbssidmask(sc->sc_ah);
 }
 
 int ath9k_wiphy_add(struct ath_softc *sc)
-- 
1.6.3.3

