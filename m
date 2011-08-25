Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58014 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab1HYQD1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 12:03:27 -0400
Received: by mail-ww0-f44.google.com with SMTP id 5so2547982wwf.1
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 09:03:27 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 5/5] wl12xx: don't queue a new dummy packet if one is already pending
Date: Thu, 25 Aug 2011 19:04:30 +0300
Message-Id: <1314288270-22380-5-git-send-email-eliad@wizery.com> (sfid-20110825_180329_956132_01F7E304)
In-Reply-To: <1314288270-22380-1-git-send-email-eliad@wizery.com>
References: <1314288270-22380-1-git-send-email-eliad@wizery.com>
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

