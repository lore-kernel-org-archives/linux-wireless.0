Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:39925 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433Ab1E2Koe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 May 2011 06:44:34 -0400
Date: Sun, 29 May 2011 12:45:29 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-2.6] rt2x00: fix rmmod crash
Message-ID: <20110529104529.GA2769@localhost.localdomain> (sfid-20110529_124442_115082_C9468D02)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not destroy workqueue, which still can be used by autowakeup_work,
before ieee80211_unregister_hw() is called.

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index c018d67..2f2627b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1165,7 +1165,6 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 		cancel_work_sync(&rt2x00dev->rxdone_work);
 		cancel_work_sync(&rt2x00dev->txdone_work);
 	}
-	destroy_workqueue(rt2x00dev->workqueue);
 
 	/*
 	 * Free the tx status fifo.
@@ -1198,6 +1197,11 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 	rt2x00lib_remove_hw(rt2x00dev);
 
 	/*
+	 * Now nobody use workqueue anymore.
+	 */
+	destroy_workqueue(rt2x00dev->workqueue);
+
+	/*
 	 * Free firmware image.
 	 */
 	rt2x00lib_free_firmware(rt2x00dev);
-- 
1.7.4

