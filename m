Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-01.rdc-kc.rr.com ([24.94.166.115]:50578 "EHLO
	ms-smtp-01.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbXHEGXp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2007 02:23:45 -0400
Date: Sun, 05 Aug 2007 01:23:36 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] bcm43xx-mac80211: Rescale link quality output
Message-ID: <46b56ce8.MTc7K0Zquczk+/6h%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The link quality output from wireless extensions is too small by the ratio
of 100/BCM43xx_RX_MAX_SSI (60) for bcm43xx-mac80211. This patch puts the
quantity on the proper scale.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_xmit.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_xmit.c
+++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_xmit.c
@@ -537,7 +537,8 @@ void bcm43xx_rx(struct bcm43xx_wldev *de
 					      (phystat0 & BCM43xx_RX_PHYST0_GAINCTL),
 					      (phystat3 & BCM43xx_RX_PHYST3_TRSTATE));
 	status.noise = dev->stats.link_noise;
-	status.signal = jssi; /* this looks wrong, but is what mac80211 wants */
+	/* the next line looks wrong, but is what mac80211 wants */
+	status.signal = jssi * 100 / BCM43xx_RX_MAX_SSI;
 	if (phystat0 & BCM43xx_RX_PHYST0_OFDM)
 		status.rate = bcm43xx_plcp_get_bitrate_ofdm(plcp);
 	else
