Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39164 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845Ab1B0Nty (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Feb 2011 08:49:54 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat: add tty_set_termios only for kernel >= 2.6.27
Date: Sun, 27 Feb 2011 14:49:44 +0100
Message-Id: <1298814584-11779-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

tty_set_termios does not build with older kernel versions and is only
needed by bluetooth which works only for kernel >= 2.6.27.

Reported-by: Juan Carlos Garza <juancarlosgarza@gmail.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.39.c        |    2 ++
 include/linux/compat-2.6.39.h |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/compat/compat-2.6.39.c b/compat/compat-2.6.39.c
index c2966f7..8d85877 100644
--- a/compat/compat-2.6.39.c
+++ b/compat/compat-2.6.39.c
@@ -11,6 +11,7 @@
 #include <linux/compat.h>
 #include <linux/tty.h>
 
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27))
 /*
  *		Termios Helper Methods
  */
@@ -108,4 +109,5 @@ int tty_set_termios(struct tty_struct *tty, struct ktermios *new_termios)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(tty_set_termios);
+#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)) */
 
diff --git a/include/linux/compat-2.6.39.h b/include/linux/compat-2.6.39.h
index 1c7b322..0c4f030 100644
--- a/include/linux/compat-2.6.39.h
+++ b/include/linux/compat-2.6.39.h
@@ -27,7 +27,9 @@
 #define tiocmget(tty) tiocmget(tty, NULL)
 #define tiocmset(tty, set, clear) tiocmset(tty, NULL, set, clear)
 
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27))
 extern int tty_set_termios(struct tty_struct *tty, struct ktermios *kt);
+#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)) */
 
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,39)) */
 
-- 
1.7.1

