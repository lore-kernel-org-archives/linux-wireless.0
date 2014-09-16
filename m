Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:53120 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbaIPBtE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 21:49:04 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH] ath9k: Fix build error
Date: Tue, 16 Sep 2014 07:19:27 +0530
Message-Id: <1410832167-14829-1-git-send-email-sujith@msujith.org> (sfid-20140916_034908_799507_507F0F21)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This happens when CONFIG_ATH9K_CHANNEL_CONTEXT is
not enabled.

../drivers/net/wireless/ath/ath9k/recv.c: In function ‘ath_rx_ps_beacon’:
../drivers/net/wireless/ath/ath9k/recv.c:553:27: error: ‘struct ath_softc’ has no member named ‘offchannel’
    if (sc->cur_chan == &sc->offchannel.chan)
                           ^
../scripts/Makefile.build:257: recipe for target 'drivers/net/wireless/ath/ath9k/recv.o' failed
make[10]: *** [drivers/net/wireless/ath/ath9k/recv.o] Error 1
../scripts/Makefile.build:404: recipe for target 'drivers/net/wireless/ath/ath9k' failed
make[9]: *** [drivers/net/wireless/ath/ath9k] Error 2

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 0b53b74..51a9852 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -549,10 +549,12 @@ static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
 		ath_dbg(common, PS,
 			"Reconfigure beacon timers based on synchronized timestamp\n");
 
+#ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
 		if (ath9k_is_chanctx_enabled()) {
 			if (sc->cur_chan == &sc->offchannel.chan)
 				skip_beacon = true;
 		}
+#endif
 
 		if (!skip_beacon &&
 		    !(WARN_ON_ONCE(sc->cur_chan->beacon.beacon_interval == 0)))
-- 
2.1.0

