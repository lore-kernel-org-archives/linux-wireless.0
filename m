Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36651 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755219Ab1CVUy0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2011 16:54:26 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 2/3] ath9k: trigger nfcal only after multiple missed beacons in AP mode
Date: Tue, 22 Mar 2011 21:54:18 +0100
Message-Id: <1300827259-42910-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1300827259-42910-1-git-send-email-nbd@openwrt.org>
References: <1300827259-42910-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Single missed (i.e. not transmitted) beacons in AP mode are not very rare
and not necessarily an indicator of strong interference, so only trigger
noise floor recalibration when multiple consecutive beacons could not
be transmitted.
---
 drivers/net/wireless/ath/ath9k/beacon.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index b5eab2f..6ebeafe 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -368,7 +368,8 @@ void ath_beacon_tasklet(unsigned long data)
 				"missed %u consecutive beacons\n",
 				sc->beacon.bmisscnt);
 			ath9k_hw_stop_dma_queue(ah, sc->beacon.beaconq);
-			ath9k_hw_bstuck_nfcal(ah);
+			if (sc->beacon.bmisscnt > 3)
+				ath9k_hw_bstuck_nfcal(ah);
 		} else if (sc->beacon.bmisscnt >= BSTUCK_THRESH) {
 			ath_dbg(common, ATH_DBG_BSTUCK,
 				"beacon is officially stuck\n");
-- 
1.7.3.2

