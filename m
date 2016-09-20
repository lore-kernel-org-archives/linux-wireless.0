Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56478 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754777AbcITObd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Sep 2016 10:31:33 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ayala.beker@intel.com,
        andrei.otcheretianski@intel.com, arend.vanspriel@broadcom.com,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 20 Sep 2016 17:31:12 +0300
Message-Id: <20160920143121.28247-1-luca@coelho.fi> (sfid-20160920_163137_556797_36C78289)
Subject: [PATCH v3 0/9] Add support for Neighbor Awareness Networking
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Now v3 of the NAN patchset.  Ayala has taken care of the kbuild bot
compilation errors and of all Arend's comments, except for the one
about adding a helper function instead checking for P2P_DEVICE and NAN
for non-netdev interfaces.

Comments are welcome, as always.

Cheers,
Luca.


Ayala Beker (9):
  cfg80211: add start / stop NAN commands
  mac80211: add boilerplate code for start / stop NAN
  cfg80211: add add_nan_func / del_nan_func
  cfg80211: allow the user space to change current NAN configuration
  cfg80211: provide a function to report a match for NAN
  cfg80211: Provide an API to report NAN function termination
  mac80211: implement nan_change_conf
  mac80211: Implement add_nan_func and rm_nan_func
  mac80211: Add API to report NAN function match

 include/net/cfg80211.h       | 184 ++++++++++++-
 include/net/mac80211.h       |  65 +++++
 include/uapi/linux/nl80211.h | 253 +++++++++++++++++
 net/mac80211/cfg.c           | 208 ++++++++++++++
 net/mac80211/chan.c          |   6 +
 net/mac80211/driver-ops.h    |  80 ++++++
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
 21 files changed, 1888 insertions(+), 10 deletions(-)

-- 
2.9.3
