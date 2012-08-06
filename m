Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59038 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756150Ab2HFWe4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 18:34:56 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/3] compat-wireless: add missing part to tty-termios backport
Date: Tue,  7 Aug 2012 00:34:45 +0200
Message-Id: <1344292486-25736-2-git-send-email-hauke@hauke-m.de> (sfid-20120807_003500_838318_10408A89)
In-Reply-To: <1344292486-25736-1-git-send-email-hauke@hauke-m.de>
References: <1344292486-25736-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This part was missing in the original patch

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/63-tty-termios.patch |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/patches/63-tty-termios.patch b/patches/63-tty-termios.patch
index b868ae9..0841106 100644
--- a/patches/63-tty-termios.patch
+++ b/patches/63-tty-termios.patch
@@ -33,3 +33,17 @@ was not done through a static inline helper.
  	ktermios.c_cflag &= ~CRTSCTS;
  	tty_set_termios(tty, &ktermios);
  
+--- a/net/bluetooth/rfcomm/tty.c
++++ b/net/bluetooth/rfcomm/tty.c
+@@ -873,7 +873,11 @@ static int rfcomm_tty_ioctl(struct tty_s
+ 
+ static void rfcomm_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
+ {
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,7,0))
+ 	struct ktermios *new = &tty->termios;
++#else
++	struct ktermios *new = tty->termios;
++#endif
+ 	int old_baud_rate = tty_termios_baud_rate(old);
+ 	int new_baud_rate = tty_termios_baud_rate(new);
+ 
-- 
1.7.9.5

