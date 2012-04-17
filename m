Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50494 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab2DQRq5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 13:46:57 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 0/6] Add ethtool stats support for Wireless Devices 
Date: Tue, 17 Apr 2012 10:46:41 -0700
Message-Id: <1334684807-14026-1-git-send-email-greearb@candelatech.com> (sfid-20120417_194701_243314_85F8C04C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>


This enables ethtool stats for mac80211 devices.  It also
adds hooks to call down into mac80211 drivers for additional
stats.  Patches to enable this hook in ath9k will be posted
in a different series.

There was a review question about how to make the ethtool
strings line up with the data in a less error prone manner.
This patch series does NOT address that.  I think it may
be more work than it's worth to try to do this, but we
can always retro-fit such behaviour later if desired.
Many drivers have this issue, so perhaps some support
code in the ethtool core is the way to go.

V2:  Fix getting survey stats:  Need to specify the
  current channel index, not just use index zero.  The
  fix for this involved adding a new helper method which
  adds a patch to the series.


Ben Greear (6):
  cfg80211: Add framework to support ethtool stats.
  mac80211: Support getting sta_info stats via ethtool.
  mac80211: Framework to get wifi-driver stats via ethtool.
  wireless: Add util method to get channel index from frequency.
  mac80211: Add more ethtools stats: survey, rates, etc
  mac80211: Add sta_state to ethtool stats.

 include/net/cfg80211.h      |   24 ++++++
 include/net/mac80211.h      |   17 ++++
 net/mac80211/cfg.c          |  176 +++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/driver-ops.h   |   37 +++++++++
 net/mac80211/driver-trace.h |   15 ++++
 net/wireless/ethtool.c      |   29 +++++++
 net/wireless/util.c         |   24 ++++++
 7 files changed, 322 insertions(+), 0 deletions(-)

-- 
1.7.3.4

