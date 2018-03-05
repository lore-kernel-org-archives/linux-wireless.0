Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:45987 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751294AbeCEOsq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Mar 2018 09:48:46 -0500
Received: by mail-pf0-f170.google.com with SMTP id h19so6392779pfd.12
        for <linux-wireless@vger.kernel.org>; Mon, 05 Mar 2018 06:48:46 -0800 (PST)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Subject: [PATCH 00/10] rsi driver enhancements
Date: Mon,  5 Mar 2018 20:06:50 +0530
Message-Id: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com> (sfid-20180305_154850_670446_E3427B03)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <amit.karwar@redpinesignals.com>

This patch series brings in improvements in scan, Tx path, roaming and
regulatory handling.

Prameela Rani Garnepudi (9):
  rsi: add support for hardware scan offload
  rsi: move xtend_desc structure from rsi_main.h to rsi_mgmt.h
  rsi: move descriptor preparation to core
  rsi: enable 80MHz clock by default
  rsi: roaming enhancements
  rsi: add module parameter rsi_reg
  rsi: regulatory modifications for 'dlcar' mode
  rsi: device disconnect changes
  rsi: tx improvements

Siva Rebbagondla (1):
  rsi: drop RX broadcast/multicast packets with invalid PN

 drivers/net/wireless/rsi/rsi_91x_core.c     |  31 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c      |  82 +++--
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 353 +++++++++++++++++++---
 drivers/net/wireless/rsi/rsi_91x_main.c     |  20 ++
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 447 +++++++++++++++++++++++++++-
 drivers/net/wireless/rsi/rsi_91x_usb.c      |  10 +
 drivers/net/wireless/rsi/rsi_boot_params.h  |   3 +-
 drivers/net/wireless/rsi/rsi_common.h       |   3 +
 drivers/net/wireless/rsi/rsi_hal.h          |   3 +
 drivers/net/wireless/rsi/rsi_main.h         |  50 +++-
 drivers/net/wireless/rsi/rsi_mgmt.h         |  67 ++++-
 11 files changed, 977 insertions(+), 92 deletions(-)

-- 
2.7.4
