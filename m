Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:29273 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbbHOTkL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Aug 2015 15:40:11 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 0/9] various patches from our internal tree
Date: Sat, 15 Aug 2015 22:39:45 +0300
Message-Id: <1439667594-13632-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150815_214019_913078_F819CA38)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Just came back from my vacation as well.
Here are a few patches we have on our internal tree.
I started to send the patch from Andrei (on HW scan vs.
the iface work) and ended up with a quite a few, so
here they are.
You've seen all of them internally already.

For those out there who would like to see what we
have in our internal tree, I've started to push it
on a weekly basis to korg:

https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/backport-iwlwifi.git/

Note that patches can be rebased, squashed etc... before
they are sent to the ML.

Andrei Otcheretianski (1):
  mac80211: Introduce per vif frame registration API

Arik Nemtsov (4):
  mac80211: debugfs: add file to disallow TDLS wider-bw
  mac80211: TDLS: add proper HT-oper IE
  mac80211: TDLS: check reg with IR-relax on chandef upgrade
  mac80211: avoid VHT usage with no 80MHz chans allowed

Emmanuel Grumbach (2):
  mac80211: allow the driver to advertise A-MSDU within A-MPDU Rx
    support
  mac80211: allow to transmit A-MSDU within A-MPDU

Johannes Berg (2):
  nl80211: support vendor dumpit commands
  mac80211: remove direct probe step before authentication

 drivers/net/wireless/iwlwifi/dvm/mac80211.c |   2 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |   2 +-
 drivers/net/wireless/mac80211_hwsim.c       |   2 +-
 include/linux/ieee80211.h                   |   1 +
 include/net/cfg80211.h                      |   9 ++
 include/net/mac80211.h                      |  28 +++-
 net/mac80211/agg-rx.c                       |   8 +-
 net/mac80211/agg-tx.c                       |  15 ++-
 net/mac80211/cfg.c                          |  23 +++-
 net/mac80211/debugfs.c                      |   1 +
 net/mac80211/debugfs_netdev.c               |  29 +++++
 net/mac80211/driver-ops.h                   |  23 +++-
 net/mac80211/ibss.c                         |   2 +-
 net/mac80211/ieee80211_i.h                  |   3 +-
 net/mac80211/mesh.c                         |   3 +-
 net/mac80211/mlme.c                         |  98 ++++++--------
 net/mac80211/sta_info.h                     |   2 +
 net/mac80211/tdls.c                         |  21 ++-
 net/mac80211/trace.h                        |  40 +++++-
 net/mac80211/util.c                         |   5 +-
 net/mac80211/vht.c                          |  15 +++
 net/wireless/nl80211.c                      | 192 ++++++++++++++++++++++++++++
 22 files changed, 432 insertions(+), 92 deletions(-)

-- 
2.1.4

