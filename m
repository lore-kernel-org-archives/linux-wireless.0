Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:50738 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751628AbdJYNto (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Oct 2017 09:49:44 -0400
Received: by mail-pg0-f67.google.com with SMTP id y5so25729pgq.7
        for <linux-wireless@vger.kernel.org>; Wed, 25 Oct 2017 06:49:44 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [v2 0/3] rsi: WOWLAN support
Date: Wed, 25 Oct 2017 19:13:04 +0530
Message-Id: <1508938984-16146-1-git-send-email-amitkarwar@gmail.com> (sfid-20171025_155037_557217_5F7FB371)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <amit.karwar@redpinesignals.com>

This patch series adds WOWLAN support for system's S3, S4 and
S5 power states. wakeup through magic packet has been verified
in these power states.

Changes since v1:
  1/3 Get rid of CONFIG_RSI_WOW compiler flag (Kalle Valo)
  2/3 Use ieee80211_restart_hw() instead of re-registering with mac80211 (Kalle Valo/Brian Norris)
  3/3 Get rid of CONFIG_RSI_WOW compiler flag

Karun Eagalapati (3):
  rsi: sdio: add WOWLAN support for S3 suspend state
  rsi: sdio: Add WOWLAN support for S4 hibernate state
  rsi: sdio: Add WOWLAN support for S5 shutdown state

 drivers/net/wireless/rsi/rsi_91x_core.c     |   8 ++
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 128 +++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_main.c     |   1 +
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     |  67 +++++++++++--
 drivers/net/wireless/rsi/rsi_91x_sdio.c     | 141 ++++++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_common.h       |   1 +
 drivers/net/wireless/rsi/rsi_main.h         |  12 ++-
 drivers/net/wireless/rsi/rsi_mgmt.h         |  31 +++++-
 drivers/net/wireless/rsi/rsi_sdio.h         |   1 +
 9 files changed, 378 insertions(+), 12 deletions(-)

-- 
2.7.4
