Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42421 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014AbXHXLBC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2007 07:01:02 -0400
Subject: [PATCH] b43: include FCS at end of frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev <bcm43xx-dev@lists.berlios.de>
Content-Type: text/plain
Date: Fri, 24 Aug 2007 13:01:50 +0200
Message-Id: <1187953310.24933.19.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes b43 include the FCS at the end of
received frames, useful for monitoring.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 drivers/net/wireless/b43/main.c |    3 ++-
 drivers/net/wireless/b43/xmit.c |    1 -
 2 files changed, 2 insertions(+), 2 deletions(-)

--- wireless-dev.orig/drivers/net/wireless/b43/main.c	2007-08-24 12:57:04.949420431 +0200
+++ wireless-dev/drivers/net/wireless/b43/main.c	2007-08-24 13:00:08.989420431 +0200
@@ -3934,7 +3934,8 @@ static int b43_wireless_init(struct ssb_
 	}
 
 	/* fill hw info */
-	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE;
+	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
+		    IEEE80211_HW_RX_INCLUDES_FCS;
 	hw->max_signal = 100;
 	hw->max_rssi = -110;
 	hw->max_noise = -110;
--- wireless-dev.orig/drivers/net/wireless/b43/xmit.c	2007-08-24 12:57:04.959420431 +0200
+++ wireless-dev/drivers/net/wireless/b43/xmit.c	2007-08-24 13:00:08.999420431 +0200
@@ -481,7 +481,6 @@ void b43_rx(struct b43_wldev *dev, struc
 	}
 	wlhdr = (struct ieee80211_hdr *)(skb->data);
 	fctl = le16_to_cpu(wlhdr->frame_control);
-	skb_trim(skb, skb->len - FCS_LEN);
 
 	if ((macstat & B43_RX_MAC_DEC) && !(macstat & B43_RX_MAC_DECERR)) {
 		unsigned int keyidx;


