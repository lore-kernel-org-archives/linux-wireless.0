Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49520 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbZKBRPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 12:15:13 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: luciano.coelho@nokia.com, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] wl1271: use __dev_alloc_skb() on RX
Date: Mon,  2 Nov 2009 12:15:15 -0500
Message-Id: <1257182115-31723-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RX is handled in a workqueue therefore allocating for GFP_ATOMIC
is overkill and not required.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Acked-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_rx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
-- 
1.6.0.4

