Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63117 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756984Ab2JJSXr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 14:23:47 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v0 0/2] driver for 60g Wilocity chip wil6210
Date: Wed, 10 Oct 2012 20:23:03 +0200
Message-ID: <1349893385-23102-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20121010_202358_481545_5BDDAAD4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Here goes driver for the "wil6210" chip by Wilocity.

This is development snapshot, only basic functionality is working.
Chip firmware is also in active development, it is likely that
firmware API will change.

Code have style warnings like #ifdef's - some code is not integrated,
there are places where one can play with different options;
these #ifdef's will go away later.

But, there is enough content to start with. In the lab I have stable
link with 1.2 Gbps throughput, as measured by iperf.

Vladimir Kondratiev (2):
  wireless: Driver for 60GHz card wil6210
  wireless: integrate wil6210 driver into build structure

 drivers/net/wireless/ath/Kconfig               |    1 +
 drivers/net/wireless/ath/Makefile              |    1 +
 drivers/net/wireless/ath/wil6210/Kconfig       |   42 ++
 drivers/net/wireless/ath/wil6210/Makefile      |   14 +
 drivers/net/wireless/ath/wil6210/cfg80211.c    |  859 ++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/debugfs.c     |  457 ++++++++++++
 drivers/net/wireless/ath/wil6210/interrupt.c   |  323 ++++++++
 drivers/net/wireless/ath/wil6210/main.c        |  353 +++++++++
 drivers/net/wireless/ath/wil6210/netdev.c      |  156 ++++
 drivers/net/wireless/ath/wil6210/pcie_bus.c    |  245 +++++++
 drivers/net/wireless/ath/wil6210/sysfs.c       |  106 +++
 drivers/net/wireless/ath/wil6210/txrx.c        |  829 +++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/txrx.h        |  352 +++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h     |  265 +++++++
 drivers/net/wireless/ath/wil6210/wil6210_rgf.h |   93 +++
 drivers/net/wireless/ath/wil6210/wmi.c         |  870 ++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/wmi.h         |  929 ++++++++++++++++++++++++
 17 files changed, 5895 insertions(+)
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
1.7.9.5

