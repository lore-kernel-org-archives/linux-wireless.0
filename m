Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44994 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223Ab2JWSeJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2012 14:34:09 -0400
Received: by mail-lb0-f174.google.com with SMTP id n3so558125lbo.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Oct 2012 11:34:07 -0700 (PDT)
From: Pontus Fuchs <pontus.fuchs@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, hch@lst.de, s.L-H@gmx.de,
	Pontus Fuchs <pontus.fuchs@gmail.com>
Subject: [PATCH v3 0/4]  Driver for the ar5523 chipset
Date: Tue, 23 Oct 2012 20:33:56 +0200
Message-Id: <1351017240-2797-1-git-send-email-pontus.fuchs@gmail.com> (sfid-20121023_203414_836689_C4EED534)
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

Changes v2 to v3:

* Replace homebrew workaround with USB_ZERO_PACKET.
* Sort and clean up copyright holders.

Pontus Fuchs (4):
  ar5523: Add main driver file
  ar5523: Add driver header file
  Add Firmware API header file
  Add Kconfig and Makefile. Add MAINTAINERS entry

 MAINTAINERS                                 |    6 +
 drivers/net/wireless/ath/Kconfig            |    1 +
 drivers/net/wireless/ath/Makefile           |    1 +
 drivers/net/wireless/ath/ar5523/Kconfig     |    7 +
 drivers/net/wireless/ath/ar5523/Makefile    |    1 +
 drivers/net/wireless/ath/ar5523/ar5523.c    | 1806 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ar5523/ar5523.h    |  152 +++
 drivers/net/wireless/ath/ar5523/ar5523_hw.h |  431 +++++++
 8 files changed, 2405 insertions(+)
 create mode 100644 drivers/net/wireless/ath/ar5523/Kconfig
 create mode 100644 drivers/net/wireless/ath/ar5523/Makefile
 create mode 100644 drivers/net/wireless/ath/ar5523/ar5523.c
 create mode 100644 drivers/net/wireless/ath/ar5523/ar5523.h
 create mode 100644 drivers/net/wireless/ath/ar5523/ar5523_hw.h

-- 
1.7.9.5

