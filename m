Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35030 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751231AbdFWOKM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Jun 2017 10:10:12 -0400
Received: by mail-pg0-f66.google.com with SMTP id f127so6274702pgc.2
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jun 2017 07:10:11 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [PATCH 00/17] rsi: station enhancements
Date: Fri, 23 Jun 2017 19:37:19 +0530
Message-Id: <1498226856-6305-1-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170623_161015_988160_FE1B4636)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have internal management frames(commands) sent to firmware for
various configurations. This patch defines some common structures
which can be shared by those frames. Key handling and regulatory
enhancements are also includesd. With this patch series included,
station can connect to security enabled AP and send/receive data. 

Prameela Rani Garnepudi (17):
  rsi: add common structures needed for command packets
  rsi: immediate wakeup bit and priority for TX command packets
  rsi: Update in tx command frame radio capabilities
  rsi: remove unnecessary check for 802.11 management packet
  rsi: Update peer notify command frame
  rsi: Update aggregation parameters command frame
  rsi: Update baseband RF programming frame
  rsi: update set_channel command frame
  rsi: update vap capabilities command frame
  rsi: update set_key command frame
  rsi: set_key enhancements
  rsi: update autorate request command frame
  rsi: block/unblock data queues as per connection status
  rsi: update tx command frame block/unblock data
  rsi: Remove internal header from Tx status skb
  rsi: Send rx filter frame to device when interface is down
  rsi: regulatory enhancements

 drivers/net/wireless/rsi/rsi_91x_mac80211.c |  63 ++++-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 382 ++++++++++++++--------------
 drivers/net/wireless/rsi/rsi_main.h         |  18 +-
 drivers/net/wireless/rsi/rsi_mgmt.h         | 143 ++++++++++-
 4 files changed, 399 insertions(+), 207 deletions(-)

-- 
2.7.4
