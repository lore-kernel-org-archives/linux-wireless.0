Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:50538 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755827AbeFOMiq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Jun 2018 08:38:46 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2018-06-15
Date: Fri, 15 Jun 2018 14:38:37 +0200
Message-Id: <20180615123838.852-1-johannes@sipsolutions.net> (sfid-20180615_143853_423087_3D6680B0)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

We have just a handful of pretty simple fixes for this round
of updates for the current cycle.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 7f6afc338405628ae32826ce82827c3f19bf3d15:

  Merge branch 'l2tp-fixes' (2018-06-14 17:10:19 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2018-06-15

for you to fetch changes up to bf2b61a6838f19cbc33f6732715012c483fa3795:

  cfg80211: fix rcu in cfg80211_unregister_wdev (2018-06-15 13:05:14 +0200)

----------------------------------------------------------------
A handful of fixes:
 * missing RCU grace period enforcement led to drivers freeing
   data structures before; fix from Dedy Lansky.
 * hwsim module init error paths were messed up; fixed it myself
   after a report from Colin King (who had sent a partial patch)
 * kernel-doc tag errors; fix from Luca Coelho
 * initialize the on-stack sinfo data structure when getting
   station information; fix from Sven Eckelmann
 * TXQ state dumping is now done from init, and when TXQs aren't
   initialized yet at that point, bad things happen, move the
   initialization; fix from Toke Høiland-Jørgensen.

----------------------------------------------------------------
Dedy Lansky (1):
      cfg80211: fix rcu in cfg80211_unregister_wdev

Johannes Berg (1):
      mac80211_hwsim: fix module init error paths

Luca Coelho (1):
      nl80211: fix some kernel doc tag mistakes

Sven Eckelmann (1):
      cfg80211: initialize sinfo in cfg80211_get_station

Toke Høiland-Jørgensen (1):
      mac80211: Move up init of TXQs

 drivers/net/wireless/mac80211_hwsim.c | 11 +++++++++--
 include/uapi/linux/nl80211.h          | 28 ++++++++++++++--------------
 net/mac80211/main.c                   | 12 ++++++------
 net/wireless/core.c                   |  1 +
 net/wireless/util.c                   |  2 ++
 5 files changed, 32 insertions(+), 22 deletions(-)
