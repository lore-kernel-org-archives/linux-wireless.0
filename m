Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41674 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab1A3MYb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 07:24:31 -0500
Received: by mail-ey0-f174.google.com with SMTP id 27so2146783eye.19
        for <linux-wireless@vger.kernel.org>; Sun, 30 Jan 2011 04:24:31 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 06/21] rt2x00: Disable txstatus tasklet by default
Date: Sun, 30 Jan 2011 13:18:13 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201101301316.04044.IvDoorn@gmail.com> <201101301317.30813.IvDoorn@gmail.com> <201101301317.53313.IvDoorn@gmail.com>
In-Reply-To: <201101301317.53313.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101301318.14610.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Enable the txstatus tasklet when interrupts are enabled and disable it
together with the interrupts. Also make the txstatus tasklet useful even
without the tx status FIFO and make use of the generic rt2x00 tasklet
initialization macro.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |    5 ++++-
 drivers/net/wireless/rt2x00/rt2x00dev.c |    8 +-------
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 54e37e0..e4d97ad 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -416,7 +416,10 @@ static void rt2800pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 	if (state == STATE_RADIO_IRQ_ON) {
 		rt2800_register_read(rt2x00dev, INT_SOURCE_CSR, &reg);
 		rt2800_register_write(rt2x00dev, INT_SOURCE_CSR, reg);
-	}
+
+		tasklet_enable(&rt2x00dev->txstatus_tasklet);
+	} else if (state == STATE_RADIO_IRQ_OFF)
+		tasklet_disable(&rt2x00dev->txstatus_tasklet);
 
 	rt2800_register_read(rt2x00dev, INT_MASK_CSR, &reg);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_RXDELAYINT, 0);
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 7d4dece..5812a4e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -821,13 +821,6 @@ static int rt2x00lib_probe_hw(struct rt2x00_dev *rt2x00dev)
 				     GFP_KERNEL);
 		if (status)
 			return status;
-
-		/* tasklet for processing the tx status reports. */
-		if (rt2x00dev->ops->lib->txstatus_tasklet)
-			tasklet_init(&rt2x00dev->txstatus_tasklet,
-				     rt2x00dev->ops->lib->txstatus_tasklet,
-				     (unsigned long)rt2x00dev);
-
 	}
 
 	/*
@@ -843,6 +836,7 @@ static int rt2x00lib_probe_hw(struct rt2x00_dev *rt2x00dev)
 		tasklet_disable(&rt2x00dev->taskletname); \
 	}
 
+	RT2X00_TASKLET_INIT(txstatus_tasklet);
 	RT2X00_TASKLET_INIT(pretbtt_tasklet);
 	RT2X00_TASKLET_INIT(tbtt_tasklet);
 	RT2X00_TASKLET_INIT(rxdone_tasklet);
-- 
1.7.2.3

