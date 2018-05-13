Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:4615 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751903AbeEMQDy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 13 May 2018 12:03:54 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH 0/7] wil6210 patches
Date: Sun, 13 May 2018 19:02:48 +0300
Message-Id: <1526227375-31881-1-git-send-email-merez@codeaurora.org> (sfid-20180513_180402_543444_09CBF42D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
 drivers/net/wireless/ath/wil6210/debugfs.c    |  431 +++++--
 drivers/net/wireless/ath/wil6210/ethtool.c    |    2 +-
 drivers/net/wireless/ath/wil6210/interrupt.c  |  225 +++-
 drivers/net/wireless/ath/wil6210/main.c       |  350 ++++--
 drivers/net/wireless/ath/wil6210/netdev.c     |   73 +-
 drivers/net/wireless/ath/wil6210/pcie_bus.c   |   62 +-
 drivers/net/wireless/ath/wil6210/pm.c         |    6 +-
 drivers/net/wireless/ath/wil6210/rx_reorder.c |   20 +-
 drivers/net/wireless/ath/wil6210/trace.h      |   57 +
 drivers/net/wireless/ath/wil6210/txrx.c       |  648 +++++-----
 drivers/net/wireless/ath/wil6210/txrx.h       |  105 +-
 drivers/net/wireless/ath/wil6210/txrx_edma.c  | 1637 +++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/txrx_edma.h  |  553 +++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h    |  220 +++-
 drivers/net/wireless/ath/wil6210/wmi.c        |  458 ++++++-
 drivers/net/wireless/ath/wil6210/wmi.h        |  166 ++-
 18 files changed, 4389 insertions(+), 637 deletions(-)
 create mode 100644 drivers/net/wireless/ath/wil6210/txrx_edma.c
 create mode 100644 drivers/net/wireless/ath/wil6210/txrx_edma.h

-- 
1.9.1
