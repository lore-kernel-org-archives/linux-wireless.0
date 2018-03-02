Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:42786 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1425209AbeCBJG7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 04:06:59 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2018-03-02
Date: Fri,  2 Mar 2018 10:06:54 +0100
Message-Id: <20180302090655.31669-1-johannes@sipsolutions.net> (sfid-20180302_100847_686091_495D18A7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

Like before... Thanks for pulling net into net-next, the Add-BA patch
below would otherwise not really be possible :-)

The only sort of interesting thing is the fast-RX improvements from
Felix, they help on routers where these things (A-MSDU and 4-addr mode)
are more important and where fast-RX really helps due to the reduced
CPU load.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit f74290fdb363665538743d14c4f00aeacdb68d87:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2018-02-24 00:04:20 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-davem-2018-03-02

for you to fetch changes up to 2e75bb2f8b8928aa01d91219a90df1e6fbc7cdd4:

  net: Convert hwsim_net_ops (2018-03-02 10:01:25 +0100)

----------------------------------------------------------------
Only a few new things:
 * hwsim net namespace stuff from Kirill Tkhai
 * A-MSDU support in fast-RX
 * 4-addr mode support in fast-RX
 * support for a spec quirk in Add-BA negotiation

----------------------------------------------------------------
Felix Fietkau (4):
      mac80211: support AP 4-addr mode fast-rx
      mac80211: support fast-rx with incompatible PS capabilities when PS is disabled
      mac80211: support station 4-addr mode fast-rx
      mac80211: support A-MSDU in fast-rx

Ilan Peer (1):
      mac80211: agg-rx: Accept ADDBA request update if timeout did not change

Kirill Tkhai (2):
      mac80211_hwsim: Make hwsim_netgroup IDA
      net: Convert hwsim_net_ops

 drivers/net/wireless/mac80211_hwsim.c |  15 ++--
 include/net/cfg80211.h                |   6 +-
 net/mac80211/agg-rx.c                 |  14 ++-
 net/mac80211/cfg.c                    |   1 +
 net/mac80211/rx.c                     | 159 +++++++++++++++++++++-------------
 net/wireless/util.c                   |   5 +-
 6 files changed, 128 insertions(+), 72 deletions(-)
