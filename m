Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:12671 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993197Ab2KOLRP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 06:17:15 -0500
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v8 0/4] driver for 60g Wilocity chip wil6210
Date: Thu, 15 Nov 2012 13:16:58 +0200
Message-ID: <1352978222-13866-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20121115_121718_732229_66779624)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are several changes:

- dynamic hex dump code moved core includes where it should belong
  it is submitted separately; and included here
  for completness - see patch 4/4. It may be integrated independent
  on other patches in this set
- separation between "Atheros card" and "depending on common Atheros code"
  moved to patch by its own - see patch 2/4. It may be integrated
  independent on other patches in this set. This is the same patch as I
  submitted Nov 14 in thread titled
  "Re: [PATCH v7 2/2] wireless: integrate wil6210 driver into build structure"
- removed all empty methods from cfg80211_ops
- restructure IRQ handling a little bit

Vladimir Kondratiev (4):
  wireless: Driver for 60GHz card wil6210
  wireless: allow Atheros card to not depend on ath.ko
  wireless: integrate wil6210 driver into build
  dynamic_debug: dynamic hex dump

 Documentation/dynamic-debug-howto.txt        |   11 +-
 drivers/net/wireless/ath/Kconfig             |    8 +-
 drivers/net/wireless/ath/Makefile            |    1 +
 drivers/net/wireless/ath/ar5523/Kconfig      |    1 +
 drivers/net/wireless/ath/ath5k/Kconfig       |    1 +
 drivers/net/wireless/ath/ath6kl/Kconfig      |    1 +
 drivers/net/wireless/ath/ath9k/Kconfig       |    1 +
 drivers/net/wireless/ath/carl9170/Kconfig    |    1 +
 drivers/net/wireless/ath/wil6210/Kconfig     |   29 +
 drivers/net/wireless/ath/wil6210/Makefile    |   15 +
 drivers/net/wireless/ath/wil6210/cfg80211.c  |  484 +++++++++++++
 drivers/net/wireless/ath/wil6210/debugfs.c   |  510 ++++++++++++++
 drivers/net/wireless/ath/wil6210/interrupt.c |  374 ++++++++++
 drivers/net/wireless/ath/wil6210/main.c      |  411 +++++++++++
 drivers/net/wireless/ath/wil6210/netdev.c    |  155 +++++
 drivers/net/wireless/ath/wil6210/pcie_bus.c  |  218 ++++++
 drivers/net/wireless/ath/wil6210/sysfs.c     |  134 ++++
 drivers/net/wireless/ath/wil6210/txrx.c      |  825 ++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/txrx.h      |  352 ++++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h   |  351 ++++++++++
 drivers/net/wireless/ath/wil6210/wmi.c       |  966 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/wmi.h       |  927 ++++++++++++++++++++++++
 include/linux/dynamic_debug.h                |   10 +
 include/linux/printk.h                       |   17 +
 24 files changed, 5799 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/wireless/ath/wil6210/Kconfig
 create mode 100644 drivers/net/wireless/ath/wil6210/Makefile
 create mode 100644 drivers/net/wireless/ath/wil6210/cfg80211.c
 create mode 100644 drivers/net/wireless/ath/wil6210/debugfs.c
 create mode 100644 drivers/net/wireless/ath/wil6210/interrupt.c
 create mode 100644 drivers/net/wireless/ath/wil6210/main.c
 create mode 100644 drivers/net/wireless/ath/wil6210/netdev.c
 create mode 100644 drivers/net/wireless/ath/wil6210/pcie_bus.c
 create mode 100644 drivers/net/wireless/ath/wil6210/sysfs.c
 create mode 100644 drivers/net/wireless/ath/wil6210/txrx.c
 create mode 100644 drivers/net/wireless/ath/wil6210/txrx.h
 create mode 100644 drivers/net/wireless/ath/wil6210/wil6210.h
 create mode 100644 drivers/net/wireless/ath/wil6210/wmi.c
 create mode 100644 drivers/net/wireless/ath/wil6210/wmi.h

-- 
1.7.10.4

