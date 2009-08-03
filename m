Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34788 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622AbZHCTZD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 15:25:03 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2009 12:25:04 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 05/24] ath9k: move devid cache setting to ath_init()
Date: Mon, 3 Aug 2009 12:24:37 -0700
Message-ID: <1249327496-24629-6-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1249327496-24629-1-git-send-email-lrodriguez@atheros.com>
References: <1249327496-24629-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This lets us trim one argument off of hw initializer routines.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c   |   15 ++++++---------
 drivers/net/wireless/ath/ath9k/hw.h   |    2 +-
 drivers/net/wireless/ath/ath9k/main.c |    3 ++-
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index fcefea8..ff2875b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -437,16 +437,14 @@ static void ath9k_hw_set_defaults(struct ath_hw *ah)
 		ah->config.serialize_regmode = SER_REG_MODE_AUTO;
 }
 
-static void ath9k_hw_newstate(u16 devid,
-			      struct ath_hw *ah)
+static void ath9k_hw_newstate(struct ath_hw *ah)
 {
 	ah->hw_version.magic = AR5416_MAGIC;
 	ah->regulatory.country_code = CTRY_DEFAULT;
-	ah->hw_version.devid = devid;
 	ah->hw_version.subvendorid = 0;
 
 	ah->ah_flags = 0;
-	if ((devid == AR5416_AR9100_DEVID))
+	if (ah->hw_version.devid == AR5416_AR9100_DEVID)
 		ah->hw_version.macVersion = AR_SREV_VERSION_9100;
 	if (!AR_SREV_9100(ah))
 		ah->ah_flags = AH_USE_EEPROM;
@@ -611,13 +609,12 @@ static int ath9k_hw_post_attach(struct ath_hw *ah)
 }
 
 static int ath9k_hw_do_attach(struct ath_hw *ah,
-			      u16 devid,
 			      struct ath_softc *sc)
 {
 	int r;
 	u32 i, j;
 
-	ath9k_hw_newstate(devid, ah);
+	ath9k_hw_newstate(ah);
 	ath9k_hw_set_defaults(ah);
 
 	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON)) {
@@ -1186,9 +1183,9 @@ void ath9k_hw_detach(struct ath_hw *ah)
 	kfree(ah);
 }
 
-int ath9k_hw_attach(struct ath_hw *ah, u16 devid, struct ath_softc *sc)
+int ath9k_hw_attach(struct ath_hw *ah, struct ath_softc *sc)
 {
-	switch (devid) {
+	switch (ah->hw_version.devid) {
 	case AR5416_DEVID_PCI:
 	case AR5416_DEVID_PCIE:
 	case AR5416_AR9100_DEVID:
@@ -1198,7 +1195,7 @@ int ath9k_hw_attach(struct ath_hw *ah, u16 devid, struct ath_softc *sc)
 	case AR9285_DEVID_PCIE:
 	case AR5416_DEVID_AR9287_PCI:
 	case AR5416_DEVID_AR9287_PCIE:
-		return ath9k_hw_do_attach(ah, devid, sc);
+		return ath9k_hw_do_attach(ah, sc);
 	default:
 		break;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 4a0d5f2..c769dd6 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -544,7 +544,7 @@ struct ath_hw {
 /* Attach, Detach, Reset */
 const char *ath9k_hw_probe(u16 vendorid, u16 devid);
 void ath9k_hw_detach(struct ath_hw *ah);
-int ath9k_hw_attach(struct ath_hw *ah, u16 devid, struct ath_softc *sc);
+int ath9k_hw_attach(struct ath_hw *ah, struct ath_softc *sc);
 void ath9k_hw_rfdetach(struct ath_hw *ah);
 int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		   bool bChannelChange);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c2b9974..fa2c230 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1331,8 +1331,9 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	}
 
 	ah->ah_sc = sc;
+	ah->hw_version.devid = devid;
 
-	r = ath9k_hw_attach(ah, devid, sc);
+	r = ath9k_hw_attach(ah, sc);
 	if (r) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"Unable to attach hardware; "
-- 
1.6.3.3

