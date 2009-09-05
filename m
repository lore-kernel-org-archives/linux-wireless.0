Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:42929 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757284AbZIEKzF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Sep 2009 06:55:05 -0400
Received: by ewy2 with SMTP id 2so1036042ewy.17
        for <linux-wireless@vger.kernel.org>; Sat, 05 Sep 2009 03:55:05 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 5 Sep 2009 12:55:05 +0200
Message-ID: <2d0a357f0909050355r381b12fei33930141cfbd8893@mail.gmail.com>
Subject: compat-wireless-2009-09-05: error: implicit declaration of function
	?kmemleak_ignore?
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

todays compat-wireless (2009-09-05) is broken.

Error looks like this:
[...]
  CC [M]  /home/sd/src/compat-wireless/compat-wireless-2009-09-05/net/mac80211/rc80211_minstrel.o
  LD [M]  /home/sd/src/compat-wireless/compat-wireless-2009-09-05/net/mac80211/mac80211.o
  LD      /home/sd/src/compat-wireless/compat-wireless-2009-09-05/net/rfkill/built-in.o
  LD      /home/sd/src/compat-wireless/compat-wireless-2009-09-05/net/wireless/built-in.o
  CC [M]  /home/sd/src/compat-wireless/compat-wireless-2009-09-05/net/wireless/core.o
  CC [M]  /home/sd/src/compat-wireless/compat-wireless-2009-09-05/net/wireless/sysfs.o
  CC [M]  /home/sd/src/compat-wireless/compat-wireless-2009-09-05/net/wireless/radiotap.o
  CC [M]  /home/sd/src/compat-wireless/compat-wireless-2009-09-05/net/wireless/util.o
  CC [M]  /home/sd/src/compat-wireless/compat-wireless-2009-09-05/net/wireless/reg.o
  CC [M]  /home/sd/src/compat-wireless/compat-wireless-2009-09-05/net/wireless/scan.o
/home/sd/src/compat-wireless/compat-wireless-2009-09-05/net/wireless/scan.c:
In function ‘cfg80211_inform_bss’:
/home/sd/src/compat-wireless/compat-wireless-2009-09-05/net/wireless/scan.c:503:
error: implicit declaration of function ‘kmemleak_ignore’
make[5]: *** [/home/sd/src/compat-wireless/compat-wireless-2009-09-05/net/wireless/scan.o]
Error 1
make[4]: *** [/home/sd/src/compat-wireless/compat-wireless-2009-09-05/net/wireless]
Error 2
make[3]: *** [_module_/home/sd/src/compat-wireless/compat-wireless-2009-09-05]
Error 2
make[2]: *** [sub-make] Error 2
make[1]: *** [all] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.31-rc8-radeonkms-686'

This fixed the issue here:

----- SNIP -----
--- net/wireless/scan.c.orig	2009-09-05 06:57:36.000000000 +0200
+++ net/wireless/scan.c	2009-09-05 12:38:09.644616605 +0200
@@ -15,6 +15,7 @@
 #include "core.h"
 #include "nl80211.h"
 #include "wext-compat.h"
+#include <linux/kmemleak.h>

 #define IEEE80211_SCAN_RESULT_EXPIRE	(15 * HZ)
----- SNAP -----

Kind Regards,
Sedat
