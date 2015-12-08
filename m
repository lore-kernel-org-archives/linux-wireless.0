Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23006 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964890AbbLHOGU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2015 09:06:20 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 0/9] various mac80211 / cfg80211 patches
Date: Tue,  8 Dec 2015 16:04:30 +0200
Message-Id: <1449583479-26658-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151208_150632_955525_34C3F4DE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

This is a mix of a few random things. A few of things seem
to deserved to be merge in mac80211.git, but all this is
based on mac80211-next.git.

Emmanuel Grumbach (1):
  mac80211: limit the A-MSDU Tx based on peer's capabilities

Eyal Shapira (1):
  mac80211: handle width changes from opmode notification IE in beacon

Johannes Berg (4):
  mac80211: document status.freq restrictions
  mac80211: suppress unchanged "limiting TX power" messages
  mac80211: run scan completed work on reconfig failure
  mac80211: reprogram in interface order

Sara Sharon (3):
  mac80211: process and save VHT MU-MIMO group frame
  mac80211: add flag for duplication check
  mac80211: pass aggregation window size to lower level

 include/linux/ieee80211.h  |  26 ++++++++++
 include/net/mac80211.h     |  43 +++++++++++++++--
 net/mac80211/agg-rx.c      |   2 +-
 net/mac80211/cfg.c         |  32 ++++++++++++-
 net/mac80211/ht.c          |   5 ++
 net/mac80211/ieee80211_i.h |   6 ++-
 net/mac80211/iface.c       |  10 ++++
 net/mac80211/mlme.c        |  24 +++++++---
 net/mac80211/rx.c          |  11 ++++-
 net/mac80211/util.c        | 116 ++++++++++++++++++++++++++-------------------
 net/mac80211/vht.c         |  53 ++++++++++++++++++---
 11 files changed, 254 insertions(+), 74 deletions(-)

-- 
2.5.0

