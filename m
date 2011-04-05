Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46883 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab1DEPVf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 11:21:35 -0400
Received: by wwa36 with SMTP id 36so591244wwa.1
        for <linux-wireless@vger.kernel.org>; Tue, 05 Apr 2011 08:21:34 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: print actual rx packet size (without padding)
Date: Tue,  5 Apr 2011 18:21:31 +0300
Message-Id: <1302016891-19091-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When debugging, reduce the padding size from each rx packet, to
get the actual packet size (so comparing it against a cap file
will be easier)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/rx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
index 2a58149..faf5a1d 100644
--- a/drivers/net/wireless/wl12xx/rx.c
+++ b/drivers/net/wireless/wl12xx/rx.c
@@ -121,7 +121,8 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length)
 
 	wl1271_rx_status(wl, desc, IEEE80211_SKB_RXCB(skb), beacon);
 
-	wl1271_debug(DEBUG_RX, "rx skb 0x%p: %d B %s", skb, skb->len,
+	wl1271_debug(DEBUG_RX, "rx skb 0x%p: %d B %s", skb,
+		     skb->len - desc->pad_len,
 		     beacon ? "beacon" : "");
 
 	skb_trim(skb, skb->len - desc->pad_len);
-- 
1.7.0.4

