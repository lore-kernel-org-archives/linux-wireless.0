Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62696 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab1FSGFF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2011 02:05:05 -0400
Received: by mail-wy0-f174.google.com with SMTP id 38so1034760wyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 18 Jun 2011 23:05:04 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 3/3] wl12xx: use 802.11 header location after relocation to frame start
Date: Sun, 19 Jun 2011 09:04:56 +0300
Message-Id: <1308463496-15522-3-git-send-email-arik@wizery.com> (sfid-20110619_080520_820544_DC513354)
In-Reply-To: <1308463496-15522-1-git-send-email-arik@wizery.com>
References: <1308463496-15522-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When operating with TKIP encryption, the function wl1271_tx_fill_hdr()
relocates the 802.11 header to the start of the frame, and leaves room
for the security header.

Some functions in the Tx path rely on the location of the header,
namely, for purposes of roaming in STA mode and connecting new stations
in AP mode. Call these functions only after the header is relocated.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/tx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 6dab9c9..39f4292 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -383,6 +383,8 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
 	if (ret < 0)
 		return ret;
 
+	wl1271_tx_fill_hdr(wl, skb, extra, info, hlid);
+
 	if (wl->bss_type == BSS_TYPE_AP_BSS) {
 		wl1271_tx_ap_update_inconnection_sta(wl, skb);
 		wl1271_tx_regulate_link(wl, hlid);
@@ -390,8 +392,6 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
 		wl1271_tx_update_filters(wl, skb);
 	}
 
-	wl1271_tx_fill_hdr(wl, skb, extra, info, hlid);
-
 	/*
 	 * The length of each packet is stored in terms of
 	 * words. Thus, we must pad the skb data to make sure its
-- 
1.7.4.1

