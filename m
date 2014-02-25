Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:50192 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaBYMju (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 07:39:50 -0500
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, bzhao@marvell.com, arend@broadcom.com
Subject: [PATCH v5 0/4] cfg80211/mac80211: move interface combinations check to mac80211
Date: Tue, 25 Feb 2014 14:39:40 +0200
Message-Id: <1393331984-21692-1-git-send-email-luca@coelho.fi> (sfid-20140225_133953_402657_71D7B61F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Hi,

In v5:

   * use local and sdata in ibss when calling
     ieee80211_check_combinations();
   * use the radar detection widths from all existing contexts,
     regardless of whether we can share an existing context or if the
     context is exclusive (thanks Michal!);

In v4:

   * rebased the remaining patches on top of what Johannes applied;
   * lots of other small changes in response to Johannes's comments.
     See each individual patch for detailed lists of changed (thanks
     Johannes!);

In v3:

   * move the "pass the mode argument..." change to the right patch;

In v2:

   * lock the chanctx mutex in ieee80211_ibss_join() before calling
     ieee80211_check_combinations().

   * pass the mode argument instead of IEEE80211_CHANCTX_SHARED to
     ieee80211_check_combinations() in ieee80211_vif_use_channel();

As Johannes suggested earlier, this patchset moves the interface
combinations check from cfg80211 to mac80211.  This is needed to
simplify the channel switch code.

There are still some cases where cfg80211 may need to check the
interface combinations (ie. when adding or changing an interface), so
I created a helper function that can be called by cfg80211 itself or
the drivers (such as mac80211).

Also, for now, I only moved the check in the cases where
ieee80211_vif_use_channel() is called and for IBSS join.  The channel
switch stuff, which will be trickier, is still missing.  These will be
handled separately and it doesn't really hurt to leave it as it is,
except because it's a bit inconsistent.

I had to shuffle some code around to make this whole thing a bit
cleaner, including the check for whether radar detection is needed.

This is not very thoroughly tested yet, I have just done some checks
with AP and STA with and without chanctx and with 1 or 2 different
channels.  This part seems to work, please test the rest. :)

I'll try to add some hwsim tests to test this more thoroughly.

Luca.

Luciano Coelho (4):
  cfg80211: refactor cfg80211_can_use_iftype_chan()
  cfg80211/mac80211: refactor cfg80211_chandef_dfs_required()
  cfg80211/mac80211: move interface counting for combination check to
    mac80211
  cfg80211/mac80211: move combination check to mac80211 for ibss

 Documentation/DocBook/80211.tmpl |   1 +
 include/net/cfg80211.h           |  41 +++++++++++--
 net/mac80211/cfg.c               |   2 -
 net/mac80211/chan.c              |  17 ++++++
 net/mac80211/ibss.c              |  60 +++++++++++++------
 net/mac80211/ieee80211_i.h       |   5 ++
 net/mac80211/mesh.c              |   9 +--
 net/mac80211/util.c              |  76 +++++++++++++++++++++++
 net/wireless/chan.c              |  77 +++++++++++++++++-------
 net/wireless/core.h              |  13 +---
 net/wireless/ibss.c              |  24 --------
 net/wireless/mesh.c              |  25 --------
 net/wireless/mlme.c              |  14 +----
 net/wireless/nl80211.c           |  53 ++++------------
 net/wireless/util.c              | 126 ++++++++++++++++++++++-----------------
 15 files changed, 328 insertions(+), 215 deletions(-)

-- 
1.8.5.3

