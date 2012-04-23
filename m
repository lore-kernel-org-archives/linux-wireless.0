Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53501 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab2DWTun (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 15:50:43 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v4 0/4] Add ethtool stats support for Wireless Devices
Date: Mon, 23 Apr 2012 12:50:28 -0700
Message-Id: <1335210632-19958-1-git-send-email-greearb@candelatech.com> (sfid-20120423_215046_377292_3222143D)
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

v4:  Leave a few STA stats zero unless we are in managed mode.

Ben Greear (4):
  cfg80211: Add framework to support ethtool stats.
  mac80211: Support getting sta_info stats via ethtool.
  mac80211: Framework to get wifi-driver stats via ethtool.
  mac80211: Add more ethtools stats: survey, rates, etc

 include/net/cfg80211.h      |   17 ++++
 include/net/mac80211.h      |   17 ++++
 net/mac80211/cfg.c          |  177 +++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/driver-ops.h   |   37 +++++++++
 net/mac80211/driver-trace.h |   15 ++++
 net/wireless/ethtool.c      |   29 +++++++
 6 files changed, 292 insertions(+), 0 deletions(-)

-- 
1.7.3.4

