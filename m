Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:33258 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbZH0VAc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 17:00:32 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, juuso.oikarinen@nokia.com,
	kalle.valo@nokia.com
Subject: [PATCH 04/13] wl1271: Correct TKIP header space handling in TX path
Date: Thu, 27 Aug 2009 23:59:58 +0300
Message-Id: <1251406807-31495-5-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1251406807-31495-1-git-send-email-luciano.coelho@nokia.com>
References: <1251406807-31495-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Correct the position to which TKIP header space is appended for TX
packets.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Vidhya Govindan <vidhya.govindan@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    9 +++------
 drivers/net/wireless/wl12xx/wl1271_tx.c   |   27 +++++++++++++++++----------
 2 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 7faa65f..4fb6138 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1161,12 +1161,9 @@ static int wl1271_register_hw(struct wl1271 *wl)
 
 static int wl1271_init_ieee80211(struct wl1271 *wl)
 {
-	/*
-	 * The tx descriptor buffer and the TKIP space.
-	 *
-	 * FIXME: add correct 1271 descriptor size
-	 */
-	wl->hw->extra_tx_headroom = WL1271_TKIP_IV_SPACE;
+	/* The tx descriptor buffer and the TKIP space. */
+	wl->hw->extra_tx_headroom = WL1271_TKIP_IV_SPACE +
+		sizeof(struct wl1271_tx_hw_descr);
 
 	/* unit us */
 	/* FIXME: find a proper value */
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
index 162f026..1ad1bc3 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
@@ -92,6 +92,14 @@ static int wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 
 	desc = (struct wl1271_tx_hw_descr *) skb->data;
 
+	/* relocate space for security header */
+	if (extra) {
+		void *framestart = skb->data + sizeof(*desc);
+		u16 fc = *(u16 *)(framestart + extra);
+		int hdrlen = ieee80211_hdrlen(fc);
+		memmove(framestart, framestart + extra, hdrlen);
+	}
+
 	/* configure packet life time */
 	desc->start_time = jiffies_to_usecs(jiffies) - wl->time_offset;
 	desc->life_time = TX_HW_MGMT_PKT_LIFETIME_TU;
@@ -257,7 +265,6 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 
 	struct ieee80211_tx_info *info;
 	struct sk_buff *skb;
-	u32 header_len;
 	u16 seq;
 	int id = result->id;
 
@@ -295,22 +302,22 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 		wl->tx_security_seq_32++;
 	wl->tx_security_seq_16 = seq;
 
-	/* get header len */
+	/* remove private header from packet */
+	skb_pull(skb, sizeof(struct wl1271_tx_hw_descr));
+
+	/* remove TKIP header space if present */
 	if (info->control.hw_key &&
-	    info->control.hw_key->alg == ALG_TKIP)
-		header_len = WL1271_TKIP_IV_SPACE +
-			sizeof(struct wl1271_tx_hw_descr);
-	else
-		header_len = sizeof(struct wl1271_tx_hw_descr);
+	    info->control.hw_key->alg == ALG_TKIP) {
+		int hdrlen = ieee80211_get_hdrlen_from_skb(skb);
+		memmove(skb->data + WL1271_TKIP_IV_SPACE, skb->data, hdrlen);
+		skb_pull(skb, WL1271_TKIP_IV_SPACE);
+	}
 
 	wl1271_debug(DEBUG_TX, "tx status id %u skb 0x%p failures %u rate 0x%x"
 		     " status 0x%x",
 		     result->id, skb, result->ack_failures,
 		     result->rate_class_index, result->status);
 
-	/* remove private header from packet */
-	skb_pull(skb, header_len);
-
 	/* return the packet to the stack */
 	ieee80211_tx_status(wl->hw, skb);
 	wl->tx_frames[result->id] = NULL;
-- 
1.5.6.5

