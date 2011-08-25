Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41492 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab1HYPJq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:46 -0400
Received: by wwf5 with SMTP id 5so2488371wwf.1
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 08:09:45 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/4] wl12xx: print the seq_num of rx packet
Date: Thu, 25 Aug 2011 18:10:58 +0300
Message-Id: <1314285060-5088-2-git-send-email-eliad@wizery.com> (sfid-20110825_172050_289242_AF44F4DA)
In-Reply-To: <1314285060-5088-1-git-send-email-eliad@wizery.com>
References: <1314285060-5088-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make it easier to match the driver log against
a sniffer log.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/rx.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
index 78d8410..9074625 100644
--- a/drivers/net/wireless/wl12xx/rx.c
+++ b/drivers/net/wireless/wl12xx/rx.c
@@ -107,6 +107,7 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length,
 	u8 beacon = 0;
 	u8 is_data = 0;
 	u8 reserved = unaligned ? NET_IP_ALIGN : 0;
+	u16 seq_num;
 
 	/*
 	 * In PLT mode we seem to get frames and mac80211 warns about them,
@@ -169,9 +170,11 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length,
 
 	wl1271_rx_status(wl, desc, IEEE80211_SKB_RXCB(skb), beacon);
 
-	wl1271_debug(DEBUG_RX, "rx skb 0x%p: %d B %s", skb,
+	seq_num = (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_SEQ) >> 4;
+	wl1271_debug(DEBUG_RX, "rx skb 0x%p: %d B %s seq %d", skb,
 		     skb->len - desc->pad_len,
-		     beacon ? "beacon" : "");
+		     beacon ? "beacon" : "",
+		     seq_num);
 
 	skb_trim(skb, skb->len - desc->pad_len);
 
-- 
1.7.6.401.g6a319

