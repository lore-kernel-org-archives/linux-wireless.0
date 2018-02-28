Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:42888 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751423AbeB1HuO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 02:50:14 -0500
Received: by mail-pg0-f65.google.com with SMTP id y8so654211pgr.9
        for <linux-wireless@vger.kernel.org>; Tue, 27 Feb 2018 23:50:13 -0800 (PST)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Subject: [PATCH 0/3] rsi: RX path improvements 
Date: Wed, 28 Feb 2018 13:08:25 +0530
Message-Id: <1519803508-27737-1-git-send-email-amitkarwar@gmail.com> (sfid-20180228_085017_880587_1D418885)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <amit.karwar@redpinesignals.com>

This patch series adds a thread for Rx handling and other related
enhancements for better throughput.

Prameela Rani Garnepudi (3):
  rsi: improve RX handling in SDIO interface
  rsi: use dynamic RX control blocks instead of MAX_RX_URB
  rsi: improve RX packet handling in USB interface

 drivers/net/wireless/rsi/rsi_91x_sdio.c     |  45 +++++++---
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |  64 ++++++++++++---
 drivers/net/wireless/rsi/rsi_91x_usb.c      | 122 ++++++++++++++++------------
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c  |  34 +++-----
 drivers/net/wireless/rsi/rsi_hal.h          |   1 +
 drivers/net/wireless/rsi/rsi_main.h         |   2 +-
 drivers/net/wireless/rsi/rsi_sdio.h         |   8 ++
 drivers/net/wireless/rsi/rsi_usb.h          |   5 +-
 8 files changed, 181 insertions(+), 100 deletions(-)

-- 
2.7.4
