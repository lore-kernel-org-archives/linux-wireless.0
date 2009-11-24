Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:48713 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757410AbZKXC0I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 21:26:08 -0500
Received: by mail-yx0-f187.google.com with SMTP id 17so5308557yxe.33
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2009 18:26:15 -0800 (PST)
Message-ID: <4B0B4405.4050605@gmail.com>
Date: Mon, 23 Nov 2009 21:25:09 -0500
From: Arnaud Lacombe <lacombar@gmail.com>
MIME-Version: 1.0
To: mcgrof@bombadil.infradead.org
CC: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Subject: [PATCH 08/13] Add compatibility macro for register_sysctl_table()
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The API was changed on commit 0b4d4147. register_sysctl_table() lost its
last
argument.

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 compat-2.6.21.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/compat-2.6.21.h b/compat-2.6.21.h
index c185cfb..263ebd2 100644
--- a/compat-2.6.21.h
+++ b/compat-2.6.21.h
@@ -7,6 +7,13 @@
 /* Compat work for 2.6.21 */
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21))

+#include <linux/sysctl.h>
+
+#define register_sysctl_table(table)				\
+	({							\
+		register_sysctl_table((table), 0);		\
+	})
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) */

 #endif /* LINUX_26_21_COMPAT_H */
-- 
1.6.3.3.385.g60647.dirty


