Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-02.rdc-kc.rr.com ([24.94.166.122]:59369 "EHLO
	ms-smtp-02.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762951AbXFAVRQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2007 17:17:16 -0400
Date: Fri, 01 Jun 2007 16:16:35 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH V2] bcm43xx-mac80211: Make wireless statistics yield  reasonable values
Message-ID: <46608cb3.kcEmWfiAoSA+svnR%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The changes contained herein are needed to get reasonable numbers for wireless
statistics in bcm43xx-mac80211.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 bcm43xx_main.c |    4 ++--
 bcm43xx_xmit.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

Index: wireless-mb/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_xmit.c
===================================================================
--- wireless-mb.orig/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_xmit.c
+++ wireless-mb/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_xmit.c
@@ -517,12 +517,12 @@ void bcm43xx_rx(struct bcm43xx_wldev *de
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
Index: wireless-mb/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c
===================================================================
--- wireless-mb.orig/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c
+++ wireless-mb/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c
@@ -3799,8 +3799,8 @@ static int bcm43xx_wireless_init(struct 
 		    IEEE80211_HW_MONITOR_DURING_OPER |
 		    IEEE80211_HW_DEVICE_HIDES_WEP |
 		    IEEE80211_HW_WEP_INCLUDE_IV;
-	hw->max_signal = -110;
-	hw->max_rssi = BCM43xx_RX_MAX_SSI;
+	hw->max_signal = 100;
+	hw->max_rssi = -110;
 	hw->max_noise = -110;
 	hw->queues = 1;
 	SET_IEEE80211_DEV(hw, dev->dev);
