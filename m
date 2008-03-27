Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:48547 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757221AbYC0LdE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2008 07:33:04 -0400
Subject: net-2.6.26 compilation is still broken
From: "Denis V. Lunev" <den@openvz.org>
To: David Miller <davem@davemloft.net>
Cc: Netdev List <netdev@vger.kernel.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Thu, 27 Mar 2008 14:33:33 +0300
Message-Id: <1206617613.32459.3.camel@iris.sw.ru> (sfid-20080327_113327_777727_99C80D60)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, Dave!

Under 'make allyesconfig' net-2.6.26 on x86_64 compilation is broken
here:
artemis ~/src/linux-netns26 $ make O=all     
  Using /home/den/src/linux-netns26 as source for kernel
  GEN     /home/den/src/linux-netns26/all/Makefile
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    /home/den/src/linux-netns26/scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  LD      drivers/built-in.o
  LD      net/built-in.o
net/ieee80211/built-in.o: In function `ieee80211_get_channel':
/home/den/src/linux-netns26/net/ieee80211/ieee80211_geo.c:176: multiple
definition of `ieee80211_get_channel'
net/wireless/built-in.o:/home/den/src/linux-netns26/net/wireless/util.c:38: first defined here
ld: Warning: size of symbol `ieee80211_get_channel' changed from 98 in
net/wireless/built-in.o to 68 in net/ieee80211/built-in.o
net/ieee80211/built-in.o: In function `__crc_ieee80211_get_channel':
(*ABS*+0xa51295ec): multiple definition of `__crc_ieee80211_get_channel'
make[2]: *** [net/built-in.o] Error 1
make[1]: *** [net] Error 2
make: *** [sub-make] Error 2
artemis ~/src/linux-netns26 $

Regards,
	Den

