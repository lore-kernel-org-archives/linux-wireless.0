Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:39014 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727204AbeH2Pup (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 11:50:45 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2018-08-29
Date: Wed, 29 Aug 2018 13:53:52 +0200
Message-Id: <20180829115353.31679-1-johannes@sipsolutions.net> (sfid-20180829_135414_524022_8D07555C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

Here's a small update for net-next, there's not much but since we
still don't have a shared tree, the ieee80211_send_layer2_update()
should go to Kalle through your tree :)

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 050cdc6c9501abcd64720b8cc3e7941efee9547d:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2018-08-27 11:59:39 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-davem-2018-08-29

for you to fetch changes up to 9c06602b1b920ed6b546632bdbbc1f400eea5242:

  cfg80211: clarify frames covered by average ACK signal report (2018-08-29 11:01:51 +0200)

----------------------------------------------------------------
Only a few changes at this point:
 * new channels in 60 GHz
 * clarify (average) ACK signal reporting API
 * expose ieee80211_send_layer2_update() for all drivers
 * start/stop mac80211's TXQs properly when required
 * avoid regulatory restore with IE ignoring
 * spelling: contidion -> condition
 * fully implement WFA Multi-AP backhaul

----------------------------------------------------------------
Alexei Avshalom Lazar (1):
      cfg80211: Add support for 60GHz band channels 5 and 6

Balaji Pothunoori (1):
      cfg80211: clarify frames covered by average ACK signal report

Dedy Lansky (1):
      cfg80211/mac80211: make ieee80211_send_layer2_update a public function

Manikanta Pubbisetty (1):
      mac80211: add stop/start logic for software TXQs

Rajeev Kumar Sirasanagandla (1):
      cfg80211: Avoid regulatory restore when COUNTRY_IE_IGNORE is set

Richard Guy Briggs (1):
      rfkill: fix spelling mistake contidion to condition

Sathishkumar Muruganandam (1):
      mac80211: add missing WFA Multi-AP backhaul STA Rx requirement

 drivers/net/wireless/ath/wil6210/debugfs.c |   2 +-
 include/net/cfg80211.h                     |  13 +++-
 include/net/mac80211.h                     |   4 ++
 include/uapi/linux/nl80211.h               |  20 +++---
 net/mac80211/cfg.c                         |  48 +------------
 net/mac80211/ieee80211_i.h                 |   3 +
 net/mac80211/main.c                        |   4 ++
 net/mac80211/rx.c                          |   2 +-
 net/mac80211/sta_info.c                    |   6 +-
 net/mac80211/tx.c                          |  11 ++-
 net/mac80211/util.c                        | 110 +++++++++++++++++++++++++++--
 net/rfkill/core.c                          |   4 +-
 net/wireless/nl80211.c                     |   7 +-
 net/wireless/reg.c                         |  48 ++++++++++++-
 net/wireless/trace.h                       |   2 +-
 net/wireless/util.c                        |  51 ++++++++++++-
 16 files changed, 258 insertions(+), 77 deletions(-)
