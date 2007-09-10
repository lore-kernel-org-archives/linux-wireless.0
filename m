Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-01.rdc-kc.rr.com ([24.94.166.115]:38916 "EHLO
	ms-smtp-01.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760211AbXIJPp0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2007 11:45:26 -0400
Date: Mon, 10 Sep 2007 10:45:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43legacy: remove IEEE80211_CONF_SSID_HIDDEN
Message-ID: <46e5667d.rxqXAWDZOvc/hIty%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
b43legacy.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Larry Finger <larry.finger@lwfinger.net>
---

John,

I don't know if this patch made it to your inbox. If not,
please apply this one.

Larry


 drivers/net/wireless/b43legacy/main.c |   12 ------------
 1 file changed, 12 deletions(-)

Index: wireless-dev/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-dev/drivers/net/wireless/b43legacy/main.c
@@ -2650,18 +2650,6 @@ static int b43legacy_dev_config(struct i
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
 
