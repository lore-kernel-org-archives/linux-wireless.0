Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52328 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab1HIJOh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:14:37 -0400
Received: by mail-wy0-f174.google.com with SMTP id 24so210690wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 02:14:36 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 35/40] wl12xx: handle wrap-around overflow in released Tx blocks FW counter
Date: Tue,  9 Aug 2011 12:13:48 +0300
Message-Id: <1312881233-9366-36-git-send-email-eliad@wizery.com> (sfid-20110809_111449_530128_EE52B5A2)
In-Reply-To: <1312881233-9366-1-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

When the FW Tx released blocks counter wraps around, we should correct
our calculation of released blocks. Otherwise we add a large negative
figure to our driver freed blocks counter

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 755415a..c8e9ba6 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -830,14 +830,21 @@ static void wl1271_fw_status(struct wl1271 *wl,
 				(status->tx_released_pkts[i] -
 				wl->tx_pkts_freed[i] + 256) % 256;
 
 		wl->tx_pkts_freed[i] = status->tx_released_pkts[i];
 	}
 
-	freed_blocks = le32_to_cpu(status->total_released_blks) -
-		       wl->tx_blocks_freed;
+	/* prevent wrap-around in total blocks counter */
+	if (likely(wl->tx_blocks_freed <=
+		   le32_to_cpu(status->total_released_blks)))
+		freed_blocks = le32_to_cpu(status->total_released_blks) -
+			       wl->tx_blocks_freed;
+	else
+		freed_blocks = 0x100000000LL - wl->tx_blocks_freed +
+			       le32_to_cpu(status->total_released_blks);
+
 	wl->tx_blocks_freed = le32_to_cpu(status->total_released_blks);
 
 	wl->tx_allocated_blocks -= freed_blocks;
 
 	avail = le32_to_cpu(status->tx_total) - wl->tx_allocated_blocks;
 
-- 
1.7.6.401.g6a319

