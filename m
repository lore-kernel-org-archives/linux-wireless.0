Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:19340 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbZBDCnz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 21:43:55 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2009 18:43:55 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18825.22.219944.79088@gargle.gargle.HOWL> (sfid-20090204_034414_032053_DF2BDA60)
Date: Wed, 4 Feb 2009 08:10:22 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 3/4] ath9k: Handle mac80211's FIF_CONTROL flag properly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/recv.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 8da08f9..630fa57 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -372,6 +372,9 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 		rfilt &= ~ATH9K_RX_FILTER_UCAST;
 	}
 
+	if (sc->rx.rxfilter & FIF_CONTROL)
+		rfilt |= ATH9K_RX_FILTER_CONTROL;
+
 	if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_STATION ||
 	    sc->sc_ah->ah_opmode == NL80211_IFTYPE_ADHOC)
 		rfilt |= ATH9K_RX_FILTER_BEACON;
-- 
1.6.1

