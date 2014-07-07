Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:44654 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaGGJbz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2014 05:31:55 -0400
Received: by mail-wg0-f42.google.com with SMTP id n12so2265120wgh.13
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jul 2014 02:31:54 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: ath9k-devel@lists.ath9k.org
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 07/10] ath9k: enable control frame reception
Date: Mon,  7 Jul 2014 11:31:43 +0200
Message-Id: <1404725506-9571-8-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140707_113212_821307_A051609F)
In-Reply-To: <1404725506-9571-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1404725506-9571-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable control frame reception if dynamic ack processing is enabled

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index ad317a4..5d02467 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -398,7 +398,7 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 	if (sc->sc_ah->is_monitoring)
 		rfilt |= ATH9K_RX_FILTER_PROM;
 
-	if (sc->rx.rxfilter & FIF_CONTROL)
+	if ((sc->rx.rxfilter & FIF_CONTROL) || !sc->sc_ah->dynack.fix_to)
 		rfilt |= ATH9K_RX_FILTER_CONTROL;
 
 	if ((sc->sc_ah->opmode == NL80211_IFTYPE_STATION) &&
-- 
1.9.1

