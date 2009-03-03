Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:40018 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758022AbZCCEuz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 23:50:55 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2009 20:50:54 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18860.46657.951020.582721@gargle.gargle.HOWL> (sfid-20090303_055114_122109_A42FF969)
Date: Tue, 3 Mar 2009 10:16:57 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 6/7] ath9k: Lock config_interface() callback with a mutex
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index ee72a0c..4f68e30 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -2316,6 +2316,8 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 	u32 rfilt = 0;
 	int error, i;
 
+	mutex_lock(&sc->mutex);
+
 	/* TODO: Need to decide which hw opmode to use for multi-interface
 	 * cases */
 	if (vif->type == NL80211_IFTYPE_AP &&
@@ -2371,8 +2373,10 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 			ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
 
 			error = ath_beacon_alloc(sc, 0);
-			if (error != 0)
+			if (error != 0) {
+				mutex_unlock(&sc->mutex);
 				return error;
+			}
 
 			ath_beacon_config(sc, 0);
 		}
@@ -2391,6 +2395,8 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 	if (vif->type == NL80211_IFTYPE_ADHOC)
 		ath_update_chainmask(sc, 0);
 
+	mutex_unlock(&sc->mutex);
+
 	return 0;
 }
 
-- 
1.6.1

