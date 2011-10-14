Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60387 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932838Ab1JNMxE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Oct 2011 08:53:04 -0400
Received: by mail-gx0-f174.google.com with SMTP id b1so344031ggn.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Oct 2011 05:53:04 -0700 (PDT)
From: Sangwook Lee <sangwook.lee@linaro.org>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, patches@linaro.org,
	Sangwook Lee <sangwook.lee@linaro.org>
Subject: [PATCH 5/5] ath6kl: Add SDIO polling function
Date: Fri, 14 Oct 2011 13:50:46 +0100
Message-Id: <1318596646-19495-6-git-send-email-sangwook.lee@linaro.org> (sfid-20111014_145316_399813_2FEBE0B8)
In-Reply-To: <1318596646-19495-1-git-send-email-sangwook.lee@linaro.org>
References: <1318596646-19495-1-git-send-email-sangwook.lee@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SDIO polling fuctions exsits on the separate file. This can be
deseleted in Makefile according to menu configuration

Signed-off-by: Sangwook Lee <sangwook.lee@linaro.org>
---
 drivers/net/wireless/ath/ath6kl/sdio_poll.c |  216 +++++++++++++++++++++++++++
 1 files changed, 216 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath6kl/sdio_poll.c

diff --git a/drivers/net/wireless/ath/ath6kl/sdio_poll.c b/drivers/net/wireless/ath/ath6kl/sdio_poll.c
new file mode 100644
index 0000000..ce2f127
--- /dev/null
+++ b/drivers/net/wireless/ath/ath6kl/sdio_poll.c
@@ -0,0 +1,216 @@
+/*
+ * Copyright (c) 2011 Linaro
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/moduleparam.h>
+#include <linux/errno.h>
+#include <linux/of.h>
+#include <linux/mmc/host.h>
+#include <linux/mmc/card.h>
+#include <linux/mmc/sdio_func.h>
+#include <linux/kthread.h>
+#include "core.h"
+#include "cfg80211.h"
+#include "target.h"
+#include "debug.h"
+#include "hif-ops.h"
+
+/* This structure is duplicated used in sdio.c */
+struct ath6kl_sdio {
+
+	struct sdio_func *func;
+
+	spinlock_t lock;
+
+	/* free list */
+	struct list_head bus_req_freeq;
+
+	/* available bus requests */
+	struct bus_request bus_req[BUS_REQUEST_MAX_NUM];
+
+	struct ath6kl *ar;
+	u8 *dma_buffer;
+
+	/* scatter request list head */
+	struct list_head scat_req;
+
+	spinlock_t scat_lock;
+	bool is_disabled;
+	atomic_t irq_handling;
+	const struct sdio_device_id *id;
+	struct work_struct wr_async_work;
+	struct list_head wr_asyncq;
+	spinlock_t wr_async_lock;
+};
+
+/* Use polling method of SDIO interrupt */
+struct ath6kl_poll {
+	/* Watchdog task struct */
+	struct task_struct *wd_ts;
+	/* watchdog sempahore */
+	struct semaphore wd_sem;
+	struct completion wd_exited;
+	/* Wathdog wake up timer */
+	struct timer_list wd_timer;
+	bool wd_timer_valid;
+	/* polling time ms */
+	int wd_ms;
+};
+
+/*Later, this can become a member of struct ath6kl */
+static struct ath6kl_poll *ap_g;
+
+static void ath6kl_wd_poll_handler(struct ath6kl *ar)
+{
+	int status;
+	struct ath6kl_sdio *ar_sdio;
+
+	/* Wait for htc_target to be created
+	 * because wd_init is called
+	 * beforeath6kl_core_init
+	 */
+	if (!ar->htc_target)
+		return;
+
+	ar_sdio = (struct ath6kl_sdio *)ar->hif_priv;
+	ath6kl_dbg(ATH6KL_DBG_SDIO, "irq\n");
+	atomic_set(&ar_sdio->irq_handling, 1);
+	status = ath6kldev_intr_bh_handler(ar);
+	atomic_set(&ar_sdio->irq_handling, 0);
+	WARN_ON(status && status != -ECANCELED);
+}
+
+/* Update watchdog time */
+static inline void ath6kl_wd_update_time(struct ath6kl_poll *ap)
+{
+	if (ap->wd_timer_valid)
+		mod_timer(&ap->wd_timer, jiffies + msecs_to_jiffies(ap->wd_ms));
+}
+
+static void ath6kl_wd_func(ulong data)
+{
+	struct ath6kl_poll *ap = (struct ath6kl_poll *)data;
+
+	if (!ap->wd_timer_valid) {
+		del_timer_sync(&ap->wd_timer);
+		return;
+	}
+	/* Wake up sleeping watchdog thread */
+	if (ap->wd_timer_valid)
+		up(&ap->wd_sem);
+
+	/* Reschedule the watchdog */
+	ath6kl_wd_update_time(ap);
+}
+
+static int ath6kl_wd_thread(void *data)
+{
+	struct ath6kl *ar = (struct ath6kl *)data;
+	struct ath6kl_poll *ap = ap_g;
+	struct sched_param param = {.sched_priority = 1 };
+
+	sched_setscheduler(current, SCHED_FIFO, &param);
+	allow_signal(SIGKILL);
+	allow_signal(SIGTERM);
+
+	/* Run until signal received */
+	do {
+		if (down_interruptible(&ap->wd_sem) == 0) {
+			/* Call the bus module watchdog */
+			ath6kl_wd_poll_handler(ar);
+			/* Reschedule the watchdog */
+			ath6kl_wd_update_time(ap);
+		} else {
+			break;
+		}
+	} while (!kthread_should_stop());
+
+	complete_and_exit(&ap->wd_exited, 0);
+
+	return 0;
+}
+
+/**
+ * ath6kl_wd_init -init watchdog poll for ath6kl
+ *
+ * must be called after ath6kl_htc_create because SDIO host
+ * irq must be disabled
+ */
+void ath6kl_wd_init(struct ath6kl *ar)
+{
+	struct ath6kl_poll *ap;
+	struct timer_list *timer;
+
+	ap = kzalloc(sizeof(struct ath6kl_poll), GFP_KERNEL);
+
+	/* For ath6kl_wd_cleanup */
+	ap_g = ap;
+
+	if (!ap) {
+		ath6kl_err("failed to alloc memory\n");
+		return;
+	}
+
+	/* Congfigure polling time */
+	ap->wd_timer_valid = true;
+	/* Please change this polling time : 10 ms by default */
+	ap->wd_ms = 10;
+
+	sema_init(&ap->wd_sem, 1);
+	init_completion(&ap->wd_exited);
+
+	ap->wd_ts = kthread_run(ath6kl_wd_thread, (void *)ar, "ath6kl_wd");
+	if (IS_ERR(ap->wd_ts)) {
+		ap->wd_timer_valid = false;
+		del_timer_sync(&ap->wd_timer);
+		ath6kl_err("failed to make ath6k_wd\n");
+		kfree(ap);
+		ap_g = NULL;
+		return;
+	}
+
+	/* Set up the watchdog timer */
+	timer = &ap->wd_timer;
+	init_timer(timer);
+	timer->function = ath6kl_wd_func;
+	timer->data = (ulong) ap;
+	/* Run timer now at first */
+	timer->expires = jiffies + msecs_to_jiffies(1);
+	add_timer(timer);
+
+}
+
+void ath6kl_wd_cleanup(struct ath6kl *ar)
+{
+	struct ath6kl_poll *ap = ap_g;
+
+	/* Check validity */
+	if (!ap || !ap->wd_timer_valid)
+		return;
+
+	ap->wd_ms = 0;
+	del_timer_sync(&ap->wd_timer);
+	ap->wd_timer_valid = false;
+
+	/* Wake up thread sleeping on wd_sem */
+	send_sig(SIGTERM, ap->wd_ts, 1);
+
+	wait_for_completion(&ap->wd_exited);
+
+	/* Kill watchdog thread */
+	kthread_stop(ap->wd_ts);
+
+	kfree(ap);
+}
-- 
1.7.4.1

