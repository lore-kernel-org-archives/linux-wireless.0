Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:14346 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752723AbeFJU3k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Jun 2018 16:29:40 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH v2 0/7] wil6210 patches
Date: Sun, 10 Jun 2018 23:29:28 +0300
Message-Id: <1528662575-7746-1-git-send-email-merez@codeaurora.org> (sfid-20180610_222957_361582_88584028)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changes from v1:
- Removal of module parameters
- Addition of debugfs entries for configuring enhanced DMA
- Fixing kbuild bot error
- Enabling AMSDU by default (based on FW support)
- Fixing L2 translation mode

The following set of patches add support for new wil6210 device (Talyn ver 2.0):
- Definition of the new device ID and memory areas
- New boot flow procedure and reset sequence
- Support new DMA interface - enhanced DMA
- Support new HW offloads, such as TSO, RX reorder and AMSDU

Gidon Studinski (3):
  wil6210: add support for enhanced DMA structures
  wil6210: initialize TX and RX enhanced DMA rings
  wil6210: add support for enhanced DMA RX data flows

Maya Erez (4):
  wil6210: add support for Talyn-MB (Talyn ver 2.0) device
  wil6210: add support for enhanced DMA TX data flows
  wil6210: add support for enhanced DMA debugfs
  wil6210: add support for Talyn-MB boot flow

 drivers/net/wireless/ath/wil6210/Makefile     |    1 +
 drivers/net/wireless/ath/wil6210/cfg80211.c   |   12 +-
 drivers/net/wireless/ath/wil6210/debugfs.c    |  490 ++++++--
 drivers/net/wireless/ath/wil6210/ethtool.c    |    2 +-
 drivers/net/wireless/ath/wil6210/interrupt.c  |  225 +++-
 drivers/net/wireless/ath/wil6210/main.c       |  360 +++++-
 drivers/net/wireless/ath/wil6210/netdev.c     |   73 +-
 drivers/net/wireless/ath/wil6210/pcie_bus.c   |   59 +-
 drivers/net/wireless/ath/wil6210/pm.c         |    6 +-
 drivers/net/wireless/ath/wil6210/rx_reorder.c |   21 +-
 drivers/net/wireless/ath/wil6210/trace.h      |   59 +
 drivers/net/wireless/ath/wil6210/txrx.c       |  649 +++++-----
 drivers/net/wireless/ath/wil6210/txrx.h       |  105 +-
 drivers/net/wireless/ath/wil6210/txrx_edma.c  | 1598 +++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/txrx_edma.h  |  562 +++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h    |  227 +++-
 drivers/net/wireless/ath/wil6210/wmi.c        |  454 ++++++-
 drivers/net/wireless/ath/wil6210/wmi.h        |  167 ++-
 18 files changed, 4436 insertions(+), 634 deletions(-)
 create mode 100644 drivers/net/wireless/ath/wil6210/txrx_edma.c
 create mode 100644 drivers/net/wireless/ath/wil6210/txrx_edma.h

-- 
1.9.1
