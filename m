Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61639 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab1H1MKk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Aug 2011 08:10:40 -0400
Received: by mail-wy0-f174.google.com with SMTP id 24so3448441wyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 28 Aug 2011 05:10:39 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 5/5] wl12xx: don't queue a new dummy packet if one is already pending
Date: Sun, 28 Aug 2011 15:11:57 +0300
Message-Id: <1314533517-24639-5-git-send-email-eliad@wizery.com> (sfid-20110828_141045_404163_38996B65)
In-Reply-To: <1314533517-24639-1-git-send-email-eliad@wizery.com>
References: <1314533517-24639-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

The firmware only asks for one dummy packet at a time, but sometimes we
are unable to provide it before a FW timer expires. When this happens,
the FW will re-request the dummy packet. If a packet is still queued in
the driver queues, do nothing in this case.

This prevents spurious dummy packets from clogging up the VO AC.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index f1fd991..aeb4cc5 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1540,7 +1540,13 @@ out:
 int wl1271_tx_dummy_packet(struct wl1271 *wl)
 {
 	unsigned long flags;
-	int q = wl1271_tx_get_queue(skb_get_queue_mapping(wl->dummy_packet));
+	int q;
+
+	/* no need to queue a new dummy packet if one is already pending */
+	if (test_bit(WL1271_FLAG_DUMMY_PACKET_PENDING, &wl->flags))
+		return 0;
+
+	q = wl1271_tx_get_queue(skb_get_queue_mapping(wl->dummy_packet));
 
 	spin_lock_irqsave(&wl->wl_lock, flags);
 	set_bit(WL1271_FLAG_DUMMY_PACKET_PENDING, &wl->flags);
-- 
1.7.6.401.g6a319

