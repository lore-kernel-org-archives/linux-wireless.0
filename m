Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:49636 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbbCAHK0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 02:10:26 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 00/16] Various patches from our internal tree
Date: Sun,  1 Mar 2015 09:09:59 +0200
Message-Id: <1425193815-17785-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_081039_043620_9FFEE1BF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Here is a sync from out internal tree. This includes a few
patches from you as well.
This is currently based on mac80211.git, but it applies on
mac80211-next.git as well.

Alexander Bondar (1):
  mac80211: Update beacon's timing and DTIM count on every beacon

Arik Nemtsov (4):
  mac80211: TDLS: support VHT between peers
  mac80211: allow TDLS setup code to take wdev lock
  mac80211: update TDLS sta spatial streams before auth
  mac80211: allow iterating inactive interfaces

Avri Altman (1):
  mac80211: tell drivers the user TX power restriction

Eliad Peller (1):
  cfg80211: add operating classes 128-130

Johannes Berg (5):
  mac80211: fix another suspend vs. association race
  mac80211: don't do driver suspend with auth/assoc in progress
  mac80211: start queues if driver rejected wowlan
  mac80211: check and dequeue skb in ieee80211_tx_prepare_skb()
  nl80211: prohibit mixing 'any' and regular wowlan triggers

Luciano Coelho (4):
  mac80211: handle drv_add_interface failures properly during reconfig
  mac80211: remove useless double check for open_count in
    __ieee80211_suspend()
  mac80211: remove duplicate check for quiescing when queueing work
  mac80211: remove channel_switch_beacon operation

 include/net/mac80211.h        |  77 ++++++++++++++++++-------
 include/uapi/linux/nl80211.h  |   2 +
 net/mac80211/cfg.c            |  49 ++++++++++++----
 net/mac80211/chan.c           |   4 +-
 net/mac80211/debugfs_netdev.c |   2 +-
 net/mac80211/driver-ops.h     |  13 -----
 net/mac80211/ieee80211_i.h    |   6 +-
 net/mac80211/iface.c          |  12 ++--
 net/mac80211/mlme.c           |  70 +++++++++++++++--------
 net/mac80211/pm.c             |  28 +++++++++-
 net/mac80211/tdls.c           | 127 ++++++++++++++++++++++++++++++++++--------
 net/mac80211/trace.h          |  25 ---------
 net/mac80211/tx.c             |   9 +++
 net/mac80211/util.c           |  83 ++++++++++++++++++++++-----
 net/mac80211/vht.c            |   4 --
 net/wireless/nl80211.c        |  22 ++++++++
 net/wireless/util.c           |   1 +
 17 files changed, 388 insertions(+), 146 deletions(-)

-- 
1.9.1

