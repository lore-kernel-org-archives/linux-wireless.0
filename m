Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:65370 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932067AbaICMcm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 08:32:42 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 00/10] various mac80211 / cfg80211 patches 
Date: Wed,  3 Sep 2014 15:24:56 +0300
Message-Id: <1409747106-30717-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140903_143247_308737_2268BBC7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

here are a few patches from our internal tree. You have already seen
most of them.

Assaf Krauss (3):
  nl80211: Allow declaring RRM-related features
  nl80211: Add flag attribute for RRM connections
  mac80211: Add RRM support to assoc request

Eliad Peller (3):
  cfg80211: avoid duplicate entries on regdomain intersection
  mac80211: adjust roc duration when combining ROCs
  mac80211: combine roc with the "next roc" if possible

Emmanuel Grumbach (1):
  mac80211: use bss_conf->dtim_period instead of conf.ps_dtim_period

Johannes Berg (2):
  mac80211: add Intel Mobile Communications copyright
  cfg80211: add Intel Mobile Communications copyright

Liad Kaufman (1):
  mac80211: fix description comment of ieee80211_subif_start_xmit

 include/linux/ieee80211.h    |  1 +
 include/net/cfg80211.h       |  3 ++
 include/net/mac80211.h       |  1 +
 include/uapi/linux/nl80211.h | 27 +++++++++++++++
 net/mac80211/cfg.c           | 77 ++++++++++++++++++++++++++++-------------
 net/mac80211/debugfs.c       |  1 +
 net/mac80211/debugfs_sta.c   |  1 +
 net/mac80211/ibss.c          |  1 +
 net/mac80211/ieee80211_i.h   |  2 ++
 net/mac80211/iface.c         |  1 +
 net/mac80211/key.c           |  1 +
 net/mac80211/main.c          |  1 +
 net/mac80211/mlme.c          | 16 +++++++--
 net/mac80211/rx.c            |  1 +
 net/mac80211/scan.c          |  1 +
 net/mac80211/sta_info.c      |  3 +-
 net/mac80211/sta_info.h      |  1 +
 net/mac80211/status.c        |  1 +
 net/mac80211/tdls.c          |  1 +
 net/mac80211/tx.c            |  6 ++--
 net/mac80211/util.c          |  1 +
 net/mac80211/wme.c           |  1 +
 net/wireless/chan.c          |  1 +
 net/wireless/core.c          |  1 +
 net/wireless/nl80211.c       | 18 ++++++++++
 net/wireless/reg.c           | 82 ++++++++++++++++++++++++++++++++------------
 net/wireless/scan.c          |  1 +
 net/wireless/util.c          |  1 +
 28 files changed, 202 insertions(+), 51 deletions(-)

-- 
1.9.1

