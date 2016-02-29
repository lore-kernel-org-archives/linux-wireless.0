Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:41124 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbcB2NZV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 08:25:21 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, QH <qiumin.hu@gmail.com>,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Etan Cohen <etancohen@google.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 00/12] Add support for Neighbor Awareness Networking
Date: Mon, 29 Feb 2016 15:25:01 +0200
Message-Id: <1456752313-5792-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160229_142524_779503_7FBA1DB7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[Resending with the ML in CC this time]

These patches were partly posted a few times as RFC.
They are now ready for a PATCH version.
NAN was described in the original post:
http://comments.gmane.org/gmane.linux.kernel.wireless.general/142109

Since then we changed a few things:
 * NL80211_CMD_ADD_NAN_FUNCTION now returns a cookie to the user space
 * and the user space passes the cookie instead of the instance id.
   This helps solving a few race conditions with the user space.
 * Any NAN related notification is sent to a Mutlicast Group
   (NL80211_MCGRP_NAN) unless NL80211_ATTR_SOCKET_OWNER was set
   upon creation of the interface. Adding
   NL80211_ATTR_SOCKET_OWNER during the creation of the socket
   allows the user space to prevent any other nl80211 socket
   to create functions, and instructs the kernel to send the
   NAN related notifications in unicast to socket that created
   the NAN interface.

The last patch is intended to show of iwlwifi intends to use the
new API and should not be applied on mac80211-next.

Andrei Otcheretianski (6):
  cfg80211: Provide an API to report NAN function termination
  cfg80211: add utility functions to clone and free nan_func
  mac80211: implement nan_change_conf
  mac80211: Implement add_nan_func and rm_nan_func
  mac80211: Add API to report nan function match
  iwlwifi: mvm: Add support for NAN interface type

Emmanuel Grumbach (6):
  cfg80211: add start / stop NAN commands
  mac80211: add boilerplate code for start / stop NAN
  cfg80211: add add_nan_func / rm_nan_func
  cfg80211: allow the user space to change current NAN configuration
  cfg80211: provide a function to report a match for NAN
  cfg80211: allow to tie the NAN instance to the owner

 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h   |   4 +
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |  22 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  80 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/power.c     |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/quota.c     |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/sf.c        |   6 +-
 include/net/cfg80211.h                             | 193 ++++++-
 include/net/mac80211.h                             |  60 +++
 include/uapi/linux/nl80211.h                       | 268 +++++++++-
 net/mac80211/cfg.c                                 | 245 +++++++++
 net/mac80211/chan.c                                |   6 +
 net/mac80211/driver-ops.h                          |  82 ++-
 net/mac80211/ieee80211_i.h                         |  25 +
 net/mac80211/iface.c                               |  29 +-
 net/mac80211/main.c                                |   8 +
 net/mac80211/offchannel.c                          |   4 +-
 net/mac80211/rx.c                                  |   3 +
 net/mac80211/trace.h                               | 134 +++++
 net/mac80211/util.c                                |  57 +-
 net/wireless/chan.c                                |   2 +
 net/wireless/core.c                                |  35 ++
 net/wireless/core.h                                |   3 +
 net/wireless/mlme.c                                |   1 +
 net/wireless/nl80211.c                             | 580 ++++++++++++++++++++-
 net/wireless/rdev-ops.h                            |  58 +++
 net/wireless/trace.h                               |  91 ++++
 net/wireless/util.c                                | 118 ++++-
 28 files changed, 2100 insertions(+), 22 deletions(-)

-- 
2.5.0

