Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:19328 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab2LLPsP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 10:48:15 -0500
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Joe Perches <joe@perches.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v10 0/3] wireless: Driver for 60GHz card wil6210
Date: Wed, 12 Dec 2012 17:47:55 +0200
Message-ID: <1355327278-12965-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20121212_164819_077273_8AAC73EA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please see patches containing driver for 60g card 'wil6210'

Following recommendations from Joe Perches and Luis R. Rodriguez,
I do not wait for 'dynamic hexdump' to merge - Greg KH says it
will not make to 3.8 - too late. Instead, I did patch that compensate
this functionality. It is submitted as separate one, to be easily
un-done when 'dynamic hexdump' patch merge.

There is some other work integrated since previous iteration:

- AP mode fixes
- IRQ code optimizations
- wmi.h that defines driver/firmware API, is now shared with the FW team
- experimental support for 3 MSI mode
- documentation included

Can it be finally merged this time? I't be happy to see it in 3.8.

Vladimir Kondratiev (3):
  wireless: Driver for 60GHz card wil6210
  wil6210: Local compensation for dynamic hexdump
  wireless: integrate wil6210 driver into build

 Documentation/networking/wil6210.txt           |  292 +++++++
 drivers/net/wireless/ath/Kconfig               |    1 +
 drivers/net/wireless/ath/Makefile              |    1 +
 drivers/net/wireless/ath/wil6210/Kconfig       |   30 +
 drivers/net/wireless/ath/wil6210/Makefile      |   14 +
 drivers/net/wireless/ath/wil6210/cfg80211.c    |  565 ++++++++++++
 drivers/net/wireless/ath/wil6210/dbg_hexdump.h |   32 +
 drivers/net/wireless/ath/wil6210/debugfs.c     |  603 +++++++++++++
 drivers/net/wireless/ath/wil6210/interrupt.c   |  471 ++++++++++
 drivers/net/wireless/ath/wil6210/main.c        |  407 +++++++++
 drivers/net/wireless/ath/wil6210/netdev.c      |  157 ++++
 drivers/net/wireless/ath/wil6210/pcie_bus.c    |  223 +++++
 drivers/net/wireless/ath/wil6210/txrx.c        |  892 +++++++++++++++++++
 drivers/net/wireless/ath/wil6210/txrx.h        |  362 ++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h     |  363 ++++++++
 drivers/net/wireless/ath/wil6210/wmi.c         |  989 +++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/wmi.h         | 1116 ++++++++++++++++++++++++
 17 files changed, 6518 insertions(+)
 create mode 100644 Documentation/networking/wil6210.txt
 create mode 100644 drivers/net/wireless/ath/wil6210/Kconfig
 create mode 100644 drivers/net/wireless/ath/wil6210/Makefile
 create mode 100644 drivers/net/wireless/ath/wil6210/cfg80211.c
 create mode 100644 drivers/net/wireless/ath/wil6210/dbg_hexdump.h
 create mode 100644 drivers/net/wireless/ath/wil6210/debugfs.c
 create mode 100644 drivers/net/wireless/ath/wil6210/interrupt.c
 create mode 100644 drivers/net/wireless/ath/wil6210/main.c
 create mode 100644 drivers/net/wireless/ath/wil6210/netdev.c
 create mode 100644 drivers/net/wireless/ath/wil6210/pcie_bus.c
 create mode 100644 drivers/net/wireless/ath/wil6210/txrx.c
 create mode 100644 drivers/net/wireless/ath/wil6210/txrx.h
 create mode 100644 drivers/net/wireless/ath/wil6210/wil6210.h
 create mode 100644 drivers/net/wireless/ath/wil6210/wmi.c
 create mode 100644 drivers/net/wireless/ath/wil6210/wmi.h

-- 
1.7.10.4

