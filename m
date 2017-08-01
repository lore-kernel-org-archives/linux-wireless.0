Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34731 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751008AbdHAJJ6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Aug 2017 05:09:58 -0400
Received: by mail-pg0-f67.google.com with SMTP id y192so1741346pgd.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Aug 2017 02:09:58 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 0/8] rsi driver enhancements
Date: Tue,  1 Aug 2017 14:35:44 +0530
Message-Id: <1501578352-10795-1-git-send-email-amitkarwar@gmail.com> (sfid-20170801_111002_492599_FDC88EAB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <amit.karwar@redpinesignals.com>

This patch series brings in few enhancements in rsi driver
like rfkill support, U-APSD and Legacy power save support,
antenna and RTS threshold configuration, improvements in
reading SDIO buffer status.

Karun Eagalapati (6):
  rsi: add support for legacy power save
  rsi: add support for U-APSD power save
  rsi: rename sdio_read_buffer_status_register
  rsi: buffer full check optimization
  rsi: buffer available interrupt handling
  rsi: RTS threshold configuration

Pavani Muthyala (1):
  rsi: update set_antenna command frame

pavani.muthyala (1):
  rsi: add support for rf-kill functionality

 drivers/net/wireless/rsi/Makefile           |   1 +
 drivers/net/wireless/rsi/rsi_91x_hal.c      |   7 ++
 drivers/net/wireless/rsi/rsi_91x_mac80211.c |  72 +++++++++++-
 drivers/net/wireless/rsi/rsi_91x_main.c     |   2 +
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 105 +++++++++++++++--
 drivers/net/wireless/rsi/rsi_91x_ps.c       | 167 ++++++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_sdio.c     |   2 +-
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |  40 ++++---
 drivers/net/wireless/rsi/rsi_main.h         |  11 +-
 drivers/net/wireless/rsi/rsi_mgmt.h         |  52 +++++++++
 drivers/net/wireless/rsi/rsi_ps.h           |  78 +++++++++++++
 drivers/net/wireless/rsi/rsi_sdio.h         |   3 +-
 12 files changed, 511 insertions(+), 29 deletions(-)
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_ps.c
 create mode 100644 drivers/net/wireless/rsi/rsi_ps.h

-- 
2.7.4
