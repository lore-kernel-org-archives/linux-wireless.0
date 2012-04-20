Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59134 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182Ab2DTWyC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2012 18:54:02 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v3 0/4] Add ethtool stats support for Wireless Devices
Date: Fri, 20 Apr 2012 15:53:49 -0700
Message-Id: <1334962432-18620-1-git-send-email-greearb@candelatech.com> (sfid-20120421_005407_418020_BFBE5639)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This enables ethtool stats for mac80211 devices.  It also
adds hooks to call down into mac80211 drivers for additional
stats.  Patches to enable this hook in ath9k will be posted
in a different series.

V3:  Do a direct-lookup of the sta_info object if in MANAGED mode.
     Iterate through all survey results until we find the matching
      frequency.
     Roll the small sta-state patch into patch 4. 

Ben Greear (4):
  cfg80211: Add framework to support ethtool stats.
  mac80211: Support getting sta_info stats via ethtool.
  mac80211: Framework to get wifi-driver stats via ethtool.
  mac80211: Add more ethtools stats: survey, rates, etc

 include/net/cfg80211.h      |   17 ++++
 include/net/mac80211.h      |   17 ++++
 net/mac80211/cfg.c          |  179 +++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/driver-ops.h   |   37 +++++++++
 net/mac80211/driver-trace.h |   15 ++++
 net/wireless/ethtool.c      |   29 +++++++
 6 files changed, 294 insertions(+), 0 deletions(-)

-- 
1.7.3.4

