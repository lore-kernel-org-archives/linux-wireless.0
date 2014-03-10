Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:54077 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627AbaCJVb7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2014 17:31:59 -0400
From: Luciano Coelho <luciano.coelho@intel.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, andrei.otcheretianski@intel.com
Subject: [PATCH v9 0/5] cfg80211/mac80211: move interface combinations check to mac80211
Date: Mon, 10 Mar 2014 23:31:38 +0200
Message-Id: <1394487103-13027-1-git-send-email-luciano.coelho@intel.com> (sfid-20140310_223204_347274_508E6E85)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Addressed some offline comments by Johannes,

In v9:

   * pass sdata->wdev.iftype instead of sdata->vif.type when calling
     cfg80211_chandef_dfs_required();
   * fixed commit message in 2/5;
   * added braces in a couple of if's that had comments and a
     statement;
   * move NL80211_IFTYPE_UNSPECIFIED to the WARN part of the switch in
     dfs_required) and remove default;

In v8:

   * fixed rebasing mistakes when setting radar_detect_width in
     patches 3/5 and 4/5;

In v7:

   * added a new patch to get rid of some more combination checks in
     cfg80211 (Johannes);
   * remove local argument from ieee80211_check_combinations();
   * remove redundant arguments from cfg80211_check_combinations();
     (Johannes);
   * change cfg80211_chandef_dfs_required() back to returning only 0
     or 1 instead of the channel width bitmap (Johannes);
   * remove a useless TODO in the cfg80211 doc (Johannes);

In v6:

   * fix typo in the interface counting code
     s/sdata-vif.chanctx_conf/sdata_iter-vif.chanctx_conf/

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


Luciano Coelho (5):
  cfg80211: refactor cfg80211_can_use_iftype_chan()
  cfg80211/mac80211: refactor cfg80211_chandef_dfs_required()
  cfg80211/mac80211: move interface counting for combination check to
    mac80211
  cfg80211/mac80211: move combination check to mac80211 for ibss
  cfg80211/mac80211: move more combination checks to mac80211

 Documentation/DocBook/80211.tmpl |   1 +
 include/net/cfg80211.h           |  31 +++++++--
 net/mac80211/cfg.c               |  11 +++-
 net/mac80211/chan.c              |  17 +++++
 net/mac80211/ibss.c              |  64 ++++++++++++------
 net/mac80211/ieee80211_i.h       |   4 ++
 net/mac80211/iface.c             |   6 +-
 net/mac80211/mesh.c              |   9 +--
 net/mac80211/util.c              |  76 +++++++++++++++++++++
 net/wireless/chan.c              |  74 ++++++++++++++++-----
 net/wireless/core.c              |  11 +---
 net/wireless/core.h              |  29 --------
 net/wireless/ibss.c              |  24 -------
 net/wireless/mesh.c              |  25 -------
 net/wireless/mlme.c              |  14 +---
 net/wireless/nl80211.c           |  59 +++++------------
 net/wireless/util.c              | 138 ++++++++++++++++++++++-----------------
 17 files changed, 343 insertions(+), 250 deletions(-)

-- 
1.9.0

