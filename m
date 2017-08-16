Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:38238 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751637AbdHPNRj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Aug 2017 09:17:39 -0400
Received: by mail-pf0-f194.google.com with SMTP id h75so1362746pfh.5
        for <linux-wireless@vger.kernel.org>; Wed, 16 Aug 2017 06:17:38 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [v2 00/11] rsi: support for AP mode
Date: Wed, 16 Aug 2017 18:43:07 +0530
Message-Id: <1502889198-4478-1-git-send-email-amitkarwar@gmail.com> (sfid-20170816_151742_940574_DE926DAC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <amit.karwar@redpinesignals.com>

This patchset contains enhancements for AP mode operation.
Major changes are maintaining the station structures in
driver and adding station id parameter to the Tx packets
whenever required.
Tests are performed to confirm aggregation, connections in
WEP and WPA/WPA2 security.

Changes in v2:
patch 5/10: Avoided print_hex_dump to print station MAC in sta_add
patch 6/10: Avoided print hex_dump to print station MAC in sta_remove

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
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 342 +++++++++++++++++++++++-----
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 180 +++++++++++----
 drivers/net/wireless/rsi/rsi_common.h       |   1 +
 drivers/net/wireless/rsi/rsi_hal.h          |   4 +-
 drivers/net/wireless/rsi/rsi_main.h         |  27 ++-
 drivers/net/wireless/rsi/rsi_mgmt.h         |  35 ++-
 8 files changed, 641 insertions(+), 147 deletions(-)

-- 
2.7.4
