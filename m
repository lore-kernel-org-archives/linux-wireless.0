Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58629 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837Ab0KJCVS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:21:18 -0500
Received: by mail-qw0-f46.google.com with SMTP id 5so5541qwh.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:21:18 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 18/44] compat/2.6.31: gather all the threaded IRQ backport together
Date: Tue,  9 Nov 2010 21:20:00 -0500
Message-Id: <1289355626-25373-19-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.31.h |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/include/linux/compat-2.6.31.h b/include/linux/compat-2.6.31.h
index d2e0f01..b9a70bd 100644
--- a/include/linux/compat-2.6.31.h
+++ b/include/linux/compat-2.6.31.h
@@ -58,16 +58,6 @@
 #define SDIO_DEVICE_ID_MARVELL_8688WLAN		0x9104
 #endif
 
-struct compat_threaded_irq {
-	unsigned int irq;
-	irq_handler_t handler;
-	irq_handler_t thread_fn;
-	void *dev_id;
-	char wq_name[64];
-	struct workqueue_struct *wq;
-	struct work_struct work;
-};
-
 /*
  * kmemleak was introduced on 2.6.31, since older kernels do not have
  * we simply ignore its tuning.
@@ -115,6 +105,15 @@ static inline struct rtable *skb_rtable(const struct sk_buff *skb)
 }
 
 /* Backport threaded IRQ support */
+struct compat_threaded_irq {
+	unsigned int irq;
+	irq_handler_t handler;
+	irq_handler_t thread_fn;
+	void *dev_id;
+	char wq_name[64];
+	struct workqueue_struct *wq;
+	struct work_struct work;
+};
 
 static inline
 void compat_irq_work(struct work_struct *work)
-- 
1.7.2.30.gc37d7.dirty

