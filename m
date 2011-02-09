Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42986 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab1BIKY4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 05:24:56 -0500
Received: by wwa36 with SMTP id 36so6407wwa.1
        for <linux-wireless@vger.kernel.org>; Wed, 09 Feb 2011 02:24:55 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: fix identification of beacon packets (debug)
Date: Wed,  9 Feb 2011 12:25:14 +0200
Message-Id: <1297247114-4563-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

for debugging purposes, wl12xx determines whether a rx packet
is a beacon packet.

however, it checks only the frame_control subtype without checking
the actual packet type, which leads to false identification in some
cases.

use ieee80211_is_beacon instead.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/rx.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
index 029597b..1e3616a 100644
--- a/drivers/net/wireless/wl12xx/rx.c
+++ b/drivers/net/wireless/wl12xx/rx.c
@@ -92,7 +92,7 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length)
 {
 	struct wl1271_rx_descriptor *desc;
 	struct sk_buff *skb;
-	u16 *fc;
+	struct ieee80211_hdr *hdr;
 	u8 *buf;
 	u8 beacon = 0;
 
@@ -118,8 +118,8 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length)
 	/* now we pull the descriptor out of the buffer */
 	skb_pull(skb, sizeof(*desc));
 
-	fc = (u16 *)skb->data;
-	if ((*fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_BEACON)
+	hdr = (struct ieee80211_hdr *)skb->data;
+	if (ieee80211_is_beacon(hdr->frame_control))
 		beacon = 1;
 
 	wl1271_rx_status(wl, desc, IEEE80211_SKB_RXCB(skb), beacon);
-- 
1.7.0.4

