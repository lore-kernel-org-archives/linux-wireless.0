Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:35457 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754943AbZCCRZW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2009 12:25:22 -0500
Message-Id: <20090303172515.987598674@atheros.com> (sfid-20090303_182527_491250_B3C2233C)
References: <20090303172325.437810138@atheros.com>
Date: Tue, 03 Mar 2009 19:23:34 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 09/15] ath9k: Register larger listen interval
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Notify the AP that we may be sleeping longer to allow the AP power
save code to buffer larger number of frames for us when using virtual
wiphys.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath9k/main.c |    1 +
 1 file changed, 1 insertion(+)

--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c	2009-03-03 18:31:30.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/main.c	2009-03-03 18:31:43.000000000 +0200
@@ -1595,6 +1595,7 @@ void ath_set_hw_capab(struct ath_softc *
 	hw->queues = 4;
 	hw->max_rates = 4;
 	hw->channel_change_time = 5000;
+	hw->max_listen_interval = 10;
 	hw->max_rate_tries = ATH_11N_TXMAXTRY;
 	hw->sta_data_size = sizeof(struct ath_node);
 	hw->vif_data_size = sizeof(struct ath_vif);

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
