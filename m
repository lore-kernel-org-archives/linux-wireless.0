Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:55841 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab3KUOfV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Nov 2013 09:35:21 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [RFC 0/3] Fix CSA locking issues
Date: Thu, 21 Nov 2013 15:34:19 +0100
Message-Id: <1385044462-23046-1-git-send-email-sw@simonwunderlich.de> (sfid-20131121_153525_018580_7FCBCD51)
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

The fix is not really trivial and I'm not an expert on the cfg80211/mac80211
locking, so I'd like to request your critical review. Patches are based
on mac80211-next.

Thanks,
   Simon


Simon Wunderlich (3):
  mac80211: modify beacon using sdata/wdev-lock, not rtnl lock
  cfg80211/mac80211/ath6kl: acquire wdev lock outside ch_switch_notify
  mac80211: don't cancel csa finalize work within stop_ap

 drivers/net/wireless/ath/ath6kl/cfg80211.c |    2 +
 include/net/cfg80211.h                     |    3 +-
 net/mac80211/cfg.c                         |  136 ++++++++++++++++++----------
 net/mac80211/ieee80211_i.h                 |    3 +
 net/wireless/nl80211.c                     |    9 +-
 5 files changed, 100 insertions(+), 53 deletions(-)

-- 
1.7.10.4

