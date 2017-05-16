Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:36613 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752038AbdEPKCk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 06:02:40 -0400
Received: by mail-pg0-f65.google.com with SMTP id h64so16095640pge.3
        for <linux-wireless@vger.kernel.org>; Tue, 16 May 2017 03:02:40 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [v3 00/11] Firmware loading changes
Date: Tue, 16 May 2017 15:31:06 +0530
Message-Id: <1494928877-27168-1-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170516_120246_131549_BD7FFFB4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series includes firmware loading enhancements for
Redpine 9113 chipset. The older method is not being used by any
Redpine chipset. There is no firmware image submitted to upstream
yet. We will submit 9113's firmware image once these changes are
accepted.

Amitkumar Karwar (1):
  rsi: define RSI_USB_BUF_SIZE macro

Prameela Rani Garnepudi (10):
  rsi: Rename file rsi_91x_pkt.c to rsi_91x_hal.c
  rsi: Changes to sdio reads and writes
  rsi: Changes in USB read and write operations
  rsi: use macros in USB specific code
  rsi: Handle usb multi-byte write failure case properly
  rsi: Add usb multi-byte read operation
  rsi: Add host interface operations as separate structure.
  rsi: Add new host interface operations
  rsi: Add new firmware loading method
  rsi: Remove old firmware loading method

 drivers/net/wireless/rsi/Makefile           |   2 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c      | 740 ++++++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_pkt.c      | 215 --------
 drivers/net/wireless/rsi/rsi_91x_sdio.c     | 211 +++++++-
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c | 190 +------
 drivers/net/wireless/rsi/rsi_91x_usb.c      | 166 ++++++-
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c  | 125 -----
 drivers/net/wireless/rsi/rsi_common.h       |   3 +-
 drivers/net/wireless/rsi/rsi_hal.h          |  81 +++
 drivers/net/wireless/rsi/rsi_main.h         |  36 +-
 drivers/net/wireless/rsi/rsi_sdio.h         |   6 +-
 drivers/net/wireless/rsi/rsi_usb.h          |   5 +-
 12 files changed, 1205 insertions(+), 575 deletions(-)
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_hal.c
 delete mode 100644 drivers/net/wireless/rsi/rsi_91x_pkt.c
 create mode 100644 drivers/net/wireless/rsi/rsi_hal.h

-- 
2.7.4
