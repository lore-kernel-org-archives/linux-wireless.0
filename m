Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:36942 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab3ESQoO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 May 2013 12:44:14 -0400
Received: by mail-oa0-f49.google.com with SMTP id k14so6753985oag.22
        for <linux-wireless@vger.kernel.org>; Sun, 19 May 2013 09:44:13 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: mcgrof@kernel.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 1/2 V2] backports: Fix menuconfig build
Date: Sun, 19 May 2013 11:43:55 -0500
Message-Id: <1368981836-6247-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20130519_184417_922542_5854E1C8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using openSUSE 12.3 with x86_64 architecture, the 'make menuconfig'
command results in the following:

finger@larrylap:~/backports-3.10-rc1-1> make menuconfig
cc -Wl,--no-as-needed -lncurses  mconf.o zconf.tab.o lxdialog/checklist.o lxdialog/inputbox.o lxdialog/menubox.o lxdialog/textbox.o lxdialog/util.o lxdialog/yesno.o   -o mconf
/usr/lib64/gcc/x86_64-suse-linux/4.7/../../../../x86_64-suse-linux/bin/ld: /lib64/libncurses.so.5: undefined reference to symbol 'acs_map'
/usr/lib64/gcc/x86_64-suse-linux/4.7/../../../../x86_64-suse-linux/bin/ld: note: 'acs_map' is defined in DSO /usr/lib64/gcc/x86_64-suse-linux/4.7/../../../../lib64/libtinfo.so so try adding it to the linker command line
/usr/lib64/gcc/x86_64-suse-linux/4.7/../../../../lib64/libtinfo.so: could not read symbols: Invalid operation
collect2: error: ld returned 1 exit status
make[2]: *** [mconf] Error 1
make[1]: *** [menuconfig] Error 2
make: *** [menuconfig] Error 2
finger@larrylap:~/backports-3.10-rc1-1>

When "-ltinfo" is added to the LDFLAGS symbol as suggested by the linker,
it builds and runs correctly.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

V2 in the proper format for git repository

Larry
---

 backport/kconfig/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/backport/kconfig/Makefile b/backport/kconfig/Makefile
index 5974e48..ff5c270 100644
--- a/backport/kconfig/Makefile
+++ b/backport/kconfig/Makefile
@@ -3,7 +3,7 @@ CFLAGS=-Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer
 LXDIALOG := lxdialog/checklist.o lxdialog/inputbox.o lxdialog/menubox.o lxdialog/textbox.o lxdialog/util.o lxdialog/yesno.o
 
 conf: conf.o zconf.tab.o
-mconf: LDFLAGS = -Wl,--no-as-needed -lncurses
+mconf: LDFLAGS = -Wl,--no-as-needed -lncurses -ltinfo
 mconf: CFLAGS += -DCURSES_LOC="<ncurses.h>" -DLOCALE
 mconf: mconf.o zconf.tab.o $(LXDIALOG)
 
-- 
1.8.1.4

