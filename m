Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:50866 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752339AbdJ0Lcs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Oct 2017 07:32:48 -0400
Received: by mail-pf0-f193.google.com with SMTP id b6so4767004pfh.7
        for <linux-wireless@vger.kernel.org>; Fri, 27 Oct 2017 04:32:47 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [v3 0/3] rsi: WOWLAN support
Date: Fri, 27 Oct 2017 16:55:54 +0530
Message-Id: <1509103557-6215-1-git-send-email-amitkarwar@gmail.com> (sfid-20171027_133311_429264_20E1E521)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <amit.karwar@redpinesignals.com>

This patch series adds WOWLAN support for system's S3, S4 and
S5 power states. wakeup through magic packet has been verified
in these power states.

Changes since v2:
  Rebased the patch series to the latest code. Recently below patch
  got accepted which causes some conflicts.
	"drivers/wireless: rsi: Convert timers to use timer_setup()"

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
