Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tomasu.net ([64.85.170.232]:36506 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754723Ab3GTSpJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Jul 2013 14:45:09 -0400
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
To: linux-wireless@vger.kernel.org
Reply-To: thomas@fjellstrom.ca
Subject: wil6210 driver compilation failure
Date: Sat, 20 Jul 2013 12:37:02 -0600
Message-ID: <6363399.uASIm9rubl@balsa> (sfid-20130720_204513_968685_45EB1A4E)
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, 

Recently while trying to figure out a separate issue, I did a
make allmodconfig and a make oldconfig with debian's default config on
the 3.10.1 kernel, and debian's config with 3.10.0.

It failed in the wil6210 driver.

The system it failed on is running a fresh install of Debian Sid, with gcc
4.8.1.

This is the error I got:

  CC [M]  drivers/net/wireless/ath/wil6210/debugfs.o
drivers/net/wireless/ath/wil6210/debugfs.c: In function âwil_print_ringâ:
drivers/net/wireless/ath/wil6210/debugfs.c:163:11: error: pointer targets in passing argument 5 of âhex_dump_to_bufferâ differ in signedness [-Werror=pointer-sign]
           false);
           ^
In file included from include/linux/kernel.h:13:0,
                 from include/linux/cache.h:4,
                 from include/linux/time.h:4,
                 from include/linux/stat.h:18,
                 from include/linux/module.h:10,
                 from drivers/net/wireless/ath/wil6210/debugfs.c:17:
include/linux/printk.h:361:13: note: expected âchar *â but argument is of type âunsigned char *â
 extern void hex_dump_to_buffer(const void *buf, size_t len,
             ^
drivers/net/wireless/ath/wil6210/debugfs.c: In function âwil_txdesc_debugfs_showâ:
drivers/net/wireless/ath/wil6210/debugfs.c:429:10: error: pointer targets in passing argument 5 of âhex_dump_to_bufferâ differ in signedness [-Werror=pointer-sign]
          sizeof(printbuf), false);
          ^
In file included from include/linux/kernel.h:13:0,
                 from include/linux/cache.h:4,
                 from include/linux/time.h:4,
                 from include/linux/stat.h:18,
                 from include/linux/module.h:10,
                 from drivers/net/wireless/ath/wil6210/debugfs.c:17:
include/linux/printk.h:361:13: note: expected âchar *â but argument is of type âunsigned char *â
 extern void hex_dump_to_buffer(const void *buf, size_t len,
             ^
cc1: all warnings being treated as errors
make[5]: *** [drivers/net/wireless/ath/wil6210/debugfs.o] Error 1
make[4]: *** [drivers/net/wireless/ath/wil6210] Error 2
make[3]: *** [drivers/net/wireless/ath] Error 2
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2

please excuse the mangled quotes, fresh install and I negelected to set up
the locale properly. It's fixed now, but it seems I need to restart X for it to
notice.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
