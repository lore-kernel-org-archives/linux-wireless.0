Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:38796 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750835AbdH3JnS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 05:43:18 -0400
Received: by mail-pf0-f196.google.com with SMTP id r187so3998601pfr.5
        for <linux-wireless@vger.kernel.org>; Wed, 30 Aug 2017 02:43:18 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 0/8] rsi: p2p mode support
Date: Wed, 30 Aug 2017 15:08:20 +0530
Message-Id: <1504085908-2163-1-git-send-email-amitkarwar@gmail.com> (sfid-20170830_114330_340458_7A900976)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <amit.karwar@redpinesignals.com>

p2p mode support is added in this patch series. Major changes
include allowing multiple interface addition and updating
interface type checks wherever needed.

Prameela Rani Garnepudi (8):
  rsi: add p2p support parameters to mac80211
  rsi: add/remove interface enhancements for p2p
  rsi: add support for p2p listen
  rsi: handle peer connection and disconnection in p2p mode
  rsi: tx and rx path enhancements for p2p mode
  rsi: disallow power save config when AP vap running
  rsi: aggregation changes for p2p mode
  rsi: miscellaneous changes for p2p mode

 drivers/net/wireless/rsi/rsi_91x_core.c     |  33 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c      |  73 +++--
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 446 ++++++++++++++++++++++------
 drivers/net/wireless/rsi/rsi_91x_main.c     |   9 +-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     |  46 +--
 drivers/net/wireless/rsi/rsi_91x_ps.c       |  15 +-
 drivers/net/wireless/rsi/rsi_common.h       |   4 +-
 drivers/net/wireless/rsi/rsi_hal.h          |   3 +-
 drivers/net/wireless/rsi/rsi_main.h         |  10 +-
 drivers/net/wireless/rsi/rsi_mgmt.h         |  21 +-
 drivers/net/wireless/rsi/rsi_ps.h           |   7 +-
 11 files changed, 495 insertions(+), 172 deletions(-)

-- 
2.7.4
