Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:29938 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381AbZHFN0N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 09:26:13 -0400
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id n76DPoEx014623
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2009 08:25:55 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: kalle.valo@nokia.com, juuso.oikarinen@nokia.com
Subject: [PATCH 0/2] wl1271: driver for the TI WL1271 chipset
Date: Thu,  6 Aug 2009 16:25:27 +0300
Message-Id: <1249565129-12677-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

As you probably already know, we have been working on the next generation of
the TI WiLink chipset, which the successor of wl1251.

This driver is a spin-off of the wl12xx driver.  Initially we were planning
to have support for both chipsets in the same driver, because there were some
similarities, but in the end we figured out that the differences were much
bigger than expected and the code was getting a bit of an abstraction mess.
So we decided to split it in two.  A lot of the code is still very similar,
but most of it is because we haven't revisited the old code and still haven't
made the necessary updates for the new chipset.  In the future, we're
planning to identify the common parts and reuse the same code in both
drivers.

This driver is still a work in progress with a few features still missing,
but to facilitate the work across different companies and for those who are
brave of heart and want to use a work-in-progress driver to help with testing
and development, I think it's time to get it included in the wireless-testing
tree.

More information about this chipset can be found here:
    http://focus.ti.com/general/docs/wtbu/wtbuproductcontent.tsp?templateId=6123&navigationId=12762&contentId=29993

The current driver is not functional on top of the latest wireless-testing
tags, because of a change in the way filtering is handled (see Kalle Valo's
email regarding this issue with wl1251).  But I will soon send a patch with a
hack that disables all filtering (similar to the one Kalle sent) that can be
used before the final solution is ready.  With that patch the driver works
and supports managed mode to connect to open and WEP access points.  Support
for WPA will come soon.  I have tested it on top of wireless-testing tag
master-2009-08-04 and scanning, association, udhcpc and ping works fine.

Comments, questions, suggestions and general reviews would be greatly
appreciated!

Cheers,
Luca.


Luciano Coelho (2):
  wl1271: add wl1271 driver files
  wl1271: add wl1271 to Kconfig and the Makefile

 drivers/net/wireless/wl12xx/Kconfig          |   12 +
 drivers/net/wireless/wl12xx/Makefile         |    6 +
 drivers/net/wireless/wl12xx/wl1271.h         |  407 ++++++++
 drivers/net/wireless/wl12xx/wl1271_acx.c     |  961 ++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_acx.h     | 1221 ++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_boot.c    |  540 ++++++++++
 drivers/net/wireless/wl12xx/wl1271_boot.h    |   72 ++
 drivers/net/wireless/wl12xx/wl1271_cmd.c     |  813 +++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_cmd.h     |  464 +++++++++
 drivers/net/wireless/wl12xx/wl1271_debugfs.c |  518 ++++++++++
 drivers/net/wireless/wl12xx/wl1271_debugfs.h |   33 +
 drivers/net/wireless/wl12xx/wl1271_event.c   |  125 +++
 drivers/net/wireless/wl12xx/wl1271_event.h   |  110 ++
 drivers/net/wireless/wl12xx/wl1271_init.c    |  397 ++++++++
 drivers/net/wireless/wl12xx/wl1271_init.h    |  115 +++
 drivers/net/wireless/wl12xx/wl1271_main.c    | 1396 ++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_ps.c      |  142 +++
 drivers/net/wireless/wl12xx/wl1271_ps.h      |   35 +
 drivers/net/wireless/wl12xx/wl1271_reg.h     |  758 ++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_rx.c      |  200 ++++
 drivers/net/wireless/wl12xx/wl1271_rx.h      |  121 +++
 drivers/net/wireless/wl12xx/wl1271_spi.c     |  382 +++++++
 drivers/net/wireless/wl12xx/wl1271_spi.h     |  113 +++
 drivers/net/wireless/wl12xx/wl1271_tx.c      |  378 +++++++
 drivers/net/wireless/wl12xx/wl1271_tx.h      |  130 +++
 25 files changed, 9449 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/wl12xx/wl1271.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_acx.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_acx.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_boot.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_boot.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_cmd.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_cmd.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_debugfs.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_debugfs.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_event.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_event.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_init.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_init.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_main.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_ps.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_ps.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_reg.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_rx.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_rx.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_spi.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_spi.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_tx.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_tx.h

