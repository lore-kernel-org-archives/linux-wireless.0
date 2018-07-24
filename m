Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:57694 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388351AbeGXIXH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 04:23:07 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2018-07-24
Date: Tue, 24 Jul 2018 09:16:57 +0200
Message-Id: <20180724071658.9464-1-johannes@sipsolutions.net> (sfid-20180724_091814_663738_7F9291F8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

After a long delay (I'm still on vacation & bonding leave until
mid August and forgot), here are a few fixes for the current
release cycle.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit d0fbad0aec1df29717fab736eb24c8a49cf2c70b:

  Merge branch 'for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/shli/md (2018-07-02 12:40:59 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2018-07-24

for you to fetch changes up to e31f6456c01c76f154e1b25cd54df97809a49edb:

  cfg80211: never ignore user regulatory hint (2018-07-24 09:11:31 +0200)

----------------------------------------------------------------
Only a few fixes:
 * always keep regulatory user hint
 * add missing break statement in station flags parsing
 * fix non-linear SKBs in port-control-over-nl80211
 * reconfigure VLAN stations during HW restart

----------------------------------------------------------------
Amar Singhal (1):
      cfg80211: never ignore user regulatory hint

Bernd Edlinger (1):
      nl80211: Add a missing break in parse_station_flags

Denis Kenzior (1):
      nl80211/mac80211: allow non-linear skb in rx_control_port

mpubbise@codeaurora.org (1):
      mac80211: add stations tied to AP_VLANs during hw reconfig

 include/net/cfg80211.h | 12 ++++++------
 net/mac80211/rx.c      |  5 +----
 net/mac80211/util.c    |  3 ++-
 net/wireless/nl80211.c | 25 ++++++++++++++++---------
 net/wireless/reg.c     | 28 +++-------------------------
 net/wireless/trace.h   | 18 ++++++++++--------
 6 files changed, 38 insertions(+), 53 deletions(-)
