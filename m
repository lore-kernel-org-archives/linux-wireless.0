Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f196.google.com ([209.85.216.196]:54972 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbZHUCao (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 22:30:44 -0400
Received: by pxi34 with SMTP id 34so3671365pxi.4
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2009 19:30:46 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>, andrey@cozybit.com,
	johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, Luis.Rodriguez@atheros.com,
	jouni.malinen@atheros.com
Subject: [PATCH] ath9k: Add support FIF_OTHER_BSS filtering mode.
Date: Thu, 20 Aug 2009 19:12:07 -0700
Message-Id: <1250820727-16729-1-git-send-email-javier@cozybit.com>
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Support for FIF_OTHER_BSS was missing.  This patch adds support for this
filtering mode which in turn resolves a problem where mesh interfaces would not
receive broadcast traffic.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 7b62c22..52e62da 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -423,11 +423,12 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 	if (sc->rx.rxfilter & FIF_PSPOLL)
 		rfilt |= ATH9K_RX_FILTER_PSPOLL;
 
-	if (sc->sec_wiphy) {
+	if (sc->sec_wiphy || (sc->rx.rxfilter & FIF_OTHER_BSS)) {
 		/* TODO: only needed if more than one BSSID is in use in
 		 * station/adhoc mode */
-		/* TODO: for older chips, may need to add ATH9K_RX_FILTER_PROM
-		 */
+		/* The following may also be needed for other older chips */
+		if (sc->sc_ah->hw_version.macVersion == AR_SREV_VERSION_9160)
+			rfilt |= ATH9K_RX_FILTER_PROM;
 		rfilt |= ATH9K_RX_FILTER_MCAST_BCAST_ALL;
 	}
 
-- 
1.5.4.3

