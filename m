Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43949 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845AbXKWMQI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 07:16:08 -0500
Subject: [PATCH] b43: include FCS in frames handed to mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 23 Nov 2007 11:46:16 +0100
Message-Id: <1195814776.4149.90.camel@johannes.berg> (sfid-20071123_121611_904155_16D1D5F2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes it can be useful to see the FCS, especially when
bad-FCS frames are shown. Pass the FCS to mac80211 and let
it worry about snipping it off when required.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/b43/main.c |    3 ++-
 drivers/net/wireless/b43/xmit.c |    1 -
 2 files changed, 2 insertions(+), 2 deletions(-)

--- everything.orig/drivers/net/wireless/b43/main.c	2007-11-22 23:35:41.208716199 +0100
+++ everything/drivers/net/wireless/b43/main.c	2007-11-22 23:36:03.138677951 +0100
@@ -4158,7 +4158,8 @@ static int b43_wireless_init(struct ssb_
 	}
 
 	/* fill hw info */
-	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE;
+	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
+		    IEEE80211_HW_RX_INCLUDES_FCS;
 	hw->max_signal = 100;
 	hw->max_rssi = -110;
 	hw->max_noise = -110;
--- everything.orig/drivers/net/wireless/b43/xmit.c	2007-11-22 23:36:05.668676810 +0100
+++ everything/drivers/net/wireless/b43/xmit.c	2007-11-22 23:36:22.668677190 +0100
@@ -489,7 +489,6 @@ void b43_rx(struct b43_wldev *dev, struc
 	}
 	wlhdr = (struct ieee80211_hdr *)(skb->data);
 	fctl = le16_to_cpu(wlhdr->frame_control);
-	skb_trim(skb, skb->len - FCS_LEN);
 
 	if (macstat & B43_RX_MAC_DEC) {
 		unsigned int keyidx;


