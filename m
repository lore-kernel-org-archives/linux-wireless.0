Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:31705 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab2KVUMN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 15:12:13 -0500
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v9 0/2] driver for 60g Wilocity chip wil6210
Date: Thu, 22 Nov 2012 15:25:32 +0200
Message-ID: <1353590734-28704-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20121122_211223_020755_74CD3D6D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This iteration includes the following:

- some refactoring in reset code
- AP mode implemented with start_ap().
  It require patch (submitted) for wpa_supplicant
- use wdev's SSID and channel, remove private ones
- remove sysfs, migrate stuff from there to the debugfs
- small update for API with firmware
- add more hardware registers (interrupt throttling control) to debugfs

It is assumed 2 other patches present, both work in progress,
likely to merge soon:

wireless: allow Atheros card to not depend on ath.ko
dynamic_debug: dynamic hex dump

the 2-nd one is for code includes, it is on its way to Greg K-H.

Vladimir Kondratiev (2):
  wireless: Driver for 60GHz card wil6210
  wireless: integrate wil6210 driver into build

 drivers/net/wireless/ath/Kconfig             |    1 +
 drivers/net/wireless/ath/Makefile            |    1 +
 drivers/net/wireless/ath/wil6210/Kconfig     |   29 +
 drivers/net/wireless/ath/wil6210/Makefile    |   14 +
 drivers/net/wireless/ath/wil6210/cfg80211.c  |  560 +++++++++++++++
 drivers/net/wireless/ath/wil6210/debugfs.c   |  603 ++++++++++++++++
 drivers/net/wireless/ath/wil6210/interrupt.c |  374 ++++++++++
 drivers/net/wireless/ath/wil6210/main.c      |  406 +++++++++++
 drivers/net/wireless/ath/wil6210/netdev.c    |  156 +++++
 drivers/net/wireless/ath/wil6210/pcie_bus.c  |  208 ++++++
 drivers/net/wireless/ath/wil6210/txrx.c      |  826 ++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/txrx.h      |  352 ++++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h   |  357 ++++++++++
 drivers/net/wireless/ath/wil6210/wmi.c       |  966 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/wmi.h       |  945 +++++++++++++++++++++++++
 15 files changed, 5798 insertions(+)
 create mode 100644 drivers/net/wireless/ath/wil6210/Kconfig
 create mode 100644 drivers/net/wireless/ath/wil6210/Makefile
 create mode 100644 drivers/net/wireless/ath/wil6210/cfg80211.c
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

