Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:30107 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571AbZA0F3V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 00:29:21 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2009 21:29:21 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18814.39650.476444.154467@gargle.gargle.HOWL> (sfid-20090127_062944_829626_A52E70DC)
Date: Tue, 27 Jan 2009 10:55:54 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH] ath9k: Reconfigure beacons on getting a notification from mac80211
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |   35 +++++++++++++++++++----------------
 1 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index d92da13..e659c36 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -2253,24 +2253,27 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 		}
 	}
 
-	if ((conf->changed & IEEE80211_IFCC_BEACON) &&
-	    ((vif->type == NL80211_IFTYPE_ADHOC) ||
-	     (vif->type == NL80211_IFTYPE_AP))) {
-		/*
-		 * Allocate and setup the beacon frame.
-		 *
-		 * Stop any previous beacon DMA.  This may be
-		 * necessary, for example, when an ibss merge
-		 * causes reconfiguration; we may be called
-		 * with beacon transmission active.
-		 */
-		ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
+	if ((vif->type == NL80211_IFTYPE_ADHOC) ||
+	    (vif->type == NL80211_IFTYPE_AP)) {
+		if ((conf->changed & IEEE80211_IFCC_BEACON) ||
+		    (conf->changed & IEEE80211_IFCC_BEACON_ENABLED &&
+		     conf->enable_beacon)) {
+			/*
+			 * Allocate and setup the beacon frame.
+			 *
+			 * Stop any previous beacon DMA.  This may be
+			 * necessary, for example, when an ibss merge
+			 * causes reconfiguration; we may be called
+			 * with beacon transmission active.
+			 */
+			ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
 
-		error = ath_beacon_alloc(sc, 0);
-		if (error != 0)
-			return error;
+			error = ath_beacon_alloc(sc, 0);
+			if (error != 0)
+				return error;
 
-		ath_beacon_sync(sc, 0);
+			ath_beacon_sync(sc, 0);
+		}
 	}
 
 	/* Check for WLAN_CAPABILITY_PRIVACY ? */
-- 
1.6.1

