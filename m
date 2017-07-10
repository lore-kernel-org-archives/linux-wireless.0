Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36299 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754063AbdGJMoM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Jul 2017 08:44:12 -0400
Received: by mail-pf0-f193.google.com with SMTP id z6so14392676pfk.3
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jul 2017 05:44:12 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [v2 00/17] rsi: station enhancements
Date: Mon, 10 Jul 2017 18:10:31 +0530
Message-Id: <1499690448-9956-1-git-send-email-amitkarwar@gmail.com> (sfid-20170710_144440_827522_059E1027)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <amit.karwar@redpinesignals.com>

We have internal management frames(commands) sent to firmware for
various configurations. This patch defines some common structures
which can be shared by those frames. Key handling and regulatory
enhancements are also includesd. With this patch series included,
station can connect to security enabled AP and send/receive data.

Changes in v2:
v1 patch series is rebased to latest code. v1 fails to apply, as
below patch is merged recently.
b952f4dff27 ("net: manual clean code which call skb_put_[data:zero]")

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
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 380 ++++++++++++++--------------
 drivers/net/wireless/rsi/rsi_main.h         |  18 +-
 drivers/net/wireless/rsi/rsi_mgmt.h         | 143 ++++++++++-
 4 files changed, 399 insertions(+), 205 deletions(-)

-- 
2.7.4
