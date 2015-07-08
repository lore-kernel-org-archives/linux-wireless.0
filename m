Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:7747 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932306AbbGHMmA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2015 08:42:00 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 00/10] random patches to mac80211
Date: Wed,  8 Jul 2015 15:41:42 +0300
Message-Id: <1436359312-26533-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150708_144205_168888_BF5734C3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Here are the patches that we had on our internal tree.
There are other patches that have been sent the ML already
and that I couldn't find in mac80211-next.

Arik Nemtsov (3):
  cfg80211: use RTNL locked reg_can_beacon for IR-relaxation
  mac80211: TDLS: handle chan-switch in RTNL locked work
  mac80211: TDLS: deny ch-switch req on disallowed channels

Avri Altman (1):
  mac80211: enable changing netdev features with ethtool

Eliad Peller (1):
  mac80211: clear local->suspended before calling drv_resume()

Gregory Greenman (1):
  mac80211: add possibility to advertise 802.11 FTM support

Johannes Berg (3):
  mac80211: remove ieee80211_aes_cmac_calculate_k1_k2()
  mac80211: shut down interfaces before destroying interface list
  mac80211: allow drivers to set netdev hw_features

Sara Sharon (1):
  mac80211: Add support for declaring MU-MIMO capability

 include/linux/ieee80211.h  |  6 ++++
 include/net/cfg80211.h     | 17 +++++++++
 include/net/mac80211.h     | 29 +++++++--------
 net/mac80211/aes_cmac.c    | 17 ---------
 net/mac80211/debugfs.c     |  1 +
 net/mac80211/driver-ops.h  | 22 ++++++++++++
 net/mac80211/ieee80211_i.h | 18 +++++++---
 net/mac80211/iface.c       | 69 +++++++++++++++++++++++++++--------
 net/mac80211/main.c        | 16 ++++++---
 net/mac80211/mlme.c        | 37 ++++++++++++++++++-
 net/mac80211/rx.c          |  5 ++-
 net/mac80211/tdls.c        | 89 ++++++++++++++++++++++++++++++++++------------
 net/mac80211/trace.h       | 28 +++++++++++++++
 net/mac80211/util.c        | 18 +++++++---
 net/wireless/chan.c        | 45 +++++++++++++++++------
 net/wireless/nl80211.c     | 14 ++++----
 net/wireless/reg.c         |  2 +-
 net/wireless/trace.h       | 11 +++---
 18 files changed, 337 insertions(+), 107 deletions(-)

-- 
2.1.4

