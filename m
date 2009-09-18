Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:44857 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756037AbZIRJgC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2009 05:36:02 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2009 02:36:06 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19123.21639.405779.433713@gargle.gargle.HOWL>
Date: Fri, 18 Sep 2009 15:06:07 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 5/9] ath9k: Allow PSPOLL only when the interface is configured in AP mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Senthil Balasubramanian <senthilkumar@atheros.com>

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 3a2204d..c880a55 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -423,7 +423,10 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 	else
 		rfilt |= ATH9K_RX_FILTER_BEACON;
 
-	if (sc->rx.rxfilter & FIF_PSPOLL)
+	if ((AR_SREV_9280_10_OR_LATER(sc->sc_ah) ||
+	    AR_SREV_9285_10_OR_LATER(sc->sc_ah)) &&
+	    (sc->sc_ah->opmode == NL80211_IFTYPE_AP) &&
+	    (sc->rx.rxfilter & FIF_PSPOLL))
 		rfilt |= ATH9K_RX_FILTER_PSPOLL;
 
 	if (conf_is_ht(&sc->hw->conf))
-- 
1.6.4.4

