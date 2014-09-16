Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:43392 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759493AbaIPANY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 20:13:24 -0400
Received: by mail-wg0-f47.google.com with SMTP id y10so4607318wgg.6
        for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2014 17:13:23 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCHv2 07/10] ath9k: enable control frame reception
Date: Tue, 16 Sep 2014 02:13:13 +0200
Message-Id: <1410826396-15544-8-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140916_021339_402512_4AAE62DE)
In-Reply-To: <1410826396-15544-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1410826396-15544-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set control frame bit in rx filter if dynack processing has been activated
in order to enable ACK frame reception

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 66c5fe8..42108f0 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -400,7 +400,8 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 	if (sc->sc_ah->is_monitoring)
 		rfilt |= ATH9K_RX_FILTER_PROM;
 
-	if (sc->cur_chan->rxfilter & FIF_CONTROL)
+	if ((sc->cur_chan->rxfilter & FIF_CONTROL) ||
+	    sc->sc_ah->dynack.enabled)
 		rfilt |= ATH9K_RX_FILTER_CONTROL;
 
 	if ((sc->sc_ah->opmode == NL80211_IFTYPE_STATION) &&
-- 
1.9.1

