Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:51801 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbZDWQkK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 12:40:10 -0400
Received: by fxm2 with SMTP id 2so649862fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 23 Apr 2009 09:40:08 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Cc: luciano.coelho@nokia.com, Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org
Subject: wl12xx: third submission
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 23 Apr 2009 19:40:05 +0300
Message-ID: <87ab67b9y2.fsf@litku.valot.fi> (sfid-20090423_184017_459971_979DD6FE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here is the third (and hopefully last) submission of wl12xx, a driver
for TI wl1251 chipset:

http://www.valot.fi/kalle/tmp/wl12xx/20090423/

Changes since second submission:

o remove mach includes to make it compile in wireless-testing

Changes since first submission from February 10:

o update to 2.6.29 (bob)
o sysfs interface removed (bob)
o netlink interface removed
o lots of bug fixes
o platform data for proper board file support

Please consider for including the driver to wireless-testing. Bob is
planning to add SDIO support to the driver and it's easier for us to
have the driver in wireless-testing. And if all goes well, it would be
nice to get the driver into 2.6.31. But that's up to you, of course.

The diffstat:

 drivers/net/wireless/Kconfig               |    1 +
 drivers/net/wireless/Makefile              |    2 +
 drivers/net/wireless/wl12xx/Kconfig        |   11 +
 drivers/net/wireless/wl12xx/Makefile       |    4 +
 drivers/net/wireless/wl12xx/acx.c          |  689 ++++++++++++++
 drivers/net/wireless/wl12xx/acx.h          | 1245 +++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/boot.c         |  295 ++++++
 drivers/net/wireless/wl12xx/boot.h         |   40 +
 drivers/net/wireless/wl12xx/cmd.c          |  353 +++++++
 drivers/net/wireless/wl12xx/cmd.h          |  265 ++++++
 drivers/net/wireless/wl12xx/debugfs.c      |  508 ++++++++++
 drivers/net/wireless/wl12xx/debugfs.h      |   33 +
 drivers/net/wireless/wl12xx/event.c        |  127 +++
 drivers/net/wireless/wl12xx/event.h        |  121 +++
 drivers/net/wireless/wl12xx/init.c         |  200 ++++
 drivers/net/wireless/wl12xx/init.h         |   40 +
 drivers/net/wireless/wl12xx/main.c         | 1375 ++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/ps.c           |  151 +++
 drivers/net/wireless/wl12xx/ps.h           |   36 +
 drivers/net/wireless/wl12xx/reg.h          |  745 +++++++++++++++
 drivers/net/wireless/wl12xx/rx.c           |  208 +++++
 drivers/net/wireless/wl12xx/rx.h           |  122 +++
 drivers/net/wireless/wl12xx/spi.c          |  358 ++++++++
 drivers/net/wireless/wl12xx/spi.h          |  109 +++
 drivers/net/wireless/wl12xx/tx.c           |  557 +++++++++++
 drivers/net/wireless/wl12xx/tx.h           |  215 +++++
 drivers/net/wireless/wl12xx/wl1251.c       |  709 ++++++++++++++
 drivers/net/wireless/wl12xx/wl1251.h       |  165 ++++
 drivers/net/wireless/wl12xx/wl12xx.h       |  409 +++++++++
 drivers/net/wireless/wl12xx/wl12xx_80211.h |  156 ++++
 include/linux/spi/wl12xx.h                 |   31 +
 31 files changed, 9280 insertions(+), 0 deletions(-)

-- 
Kalle Valo
