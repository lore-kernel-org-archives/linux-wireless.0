Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:57030 "EHLO
        sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752387AbdFNUye (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Jun 2017 16:54:34 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 0/3] wil6210 patches
Date: Wed, 14 Jun 2017 23:54:25 +0300
Message-Id: <1497473668-16325-1-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170614_225448_308420_C590BCB6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This set of patches includes:
- D3hot support for 11ad platform devices which supports it
- removal of ioctl interface from wil6210 driver

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
 drivers/net/wireless/ath/wil6210/wil6210.h      |  26 +++
 drivers/net/wireless/ath/wil6210/wil_platform.h |   5 +-
 drivers/net/wireless/ath/wil6210/wmi.c          | 143 +++++++++++++++
 drivers/net/wireless/ath/wil6210/wmi.h          |  27 +--
 14 files changed, 611 insertions(+), 241 deletions(-)
 delete mode 100644 drivers/net/wireless/ath/wil6210/ioctl.c

-- 
1.9.1
