Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:13180 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab2JUNJP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Oct 2012 09:09:15 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v1 0/2] driver for 60g Wilocity chip wil6210
Date: Sun, 21 Oct 2012 15:02:49 +0200
Message-ID: <1350824571-22554-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20121021_150921_980464_B2344BF6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Resending driver patches with few corrections:
- removed piece of unused code
- removed endianness conversion - it is not integrated and all
chances it is just wrong. Hardware is little endian, and only platform
I have is 64-bit Intel.

I maintain driver as a single patch; for today changes it should be fine,
but I'd be happy to get comments how to proceed when I will add features:
whether keep it one patch, or as series one per feature. From one side,
patch per feature is right thing to do, but it is not merged yet, so
keeping one patch may be OK as well. Thoughts?

Also, I got no comments so far. Am I missing something?

Vladimir Kondratiev (2):
  wireless: Driver for 60GHz card wil6210
  wireless: integrate wil6210 driver into build structure

 drivers/net/wireless/ath/Kconfig               |    1 +
 drivers/net/wireless/ath/Makefile              |    1 +
 drivers/net/wireless/ath/wil6210/Kconfig       |   42 ++
 drivers/net/wireless/ath/wil6210/Makefile      |   15 +
 drivers/net/wireless/ath/wil6210/cfg80211.c    |  842 +++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/debugfs.c     |  456 ++++++++++++
 drivers/net/wireless/ath/wil6210/interrupt.c   |  323 ++++++++
 drivers/net/wireless/ath/wil6210/main.c        |  353 +++++++++
 drivers/net/wireless/ath/wil6210/netdev.c      |  156 ++++
 drivers/net/wireless/ath/wil6210/pcie_bus.c    |  245 +++++++
 drivers/net/wireless/ath/wil6210/sysfs.c       |  106 +++
 drivers/net/wireless/ath/wil6210/txrx.c        |  829 +++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/txrx.h        |  352 +++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h     |  265 +++++++
 drivers/net/wireless/ath/wil6210/wil6210_rgf.h |   93 +++
 drivers/net/wireless/ath/wil6210/wmi.c         |  867 ++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/wmi.h         |  929 ++++++++++++++++++++++++
 17 files changed, 5875 insertions(+)
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

