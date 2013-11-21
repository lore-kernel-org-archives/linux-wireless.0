Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:55926 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3KUP41 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Nov 2013 10:56:27 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/4] Fix CSA locking issues
Date: Thu, 21 Nov 2013 16:56:19 +0100
Message-Id: <1385049383-5617-1-git-send-email-sw@simonwunderlich.de> (sfid-20131121_165630_822403_1311E116)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Unfortunately my channel switch announcement patches contained locking issues
which I didn't notice during my test due to bad configuration. Johannes pointed
them out, so here is my attempt to fix them. This series attempts to fix two
issues:

 * There are "suspicious rcu_dereference_protected() usage" problems for
   ieee80211_assign_beacon and ieee80211_ibss_csa_beacon because the respective
   locking was missing
 * There is a circular dependency between the wdev/sdata-lock and the
   csa_finalize worker lock (see description in patch 3).

These patches contain changes for issues in the RFC series pointed out by
Johannes. I've also found another possible leak so I added this to the series.
Patches are based on mac80211-next.

Cheers,
   Simon

Simon Wunderlich (4):
  cfg80211/mac80211: modify beacon using sdata/wdev-lock, not rtnl lock
  cfg80211/mac80211/ath6kl: acquire wdev lock outside ch_switch_notify
  mac80211: don't cancel csa finalize work within stop_ap
  mac80211: don't leak next beacon when csa is aborted

 drivers/net/wireless/ath/ath6kl/cfg80211.c |    2 ++
 include/net/cfg80211.h                     |    3 +-
 net/mac80211/cfg.c                         |   47 +++++++++++++++++++---------
 net/mac80211/ieee80211_i.h                 |    3 ++
 net/mac80211/iface.c                       |    7 ++++-
 net/wireless/nl80211.c                     |   31 ++++++++++++------
 6 files changed, 67 insertions(+), 26 deletions(-)

-- 
1.7.10.4

