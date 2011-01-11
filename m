Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.resortinternet.net ([65.114.208.136]:42873 "EHLO
	smtp.resortinternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab1AKAVN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 19:21:13 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 4/4] ath9k: reduce the likelihood of baseband hang check false positives
Date: Mon, 10 Jan 2011 17:05:50 -0700
Message-Id: <1294704350-50621-4-git-send-email-nbd@openwrt.org>
In-Reply-To: <1294704350-50621-3-git-send-email-nbd@openwrt.org>
References: <1294704350-50621-1-git-send-email-nbd@openwrt.org>
 <1294704350-50621-2-git-send-email-nbd@openwrt.org>
 <1294704350-50621-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since baseband hangs are rare, but the hang check function has a high
false positive rate in some situations, we need to add more reliable
indicators.

In AP mode we can use blocked beacon transmissions as an indicator,
they should be rare enough.

In station mode, we can skip the hang check entirely, since a true
hang will trigger beacon loss detection, and mac80211 will rescan,
which leads to a hw reset that will bring the hardware back to life.

To make this more reliable, we need to skip fast channel changes
if the hardware appears to be stuck.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index f90a6ca..c753ba4 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -251,6 +251,9 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 	if (!ath_stoprecv(sc))
 		stopped = false;
 
+	if (!ath9k_hw_check_alive(ah))
+		stopped = false;
+
 	/* XXX: do not flush receive queue here. We don't want
 	 * to flush data frames already in queue because of
 	 * changing channel. */
@@ -602,7 +605,15 @@ void ath9k_tasklet(unsigned long data)
 
 	spin_lock(&sc->sc_pcu_lock);
 
-	if (!ath9k_hw_check_alive(ah))
+	/*
+	 * Only run the baseband hang check if beacons stop working in AP or
+	 * IBSS mode, because it has a high false positive rate. For station
+	 * mode it should not be necessary, since the upper layers will detect
+	 * this through a beacon miss automatically and the following channel
+	 * change will trigger a hardware reset anyway
+	 */
+	if (ath9k_hw_numtxpending(ah, sc->beacon.beaconq) != 0 &&
+	    !ath9k_hw_check_alive(ah))
 		ieee80211_queue_work(sc->hw, &sc->hw_check_work);
 
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
-- 
1.7.3.2

