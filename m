Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65142 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800Ab0KJCVI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:21:08 -0500
Received: by mail-qw0-f46.google.com with SMTP id 5so5749qwh.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:21:08 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 13/44] compat/2.6.25: don't include <linux/{io,leds}.h> prior to 2.6.17
Date: Tue,  9 Nov 2010 21:19:55 -0500
Message-Id: <1289355626-25373-14-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.25.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.25.h b/include/linux/compat-2.6.25.h
index 641fbde..6183a89 100644
--- a/include/linux/compat-2.6.25.h
+++ b/include/linux/compat-2.6.25.h
@@ -7,8 +7,10 @@
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,25))
 
 #include <linux/types.h>
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,17))
 #include <linux/io.h>
 #include <linux/leds.h>
+#endif
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,18))
 #include <linux/hw_random.h>
 #endif
-- 
1.7.2.30.gc37d7.dirty

