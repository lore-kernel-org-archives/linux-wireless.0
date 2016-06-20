Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34237 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbcFTKKu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2016 06:10:50 -0400
Received: by mail-pa0-f52.google.com with SMTP id bz2so49728526pad.1
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jun 2016 03:10:38 -0700 (PDT)
From: Binoy Jayan <binoy.jayan@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, Arnd Bergmann <arnd@arndb.de>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH v2 1/2] staging: wilc1000: message_queue: Move code to host interface
Date: Mon, 20 Jun 2016 15:40:18 +0530
Message-Id: <1466417419-13568-2-git-send-email-binoy.jayan@linaro.org> (sfid-20160620_121058_766512_EA120168)
In-Reply-To: <1466417419-13568-1-git-send-email-binoy.jayan@linaro.org>
References: <1465814259-3009-1-git-send-email-binoy.jayan@linaro.org>
 <1466417419-13568-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the contents of wilc_msgqueue.c and wilc_msgqueue.h into
host_interface.c, remove 'wilc_msgqueue.c' and 'wilc_msgqueue.h'.
This is done so as to restructure the implementation of the kthread
'hostIFthread' using a work queue.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/Makefile         |   1 -
 drivers/staging/wilc1000/host_interface.c | 163 +++++++++++++++++++++++++++++-
 drivers/staging/wilc1000/wilc_msgqueue.c  | 144 --------------------------
 drivers/staging/wilc1000/wilc_msgqueue.h  |  28 -----
 4 files changed, 162 insertions(+), 174 deletions(-)
 delete mode 100644 drivers/staging/wilc1000/wilc_msgqueue.c
 delete mode 100644 drivers/staging/wilc1000/wilc_msgqueue.h

diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/Makefile
index acc3f3e..d226283 100644
--- a/drivers/staging/wilc1000/Makefile
+++ b/drivers/staging/wilc1000/Makefile
@@ -6,7 +6,6 @@ ccflags-y += -DFIRMWARE_1002=\"atmel/wilc1002_firmware.bin\" \
 ccflags-y += -I$(src)/ -DWILC_ASIC_A0 -DWILC_DEBUGFS
 
 wilc1000-objs := wilc_wfi_cfgoperations.o linux_wlan.o linux_mon.o \
-			wilc_msgqueue.o \
 			coreconfigurator.o host_interface.o \
 			wilc_wlan_cfg.o wilc_debugfs.o \
 			wilc_wlan.o
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 9535842..494345b 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3,11 +3,13 @@
 #include <linux/kthread.h>
 #include <linux/delay.h>
 #include <linux/completion.h>
+#include <linux/list.h>
 #include "host_interface.h"
+#include <linux/spinlock.h>
+#include <linux/errno.h>
 #include "coreconfigurator.h"
 #include "wilc_wlan.h"
 #include "wilc_wlan_if.h"
-#include "wilc_msgqueue.h"
 #include <linux/etherdevice.h>
 #include "wilc_wfi_netdevice.h"
 
@@ -57,6 +59,20 @@
 #define TCP_ACK_FILTER_LINK_SPEED_THRESH	54
 #define DEFAULT_LINK_SPEED			72
 
+struct message {
+	void *buf;
+	u32 len;
+	struct list_head list;
+};
+
+struct message_queue {
+	struct semaphore sem;
+	spinlock_t lock;
+	bool exiting;
+	u32 recv_count;
+	struct list_head msg_list;
+};
+
 struct host_if_wpa_attr {
 	u8 *key;
 	const u8 *mac_addr;
@@ -264,6 +280,151 @@ static struct wilc_vif *join_req_vif;
 static void *host_int_ParseJoinBssParam(struct network_info *ptstrNetworkInfo);
 static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx);
 static s32 Handle_ScanDone(struct wilc_vif *vif, enum scan_event enuEvent);
+static int wilc_mq_create(struct message_queue *mq);
+static int wilc_mq_send(struct message_queue *mq,
+		 const void *send_buf, u32 send_buf_size);
+static int wilc_mq_recv(struct message_queue *mq,
+		 void *recv_buf, u32 recv_buf_size, u32 *recv_len);
+static int wilc_mq_destroy(struct message_queue *mq);
+
+/*!
+ *  @author		syounan
+ *  @date		1 Sep 2010
+ *  @note		copied from FLO glue implementatuion
+ *  @version		1.0
+ */
+static int wilc_mq_create(struct message_queue *mq)
+{
+	spin_lock_init(&mq->lock);
+	sema_init(&mq->sem, 0);
+	INIT_LIST_HEAD(&mq->msg_list);
+	mq->recv_count = 0;
+	mq->exiting = false;
+	return 0;
+}
+
+/*!
+ *  @author		syounan
+ *  @date		1 Sep 2010
+ *  @note		copied from FLO glue implementatuion
+ *  @version		1.0
+ */
+static int wilc_mq_destroy(struct message_queue *mq)
+{
+	struct message *msg;
+
+	mq->exiting = true;
+
+	/* Release any waiting receiver thread. */
+	while (mq->recv_count > 0) {
+		up(&mq->sem);
+		mq->recv_count--;
+	}
+
+	while (!list_empty(&mq->msg_list)) {
+		msg = list_first_entry(&mq->msg_list, struct message, list);
+		list_del(&msg->list);
+		kfree(msg->buf);
+	}
+
+	return 0;
+}
+
+/*!
+ *  @author		syounan
+ *  @date		1 Sep 2010
+ *  @note		copied from FLO glue implementatuion
+ *  @version		1.0
+ */
+static int wilc_mq_send(struct message_queue *mq,
+		 const void *send_buf, u32 send_buf_size)
+{
+	unsigned long flags;
+	struct message *new_msg = NULL;
+
+	if (!mq || (send_buf_size == 0) || !send_buf)
+		return -EINVAL;
+
+	if (mq->exiting)
+		return -EFAULT;
+
+	/* construct a new message */
+	new_msg = kmalloc(sizeof(*new_msg), GFP_ATOMIC);
+	if (!new_msg)
+		return -ENOMEM;
+
+	new_msg->len = send_buf_size;
+	INIT_LIST_HEAD(&new_msg->list);
+	new_msg->buf = kmemdup(send_buf, send_buf_size, GFP_ATOMIC);
+	if (!new_msg->buf) {
+		kfree(new_msg);
+		return -ENOMEM;
+	}
+
+	spin_lock_irqsave(&mq->lock, flags);
+
+	/* add it to the message queue */
+	list_add_tail(&new_msg->list, &mq->msg_list);
+
+	spin_unlock_irqrestore(&mq->lock, flags);
+
+	up(&mq->sem);
+
+	return 0;
+}
+
+/*!
+ *  @author		syounan
+ *  @date		1 Sep 2010
+ *  @note		copied from FLO glue implementatuion
+ *  @version		1.0
+ */
+static int wilc_mq_recv(struct message_queue *mq,
+		 void *recv_buf, u32 recv_buf_size, u32 *recv_len)
+{
+	struct message *msg;
+	unsigned long flags;
+
+	if (!mq || (recv_buf_size == 0) || !recv_buf || !recv_len)
+		return -EINVAL;
+
+	if (mq->exiting)
+		return -EFAULT;
+
+	spin_lock_irqsave(&mq->lock, flags);
+	mq->recv_count++;
+	spin_unlock_irqrestore(&mq->lock, flags);
+
+	down(&mq->sem);
+	spin_lock_irqsave(&mq->lock, flags);
+
+	if (list_empty(&mq->msg_list)) {
+		spin_unlock_irqrestore(&mq->lock, flags);
+		up(&mq->sem);
+		return -EFAULT;
+	}
+	/* check buffer size */
+	msg = list_first_entry(&mq->msg_list, struct message, list);
+	if (recv_buf_size < msg->len) {
+		spin_unlock_irqrestore(&mq->lock, flags);
+		up(&mq->sem);
+		return -EOVERFLOW;
+	}
+
+	/* consume the message */
+	mq->recv_count--;
+	memcpy(recv_buf, msg->buf, msg->len);
+	*recv_len = msg->len;
+
+	list_del(&msg->list);
+
+	kfree(msg->buf);
+	kfree(msg);
+
+	spin_unlock_irqrestore(&mq->lock, flags);
+
+	return 0;
+}
 
 /* The u8IfIdx starts from 0 to NUM_CONCURRENT_IFC -1, but 0 index used as
  * special purpose in wilc device, so we add 1 to the index to starts from 1.
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
deleted file mode 100644
index 6cb894e..0000000
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ /dev/null
@@ -1,144 +0,0 @@
-
-#include "wilc_msgqueue.h"
-#include <linux/spinlock.h>
-#include <linux/errno.h>
-#include <linux/slab.h>
-
-/*!
- *  @author		syounan
- *  @date		1 Sep 2010
- *  @note		copied from FLO glue implementatuion
- *  @version		1.0
- */
-int wilc_mq_create(struct message_queue *mq)
-{
-	spin_lock_init(&mq->lock);
-	sema_init(&mq->sem, 0);
-	INIT_LIST_HEAD(&mq->msg_list);
-	mq->recv_count = 0;
-	mq->exiting = false;
-	return 0;
-}
-
-/*!
- *  @author		syounan
- *  @date		1 Sep 2010
- *  @note		copied from FLO glue implementatuion
- *  @version		1.0
- */
-int wilc_mq_destroy(struct message_queue *mq)
-{
-	struct message *msg;
-
-	mq->exiting = true;
-
-	/* Release any waiting receiver thread. */
-	while (mq->recv_count > 0) {
-		up(&mq->sem);
-		mq->recv_count--;
-	}
-
-	while (!list_empty(&mq->msg_list)) {
-		msg = list_first_entry(&mq->msg_list, struct message, list);
-		list_del(&msg->list);
-		kfree(msg->buf);
-	}
-
-	return 0;
-}
-
-/*!
- *  @author		syounan
- *  @date		1 Sep 2010
- *  @note		copied from FLO glue implementatuion
- *  @version		1.0
- */
-int wilc_mq_send(struct message_queue *mq,
-		 const void *send_buf, u32 send_buf_size)
-{
-	unsigned long flags;
-	struct message *new_msg = NULL;
-
-	if (!mq || (send_buf_size == 0) || !send_buf)
-		return -EINVAL;
-
-	if (mq->exiting)
-		return -EFAULT;
-
-	/* construct a new message */
-	new_msg = kmalloc(sizeof(*new_msg), GFP_ATOMIC);
-	if (!new_msg)
-		return -ENOMEM;
-
-	new_msg->len = send_buf_size;
-	INIT_LIST_HEAD(&new_msg->list);
-	new_msg->buf = kmemdup(send_buf, send_buf_size, GFP_ATOMIC);
-	if (!new_msg->buf) {
-		kfree(new_msg);
-		return -ENOMEM;
-	}
-
-	spin_lock_irqsave(&mq->lock, flags);
-
-	/* add it to the message queue */
-	list_add_tail(&new_msg->list, &mq->msg_list);
-
-	spin_unlock_irqrestore(&mq->lock, flags);
-
-	up(&mq->sem);
-
-	return 0;
-}
-
-/*!
- *  @author		syounan
- *  @date		1 Sep 2010
- *  @note		copied from FLO glue implementatuion
- *  @version		1.0
- */
-int wilc_mq_recv(struct message_queue *mq,
-		 void *recv_buf, u32 recv_buf_size, u32 *recv_len)
-{
-	struct message *msg;
-	unsigned long flags;
-
-	if (!mq || (recv_buf_size == 0) || !recv_buf || !recv_len)
-		return -EINVAL;
-
-	if (mq->exiting)
-		return -EFAULT;
-
-	spin_lock_irqsave(&mq->lock, flags);
-	mq->recv_count++;
-	spin_unlock_irqrestore(&mq->lock, flags);
-
-	down(&mq->sem);
-	spin_lock_irqsave(&mq->lock, flags);
-
-	if (list_empty(&mq->msg_list)) {
-		spin_unlock_irqrestore(&mq->lock, flags);
-		up(&mq->sem);
-		return -EFAULT;
-	}
-	/* check buffer size */
-	msg = list_first_entry(&mq->msg_list, struct message, list);
-	if (recv_buf_size < msg->len) {
-		spin_unlock_irqrestore(&mq->lock, flags);
-		up(&mq->sem);
-		return -EOVERFLOW;
-	}
-
-	/* consume the message */
-	mq->recv_count--;
-	memcpy(recv_buf, msg->buf, msg->len);
-	*recv_len = msg->len;
-
-	list_del(&msg->list);
-
-	kfree(msg->buf);
-	kfree(msg);
-
-	spin_unlock_irqrestore(&mq->lock, flags);
-
-	return 0;
-}
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
deleted file mode 100644
index 846a484..0000000
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ /dev/null
@@ -1,28 +0,0 @@
-#ifndef __WILC_MSG_QUEUE_H__
-#define __WILC_MSG_QUEUE_H__
-
-#include <linux/semaphore.h>
-#include <linux/list.h>
-
-struct message {
-	void *buf;
-	u32 len;
-	struct list_head list;
-};
-
-struct message_queue {
-	struct semaphore sem;
-	spinlock_t lock;
-	bool exiting;
-	u32 recv_count;
-	struct list_head msg_list;
-};
-
-int wilc_mq_create(struct message_queue *mq);
-int wilc_mq_send(struct message_queue *mq,
-		 const void *send_buf, u32 send_buf_size);
-int wilc_mq_recv(struct message_queue *mq,
-		 void *recv_buf, u32 recv_buf_size, u32 *recv_len);
-int wilc_mq_destroy(struct message_queue *mq);
-
-#endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

