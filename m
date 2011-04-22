Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:37051 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754274Ab1DVJUv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Apr 2011 05:20:51 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 22 Apr 2011 02:20:25 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 2/2] ath9k: set beacon related ps flags on bss_info change
Date: Fri, 22 Apr 2011 14:50:39 +0530
Message-ID: <1303464039-11574-2-git-send-email-rmanoharan@atheros.com>
In-Reply-To: <1303464039-11574-1-git-send-email-rmanoharan@atheros.com>
References: <1303464039-11574-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Requesting beacon sync up to configure beacon timers properly
in hw, has be done after doing beacon config with default values.
Setting the flags in beacon config is causing the device to not
enter into network sleep on idle state.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/beacon.c |    6 ------
 drivers/net/wireless/ath/ath9k/main.c   |    6 ++++++
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 24f565b..22cd241 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -781,12 +781,6 @@ void ath_set_beacon(struct ath_softc *sc)
 		break;
 	case NL80211_IFTYPE_STATION:
 		ath_beacon_config_sta(sc, cur_conf);
-		/*
-		 * Request a re-configuration of Beacon related timers
-		 * on the receipt of the first Beacon frame (i.e.,
-		 * after time sync with the AP).
-		 */
-		sc->ps_flags |= PS_BEACON_SYNC | PS_WAIT_FOR_BEACON;
 		break;
 	default:
 		ath_dbg(common, ATH_DBG_CONFIG,
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a8d9009..0fb01b7 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1932,6 +1932,12 @@ static void ath9k_bss_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 				"Bss Info ASSOC %d, bssid: %pM\n",
 				bss_conf->aid, common->curbssid);
 			ath_beacon_config(sc, vif);
+			/*
+			 * Request a re-configuration of Beacon related timers
+			 * on the receipt of the first Beacon frame (i.e.,
+			 * after time sync with the AP).
+			 */
+			sc->ps_flags |= PS_BEACON_SYNC | PS_WAIT_FOR_BEACON;
 			/* Reset rssi stats */
 			sc->last_rssi = ATH_RSSI_DUMMY_MARKER;
 			sc->sc_ah->stats.avgbrssi = ATH_RSSI_DUMMY_MARKER;
-- 
1.7.4.4

