Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31382 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbcCARSX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 12:18:23 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH v2 00/15] wil6210 patches
Date: Tue,  1 Mar 2016 19:18:03 +0200
Message-Id: <1456852698-26808-1-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160301_181831_124584_E4C2B620)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changes in V2:
- Fixed oob_mode module parameter description

This set of patches includes:
- wil6210 bug fixes
- P2P support
- switch to generated wmi.h
- replay attack detection

Dedy Lansky (1):
  wil6210: p2p initial support

Hamad Kadmany (1):
  wil6210: Set permanent MAC address to wiphy

Lior David (9):
  wil6210: add support for discovery mode during scan
  wil6210: switch to generated wmi.h
  wil6210: basic PBSS/PCP support
  wil6210: P2P_DEVICE virtual interface support
  wil6210: fix race conditions in p2p listen and search
  wil6210: clean ioctl debug message
  wil6210: fix no_fw_recovery mode with change_virtual_intf
  wil6210: pass is_go flag to firmware
  wil6210: add oob_mode module parameter

Maya Erez (3):
  wil6210: remove BACK RX and TX workers
  wil6210: AP: prevent connecting to already connected station
  wil6210: add support for platform specific notification events

Vladimir Kondratiev (1):
  wil6210: replay attack detection

 drivers/net/wireless/ath/wil6210/Makefile       |    1 +
 drivers/net/wireless/ath/wil6210/cfg80211.c     |  332 +++++-
 drivers/net/wireless/ath/wil6210/debugfs.c      |   55 +-
 drivers/net/wireless/ath/wil6210/interrupt.c    |    6 +-
 drivers/net/wireless/ath/wil6210/ioctl.c        |   11 +-
 drivers/net/wireless/ath/wil6210/main.c         |   81 +-
 drivers/net/wireless/ath/wil6210/netdev.c       |    7 +-
 drivers/net/wireless/ath/wil6210/p2p.c          |  253 +++++
 drivers/net/wireless/ath/wil6210/pcie_bus.c     |    1 +
 drivers/net/wireless/ath/wil6210/rx_reorder.c   |  204 +---
 drivers/net/wireless/ath/wil6210/trace.h        |   19 +-
 drivers/net/wireless/ath/wil6210/txrx.c         |   67 +-
 drivers/net/wireless/ath/wil6210/txrx.h         |   12 +-
 drivers/net/wireless/ath/wil6210/wil6210.h      |  110 +-
 drivers/net/wireless/ath/wil6210/wil_platform.h |    8 +-
 drivers/net/wireless/ath/wil6210/wmi.c          |  134 ++-
 drivers/net/wireless/ath/wil6210/wmi.h          | 1264 +++++++++++------------
 17 files changed, 1594 insertions(+), 971 deletions(-)
 create mode 100644 drivers/net/wireless/ath/wil6210/p2p.c

-- 
1.8.5.2

