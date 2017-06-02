Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35727 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750955AbdFBOPU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 10:15:20 -0400
Received: by mail-pf0-f196.google.com with SMTP id u26so11893340pfd.2
        for <linux-wireless@vger.kernel.org>; Fri, 02 Jun 2017 07:15:20 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Alexey.Brodkin@synopsys.com,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [PATCH 0/6] rsi driver bringup changes
Date: Fri,  2 Jun 2017 19:42:59 +0530
Message-Id: <1496412785-8720-1-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170602_161524_914674_8498A5E8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series includes the changes for adding USB chipset,
frames exchanged with firmware during initialization
and false interrupt problem fix for SDIO.

Amitkumar Karwar (1):
  rsi: use enum for FSM states

Prameela Rani Garnepudi (5):
  rsi: add usb RS9113 chipset support
  rsi: Register interrupt handler before firmware load
  rsi: receive path enhancement for RS9113
  rsi: configure new boot parameters to device
  rsi: add tx frame for common device configuration

 drivers/net/wireless/rsi/rsi_91x_hal.c     |   4 +-
 drivers/net/wireless/rsi/rsi_91x_main.c    |   9 +-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c    | 152 +++++++++++++++++++++++++----
 drivers/net/wireless/rsi/rsi_91x_sdio.c    |  21 ++--
 drivers/net/wireless/rsi/rsi_91x_usb.c     |   1 +
 drivers/net/wireless/rsi/rsi_boot_params.h |  15 +--
 drivers/net/wireless/rsi/rsi_hal.h         |   3 +
 drivers/net/wireless/rsi/rsi_main.h        |  29 ++++--
 drivers/net/wireless/rsi/rsi_mgmt.h        |  97 ++++++++++++++++++
 9 files changed, 286 insertions(+), 45 deletions(-)

-- 
2.7.4
