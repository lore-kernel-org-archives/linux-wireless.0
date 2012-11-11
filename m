Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:22172 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab2KKQy1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2012 11:54:27 -0500
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v6 0/2] driver for 60g Wilocity chip wil6210
Date: Sun, 11 Nov 2012 18:54:08 +0200
Message-ID: <1352652850-19449-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20121111_175429_762757_EAFAD658)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Another round of review. Changes:

- removed Kconfig depends on EXPERIMENTAL
- cleaned mess with wil6210/Kconfig
- removed "trace" and debug prints
- all remaining 'info' priority prints converted to 'debug' or 'error'
- unsigned loop variables
- IRQ mask debug code moved to separate function
- use module_pci_driver to simplify the code

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
 drivers/net/wireless/ath/wil6210/debugfs.c   |  506 ++++++++++++++
 drivers/net/wireless/ath/wil6210/interrupt.c |  353 ++++++++++
 drivers/net/wireless/ath/wil6210/main.c      |  394 +++++++++++
 drivers/net/wireless/ath/wil6210/netdev.c    |  155 +++++
 drivers/net/wireless/ath/wil6210/pcie_bus.c  |  218 ++++++
 drivers/net/wireless/ath/wil6210/sysfs.c     |  134 ++++
 drivers/net/wireless/ath/wil6210/txrx.c      |  810 ++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/txrx.h      |  352 ++++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h   |  377 ++++++++++
 drivers/net/wireless/ath/wil6210/wmi.c       |  959 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/wmi.h       |  928 +++++++++++++++++++++++++
 21 files changed, 5861 insertions(+), 2 deletions(-)
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

