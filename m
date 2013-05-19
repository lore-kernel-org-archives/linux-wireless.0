Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21161 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab3ESQ2F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 May 2013 12:28:05 -0400
Date: Sun, 19 May 2013 11:27:58 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: mcgrof@kernel.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] backports: Fix menuconfig build
Message-ID: <5198fd8e.jScXWCVTcp8xL6Fp%Larry.Finger@lwfinger.net> (sfid-20130519_182823_302731_2998B6FC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Index: backports-3.10-rc1-1/kconfig/Makefile
===================================================================
--- backports-3.10-rc1-1.orig/kconfig/Makefile
+++ backports-3.10-rc1-1/kconfig/Makefile
@@ -3,7 +3,7 @@ CFLAGS=-Wall -Wmissing-prototypes -Wstri
 LXDIALOG := lxdialog/checklist.o lxdialog/inputbox.o lxdialog/menubox.o lxdialog/textbox.o lxdialog/util.o lxdialog/yesno.o
 
 conf: conf.o zconf.tab.o
-mconf: LDFLAGS = -Wl,--no-as-needed -lncurses
+mconf: LDFLAGS = -Wl,--no-as-needed -lncurses -ltinfo
 mconf: CFLAGS += -DCURSES_LOC="<ncurses.h>" -DLOCALE
 mconf: mconf.o zconf.tab.o $(LXDIALOG)
 
