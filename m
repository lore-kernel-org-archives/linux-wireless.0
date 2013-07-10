Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:53660 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247Ab3GJGkR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jul 2013 02:40:17 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 1/2] ath9k_htc: do some initial hardware configuration
Date: Wed, 10 Jul 2013 08:40:03 +0200
Message-Id: <1373438404-5871-1-git-send-email-linux@rempel-privat.de> (sfid-20130710_084021_990963_BCDC59D3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently we configure harwdare and clock, only after
interface start. In this case, if we reload module or
reboot PC without configuring adapter, firmware will freeze.
There is no software way to reset adpter.

This patch add initial configuration and set it in
disabled state, to avoid this freeze. Behaviour of this patch
should be similar to: ifconfig wlan0 up; ifconfig wlan0 down.

Bug: https://github.com/qca/open-ath9k-htc-firmware/issues/1
Tested-by: Bo Shi <cnshibo@gmail.com>
Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 71a183f..c3676bf 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -861,6 +861,7 @@ static int ath9k_init_device(struct ath9k_htc_priv *priv,
 	if (error != 0)
 		goto err_rx;
 
+	ath9k_hw_disable(priv->ah);
 #ifdef CONFIG_MAC80211_LEDS
 	/* must be initialized before ieee80211_register_hw */
 	priv->led_cdev.default_trigger = ieee80211_create_tpt_led_trigger(priv->hw,
-- 
1.8.1.2

