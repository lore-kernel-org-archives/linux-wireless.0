Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36005 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab1FZHgN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jun 2011 03:36:13 -0400
Received: by mail-ww0-f44.google.com with SMTP id 5so3924480wwe.1
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jun 2011 00:36:12 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2 3/3] wl12xx: use 802.11 header location after relocation to frame start
Date: Sun, 26 Jun 2011 10:36:04 +0300
Message-Id: <1309073764-24219-3-git-send-email-arik@wizery.com> (sfid-20110626_093618_375552_677248DE)
In-Reply-To: <1309073764-24219-1-git-send-email-arik@wizery.com>
References: <1309073764-24219-1-git-send-email-arik@wizery.com>
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
index f3d79c8..0de04da 100644
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

