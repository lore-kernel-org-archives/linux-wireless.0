Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:38084
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364AbXH3R20 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 13:28:26 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43 drivers: remove IEEE80211_CONF_SSID_HIDDEN
Date: Thu, 30 Aug 2007 19:26:32 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev <bcm43xx-dev@lists.berlios.de>,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200708301926.32594.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

The IEEE80211_CONF_SSID_HIDDEN setting is unclear but does not
match the "closed net" flag b43 hardware has; the flag influences
only the sending of probe responses which is disabled anyway.
>From looking at the microcode, I can see that if the flag is set
then probe requests are required to be directed to the BSSID of
the AP to be answered by the microcode, but this not interesting
because we don't support probe request offload anyway.

This patch removes the IEEE80211_CONF_SSID_HIDDEN use from
both b43 drivers.

Cc: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <larry.finger@lwfinger.net>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

---
I've also clarified the specs, please queue the change to your
respective drivers.

 drivers/net/wireless/b43/main.c       |   11 -----------
 drivers/net/wireless/b43legacy/main.c |   12 ------------
 2 files changed, 23 deletions(-)

--- wireless-dev.orig/drivers/net/wireless/b43/main.c	2007-08-30 14:35:57.512051253 +0200
+++ wireless-dev/drivers/net/wireless/b43/main.c	2007-08-30 14:36:01.002051253 +0200
@@ -2836,17 +2836,6 @@ static int b43_dev_config(struct ieee802
 		}
 	}
 
-	/* Hide/Show the SSID (AP mode only). */
-	if (conf->flags & IEEE80211_CONF_SSID_HIDDEN) {
-		b43_write32(dev, B43_MMIO_MACCTL,
-			    b43_read32(dev, B43_MMIO_MACCTL)
-			    | B43_MACCTL_CLOSEDNET);
-	} else {
-		b43_write32(dev, B43_MMIO_MACCTL,
-			    b43_read32(dev, B43_MMIO_MACCTL)
-			    & ~B43_MACCTL_CLOSEDNET);
-	}
-
 	/* Antennas for RX and management frame TX. */
 	b43_mgmtframe_txantenna(dev, antenna_tx);
 	b43_set_rx_antenna(dev, antenna_rx);
--- wireless-dev.orig/drivers/net/wireless/b43legacy/main.c	2007-08-30 14:35:05.962051253 +0200
+++ wireless-dev/drivers/net/wireless/b43legacy/main.c	2007-08-30 14:36:01.022051253 +0200
@@ -2655,18 +2655,6 @@ static int b43legacy_dev_config(struct i
 		}
 	}
 
-	/* Hide/Show the SSID (AP mode only). */
-	if (conf->flags & IEEE80211_CONF_SSID_HIDDEN)
-		b43legacy_write32(dev, B43legacy_MMIO_STATUS_BITFIELD,
-				  b43legacy_read32(dev,
-				  B43legacy_MMIO_STATUS_BITFIELD)
-				  | B43legacy_SBF_NO_SSID_BCAST);
-	else
-		b43legacy_write32(dev, B43legacy_MMIO_STATUS_BITFIELD,
-				  b43legacy_read32(dev,
-				  B43legacy_MMIO_STATUS_BITFIELD)
-				  & ~B43legacy_SBF_NO_SSID_BCAST);
-
 	/* Antennas for RX and management frame TX. */
 	b43legacy_mgmtframe_txantenna(dev, antenna_tx);
 

-- 
Greetings Michael.
