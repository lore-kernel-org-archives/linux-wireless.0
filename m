Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43179 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754698Ab1EPVWJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 17:22:09 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, linville@tuxdriver.com,
	rmanoharan@atheros.com
Subject: [PATCH] ath9k: fix ad-hoc mode beacon selection
Date: Mon, 16 May 2011 23:22:00 +0200
Message-Id: <1305580920-2021-1-git-send-email-nbd@openwrt.org> (sfid-20110516_232213_515001_EE9BE60C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In ad-hoc mode, beacon timers are configured differently compared to AP
mode, and (depending on the scenario) can vary enough to make the beacon
tasklet not detect slot 0 based on the TSF.
Since staggered beacons are not (and cannot be) used in ad-hoc mode, it
makes more sense to just hardcode slot 0 here, avoiding unnecessary
TSF reads and calculations.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Reported-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/beacon.c |   32 +++++++++++++++++++-----------
 1 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 637dbc5..c7f4679 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -351,9 +351,7 @@ void ath_beacon_tasklet(unsigned long data)
 	struct ath_buf *bf = NULL;
 	struct ieee80211_vif *vif;
 	int slot;
-	u32 bfaddr, bc = 0, tsftu;
-	u64 tsf;
-	u16 intval;
+	u32 bfaddr, bc = 0;
 
 	/*
 	 * Check if the previous beacon has gone out.  If
@@ -388,17 +386,27 @@ void ath_beacon_tasklet(unsigned long data)
 	 * on the tsf to safeguard against missing an swba.
 	 */
 
-	intval = cur_conf->beacon_interval ? : ATH_DEFAULT_BINTVAL;
 
-	tsf = ath9k_hw_gettsf64(ah);
-	tsf += TU_TO_USEC(ah->config.sw_beacon_response_time);
-	tsftu = TSF_TO_TU((tsf * ATH_BCBUF) >>32, tsf * ATH_BCBUF);
-	slot = (tsftu % (intval * ATH_BCBUF)) / intval;
-	vif = sc->beacon.bslot[slot];
+	if (ah->opmode == NL80211_IFTYPE_AP) {
+		u16 intval;
+		u32 tsftu;
+		u64 tsf;
+
+		intval = cur_conf->beacon_interval ? : ATH_DEFAULT_BINTVAL;
+		tsf = ath9k_hw_gettsf64(ah);
+		tsf += TU_TO_USEC(ah->config.sw_beacon_response_time);
+		tsftu = TSF_TO_TU((tsf * ATH_BCBUF) >>32, tsf * ATH_BCBUF);
+		slot = (tsftu % (intval * ATH_BCBUF)) / intval;
+		vif = sc->beacon.bslot[slot];
+
+		ath_dbg(common, ATH_DBG_BEACON,
+			"slot %d [tsf %llu tsftu %u intval %u] vif %p\n",
+			slot, tsf, tsftu / ATH_BCBUF, intval, vif);
+	} else {
+		slot = 0;
+		vif = sc->beacon.bslot[slot];
+	}
 
-	ath_dbg(common, ATH_DBG_BEACON,
-		"slot %d [tsf %llu tsftu %u intval %u] vif %p\n",
-		slot, tsf, tsftu / ATH_BCBUF, intval, vif);
 
 	bfaddr = 0;
 	if (vif) {
-- 
1.7.3.2

