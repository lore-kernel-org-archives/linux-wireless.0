Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:34646 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbaBSKAu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 05:00:50 -0500
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, bzhao@marvell.com, arend@broadcom.com
Subject: [PATCH 0/7] cfg80211/mac80211: move interface combinations check to mac80211
Date: Wed, 19 Feb 2014 12:00:38 +0200
Message-Id: <1392804045-11258-1-git-send-email-luca@coelho.fi> (sfid-20140219_110105_259391_ACEBA16C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Hi,

As Johannes suggested earlier, this patchset moves the interface
combinations check from cfg80211 to mac80211.  This is needed to
simplify the channel switch code.

There are still some cases where cfg80211 may need to check the
interface combinations (eg. when adding or changing an interface), so
I created a helper function that can be called by cfg80211 itself or
the drivers (such as mac80211).

Also, for now, I only moved the check in the cases where
ieee80211_vif_use_channel() is called and for IBSS join.  There are
still some trickier cases such as a libertas backward-compatibility
workaround and the channel switch stuff.  These will be handled
separately and it doesn't really hurt to leave it as it is, except
because it's a bit inconsistent.

I had to shuffle some code around to make this whole thing a bit
cleaner, including the check for whether radar detection is needed.

In this series, I have included the two previous patches I sent,
because they're somewhat related to the rest of the series.  For
"cfg80211: remove radar requirements check from
cfg80211_can_use_iftype_chan()" I have removed the excessive comments,
since they become mostly outdated with the rest of the series anyway.

This is not very thoroughly tested yet, I have just done some checks
with AP and STA with and without chanctx and with 1 or 2 different
channels.  This part seems to work, please test the rest. :)

I'll try to add some hwsim tests to test this more thoroughly.

Luca.


Luciano Coelho (7):
  nl80211: make sure we check for DFS with mesh channel switch
  cfg80211: remove radar requirements check from
    cfg80211_can_use_iftype_chan()
  cfg80211: refactor cfg80211_can_use_iftype_chan()
  mac80211: ibss: handle cfg80211_chandef_dfs_required() error codes
  cfg80211/mac80211: refactor cfg80211_chandef_dfs_required()
  cfg80211/mac80211: move interface counting for combination check to
    mac80211
  cfg80211/mac80211: move combination check to mac80211 for ibss

 Documentation/DocBook/80211.tmpl |   1 +
 include/net/cfg80211.h           |  41 +++++++++-
 net/mac80211/cfg.c               |   7 +-
 net/mac80211/chan.c              |  18 +++++
 net/mac80211/ibss.c              |  64 +++++++++++-----
 net/mac80211/ieee80211_i.h       |   5 ++
 net/mac80211/mesh.c              |   9 ++-
 net/mac80211/mlme.c              |  14 ++++
 net/mac80211/util.c              |  88 ++++++++++++++++++++++
 net/wireless/chan.c              |  77 ++++++++++++++-----
 net/wireless/core.h              |   7 ++
 net/wireless/ibss.c              |  25 -------
 net/wireless/mesh.c              |  24 +++---
 net/wireless/mlme.c              |  14 +---
 net/wireless/nl80211.c           |  48 ++++--------
 net/wireless/util.c              | 157 ++++++++++++++++++---------------------
 16 files changed, 379 insertions(+), 220 deletions(-)

-- 
1.8.5.3

