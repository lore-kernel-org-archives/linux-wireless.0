Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22983 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724Ab0DPG03 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 02:26:29 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 15 Apr 2010 23:26:29 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19400.748.861647.996982@gargle.gargle.HOWL>
Date: Fri, 16 Apr 2010 11:55:48 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 07/10] ath9k_htc: Remove GPIO set on unload
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no point in trying to set the LED pin
when the module is being unloaded. The target
would be reset anyway.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 08a4a58..2cea577 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -960,7 +960,6 @@ void ath9k_deinit_leds(struct ath9k_htc_priv *priv)
 	ath9k_unregister_led(&priv->tx_led);
 	ath9k_unregister_led(&priv->rx_led);
 	ath9k_unregister_led(&priv->radio_led);
-	ath9k_hw_set_gpio(priv->ah, priv->ah->led_pin, 1);
 }
 
 void ath9k_init_leds(struct ath9k_htc_priv *priv)
-- 
1.7.0.5

