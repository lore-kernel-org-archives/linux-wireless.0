Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:59700 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751373AbdK0Kd0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Nov 2017 05:33:26 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2017-11-27
Date: Mon, 27 Nov 2017 11:32:56 +0100
Message-Id: <20171127103257.13399-1-johannes@sipsolutions.net> (sfid-20171127_113333_416703_18C779F9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

Here are a few more fixes, one of which fixes the crash Florian
reported which I think is the same that zero-day reported.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit a13e8d418f3cb9d0b4efa6e744b8b23c0e3cdfe8:

  Merge tag 'mac80211-for-davem-2017-11-20' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211 (2017-11-21 20:30:57 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2017-11-27

for you to fetch changes up to 72e2c3438ba3bd2ed640b6b5ea9e58993dd9ab7f:

  mac80211: tear down RX aggregations first (2017-11-27 11:24:59 +0100)

----------------------------------------------------------------
Four fixes:
 * CRYPTO_SHA256 is needed for regdb validation
 * mac80211: mesh path metric was wrong in some frames
 * mac80211: use QoS null-data packets on QoS connections
 * mac80211: tear down RX aggregation sessions first to
   drop fewer packets in HW restart scenarios

----------------------------------------------------------------
Chun-Yeow Yeoh (1):
      mac80211: fix the update of path metric for RANN frame

Johannes Berg (2):
      cfg80211: select CRYPTO_SHA256 if needed
      mac80211: use QoS NDP for AP probing

Sara Sharon (1):
      mac80211: tear down RX aggregations first

 drivers/net/wireless/ath/ath9k/channel.c |  2 +-
 drivers/net/wireless/st/cw1200/sta.c     |  4 ++--
 drivers/net/wireless/ti/wl1251/main.c    |  2 +-
 drivers/net/wireless/ti/wlcore/cmd.c     |  5 +++--
 include/net/mac80211.h                   |  8 +++++++-
 net/mac80211/ht.c                        |  4 +++-
 net/mac80211/mesh_hwmp.c                 | 15 +++++++++------
 net/mac80211/mlme.c                      |  2 +-
 net/mac80211/tx.c                        | 29 +++++++++++++++++++++++++++--
 net/wireless/Kconfig                     |  7 +++++++
 10 files changed, 61 insertions(+), 17 deletions(-)
