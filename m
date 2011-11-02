Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:53608 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969Ab1KBMKu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Nov 2011 08:10:50 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Cc: rodrigue@qca.qualcomm.com, nbd@openwrt.org, linville@tuxdriver.com,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH] ath9k: preserve DFS flags in calcrxfilter
Date: Wed,  2 Nov 2011 13:10:03 +0100
Message-Id: <1320235803-12190-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20111102_131054_050715_ED335C6C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RX filter flags previously set for DFS radar detection were not
preserved after "ath9k: disable unnecessary PHY error reporting".

This patch ensures that the flags required for DFS support are
kept set.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 592ae5b..02c8dc3 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -417,6 +417,7 @@ void ath_rx_cleanup(struct ath_softc *sc)
  * Calculate the receive filter according to the
  * operating mode and state:
  *
+ * o preserve DFS (phyerror, phyradar)
  * o always accept unicast, broadcast, and multicast traffic
  * o maintain current state of phy error reception (the hal
  *   may enable phy error frames for noise immunity work)
@@ -434,10 +435,15 @@ void ath_rx_cleanup(struct ath_softc *sc)
 
 u32 ath_calcrxfilter(struct ath_softc *sc)
 {
+	const u32 rx_filter_preserve =
+		(ATH9K_RX_FILTER_PHYERR | ATH9K_RX_FILTER_PHYRADAR);
+	const u32 rx_filter_accept =
+		(ATH9K_RX_FILTER_UCAST | ATH9K_RX_FILTER_BCAST
+				| ATH9K_RX_FILTER_MCAST);
 	u32 rfilt;
 
-	rfilt = ATH9K_RX_FILTER_UCAST | ATH9K_RX_FILTER_BCAST
-		| ATH9K_RX_FILTER_MCAST;
+	rfilt = (ath9k_hw_getrxfilter(sc->sc_ah) & rx_filter_preserve);
+	rfilt |= rx_filter_accept;
 
 	if (sc->rx.rxfilter & FIF_PROBE_REQ)
 		rfilt |= ATH9K_RX_FILTER_PROBEREQ;
@@ -475,8 +481,6 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 	}
 
 	return rfilt;
-
-#undef RX_FILTER_PRESERVE
 }
 
 int ath_startrecv(struct ath_softc *sc)
-- 
1.7.4.1

