Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35807 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752666AbeBSNay (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 08:30:54 -0500
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, marcel@holtmann.org
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        linux-bluetooth@vger.kernel.org
Subject: [v7 0/8] rsi: add bluetooth and coex support
Date: Mon, 19 Feb 2018 18:49:31 +0530
Message-Id: <1519046379-10068-1-git-send-email-amitkarwar@gmail.com> (sfid-20180219_143057_773766_0F5CE2AA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <amit.karwar@redpinesignals.com>

This patch series adds new bluetooth driver and coex enhancments
in existing wlan driver for RSI chipsets.
As per our architecture, both wlan and bluetooth drivers talk
over same SDIO interface to device. Separate endpoint will be
used in case of USB interface.

Change in v7: 4/8 is modified
Changes in v6: 1/8, 3/8, 4/8, 5/8, 6/8 are modified
Changes in v5: 5/8 is modified
Changes in v4: 5/8 is modified
Changes in v3: 4/8, 5/8 and 6/8 patches are modified
Changes in v2: 2/8, 5/8 and 6/8 patches are modified

Prameela Rani Garnepudi (6):
  rsi: add rx control block to handle rx packets in USB
  rsi: add header file rsi_91x
  rsi: add coex support
  Bluetooth: btrsi: add new rsi bluetooth driver
  rsi: add module parameter operating mode
  rsi: sdio changes to support BT

Siva Rebbagondla (2):
  rsi: add bluetooth rx endpoint
  rsi: handle BT traffic in driver

 drivers/bluetooth/Kconfig                   |  12 ++
 drivers/bluetooth/Makefile                  |   2 +
 drivers/bluetooth/btrsi.c                   | 188 ++++++++++++++++++++++++++++
 drivers/net/wireless/rsi/Kconfig            |   9 ++
 drivers/net/wireless/rsi/Makefile           |   1 +
 drivers/net/wireless/rsi/rsi_91x_coex.c     | 179 ++++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_core.c     |  20 ++-
 drivers/net/wireless/rsi/rsi_91x_hal.c      |  56 +++++++--
 drivers/net/wireless/rsi/rsi_91x_main.c     | 129 ++++++++++++++++++-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     |   2 +-
 drivers/net/wireless/rsi/rsi_91x_sdio.c     |  13 +-
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |   5 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c      | 124 +++++++++++++-----
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c  |  35 ++++--
 drivers/net/wireless/rsi/rsi_coex.h         |  38 ++++++
 drivers/net/wireless/rsi/rsi_common.h       |   5 +-
 drivers/net/wireless/rsi/rsi_hal.h          |  21 ++++
 drivers/net/wireless/rsi/rsi_main.h         |  21 ++--
 drivers/net/wireless/rsi/rsi_mgmt.h         |   3 +
 drivers/net/wireless/rsi/rsi_usb.h          |  16 ++-
 include/net/rsi_91x.h                       |  56 +++++++++
 21 files changed, 853 insertions(+), 82 deletions(-)
 create mode 100644 drivers/bluetooth/btrsi.c
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_coex.c
 create mode 100644 drivers/net/wireless/rsi/rsi_coex.h
 create mode 100644 include/net/rsi_91x.h

-- 
2.7.4
