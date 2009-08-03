Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34787 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754442AbZHCTZB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 15:25:01 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2009 12:25:03 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 04/24] ath9k: move memory allocation of ath_hw to ath_init()
Date: Mon, 3 Aug 2009 12:24:36 -0700
Message-ID: <1249327496-24629-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1249327496-24629-1-git-send-email-lrodriguez@atheros.com>
References: <1249327496-24629-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This lets us simplify attach code and arguments passed.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c   |   65 ++++++++++-----------------------
 drivers/net/wireless/ath/ath9k/hw.h   |    2 +-
 drivers/net/wireless/ath/ath9k/main.c |   35 ++++++++++++------
 3 files changed, 44 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 2e09204..fcefea8 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -437,20 +437,9 @@ static void ath9k_hw_set_defaults(struct ath_hw *ah)
 		ah->config.serialize_regmode = SER_REG_MODE_AUTO;
 }
 
-static struct ath_hw *ath9k_hw_newstate(u16 devid, struct ath_softc *sc,
-					int *status)
+static void ath9k_hw_newstate(u16 devid,
+			      struct ath_hw *ah)
 {
-	struct ath_hw *ah;
-
-	ah = kzalloc(sizeof(struct ath_hw), GFP_KERNEL);
-	if (ah == NULL) {
-		DPRINTF(sc, ATH_DBG_FATAL,
-			"Cannot allocate memory for state block\n");
-		*status = -ENOMEM;
-		return NULL;
-	}
-
-	ah->ah_sc = sc;
 	ah->hw_version.magic = AR5416_MAGIC;
 	ah->regulatory.country_code = CTRY_DEFAULT;
 	ah->hw_version.devid = devid;
@@ -479,8 +468,6 @@ static struct ath_hw *ath9k_hw_newstate(u16 devid, struct ath_softc *sc,
 	ah->gbeacon_rate = 0;
 
 	ah->power_mode = ATH9K_PM_UNDEFINED;
-
-	return ah;
 }
 
 static int ath9k_hw_rfattach(struct ath_hw *ah)
@@ -623,28 +610,25 @@ static int ath9k_hw_post_attach(struct ath_hw *ah)
 	return 0;
 }
 
-static struct ath_hw *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
-					 int *status)
+static int ath9k_hw_do_attach(struct ath_hw *ah,
+			      u16 devid,
+			      struct ath_softc *sc)
 {
-	struct ath_hw *ah;
-	int ecode;
+	int r;
 	u32 i, j;
 
-	ah = ath9k_hw_newstate(devid, sc, status);
-	if (ah == NULL)
-		return NULL;
-
+	ath9k_hw_newstate(devid, ah);
 	ath9k_hw_set_defaults(ah);
 
 	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON)) {
 		DPRINTF(sc, ATH_DBG_FATAL, "Couldn't reset chip\n");
-		ecode = -EIO;
+		r = -EIO;
 		goto bad;
 	}
 
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE)) {
 		DPRINTF(sc, ATH_DBG_FATAL, "Couldn't wakeup chip\n");
-		ecode = -EIO;
+		r = -EIO;
 		goto bad;
 	}
 
@@ -676,7 +660,7 @@ static struct ath_hw *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 			"Mac Chip Rev 0x%02x.%x is not supported by "
 			"this driver\n", ah->hw_version.macVersion,
 			ah->hw_version.macRev);
-		ecode = -EOPNOTSUPP;
+		r = -EOPNOTSUPP;
 		goto bad;
 	}
 
@@ -878,8 +862,8 @@ static struct ath_hw *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 	else
 		ath9k_hw_disablepcie(ah);
 
-	ecode = ath9k_hw_post_attach(ah);
-	if (ecode != 0)
+	r = ath9k_hw_post_attach(ah);
+	if (r)
 		goto bad;
 
 	if (AR_SREV_9287_11(ah))
@@ -939,8 +923,8 @@ static struct ath_hw *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 		}
 	}
 
-	ecode = ath9k_hw_init_macaddr(ah);
-	if (ecode != 0) {
+	r = ath9k_hw_init_macaddr(ah);
+	if (r) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"Failed to initialize MAC address\n");
 		goto bad;
@@ -953,14 +937,10 @@ static struct ath_hw *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 
 	ath9k_init_nfcal_hist_buffer(ah);
 
-	return ah;
+	return 0;
 bad:
-	if (ah)
-		ath9k_hw_detach(ah);
-	if (status)
-		*status = ecode;
-
-	return NULL;
+	ath9k_hw_detach(ah);
+	return r;
 }
 
 static void ath9k_hw_init_bb(struct ath_hw *ah,
@@ -1206,10 +1186,8 @@ void ath9k_hw_detach(struct ath_hw *ah)
 	kfree(ah);
 }
 
-struct ath_hw *ath9k_hw_attach(u16 devid, struct ath_softc *sc, int *error)
+int ath9k_hw_attach(struct ath_hw *ah, u16 devid, struct ath_softc *sc)
 {
-	struct ath_hw *ah = NULL;
-
 	switch (devid) {
 	case AR5416_DEVID_PCI:
 	case AR5416_DEVID_PCIE:
@@ -1220,14 +1198,11 @@ struct ath_hw *ath9k_hw_attach(u16 devid, struct ath_softc *sc, int *error)
 	case AR9285_DEVID_PCIE:
 	case AR5416_DEVID_AR9287_PCI:
 	case AR5416_DEVID_AR9287_PCIE:
-		ah = ath9k_hw_do_attach(devid, sc, error);
-		break;
+		return ath9k_hw_do_attach(ah, devid, sc);
 	default:
-		*error = -EOPNOTSUPP;
 		break;
 	}
-
-	return ah;
+	return -EOPNOTSUPP;
 }
 
 /*******/
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 93a8930..4a0d5f2 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -544,7 +544,7 @@ struct ath_hw {
 /* Attach, Detach, Reset */
 const char *ath9k_hw_probe(u16 vendorid, u16 devid);
 void ath9k_hw_detach(struct ath_hw *ah);
-struct ath_hw *ath9k_hw_attach(u16 devid, struct ath_softc *sc, int *error);
+int ath9k_hw_attach(struct ath_hw *ah, u16 devid, struct ath_softc *sc);
 void ath9k_hw_rfdetach(struct ath_hw *ah);
 int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		   bool bChannelChange);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index ada5fef..c2b9974 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1295,7 +1295,7 @@ static int ath9k_reg_notifier(struct wiphy *wiphy,
 static int ath_init(u16 devid, struct ath_softc *sc)
 {
 	struct ath_hw *ah = NULL;
-	int error = 0, i;
+	int r = 0, i;
 	int csz = 0;
 
 	/* XXX: hardware will not be ready until ath_open() being called */
@@ -1322,11 +1322,21 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	/* XXX assert csz is non-zero */
 	sc->cachelsz = csz << 2;	/* convert to bytes */
 
-	ah = ath9k_hw_attach(devid, sc, &error);
-	if (ah == NULL) {
+	ah = kzalloc(sizeof(struct ath_hw), GFP_KERNEL);
+	if (!ah) {
+		DPRINTF(sc, ATH_DBG_FATAL,
+			"Cannot allocate memory for state block\n");
+		r = -ENOMEM;
+		goto bad_no_ah;
+	}
+
+	ah->ah_sc = sc;
+
+	r = ath9k_hw_attach(ah, devid, sc);
+	if (r) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"Unable to attach hardware; "
-			"initialization status: %d\n", error);
+			"initialization status: %d\n", r);
 		goto bad;
 	}
 	sc->sc_ah = ah;
@@ -1347,7 +1357,7 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	for (i = 0; i < sc->keymax; i++)
 		ath9k_hw_keyreset(ah, (u16) i);
 
-	if (error)
+	if (r)
 		goto bad;
 
 	/* default to MONITOR mode */
@@ -1369,14 +1379,14 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	if (sc->beacon.beaconq == -1) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"Unable to setup a beacon xmit queue\n");
-		error = -EIO;
+		r = -EIO;
 		goto bad2;
 	}
 	sc->beacon.cabq = ath_txq_setup(sc, ATH9K_TX_QUEUE_CAB, 0);
 	if (sc->beacon.cabq == NULL) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"Unable to setup CAB xmit queue\n");
-		error = -EIO;
+		r = -EIO;
 		goto bad2;
 	}
 
@@ -1391,26 +1401,26 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	if (!ath_tx_setup(sc, ATH9K_WME_AC_BK)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"Unable to setup xmit queue for BK traffic\n");
-		error = -EIO;
+		r = -EIO;
 		goto bad2;
 	}
 
 	if (!ath_tx_setup(sc, ATH9K_WME_AC_BE)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"Unable to setup xmit queue for BE traffic\n");
-		error = -EIO;
+		r = -EIO;
 		goto bad2;
 	}
 	if (!ath_tx_setup(sc, ATH9K_WME_AC_VI)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"Unable to setup xmit queue for VI traffic\n");
-		error = -EIO;
+		r = -EIO;
 		goto bad2;
 	}
 	if (!ath_tx_setup(sc, ATH9K_WME_AC_VO)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"Unable to setup xmit queue for VO traffic\n");
-		error = -EIO;
+		r = -EIO;
 		goto bad2;
 	}
 
@@ -1506,9 +1516,10 @@ bad2:
 bad:
 	if (ah)
 		ath9k_hw_detach(ah);
+bad_no_ah:
 	ath9k_exit_debug(sc);
 
-	return error;
+	return r;
 }
 
 void ath_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
-- 
1.6.3.3

