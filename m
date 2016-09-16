Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:55040 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752629AbcIPIdc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Sep 2016 04:33:32 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 16 Sep 2016 11:33:12 +0300
Message-Id: <20160916083321.5840-1-luca@coelho.fi> (sfid-20160916_103347_863143_DC16B5F9)
Subject: [PATCH v2 0/9] Add support for Neighbor Awareness Networking
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

This is v2 of the NAN patches that Emmanuel sent a while back[1].  In
this version, we squashed some patches and took care of some comments
after reviews (both internal and public).

NAN was described in the original post[2].

I hope they're good for merging now, because I'm tired of carrying
this changes forward in our internal trees. :P

Nevertheless, comments are welcome, as always.

[1] http://mid.gmane.org/1456752313-5792-1-git-send-email-emmanuel.grumbach@intel.com
[2] http://mid.gmane.org/1442500351-8780-1-git-send-email-andrei.otcheretianski@intel.com

Cheers,
Luca.


Ayala Beker (9):
  cfg80211: add start / stop NAN commands
  mac80211: add boilerplate code for start / stop NAN
  cfg80211: add add_nan_func / rm_nan_func
  cfg80211: allow the user space to change current NAN configuration
  cfg80211: provide a function to report a match for NAN
  cfg80211: Provide an API to report NAN function termination
  mac80211: implement nan_change_conf
  mac80211: Implement add_nan_func and rm_nan_func
  mac80211: Add API to report NAN function match

 include/net/cfg80211.h       | 184 ++++++++++++-
 include/net/mac80211.h       |  65 +++++
 include/uapi/linux/nl80211.h | 258 +++++++++++++++++
 net/mac80211/cfg.c           | 208 ++++++++++++++
 net/mac80211/chan.c          |   6 +
 net/mac80211/driver-ops.h    |  82 +++++-
 net/mac80211/ieee80211_i.h   |  17 ++
 net/mac80211/iface.c         |  28 +-
 net/mac80211/main.c          |   8 +
 net/mac80211/offchannel.c    |   4 +-
 net/mac80211/rx.c            |   3 +
 net/mac80211/trace.h         | 133 +++++++++
 net/mac80211/util.c          |  50 +++-
 net/wireless/chan.c          |   2 +
 net/wireless/core.c          |  35 +++
 net/wireless/core.h          |   3 +
 net/wireless/mlme.c          |   1 +
 net/wireless/nl80211.c       | 642 ++++++++++++++++++++++++++++++++++++++++++-
 net/wireless/rdev-ops.h      |  58 ++++
 net/wireless/trace.h         |  90 ++++++
 net/wireless/util.c          |  28 +-
 21 files changed, 1894 insertions(+), 11 deletions(-)

-- 
2.9.3
