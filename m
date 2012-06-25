Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35476 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752537Ab2FYB7Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jun 2012 21:59:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1SiyaI-0002DC-D9
	for linux-wireless@vger.kernel.org; Mon, 25 Jun 2012 03:59:22 +0200
Received: from c-69-245-126-173.hsd1.mi.comcast.net ([69.245.126.173])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jun 2012 03:59:22 +0200
Received: from ilhebe999 by c-69-245-126-173.hsd1.mi.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jun 2012 03:59:22 +0200
To: linux-wireless@vger.kernel.org
From: Ouyang <ilhebe999@gmail.com>
Subject: make module error
Date: Mon, 25 Jun 2012 01:59:09 +0000 (UTC)
Message-ID: <loom.20120625T030454-300@post.gmane.org> (sfid-20120625_035929_686925_C9CBB124)
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kernel version:3.4.3-1.fc17.x86_64
I had already posted this problem several times and some specialist gave me some 
suggestions, thanks to them. the problems is still not solved even though I 
change my fedora 16 to fedora 17.

After I install ncurses-devel,copy a working kernel configuration of your linux 
distro to the top level of the wireless-testing tree ,I used the command 
menuconfig, but I did not change any setting of the menuconfig, just the default 
value, and then , "make modules': and it comes with:


In file included from drivers/net/wireless/at76c50x-usb.c:46:0:
include/net/mac80211.h: In function ‘ieee80211_tx_info_clear_status’:
include/net/mac80211.h:638:2: error: size of unnamed array is negative
include/net/mac80211.h:643:2: error: size of unnamed array is negative
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

