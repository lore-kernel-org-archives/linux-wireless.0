Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39368 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114Ab0KJCUv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:20:51 -0500
Received: by qyk12 with SMTP id 12so2500250qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:20:50 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 03/44] compat/2.6.18: add compat skeleton for the `hwrng' API
Date: Tue,  9 Nov 2010 21:19:45 -0500
Message-Id: <1289355626-25373-4-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.18.h |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.18.h b/include/linux/compat-2.6.18.h
index 5e0182b..a45cfc7 100644
--- a/include/linux/compat-2.6.18.h
+++ b/include/linux/compat-2.6.18.h
@@ -8,6 +8,30 @@
 
 #define roundup(x, y)	((((x) + ((y) - 1)) / (y)) * (y))
 
+struct hwrng
+{
+	const char *name;
+	int (*init)(struct hwrng *rng);
+	void (*cleanup)(struct hwrng *rng);
+	int (*data_present)(struct hwrng *rng);
+	int (*data_read)(struct hwrng *rng, u32 *data);
+	unsigned long priv;
+
+	/* internal. */
+	struct list_head list;
+};
+
+static inline int
+hwrng_register(struct hwrng *rng)
+{
+	return -ENOSYS;
+}
+
+static void
+hwrng_unregister(struct hwrng *rng)
+{
+}
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,18)) */
 
 #endif /* LINUX_26_18_COMPAT_H */
-- 
1.7.2.30.gc37d7.dirty

