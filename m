Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41674 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab1A3MYl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 07:24:41 -0500
Received: by mail-ey0-f174.google.com with SMTP id 27so2146783eye.19
        for <linux-wireless@vger.kernel.org>; Sun, 30 Jan 2011 04:24:40 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 11/21] rt2x00: Remove interrupt thread registration
Date: Sun, 30 Jan 2011 13:20:29 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201101301316.04044.IvDoorn@gmail.com> <201101301319.38761.IvDoorn@gmail.com> <201101301320.06167.IvDoorn@gmail.com>
In-Reply-To: <201101301320.06167.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101301320.29903.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

No driver uses interrupt threads anymore. Remove the remaining interrupt
thread artifacts.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h    |   11 -----------
 drivers/net/wireless/rt2x00/rt2x00pci.c |    7 +++----
 2 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 6965131..7661e4f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -512,11 +512,6 @@ struct rt2x00lib_ops {
 	irq_handler_t irq_handler;
 
 	/*
-	 * Threaded Interrupt handlers.
-	 */
-	irq_handler_t irq_handler_thread;
-
-	/*
 	 * TX status tasklet handler.
 	 */
 	void (*txstatus_tasklet) (unsigned long data);
@@ -895,12 +890,6 @@ struct rt2x00_dev {
 	const struct firmware *fw;
 
 	/*
-	 * Interrupt values, stored between interrupt service routine
-	 * and interrupt thread routine.
-	 */
-	u32 irqvalue[2];
-
-	/*
 	 * FIFO for storing tx status reports between isr and tasklet.
 	 */
 	DECLARE_KFIFO_PTR(txstatus_fifo, u32);
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index ace0b66..4dd82b0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -160,10 +160,9 @@ int rt2x00pci_initialize(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Register interrupt handler.
 	 */
-	status = request_threaded_irq(rt2x00dev->irq,
-				      rt2x00dev->ops->lib->irq_handler,
-				      rt2x00dev->ops->lib->irq_handler_thread,
-				      IRQF_SHARED, rt2x00dev->name, rt2x00dev);
+	status = request_irq(rt2x00dev->irq,
+			     rt2x00dev->ops->lib->irq_handler,
+			     IRQF_SHARED, rt2x00dev->name, rt2x00dev);
 	if (status) {
 		ERROR(rt2x00dev, "IRQ %d allocation failed (error %d).\n",
 		      rt2x00dev->irq, status);
-- 
1.7.2.3

