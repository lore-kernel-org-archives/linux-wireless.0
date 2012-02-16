Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:55491 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab2BPSpp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Feb 2012 13:45:45 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	users@rt2x00.serialmonkey.com, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH] rt2x00: fix a possible NULL pointer dereference
Date: Thu, 16 Feb 2012 20:44:59 +0100
Message-Id: <1329421499-10237-1-git-send-email-juhosg@openwrt.org> (sfid-20120216_194548_984006_61DD86A8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 'rt2x00lib_probe_dev' function tries to
allocate the workqueue. If the allocation
fails, 'rt2x00_lib_remove_dev' is called on
the error path. Because 'rt2x00dev->workqueue'
is NULL in this case, the 'destroy_workqueue'
call will cause a NULL pointer dereference.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index bae5b01..d62e64f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1232,7 +1232,8 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 		cancel_work_sync(&rt2x00dev->rxdone_work);
 		cancel_work_sync(&rt2x00dev->txdone_work);
 	}
-	destroy_workqueue(rt2x00dev->workqueue);
+	if (rt2x00dev->workqueue)
+		destroy_workqueue(rt2x00dev->workqueue);
 
 	/*
 	 * Free the tx status fifo.
-- 
1.7.2.1

