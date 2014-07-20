Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:46637 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbaGTMbg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 08:31:36 -0400
Received: by mail-wg0-f41.google.com with SMTP id z12so5252553wgg.12
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 05:31:35 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	Philippe Duchein <wireless-dev@duchein.net>
Subject: [PATCH 07/10] ath9k: enable control frame reception
Date: Sun, 20 Jul 2014 14:31:23 +0200
Message-Id: <1405859486-31414-8-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140720_143141_580896_94789CF5)
In-Reply-To: <1405859486-31414-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1405859486-31414-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable control frame reception if dynamic ack processing is enabled

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index ad317a4..cc5ba4a 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -398,7 +398,7 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 	if (sc->sc_ah->is_monitoring)
 		rfilt |= ATH9K_RX_FILTER_PROM;
 
-	if (sc->rx.rxfilter & FIF_CONTROL)
+	if ((sc->rx.rxfilter & FIF_CONTROL) || sc->sc_ah->dynack.enabled)
 		rfilt |= ATH9K_RX_FILTER_CONTROL;
 
 	if ((sc->sc_ah->opmode == NL80211_IFTYPE_STATION) &&
-- 
1.9.1

