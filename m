Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59232 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754962AbXH3NEe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 09:04:34 -0400
Subject: [PATCH] b43 drivers: remove IEEE80211_CONF_SSID_HIDDEN
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev <bcm43xx-dev@lists.berlios.de>
Content-Type: text/plain
Date: Thu, 30 Aug 2007 15:05:44 +0200
Message-Id: <1188479144.2963.30.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
 


