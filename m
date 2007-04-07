Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-03.rdc-kc.rr.com ([24.94.166.129]:46243 "EHLO
	ms-smtp-03.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966217AbXDGSC2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Apr 2007 14:02:28 -0400
Date: Sat, 07 Apr 2007 13:00:05 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: [PATCH] bcm43xx-mac80211: Fix error in initiallizing max RSSI and max signal
Message-ID: <4617dc25.vXqEEvwca/gaq2Cw%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In bcm43xx-mac80211, the max_rssi and max_signal values sent to mac80211 are reversed.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is wireless-dev material.

Michael,

It can also be applied to the mb tree.

Larry

 bcm43xx_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c
+++ wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c
@@ -3760,8 +3760,8 @@ static int bcm43xx_wireless_init(struct 
 		    IEEE80211_HW_MONITOR_DURING_OPER |
 		    IEEE80211_HW_DEVICE_HIDES_WEP |
 		    IEEE80211_HW_WEP_INCLUDE_IV;
-	hw->max_rssi = -110;
-	hw->max_signal = BCM43xx_RX_MAX_SSI;
+	hw->max_signal = -110;
+	hw->max_rssi = BCM43xx_RX_MAX_SSI;
 	hw->max_noise = -110;
 	hw->queues = 1;
 	SET_IEEE80211_DEV(hw, dev->dev);
