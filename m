Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:59249 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759723Ab3EORWR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 13:22:17 -0400
Received: by mail-la0-f46.google.com with SMTP id fk20so2038947lab.19
        for <linux-wireless@vger.kernel.org>; Wed, 15 May 2013 10:22:15 -0700 (PDT)
MIME-Version: 1.0
From: Randy Li <randylxr@gmail.com>
Date: Thu, 16 May 2013 01:21:53 +0800
Message-ID: <CAA0gq31cpv6f=JgChxTBPcmOXXzgL0hXnHzHYdvSZH-MZTUUKw@mail.gmail.com> (sfid-20130515_192220_633710_975B0EE9)
Subject: AR6003 SDIO can't received data if you didn't send any date for a while
To: linux-wireless@vger.kernel.org
Cc: ath6kl-devel@qualcomm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I use this WNIC in a s3c6410 devboard called OK6410 made by
forlinx(http://www.forlinx.net/Other/6.htm)

The kernel is 3.0.1, the driver in the kernel source can't work. So I
tried compat-wireless-3.3-2-n and
compat-wireless-3.5.4-1. 3.3-2 is eaier to get -101 error when I load
the modules, in this time I have to replug WNIC card.

When networking is connected, I can't ping ar6003 in the other place,
if ar6003 didn't send any data
recently.Once ar6003 stoped sending, I can't send to ar6003 after a
very little while.

But if I send large data like video both of them still stop working
after a while, 3.3-2(about 5 minutes) seems to work more longer than
3.5.4-1(about 1 mintue). But both ip link and iw wlan0 link show my
link is up. I have to ifdown and ifup to use wireless again.

kvalo said it cause by irq problem.But when I compiled compat-wireless
with debug, I only have files in /sys/kernel/debug/ieee80211/
phy0/ , but there is ath6kl directory there. I have enabled all
debug_mask, but I don't get any irq infomation frome dmesg.

Could you tell me the correct way enable debug in compiling and load module?
P.S how to install compat-wireless? I can't use INSTALL_MOD_PATH, I
have to copy these directory and use find tool to remove .c .h .o
files.

Here is output of /proc/interrupts in ok6410

          CPU0
 16:          3  s3c-uart  s3c6400-uart
 18:        240  s3c-uart  s3c6400-uart
 20:          2  s3c-uart
 22:         48  s3c-uart
 35:          0       VIC  s3c-fimc0
 36:          0       VIC  s3c-fimc1
 40:          0       VIC  s3c-g3d
 41:          0       VIC  s3c-pp
 42:          0       VIC  s3c-rotator
 43:          0       VIC  s3c-g2d
 44:          0       VIC  TV_ENCODER
 45:          0       VIC  TV_SCALER
 47:          0       VIC  s3c-jpeg
 48:       4735       VIC  s3c-mfc
 54:          0       VIC  s3c-keypad
 58:          0       VIC  s3c2410-wdt
 62:     460074       VIC  s3c-lcd
 68:         26       VIC  AC97
 73:          0       VIC  DMA
 74:          0       VIC  DMA
 79:     177847       VIC  ohci_hcd:usb1
 82:        123       VIC  s3c2440-i2c.0
 88:      46540       VIC  mmc0
 94:          0       VIC  s3c_updown
 95:          0       VIC  adc, s3c_action
100:     727214  s3c-timer  S3C2410 Timer Tick
101:          0  s3c-eint  BUTTON1
102:          0  s3c-eint  BUTTON2
103:          0  s3c-eint  BUTTON3
104:          0  s3c-eint  BUTTON4
105:          0  s3c-eint  BUTTON5
106:          0  s3c-eint  BUTTON6
108:      59168  s3c-eint  eth0
Err:          0



-----
ayaka
