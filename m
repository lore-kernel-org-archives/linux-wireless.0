Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-02.rdc-kc.rr.com ([24.94.166.122]:60657 "EHLO
	ms-smtp-02.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759651AbXEZRKB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2007 13:10:01 -0400
Date: Sat, 26 May 2007 12:09:34 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] bcm43xx-mac80211: Fix for tx_bias equal to 0xFF
Message-ID: <465869ce.8wcEX9q9ZmHxX2m3%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Index: wireless-mb/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_phy.c
===================================================================
--- wireless-mb.orig/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_phy.c
+++ wireless-mb/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_phy.c
@@ -4122,6 +4122,10 @@ void bcm43xx_radio_set_txpower_bg(struct
 	tx_magn = _tx_magn;
 	phy->bbatt = baseband_attenuation;
 	phy->rfatt = radio_attenuation;
+	if (tx_bias == 0xFF) {
+		bcm43xx_lo_g_measure(dev);
+		tx_bias = phy->lo_control->tx_bias;
+	}
 
 	/* Set Baseband Attenuation on device. */
 	bcm43xx_phy_set_baseband_attenuation(dev, baseband_attenuation);
