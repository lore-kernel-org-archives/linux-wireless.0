Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53039 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932860AbZJ3Sfl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 14:35:41 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: luciano.coelho@nokia.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC] wl1271: use __dev_alloc_skb() on RX
Date: Fri, 30 Oct 2009 14:35:46 -0400
Message-Id: <1256927746-19352-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RX is handled in a workqueue therefore allocating for GFP_ATOMIC
is overkill and not required.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

--- 

This goes untested and not even compile tested but just thought this was odd.

diff --git a/drivers/net/wireless/wl12xx/wl1271_rx.c b/drivers/net/wireless/wl12xx/wl1271_rx.c
index 37d81ab..ca645f3 100644
--- a/drivers/net/wireless/wl12xx/wl1271_rx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_rx.c
@@ -159,7 +159,7 @@ static void wl1271_rx_handle_data(struct wl1271 *wl, u32 length)
 	u8 *buf;
 	u8 beacon = 0;
 
-	skb = dev_alloc_skb(length);
+	skb = __dev_alloc_skb(length, GFP_KERNEL);
 	if (!skb) {
 		wl1271_error("Couldn't allocate RX frame");
 		return;
