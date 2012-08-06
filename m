Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59037 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756180Ab2HFWe4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 18:34:56 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/3] compat-wireless: the tty termios change is not in 3.6-rc1
Date: Tue,  7 Aug 2012 00:34:44 +0200
Message-Id: <1344292486-25736-1-git-send-email-hauke@hauke-m.de> (sfid-20120807_003501_697074_46661C4B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The api change this patch is needed for is not in kernel 3.6-rc1.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/63-tty-termios.patch |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/patches/63-tty-termios.patch b/patches/63-tty-termios.patch
index dd7c300..b868ae9 100644
--- a/patches/63-tty-termios.patch
+++ b/patches/63-tty-termios.patch
@@ -25,7 +25,7 @@ was not done through a static inline helper.
  		return status;
  
  	/* Disable Automatic RTSCTS */
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0))
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,7,0))
  	ktermios = tty->termios;
 +#else
 +	memcpy(&ktermios, tty->termios, sizeof(ktermios));
-- 
1.7.9.5

