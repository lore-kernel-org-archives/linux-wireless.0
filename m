Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42582 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab2JKUCA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2012 16:02:00 -0400
Received: by mail-lb0-f174.google.com with SMTP id n3so1584839lbo.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Oct 2012 13:01:58 -0700 (PDT)
From: Pontus Fuchs <pontus.fuchs@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, hch@lst.de, s.L-H@gmx.de,
	Pontus Fuchs <pontus.fuchs@gmail.com>
Subject: [PATCH 0/4] Driver for the ar5523 chipset
Date: Thu, 11 Oct 2012 22:01:38 +0200
Message-Id: <1349985702-21322-1-git-send-email-pontus.fuchs@gmail.com> (sfid-20121011_220205_194774_7A40AA3E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some time ago I found an old USB wireless dongle in my drawer. I was
surprised it wasn't supported in Linux. Google gave me an old
unfinished driver created by Christoph Hellwig. Armed with some
spare time and naivity I picked up where Christoph left in 2007 and
now it's actually working pretty fine. It does not crash for me and
throughput is decent.

It's based on the FreeBSD driver, which in turn is based on the
reverse engineered Windows driver, hence a very limited feature set.
Not even HW crypto offload is supported. But at least there is a
firmware which has a suitable license:

http://www.freebsd.org/cgi/cvsweb.cgi/src/sys/contrib/dev/uath/ar5523.bin.uu

Pontus Fuchs (4):
  ar5523: Add main driver file
  ar5523: Add driver header file
  ar5523: Add Firmware API header file
  ar5523: Add Kconfig and Makefile

 drivers/staging/Kconfig            |    2 +
 drivers/staging/Makefile           |    1 +
 drivers/staging/ar5523/Kconfig     |    7 +
 drivers/staging/ar5523/Makefile    |    1 +
 drivers/staging/ar5523/ar5523.c    | 1824 ++++++++++++++++++++++++++++++++++++
 drivers/staging/ar5523/ar5523.h    |  164 ++++
 drivers/staging/ar5523/ar5523_hw.h |  447 +++++++++
 7 files changed, 2446 insertions(+)
 create mode 100644 drivers/staging/ar5523/Kconfig
 create mode 100644 drivers/staging/ar5523/Makefile
 create mode 100644 drivers/staging/ar5523/ar5523.c
 create mode 100644 drivers/staging/ar5523/ar5523.h
 create mode 100644 drivers/staging/ar5523/ar5523_hw.h

-- 
1.7.9.5

