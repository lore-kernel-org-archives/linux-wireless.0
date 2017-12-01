Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33303 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750854AbdLAHt2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Dec 2017 02:49:28 -0500
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, marcel@holtmann.org
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        linux-bluetooth@vger.kernel.org
Subject: [v3 0/8] rsi: add bluetooth and coex support
Date: Fri,  1 Dec 2017 13:11:17 +0530
Message-Id: <1512114085-2615-1-git-send-email-amitkarwar@gmail.com> (sfid-20171201_084950_645060_31486050)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <amit.karwar@redpinesignals.com>

This patch series adds new bluetooth driver and coex enhancments
in existing wlan driver for RSI chipsets.
As per our architecture, both wlan and bluetooth drivers talk
over same SDIO interface to device. Separate endpoint will be
used in case of USB interface.

Changes in v3: 5/8 and 6/8 patches are modified
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
 drivers/bluetooth/btrsi.c                   | 211 ++++++++++++++++++++++++++++
 drivers/bluetooth/rsi_hci.h                 |  40 ++++++
 drivers/net/wireless/rsi/Kconfig            |   2 +-
 drivers/net/wireless/rsi/Makefile           |   1 +
 drivers/net/wireless/rsi/rsi_91x_coex.c     | 184 ++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_core.c     |  16 ++-
 drivers/net/wireless/rsi/rsi_91x_hal.c      |  56 ++++++--
 drivers/net/wireless/rsi/rsi_91x_main.c     | 110 ++++++++++++++-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     |   2 +-
 drivers/net/wireless/rsi/rsi_91x_sdio.c     |  13 +-
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |   5 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c      | 124 +++++++++++-----
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c  |  35 +++--
 drivers/net/wireless/rsi/rsi_coex.h         |  38 +++++
 drivers/net/wireless/rsi/rsi_common.h       |   5 +-
 drivers/net/wireless/rsi/rsi_hal.h          |  21 +++
 drivers/net/wireless/rsi/rsi_main.h         |  20 +--
 drivers/net/wireless/rsi/rsi_mgmt.h         |   3 +
 drivers/net/wireless/rsi/rsi_usb.h          |  16 ++-
 include/linux/rsi_header.h                  |  56 ++++++++
 22 files changed, 888 insertions(+), 83 deletions(-)
 create mode 100644 drivers/bluetooth/btrsi.c
 create mode 100644 drivers/bluetooth/rsi_hci.h
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_coex.c
 create mode 100644 drivers/net/wireless/rsi/rsi_coex.h
 create mode 100644 include/linux/rsi_header.h

-- 
2.7.4
