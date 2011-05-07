Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49960 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384Ab1EGP2N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 May 2011 11:28:13 -0400
Received: by eyx24 with SMTP id 24so1215677eyx.19
        for <linux-wireless@vger.kernel.org>; Sat, 07 May 2011 08:28:12 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Fix rmmod hang of rt2800pci
Date: Sat, 7 May 2011 17:27:46 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <201105071727.46998.IvDoorn@gmail.com> (sfid-20110507_172816_668841_4AB0BE75)
Content-Type: Text/Plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

txstatus_timer should only be deleted for USB devices, as it is only
initialized for USB devices.

Reported-by: Andreas Hartmann <andihartmann@01019freenet.de>
Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 2eb5196..c018d67 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1159,9 +1159,9 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Stop all work.
 	 */
-	del_timer_sync(&rt2x00dev->txstatus_timer);
 	cancel_work_sync(&rt2x00dev->intf_work);
 	if (rt2x00_is_usb(rt2x00dev)) {
+		del_timer_sync(&rt2x00dev->txstatus_timer);
 		cancel_work_sync(&rt2x00dev->rxdone_work);
 		cancel_work_sync(&rt2x00dev->txdone_work);
 	}
-- 
1.7.2.3

