Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:49461 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083AbZATIBr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 03:01:47 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2009 00:01:47 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18805.33820.337059.136518@gargle.gargle.HOWL> (sfid-20090120_090156_211719_E09C2C5E)
Date: Tue, 20 Jan 2009 13:28:20 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH] ath9k: Reconfigure beacons only when enable_beacon is set
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 8ad927a..0f931c2 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -2194,13 +2194,16 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 		 * causes reconfiguration; we may be called
 		 * with beacon transmission active.
 		 */
-		ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
 
-		error = ath_beacon_alloc(sc, 0);
-		if (error != 0)
-			return error;
+		if (conf->enable_beacon) {
+			ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
+
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

