Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:55019 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbaCAURb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2014 15:17:31 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, sujith@msujith.org,
	linville@tuxdriver.com
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 15/23] ath9k: move ath9k_beacon_config_adhoc to common
Date: Sat,  1 Mar 2014 21:15:58 +0100
Message-Id: <1393704966-13985-16-git-send-email-linux@rempel-privat.de> (sfid-20140301_214709_523065_808B1C89)
In-Reply-To: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
References: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/beacon.c        | 21 ++-------------------
 drivers/net/wireless/ath/ath9k/common-beacon.c | 25 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/common-beacon.h |  2 ++
 3 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 9333fa1..01322a4 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -526,29 +526,12 @@ static void ath9k_beacon_config_adhoc(struct ath_softc *sc,
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
-	u32 intval, nexttbtt;
 
 	ath9k_reset_beacon_status(sc);
 
-	intval = TU_TO_USEC(conf->beacon_interval);
-
-	if (conf->ibss_creator)
-		nexttbtt = intval;
-	else
-		nexttbtt = ath9k_get_next_tbtt(sc, ath9k_hw_gettsf64(ah),
-					       conf->beacon_interval);
-
-	if (conf->enable_beacon)
-		ah->imask |= ATH9K_INT_SWBA;
-	else
-		ah->imask &= ~ATH9K_INT_SWBA;
-
-	ath_dbg(common, BEACON,
-		"IBSS (%s) nexttbtt: %u intval: %u conf_intval: %u\n",
-		(conf->enable_beacon) ? "Enable" : "Disable",
-		nexttbtt, intval, conf->beacon_interval);
+	ath9k_cmn_beacon_config_adhoc(ah, conf);
 
-	ath9k_beacon_init(sc, nexttbtt, intval, conf->ibss_creator);
+	ath9k_beacon_init(sc, conf->nexttbtt, conf->intval, conf->ibss_creator);
 
 	/*
 	 * Set the global 'beacon has been configured' flag for the
diff --git a/drivers/net/wireless/ath/ath9k/common-beacon.c b/drivers/net/wireless/ath/ath9k/common-beacon.c
index 35cc9fd..45bc899 100644
--- a/drivers/net/wireless/ath/ath9k/common-beacon.c
+++ b/drivers/net/wireless/ath/ath9k/common-beacon.c
@@ -124,3 +124,28 @@ int ath9k_cmn_beacon_config_sta(struct ath_hw *ah,
 	return 0;
 }
 EXPORT_SYMBOL(ath9k_cmn_beacon_config_sta);
+
+void ath9k_cmn_beacon_config_adhoc(struct ath_hw *ah,
+				   struct ath_beacon_config *conf)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	conf->intval = TU_TO_USEC(conf->beacon_interval);
+
+	if (conf->ibss_creator)
+		conf->nexttbtt = conf->intval;
+	else
+		conf->nexttbtt = ath9k_get_next_tbtt(ah, ath9k_hw_gettsf64(ah),
+					       conf->beacon_interval);
+
+	if (conf->enable_beacon)
+		ah->imask |= ATH9K_INT_SWBA;
+	else
+		ah->imask &= ~ATH9K_INT_SWBA;
+
+	ath_dbg(common, BEACON,
+		"IBSS (%s) nexttbtt: %u intval: %u conf_intval: %u\n",
+		(conf->enable_beacon) ? "Enable" : "Disable",
+		conf->nexttbtt, conf->intval, conf->beacon_interval);
+}
+EXPORT_SYMBOL(ath9k_cmn_beacon_config_adhoc);
diff --git a/drivers/net/wireless/ath/ath9k/common-beacon.h b/drivers/net/wireless/ath/ath9k/common-beacon.h
index 51cbcb5..d8e7c0d 100644
--- a/drivers/net/wireless/ath/ath9k/common-beacon.h
+++ b/drivers/net/wireless/ath/ath9k/common-beacon.h
@@ -19,3 +19,5 @@ struct ath_beacon_config;
 int ath9k_cmn_beacon_config_sta(struct ath_hw *ah,
 				struct ath_beacon_config *conf,
 				struct ath9k_beacon_state *bs);
+void ath9k_cmn_beacon_config_adhoc(struct ath_hw *ah,
+				   struct ath_beacon_config *conf);
-- 
1.9.0

