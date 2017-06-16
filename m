Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:32953 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754070AbdFPOi3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Jun 2017 10:38:29 -0400
Received: by mail-pg0-f68.google.com with SMTP id u62so928386pgb.0
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jun 2017 07:38:29 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [v2 0/6] rsi driver bringup enhancements
Date: Fri, 16 Jun 2017 20:05:35 +0530
Message-Id: <1497623741-2082-1-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170616_163832_852176_05E27B72)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series includes the changes for adding USB chipset,
frames exchanged with firmware during initialization
and false interrupt problem fix for SDIO.

Changes in v2:
Patch 6/6: Get rid of __LITTLE_ENDIAN compiler flag usage(Kalle Valo)

Amitkumar Karwar (1):
  rsi: use enum for FSM states

Prameela Rani Garnepudi (5):
  rsi: add usb RS9113 chipset support
  rsi: Register interrupt handler before firmware load
  rsi: receive path enhancement for RS9113
  rsi: configure new boot parameters to device
  rsi: add tx frame for common device configuration

 drivers/net/wireless/rsi/rsi_91x_hal.c     |   4 +-
 drivers/net/wireless/rsi/rsi_91x_main.c    |   9 ++-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c    | 120 ++++++++++++++++++++++++-----
 drivers/net/wireless/rsi/rsi_91x_sdio.c    |  21 ++---
 drivers/net/wireless/rsi/rsi_91x_usb.c     |   1 +
 drivers/net/wireless/rsi/rsi_boot_params.h |  15 ++--
 drivers/net/wireless/rsi/rsi_hal.h         |   3 +
 drivers/net/wireless/rsi/rsi_main.h        |  28 +++++--
 drivers/net/wireless/rsi/rsi_mgmt.h        |  76 ++++++++++++++++++
 9 files changed, 232 insertions(+), 45 deletions(-)

-- 
2.7.4
