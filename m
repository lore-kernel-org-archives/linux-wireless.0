Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36310 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753424AbdFMOvY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 10:51:24 -0400
Received: by mail-pg0-f67.google.com with SMTP id v18so19200697pgb.3
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jun 2017 07:51:24 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Alexey.Brodkin@synopsys.com,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [PATCH 00/20] rsi driver enhancements
Date: Tue, 13 Jun 2017 20:18:48 +0530
Message-Id: <1497365348-2305-1-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170613_165128_463571_C0F3C75C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series includes some fixes and enhancements in Tx and Rx
data paths. Connection in open security and data traffic has been
verified with SDIO and USB variants of 9113 chipset.

Amitkumar Karwar (1):
  rsi: correct the logic of deriving queue number

Karun Eagalapati (14):
  rsi: fix sdio card reset problem
  rsi: chip reset for SDIO interface
  rsi: correct SDIO disconnect path handling
  rsi: card reset for USB interface
  rsi: USB tx headroom cleanup
  rsi: rename USB endpoint macros
  rsi: choose correct endpoint based on queue.
  rsi: set immediate wakeup bit
  rsi: separate function for management packet descriptor
  rsi: rename variable in_sdio_litefi_irq
  rsi: Optimise sdio claim and release host
  rsi: SDIO Rx packet processing enhancement
  rsi: use separate mutex lock for receive thread
  rsi: Rename mutex tx_rxlock to the tx_lock.

Prameela Rani Garnepudi (1):
  rsi: changes in eeprom read frame

pavani.muthyala (4):
  rsi: management frame descriptor preparation cleanup
  rsi: data packet descriptor code cleanup
  rsi: data packet descriptor enhancements
  rsi: separate function for data packet descriptor

 drivers/net/wireless/rsi/rsi_91x_core.c     |  10 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c      | 269 ++++++++++++++++++----------
 drivers/net/wireless/rsi/rsi_91x_main.c     |   2 +-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     |  87 ++++++---
 drivers/net/wireless/rsi/rsi_91x_sdio.c     | 154 ++++++++++++----
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |  44 +++--
 drivers/net/wireless/rsi/rsi_91x_usb.c      | 118 +++++++++---
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c  |   6 +-
 drivers/net/wireless/rsi/rsi_hal.h          |  82 +++++++++
 drivers/net/wireless/rsi/rsi_main.h         |  29 ++-
 drivers/net/wireless/rsi/rsi_mgmt.h         |  40 ++++-
 drivers/net/wireless/rsi/rsi_sdio.h         |   4 +-
 drivers/net/wireless/rsi/rsi_usb.h          |   5 +-
 13 files changed, 644 insertions(+), 206 deletions(-)

-- 
2.7.4
