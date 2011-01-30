Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41674 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab1A3MY3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 07:24:29 -0500
Received: by mail-ey0-f174.google.com with SMTP id 27so2146783eye.19
        for <linux-wireless@vger.kernel.org>; Sun, 30 Jan 2011 04:24:29 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 05/21] rt2x00: Introduce tasklets for interrupt handling
Date: Sun, 30 Jan 2011 13:17:52 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201101301316.04044.IvDoorn@gmail.com> <201101301316.53532.IvDoorn@gmail.com> <201101301317.30813.IvDoorn@gmail.com>
In-Reply-To: <201101301317.30813.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101301317.53313.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

No functional changes, just preparation for moving interrupt handling to
tasklets. The tasklets are disabled by default. Drivers making use of
them need to enable the tasklets when the device state is set to IRQ_ON.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h    |   13 +++++++++++++
 drivers/net/wireless/rt2x00/rt2x00dev.c |   21 +++++++++++++++++++++
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 985982b..6965131 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -520,6 +520,10 @@ struct rt2x00lib_ops {
 	 * TX status tasklet handler.
 	 */
 	void (*txstatus_tasklet) (unsigned long data);
+	void (*pretbtt_tasklet) (unsigned long data);
+	void (*tbtt_tasklet) (unsigned long data);
+	void (*rxdone_tasklet) (unsigned long data);
+	void (*autowake_tasklet) (unsigned long data);
 
 	/*
 	 * Device init handlers.
@@ -905,6 +909,15 @@ struct rt2x00_dev {
 	 * Tasklet for processing tx status reports (rt2800pci).
 	 */
 	struct tasklet_struct txstatus_tasklet;
+	struct tasklet_struct pretbtt_tasklet;
+	struct tasklet_struct tbtt_tasklet;
+	struct tasklet_struct rxdone_tasklet;
+	struct tasklet_struct autowake_tasklet;
+
+	/*
+	 * Protect the interrupt mask register.
+	 */
+	spinlock_t irqmask_lock;
 };
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 50b379a..7d4dece 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -831,6 +831,26 @@ static int rt2x00lib_probe_hw(struct rt2x00_dev *rt2x00dev)
 	}
 
 	/*
+	 * Initialize tasklets if used by the driver. Tasklets are
+	 * disabled until the interrupts are turned on. The driver
+	 * has to handle that.
+	 */
+#define RT2X00_TASKLET_INIT(taskletname) \
+	if (rt2x00dev->ops->lib->taskletname) { \
+		tasklet_init(&rt2x00dev->taskletname, \
+			     rt2x00dev->ops->lib->taskletname, \
+			     (unsigned long)rt2x00dev); \
+		tasklet_disable(&rt2x00dev->taskletname); \
+	}
+
+	RT2X00_TASKLET_INIT(pretbtt_tasklet);
+	RT2X00_TASKLET_INIT(tbtt_tasklet);
+	RT2X00_TASKLET_INIT(rxdone_tasklet);
+	RT2X00_TASKLET_INIT(autowake_tasklet);
+
+#undef RT2X00_TASKLET_INIT
+
+	/*
 	 * Register HW.
 	 */
 	status = ieee80211_register_hw(rt2x00dev->hw);
@@ -958,6 +978,7 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 {
 	int retval = -ENOMEM;
 
+	spin_lock_init(&rt2x00dev->irqmask_lock);
 	mutex_init(&rt2x00dev->csr_mutex);
 
 	set_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
-- 
1.7.2.3

