Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33690 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751158AbdHCOc7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 10:32:59 -0400
Received: by mail-pg0-f67.google.com with SMTP id u185so1673064pgb.0
        for <linux-wireless@vger.kernel.org>; Thu, 03 Aug 2017 07:32:58 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [v2 0/8] rsi driver enhancements
Date: Thu,  3 Aug 2017 19:58:56 +0530
Message-Id: <1501770544-6746-1-git-send-email-amitkarwar@gmail.com> (sfid-20170803_163305_685961_370D7794)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <amit.karwar@redpinesignals.com>

This patch series brings in few enhancements in rsi driver
like rfkill support, U-APSD and Legacy power save support,
antenna and RTS threshold configuration, improvements in
reading SDIO buffer status.

Changes in v2:
  1/8: Pavani's name was in incorrect format. Fixed this(Kalle)
  3/8: Used the same licence information for newly added files.
       Removed redundant comments for functions (Kalle)

Karun Eagalapati (6):
  rsi: add support for legacy power save
  rsi: add support for U-APSD power save
  rsi: rename sdio_read_buffer_status_register
  rsi: buffer full check optimization
  rsi: buffer available interrupt handling
  rsi: RTS threshold configuration

Pavani Muthyala (2):
  rsi: add support for rf-kill functionality
  rsi: update set_antenna command frame

 drivers/net/wireless/rsi/Makefile           |   1 +
 drivers/net/wireless/rsi/rsi_91x_hal.c      |   7 ++
 drivers/net/wireless/rsi/rsi_91x_mac80211.c |  71 +++++++++++++-
 drivers/net/wireless/rsi/rsi_91x_main.c     |   2 +
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 104 ++++++++++++++++++--
 drivers/net/wireless/rsi/rsi_91x_ps.c       | 146 ++++++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_sdio.c     |   2 +-
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |  40 +++++---
 drivers/net/wireless/rsi/rsi_main.h         |  11 ++-
 drivers/net/wireless/rsi/rsi_mgmt.h         |  52 ++++++++++
 drivers/net/wireless/rsi/rsi_ps.h           |  64 ++++++++++++
 drivers/net/wireless/rsi/rsi_sdio.h         |   3 +-
 12 files changed, 474 insertions(+), 29 deletions(-)
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_ps.c
 create mode 100644 drivers/net/wireless/rsi/rsi_ps.h

-- 
2.7.4
