Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65142 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab0KJCVW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:21:22 -0500
Received: by mail-qw0-f46.google.com with SMTP id 5so5749qwh.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:21:22 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 20/44] compat/2.6.32: fix compat inline to flush_delayed_work()
Date: Tue,  9 Nov 2010 21:20:02 -0500
Message-Id: <1289355626-25373-21-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was needed as major API changes was made in 2.6.21.

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.32.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.32.h b/include/linux/compat-2.6.32.h
index 321a89a..873ae3d 100644
--- a/include/linux/compat-2.6.32.h
+++ b/include/linux/compat-2.6.32.h
@@ -20,6 +20,10 @@
 
 static inline void flush_delayed_work(struct delayed_work *dwork)
 {
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21))
+	cancel_delayed_work(dwork);
+	flush_scheduled_work();
+#else
 	if (del_timer_sync(&dwork->timer)) {
 		/*
 		 * This is what would happen on 2.6.32 but since we don't have
@@ -34,6 +38,7 @@ static inline void flush_delayed_work(struct delayed_work *dwork)
 		*/
 	}
 	flush_work(&dwork->work);
+#endif
 }
 
 /*
-- 
1.7.2.30.gc37d7.dirty

