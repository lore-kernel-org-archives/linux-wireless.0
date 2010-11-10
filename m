Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:36265 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837Ab0KJCVV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:21:21 -0500
Received: by mail-qy0-f181.google.com with SMTP id 31so159944qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:21:20 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 19/44] compat/2.6.31: fix threaded irq backport wrt. INIT_WORK() macro
Date: Tue,  9 Nov 2010 21:20:01 -0500
Message-Id: <1289355626-25373-20-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.31.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.31.h b/include/linux/compat-2.6.31.h
index b9a70bd..b1b7b28 100644
--- a/include/linux/compat-2.6.31.h
+++ b/include/linux/compat-2.6.31.h
@@ -115,12 +115,22 @@ struct compat_threaded_irq {
 	struct work_struct work;
 };
 
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20))
+static inline
+void compat_irq_work(void *arg)
+{
+	struct work_struct *work = arg;
+	struct compat_threaded_irq *comp = container_of(work, struct compat_threaded_irq, work);
+	comp->thread_fn(comp->irq, comp->dev_id);
+}
+#else
 static inline
 void compat_irq_work(struct work_struct *work)
 {
 	struct compat_threaded_irq *comp = container_of(work, struct compat_threaded_irq, work);
 	comp->thread_fn(comp->irq, comp->dev_id);
 }
+#endif
 
 static inline
 irqreturn_t compat_irq_dispatcher(int irq, void *dev_id)
@@ -150,7 +160,11 @@ int compat_request_threaded_irq(struct compat_threaded_irq *comp,
 	comp->handler = handler;
 	comp->thread_fn = thread_fn;
 	comp->dev_id = dev_id;
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20))
+	INIT_WORK(&comp->work, compat_irq_work, &comp->work);
+#else
 	INIT_WORK(&comp->work, compat_irq_work);
+#endif
 
 	if (!comp->wq) {
 		snprintf(comp->wq_name, sizeof(comp->wq_name),
-- 
1.7.2.30.gc37d7.dirty

