Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:7701 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaIJNfH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 09:35:07 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 00/22] wil6210 patches
Date: Wed, 10 Sep 2014 16:34:29 +0300
Message-ID: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140910_153513_467622_435F1FF3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Really big item is firmware download. It is still
experimental, and there is no firmware ready for
public release yet; but we are getting close.

Another item worth mentioning is provisioning for
platform specific code.

The rest is bug fixes and small improvements

Dedy Lansky (6):
  wil6210: fix for memory corruption while insmod
  wil6210: fix for memory corruption upon rmmod
  wil6210: fix race condition of disconnect while BACK event
  wil6210: modify confusing printout
  wil6210: fix race condition between BACK event and Rx data
  wil6210: introduce separate completion for WMI

Vladimir Kondratiev (16):
  wil6210: firmware download
  wil6210: debug prints for vring de-allocation
  wil6210: print more information when connecting
  wil6210: some more debug for the WMI mechanism
  wil6210: coding style fixes
  wil6210: platform specific module
  wil6210: add more debug printouts
  wil6210: fix usage of print_hex_dump_debug
  wil6210: send connect request IEs to FW also for non-secure connection
  wil6210: add change_beacon() driver callback
  wil6210: enlarge TX/RX buffer length
  wil6210: specify max. IE length
  wil6210: fix typo in comment
  wil6210: rename [en|dis]able irq to [un]mask
  wil6210: fix for oops while stopping interface
  wil6210: fix PTR_ERR() usage after initialization to constant

 drivers/net/wireless/ath/wil6210/Kconfig           |   9 +
 drivers/net/wireless/ath/wil6210/Makefile          |   3 +
 drivers/net/wireless/ath/wil6210/cfg80211.c        | 126 ++++--
 drivers/net/wireless/ath/wil6210/debugfs.c         |  60 ++-
 drivers/net/wireless/ath/wil6210/fw.c              |  45 ++
 drivers/net/wireless/ath/wil6210/fw.h              | 149 +++++++
 drivers/net/wireless/ath/wil6210/fw_inc.c          | 495 +++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/interrupt.c       |  31 +-
 drivers/net/wireless/ath/wil6210/main.c            | 185 +++++---
 drivers/net/wireless/ath/wil6210/netdev.c          |  17 +-
 drivers/net/wireless/ath/wil6210/pcie_bus.c        |  39 +-
 drivers/net/wireless/ath/wil6210/rx_reorder.c      |  13 +-
 drivers/net/wireless/ath/wil6210/txrx.c            |  66 ++-
 drivers/net/wireless/ath/wil6210/txrx.h            |   9 +-
 drivers/net/wireless/ath/wil6210/wil6210.h         |  43 +-
 drivers/net/wireless/ath/wil6210/wil_platform.c    |  49 ++
 drivers/net/wireless/ath/wil6210/wil_platform.h    |  34 ++
 .../net/wireless/ath/wil6210/wil_platform_msm.c    | 257 +++++++++++
 .../net/wireless/ath/wil6210/wil_platform_msm.h    |  24 +
 drivers/net/wireless/ath/wil6210/wmi.c             |  40 +-
 drivers/net/wireless/ath/wil6210/wmi.h             |  18 +-
 21 files changed, 1540 insertions(+), 172 deletions(-)
 create mode 100644 drivers/net/wireless/ath/wil6210/fw.c
 create mode 100644 drivers/net/wireless/ath/wil6210/fw.h
 create mode 100644 drivers/net/wireless/ath/wil6210/fw_inc.c
 create mode 100644 drivers/net/wireless/ath/wil6210/wil_platform.c
 create mode 100644 drivers/net/wireless/ath/wil6210/wil_platform.h
 create mode 100644 drivers/net/wireless/ath/wil6210/wil_platform_msm.c
 create mode 100644 drivers/net/wireless/ath/wil6210/wil_platform_msm.h

-- 
1.9.1

