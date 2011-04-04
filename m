Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891Ab1DDLux (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2011 07:50:53 -0400
Date: Mon, 4 Apr 2011 13:50:32 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] rt2x00: fix cancelling uninitialized work
Message-ID: <20110404115000.GA9707@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

{rx,tx}done_work's are only initialized for usb devices.

Cc: stable@kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 9de9dbe..84eb6ad 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1062,8 +1062,10 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 	 * Stop all work.
 	 */
 	cancel_work_sync(&rt2x00dev->intf_work);
-	cancel_work_sync(&rt2x00dev->rxdone_work);
-	cancel_work_sync(&rt2x00dev->txdone_work);
+	if (rt2x00_is_usb(rt2x00dev)) {
+		cancel_work_sync(&rt2x00dev->rxdone_work);
+		cancel_work_sync(&rt2x00dev->txdone_work);
+	}
 	destroy_workqueue(rt2x00dev->workqueue);
 
 	/*
-- 
1.7.1

