Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:52858 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbaCKORm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 10:17:42 -0400
From: Luciano Coelho <luciano.coelho@intel.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, andrei.otcheretianski@intel.com,
	eliad@wizery.com
Subject: [PATCH v10 0/5] cfg80211/mac80211: move interface combinations check to mac80211
Date: Tue, 11 Mar 2014 16:16:29 +0200
Message-Id: <1394547394-3910-1-git-send-email-luciano.coelho@intel.com> (sfid-20140311_151749_429543_479DF0D0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The history is getting too big, so drop it... *sigh*

Adressed some comment by Eliad (thanks!)

In v10:

   * ignore software iftypes when checking used_iftypes;
   * ignore NL80211_IFTYPE_UNSPECIFIED instead of WARNing in
     cfg80211_dfs_required();

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
 net/wireless/util.c              | 139 ++++++++++++++++++++++-----------------
 17 files changed, 344 insertions(+), 250 deletions(-)

-- 
1.9.0

