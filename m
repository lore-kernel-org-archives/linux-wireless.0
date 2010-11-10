Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58629 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab0KJCWF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:22:05 -0500
Received: by mail-qw0-f46.google.com with SMTP id 5so5541qwh.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:22:05 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 43/44] compat/2.6.{19,31}: fix threaded irq backport for <2.6.19
Date: Tue,  9 Nov 2010 21:20:25 -0500
Message-Id: <1289355626-25373-44-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.31.h |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.31.h b/include/linux/compat-2.6.31.h
index 52291f4..76b2cf8 100644
--- a/include/linux/compat-2.6.31.h
+++ b/include/linux/compat-2.6.31.h
@@ -101,6 +101,10 @@ static inline struct rtable *skb_rtable(const struct sk_buff *skb)
 }
 
 /* Backport threaded IRQ support */
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19))
+typedef irqreturn_t (*irq_handler_t)(int, void *, struct pt_regs *);
+#endif
+
 struct compat_threaded_irq {
 	unsigned int irq;
 	irq_handler_t handler;
@@ -117,7 +121,11 @@ void compat_irq_work(void *arg)
 {
 	struct work_struct *work = arg;
 	struct compat_threaded_irq *comp = container_of(work, struct compat_threaded_irq, work);
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19))
+	comp->thread_fn(comp->irq, comp->dev_id, NULL);
+#else
 	comp->thread_fn(comp->irq, comp->dev_id);
+#endif
 }
 #else
 static inline
@@ -128,13 +136,22 @@ void compat_irq_work(struct work_struct *work)
 }
 #endif
 
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19))
+static inline
+irqreturn_t compat_irq_dispatcher(int irq, void *dev_id, struct pt_regs *regs)
+#else
 static inline
 irqreturn_t compat_irq_dispatcher(int irq, void *dev_id)
+#endif
 {
 	struct compat_threaded_irq *comp = dev_id;
 	irqreturn_t res;
 
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19))
+	res = comp->handler(irq, comp->dev_id, regs);
+#else
 	res = comp->handler(irq, comp->dev_id);
+#endif
 	if (res == IRQ_WAKE_THREAD) {
 		queue_work(comp->wq, &comp->work);
 		res = IRQ_HANDLED;
-- 
1.7.2.30.gc37d7.dirty

