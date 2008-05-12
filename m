Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms5.Sony.CO.JP ([211.125.136.201]:35099 "EHLO ms5.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbYELEug (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2008 00:50:36 -0400
Received: from mta5.sony.co.jp (mta5.Sony.CO.JP [137.153.71.6])
 by ms5.sony.co.jp (R8/Sony) with ESMTP id m4C4oY1Y011505
 for <linux-wireless@vger.kernel.org>; Mon, 12 May 2008 13:50:34 +0900 (JST)
Received: from mta5.sony.co.jp (localhost [127.0.0.1])
 by mta5.sony.co.jp (R8/Sony) with ESMTP id m4C4oXG0004458
 for <linux-wireless@vger.kernel.org>; Mon, 12 May 2008 13:50:33 +0900 (JST)
Received: from smail1.sm.sony.co.jp (smail1.sm.sony.co.jp [43.11.253.1])
 by mta5.sony.co.jp (R8/Sony) with ESMTP id m4C4oXv4004447
 for <linux-wireless@vger.kernel.org>; Mon, 12 May 2008 13:50:33 +0900 (JST)
Date: Mon, 12 May 2008 13:50:28 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] PS3: gelic: fix memory leak
Cc: geoffrey.levand@am.sony.com,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Message-Id: <20080512133701.A050.40F06B3A@sm.sony.co.jp> (sfid-20080512_065050_790466_38AE8815)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the bug that the I/O buffer is not freed at the driver removal.

Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>
---
 drivers/net/ps3_gelic_wireless.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ps3_gelic_wireless.c
+++ b/drivers/net/ps3_gelic_wireless.c
@@ -2474,6 +2474,8 @@ static void gelic_wl_free(struct gelic_w
 
 	pr_debug("%s: <-\n", __func__);
 
+	free_page((unsigned long)wl->buf);
+
 	pr_debug("%s: destroy queues\n", __func__);
 	destroy_workqueue(wl->eurus_cmd_queue);
 	destroy_workqueue(wl->event_queue);

-- 
Masakazu Mokuno

