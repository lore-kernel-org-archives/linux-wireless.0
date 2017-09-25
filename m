Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33392 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932395AbdIYN0p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Sep 2017 09:26:45 -0400
Received: by mail-pg0-f66.google.com with SMTP id i130so4868047pgc.0
        for <linux-wireless@vger.kernel.org>; Mon, 25 Sep 2017 06:26:45 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 0/3] rsi: WOWLAN support
Date: Mon, 25 Sep 2017 18:51:04 +0530
Message-Id: <1506345664-4610-1-git-send-email-amitkarwar@gmail.com> (sfid-20170925_152652_581493_BCF3D1CB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <amit.karwar@redpinesignals.com>

This patch series adds WOWLAN support for system's S3, S4 and
S5 power states. wakeup through magic packet has been verified
in these power states.

Karun Eagalapati (3):
  rsi: sdio: add WOWLAN support for S3 suspend state
  rsi: sdio: Add WOWLAN support for S4 hibernate state
  rsi: sdio: Add WOWLAN support for S5 shutdown state

 drivers/net/wireless/rsi/Kconfig            |   7 ++
 drivers/net/wireless/rsi/rsi_91x_core.c     |   9 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 126 +++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     |  66 ++++++++++--
 drivers/net/wireless/rsi/rsi_91x_sdio.c     | 150 ++++++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_common.h       |   3 +
 drivers/net/wireless/rsi/rsi_main.h         |  12 ++-
 drivers/net/wireless/rsi/rsi_mgmt.h         |  37 ++++++-
 8 files changed, 398 insertions(+), 12 deletions(-)

-- 
2.7.4
