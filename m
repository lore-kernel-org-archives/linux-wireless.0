Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:48137
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbXKXOH7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2007 09:07:59 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: include FCS in frames handed to mac80211
Date: Sat, 24 Nov 2007 15:06:33 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200711241506.33414.mb@bu3sch.de> (sfid-20071124_140809_178297_2ADBBD97)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

Sometimes it can be useful to see the FCS, especially when
bad-FCS frames are shown. Pass the FCS to mac80211 and let
it worry about snipping it off when required.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

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




-------------------------------------------------------

-- 
Greetings Michael.
