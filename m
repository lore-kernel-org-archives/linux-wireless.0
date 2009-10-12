Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:64656 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590AbZJLMLF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 08:11:05 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 12/16] wl1271: Update TX path block calucation algo
Date: Mon, 12 Oct 2009 15:08:53 +0300
Message-Id: <1255349337-9776-13-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255349337-9776-1-git-send-email-luciano.coelho@nokia.com>
References: <1255349337-9776-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Update the TX path block calculation algorithm based on TI reference.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_tx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
index 5d3aa4b..56a7f36 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
@@ -57,8 +57,8 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra)
 	/* approximate the number of blocks required for this packet
 	   in the firmware */
 	/* FIXME: try to figure out what is done here and make it cleaner */
-	total_blocks = (total_len) >> TX_HW_BLOCK_SHIFT_DIV;
-	excluded = (total_blocks << 2) + (skb->len & 0xff) + 34;
+	total_blocks = (total_len + 20) >> TX_HW_BLOCK_SHIFT_DIV;
+	excluded = (total_blocks << 2) + ((total_len + 20) & 0xff) + 34;
 	total_blocks += (excluded > 252) ? 2 : 1;
 	total_blocks += TX_HW_BLOCK_SPARE;
 
-- 
1.5.6.5

