Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42043 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762681Ab2DLUgI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 16:36:08 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 4/4] ath9k: optimize the hardware hang check
Date: Thu, 12 Apr 2012 22:35:58 +0200
Message-Id: <1334262958-90777-4-git-send-email-nbd@openwrt.org> (sfid-20120412_223616_942951_9E5B0866)
In-Reply-To: <1334262958-90777-3-git-send-email-nbd@openwrt.org>
References: <1334262958-90777-1-git-send-email-nbd@openwrt.org>
 <1334262958-90777-2-git-send-email-nbd@openwrt.org>
 <1334262958-90777-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since it's only called when beacons are stuck, move it to the SWBA handler
tasklet, to avoid doing redundant checks on every single interrupt.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/beacon.c |    3 +++
 drivers/net/wireless/ath/ath9k/main.c   |   11 -----------
 2 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 6264182..df5b6ac 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -369,6 +369,9 @@ void ath_beacon_tasklet(unsigned long data)
 	if (ath9k_hw_numtxpending(ah, sc->beacon.beaconq) != 0) {
 		sc->beacon.bmisscnt++;
 
+		if (!ath9k_hw_check_alive(ah))
+			ieee80211_queue_work(sc->hw, &sc->hw_check_work);
+
 		if (sc->beacon.bmisscnt < BSTUCK_THRESH * sc->nbcnvifs) {
 			ath_dbg(common, BSTUCK,
 				"missed %u consecutive beacons\n",
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index fcb13e3..95dc62e 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -692,17 +692,6 @@ void ath9k_tasklet(unsigned long data)
 		goto out;
 	}
 
-	/*
-	 * Only run the baseband hang check if beacons stop working in AP or
-	 * IBSS mode, because it has a high false positive rate. For station
-	 * mode it should not be necessary, since the upper layers will detect
-	 * this through a beacon miss automatically and the following channel
-	 * change will trigger a hardware reset anyway
-	 */
-	if (ath9k_hw_numtxpending(ah, sc->beacon.beaconq) != 0 &&
-	    !ath9k_hw_check_alive(ah))
-		ieee80211_queue_work(sc->hw, &sc->hw_check_work);
-
 	if ((status & ATH9K_INT_TSFOOR) && sc->ps_enabled) {
 		/*
 		 * TSF sync does not look correct; remain awake to sync with
-- 
1.7.3.2

