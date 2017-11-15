Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:46555 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752745AbdKOH2T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Nov 2017 02:28:19 -0500
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, marcel@holtmann.org
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH 0/8] rsi: add bluetooth and coex support
Date: Wed, 15 Nov 2017 12:50:36 +0530
Message-Id: <1510730444-3237-1-git-send-email-amitkarwar@gmail.com> (sfid-20171115_082826_424417_8FA27744)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <amit.karwar@redpinesignals.com>

This patch series adds new bluetooth driver and coex enhancments
in existing wlan driver for RSI chipsets.
As per our architecture, both wlan and bluetooth drivers talk
over same SDIO interface to device. Separate endpoint will be
used in case of USB interface.

Prameela Rani Garnepudi (6):
  rsi: add rx control block to handle rx packets in USB
  rsi: add header file rsi_header
  rsi: add coex support
  Bluetooth: btrsi: add new rsi bluetooth driver
  rsi: add module parameter operating mode
  rsi: sdio changes to support BT

Siva Rebbagondla (2):
  rsi: add bluetooth rx endpoint
  rsi: handle BT traffic in driver

 drivers/bluetooth/Kconfig                   |  12 ++
 drivers/bluetooth/Makefile                  |   2 +
 drivers/bluetooth/btrsi.c                   | 268 ++++++++++++++++++++++++++++
 drivers/bluetooth/rsi_hci.h                 |  51 ++++++
 drivers/net/wireless/rsi/Makefile           |   1 +
 drivers/net/wireless/rsi/rsi_91x_coex.c     | 184 +++++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_core.c     |  16 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c      |  56 +++++-
 drivers/net/wireless/rsi/rsi_91x_main.c     | 127 ++++++++++++-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     |   2 +-
 drivers/net/wireless/rsi/rsi_91x_sdio.c     |  13 +-
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |   5 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c      | 124 +++++++++----
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c  |  35 ++--
 drivers/net/wireless/rsi/rsi_coex.h         |  38 ++++
 drivers/net/wireless/rsi/rsi_common.h       |   5 +-
 drivers/net/wireless/rsi/rsi_hal.h          |  21 +++
 drivers/net/wireless/rsi/rsi_main.h         |  22 +--
 drivers/net/wireless/rsi/rsi_mgmt.h         |   3 +
 drivers/net/wireless/rsi/rsi_usb.h          |  16 +-
 include/linux/rsi_header.h                  |  58 ++++++
 21 files changed, 977 insertions(+), 82 deletions(-)
 create mode 100644 drivers/bluetooth/btrsi.c
 create mode 100644 drivers/bluetooth/rsi_hci.h
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_coex.c
 create mode 100644 drivers/net/wireless/rsi/rsi_coex.h
 create mode 100644 include/linux/rsi_header.h

-- 
2.7.4
