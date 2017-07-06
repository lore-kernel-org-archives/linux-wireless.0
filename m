Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36124 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750970AbdGFOlW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 10:41:22 -0400
Received: by mail-pf0-f194.google.com with SMTP id z6so549586pfk.3
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jul 2017 07:41:22 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [v3 00/21] rsi driver enhancements
Date: Thu,  6 Jul 2017 20:07:03 +0530
Message-Id: <1499351844-2046-1-git-send-email-amitkarwar@gmail.com> (sfid-20170706_164126_691112_7A0F96ED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <amit.karwar@redpinesignals.com>

This patch series includes some fixes and enhancements in Tx and Rx
data paths. Connection in open security and data traffic has been
verified with SDIO and USB variants of 9113 chipset.

Changes in v3 series:
1/21: Newly added patch in v3 which makes use of BUILD_BUG_ON to avoid
      potential issue in future(Kalle Valo)
2/21: Added missing change in debugfs fsm_state array(Kalle Valo)
12/21, 14/21, 15/21, 16/21: Pavani's name corrected

Changes in v2 series:
1/20: Get rid of __LITTLE_ENDIAN flag usage
11/20: Get rid of __LITTLE_ENDIAN flag usage
12/20: Changes to match modified 11/20
13/20: Get rid of __LITTLE_ENDIAN flag usage
14/20: Changes to match modified 13/20
15/20: Changes to match modified 13/20
19/20: mutex_init was missed for rx_lock in v1

Amitkumar Karwar (2):
  rsi: use BUILD_BUG_ON check for fsm_state
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

Pavani Muthyala (4):
  rsi: management frame descriptor preparation cleanup
  rsi: data packet descriptor code cleanup
  rsi: data packet descriptor enhancements
  rsi: separate function for data packet descriptor

Prameela Rani Garnepudi (2):
  rsi: changes in eeprom read frame
  rsi: separate function for management packet descriptor

 drivers/net/wireless/rsi/rsi_91x_core.c     |  10 +-
 drivers/net/wireless/rsi/rsi_91x_debugfs.c  |   3 +
 drivers/net/wireless/rsi/rsi_91x_hal.c      | 270 ++++++++++++++++++----------
 drivers/net/wireless/rsi/rsi_91x_main.c     |   3 +-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     |  90 +++++++---
 drivers/net/wireless/rsi/rsi_91x_sdio.c     | 154 ++++++++++++----
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |  44 +++--
 drivers/net/wireless/rsi/rsi_91x_usb.c      | 118 +++++++++---
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c  |   6 +-
 drivers/net/wireless/rsi/rsi_hal.h          |  64 +++++++
 drivers/net/wireless/rsi/rsi_main.h         |  34 +++-
 drivers/net/wireless/rsi/rsi_mgmt.h         |  26 ++-
 drivers/net/wireless/rsi/rsi_sdio.h         |   4 +-
 drivers/net/wireless/rsi/rsi_usb.h          |   5 +-
 14 files changed, 623 insertions(+), 208 deletions(-)

-- 
2.7.4
