Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:59016 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbaCAUR4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2014 15:17:56 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, sujith@msujith.org,
	linville@tuxdriver.com
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 20/23] ath9k: move ath9k_beacon_config_ap common
Date: Sat,  1 Mar 2014 21:16:03 +0100
Message-Id: <1393704966-13985-21-git-send-email-linux@rempel-privat.de> (sfid-20140301_214709_643562_1F29BA65)
In-Reply-To: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
References: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/beacon.c        | 21 ++-----------------
 drivers/net/wireless/ath/ath9k/common-beacon.c | 29 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/common-beacon.h |  3 +++
 3 files changed, 34 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 01322a4..e188743 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -483,26 +483,9 @@ static void ath9k_beacon_config_ap(struct ath_softc *sc,
 				   struct ath_beacon_config *conf)
 {
 	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
-	u32 nexttbtt, intval;
-
-	/* NB: the beacon interval is kept internally in TU's */
-	intval = TU_TO_USEC(conf->beacon_interval);
-	intval /= ATH_BCBUF;
-	nexttbtt = ath9k_get_next_tbtt(sc, ath9k_hw_gettsf64(ah),
-				       conf->beacon_interval);
-
-	if (conf->enable_beacon)
-		ah->imask |= ATH9K_INT_SWBA;
-	else
-		ah->imask &= ~ATH9K_INT_SWBA;
-
-	ath_dbg(common, BEACON,
-		"AP (%s) nexttbtt: %u intval: %u conf_intval: %u\n",
-		(conf->enable_beacon) ? "Enable" : "Disable",
-		nexttbtt, intval, conf->beacon_interval);
 
-	ath9k_beacon_init(sc, nexttbtt, intval, false);
+	ath9k_cmn_beacon_config_ap(ah, conf, ATH_BCBUF);
+	ath9k_beacon_init(sc, conf->nexttbtt, conf->intval, false);
 }
 
 static void ath9k_beacon_config_sta(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/common-beacon.c b/drivers/net/wireless/ath/ath9k/common-beacon.c
index 45bc899..775d1d2 100644
--- a/drivers/net/wireless/ath/ath9k/common-beacon.c
+++ b/drivers/net/wireless/ath/ath9k/common-beacon.c
@@ -149,3 +149,32 @@ void ath9k_cmn_beacon_config_adhoc(struct ath_hw *ah,
 		conf->nexttbtt, conf->intval, conf->beacon_interval);
 }
 EXPORT_SYMBOL(ath9k_cmn_beacon_config_adhoc);
+
+/*
+ * For multi-bss ap support beacons are either staggered evenly over N slots or
+ * burst together.  For the former arrange for the SWBA to be delivered for each
+ * slot. Slots that are not occupied will generate nothing.
+ */
+void ath9k_cmn_beacon_config_ap(struct ath_hw *ah,
+				struct ath_beacon_config *conf,
+				unsigned int bc_buf)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	/* NB: the beacon interval is kept internally in TU's */
+	conf->intval = TU_TO_USEC(conf->beacon_interval);
+	conf->intval /= bc_buf;
+	conf->nexttbtt = ath9k_get_next_tbtt(ah, ath9k_hw_gettsf64(ah),
+				       conf->beacon_interval);
+
+	if (conf->enable_beacon)
+		ah->imask |= ATH9K_INT_SWBA;
+	else
+		ah->imask &= ~ATH9K_INT_SWBA;
+
+	ath_dbg(common, BEACON,
+		"AP (%s) nexttbtt: %u intval: %u conf_intval: %u\n",
+		(conf->enable_beacon) ? "Enable" : "Disable",
+		conf->nexttbtt, conf->intval, conf->beacon_interval);
+}
+EXPORT_SYMBOL(ath9k_cmn_beacon_config_ap);
diff --git a/drivers/net/wireless/ath/ath9k/common-beacon.h b/drivers/net/wireless/ath/ath9k/common-beacon.h
index d8e7c0d..3665d27 100644
--- a/drivers/net/wireless/ath/ath9k/common-beacon.h
+++ b/drivers/net/wireless/ath/ath9k/common-beacon.h
@@ -21,3 +21,6 @@ int ath9k_cmn_beacon_config_sta(struct ath_hw *ah,
 				struct ath9k_beacon_state *bs);
 void ath9k_cmn_beacon_config_adhoc(struct ath_hw *ah,
 				   struct ath_beacon_config *conf);
+void ath9k_cmn_beacon_config_ap(struct ath_hw *ah,
+				struct ath_beacon_config *conf,
+				unsigned int bc_buf);
-- 
1.9.0

