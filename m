Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:49155 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666AbbKQIYo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2015 03:24:44 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 0/8] various mac80211 patches
Date: Tue, 17 Nov 2015 10:24:32 +0200
Message-Id: <1447748680-23075-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151117_092451_269247_2DC41D10)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Here are a few patches we have on our internal tree.
Ilan's has been applied already but somehow wasn't merged.
Since I know you apply patches in the merge window and
rebase them, I am afraid it got lost, so I am resending it
here just as a heads up.

There are bugfixes (Gregory's one, my tx power thing and
Eliad's teardown related patch), along with improvements.
A few improvements are needed for bugfix on the driver side,
but I think they don't deserve to be merged in 4.4. Your call
obviously.

Eliad Peller (2):
  mac80211: add atomic uploaded keys iterator
  mac80211: don't teardown sdata on sdata stop

Emmanuel Grumbach (2):
  mac80211: allow the driver to send EOSP when needed
  mac80211: ensure we don't update tx power on a non-running sdata

Gregory Greenman (1):
  mac80211: always set the buf_size in AddBA req to 64

Ilan Peer (1):
  cfg80211: Add missing tracing to cfg80211

Johannes Berg (2):
  cfg80211: add complete data to station add/change tracing
  mac80211: allow driver to prevent two stations w/ same address

 include/net/mac80211.h  |  58 ++++++++++++++++-
 net/mac80211/agg-tx.c   |   3 +-
 net/mac80211/debugfs.c  |   1 +
 net/mac80211/iface.c    |   5 +-
 net/mac80211/key.c      |  56 +++++++++++++++--
 net/mac80211/sta_info.c | 163 +++++++++++++++++++++++++++++++++++-------------
 net/mac80211/sta_info.h |   2 +
 net/mac80211/trace.h    |  25 ++++++++
 net/wireless/nl80211.c  |   9 ++-
 net/wireless/rdev-ops.h |  43 +++++++++++++
 net/wireless/trace.h    |  99 +++++++++++++++++++++++++++++
 11 files changed, 405 insertions(+), 59 deletions(-)

-- 
2.5.0

