Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:30085 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758795Ab2J2L6i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2012 07:58:38 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v2 0/2] driver for 60g Wilocity chip wil6210
Date: Mon, 29 Oct 2012 13:58:24 +0200
Message-ID: <1351511906-19989-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20121029_125841_944248_F493C9C9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Addressed Luis's input:

- typos, formatting, names, style etc.
- kill all #ifdef's like #if 0
- use dynamic printk and kill more #ifdefs
- did "dynamic printk" style variand for hex. dump
- moved wil6210 under "atheros cards" in Kconfig. This require some
  changes around to not depend on ath.ko module

I did it in 2 patches for now, to simplify discussion regarding
Kconfig changes

I kept "driver version", as it was requested by customers;
and I see some 600+ drivers in today's kernel use it.

Comments are welcome

Vladimir Kondratiev (2):
  wireless: Driver for 60GHz card wil6210
  wireless: integrate wil6210 driver into build structure

 drivers/net/wireless/ath/Kconfig               |    8 +-
 drivers/net/wireless/ath/Makefile              |    1 +
 drivers/net/wireless/ath/ath5k/Kconfig         |    1 +
 drivers/net/wireless/ath/ath6kl/Kconfig        |    1 +
 drivers/net/wireless/ath/ath9k/Kconfig         |    1 +
 drivers/net/wireless/ath/carl9170/Kconfig      |    1 +
 drivers/net/wireless/ath/wil6210/Kconfig       |   25 +
 drivers/net/wireless/ath/wil6210/Makefile      |   15 +
 drivers/net/wireless/ath/wil6210/cfg80211.c    |  821 ++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/debugfs.c     |  499 ++++++++++++
 drivers/net/wireless/ath/wil6210/interrupt.c   |  339 +++++++++
 drivers/net/wireless/ath/wil6210/main.c        |  401 ++++++++++
 drivers/net/wireless/ath/wil6210/netdev.c      |  159 ++++
 drivers/net/wireless/ath/wil6210/pcie_bus.c    |  255 +++++++
 drivers/net/wireless/ath/wil6210/sysfs.c       |  133 ++++
 drivers/net/wireless/ath/wil6210/txrx.c        |  817 ++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/txrx.h        |  352 +++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h     |  299 ++++++++
 drivers/net/wireless/ath/wil6210/wil6210_rgf.h |   93 +++
 drivers/net/wireless/ath/wil6210/wmi.c         |  965 ++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/wmi.h         |  928 +++++++++++++++++++++++
 21 files changed, 6112 insertions(+), 2 deletions(-)
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
 create mode 100644 drivers/net/wireless/ath/wil6210/wil6210_rgf.h
 create mode 100644 drivers/net/wireless/ath/wil6210/wmi.c
 create mode 100644 drivers/net/wireless/ath/wil6210/wmi.h

-- 
1.7.10.4

