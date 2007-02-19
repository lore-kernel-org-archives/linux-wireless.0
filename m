Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:54726 "EHLO silver.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932575AbXBSWjQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 17:39:16 -0500
From: Jiri Benc <jbenc@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
Message-Id: <20070219233919.221549000.midnight@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/12] d80211: pull request
Date: Mon, 19 Feb 2007 23:39:45 +0100 (CET)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I merged John's current wireless-dev (the master branch) into my tree,
resolved conflicts, fixed resulting compilation breakage and applied Pavel's
fix.

John, please pull from
git://git.kernel.org/pub/scm/linux/kernel/git/jbenc/dscape.git up
to obtain following patches:

Ivo van Doorn:
      d80211: Fix skb panic during passive scan

Jiri Benc:
      Merge git://git.kernel.org/.../linville/wireless-dev into devel
      d80211: more wiphy API fixes

Johannes Berg:
      d80211: remove IEEE80211_HW_FRAGLIST flag

Michael Wu:
      d80211: fix authentication issues
      d80211: trivial cleanups in ieee80211_i.h
      d80211: remove hosttime from ieee80211_rx_status
      d80211: Fix concurrency issues in ieee80211_sta.c
      d80211: Simplify channel & mode configuration
      d80211: Make common function for frequency/channel selection
      d80211: Support automatic channel/BSSID/SSID configuration
      d80211: Fix wireless statistics reporting

Pavel Roskin:
      d80211: fix incorrect hw.priv setting in ieee80211_alloc_hw()

 include/net/d80211.h         |   14 +
 net/d80211/ieee80211.c       |  102 +++++-----
 net/d80211/ieee80211_cfg.c   |    2 
 net/d80211/ieee80211_i.h     |   32 ++-
 net/d80211/ieee80211_iface.c |    7 +
 net/d80211/ieee80211_ioctl.c |  144 ++++++++------
 net/d80211/ieee80211_scan.c  |    5 
 net/d80211/ieee80211_sta.c   |  442 ++++++++++++++++++++++++++----------------
 8 files changed, 452 insertions(+), 296 deletions(-)


-- 
Jiri Benc
SUSE Labs
