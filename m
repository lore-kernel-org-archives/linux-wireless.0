Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:35428 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754388AbZHCTds (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 15:33:48 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2009 12:33:49 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 08/24] ath9k: pass only one argument to hw attach
Date: Mon, 3 Aug 2009 12:33:47 -0700
Message-ID: <1249328027-24865-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The softc is cached and set within the ath_hw struct.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

Resending, johill informs me this one didn't make it out.

 drivers/net/wireless/ath/ath9k/hw.c   |   12 ++++++------
 drivers/net/wireless/ath/ath9k/hw.h   |    2 +-
 drivers/net/wireless/ath/ath9k/main.c |    2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index d8ae289..301ef04 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -627,7 +627,7 @@ static bool ath9k_hw_devid_supported(u16 devid)
 	return false;
 }
 
-int ath9k_hw_attach(struct ath_hw *ah, struct ath_softc *sc)
+int ath9k_hw_attach(struct ath_hw *ah)
 {
 	int r;
 	u32 i, j;
@@ -641,13 +641,13 @@ int ath9k_hw_attach(struct ath_hw *ah, struct ath_softc *sc)
 	ath9k_hw_set_defaults(ah);
 
 	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON)) {
-		DPRINTF(sc, ATH_DBG_FATAL, "Couldn't reset chip\n");
+		DPRINTF(ah->ah_sc, ATH_DBG_FATAL, "Couldn't reset chip\n");
 		r = -EIO;
 		goto bad;
 	}
 
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE)) {
-		DPRINTF(sc, ATH_DBG_FATAL, "Couldn't wakeup chip\n");
+		DPRINTF(ah->ah_sc, ATH_DBG_FATAL, "Couldn't wakeup chip\n");
 		r = -EIO;
 		goto bad;
 	}
@@ -663,7 +663,7 @@ int ath9k_hw_attach(struct ath_hw *ah, struct ath_softc *sc)
 		}
 	}
 
-	DPRINTF(sc, ATH_DBG_RESET, "serialize_regmode is %d\n",
+	DPRINTF(ah->ah_sc, ATH_DBG_RESET, "serialize_regmode is %d\n",
 		ah->config.serialize_regmode);
 
 	switch (ah->hw_version.macVersion) {
@@ -676,7 +676,7 @@ int ath9k_hw_attach(struct ath_hw *ah, struct ath_softc *sc)
 	case AR_SREV_VERSION_9287:
 		break;
 	default:
-		DPRINTF(sc, ATH_DBG_FATAL,
+		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
 			"Mac Chip Rev 0x%02x.%x is not supported by "
 			"this driver\n", ah->hw_version.macVersion,
 			ah->hw_version.macRev);
@@ -945,7 +945,7 @@ int ath9k_hw_attach(struct ath_hw *ah, struct ath_softc *sc)
 
 	r = ath9k_hw_init_macaddr(ah);
 	if (r) {
-		DPRINTF(sc, ATH_DBG_FATAL,
+		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
 			"Failed to initialize MAC address\n");
 		goto bad;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index c769dd6..35cf9f8 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -544,7 +544,7 @@ struct ath_hw {
 /* Attach, Detach, Reset */
 const char *ath9k_hw_probe(u16 vendorid, u16 devid);
 void ath9k_hw_detach(struct ath_hw *ah);
-int ath9k_hw_attach(struct ath_hw *ah, struct ath_softc *sc);
+int ath9k_hw_attach(struct ath_hw *ah);
 void ath9k_hw_rfdetach(struct ath_hw *ah);
 int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		   bool bChannelChange);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 605d328..6242950 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1334,7 +1334,7 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	ah->hw_version.devid = devid;
 	sc->sc_ah = ah;
 
-	r = ath9k_hw_attach(ah, sc);
+	r = ath9k_hw_attach(ah);
 	if (r) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"Unable to attach hardware; "
-- 
1.6.3.3

