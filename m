Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:63324 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab2KMMYA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 07:24:00 -0500
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v7 0/2] driver for 60g Wilocity chip wil6210
Date: Tue, 13 Nov 2012 14:23:45 +0200
Message-ID: <1352809427-29682-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20121113_132404_578512_ED8EB068)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changes since v6:

- fix for endianness in WMI structures
- use 'volatile' for DMA rings since they are written back by hardware
- enable aggregation on Tx
- on Rx, move statistics update to the final Rx function

Vladimir Kondratiev (2):
  wireless: Driver for 60GHz card wil6210
  wireless: integrate wil6210 driver into build structure

 drivers/net/wireless/ath/Kconfig             |    8 +-
 drivers/net/wireless/ath/Makefile            |    1 +
 drivers/net/wireless/ath/ar5523/Kconfig      |    1 +
 drivers/net/wireless/ath/ath5k/Kconfig       |    1 +
 drivers/net/wireless/ath/ath6kl/Kconfig      |    1 +
 drivers/net/wireless/ath/ath9k/Kconfig       |    1 +
 drivers/net/wireless/ath/carl9170/Kconfig    |    1 +
 drivers/net/wireless/ath/wil6210/Kconfig     |   29 +
 drivers/net/wireless/ath/wil6210/Makefile    |   15 +
 drivers/net/wireless/ath/wil6210/cfg80211.c  |  619 +++++++++++++++++
 drivers/net/wireless/ath/wil6210/debugfs.c   |  510 ++++++++++++++
 drivers/net/wireless/ath/wil6210/interrupt.c |  352 ++++++++++
 drivers/net/wireless/ath/wil6210/main.c      |  411 +++++++++++
 drivers/net/wireless/ath/wil6210/netdev.c    |  155 +++++
 drivers/net/wireless/ath/wil6210/pcie_bus.c  |  218 ++++++
 drivers/net/wireless/ath/wil6210/sysfs.c     |  134 ++++
 drivers/net/wireless/ath/wil6210/txrx.c      |  825 ++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/txrx.h      |  352 ++++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h   |  378 ++++++++++
 drivers/net/wireless/ath/wil6210/wmi.c       |  966 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/wmi.h       |  927 ++++++++++++++++++++++++
 21 files changed, 5903 insertions(+), 2 deletions(-)
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

