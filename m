Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:51266 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964931AbeEITgT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 15:36:19 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2018-05-09
Date: Wed,  9 May 2018 21:36:12 +0200
Message-Id: <20180509193613.10902-1-johannes@sipsolutions.net> (sfid-20180509_213626_254303_A8C67BF8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

We just have a few fixes this time around.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 64e86fec54069266ba32be551d7b7f75e88ab60c:

  net: qualcomm: rmnet: Fix warning seen with fill_info (2018-04-18 21:23:06 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2018-05-09

for you to fetch changes up to 914eac248d876f9c00cd1792ffec3d182c863f13:

  mac80211: use timeout from the AddBA response instead of the request (2018-05-07 20:35:15 +0200)

----------------------------------------------------------------
We only have a few fixes this time:
 * WMM element validation
 * SAE timeout
 * add-BA timeout
 * docbook parsing
 * a few memory leaks in error paths

----------------------------------------------------------------
Ilan Peer (2):
      mac80211: Fix condition validating WMM IE
      mac80211: Adjust SAE authentication timeout

Johan Hovold (1):
      rfkill: gpio: fix memory leak in probe error path

Johannes Berg (1):
      cfg80211: limit wiphy names to 128 bytes

Randy Dunlap (1):
      mac80211: fix kernel-doc "bad line" warning

Sara Sharon (1):
      mac80211: use timeout from the AddBA response instead of the request

Srinivas Dasari (1):
      nl80211: Free connkeys on external authentication failure

YueHaibing (1):
      mac80211_hwsim: fix a possible memory leak in hwsim_new_radio_nl()

weiyongjun (A) (1):
      cfg80211: fix possible memory leak in regdb_query_country()

 drivers/net/wireless/mac80211_hwsim.c |  1 +
 include/net/mac80211.h                |  2 +-
 include/uapi/linux/nl80211.h          |  2 ++
 net/mac80211/agg-tx.c                 |  4 ++++
 net/mac80211/mlme.c                   | 27 +++++++++++++++++++--------
 net/mac80211/tx.c                     |  3 ++-
 net/rfkill/rfkill-gpio.c              |  7 ++++++-
 net/wireless/core.c                   |  3 +++
 net/wireless/nl80211.c                |  1 +
 net/wireless/reg.c                    |  1 +
 10 files changed, 40 insertions(+), 11 deletions(-)
