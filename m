Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33364 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753127AbdHKNpp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Aug 2017 09:45:45 -0400
Received: by mail-pg0-f68.google.com with SMTP id u185so3197721pgb.0
        for <linux-wireless@vger.kernel.org>; Fri, 11 Aug 2017 06:45:45 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 00/11] rsi: support for AP mode
Date: Fri, 11 Aug 2017 19:11:18 +0530
Message-Id: <1502458889-9690-1-git-send-email-amitkarwar@gmail.com> (sfid-20170811_154548_742319_A46DC480)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <amit.karwar@redpinesignals.com>

This patchset contains enhancements for AP mode operation.
Major changes are maintaining the station structures in
driver and adding station id parameter to the Tx packets
whenever required.
Tests are performed to confirm aggregation, connections in
WEP and WPA security. 

Prameela Rani Garnepudi (11):
  rsi: advertise ap mode support
  rsi: add interface changes for ap mode
  rsi: remove interface changes for AP mode
  rsi: add beacon changes for AP mode
  rsi: handle station connection in AP mode
  rsi: handle station disconnection in AP mode
  rsi: data and managemet path changes for AP mode
  rsi: use common descriptor for auto rate frame
  rsi: update tx auto rate command frame for AP mode
  rsi: aggregation parameters frame for AP mode
  rsi: security enhancements for AP mode

 drivers/net/wireless/rsi/rsi_91x_core.c     |  70 ++++--
 drivers/net/wireless/rsi/rsi_91x_hal.c      | 129 +++++++++--
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 344 +++++++++++++++++++++++-----
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 180 +++++++++++----
 drivers/net/wireless/rsi/rsi_common.h       |   1 +
 drivers/net/wireless/rsi/rsi_hal.h          |   4 +-
 drivers/net/wireless/rsi/rsi_main.h         |  27 ++-
 drivers/net/wireless/rsi/rsi_mgmt.h         |  35 ++-
 8 files changed, 643 insertions(+), 147 deletions(-)

-- 
2.7.4
