Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56499 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab0ISQzC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Sep 2010 12:55:02 -0400
Received: by fxm3 with SMTP id 3so295970fxm.19
        for <linux-wireless@vger.kernel.org>; Sun, 19 Sep 2010 09:55:01 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH 1/2] wl1271: avoid redundant memcpy of rx_status
Date: Sun, 19 Sep 2010 18:55:08 +0200
Message-Id: <1284915309-999-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

copy the rx_status directly to skb->cb (control buffer) instead of copying
it to a local struct and then copying it again (for each rx packet)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/wl1271_rx.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_rx.c b/drivers/net/wireless/wl12xx/wl1271_rx.c
index 019aa79..94da5dd 100644
--- a/drivers/net/wireless/wl12xx/wl1271_rx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_rx.c
@@ -76,7 +76,6 @@ static void wl1271_rx_status(struct wl1271 *wl,
 
 static void wl1271_rx_handle_data(struct wl1271 *wl, u32 length)
 {
-	struct ieee80211_rx_status rx_status;
 	struct wl1271_rx_descriptor *desc;
 	struct sk_buff *skb;
 	u16 *fc;
@@ -109,14 +108,13 @@ static void wl1271_rx_handle_data(struct wl1271 *wl, u32 length)
 	if ((*fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_BEACON)
 		beacon = 1;
 
-	wl1271_rx_status(wl, desc, &rx_status, beacon);
+	wl1271_rx_status(wl, desc, IEEE80211_SKB_RXCB(skb), beacon);
 
 	wl1271_debug(DEBUG_RX, "rx skb 0x%p: %d B %s", skb, skb->len,
 		     beacon ? "beacon" : "");
 
 	skb_trim(skb, skb->len - desc->pad_len);
 
-	memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
 	ieee80211_rx_ni(wl->hw, skb);
 }
 
-- 
1.7.0.4

