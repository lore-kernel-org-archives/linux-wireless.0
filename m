Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:44221 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754395AbdLFKEy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Dec 2017 05:04:54 -0500
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, marcel@holtmann.org
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        linux-bluetooth@vger.kernel.org
Subject: [v4 0/8] rsi: add bluetooth and coex support
Date: Wed,  6 Dec 2017 15:26:29 +0530
Message-Id: <1512554197-19664-1-git-send-email-amitkarwar@gmail.com> (sfid-20171206_110500_869591_C7920708)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <amit.karwar@redpinesignals.com>

This patch series adds new bluetooth driver and coex enhancments
in existing wlan driver for RSI chipsets.
As per our architecture, both wlan and bluetooth drivers talk
over same SDIO interface to device. Separate endpoint will be
used in case of USB interface.

Changes in v4: 5/8 is modified
Changes in v3: 4/8, 5/8 and 6/8 patches are modified
Changes in v2: 2/8, 5/8 and 6/8 patches are modified

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

 drivers/bluetooth/Kconfig                   |  11 ++
 drivers/bluetooth/Makefile                  |   2 +
 drivers/bluetooth/btrsi.c                   | 224 ++++++++++++++++++++++++++++
 drivers/net/wireless/rsi/Kconfig            |   2 +-
 drivers/net/wireless/rsi/Makefile           |   1 +
 drivers/net/wireless/rsi/rsi_91x_coex.c     | 184 +++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_core.c     |  16 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c      |  56 ++++++-
 drivers/net/wireless/rsi/rsi_91x_main.c     | 110 +++++++++++++-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     |   2 +-
 drivers/net/wireless/rsi/rsi_91x_sdio.c     |  13 +-
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |   5 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c      | 124 +++++++++++----
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c  |  35 +++--
 drivers/net/wireless/rsi/rsi_coex.h         |  38 +++++
 drivers/net/wireless/rsi/rsi_common.h       |   5 +-
 drivers/net/wireless/rsi/rsi_hal.h          |  21 +++
 drivers/net/wireless/rsi/rsi_main.h         |  20 +--
 drivers/net/wireless/rsi/rsi_mgmt.h         |   3 +
 drivers/net/wireless/rsi/rsi_usb.h          |  16 +-
 include/linux/rsi_header.h                  |  56 +++++++
 21 files changed, 861 insertions(+), 83 deletions(-)
 create mode 100644 drivers/bluetooth/btrsi.c
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_coex.c
 create mode 100644 drivers/net/wireless/rsi/rsi_coex.h
 create mode 100644 include/linux/rsi_header.h

-- 
2.7.4
