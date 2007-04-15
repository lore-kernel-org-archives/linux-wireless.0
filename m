Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-01.rdc-kc.rr.com ([24.94.166.115]:51321 "EHLO
	ms-smtp-01.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbXDOEVn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Apr 2007 00:21:43 -0400
Date: Sat, 14 Apr 2007 23:22:46 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: [PATCH] bcm43xx-mac80211: Make wireless statistics yield  reasonable values
Message-ID: <4621a896.akSEX43I3VgRXr70%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The variables in mac80211 are confusing and should be renamed; however, that may take
some time to reach a consensus. In the meantime, these changes are needed to get
reasonable numbers from bcm43xx-mac80211.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is wireless-dev material. The extensive renaming patches
that were submitted on 4/14 should be discarded.

Larry

 bcm43xx_main.c |    4 ++--
 bcm43xx_xmit.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

Index: wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_xmit.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_xmit.c
+++ wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_xmit.c
@@ -525,12 +525,12 @@ void bcm43xx_rx(struct bcm43xx_wldev *de
 		}
 	}
 
-	status.signal = bcm43xx_rssi_postprocess(dev, jssi,
+	status.ssi = bcm43xx_rssi_postprocess(dev, jssi,
 					      (phystat0 & BCM43xx_RX_PHYST0_OFDM),
 					      (phystat0 & BCM43xx_RX_PHYST0_GAINCTL),
 					      (phystat3 & BCM43xx_RX_PHYST3_TRSTATE));
 	status.noise = dev->stats.link_noise;
-	status.ssi = jssi;
+	status.signal = jssi; /* this looks wrong, but is what mac80211 wants */
 	if (phystat0 & BCM43xx_RX_PHYST0_OFDM)
 		status.rate = bcm43xx_plcp_get_bitrate_ofdm(plcp);
 	else
Index: wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c
+++ wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c
@@ -3757,8 +3757,8 @@ static int bcm43xx_wireless_init(struct 
 		    IEEE80211_HW_MONITOR_DURING_OPER |
 		    IEEE80211_HW_DEVICE_HIDES_WEP |
 		    IEEE80211_HW_WEP_INCLUDE_IV;
-	hw->max_rssi = -110;
-	hw->max_signal = BCM43xx_RX_MAX_SSI;
+	hw->max_signal = 100; /* This looks wrong, but is what mac80211 wants */
+	hw->max_rssi = BCM43xx_RX_MAX_SSI;
 	hw->max_noise = -110;
 	hw->queues = 1;
 	SET_IEEE80211_DEV(hw, dev->dev);
