Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64660 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754535AbcI1X7b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2016 19:59:31 -0400
From: Thomas Pedersen <twp@qca.qualcomm.com>
To: ath10k <ath10k@lists.infradead.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
        Thomas Pedersen <twp@qca.qualcomm.com>
Subject: [PATCH 0/4] ath10k: fix mesh sync operation
Date: Wed, 28 Sep 2016 16:56:27 -0700
Message-ID: <20160928235631.9197-1-twp@qca.qualcomm.com> (sfid-20160929_015935_293622_5DEFFE7A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset introduces a new ieee80211_op offset_tsf(), which gives
the driver a s64 TSF offset for TSF adjustment. This is more accurate
than programming absolute TSF since programming delay is avoided.

ath10k can't get the current TSF or program an absolute TSF, so we
remove those ops to not mislead the stack and hopefully avoid future
bugs.

Tested on QCA4019 with firmware 10.4-3.2.1-0033. After this change
Toffset remains stable to within 5us.

Thomas Pedersen (4):
  mac80211: add offset_tsf driver op
  ath10k: implement offset_tsf ieee80211_op
  ath10k: remove set/get_tsf ieee80211_ops
  mac80211: mesh: decrease max drift

 drivers/net/wireless/ath/ath10k/mac.c     | 45 +++++++++++--------------------
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  1 -
 drivers/net/wireless/ath/ath10k/wmi.c     |  6 ++---
 drivers/net/wireless/ath/ath10k/wmi.h     |  8 +++++-
 include/net/mac80211.h                    |  8 ++++++
 net/mac80211/debugfs_netdev.c             | 12 ++++++---
 net/mac80211/driver-ops.c                 | 15 +++++++++++
 net/mac80211/driver-ops.h                 |  3 +++
 net/mac80211/mesh_sync.c                  | 12 ++++++---
 net/mac80211/trace.h                      | 26 ++++++++++++++++++
 10 files changed, 94 insertions(+), 42 deletions(-)

-- 
2.10.0.297.gf6727b0
