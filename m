Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64201 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab0L0OIK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Dec 2010 09:08:10 -0500
Received: by wwa36 with SMTP id 36so9024113wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Dec 2010 06:08:09 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 02/10] rt2x00: allow txstatus_fifo w/o txstatus_tasklet
Date: Mon, 27 Dec 2010 15:04:54 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201012271504.30848.IvDoorn@gmail.com>
In-Reply-To: <201012271504.30848.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012271504.55450.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Stezenbach <js@sig21.net>

When DRIVER_REQUIRE_TXSTATUS_FIFO is set, intialize the
txstatus_fifo, but initialize rt2x00dev->txstatus_tasklet
only when both DRIVER_REQUIRE_TXSTATUS_FIFO and
rt2x00dev->ops->lib->txstatus_tasklet are set.

This allows the txstatus_fifo to be used by rt2800usb which
does not use txstatus_tasklet.

Signed-off-by: Johannes Stezenbach <js@sig21.net>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index fa74acd..97a8911 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -813,8 +813,7 @@ static int rt2x00lib_probe_hw(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Allocate tx status FIFO for driver use.
 	 */
-	if (test_bit(DRIVER_REQUIRE_TXSTATUS_FIFO, &rt2x00dev->flags) &&
-	    rt2x00dev->ops->lib->txstatus_tasklet) {
+	if (test_bit(DRIVER_REQUIRE_TXSTATUS_FIFO, &rt2x00dev->flags)) {
 		/*
 		 * Allocate txstatus fifo and tasklet, we use a size of 512
 		 * for the kfifo which is big enough to store 512/4=128 tx
@@ -828,9 +827,10 @@ static int rt2x00lib_probe_hw(struct rt2x00_dev *rt2x00dev)
 			return status;
 
 		/* tasklet for processing the tx status reports. */
-		tasklet_init(&rt2x00dev->txstatus_tasklet,
-			     rt2x00dev->ops->lib->txstatus_tasklet,
-			     (unsigned long)rt2x00dev);
+		if (rt2x00dev->ops->lib->txstatus_tasklet)
+			tasklet_init(&rt2x00dev->txstatus_tasklet,
+				     rt2x00dev->ops->lib->txstatus_tasklet,
+				     (unsigned long)rt2x00dev);
 
 	}
 
-- 
1.7.2.3

