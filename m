Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:38235 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab1DLL7z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 07:59:55 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 04:59:29 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] ath9k: Fix improper beacon slot selection in IBSS
Date: Tue, 12 Apr 2011 17:29:29 +0530
Message-ID: <1302609569-11696-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Request a re-configuration of Beacon related timers
on the receipt of the first Beacon frame has to be set only
for station mode. Setting beacon sync for IBSS is causing
wrong beacon slot selection on beacon generation.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/beacon.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index b56f69e..9193a38 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -744,7 +744,6 @@ void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif)
 		cur_conf->dtim_period = 1;
 
 	ath_set_beacon(sc);
-	sc->ps_flags |= PS_BEACON_SYNC | PS_WAIT_FOR_BEACON;
 }
 
 void ath_set_beacon(struct ath_softc *sc)
@@ -762,6 +761,12 @@ void ath_set_beacon(struct ath_softc *sc)
 		break;
 	case NL80211_IFTYPE_STATION:
 		ath_beacon_config_sta(sc, cur_conf);
+		/*
+		 * Request a re-configuration of Beacon related timers
+		 * on the receipt of the first Beacon frame (i.e.,
+		 * after time sync with the AP).
+		 */
+		sc->ps_flags |= PS_BEACON_SYNC | PS_WAIT_FOR_BEACON;
 		break;
 	default:
 		ath_dbg(common, ATH_DBG_CONFIG,
-- 
1.7.4.4

