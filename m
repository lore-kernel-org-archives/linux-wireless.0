Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:65217 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752114AbZL3Kgt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2009 05:36:49 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Wireless list <linux-wireless@vger.kernel.org>,
	rt2x00 users list <users@rt2x00.serialmonkey.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 0/6] rt2x00 fixes and cleanups
Date: Wed, 30 Dec 2009 11:36:28 +0100
Message-Id: <1262169394-11647-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Another set of miscellaneous fixes and cleanups for rt2x00.

This includes the TX headroom reservation fixes that were submitted
before but removed after breakage. The series now contains a fix
for that found by Pavel Roskin.

The series is against wireless-next-2.6.

The series can also be pulled from:

	git://git.gwingerde.nl/rt2x00-next-2.6.git

Gertjan van Wingerde (5):
  rt2x00: Properly request tx headroom for alignment operations.
  rt2x00: RF3052 is a valid RF chipset for USB devices as well.
  rt2x00: Unify rt2800 WPDMA ready waiting functions.
  rt2x00: Fix LED configuration setting for rt2800.
  rt2x00: Make rt2800_init_led static and don't export it.

Pavel Roskin (1):
  rt2x00: use correct headroom for transmission

 drivers/net/wireless/rt2x00/rt2800lib.c   |   29 ++++++++++++++++++++++++-----
 drivers/net/wireless/rt2x00/rt2800lib.h   |    3 +--
 drivers/net/wireless/rt2x00/rt2800pci.c   |   24 +++---------------------
 drivers/net/wireless/rt2x00/rt2800usb.c   |   22 ++--------------------
 drivers/net/wireless/rt2x00/rt2x00.h      |    6 ++++++
 drivers/net/wireless/rt2x00/rt2x00dev.c   |   12 +++++++++++-
 drivers/net/wireless/rt2x00/rt2x00queue.c |    6 +++---
 7 files changed, 50 insertions(+), 52 deletions(-)

