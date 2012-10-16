Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:33404 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599Ab2JPT3j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2012 15:29:39 -0400
Received: by mail-la0-f46.google.com with SMTP id h6so4443643lag.19
        for <linux-wireless@vger.kernel.org>; Tue, 16 Oct 2012 12:29:38 -0700 (PDT)
From: Pontus Fuchs <pontus.fuchs@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, hch@lst.de, s.L-H@gmx.de,
	Pontus Fuchs <pontus.fuchs@gmail.com>
Subject: [PATCH v2 0/4] Driver for the ar5523 chipset
Date: Tue, 16 Oct 2012 21:29:25 +0200
Message-Id: <1350415769-8271-1-git-send-email-pontus.fuchs@gmail.com> (sfid-20121016_212943_258257_CEACED65)
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

Changes v1 to v2:

* Place driver in drivers/net/wireless/ath instead of staging.
* Change to same license as ath9k as suggested by Luis.
* Add comment about shutting up errors on USB disconnect.
* Use ALIGN() / IS_ALIGNED() for alignment fix / check.
* Fix whitespace on file ending.
* Bugfix: Avoid % 512 transfer sizes on TX as the FW will hang.
* Bugfix: Change filtering so that [mb]cast are properly RXed.

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
 drivers/net/wireless/ath/ar5523/ar5523.c    | 1816 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ar5523/ar5523.h    |  155 +++
 drivers/net/wireless/ath/ar5523/ar5523_hw.h |  434 +++++++
 8 files changed, 2421 insertions(+)
 create mode 100644 drivers/net/wireless/ath/ar5523/Kconfig
 create mode 100644 drivers/net/wireless/ath/ar5523/Makefile
 create mode 100644 drivers/net/wireless/ath/ar5523/ar5523.c
 create mode 100644 drivers/net/wireless/ath/ar5523/ar5523.h
 create mode 100644 drivers/net/wireless/ath/ar5523/ar5523_hw.h

-- 
1.7.9.5

