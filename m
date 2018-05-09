Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:51352 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965426AbeEITkm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 15:40:42 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2018-05-09
Date: Wed,  9 May 2018 21:40:33 +0200
Message-Id: <20180509194034.11992-1-johannes@sipsolutions.net> (sfid-20180509_214049_113840_06178292)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

Nothing major here either. I'm still waiting for the HE/802.11ax
stuff, but even when we do get that it'll just add rates and not
be very exciting at this point :-)

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 415787d7799f4fccbe8d49cb0b8e5811be6b0389:

  ipv6: frags: fix a lockdep false positive (2018-04-18 23:19:39 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-davem-2018-05-09

for you to fetch changes up to 57c6cb81717f957fb741f2e4c79bd0e2f4f55910:

  mac80211: ethtool: avoid 32 bit multiplication overflow (2018-05-08 15:02:03 +0200)

----------------------------------------------------------------
While we're still waiting for HE/802.11ax code, we just
have a few things:
 * some new statistics (ACK RSSI, TXQ)
 * TXQ configuration
 * infrastructure to handle CSA in firmware
 * and some various cleanups/improvements

----------------------------------------------------------------
Amar Singhal (1):
      cfg80211: Call reg_notifier for self managed hints conditionally

Balaji Pothunoori (2):
      cfg80211: average ack rssi support for data frames
      mac80211: average ack rssi support for data frames

Bjoern Johansson (1):
      mac80211_hwsim: indicate support for powersave.

Colin Ian King (1):
      mac80211: ethtool: avoid 32 bit multiplication overflow

Gregory Greenman (1):
      mac80211: add api to set CSA counter in mac80211

Haim Dreyfuss (1):
      nl80211: Add wmm rule attribute to NL80211_CMD_GET_WIPHY dump command

Johannes Berg (4):
      mac80211: rename rtap_vendor_space to rtap_space
      mac80211: clean up rate info bandwidth setting
      mac80211: ethtool: memset the whole sinfo struct to 0
      mac80211: remove pointless flags=0 assignment

Toke Høiland-Jørgensen (3):
      regulatory: Rename confusing 'country IE' in log output
      cfg80211: Expose TXQ stats and parameters to userspace
      mac80211: Support the new cfg80211 TXQ stats API

 drivers/net/wireless/mac80211_hwsim.c |   1 +
 include/net/cfg80211.h                |  53 +++++++
 include/net/mac80211.h                |  13 ++
 include/uapi/linux/nl80211.h          |  93 ++++++++++++
 net/mac80211/cfg.c                    |  99 +++++++++++++
 net/mac80211/ethtool.c                |  37 +++--
 net/mac80211/ieee80211_i.h            |   3 +
 net/mac80211/main.c                   |   3 +
 net/mac80211/rx.c                     |  40 +++---
 net/mac80211/sta_info.c               |  24 +++-
 net/mac80211/sta_info.h               |   2 +
 net/mac80211/status.c                 |   2 +
 net/mac80211/tx.c                     |  45 ++++++
 net/mac80211/util.c                   |   6 +-
 net/wireless/nl80211.c                | 262 ++++++++++++++++++++++++++++++----
 net/wireless/rdev-ops.h               |  12 ++
 net/wireless/reg.c                    |  37 ++++-
 net/wireless/trace.h                  |  14 ++
 net/wireless/wext-compat.c            |  23 +--
 19 files changed, 683 insertions(+), 86 deletions(-)
