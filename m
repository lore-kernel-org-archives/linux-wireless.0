Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35072 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752231AbdFPO5a (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Jun 2017 10:57:30 -0400
Received: by mail-pg0-f66.google.com with SMTP id f127so6640081pgc.2
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jun 2017 07:57:30 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [v2 00/20] rsi driver enhancements
Date: Fri, 16 Jun 2017 20:24:21 +0530
Message-Id: <1497624881-2315-1-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170616_165734_503109_0968AD1B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series includes some fixes and enhancements in Tx and Rx
data paths. Connection in open security and data traffic has been
verified with SDIO and USB variants of 9113 chipset.

Changes in v2 series:
1/20: Get rid of __LITTLE_ENDIAN flag usage
11/20: Get rid of __LITTLE_ENDIAN flag usage
12/20: Changes to match modified 11/20
13/20: Get rid of __LITTLE_ENDIAN flag usage
14/20: Changes to match modified 13/20
15/20: Changes to match modified 13/20
19/20: mutex_init was missed for rx_lock in v1

Amitkumar Karwar (1):
  rsi: correct the logic of deriving queue number

Karun Eagalapati (13):
  rsi: fix sdio card reset problem
  rsi: chip reset for SDIO interface
  rsi: correct SDIO disconnect path handling
  rsi: card reset for USB interface
  rsi: USB tx headroom cleanup
  rsi: rename USB endpoint macros
  rsi: choose correct endpoint based on queue.
  rsi: set immediate wakeup bit
  rsi: rename variable in_sdio_litefi_irq
  rsi: Optimise sdio claim and release host
  rsi: SDIO Rx packet processing enhancement
  rsi: use separate mutex lock for receive thread
  rsi: Rename mutex tx_rxlock to the tx_lock.

Prameela Rani Garnepudi (2):
  rsi: changes in eeprom read frame
  rsi: separate function for management packet descriptor

pavani.muthyala (4):
  rsi: management frame descriptor preparation cleanup
  rsi: data packet descriptor code cleanup
  rsi: data packet descriptor enhancements
  rsi: separate function for data packet descriptor

 drivers/net/wireless/rsi/rsi_91x_core.c     |  10 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c      | 270 ++++++++++++++++++----------
 drivers/net/wireless/rsi/rsi_91x_main.c     |   3 +-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     |  90 +++++++---
 drivers/net/wireless/rsi/rsi_91x_sdio.c     | 154 ++++++++++++----
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |  44 +++--
 drivers/net/wireless/rsi/rsi_91x_usb.c      | 118 +++++++++---
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c  |   6 +-
 drivers/net/wireless/rsi/rsi_hal.h          |  64 +++++++
 drivers/net/wireless/rsi/rsi_main.h         |  30 +++-
 drivers/net/wireless/rsi/rsi_mgmt.h         |  26 ++-
 drivers/net/wireless/rsi/rsi_sdio.h         |   4 +-
 drivers/net/wireless/rsi/rsi_usb.h          |   5 +-
 13 files changed, 617 insertions(+), 207 deletions(-)

-- 
2.7.4
