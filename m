Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65142 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab0KJCUz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:20:55 -0500
Received: by qwh5 with SMTP id 5so5749qwh.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:20:54 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 06/44] compat/2.6.19: add typedef for `bool' and `true'/`false'
Date: Tue,  9 Nov 2010 21:19:48 -0500
Message-Id: <1289355626-25373-7-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.19.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.19.h b/include/linux/compat-2.6.19.h
index 9bb1ace..bcffc47 100644
--- a/include/linux/compat-2.6.19.h
+++ b/include/linux/compat-2.6.19.h
@@ -19,6 +19,14 @@ compat_kmem_cache_destroy(struct kmem_cache *cachep)
 #endif
 }
 
+#else /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,19)) */
+
+typedef _Bool			bool;
+enum {
+	false = 0,
+	true = 1
+};
+
 #endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,19)) */
 
 #endif /* LINUX_26_19_COMPAT_H */
-- 
1.7.2.30.gc37d7.dirty

