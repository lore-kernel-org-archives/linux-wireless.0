Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:60070 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203Ab1GVQvV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 12:51:21 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat: add include/crypto/aes.h
Date: Fri, 22 Jul 2011 18:51:10 +0200
Message-Id: <1311353470-31012-2-git-send-email-hauke@hauke-m.de> (sfid-20110722_185123_538417_AB1A6ABA)
In-Reply-To: <1311353470-31012-1-git-send-email-hauke@hauke-m.de>
References: <1311353470-31012-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/crypto/aes.h |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)
 create mode 100644 include/crypto/aes.h

diff --git a/include/crypto/aes.h b/include/crypto/aes.h
new file mode 100644
index 0000000..8031a54
--- /dev/null
+++ b/include/crypto/aes.h
@@ -0,0 +1,21 @@
+#ifndef _COMPAT_CRYPTO_AES_H
+#define _COMPAT_CRYPTO_AES_H
+
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,24))
+#include_next <crypto/aes.h>
+#else
+
+#define AES_MIN_KEY_SIZE	16
+#define AES_MAX_KEY_SIZE	32
+#define AES_KEYSIZE_128		16
+#define AES_KEYSIZE_192		24
+#define AES_KEYSIZE_256		32
+#define AES_BLOCK_SIZE		16
+#define AES_MAX_KEYLENGTH	(15 * 16)
+#define AES_MAX_KEYLENGTH_U32	(AES_MAX_KEYLENGTH / sizeof(u32))
+
+#endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,24)) */
+
+#endif
-- 
1.7.4.1

