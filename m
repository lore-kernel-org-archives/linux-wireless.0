Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58781 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab1DRNoU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 09:44:20 -0400
Received: by wwa36 with SMTP id 36so5680567wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 06:44:19 -0700 (PDT)
From: Ido Yariv <ido@wizery.com>
To: "Luciano Coelho" <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>
Subject: [PATCH] wl12xx: Restart TX when TX descriptors are available
Date: Mon, 18 Apr 2011 16:44:11 +0300
Message-Id: <1303134251-31514-1-git-send-email-ido@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver stops sending TX packets when either there aren't enough
memory blocks, or it runs out of TX descriptors. The driver continues to
send packets to the FW only when more memory blocks are available.

The FW might free TX descriptors without freeing the corresponding
memory blocks, especially when dynamic memory is enabled. In cases where
memory blocks are not freed at all, the driver will keep waiting for
more memory blocks indefinitely.

Fix this by clearing the WL1271_FLAG_FW_TX_BUSY flag when there are
available TX descriptors.

Signed-off-by: Ido Yariv <ido@wizery.com>
---
 drivers/net/wireless/wl12xx/tx.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 7a3339f..5a1575f 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -65,6 +65,9 @@ static int wl1271_alloc_tx_id(struct wl1271 *wl, struct sk_buff *skb)
 static void wl1271_free_tx_id(struct wl1271 *wl, int id)
 {
 	if (__test_and_clear_bit(id, wl->tx_frames_map)) {
+		if (unlikely(wl->tx_frames_cnt == ACX_TX_DESCRIPTORS))
+			clear_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags);
+
 		wl->tx_frames[id] = NULL;
 		wl->tx_frames_cnt--;
 	}
-- 
1.7.1

