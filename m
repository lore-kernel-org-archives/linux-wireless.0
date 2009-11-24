Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:39830 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757716AbZKXCZO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 21:25:14 -0500
Received: by mail-yx0-f187.google.com with SMTP id 17so5307924yxe.33
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2009 18:25:21 -0800 (PST)
Message-ID: <4B0B43CF.1000102@gmail.com>
Date: Mon, 23 Nov 2009 21:24:15 -0500
From: Arnaud Lacombe <lacombar@gmail.com>
MIME-Version: 1.0
To: mcgrof@bombadil.infradead.org
CC: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Subject: [PATCH 04/13] Add roundup() compatibility macro
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added on commit b4cac1a0 by David Howells in include/linux/kernel.h.

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 compat-2.6.18.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/compat-2.6.18.h b/compat-2.6.18.h
index 077f28b..3245c42 100644
--- a/compat-2.6.18.h
+++ b/compat-2.6.18.h
@@ -7,6 +7,8 @@
 /* Compat work for 2.6.18 */
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,18))

+#define roundup(x, y)	((((x) + ((y) - 1)) / (y)) * (y))
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,18)) */

 #endif /* LINUX_26_18_COMPAT_H */
-- 
1.6.3.3.385.g60647.dirty


