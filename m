Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44636 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755697Ab2FVVER (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 17:04:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1SiB1a-0001ma-VI
	for linux-wireless@vger.kernel.org; Fri, 22 Jun 2012 23:04:15 +0200
Received: from 141.215.212.197 ([141.215.212.197])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jun 2012 23:04:14 +0200
Received: from ilhebe999 by 141.215.212.197 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jun 2012 23:04:14 +0200
To: linux-wireless@vger.kernel.org
From: Xun Ouyang <ilhebe999@gmail.com>
Subject: please help me, fedora make modules error
Date: Fri, 22 Jun 2012 21:04:05 +0000 (UTC)
Message-ID: <loom.20120622T225528-225@post.gmane.org> (sfid-20120622_230420_944627_64D66763)
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After I install ncurses-devel, I used the command menuconfig, but I did not 
change anything, just the default value, and then , "make modules'


[root@linux123 wireless-testing]# make modules
make[1]: Nothing to be done for `all'.
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CC [M]  drivers/net/wireless/at76c50x-usb.o
In file included from drivers/net/wireless/at76c50x-usb.c:46:0:
include/net/mac80211.h: In function ‘ieee80211_tx_info_clear_status’:
include/net/mac80211.h:639:2: error: size of unnamed array is negative
include/net/mac80211.h:644:2: error: size of unnamed array is negative
make[3]: *** [drivers/net/wireless/at76c50x-usb.o] Error 1
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2

The content in line 639 and 644 are all:like 
BUILD_BUG_ON(offsetof(struct XXXXXXX) !=XXX);

If I comment this line out, it "seems" this problem fixed.
And I tried to make modules again, the same error(BUILD_BUG_ON
(offsetof(struct XXXXXXX) !=XXX);)  came out but different
file, different lines.And repeatedly.
I do not think there are so many error that need to be fixed since I
just change a few lines of codes which seems unrelated to theses errors.

  
I really do not know what to do.Anyone can help me? Thank you so much.

