Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57391 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754234Ab1DGRY1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 13:24:27 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH] ath9k: fix PS-Poll reception on AR9160 and earlier
Date: Thu,  7 Apr 2011 19:24:23 +0200
Message-Id: <1302197063-31863-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I can't find any valid reason for not setting the ATH9K_RX_FILTER_PSPOLL
flag on older hardware and neither the documentation nor the reference
code mention any reason for excluding older hardware here.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/recv.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 87d96c5..cdcf60d 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -426,9 +426,7 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 	else
 		rfilt |= ATH9K_RX_FILTER_BEACON;
 
-	if ((AR_SREV_9280_20_OR_LATER(sc->sc_ah) ||
-	    AR_SREV_9285_12_OR_LATER(sc->sc_ah)) &&
-	    (sc->sc_ah->opmode == NL80211_IFTYPE_AP) &&
+	if ((sc->sc_ah->opmode == NL80211_IFTYPE_AP) ||
 	    (sc->rx.rxfilter & FIF_PSPOLL))
 		rfilt |= ATH9K_RX_FILTER_PSPOLL;
 
-- 
1.7.3.2

