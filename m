Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49151 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966231Ab2EPKFk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 06:05:40 -0400
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: mcgrof@kernel.org
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	=?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH] compat: backport ether_addr_equal
Date: Wed, 16 May 2012 12:55:48 +0300
Message-Id: <1337162148-16499-1-git-send-email-ozancag@gmail.com> (sfid-20120516_120545_705299_61BE72B6)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This backports:

    commit a599b0f54d233d0f63d6be9a2ff0049d24751669
    Author: Joe Perches <joe@perches.com>
    Date:   Tue May 8 18:56:45 2012 +0000

        etherdevice.h: Add ether_addr_equal

        Add a boolean function to check if 2 ethernet addresses
        are the same.

        This is to avoid any confusion about compare_ether_addr
        returning an unsigned, and not being able to use the
        compare_ether_addr function for sorting ala memcmp.

        Signed-off-by: Joe Perches <joe@perches.com>
        Signed-off-by: David S. Miller <davem@davemloft.net>

[root@ozzyfedora compat]# bin/ckmake
Trying kernel                      3.3.4-5.fc17.x86_64  [OK]

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 include/linux/compat-3.5.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/compat-3.5.h b/include/linux/compat-3.5.h
index 554d347..a83266b 100644
--- a/include/linux/compat-3.5.h
+++ b/include/linux/compat-3.5.h
@@ -3,6 +3,7 @@
 
 #include <linux/version.h>
 #include <linux/fs.h>
+#include <linux/etherdevice.h>
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(3,5,0))
 
@@ -12,6 +13,12 @@ extern int simple_open(struct inode *inode, struct file *file);
 #define tty_lock(__tty) tty_lock()
 #define tty_unlock(__tty) tty_unlock()
 
+/* Backport ether_addr_equal */
+static inline bool ether_addr_equal(const u8 *addr1, const u8 *addr2)
+{
+    return !compare_ether_addr(addr1, addr2);
+}
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,5,0)) */
 
 #endif /* LINUX_3_5_COMPAT_H */
-- 
1.7.10.1

