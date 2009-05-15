Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:15536 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757314AbZEONes (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 09:34:48 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 15 May 2009 06:34:50 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: cleanup beacon parameters configuration
Date: Fri, 15 May 2009 18:59:22 +0530
Message-ID: <1242394162-9812-3-git-send-email-vasanth@atheros.com>
In-Reply-To: <1242394162-9812-2-git-send-email-vasanth@atheros.com>
References: <1242394162-9812-1-git-send-email-vasanth@atheros.com>
 <1242394162-9812-2-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch configures the beacon timers with beacon interval
and beacon period passed through vif.bss_conf. Also cache the
currecnt beacon configuration which will be used to configure
the beacon timers when the driver triggers it after reset.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |    1 +
 drivers/net/wireless/ath/ath9k/beacon.c |   63 +++++++++++++++++--------------
 2 files changed, 36 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 82d8b86..aaef870 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -604,6 +604,7 @@ struct ath_softc {
 	struct ath9k_debug debug;
 #endif
 	struct ath_bus_ops *bus_ops;
+	struct ath_beacon_config cur_beacon_conf;
 };
 
 struct ath_wiphy {
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index af5edb8..57f91a9 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -695,43 +695,50 @@ static void ath_beacon_config_adhoc(struct ath_softc *sc,
 	sc->beacon.bmisscnt = 0;
 	ath9k_hw_set_interrupts(sc->sc_ah, sc->imask);
 
-	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_VEOL)
+	/* FIXME: Handle properly when vif is NULL */
+	if (vif && sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_VEOL)
 		ath_beacon_start_adhoc(sc, vif);
 }
 
 void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif)
 {
-	struct ath_beacon_config conf;
+	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
+	enum nl80211_iftype iftype;
 
 	/* Setup the beacon configuration parameters */
 
-	memset(&conf, 0, sizeof(struct ath_beacon_config));
-	conf.beacon_interval = sc->beacon_interval ? : ATH_DEFAULT_BINTVAL;
-	conf.listen_interval = 1;
-	conf.dtim_period = conf.beacon_interval;
-	conf.dtim_count = 1;
-	conf.bmiss_timeout = ATH_DEFAULT_BMISS_LIMIT * conf.beacon_interval;
-
 	if (vif) {
-		struct ath_vif *avp = (struct ath_vif *)vif->drv_priv;
-
-		switch(avp->av_opmode) {
-		case NL80211_IFTYPE_AP:
-			ath_beacon_config_ap(sc, &conf);
-			break;
-		case NL80211_IFTYPE_ADHOC:
-		case NL80211_IFTYPE_MESH_POINT:
-			ath_beacon_config_adhoc(sc, &conf, vif);
-			break;
-		case NL80211_IFTYPE_STATION:
-			ath_beacon_config_sta(sc, &conf);
-			break;
-		default:
-			DPRINTF(sc, ATH_DBG_CONFIG,
-				"Unsupported beaconing mode\n");
-			return;
-		}
+		struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
+
+		iftype = vif->type;
 
-		sc->sc_flags |= SC_OP_BEACONS;
+		cur_conf->beacon_interval = bss_conf->beacon_int;
+		cur_conf->dtim_period = bss_conf->dtim_period;
+		cur_conf->listen_interval = 1;
+		cur_conf->dtim_count = 1;
+		cur_conf->bmiss_timeout =
+			ATH_DEFAULT_BMISS_LIMIT * cur_conf->beacon_interval;
+	} else {
+		iftype = sc->sc_ah->opmode;
 	}
+
+
+	switch (iftype) {
+	case NL80211_IFTYPE_AP:
+		ath_beacon_config_ap(sc, cur_conf);
+		break;
+	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_MESH_POINT:
+		ath_beacon_config_adhoc(sc, cur_conf, vif);
+		break;
+	case NL80211_IFTYPE_STATION:
+		ath_beacon_config_sta(sc, cur_conf);
+		break;
+	default:
+		DPRINTF(sc, ATH_DBG_CONFIG,
+			"Unsupported beaconing mode\n");
+		return;
+	}
+
+	sc->sc_flags |= SC_OP_BEACONS;
 }
-- 
1.5.5.1

