Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42489 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab0INTA1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 15:00:27 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [ath9k] ath9k:  calcrxfilter should take multiple VIFs into account.
Date: Tue, 14 Sep 2010 12:00:22 -0700
Message-Id: <1284490822-11058-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

When there is more than one VIF, listen for all beacons
and ensure ATH9K_RX_FILTER_MCAST_BCAST_ALL is set.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 b32c8f0... 6ba971b... M	drivers/net/wireless/ath/ath9k/recv.c
 drivers/net/wireless/ath/ath9k/recv.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index b32c8f0..6ba971b 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -449,6 +449,7 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 		rfilt |= ATH9K_RX_FILTER_CONTROL;
 
 	if ((sc->sc_ah->opmode == NL80211_IFTYPE_STATION) &&
+	    (sc->nvifs <= 1) &&
 	    !(sc->rx.rxfilter & FIF_BCN_PRBRESP_PROMISC))
 		rfilt |= ATH9K_RX_FILTER_MYBEACON;
 	else
@@ -463,9 +464,8 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 	if (conf_is_ht(&sc->hw->conf))
 		rfilt |= ATH9K_RX_FILTER_COMP_BAR;
 
-	if (sc->sec_wiphy || (sc->rx.rxfilter & FIF_OTHER_BSS)) {
-		/* TODO: only needed if more than one BSSID is in use in
-		 * station/adhoc mode */
+	if (sc->sec_wiphy || (sc->nvifs > 1) ||
+	    (sc->rx.rxfilter & FIF_OTHER_BSS)) {
 		/* The following may also be needed for other older chips */
 		if (sc->sc_ah->hw_version.macVersion == AR_SREV_VERSION_9160)
 			rfilt |= ATH9K_RX_FILTER_PROM;
-- 
1.7.2.2

