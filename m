Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45335 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750802AbdFOG0w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 02:26:52 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH v3 0/3] wil6210 patches
Date: Thu, 15 Jun 2017 09:26:45 +0300
Message-Id: <1497508008-9536-1-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170615_082655_721188_DD165DBE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This set of patches includes:
- D3hot support for 11ad platform devices which supports it
- removal of ioctl interface from wil6210 driver

Changes from v1:
- Change of wil_platform.h copyright year to 2017

Changes from v2:
Removal of additional ioctl related code

Dedy Lansky (1):
  wil6210: prevent platform callbacks after uninit

Maya Erez (2):
  wil6210: add support for PCIe D3hot in system suspend
  wil6210: remove ioctl interface

 drivers/net/wireless/ath/wil6210/Makefile       |   1 -
 drivers/net/wireless/ath/wil6210/cfg80211.c     |  38 ++++
 drivers/net/wireless/ath/wil6210/debugfs.c      |  49 +++++
 drivers/net/wireless/ath/wil6210/interrupt.c    |   6 +
 drivers/net/wireless/ath/wil6210/ioctl.c        | 180 -------------------
 drivers/net/wireless/ath/wil6210/main.c         |   7 +-
 drivers/net/wireless/ath/wil6210/netdev.c       |   8 -
 drivers/net/wireless/ath/wil6210/pcie_bus.c     |  63 ++++---
 drivers/net/wireless/ath/wil6210/pm.c           | 228 ++++++++++++++++++++++--
 drivers/net/wireless/ath/wil6210/txrx.c         |  71 ++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h      |  27 ++-
 drivers/net/wireless/ath/wil6210/wil_platform.h |   7 +-
 drivers/net/wireless/ath/wil6210/wmi.c          | 143 +++++++++++++++
 drivers/net/wireless/ath/wil6210/wmi.h          |  27 +--
 include/uapi/linux/wil6210_uapi.h               |  87 ---------
 15 files changed, 612 insertions(+), 330 deletions(-)
 delete mode 100644 drivers/net/wireless/ath/wil6210/ioctl.c
 delete mode 100644 include/uapi/linux/wil6210_uapi.h

-- 
1.9.1
