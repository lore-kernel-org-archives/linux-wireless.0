Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:50839 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbZH0VAV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 17:00:21 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, juuso.oikarinen@nokia.com,
	kalle.valo@nokia.com
Subject: [PATCH 02/13] wl1271: Correction to TX block allocation calculation
Date: Thu, 27 Aug 2009 23:59:56 +0300
Message-Id: <1251406807-31495-3-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1251406807-31495-1-git-send-email-luciano.coelho@nokia.com>
References: <1251406807-31495-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Correct the TX path implementation to allocate sufficient blocks in the
firmware for TX packets.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Kalle Valo <kalle.valo@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
index ff22125..0c19688 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
@@ -58,7 +58,7 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra)
 	/* approximate the number of blocks required for this packet
 	   in the firmware */
 	/* FIXME: try to figure out what is done here and make it cleaner */
-	total_blocks = (skb->len) >> TX_HW_BLOCK_SHIFT_DIV;
+	total_blocks = (total_len) >> TX_HW_BLOCK_SHIFT_DIV;
 	excluded = (total_blocks << 2) + (skb->len & 0xff) + 34;
 	total_blocks += (excluded > 252) ? 2 : 1;
 	total_blocks += TX_HW_BLOCK_SPARE;
-- 
1.5.6.5

