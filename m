Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:41070 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751364AbdKTQGv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Nov 2017 11:06:51 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2017-11-20
Date: Mon, 20 Nov 2017 17:06:44 +0100
Message-Id: <20171120160645.21074-1-johannes@sipsolutions.net> (sfid-20171120_170655_608527_2815222D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

Sorry this is coming now, I had a super hectic time after travel
since I had to catch up after two weeks of being away ...

That's not really an excuse, but I'm asking you anyway to pull
Kees's timer conversions with the fixes since he really wants
to make more changes on top and clean this up properly. I've had
those pending, but in the hectic week after coming back didn't
send the mac80211-next pull request that I should have done.

If you don't want that, let me know and I'll respin without it.

Otherwise, please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 32a72bbd5da2411eab591bf9bc2e39349106193a:

  net: vxge: Fix some indentation issues (2017-11-20 11:36:30 +0900)

are available in the git repository at:

  ssh://korg/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2017-11-20

for you to fetch changes up to 33ddd81e2bd5d9970b9f01ab383ba45035fa41ee:

  mac80211: properly free requested-but-not-started TX agg sessions (2017-11-20 17:01:31 +0100)

----------------------------------------------------------------
A few things:
 * straggler timer conversions from Kees
 * memory leak fix in hwsim
 * fix some fallout from regdb changes if wireless is built-in
 * also free aggregation sessions in startup state when station
   goes away, to avoid crashing the timer

----------------------------------------------------------------
Ben Hutchings (1):
      mac80211_hwsim: Fix memory leak in hwsim_new_radio_nl()

Johannes Berg (3):
      nl80211: don't expose wdev->ssid for most interfaces
      cfg80211: initialize regulatory keys/database later
      mac80211: properly free requested-but-not-started TX agg sessions

Kees Cook (2):
      mac80211: Convert timers to use timer_setup()
      mac80211: aggregation: Convert timers to use timer_setup()

 drivers/net/wireless/mac80211_hwsim.c |  5 +++-
 net/mac80211/agg-rx.c                 | 41 ++++++++++++-----------------
 net/mac80211/agg-tx.c                 | 49 ++++++++++++++++-------------------
 net/mac80211/ibss.c                   |  7 +++--
 net/mac80211/ieee80211_i.h            |  3 ++-
 net/mac80211/led.c                    | 11 ++++----
 net/mac80211/main.c                   |  3 +--
 net/mac80211/mesh.c                   | 27 +++++++++----------
 net/mac80211/mesh.h                   |  2 +-
 net/mac80211/mesh_hwmp.c              |  4 +--
 net/mac80211/mesh_pathtbl.c           |  3 +--
 net/mac80211/mlme.c                   | 32 ++++++++++-------------
 net/mac80211/ocb.c                    | 10 +++----
 net/mac80211/sta_info.c               | 15 +++--------
 net/mac80211/sta_info.h               | 12 +++++++--
 net/wireless/nl80211.c                | 26 +++++++++++++++++--
 net/wireless/reg.c                    | 42 +++++++++++++++++++-----------
 17 files changed, 155 insertions(+), 137 deletions(-)
